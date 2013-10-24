package GCStats;

###################################################
#
#  Copyright 2005-2010 Christian Jodar
#
#  This file is part of GCstar.
#
#  GCstar is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  GCstar is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with GCstar; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
#
###################################################
use utf8;
use Gtk2;

use strict;

our $statisticsActivated;
BEGIN {
    $statisticsActivated = 1;
    # Trick for depencies checker. Don't remove these commented lines.
    #eval 'use GD';
    #eval 'use GD::Graph::bars';
    #eval 'use GD::Graph::pie';
    #eval 'use GD::Graph::area';
    #eval 'use GD::Text';
    #eval 'use Date::Calc';
    foreach my $module (qw/GD GD::Graph::bars GD::Graph::pie GD::Graph::area GD::Text Date::Calc/)
    {
        eval "use $module";
        if ($@)
        {
            $statisticsActivated = 0;
            last;
        }
    }
}

{
    package GCStatsImageGenerator;

    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        my $self  = {parent => $parent};
        bless ($self, $class);

        GD::Text->font_path($ENV{GCS_SHARE_DIR}.'/fonts');

        return $self;
    }

    sub setData
    {
        my ($self, $items, $sort, $type, $useNumbers) = @_;
        my %stats;
        foreach my $item(@$items)
        {
            if (ref($item) eq 'ARRAY')
            {
                $stats{$_}++ foreach (@$item);
            }
            else
            {
                $stats{$item}++;
            }
        }
        my (@val1, @val2);
        my @sortedKeys;
        if ($sort)
        {
            @sortedKeys = sort {$stats{$a} <=> $stats{$b}} keys %stats;
        }
        else
        {
            # TODO This sort should be more complicated, depending on the type of field
            @sortedKeys = sort {$a cmp $b} keys %stats;
        }
        my $val;
        foreach my $key(@sortedKeys)
        {
            $val = $key;
            $val .= ' ('.$stats{$key}.')' if $useNumbers;
            push @val1, $val;
            push @val2, $stats{$key};
        }
        $self->{data} = [\@val1, \@val2];
    }

    sub generate
    {
        my ($self, %options) = @_;
        my $graph;
        
        # Plot the graph twice as large as desired, so we can resample it down later, and eliminate
        # the jagged lines caused by GD::Graph's lack of anti-aliasing
        my $scaledWidth = $options{width} * 2;
        my $scaledHeight = $options{height} * 2;   
        my $scaledFontSize = $options{fontSize} * 2;
        
        if ($options{type} eq 'bars')
        {
            $graph = GD::Graph::bars->new($scaledWidth, $scaledHeight);
            $graph->set(
                x_labels_vertical => 1,
            );
            $graph->set_x_label_font('LiberationSans-Regular.ttf', $scaledFontSize);
            $graph->set_y_label_font('LiberationSans-Regular.ttf', $scaledFontSize);
            $graph->set_x_axis_font('LiberationSans-Regular.ttf', $scaledFontSize);
            $graph->set_y_axis_font('LiberationSans-Regular.ttf', $scaledFontSize);
            $graph->set_legend_font('LiberationSans-Regular.ttf', $scaledFontSize);
            $graph->set_values_font('LiberationSans-Regular.ttf', $scaledFontSize);
        }
        elsif ($options{type} eq 'area')
        {
            $graph = GD::Graph::area->new($scaledWidth, $scaledHeight);
            $graph->set(
                x_labels_vertical => 1,
            );
            $graph->set_x_label_font('LiberationSans-Regular.ttf', $scaledFontSize);
            $graph->set_y_label_font('LiberationSans-Regular.ttf', $scaledFontSize);
            $graph->set_x_axis_font('LiberationSans-Regular.ttf', $scaledFontSize);
            $graph->set_y_axis_font('LiberationSans-Regular.ttf', $scaledFontSize);
            $graph->set_legend_font('LiberationSans-Regular.ttf', $scaledFontSize);
            $graph->set_values_font('LiberationSans-Regular.ttf', $scaledFontSize);
        }
        elsif ($options{type} eq 'history')
        {
            $graph = GD::Graph::area->new($scaledWidth, $scaledHeight);
            $graph->set_x_label_font('LiberationSans-Regular.ttf', $scaledFontSize);
            $graph->set_y_label_font('LiberationSans-Regular.ttf', $scaledFontSize);
            $graph->set_x_axis_font('LiberationSans-Regular.ttf', $scaledFontSize);
            $graph->set_y_axis_font('LiberationSans-Regular.ttf', $scaledFontSize);
            $graph->set_legend_font('LiberationSans-Regular.ttf', $scaledFontSize);
            $graph->set_values_font('LiberationSans-Regular.ttf', $scaledFontSize);
            
            # Modify data to accumulate
            if ($options{accumulate})
            {
                my $prev = 0;
                foreach (@{$self->{data}->[1]})
                {
                    $_ += $prev;
                    $prev = $_;
                }
            }
            # Transform dates into numbers of days
            # Reference is the 1st one as they are ordered
            # Or the 2nd one if there are items without value
            my @refDate;
            if ($self->{data}->[0]->[0])
            {
                @refDate = split m|/|, $self->{data}->[0]->[0];
            }
            else
            {
                @refDate = split m|/|, $self->{data}->[0]->[1];
                # We consider items without value as being the day before
                @refDate = Date::Calc::Add_Delta_Days(@refDate, -1);
                $self->{data}->[0]->[0] = sprintf('%d/%02d/%02d', @refDate);
            }
            my $prev = -1;
            my @newDates;
            my $dateFormat = $self->{parent}->{options}->dateFormat;
            foreach my $date(@{$self->{data}->[0]})
            {
                push @newDates, GCUtils::timeToStr(GCPreProcess::restoreDate($date), $dateFormat);
                if (!$date)
                {
                    $prev = 0;
                    next;
                }
                my @cmpDate = split m|/|, $date;
                my $diff = Date::Calc::Delta_Days(@refDate, @cmpDate);
                if ($diff > $prev + 1)
                {
                    my @filler;
                    $#filler = $diff - $prev - 2;
                    if (!$options{accumulate})
                    {
                        @filler = map {''} @filler;
                    }
                    splice (@newDates, $prev + 1, 0, @filler);
                    splice (@{$self->{data}->[1]}, $prev + 1, 0, @filler);
                }
                $prev = $diff;
            }
            $self->{data}->[0] = \@newDates;
            if (!$options{showAllDates})
            {
                for my $idx(0..$#newDates)
                {
                    my @date = Date::Calc::Add_Delta_Days(@refDate, $idx);
                    my $value;
                    if ($date[2] == 1)
                    {
                        my $dateStr = sprintf('%d/%02d/%02d', @date);
                        $value = GCUtils::timeToStr(GCPreProcess::restoreDate($dateStr), $dateFormat);
                    }
                    else
                    {
                        if ($self->{data}->[1]->[$idx])
                        {
                            $value = '';
                        }
                    }
                    $self->{data}->[0]->[$idx] = $value;
                }
            }
            $graph->set(
                #x_label_skip => 5,
                x_labels_vertical => 1,
                show_values => 1,
            );
        }
        else
        {
            $graph = GD::Graph::pie->new($scaledWidth, $scaledHeight);
            $graph->set_value_font('LiberationSans-Regular.ttf', $scaledFontSize);
            $graph->set_label_font('LiberationSans-Regular.ttf', $scaledFontSize);
            $graph->set('3d' => ($options{type} eq '3dpie'));
        }
        $graph->set_title_font('LiberationSans-Regular.ttf', $scaledFontSize);
        $graph->set(
            title       => $options{title},
            show_values => $options{showValues},
            transparent => 0,
            bgclr       => '#ffffff',
            dclrs       => ['#ffdf33', '#1c86ee', '#cdad00', '#6c7b8b', '#ffb618'],
            cycle_clrs  => 1,
            t_margin    => 20,
            b_margin    => 20,
            l_margin    => 20,
            r_margin    => 20,
            text_space  => 20,
        );
      
        my $gd = $graph->plot($self->{data});
        
        # Now, resample the graph down to the desired size, effectively anti-aliasing the sharp edges
        my $aaImage = GD::Image->new($options{width},  $options{height}, 1);
        $aaImage->copyResampled($gd, 0, 0, 0, 0, $options{width}, $options{height}, $scaledWidth, $scaledHeight);

	return $aaImage->png;
    }
}

{
    package GCStatsDialog;
    use base "Gtk2::Dialog";
    
    use GCUtils;
    use GCDialogs;

    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent->{lang}->{MenuStatistics},
                                       $parent,
                                       [qw/destroy-with-parent/],
                                       $parent->{lang}->{StatsGenerate} => 'apply',
                                       'gtk-save-as' => 'ok',
                                       'gtk-close' => 'close'
                                      );
        bless($self, $class);

        $self->{parent} = $parent;
        $self->{generator} = new GCStatsImageGenerator($parent);

        $self->{choices} = [
            {value => 'bars', displayed => $parent->{lang}->{StatsBars}},
            {value => 'pie', displayed => $parent->{lang}->{StatsPie}},
            {value => '3dpie', displayed => $parent->{lang}->{Stats3DPie}},
            {value => 'area', displayed => $parent->{lang}->{StatsArea}},
            {value => 'history', displayed => $parent->{lang}->{StatsHistory}},
        ];
        $self->{typeOption} = new GCMenuList($self->{choices}, 4);
        $self->{typeOption}->setValue('3dpie');
        my $typeLabel = new GCLabel($parent->{lang}->{StatsKindOfGraph});
        $self->{fieldLabel} = new GCLabel($parent->{lang}->{StatsFieldToUse});
        $self->{fieldOption} = new GCFieldSelector(0, undef, 1);
        $self->{dateLabel} = new GCLabel($parent->{lang}->{StatsFieldDate});
        $self->{dateOption} = new GCFieldSelector(0, undef, 1, 0, 0, 'date');
        $self->{sortByNumberOption} = new GCCheckBox($parent->{lang}->{StatsSortByNumber});
        $self->{sortByNumberOption}->setValue(0);
        $self->{accumulateOption} = new GCCheckBox($parent->{lang}->{StatsAccumulate});
        $self->{accumulateOption}->setValue(1);
        $self->{useNumberOption} = new GCCheckBox($parent->{lang}->{StatsDisplayNumber});
        $self->{useNumberOption}->setValue(0);

        my $widthLabel = new GCLabel($parent->{lang}->{StatsWidth});
        $self->{widthOption} = new GCCheckedText('0-9');
        $self->{widthOption}->setValue(600);
        my $heightLabel = new GCLabel($parent->{lang}->{StatsHeight});
        $self->{heightOption} = new GCCheckedText('0-9');
        $self->{heightOption}->setValue(600);
        my $fontLabel = new GCLabel($parent->{lang}->{StatsFontSize});
        $self->{fontOption} = new GCNumeric(12, 1, 100, 1);

        $self->{typeOption}->signal_connect('changed' => sub {
            $self->checkVisible;
        });

        my $table = new Gtk2::Table(3, 11, 0);
        $table->set_row_spacings($GCUtils::margin);
        $table->set_col_spacings($GCUtils::margin);
        $table->set_border_width($GCUtils::halfMargin);

        $table->attach($typeLabel, 0, 1, 0, 1, 'fill', 'fill', 0, 0);
        $table->attach($self->{typeOption}, 1, 2, 0, 1, 'fill', 'fill', 0, 0);
        $table->attach($widthLabel, 3, 4, 0, 1, 'fill', 'fill', 0, 0);
        $table->attach($self->{widthOption}, 4, 5, 0, 1, 'fill', 'fill', 0, 0);
        $table->attach($heightLabel, 6, 7, 0, 1, 'fill', 'fill', 0, 0);
        $table->attach($self->{heightOption}, 7, 8, 0, 1, 'fill', 'fill', 0, 0);
        $table->attach($fontLabel, 9, 10, 0, 1, 'fill', 'fill', 0, 0);
        $table->attach($self->{fontOption}, 10, 11, 0, 1, 'fill', 'fill', 0, 0);
        $table->attach($self->{fieldLabel}, 0, 1, 1, 2, 'fill', 'fill', 0, 0);
        $table->attach($self->{fieldOption}, 1, 2, 1, 2, 'fill', 'fill', 0, 0);
        $table->attach($self->{dateLabel}, 0, 1, 1, 2, 'fill', 'fill', 0, 0);
        $table->attach($self->{dateOption}, 1, 2, 1, 2, 'fill', 'fill', 0, 0);
        $table->attach($self->{sortByNumberOption}, 3, 5, 1, 2, 'fill', 'fill', 0, 0);
        $table->attach($self->{accumulateOption}, 3, 5, 1, 2, 'fill', 'fill', 0, 0);
        $table->attach($self->{useNumberOption}, 6, 8, 1, 2, 'fill', 'fill', 0, 0);
 
        $self->{image} = Gtk2::Image->new;

        $self->vbox->pack_start($self->{image},1,1,0);
        $self->vbox->pack_start($table,0,0,0);

        ($self->action_area->get_children)[1]->set_sensitive(0);

        return $self;
    }

    sub checkVisible
    {
        my $self = shift;
        my $val = $self->{typeOption}->getValue;
        if ($val eq 'history')
        {
            $self->{fieldLabel}->hide;
            $self->{fieldOption}->hide;
            $self->{dateLabel}->show_all;
            $self->{dateOption}->show_all;
            $self->{sortByNumberOption}->hide;
            $self->{accumulateOption}->show_all;
        }
        else
        {
            $self->{fieldLabel}->show_all;
            $self->{fieldOption}->show_all;
            $self->{dateLabel}->hide;
            $self->{dateOption}->hide;
            $self->{sortByNumberOption}->show_all;
            $self->{accumulateOption}->hide;
        }
    }

    sub setData
    {
        my ($self, $model, $data, $title) = @_;
        $self->{model} = $model;
        $self->{data} = $data;
        $self->{title} = $title;
        $self->{fieldOption}->setModel($model);
        $self->{fieldOption}->setValue('genre');
        $self->{dateOption}->setModel($model);
        $self->{dateOption}->setValue('added');
    }

    sub show
    {
        my ($self) = @_;

        #$self->generatePicture;
        $self->SUPER::show();
        $self->show_all;
        $self->checkVisible;
        $self->set_position('center');
        my $response = 'cancel';
        while (!(($response eq 'close') || ($response eq 'delete-event')))
        {
            $response = $self->run;
            $self->generatePicture if $response eq 'apply';
            $self->save if $response eq 'ok';
        }
        $self->hide;
    }

    sub generatePicture
    {
        my $self = shift;

        my $graphType = $self->{typeOption}->getValue;
        my $sortField = ($graphType eq 'history')
                        ? $self->{dateOption}->getValue
                        : $self->{fieldOption}->getValue;
        my $sortByNumber = $self->{sortByNumberOption}->getValue;
        my $accumulate = $self->{accumulateOption}->getValue;
        my $useNumber = ($graphType =~ /pie/) && $self->{useNumberOption}->getValue;
        my $showValues = ($graphType !~ /pie/) && $self->{useNumberOption}->getValue;
        my $width = $self->{widthOption}->getValue;
        my $height = $self->{heightOption}->getValue;
        my $fontSize = $self->{fontOption}->getValue;

        my $type = $self->{parent}->{model}->{fieldsInfo}->{$sortField}->{type};
        my @valuesList;
        if ($type eq 'date')
        {
            @valuesList = map {GCPreProcess::reverseDate($_->{$sortField})} @{$self->{data}};
        }
        else
        {
            @valuesList = map {$self->{parent}->transformValue($_->{$sortField}, $sortField, 1)} @{$self->{data}};
        }
        $self->{generator}->setData(\@valuesList, $sortByNumber, $type, $useNumber);
        #$self->{generator}->setData($self->{data}, $sortField);
        my $png = $self->{generator}->generate(type         => $graphType,
                                               showValues   => $showValues,
                                               accumulate   => $accumulate,
                                               title        => $self->{title},
                                               width        => $width,
                                               height       => $height,
                                               fontSize     => $fontSize,
                                               showAllDates => 0);

        my $loader = Gtk2::Gdk::PixbufLoader->new;
        $loader->write($png);
        $loader->close;
        $self->{pixbuf} = $loader->get_pixbuf;
        $self->{image}->set_from_pixbuf($self->{pixbuf});
        ($self->action_area->get_children)[1]->set_sensitive(1);
    }

    sub save
    {
        my $self = shift;
        my $fileDialog = new GCFileChooserDialog($self->{parent}->{lang}->{StatsSave}, $self, 'save', 1);
        $fileDialog->set_pattern_filter(['PNG (.png)', '*.png']);
        $fileDialog->set_filename($self->{filename});
        my $response = $fileDialog->run;
        if ($response eq 'ok')
        {
            $self->{filename} = $fileDialog->get_filename;
            $self->{pixbuf}->save($self->{filename}, 'png');
        }        
        $fileDialog->destroy;
    }
}

1;
