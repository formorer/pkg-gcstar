package GCBaseWidgets;

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
#use GCBorrowings;
use Encode;


use strict;

our @videoExtensions = ('.aaf','.3gp','.asf','.avi','.flv','.m1v','.m2v','.m4v','.mkv','.mov',
                           '.mp4','.mpeg','.mpg','.mpe','.mxf','.nsv','.ogg','.ogv','.rm','.swf','.wmv',
                           '.iso');
            
our @ebookExtensions = ('.txt','.htm','.html','.azw','.opf','.tr2','.tr3','.aeh','.fb2','.chm',
                           '.pdf','.ps','.djvu','.lit','.pdb','.dnl','.xeb','.ceb','.lbr','.prc',
                           '.mobi','.epub','.lrf','.lrx','.pdg','.doc','.odt','.cbr','.cbz','.djvu');
                           
our @audioExtensions = ('.m3u','.pls','.asx','.wax','.wvx','.b4s','.kpl','.ram','.smil','.iso',
                            '.cue','.bin','.mp3','.ogg','.oga','.flac');

sub createWidget
{
    my ($parent, $info, $comparison) = @_;
    my $widget;
    my $withComparisonLabel = 1;

    if ($info->{type} eq 'short text')
    {
        if ($comparison eq 'range')
        {
            $widget = new GCRange('text', $parent->{lang});
            $widget->setWidth(16);
            $withComparisonLabel = 0;
        }
        else
        {
            $widget = new GCShortText;
        }
    }
    elsif ($info->{type} eq 'number')
    {
        #If we want to have values that are less to the specified one,
        #we use max as default to be sure everything will be returned
        #in that case.
        my $default = $info->{min};
        $default = $info->{max}
        if $comparison =~ /^l/;
        if (exists $info->{min})
        {
            if ($comparison eq 'range')
            {
                $widget = new GCRange('number',
                                      $parent->{lang},
                                      $info->{min},
                                      $info->{max},
                                      $info->{step});
                $widget->setWidth(16);
                $withComparisonLabel = 0;
            }
            else
            {
                $widget = new GCNumeric($default,
                                        $info->{min},
                                        $info->{max},
                                        $info->{step});
            }
        }
        else
        {
            if ($comparison eq 'range')
            {
                $widget = new GCRange('numeric text', $parent->{lang});
                $widget->setWidth(16);
                $withComparisonLabel = 0;
            }
            else
            {
                $widget = new GCCheckedText('0-9.');
            }
        }
    }
    elsif ($info->{type} eq 'checked text')
    {
        $widget = new GCCheckedText($info->{format});
    }
    elsif (($info->{type} eq 'history text')
           || (($info->{type} =~ /list/)
               && ($info->{history} ne 'false')))
    {
        $widget = new GCHistoryText;
    }
    elsif ($info->{type} eq 'options')
    {
        $widget = new GCMenuList;
        $widget->setValues($parent->{model}->getValues($info->{values}), $info->{separator});
    }
    elsif ($info->{type} eq 'yesno')
    {
        $widget = new GCCheckBoxWithIgnore($parent);
        $withComparisonLabel = 0;
    }
    elsif ($info->{type} eq 'date')
    {
    	if ($comparison eq 'range')
        {
            $widget = new GCRange('date', $parent->{lang}, undef, undef, undef, $parent);
            $widget->setWidth(16);
            $withComparisonLabel = 0;
        }
        else
        {
			$widget = new GCDate($parent->{window}, $parent->{lang}, 1,
            	                 $parent->{options}->dateFormat);
        }
    }
    else
    {
        $widget = new GCShortText;
    }
    
    return ($widget, $withComparisonLabel);
}

{
    package GCGraphicComponent;

    use base 'Exporter';
    our @EXPORT = qw($somethingChanged);
    our $somethingChanged = 0;

    sub expand
    {
    }
    
    sub lock
    {
    }

    sub getMainParent
    {
        my $self = shift;
        return if ! $self->{parent};
        my $tmpWidget = $self;
        $tmpWidget = $tmpWidget->{parent} while $tmpWidget && (! $tmpWidget->isa('GCFrame'));
        $self->{mainParent} = $tmpWidget;
    }
    
    sub acceptMarkup
    {
        my $self = shift;
        return 0;
    }

    sub cleanMarkup
    {
        my ($self, $text, $encodeSubset) = @_;
        $text =~ s|<br ?/?>|\n|g;
        if ($encodeSubset)
        {
            # Encode only the characters set_markup has issues with
            $text =~ s|&|&amp;|g;                   
            $text =~ s|<|&lt;|g;       
            $text =~ s|>|&gt;|g;       
        }
        else
        {
            $text = GCUtils::encodeEntities($text)
        }
        return $text;
    }

    sub selectAll
    {
    }

    sub getTagFromSpan
    {
        my ($self, $desc) = @_;
        my @result = (); #('background' => $self->{background});
        my @keyvalues = split / /, $desc;
        foreach (@keyvalues)
        {
            /([^=]*)=(.*)/;
            my $key = $1;
            my $value = $2;
            $value =~ s/('|")//g;
            #"'
            next if $key =~ /=/;
            push @result, ($key, $value);
        }
        return @result;
    }
    
    sub valueToDisplayed
    {
        # 1st parameter is self
        shift;
        # Here we don't change the value;
        return shift;
    }
    
    sub hasChanged
    {
        my $self = shift;

        return $self->{hasChanged};
    }
    
    sub setChanged
    {
        my $self = shift;
        $self->{hasChanged} = 1;
        $somethingChanged = 1;
    }

    sub setWidth
    {
        my ($self, $value) = @_;
    }

    sub setHeight
    {
        my ($self, $height) = @_;
    }

    sub resetChanged
    {
        my $self = shift;
        $self->{hasChanged} = 0;
    }

    sub activateStateTracking
    {
        # We do nothing by default
        # Other widget should connect a signal handler or something similar
        # when the content has been changed
    }
    
    sub getLinkedValue
    {
    }
    sub setLinkedValue
    {
    }

    sub setLinkedComponent
    {
        my ($self, $linked) = @_;
        $self->{linkedComponent} = $linked;
    }
}

{
    package GCPseudoHistoryComponent;
    #
    # This is an abstract package handling a little history
    #
    sub initHistory
    {
        my ($self, $listType) = @_;
        $self->{history} = {};

        # listType contains the type of the original field:
        #   0: No list
        #   >0: Multiple list (number of columns)
        $self->{listType} = $listType;
        
        $self->{history}->{0} = {'' => 1};
        for(my $i = 1; $i < $listType; $i++)
        {
            $self->{history}->{$i} = {'' => 1};
        }
        $self->{listType} = $listType;
    }

    sub addHistory
    {
        my $self = shift;

        my $value = shift;
        my $i;
        if (ref($value) eq 'ARRAY')
        {
            foreach (@$value)
            {
                $i = 0;
                foreach my $item(@$_)
                {
                    $self->{history}->{$i}->{$item} = 1;
                    $i++;
                }
            }
        }
        else
        {
            # The separator used was ; instead of ,
            $value =~ s/;/,/g if $value !~ /,/;
            my @values = split m/,/, $value;
            foreach (@values)
            {
                my @items = split m/;/;
                $i = 0;
                foreach my $item(@items)
                {
                   $self->{history}->{$i}->{$item} = 1;
                   $i++;
                }
            }
        }
    }

    sub setDropDown
    {
    }

    sub getValues
    {
        my $self = shift;
        my @array;
        
        
        if ($self->{listType} < 1)
        {
            @array = sort keys %{$self->{history}->{0}};
        }
        else
        {
            foreach (sort keys %{$self->{history}})
            {
                my @tmpArray = sort keys %{$self->{history}->{$_}};
                push @array, \@tmpArray;
            }
        }
        return \@array;
    }

    sub setValues
    {
        my ($self, $values) = @_;
        if ($self->{listType} == 0)
        {
            $self->{history} = {};
            $self->{history}->{0}->{$_} = 1 foreach (@$values);
        }
        else
        {
            $self->{history} = {};
            for (my $i = 0; $i < $self->{listType}; $i++)
            {
                $self->{history}->{$i}->{$_} = 1 foreach (@{$values->[$i]});
            }
        }
    }
}

{
    package GCLinkedComponent;
    @GCLinkedComponent::ISA = ('GCGraphicComponent');

    sub new
    {
        my ($proto, $linked) = @_;
        my $class = ref($proto) || $proto;
    
        my $self = {linked => $linked};
        bless ($self, $class);
        $linked->setLinkedComponent($self);
        return $self;
    }

    sub setValue
    {
        my $self = shift;
        $self->setChanged;
        return $self->{linked}->setLinkedValue(@_);
    }

    sub getValue
    {
        my $self = shift;
        return $self->{linked}->getLinkedValue(@_);
    }

    sub resetChanged
    {
        my $self = shift;
        $self->{hasChanged} = 0;
        return $self->{linked}->resetChanged(@_);
    }
    
    sub hide
    {
        my $self = shift;
        $self->{linked}->setLinkedActivated(0);
    }

    sub show
    {
        my $self = shift;
        $self->{linked}->setLinkedActivated(1);
    }
}

{
    package GCShortText;

    use Glib::Object::Subclass
                Gtk2::Entry::
    ;
    
    @GCShortText::ISA = ('Gtk2::Entry', 'GCGraphicComponent');
    
    sub new
    {
        my ($proto) = @_;
        my $class = ref($proto) || $proto;
    
        my $self = $class->SUPER::new;

        bless ($self, $class);
        return $self;
    }

    sub activateStateTracking
    {
        my $self = shift;
        return if $self->{readOnly};
        $self->signal_connect('changed' => sub {;
            $self->setChanged;
        });
    }
    
    sub isEmpty
    {
        my $self = shift;
        
        return $self->getValue eq '';
    }
    
    sub selectAll
    {
        my $self = shift;
        $self->select_region(0, length($self->getValue));
        $self->grab_focus;
    }
    
    sub getValue
    {
        my $self = shift;
        return $self->get_text;
    }
    
    sub setValue
    {
        my ($self, $value) = @_;
        $self->set_text($value);
    }
    
    sub clear
    {
        my $self = shift;
        $self->setValue('');
    }
    
    sub setWidth
    {
        my ($self, $value) = @_;
        $self->set_width_chars($value);
    }
    
    sub setReadOnly
    {
        my $self = shift;
        $self->set_editable(0);
        $self->{readOnly} = 1;
    }

    sub lock
    {
        my ($self, $locked) = @_;
        return if $self->{readOnly};
        #$self->can_focus(!$locked);
        $self->set_editable(!$locked);
    }
}

our $hasSpellChecker;
BEGIN {
    eval 'use Gtk2::Spell';
    if ($@)
    {
        $hasSpellChecker = 0;
    }
    else
    {
        $hasSpellChecker = 1;
    }
}
{
    package GCLongText;
    

    use Glib::Object::Subclass
                Gtk2::ScrolledWindow::
    ;
    
    @GCLongText::ISA = ('Gtk2::ScrolledWindow', 'GCGraphicComponent');

    sub new
    {
        my ($proto) = @_;
        my $class = ref($proto) || $proto;
    
        my $self = $class->SUPER::new;
    
        $self->{text} = new Gtk2::TextView;
        $self->{text}->set_editable(1);
        $self->{text}->set_wrap_mode('word');
        $self->set_border_width(0);
        $self->set_shadow_type('in');
        $self->set_policy('automatic', 'automatic');
        #$self->set_size_request(-1,80);
        
        $self->add($self->{text});
        $self->{spellChecker} = 0;

        bless ($self, $class);
        return $self;
    }

    sub activateStateTracking
    {
        my $self = shift;
        $self->{text}->get_buffer->signal_connect('changed' => sub {;
            $self->setChanged;
        });
    }
    
    sub setSpellChecking
    {
        my ($self, $activate, $lang) = @_;
        return if ! $GCGraphicComponents::hasSpellChecker;
        if ($activate)
        {
            $lang ||= $ENV{LANG};
            if ($self->{spellChecker})
            {
                return if $lang eq $self->{lang};
                $self->setSpellChecking(0)
            }
            eval {
                $self->{spellChecker} = Gtk2::Spell->new_attach($self->{text});
                $self->{spellChecker}->set_language($lang);
                $self->{lang} = $lang;
            };
            if ($@)
            {
                $self->setSpellChecking(0);
            }
        }
        else
        {
            $self->{spellChecker}->detach if $self->{spellChecker};
            $self->{spellChecker} = 0;
        }
    }
    
    sub isEmpty
    {
        my $self = shift;
        
        return $self->getValue eq '';
    }
    
    sub getValue
    {
        my $self = shift;
        my $buffer = $self->{text}->get_buffer;
        my $text = $buffer->get_text($buffer->get_start_iter,
                   $buffer->get_end_iter, 1);
        #$text =~s/\n/<br\/>/g;
        return $text;
    }
    
    sub setValue
    {
        my ($self, $text) = @_;
        #$text =~s/<br\/>/\n/g;
        $text = '' if !defined $text;
        $self->{text}->get_buffer->set_text($text);
    }
    
    sub clear
    {
        my $self = shift;
        $self->setValue('');
    }
    
    sub lock
    {
        my ($self, $locked) = @_;
    
        $self->{text}->can_focus(!$locked);
    }
    
    sub setHeight
    {
        my ($self, $height) = @_;
        
        # TODO Change height
    }
}

{
    package GCHistoryText;
    

    use Glib::Object::Subclass
                Gtk2::Combo::
    ;
    
    @GCHistoryText::ISA = ('Gtk2::Combo', 'GCGraphicComponent');
    
    sub new
    {
        my ($proto) = @_;
        my $class = ref($proto) || $proto;
    
        my $self = $class->SUPER::new;
        $self->{history} = {'' => 1};
        
        # Settings for auto-completion
        $self->{completionModel} = Gtk2::ListStore->new('Glib::String');
        $self->{completion} = Gtk2::EntryCompletion->new;
        $self->{completion}->set_model($self->{completionModel});
        $self->{completion}->set_text_column(0);
        $self->entry->set_completion($self->{completion});

        bless ($self, $class);
        return $self;
    }

    sub activateStateTracking
    {
        my $self = shift;
        $self->entry->signal_connect('changed' => sub {;
            $self->setChanged;
        });
    }

    sub isEmpty
    {
        my $self = shift;
        
        return $self->getValue eq '';
    }
    
    sub selectAll
    {
        my $self = shift;
        $self->entry->select_region(0, -1);
        $self->entry->grab_focus;
    }

    sub getValue
    {
        my $self = shift;
        my @children = $self->get_children;
        return $children[0]->get_text if $children[0];
    }
    
    sub setValue
    {
        my ($self, $text) = @_;
        my @children = $self->get_children;
        $children[0]->set_text($text);
    }

    sub clear
    {
        my $self = shift;
        $self->setValue('');
    }
    
    sub setWidth
    {
        my ($self, $value) = @_;
        ($self->get_children)[0]->set_width_chars($value);
    }
    
    sub lock
    {
        my ($self, $locked) = @_;
    
        ($self->get_children)[0]->can_focus(!$locked);
        ($self->get_children)[1]->set_sensitive(!$locked);
    }
    
    sub addHistory
    {
        my $self = shift;
        my $value = (scalar @_) ? shift : $self->getValue;
        my $noUpdate = shift;
        $value =~ s/^\s*//;
        if (!exists $self->{history}->{$value})
        {
            $self->{history}->{$value} = 1;
            if (!$noUpdate)
            {
                $self->setDropDown(sort keys %{$self->{history}});
            }
        }
    }
    
    sub setDropDown
    {
        my $self = shift;
        my @values = (scalar @_) ? @_ : sort keys %{$self->{history}};
        my $previousValue = $self->getValue;
        
        # Update history list
        $self->set_popdown_strings(@values);
        
        # Restore value as it is lost when updating list
        $self->setValue($previousValue);
        
        # Update auto-completion list
        $self->{completionModel}->clear;
        foreach (@values)
        {
            my $iter = $self->{completionModel}->append;
            $self->{completionModel}->set($iter,
                                          0 => $_);
        }
    }
    
    sub getValues
    {
        my $self = shift;
        my @array = sort keys %{$self->{history}};
        return \@array;
    }

    sub setValues
    {
        my ($self, $values) = @_;
        $self->{history} = {};
        $self->setDropDown(@$values);
        $self->{history}->{$_} = 1 foreach (@$values);
    }

    sub setActivate
    {
        my $value
    }

    sub popup
    {
        my $self = shift;
        ($self->get_children)[1]->grab_focus;
        ($self->get_children)[1]->signal_emit('activate');
    }
}

{
    package GCNumeric;
    

    use Glib::Object::Subclass
                Gtk2::SpinButton::
    ;
    
    @GCNumeric::ISA = ('Gtk2::SpinButton', 'GCRatingWidget', 'GCGraphicComponent');
    
    use GCWidgets;
    use GCLang;

    sub new
    {
        my ($proto, $default, $min, $max, $step, $format) = @_;
        my $class = ref($proto) || $proto;

        my $self;

        if (($format eq 'text') || (!$format))
        {
            # Standard numeric field
            $step = 1 if !$step;
            my $pageStep = 10 * $step;

            my $decimals = 0;
            $decimals = length($1) if $step =~ /\.(.*)$/;

            my $accel = 0;
            my $values = ($max - $min) / $step;
            $accel = 0.2 if $values > 100;
            $accel = 0.5 if $values > 500;
            $accel = 1.0 if $values > 2000;
            $default = 0 if $default eq '';
            my $adj = Gtk2::Adjustment->new($default, $min, $max, $step, $pageStep, 0) ;
            $self = $class->SUPER::new($adj, $accel, $decimals);
            $self->{default} = $default;
            $self->{step} = $step;
            $self->{pageStep} = $pageStep;
            $self->{accel} = $accel;
            $self->{format} = 'text';
            $self->set_numeric(1);
        }
        elsif ($format eq 'graphical')
        {
            # Graphical rating widget
            $default = 0 if $default eq '';
            $max = 10 if $max eq '';

            $self = GCRatingWidget->new (maxStars=>$max, rating=>$default, direction=>GCLang::languageDirection($ENV{LANG}));
            $self->{format} = 'graphical';
        }
        bless ($self, $class);
        return $self;
    }

    sub activateStateTracking
    {
        my $self = shift;
        $self->signal_connect('changed' => sub {;
            $self->setChanged;
        });
    }

    sub isEmpty
    {
        my $self = shift;
        
        if ($self->{format} eq 'text')
        {
            return $self->get_text eq '';
        }
        elsif ($self->{format} eq 'graphical')
        {
            return $self->get('rating') eq 0;
        }
    }

    sub selectAll
    {
        my $self = shift;
        if ($self->{format} eq 'text')
        {
            $self->select_region(0, length($self->getValue));
        }
    }
    
    sub getValue
    {
        my $self = shift;
        my $value;

        if ($self->{format} eq 'text')
        {
            $value = $self->get_text;
            $value =~ s/,/./;
        }
        elsif ($self->{format} eq 'graphical')
        {
            $value = $self->get('rating');
        }

        return $value;
    }

    sub setValue
    {
        my ($self, $text) = @_;

        if ($self->{format} eq 'text')
        {
            $text = $self->{default} if $text eq '';
            $self->set_value($text);
        }
        elsif ($self->{format} eq 'graphical')
        {
            $text = $self->{default} if $text eq '';
            $self->set_rating($text);
        }
    }
    
    sub clear
    {
        my $self = shift;

        if ($self->{format} eq 'text')
        {
            $self->set_value($self->{default});
        }
        elsif ($self->{format} eq 'graphical')
        {
            $self->set_rating($self->{default});
        }
    }
    
    sub setWidth
    {
        my ($self, $value) = @_;
        $self->set_width_chars($value);
    }
    
    sub lock
    {
        my ($self, $locked) = @_;

        if ($self->{format} eq 'text')
        {
            $self->can_focus(!$locked);
            my $step = ($locked ? 0 : $self->{step});
            $self->set_increments($step, $self->{pageStep});
        }
        elsif ($self->{format} eq 'graphical')
        {
            $self->set(sensitive=>!$locked);
        }
    }
}

{
    package GCCheckedText;

    use Glib::Object::Subclass
                Gtk2::Entry::
    ;
    
    @GCCheckedText::ISA = ('GCShortText');
    
    sub new
    {
        my ($proto, $format) = @_;
        my $class = ref($proto) || $proto;
    
        my $self = $class->SUPER::new;
        bless ($self, $class);
        my $forbidden = qr/[^$format]/;
        $self->signal_connect('insert-text' => sub {
                # Remove forbidden characters
                $_[1] =~ s/$forbidden//g;
                () # this callback must return either 2 or 0 items.
        });

        return $self;
    }
}

{
    package GCRange;
    
    use Glib::Object::Subclass
                Gtk2::HBox::
    ;
    
    @GCRange::ISA = ('Gtk2::HBox', 'GCGraphicComponent');
    
    sub new
    {
        my ($proto, $type, $lang, $min, $max, $step, $parent) = @_;
        my $class = ref($proto) || $proto;
    
        my $self = $class->SUPER::new;
        bless ($self, $class);

        if ($type eq 'text')
        {
            $self->{from} = new GCShortText;
            $self->{to} = new GCShortText;
        }
        elsif ($type eq 'numeric text')
        {
            new GCCheckedText('0-9.');
            $self->{to} = new GCCheckedText('0-9.');
        }
        elsif ($type eq 'date')
        {
            $self->{from} = new GCDate($parent->{window}, $lang, 1,
           	                           $parent->{options}->dateFormat);
            $self->{to} = new GCDate($parent->{window}, $lang, 1,
           	                         $parent->{options}->dateFormat);
        }
        else
        {
            $self->{from} = new GCNumeric($min, $min, $max, $step);
            $self->{to} = new GCNumeric($max, $min, $max, $step);
        }
        $self->pack_start(Gtk2::Label->new($lang->{PanelFrom}), 0, 0, 12);
        $self->pack_start($self->{from}, 1, 1, 0);
        $self->pack_start(Gtk2::Label->new($lang->{PanelTo}), 0, 0, 12);
        $self->pack_start($self->{to}, 1, 1, 0);
        
        return $self;
    }

    sub activateStateTracking
    {
        my $self = shift;
        $self->{from}->activateStateTracking;
        $self->{to}->activateStateTracking;
    }

    sub isEmpty
    {
        my $self = shift;
        
        return $self->getValue eq '';
    }
    
    sub getValue
    {
        my $self = shift;
        return $self->{from}->getValue.';'.$self->{to}->getValue;
    }
    
    sub setValue
    {
        my ($self, $value) = @_;
        my @values = split m/;/, $value;
        $self->{from}->setValue($values[0]);
        $self->{to}->setValue($values[0]);
    }
    
    sub setWidth
    {
        my ($self, $value) = @_;
        $self->{from}->setWidth($value / 2);
        $self->{to}->setWidth($value / 2);
    }
    
    sub lock
    {
        my ($self, $locked) = @_;
    
        $self->{from}->lock(!$locked);
        $self->{to}->lock(!$locked);
    }
    
    sub signal_connect
    {
        my $self = shift;
        $self->{from}->signal_connect(@_);
        $self->{to}->signal_connect(@_);
    }
    
    sub AUTOLOAD
    {
        my $self = shift;
        my $name = our $AUTOLOAD;
        return if $name =~ /::DESTROY$/;
        $name =~ s/.*?::(.*)/$1/;
        $self->{from}->$name(@_);
        $self->{to}->$name(@_);
    }
}

{
    package GCDate;
    
    use Glib::Object::Subclass
                Gtk2::HBox::
    ;
    
    @GCDate::ISA = ('Gtk2::HBox', 'GCGraphicComponent');
    
    sub selectValue
    {
        my $self = shift;
        $self->{dialog} = new GCDateSelectionDialog($self->{mainParent})
            if ! $self->{dialog};
        $self->{dialog}->date($self->getRawValue);
        if ($self->{dialog}->show)
        {
            $self->setValue($self->{dialog}->date);
        }
        $self->{parent}->showMe;
    }

    sub new
    {
        my ($proto, $parent, $lang, $reverseDate, $format) = @_;
        $format ||= '%d/%m/%Y';
        my $class = ref($proto) || $proto;

        my $self = $class->SUPER::new;
        bless ($self, $class);

        $self->{parent} = $parent;
        $self->getMainParent;
        $self->{reverseDate} = $reverseDate;
        $self->{entry} = Gtk2::Entry->new; #_with_max_length(10);
        $self->{entry}->set_width_chars(12);
        $self->{button} = new Gtk2::Button($lang->{PanelDateSelect});
        $self->{button}->signal_connect('clicked' => sub {
            $self->selectValue;
        });
        $self->pack_start($self->{entry}, 1, 1, 0);
        $self->pack_start($self->{button}, 0, 0, 0);
        
        $self->{format} = $format;
        #$self->{format} = '%d %B %Y';
        return $self;
    }

    sub setFormat
    {
        my ($self, $format) = @_;
        my $current = $self->getValue;
        $self->{format} = $format;
        $self->setValue($current);
    }

    sub activateStateTracking
    {
        my $self = shift;
        $self->{entry}->signal_connect('changed' => sub {;
            $self->setChanged;
        });
    }

    sub isEmpty
    {
        my $self = shift;
        
        return $self->getValue eq '';
    }
    
    sub getCurrentDate
    {
        my $self = shift;
        
        my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
        return sprintf('%02d/%02d/%4d', $mday, $mon+1, 1900+$year);
    }
    
    
    sub getRawValue
    {
        my $self = shift;
        my $value = $self->{entry}->get_text;
        $value = GCUtils::strToTime($value, $self->{format})
            if $self->{format} && $value;
        return $value;
        
    }
    
    sub getValue
    {
        my $self = shift;
        my $value = $self->getRawValue;
        return GCPreProcess::reverseDate($value) if $self->{reverseDate};
        return $value;
    }

    sub setValue
    {
        my ($self, $text) = @_;
        $text = GCPreProcess::restoreDate($text) if $self->{reverseDate};
        if ($text eq 'current')
        {
            $text = $self->getCurrentDate;
            $self->setChanged;
        }
        $text = GCUtils::timeToStr($text, $self->{format}) if $self->{format};
        $self->{entry}->set_text($text);
    }
    
    sub clear
    {
        my $self = shift;
        $self->setValue('');
    }

    sub setWidth
    {
        my ($self, $value) = @_;
        $self->{entry}->set_width_chars($value);
    }
    
    sub lock
    {
        my ($self, $locked) = @_;
    
        $self->{entry}->can_focus(!$locked);
        $self->{button}->set_sensitive(!$locked);
    }
}

{
    package GCFile;
    
    use Glib::Object::Subclass
                Gtk2::HBox::
    ;
    
    @GCFile::ISA = ('Gtk2::HBox', 'GCGraphicComponent', 'GCPseudoHistoryComponent');

    use File::Basename;

    sub selectValue
    {
	my $self = shift;

        my $dialog = GCFileChooserDialog->new($self->{title},
                                              $self->{mainParent},
                                              $self->{type},
                                              $self->{withFilter});
		$dialog->set_filename($self->getValue);
        $dialog->set_pattern_filter($self->{patterns})
            if $self->{patterns};
		my $response = $dialog->run;
		if ($response eq 'ok')
		{
	        $self->setValue($dialog->get_filename);
        }
        $dialog->hide;
        $self->{parent}->showMe;
    }
    
    sub setPatternFilter
    {
        my ($self, $patterns) = @_;
        $self->{patterns} = $patterns;
    }
    
    sub setType
    {
        my ($self, $type, $withFilter) = @_;
        
        if (($type ne $self->{type}) || ($withFilter != $self->{withFilter}))
        {
            $self->{dialog}->destroy
                if $self->{dialog};
            $self->{dialog} = undef;
            $self->{type} = $type;
            $self->{withFilter} = $withFilter;
        }
    }

    sub setTitle
    {
        my ($self, $title) = @_;
        $self->{title} = $title;
        if ($self->{dialog})
        {
            $self->{dialog}->setTitle($title);
        }
    }

    sub new
    {
        my ($proto, $parent, $title, $type, $withFilter, $defaultValue, $allowContextMenu, $fieldType) = @_;
        my $class = ref($proto) || $proto;
    
        my $self = $class->SUPER::new;
        bless ($self, $class);
        $self->{parent} = $parent;
        $self->getMainParent;

        $title ||= $self->{parent}->{lang}->{PanelSelectFileTitle};
        $self->{title} = $title;
        $type ||= 'open';
        $self->{type} = $type;
        $withFilter = 0 if !$withFilter;
        $self->{withFilter} = $withFilter;

        $self->{entry} = Gtk2::Entry->new;
        
        $self->{button} = new GCButton($self->{parent}->{lang}->{PanelSelectFileTitle});

        # For video/ebook/audio files, set file pattern filters
        if (($fieldType eq 'video') || ($fieldType eq 'ebook') || ($fieldType eq 'audio'))
        {
            $self->setPatternFilter([$self->{parent}->{lang}->{FileVideoFiles}, \@videoExtensions])
                if ($fieldType eq 'video');
            $self->setPatternFilter([$self->{parent}->{lang}->{FileEbookFiles}, \@ebookExtensions])
                if ($fieldType eq 'ebook');     
            $self->setPatternFilter([$self->{parent}->{lang}->{FileAudioFiles}, \@audioExtensions])
                if ($fieldType eq 'audio');       
            $self->{withFilter} = 1;
        }

        $self->{button}->signal_connect('clicked' => sub {
            $self->selectValue;
        });

        if ($allowContextMenu)
        {
            my @subMenuFileChoose;
            $subMenuFileChoose[0] = Gtk2::ImageMenuItem->new_with_mnemonic($parent->{lang}->{ContextChooseFile});
            $subMenuFileChoose[0]->signal_connect("activate" , sub {$self->selectValue});
            $subMenuFileChoose[1] = Gtk2::ImageMenuItem->new_with_mnemonic($parent->{lang}->{ContextChooseFolder});
            $subMenuFileChoose[1]->signal_connect("activate" , sub {
                $self->{type} = 'select-folder';
                $self->{title} = $parent->{lang}->{ContextChooseFolder};
                $self->selectValue;
            });
            $self->{button}->setContextMenu(\@subMenuFileChoose);
            $self->{button}->enableContextMenu;
        }
        
        $self->pack_start($self->{entry}, 1, 1, 0);

        if ($defaultValue)
        {
            $self->{defaultButton} = GCButton->newFromStock('gtk-undo', 0, $parent->{lang}->{PanelRestoreDefault});
            $parent->{tooltips}->set_tip($self->{defaultButton},
                $parent->{lang}->{PanelRestoreDefault}.$parent->{lang}->{Separator}.$defaultValue)
                    if $parent->{tooltips};
            $self->pack_start($self->{defaultButton}, 0, 0, 0);
            $self->{defaultButton}->signal_connect('clicked' => sub {
                $self->setValue($defaultValue);
            });
        }
        
        # Add the 'select file' button only if the field is not a url field
        $self->pack_start($self->{button}, 0, 0, 0)
            if ($fieldType ne 'url');

        return $self;
    }

    sub activateStateTracking
    {
        my $self = shift;
        $self->{entry}->signal_connect('changed' => sub {;
            $self->setChanged;
        });
    }

    sub isEmpty
    {
        my $self = shift;
        
        return $self->getValue eq '';
    }
    
    sub getValue
    {
        my $self = shift;
        return $self->{entry}->get_text;
    }

    sub setValue
    {
        my ($self, $text) = @_;
        $self->{entry}->set_text($text);
    }
    
    sub clear
    {
        my $self = shift;
        $self->setValue('');
    }

    sub setWidth
    {
        my ($self, $value) = @_;
        $self->{entry}->set_width_chars($value);
    }
    
    sub lock
    {
        my ($self, $locked) = @_;
    
        $self->{entry}->can_focus(!$locked);
        $self->{button}->set_sensitive(!$locked);
    }
}

{
    package GCUrl;
    
    use Glib::Object::Subclass
                Gtk2::HBox::
    ;
    
    @GCUrl::ISA = ('GCFile');

    sub selectValue
    {
		my $self = shift;
		my $url = $self->getValue;
		return if !$url;
		$self->{opener}->launch($url, 'url');
    }

    sub new
    {
        my ($proto, $opener) = @_;
        my $class = ref($proto) || $proto;
    
        my $self = $class->SUPER::new(undef, '', 'url');
        $self->{opener} = $opener;
        bless ($self, $class);
        return $self;
    }
}

{
    package GCButton;
    
    use Glib::Object::Subclass
                Gtk2::Button::
    ;
    
    @GCButton::ISA = ('Gtk2::Button', 'GCGraphicComponent');
    
    sub new
    {
        my ($proto, $label) = @_;
        my $class = ref($proto) || $proto;
    
        my $self = $class->SUPER::new($label);

        bless ($self, $class);
        return $self;
    }
    
    sub newFromStock
    {
        my ($proto, $stock, $nolabel, $label) = @_;
        my $class = ref($proto) || $proto;

        $nolabel = 0 if ($^O =~ /win32/i);

        my $self = $class->SUPER::new_from_stock($stock);
        
        if ($nolabel)
        {
            my $tmpWidget = $self;
            $tmpWidget = $tmpWidget->child while ! $tmpWidget->isa('Gtk2::HBox');
            ($tmpWidget->get_children)[1]->destroy;
        }
        elsif ($label)
        {
            my $tmpWidget = $self;
            $tmpWidget = $tmpWidget->child while ! $tmpWidget->isa('Gtk2::HBox');
            ($tmpWidget->get_children)[1]->set_label($label);        
        }

        bless ($self, $class);
        return $self;
    }
    
    sub isEmpty
    {
        my $self = shift;
        
        return 0;
    }
    
    sub getValue
    {
        my $self = shift;
    }
    
    sub setValue
    {
        my ($self, $value) = @_;
        $self->setChanged;
        return $value;
    }

    sub clear
    {
        my $self = shift;
        $self->setValue('');
    }
    
    sub lock
    {
        my ($self, $locked) = @_;
    
        $self->set_sensitive(!$locked);
    }
    
    sub setWidth
    {
        my ($self, $value) = @_;
        $self->set_size_request($value, -1);
    }
    sub setContextMenu
    {
        my ($self, $menu) = @_;
        $self->{popupContextMenu}=new Gtk2::Menu if !$self->{popupContextMenu};
        for my $i(0..$#{$self->{popupContextMenu}->{items}})
        {
            $self->{popupContextMenu}->remove($self->{popupContextMenu}->{items}->[$i]);
            $self->{popupContextMenu}->{items}->[$i]->destroy;
        }
        delete $self->{popupContextMenu}->{items};
        for my $i(0..$#$menu)
        {
            $self->{popupContextMenu}->{items}->[$i]=$menu->[$i];
            $self->{popupContextMenu}->append($self->{popupContextMenu}->{items}->[$i]);
        }
        $self->{popupContextMenu}->show_all;
    }
    sub enableContextMenu
    {
        my ($self,$button) = @_;
        #TODO enabled context for one button mouses
        $button=3 if !$button;
        $self->{contextMenuSignalHandler}=$self->signal_connect('button_press_event' => sub {
            my ($widget, $event) = @_;
            return 0 if $event->button ne $button;
            $self->{popupContextMenu}->popup(undef, undef, undef, undef, $event->button, $event->time);
            return 0;
        }) if !$self->{contextMenuSignalHandler};
    }
    sub disableContextMenu
    {
        my $self = shift;
        if($self->{contextMenuSignalHandler})
        {
            $self->signal_handler_disconnect($self->{contextMenuSignalHandler});
            delete $self->{contextMenuSignalHandler};
        }
    }
}

{
    package GCUrlButton;
    
    use Glib::Object::Subclass
                Gtk2::Button::
    ;
    
    @GCUrlButton::ISA = ('GCButton', 'GCGraphicComponent');
    
    sub new
    {
        my ($proto, $label, $opener) = @_;
        my $class = ref($proto) || $proto;
    
        my $self = $class->SUPER::new($label);
        $self->{opener}=$opener;
        $self->{defaultLabel} = $label;
        $self->{clicSignalHandler}=$self->signal_connect('clicked' => sub {
            $self->{opener}->launch($self->{url}, 'url');
        });
        

        bless ($self, $class);
        return $self;
    }
        
    sub getValue
    {
        my $self = shift;

        return $self->{value};
    }
    
    sub setValue
    {
        my ($self, $value) = @_;

        $self->setChanged;
        my @urls=split ';',$value;
        if(scalar(@urls)>1)
        {
            my (@menu,$i,$url);
            foreach my $urlName(@urls)
            {
                $urlName =~ /^(.*?)##(.*)$/;
                my $name=$2;
                my $menuItem=Gtk2::MenuItem->new_with_label($name);
                $menuItem->signal_connect("activate" ,sub {
                    $self->{opener}->launch($_[1], 'url')
                },$1);
                push @menu,$menuItem;
            }
            $self->{url} ='';
            $self->setContextMenu(\@menu);
            $self->enableContextMenu(1);
            $self->lock(0);
            #$self->signal_handler_block($self->{clicSignalHandler});
            $self->setLabel($self->{defaultLabel});
        }
        else
        {
            if ($value =~ /^(.*?)##(.*)$/)
            {
                $self->{url} = $1;
                $self->setLabel($2);
            }
            else
            {
                $self->{url} = $value;
                $self->setLabel($self->{defaultLabel});
            }
            $self->lock(!$self->{url});
            $self->disableContextMenu;
            #$self->signal_handler_unblock($self->{clicHandler});
        }
        $self->{value} = $value;
    }

    sub setLabel
    {
        my ($self, $label) = @_;
        $self->set_label($label);
    }
}

{
    package GCCheckBox;
    
    use Glib::Object::Subclass
                Gtk2::CheckButton::
    ;
    
    @GCCheckBox::ISA = ('Gtk2::CheckButton', 'GCGraphicComponent');
    
    sub new
    {
        my ($proto, $label) = @_;
        my $class = ref($proto) || $proto;
    
        my $self = $class->SUPER::new($label);

        bless ($self, $class);
        return $self;
    }

    sub activateStateTracking
    {
        my $self = shift;

        $self->signal_connect('toggled' => sub {
            $self->setChanged;
        });
    }

    sub isEmpty
    {
        my $self = shift;
        
        return 0;
    }
    
    sub getValue
    {
        my $self = shift;
        return 1 if ($self->get_active);
        return 0;
    }
    
    sub getValueAsText
    {
        my $self = shift;
        return 'true' if ($self->get_active);
        return 'false';
    }
    
    sub setValue
    {
        my ($self, $value) = @_;
        $self->set_active($value);
    }
    
    sub clear
    {
        my $self = shift;
        $self->setValue(0);
    }

    sub lock
    {
        my ($self, $locked) = @_;
    
        $self->set_sensitive(!$locked);
    }
}

{
    package GCCheckBoxWithIgnore;
    
    use Glib::Object::Subclass
                Gtk2::HBox::
    ;
    
    @GCCheckBoxWithIgnore::ISA = ('Gtk2::HBox', 'GCGraphicComponent');
    
    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
    
        my $self = $class->SUPER::new(0,0);
        bless ($self, $class);
        
        $self->{check}->[0] = new Gtk2::RadioButton(undef,$parent->{lang}->{CheckUndef});
        $self->{group} = $self->{check}->[0]->get_group;
        $self->{check}->[1] = new Gtk2::RadioButton($self->{group},$parent->{lang}->{CheckNo});
        $self->{check}->[2] = new Gtk2::RadioButton($self->{group},$parent->{lang}->{CheckYes});
        
        $self->pack_start($self->{check}->[0], 0, 0, 10);
        $self->pack_start($self->{check}->[1], 0, 0, 10);
        $self->pack_start($self->{check}->[2], 0, 0, 10);
        
        return $self;
    }
    
    sub activateStateTracking
    {
        my $self = shift;

        foreach (@{$self->{check}})
        {
            $_->signal_connect('toggled' => sub {
                $self->setChanged;
            });
        }
    }

    sub isEmpty
    {
        my $self = shift;
        
        return $self->{check}->[0]->get_active;
    }
    
    sub getValue
    {
        my $self = shift;
        my $i = 0;
        foreach (@{$self->{check}})
        {
            last if $self->{check}->[$i]->get_active;
            $i++;
        }
        $i--;
        return $i;
    }
    
    sub setValue
    {
        my ($self, $value) = @_;
        $self->{check}->[$value + 1]->set_active(1);
    }
    
    sub clear
    {
        my $self = shift;
        $self->setValue(-1);
    }

    sub lock
    {
        my ($self, $locked) = @_;

        $self->set_sensitive(!$locked);
    }
}

{
    package GCMultipleList;
    
    use Glib::Object::Subclass
                Gtk2::HBox::
    ;
    
    @GCMultipleList::ISA = ('Gtk2::HBox', 'GCGraphicComponent');
    
    sub new
    {
        my ($proto, $parent, $number, $labels, $withHistory, $readonly, $useFiles,$types) = @_;
        my $class = ref($proto) || $proto;
    
        my $self = $class->SUPER::new(0,0);

        $self->{number} = $number;
        $self->{readonly} = $readonly;
        $self->{withHistory} = $withHistory;

		my $hboxActions = new Gtk2::HBox(0,0);

        my @histories;
        my @listColumns;
        my $i;
        for $i (0..($number - 1))
        {
            push @histories, {'' => 1};
            push @listColumns, ($labels->[$i] => 'text');
            next if $readonly;
            if ($useFiles)
            {
                $self->{entries}->[$i] = GCFile->new($parent);
                $self->{entries}->[$i]->{entry}->signal_connect('activate' => sub {
                    $self->addValues;
                });
            }
            else
            {
                if($types && $types->[$i] eq 'date')
                {
                    $self->{entries}->[$i] = GCDate->new($parent, $parent->{lang}, 1,$parent->{options}->dateFormat);
                    $self->{entries}->[$i]->{entry}->signal_connect('activate' => sub {
                        $self->addValues;
                        $self->{entries}->[0]->grab_focus;
                    });
                    $self->{withHistoryField}->[$i]=0;
                }
                elsif ($withHistory && (!$types || $types->[$i] eq 'history'))
                {
                    $self->{entries}->[$i] = GCHistoryText->new;
                    $self->{entries}->[$i]->entry->signal_connect('activate' => sub {
                        my $widget = $self->{entries}->[$i];
                        if ($widget->getValue)
                        {
                            $self->addValues;
                            # FIXME. It seems this does nothing:
                            $self->{entries}->[0]->grab_focus;
                        }
                        $widget->entry->signal_stop_emission_by_name('activate');
                    });
                    $self->{withHistoryField}->[$i]=1;
                }
                else
                {
                    $self->{entries}->[$i] = GCShortText->new;
                    $self->{entries}->[$i]->signal_connect('activate' => sub {
                        $self->addValues;
                        $self->{entries}->[0]->grab_focus;
                    });
                    $self->{withHistoryField}->[$i]=0 if $withHistory;
                }
            }
            $self->{entries}->[$i]->setWidth(12);
            $hboxActions->pack_start($self->{entries}->[$i], 1, 1, 6);
        }

        $self->{histories} = [\@histories];

        $self->{box} = new Gtk2::VBox(0,0);

        # If list belongs to an expander, set box size to a reasonable size
        $self->{box}->{signalHandler} = $self->{box}->signal_connect('size-allocate' => sub {
            if (($self->{realParent}) && ($self->{realParent}->isa('GCExpander')))
            {
                my $width = $self->allocation->width - ( 2 * $GCUtils::margin) ;
                $self->{box}->set_size_request(($width >= -1) ? $width : -1 , -1);
                return 0;
            }
        });

        $self->{list} = new Gtk2::SimpleList(@listColumns);
        for $i (0..($number - 1))
        {
            $self->{list}->set_column_editable($i, 1);
        }
        $self->{list}->unset_rows_drag_source;
        $self->{list}->unset_rows_drag_dest;
        $self->{list}->set_reorderable(1);
        #($self->{list}->get_column(0)->get_cell_renderers)[0]->set('wrap-mode' => 'word');

        for $i (0..($number - 1))
        {
            $self->{list}->get_column($i)->set_resizable(1);
        }
        my $scroll = new Gtk2::ScrolledWindow;
        $scroll->set_policy ('automatic', 'automatic');
        $scroll->set_shadow_type('etched-in');
        $scroll->set_size_request(-1, 120);
        $scroll->add($self->{list});
        $self->{box}->pack_start($scroll, 1, 1, 2);
        if (!$readonly)
        {
            $self->{addButton} = GCButton->newFromStock('gtk-add', 0);
            $self->{addButton}->signal_connect('clicked' => sub {
                $self->addValues;
            });
            $self->{removeButton} = GCButton->newFromStock('gtk-remove', 0);
            $hboxActions->pack_start($self->{addButton}, 0, 0, 6);
            $hboxActions->pack_start($self->{removeButton}, 0, 0, 6);
        }
        else
        {
            $self->{removeButton} = GCButton->newFromStock('gtk-remove', 0);
            $self->{clearButton} = GCButton->newFromStock('gtk-clear', 0);
            $self->{clearButton}->signal_connect('clicked' => sub {
                $self->clear;
            });            
            $hboxActions->pack_start($self->{removeButton}, 1, 0, 6);
            $hboxActions->pack_start($self->{clearButton}, 1, 0, 6);
        }
        $self->{box}->pack_start($hboxActions, 0, 0, 6)
            if $readonly < 2;

        $self->{removeButton}->signal_connect('clicked' => sub {
            my @idx = $self->{list}->get_selected_indices;
            my $selected = $idx[0];
            splice @{$self->{list}->{data}}, $selected, 1;
            $selected-- if ($selected >= scalar(@{$self->{list}->{data}}));
            $selected = 0 if $selected < 0 ;
            $self->{list}->select($selected);
        });
        
        $self->{list}->signal_connect('key-press-event' => sub {
            my ($widget, $event) = @_;
            my $key = Gtk2::Gdk->keyval_name($event->keyval);
            if ((!$self->{readonly}) && ($key eq 'Delete'))
            {
                $self->{removeButton}->activate;
                return 1;
            }
            # Let key be managed by Gtk2
            return 0;
        });
        

        $self->pack_start($self->{box},1,$self->{readonly},0);

        bless ($self, $class);
        return $self;
    }

    sub activateStateTracking
    {
        my $self = shift;
        $self->{list}->get_model->signal_connect('row-inserted' => sub {
            $self->setChanged;
        });
        $self->{list}->get_model->signal_connect('row-deleted' => sub {
            $self->setChanged;
        });
        $self->{list}->get_model->signal_connect('row-changed' => sub {
            $self->setChanged;
        });
    }

    sub expand
    {
        my $self = shift;
        $self->set_child_packing($self->{box},1,1,0,'start');
    }

    sub addValues
    {
        my ($self, @values) = @_;
        if (!$self->{readonly})
        {
            for my $i (0..($self->{number} - 1))
            {
                $values[$i] = $self->{entries}->[$i]->getValue if !$values[$i];
                $self->{entries}->[$i]->addHistory($values[$i])
                    if $self->{withHistory} && $self->{withHistoryField}->[$i];
                $self->{entries}->[$i]->clear;
            }
        }
        # Check that at least one value is not empty
        my $isEmpty = 1;
        for my $val (@values)
        {
            if ($val)
            {
                $isEmpty = 0;
                last;
            }
        }
        if (!$isEmpty)
        {
            push @{$self->{list}->{data}}, \@values;
            $self->{list}->select($#{$self->{list}->{data}});
            my $path = $self->{list}->get_selection->get_selected_rows;
            $self->{list}->scroll_to_cell($path) if $path;
        }
    }

    sub isEmpty
    {
        my $self = shift;
        
        return $self->getValue eq '';
    }
    
    sub getValue
    {
        my $self = shift;
        my $formated = shift;

        if ($formated)
        {
            return GCPreProcess::multipleList($self->{list}->{data}, $self->{number});
        }
        else
        {
            # As data in list is a tied array, we need to copy all the values
            my @value;
            foreach (@{$self->{list}->{data}})
            {
                push @value, [];
                foreach my $col(@$_)
                {
                    push @{$value[-1]}, $col;
                }
            }
            return \@value;
        }
    }
    
    sub setValue
    {
        my ($self, $value) = @_;

        if (ref($value) eq 'ARRAY')
        {
            @{$self->{list}->{data}} = @{$value};
        }
        else
        {
            # The separator used was ; instead of ,
            $value =~ s/;/,/g if $value !~ /,/;
            @{$self->{list}->{data}} = ();
            my @values = split m/,/, $value;
            foreach my $entry (@values)
            {
                my @items = split m/;/, $entry;
                s/^\s*// foreach(@items);
                push @{$self->{list}->{data}}, \@items;
            }
        }
    }
    
    sub clear
    {
        my $self = shift;
        $self->setValue('');
    }
    
    sub lock
    {
        my ($self, $locked) = @_;
        return if $self->{readonly};
        $self->{addButton}->set_sensitive(!$locked);
        $self->{removeButton}->set_sensitive(!$locked);
        foreach (@{$self->{entries}})
        {
            $_->lock($locked);
        }
    }

    sub addHistory
    {
        my $self = shift;
        my $value = (scalar @_) ? shift : $self->getValue;
        my $noUpdate = shift;

        return if $self->{readonly};
        my $i;
        my $item;
        if (ref($value) eq 'ARRAY')
        {
            foreach (@$value)
            {
                $i = 0;
                foreach $item(@$_)
                {
                    $self->{entries}->[$i]->addHistory($item, $noUpdate) if $self->{withHistoryField}->[$i];
                    $i++;
                }
            }
        }
        else
        {
            # The separator used was ; instead of ,
            $value =~ s/;/,/g if $value !~ /,/;
            my @values = split m/,/, $value;
            foreach (@values)
            {
                my @items = split m/;/;
                $i = 0;
                foreach my $item(@items)
                {
                    $self->{entries}->[$i]->addHistory($item, $noUpdate) if $self->{withHistoryField}->[$i];
                    $i++;
                }
                #push @{$self->{list}->{data}}, \@items;
            }
        }
    }

    sub setDropDown
    {
        my $self = shift;
        
        my $i = 0;
        foreach (@{$self->{entries}})
        {
            $_->setDropDown if $self->{withHistoryField}->[$i];
            $i++;
        }
    }

    sub getValues
    {
        my $self = shift;
        return [] if $self->{readonly};
        my @array;
        my $i=0;
        foreach (@{$self->{entries}})
        {
            my $val=[];
            $val=$_->getValues if ($self->{withHistoryField}->[$i++]);
            push @array, $val;
        }
        # = sort keys %{$self->{history}};
        return \@array;
    }
    
    sub setValues
    {
        my ($self, $values) = @_;
        return if $self->{readonly};
        my $i = 0;
        foreach (@$values)
        {
            $self->{entries}->[$i]->setValues($_) if ($self->{withHistoryField}->[$i]);
            $i++;
        }
    }
}


{
    package GCItemImage;
    
    use Glib::Object::Subclass
                Gtk2::Image::
    ;
    
    @GCItemImage::ISA = ('Gtk2::Image', 'GCGraphicComponent');

    use File::Spec;
    use File::Basename;
    
    sub new
    {
        my ($proto, $options, $parent, $fixedSize, $width, $height) = @_;
        my $class = ref($proto) || $proto;
#        my $self  = Gtk2::Image->new_from_file($parent->{defaultImage});
        my $self  = Gtk2::Image->new;
        $self->{options} = $options;
        #$self->{defaultImage} = $defaultImage;
        $self->{parent} = $parent;
        $self->{displayedImage} = '';
        $self->{fixedSize} = $fixedSize;
        bless ($self, $class);
        if ($width && $height)
        {
            $self->{width} = $width;
            $self->{height} = $height;
        }
        else
        {
            $self->{width} = 120;
            $self->{height} = 160;
        }
        $self->{immediate} = 0;
        return $self;
    }

    sub setImmediate
    {
        my ($self) = @_;
        $self->{immediate} = 1;
    }
    sub activateStateTracking
    {
        my $self = shift;
        $self->{trackState} = 1;
    }

    sub isEmpty
    {
        my $self = shift;
        
        return $self->getValue eq '';
    }
    
    sub setValue
    {
        my ($self, $displayedImage, $placer) = @_;
        $self->{displayedImage} = $displayedImage;
        $self->setChanged if $self->{trackState};
        if ($self->{immediate})
        {
            $self->setPicture;
        }
        else
        {
            Glib::Source->remove($self->{timer})
                if $self->{timer};
            $self->{timer} = Glib::Timeout->add(100, sub {
                $self->setPicture;
                $placer->placeImg if $placer;
                return 0;
            });
        }
    }

    sub setPicture
    {
        my $self = shift;
        $self->{timer} = 0;
        my $displayedImage = GCUtils::getDisplayedImage($self->{displayedImage},
                                                        $self->{parent}->{defaultImage},
                                                        $self->{options}->file);
        my $pixbuf;
        eval
        {
            $pixbuf = Gtk2::Gdk::Pixbuf->new_from_file($displayedImage);
        };
        if ($@)
        {
            $displayedImage = $self->{parent}->{defaultImage};
            $pixbuf = Gtk2::Gdk::Pixbuf->new_from_file($displayedImage);
        }
        $self->{realImage} = $displayedImage;
        $pixbuf = GCUtils::scaleMaxPixbuf($pixbuf, $self->{width}, $self->{height});
        $self->set_from_pixbuf($pixbuf);
        $self->set_size_request($self->{width}, $self->{height}) if $self->{fixedSize};
    }
    
    sub getValue
    {
        my $self = shift;
        return $self->{displayedImage};
    }

    sub getFile
    {
        my $self = shift;
        return $self->{realImage};
    }

    sub clear
    {
        my $self = shift;
        $self->setValue('');
    }
    
    sub lock
    {
        my ($self, $locked) = @_;
    }
    
    sub setWidth
    {
        my ($self, $value) = @_;
        $self->{width} = $value;
    }

    sub setHeight
    {
        my ($self, $value) = @_;
        $self->{height} = $value;
    }
    
    sub getSize
    {
        my $self = shift;
        my $pixbuf = $self->get_pixbuf;
        return ($pixbuf->get_width, $pixbuf->get_height);
    }
}


our $hasGnome2VFS;
BEGIN {
    eval 'use Gnome2::VFS';
    if ($@)
    {
        $hasGnome2VFS = 0;
    }
    else
    {
        $hasGnome2VFS = 1;
        Gnome2::VFS->init();
    }
}

{
    package GCImageButton;

    use Glib::Object::Subclass
                Gtk2::Button::
    ;
    
    @GCImageButton::ISA = ('Gtk2::Button', 'GCGraphicComponent');

    use File::Basename;
    use Encode;

    sub animateImg
    {
        my ($self, $from, $to) = @_;
        my $pixbuf1 = Gtk2::Gdk::Pixbuf->new_from_file($from);
        $pixbuf1 = GCUtils::scaleMaxPixbuf($pixbuf1, $self->{img}->{width}, $self->{img}->{height});
        my $pixbuf2 = Gtk2::Gdk::Pixbuf->new_from_file($to);
        $pixbuf2 = GCUtils::scaleMaxPixbuf($pixbuf2, $self->{img}->{width}, $self->{img}->{height});
        my $height = $pixbuf2->get_height;
        my $width = $pixbuf2->get_width;
        foreach my $i(0..20)
        {
            Glib::Timeout->add(30*$i, sub {
                my $pixbufA = $pixbuf1->copy;
                my $pixbufB = $pixbuf2->copy;
                $pixbufA->composite($pixbufB, 0, 0, int($width - (($i/20)*$width)), $height, 0, 0, 1, 1, 'nearest', 255);
                $self->{img}->set_from_pixbuf($pixbufB);
            });
        }
    }

    sub setImg
    {
        my ($self, $value) = @_;
        $self->{img}->setValue($value, $self);
    }

    sub placeImg
    {
        my ($self) = @_;
        my ($picWidth, $picHeight) = $self->{img}->getSize;
        my ($buttonWidth, $buttonHeight) = ($self->allocation->width, $self->allocation->height);
        my $x = ($buttonWidth - $picWidth - $GCUtils::margin)/ 2;
        my $y = ($buttonHeight -$picHeight - $GCUtils::margin)/ 2;

        # Don't allow negative positions, can happen when button has not been allocated a width/height yet
        $x = 0 if ($x < 0);
        $y = 0 if ($y < 0);
        
        $self->{layout}->move($self->{img}, $x, $y);
    }

    sub changeState
    {
        my $self = shift;
        if ($self->{trackState})
        {
            if ($self->{flipped})
            {
                $self->{linkedComponent}->setChanged;
            }
            else
            {
                $self->setChanged;
            }
        }
    }

    sub clearImage
    {
        my $self = shift;

        $self->changeState;
        $self->{mainParent}->checkPictureToBeRemoved($self->{imageFile});
        $self->setValueWithParent('');
    }

    sub changeImage
    {
        my ($self, $fileName) = @_;
        return 0 if $self->{locked};
        if (!$fileName)
        {
            my $imageDialog = GCFileChooserDialog->new($self->{parent}->{lang}->{PanelImageTitle}, $self->{mainParent}, 'open');
            $imageDialog->setWithImagePreview(1);

            my $currentFile = $self->{img}->getValue;
            if ($currentFile)
            {
                $imageDialog->set_filename($currentFile);
            }
            else
            {
                $imageDialog->set_filename($self->{previousDirectory});
            }
            my $response = $imageDialog->run;
            $fileName = $imageDialog->get_filename;
            $imageDialog->destroy;

            $self->{parent}->showMe;
            if ($response eq 'ok')
            {
                $self->{previousDirectory} = dirname($fileName);
                $self->setChanged if $self->{trackState};
            }
            else
            {
                return;
            }
        }

        my $ref = ($self->{flipped} ? $self->{backPic} : $self->{imageFile});
        if ($fileName ne $ref)
        {
            $self->{mainParent}->checkPictureToBeRemoved($ref);
            $self->changeState;
        }
        my $image = $self->{mainParent}->transformPicturePath($fileName);
        $self->setValueWithParent($image);
        return;        
    }
    
    sub isEmpty
    {
        my $self = shift;
        
        return $self->getValue eq '';
    }
    
    sub setValue
    {
        my ($self, $value) = @_;        
        $self->setChanged if $self->{trackState};
        $self->setActualValue($value);
    }

    sub setValueWithParent
    {
        my ($self, $value, $keepWatcher) = @_;
        
        $self->setActualValue($value, $keepWatcher, $self->{flipped});
        if ($self->{isCover} && !$self->{flipped})
        {
            $self->{mainParent}->{items}->updateSelectedItemInfoFromPanel(0, [$self->{name}]);
            $self->{hasChanged} = 0 if $self->{parent} eq $self->{mainParent}->{panel} && !$keepWatcher;
        }
    }

    sub setActualValue
    {
        my ($self, $value, $keepWatcher, $flipped) = @_;
        Glib::Source->remove($self->{fileWatcher})
            if $self->{fileWatcher} && !$keepWatcher;
        if ($flipped)
        {
            $self->{backPic} = $value;
        }
        else
        {
            $self->{imageFile} = $value;
        }
        $self->setImg($value);
    }

    sub getValue
    {
        my $self = shift;
        if ($self->{flipped})
        {
            return $self->{imageFile};
        }
        return $self->{img}->getValue;
    }

    sub setLinkedActivated
    {
        my ($self, $value) = @_;
        $self->flipImage(1) if $self->{flipped};
        $self->{flipActivated} = $value;
    }

    sub flipImage
    {
        my ($self, $noButton) = @_;
        my $newLabel;
        if ($self->{flipped})
        {
            $self->setImg($self->{imageFile});
            $self->{frontFlipImage}->show if !$noButton;
            $self->{backFlipImage}->hide;
            #$self->animateImg($self->{backPic}, $self->{imageFile});
        }
        else
        {
            $self->setImg($self->{backPic});
            $self->{backFlipImage}->show if !$noButton;
            $self->{frontFlipImage}->hide;
            #$self->animateImg($self->{imageFile}, $self->{backPic});
        }
        $self->{flipped} = !$self->{flipped};
    }

    sub setLinkedValue
    {
        my ($self, $linkedValue) = @_;
        $self->setChanged if $self->{trackState};
        $self->{backPic} = $linkedValue;
        $self->setImg($linkedValue) if $self->{flipped};
    }

    sub getLinkedValue
    {
        my ($self, $linkedValue) = @_;
        return $self->{backPic};
    }

    sub setLinkedComponent
    {
        my ($self, $linked) = @_;
        $self->{linkedComponent} = $linked;

        $self->{flipActivated} = 1;
        $self->{frontFlipImage} = Gtk2::Image->new_from_file($ENV{GCS_SHARE_DIR}.'/overlays/flip.png');
        $self->{frontFlipImage}->set_no_show_all(1);
        $self->{backFlipImage} = Gtk2::Image->new_from_file($ENV{GCS_SHARE_DIR}.'/overlays/flip2.png');
        $self->{backFlipImage}->set_no_show_all(1);
        my $pixbuf = $self->{frontFlipImage}->get_pixbuf;
        my ($picWidth, $picHeight) = ($pixbuf->get_width, $pixbuf->get_height);

        $self->{addedFlipButton} = 0;
        $self->signal_connect('enter' => sub {
            return if ! $self->{flipActivated};
            if (!$self->{addedFlipButton})
            {
                $self->{flipX} = $self->{width} - $picWidth - $GCUtils::margin;
                $self->{flipY} = $self->{height} - $picHeight - $GCUtils::margin;
                $self->{layout}->put($self->{frontFlipImage},
                                     $self->{flipX},
                                     $self->{flipY});
                $self->{layout}->put($self->{backFlipImage},
                                     $self->{flipX},
                                     $self->{flipY});
                $self->{addedFlipButton} = 1;
            }
            if ($self->{flipped})
            {
                $self->{backFlipImage}->show;
            }
            else
            {
                $self->{frontFlipImage}->show;
            }
        });
        $self->signal_connect('leave' => sub {
            $self->{frontFlipImage}->hide;
            $self->{backFlipImage}->hide;
        });
        $self->signal_connect('button-release-event' => sub {
            return 0 if ! $self->{flipActivated};
            my ($button, $event) = @_;
            my ($x, $y) = $event->get_coords;
            if (($x > $self->{flipX}) && ($y > $self->{flipY}))
            {
                $self->flipImage;
                $self->set_sensitive(0);
                $self->released;
                $self->set_sensitive(1);
                return 1;
            }
            else
            {
                return 0;
            }
        });
        
        $self->signal_connect('key-press-event' => sub {
            return 0 if ! $self->{flipActivated};
            my ($widget, $event) = @_;
            my $key = Gtk2::Gdk->keyval_name($event->keyval);
            
            if (($key eq 'f') || ($key eq 'BackSpace'))
            {
                $self->flipImage;
                return 1;
            }
            return 0;
        });
        
        $self->signal_connect('query_tooltip' => sub {
            my ($window, $x, $y, $keyboard_mode, $tip) = @_;
            return if $self->{settingTip};
            $self->{settingTip} = 1;
            if ($self->{flipActivated} && ($x > $self->{flipX}) && ($y > $self->{flipY}))
            {
                $self->{tooltips}->set_tip($self, $self->{flipped} ?
                                                  $self->{parent}->{lang}->{ContextImgFront} :
                                                  $self->{parent}->{lang}->{ContextImgBack});
            }
            else
            {
                $self->{tooltips}->set_tip($self, $self->{tip});
            }
            $self->{settingTip} = 0;
            return 0;
        });
        
    }

    sub clear
    {
        my $self = shift;
        $self->setValue('');
    }

    sub new
    {
        my ($proto, $parent, $img, $isCover, $default) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new;
        bless ($self, $class);

        $default = 'view' if !$default;

        $self->{layout} = new Gtk2::Fixed;
        $self->{layout}->put($img, 0, 0);
        $self->add($self->{layout});
        
        $self->{img} = $img;
        $self->{default} = $default;
        #$self->set_size_request(130,170);
        $self->{width} = -1;
        $self->{height} = -1;
        $self->{imageFile} = $img->getValue;

        # True if this is the cover used in image mode
        $self->{isCover} = $isCover;

        $self->{parent} = $parent;
        $self->getMainParent;
        $self->{tooltips} = $self->{mainParent}->{tooltips};

        $self->{tip} = ($default eq 'open') ? $parent->{lang}->{PanelImageTipOpen} : $parent->{lang}->{PanelImageTipView};
        $self->{tip} .= $parent->{lang}->{PanelImageTipMenu};
        $self->{tooltips}->set_tip($self, $self->{tip});

        $self->signal_connect('button_press_event' => sub {
            my ($widget, $event) = @_;
            return 0 if $event->button ne 3;
            $self->createContextMenu();
            $self->{imgContext}->popup(undef, undef, undef, undef, $event->button, $event->time);
            return 0;
        });

        $self->signal_connect('clicked' => sub {
            $self->changeImage if $self->{default} eq 'open';
            $self->showImage if $self->{default} eq 'view';
            return 1;
        });

        #Drag and drop a picture on a button
        $self->drag_dest_set('all', ['copy','private','default','move','link','ask']);
        my $target_list = Gtk2::TargetList->new();
        my $atom1 = Gtk2::Gdk::Atom->new('text/uri-list');
        my $atom2 = Gtk2::Gdk::Atom->new('text/plain');
        $target_list->add($atom1, 0, 0);
        $target_list->add($atom2, 0, 0);
        if ($^O =~ /win32/i)
        {
            my $atom2 = Gtk2::Gdk::Atom->new('DROPFILES_DND');
            $target_list->add($atom2, 0, 0);
        }
        $self->drag_dest_set_target_list($target_list);
        $self->signal_connect(drag_data_received => sub {
            my ($widget, $context, $widget_x, $widget_y, $data, $info,$time) = @_;
            my @files = split /\n/, $data->data;
            my $fileName = $files[0];
            if ($fileName =~ /^http/)
            {
                $fileName = $self->{mainParent}->downloadPicture($fileName);
            }
            else
            {
                $fileName =  Glib::filename_from_uri  $fileName; 
                $fileName = decode('utf8', $fileName);           
                $fileName =~ s|^file://?(.*)\W*$|$1|;
                $fileName =~ s|^/*|| if ($^O =~ /win32/i);
                $fileName =~ s/.$//ms;
                $fileName =~ s/%20/ /g;
            }
            $self->changeImage($fileName);
        });

        $self->{previousDirectory} = '';
        $self->{flipped} = 0;
        $self->{flipActivated} = 0;

        return $self;
    }
    
    sub createContextMenu
    {
        my $self = shift;
        
        my $parent;
        $parent = $self->{parent};

        $self->{imgContext} = new Gtk2::Menu;

        if ($parent->{options}->tearoffMenus)
        {
            $self->{imgContext}->append(Gtk2::TearoffMenuItem->new());
        }

        $self->{itemOpen} = Gtk2::ImageMenuItem->new_with_mnemonic($parent->{lang}->{ContextChooseImage});
        my $itemOpenImage = Gtk2::Image->new_from_stock('gtk-open', 'menu');
        $self->{itemOpen}->set_image($itemOpenImage);
        # This item will be deactivated if the component is locked
        $self->{itemOpen}->set_sensitive(!$self->{locked});
        $self->{itemOpen}->signal_connect("activate" , sub {
            $self->changeImage;
        });
        $self->{imgContext}->append($self->{itemOpen});
        $self->{itemShow} = Gtk2::ImageMenuItem->new_from_stock('gtk-zoom-100',undef);
        $self->{itemShow}->signal_connect("activate" , sub {
            $self->showImage;
        });
        # Disable for default image
        $self->{itemShow}->set_sensitive(0) if $self->isDefaultImage();
        $self->{imgContext}->append($self->{itemShow});

        if ($self->{linkedComponent})
        {
            $self->{itemFlip} = Gtk2::MenuItem->new($self->{flipped} ?
                                                        $parent->{lang}->{ContextImgFront} :
                                                        $parent->{lang}->{ContextImgBack});
            $self->{itemFlip}->signal_connect("activate" , sub {
                $self->flipImage;
            });
            $self->{imgContext}->append($self->{itemFlip});
        }

        $self->{itemClear} = Gtk2::ImageMenuItem->new_from_stock('gtk-clear',undef);
        # This item will be deactivated if the component is locked
        $self->{itemClear}->set_sensitive(!$self->{locked});
        $self->{itemClear}->signal_connect("activate" , sub {
            $self->clearImage;
        });
        $self->{imgContext}->append($self->{itemClear});        
        # Disable for default image
        $self->{itemClear}->set_sensitive(0) if $self->isDefaultImage();
        $self->{imgContext}->show_all;

        my $itemOpenWith = Gtk2::MenuItem->new_with_mnemonic($parent->{lang}->{ContextOpenWith});
        $self->{menuOpenWith} = Gtk2::Menu->new;

        if ($hasGnome2VFS && ($parent->{options}->programs eq 'system' || $parent->{options}->imageEditor eq ''))
        { 
            # Get applications for mime types corresponding with image

            # Get all editors/viewers for jpeg file format
            my $mimeTest = Gnome2::VFS::Mime::Type->new ("image/jpeg");
            my @mimeList = $mimeTest->get_short_list_applications;

            # Add applications to open with list
            foreach (@mimeList)
            {
                my $launchApp = $_;
                my $item = Gtk2::MenuItem->new_with_mnemonic($launchApp->get_name);
                $item->signal_connect ('activate' => sub {
                        $self->openWith($launchApp);
                });
                $self->{menuOpenWith}->append($item);
            }

            #Gnome2::VFS -> shutdown();
        }
        elsif ($parent->{options}->programs eq 'system' || $parent->{options}->imageEditor eq '')
        {
            # Can't parse applications, so use system default app  
            my $item = Gtk2::MenuItem->new_with_mnemonic($parent->{lang}->{ContextImageEditor});

            my $command;
            $command = ($^O =~ /win32/i) ? ''
                     : ($^O =~ /macos/i) ? '/usr/bin/open'
                     :                     $ENV{GCS_SHARE_DIR}.'/helpers/xdg-open';

            # Not sure if this is correct, haven't tested with Windows:
            if ($^O =~ /win32/i)
            {
                $command = '"'.$command.'"' if $command;
            }

            $item->signal_connect ('activate' => sub {
                     $self->openWithImageEditor($command);
            });

            $self->{menuOpenWith}->append($item);
        }
        else
        {
            # Use user defined app  
            my $item = Gtk2::MenuItem->new_with_mnemonic($parent->{lang}->{ContextImageEditor});
            $item->signal_connect ('activate' => sub {
                     $self->openWithImageEditor($parent->{options}->imageEditor);
            });

            $self->{menuOpenWith}->append($item);
        }


        $itemOpenWith->set_submenu($self->{menuOpenWith});
       
        # Disable for default image
        $itemOpenWith->set_sensitive(0) if $self->isDefaultImage();

        $self->{imgContext}->append($itemOpenWith);
        $self->{imgContext}->show_all;

    }

    sub activateStateTracking
    {
        my $self = shift;
        $self->{trackState} = 1;
    }

    sub lock
    {
        my ($self, $locked) = @_;
    
        $self->{locked} = $locked;
    }
    
    sub showImage
    {
        my $self = shift;
        $self->{mainParent}->launch($self->{img}->getValue, 'image');
    }
    
    sub isDefaultImage
    {
        my ($self) = @_;

        if ($self->{img}->getFile eq $self->{parent}->{defaultImage})
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }

    sub openWith
    {
        my ($self, $app) = @_;
        my $cmd;
        my $escFileName;

        # Ultra hacky workaround, because $app->{launch} segfaults. See http://bugzilla.gnome.org/show_bug.cgi?id=315049
        # Probably should change to gvfs when perl modules are available

        if ($app->{command} =~ m/(\w*)/)
        {
            $cmd = $1;
        }

        $escFileName = $self->{img}->getFile;
        $escFileName =~ s/\ /%20/g;
        $self->editPicture("$cmd file://$escFileName");
    }

    sub openWithImageEditor
    {
        my ($self, $editor) = @_;
        my $file = $self->{img}->getFile;
        $file =~ s|/|\\|g if ($^O =~ /win32/i);
        $self->editPicture("$editor \"$file\"");
    }

    sub editPicture
    {
        my ($self, $commandLine) = @_;
        my $file = $self->{img}->getFile;

        my $flipped = $self->{flipped};
        $self->{fileWatchDays} = -M $file; 
        $self->{fileWatcher} = Glib::Timeout->add(1000, sub {
            my $currentDays = -M $file;
            if ($currentDays < $self->{fileWatchDays})
            {
                $self->changeState;
                # We remove it from the pixbuf cache in items view. Useful
                # for detailed list to be sure it will be re-loaded
                delete $self->{mainParent}->{itemsView}->{cache}->{$file}
                    if $self->{mainParent}->{itemsView}->{cache};
                $self->setValueWithParent($self->{img}->getValue, 1, $flipped);
                $self->{fileWatchDays} = $currentDays; 
            }
            return 1;
        });
        $self->{mainParent}->launch($commandLine, 'program', 1);
    }

    sub setWidth
    {
        my ($self, $value) = @_;
        $self->{width} = $value;
        $self->set_size_request($value, $self->{height});
        $self->{img}->setWidth($value - $GCUtils::margin);
    }

    sub setHeight
    {
        my ($self, $value) = @_;
        $self->{height} = $value;
        $self->set_size_request($self->{width}, $value);
        $self->{img}->setHeight($value - $GCUtils::margin);
    }
    
}

{
    package GCMenuList;

    use Glib::Object::Subclass
                Gtk2::ComboBox::
    ;
    
    @GCMenuList::ISA = ('Gtk2::ComboBox', 'GCGraphicComponent');

    our $separatorValue = 'GCSSeparator';

    sub isEmpty
    {
        my $self = shift;
        
        return 1 if ! defined $self->get_active_iter;
        return ($self->{listModel}->get($self->get_active_iter))[1] eq '';
        my $idx = $self->get_history;
        $idx-- if $idx >= $self->{separatorPosition};
        $idx = 0 if $idx < 0;
        return $self->{'values'}->[$idx]->{displayed} eq '';
    }
    
    sub valueToDisplayed
    {
        my ($self, $value) = @_;
    
        foreach (@{$self->{'values'}})
        {
            return $_->{displayed} if $_->{value} eq $value
        }
        return '';
    }
    
    sub getValue
    {
        my ($self, $formatted) = @_;
        my $iter = $self->get_active_iter;
        my $value = '';
        $value = ($self->{listModel}->get($iter))[0] if $iter;
        $value = $self->valueToDisplayed($value) if $formatted;
        return $value;
    }

    sub getDisplayedValue
    {
        my $self = shift;
        my $iter = $self->get_active_iter;
        return ($self->{listModel}->get($iter))[1] if $iter;
        return '';
    }

    sub setValue
    {
        my ($self, $value) = @_;

        $value = 0 if !$value;
        my $i = 0;
        if ($value)
        {
    		foreach (@{$self->{values}})
            {
                last if $_->{value} eq $value;
                $i++;
            }
        }
        $i++ if $i >= $self->{separatorPosition};
        $i-- if ($self->{default} == -1) && ($i >= $self->{count});
        $self->set_active($i)
            if ($i < scalar(@{$self->{values}}));
    }

    sub clear
    {
        my $self = shift;
        $self->set_active(0);
    }

    sub lock
    {
        my ($self, $locked) = @_;
        
        $self->set_sensitive(!$locked);
    }
    
    sub getValues
    {
        my $self = shift;
        
        my @values;
        return $self->{values};
    }
    
    sub setValues
    {
        my ($self, $values, $separatorPosition, $preserveValue) = @_;
        if ($self->{title})
        {
            $separatorPosition = 1;
            unshift @$values, {value => -1, displayed => $self->{title}};
        }
        my $model = $self->{listModel};
        my $previous = $self->getValue if $preserveValue;
        $self->{values} = $values;
        $self->{separatorPosition} = $separatorPosition || 9999;

        $model->clear;
        my $i = 0;
        foreach (@$values)
        {
            if ($i == $self->{separatorPosition})
            {
                $model->set($model->append, 0 => $GCMenuList::separatorValue, 1 => '');
                $i++;
            }
            $model->set($model->append,
                        0 => $_->{value},
                        1 => $_->{displayed});
            $i++;
        }

        $self->{count} = $i;
        $self->setValue($previous) if $preserveValue;
        $self->set_active(0) if !$preserveValue;
    }
    
    sub setLastForDefault
    {
        my $self = shift;
        $self->{default} = -1;
    }

    sub setTitle
    {
        my ($self, $title) = @_;
        $self->{title} = $title;
    }

    sub new
    {
        my ($proto, $values, $separatorPosition) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new;
        bless ($self, $class);

        $self->{listModel} = Gtk2::ListStore->new('Glib::String', 'Glib::String');
        $self->set_model($self->{listModel});
        my $renderer = Gtk2::CellRendererText->new;
        $self->pack_start($renderer, 1);
        $self->add_attribute($renderer, text => 1);
        $self->set_row_separator_func(sub {
            my ($model, $iter) = @_;
            my @values = $model->get($iter, 0);
            my $val = '';
            $val = $values[0] if defined $values[0];
            return $val eq $GCMenuList::separatorValue;
        });

        $self->setValues($values, $separatorPosition) if $values;
        $self->{default} = 0;
        $self->set_focus_on_click(1);
        return $self;
    }

    sub activateStateTracking
    {
        my $self = shift;
        $self->signal_connect('changed' => sub {
            $self->setChanged;
        });
    }
}

{
    package GCHeaderLabel;

    use Glib::Object::Subclass
                Gtk2::Label::
    ;
    
    @GCHeaderLabel::ISA = ('Gtk2::Label', 'GCGraphicComponent');
    
    sub new
    {
        my ($proto, $label) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new;
        bless ($self, $class);

        $self->setText($label);
        $self->set_alignment(0,1);
        
        return $self;
    }
    
    sub setText
    {
        my ($self, $label) = @_;
        $self->set_markup('<b>'.$label.'</b>');        
    }
}

{
    package GCLabel;
    
    use Glib::Object::Subclass
                Gtk2::Label::
    ;
    
    @GCLabel::ISA = ('Gtk2::Label', 'GCGraphicComponent');

    sub new
    {
        my ($proto, $label, $disableMarkup) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new;
        bless ($self, $class);
        $self->set_markup($label) unless $disableMarkup;
        $self->set_label($label) if $disableMarkup;
        $self->set_alignment(0,0.5);
        return $self;
    }
}

{
    package GCColorLabel;
    
    use Glib::Object::Subclass
                Gtk2::EventBox::
    ;
    
    @GCColorLabel::ISA = ('Gtk2::EventBox', 'GCGraphicComponent', 'GCPseudoHistoryComponent');

    sub new
    {
        my ($proto, $color, $listType) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new;

        bless ($self, $class);

        $listType = 0 if !$listType;
        $self->modify_bg('normal', $color);
        $self->{label} = Gtk2::Label->new;
        $self->{label}->show;
        $self->{hboxFill} = new Gtk2::HBox(0,0);
        $self->{hboxFill}->pack_start($self->{label},1,1,0);
        $self->add($self->{hboxFill});
        $self->set_alignment(0,0.5);
        $self->initHistory($listType);

        return $self;
    }

    sub acceptMarkup
    {
        my $self = shift;
        return 1;
    }

    sub setMarkup
    {
        my ($self, $text) = @_;
        
        $self->{label}->set_markup($text);
    }

    sub getValue
    {
        my $self = shift;

        (my $label = $self->{label}->get_label) =~ s/<.*?>(.*?)<\/.*?>/$1/g;
        return $label;
    }

    sub setBgColor
    {
        my ($self, $color) = @_;
        $self->modify_bg('normal', $color);
    }

    sub set_justify
    {
        my ($self, $value) = @_;
        $self->{label}->set_justify($value);
        $self->{label}->set_alignment(0.5,0) if $value eq 'center';
        $self->{label}->set_alignment(1,0) if $value eq 'right';
    }
    
    sub AUTOLOAD
    {
        my $self = shift;
        my $name = our $AUTOLOAD;
        return if $name =~ /::DESTROY$/;
        $name =~ s/.*?::(.*)/$1/;
        $self->{label}->$name(@_);
    }
}

{
    package GCColorLink;
    
    use Glib::Object::Subclass
                Gtk2::EventBox::
    ;
    
    @GCColorLink::ISA = ('GCColorLabel');

    sub new
    {
        my ($proto, $color, $opener) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($color);
        bless ($self, $class);
        $self->{opener} = $opener;
        $self->signal_connect('button-release-event' => sub {
            my $value = $self->getValue;
            return if !$value;
            $self->{opener}->launch($value, 'url');
        });
        $self->signal_connect('enter-notify-event' => sub {
            $self->window->set_cursor(Gtk2::Gdk::Cursor->new('hand2'))
                if $self->getValue;
        });
        #$self->window->set_cursor(Gtk2::Gdk::Cursor->new('watch'));
        return $self;
    }
}

{
    package GCColorLongLabel;

    use Glib::Object::Subclass
                Gtk2::TextView::
    ;
    
    @GCColorLongLabel::ISA = ('Gtk2::TextView', 'GCGraphicComponent');

    sub new
    {
        my ($proto, $color) = @_;
        my $class = ref($proto) || $proto;
    
        my $self = $class->SUPER::new;
        bless ($self, $class);

        $self->set_editable(0);
        $self->set_wrap_mode('word');
        $self->{background} = $color;
        $self->modify_base('normal', $color);
        $self->modify_bg('normal', $color);
        $self->set_border_width($GCUtils::halfMargin);

        my $layout = $self->create_pango_layout('G');
        my (undef, $rect) = $layout->get_pixel_extents;
        $self->{em} = 1.5 * $rect->{height};        


        return $self;
    }
    
    sub acceptMarkup
    {
        my $self = shift;
        return 1;
    }

    sub setMarkup
    {
        my ($self, $text) = @_;
        
        #$text =~ s/&/&amp;/g;
        if ($self->{resize})
        {
            $self->resize;
        }
        else
        {
            my $buffer = $self->get_buffer;
            $self->get_buffer->set_text('');
            $text =~ s|<span ([^>]*?)>([^<]*?)</span>|$2|;
            if ($self->{spanTag})
            {
                $buffer->get('tag-table')->remove($self->{spanTag});
            }
            $self->{spanTag} = $buffer->create_tag('span', $self->getTagFromSpan($1));
            $buffer->insert_with_tags_by_name ($buffer->get_start_iter, $text, 'span');
        }
    }

    sub getValue
    {
        my $self = shift;

        (my $label = $self) =~ s/<.*?>(.*?)<\/.*?>/$1/g;
        return $label;
    }

}

{
    package GCColorTable;
    
    use Glib::Object::Subclass
                Gtk2::Table::
    ;
    
    @GCColorTable::ISA = ('Gtk2::Table', 'GCGraphicComponent', 'GCPseudoHistoryComponent');

    sub new
    {
        my ($proto, $columns, $labels, $headerStyle, $contentStyle, $topHeader) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new(1, $columns);

        bless ($self, $class);

        $self->set_col_spacings(3);
        $self->set_row_spacings(3);
        $self->{number} = $columns;
        $self->{style} = $contentStyle;
        $self->{firstRow} = 0;
        if ($topHeader)
        {
            $self->{firstRow}++;
            my $top = new GCColorLabel($headerStyle->{bgColor});
            $top->set_padding($GCUtils::halfMargin,$GCUtils::halfMargin);
            $top->setMarkup('<span '.$headerStyle->{style}.'>'.$topHeader.'</span>');
            $self->attach($top, 0, $columns, 0, 1, ['expand', 'fill'], 'fill', 0, 0);            
        }
        my $i;
        if ($columns > 1)
        {
            for $i(0..($columns - 1))
            {
                my $header = new GCColorLabel($headerStyle->{bgColor});
                $header->set_padding($GCUtils::halfMargin,$GCUtils::halfMargin);
                $header->setMarkup('<span '.$headerStyle->{style}.'>'.$labels->[$i].'</span>');
                $self->attach($header, $i, $i + 1, $self->{firstRow}, $self->{firstRow} + 1, ['expand', 'fill'], 'fill', 0, 0);
            }
            $self->{firstRow}++;
        }
        $self->initHistory($columns);
        return $self;
    }

    sub setValue
    {
        my ($self, $value) = @_;
        $self->{value} = $value;
 
        foreach (@{$self->{labels}})
        {
            $self->remove($_);
            $_->destroy;
        }

        $self->{labels} = [];
        my @lines;
        if (ref($value) eq 'ARRAY')
        {
            @lines = @$value;
        }
        else
        {
            $value =~ s/^\s*//;
            @lines = split m/,/, $value;
        }
        if ($#lines < 0)
        {
            $self->hide_all;
            return;
        }
        my $i = $self->{firstRow};
        $self->resize($#lines + 1 + $self->{firstRow}, $self->{number});
        foreach (@lines)
        {
            my @cols;
            if (ref($value) eq 'ARRAY')
            {
                @cols = @$_;
            }
            else
            {
                @cols = split m/;/, $_;
            }
            my $j = 0;
            for my $col(@cols)
            {
                # TODO Optimize GCColorLongLabel. It offers a better display (no scrollbar)
                # but it slows down the display.
                my $label = new GCColorLabel($self->{style}->{bgColor});
                $label->set_padding($GCUtils::halfMargin,$GCUtils::halfMargin);
                #my $label = new GCColorLongLabel($self->{style}->{bgColor}, '2em');
                $label->setMarkup('<span '.$self->{style}->{style}.'>'.$self->cleanMarkup($col, 1).'</span>');
                $self->attach($label, $j, $j + 1, $i, $i + 1, ['expand', 'fill'], 'fill', 0, 0);
                push @{$self->{labels}}, $label;
                $j++;
            }
            $i++;
        }
        $self->show_all;
    }

    sub getValue
    {
        my $self = shift;
        return $self->{value};
    }
    
    sub setBgColor
    {
        my ($self, $color) = @_;
        return;
    }

    sub set_justify
    {
        my ($self, $value) = @_;
        return;
    }
    
}

{
    package GCColorText;

    use Glib::Object::Subclass
                Gtk2::ScrolledWindow::
    ;
    
    @GCColorText::ISA = ('Gtk2::ScrolledWindow', 'GCGraphicComponent', 'GCPseudoHistoryComponent');

    sub new
    {
        my ($proto, $color, $height, $listType) = @_;
        my $class = ref($proto) || $proto;
    
        my $self = $class->SUPER::new;
        bless ($self, $class);

        $listType = 0 if !$listType;
        $self->{text} = new Gtk2::TextView;
        $self->{text}->set_editable(0);
        $self->{text}->set_wrap_mode('word');
        $self->{background} = $color;
        $self->{text}->modify_base('normal', $color);
        $self->{text}->modify_bg('normal', $color);
        $self->{text}->set_border_width($GCUtils::halfMargin);
        $self->set_border_width(0);
        $self->set_shadow_type('none');
        $self->set_policy('automatic', 'automatic');
        $self->add($self->{text});
        $self->initHistory($listType);

        my $layout = $self->create_pango_layout('G');
        my (undef, $rect) = $layout->get_pixel_extents;
        $self->{em} = 1.5 * $rect->{height};        

        $self->setHeight($height) if $height;

        return $self;
    }
    
    sub acceptMarkup
    {
        my $self = shift;
        return 1;
    }

    sub setMarkup
    {
        my ($self, $text) = @_;
        
        if ($self->{resize})
        {
            $self->resize;
        }
        else
        {
            my $buffer = $self->{text}->get_buffer;
            $self->{text}->get_buffer->set_text('');
            $text =~ s|<span ([^>]*?)>([^<]*?)</span>|$2|;
            if ($self->{spanTag})
            {
                $buffer->get('tag-table')->remove($self->{spanTag});
            }
            $self->{spanTag} = $buffer->create_tag('span', $self->getTagFromSpan($1));
            $buffer->insert_with_tags_by_name ($buffer->get_start_iter, $text, 'span');
        }
    }

    sub getValue
    {
        my $self = shift;

        (my $label = $self->{text}) =~ s/<.*?>(.*?)<\/.*?>/$1/g;
        return $label;
    }

    sub setHeight
    {
        my ($self, $height) = @_;
        $height =~ s/^([0-9]+)em$/$1*$self->{em}/e;
        $self->set_size_request(-1, $height);
    }

    sub AUTOLOAD
    {
        my $self = shift;
        my $name = our $AUTOLOAD;
        return if $name =~ /::DESTROY$/;
        $name =~ s/.*?::(.*)/$1/;
        $self->{text}->$name(@_);
    }
}

{
    package GCColorExpander;
    
    use Glib::Object::Subclass
                Gtk2::Expander::
    ;
    
    @GCColorExpander::ISA = ('GCExpander');

    sub new
    {
        my ($proto, $label, $bgColor, $fgStyle) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($label);

        bless ($self, $class);
        $self->{label} = new GCColorLabel($bgColor);
        $self->set_label_widget($self->{label});
        $self->{fgStyle} = $fgStyle;

        return $self;
    }
    
    sub setValue
    {
        my ($self, $label, $description) = @_;

        $label = '<span '.$self->{fgStyle}.">$label</span>";

        $self->{label}->set_markup($label);
        if ($description)
        {
            $self->{description}->set_label($description);
            $self->{description}->show;
        }
        else
        {
            $self->{description}->set_label('');
            $self->{description}->hide;
        }


    }
}

{
    package GCDialogHeader;
    
    use Glib::Object::Subclass
                Gtk2::HBox::
    ;
    
    @GCDialogHeader::ISA = ('Gtk2::HBox', 'GCGraphicComponent');
    
    sub new
    {
        my ($proto, $text, $imageStock, $logosDir) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new;

        bless ($self, $class);
        
        $self->{label} = new Gtk2::Label;
        $self->{label}->set_markup("<span size='large' weight='bold'>$text</span>");
        $self->{label}->set_alignment(0,0.5);
        
        if (-f $logosDir.$imageStock.'.png')
        {
            $self->{image} = Gtk2::Image->new_from_file($logosDir.$imageStock.'.png');
            $self->pack_start($self->{image},0,1,5);
        }
        
        $self->pack_start($self->{label},0,1,5);
        
        return $self;
    }
}

{
    package GCImageBox;
    
    use Glib::Object::Subclass
                Gtk2::VBox::
    ;
    
    @GCImageBox::ISA = ('Gtk2::VBox', 'GCGraphicComponent');
    
    sub new_from_file
    {
        my ($proto, $imageFile, $label) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();

        bless ($self, $class);

        my $image = Gtk2::Image->new_from_file($imageFile);
        $self->init($image, $label);
        
        return $self;
    }
    sub new_from_stock
    {
        my ($proto, $stockId, $label) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();

        bless ($self, $class);

        my $image = Gtk2::Image->new_from_stock($stockId, 'large-toolbar');
        $self->init($image, $label);
         
        return $self;        
    }
    
    sub init
    {
        my ($self, $image, $label) = @_;
        
        $self->{label} = new Gtk2::Label($label);
        
        $self->pack_start($image, 0, 0, 0);
        $self->pack_start($self->{label}, 0, 0, 0);
        
        $self->show_all;
    }
}

{
    package GCGroup;

    use Glib::Object::Subclass
                Gtk2::Frame::
    ;
    
    @GCGroup::ISA = ('Gtk2::Frame', 'GCGraphicComponent');
    
    sub new
    {
        my ($proto, $title) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new;

        bless ($self, $class);

        $self->set_shadow_type('none');
        $self->set_border_width($GCUtils::margin);
        $self->{label} = new Gtk2::Label;
        $self->{label}->set_padding(0,0);
        #$label->set_border_width(0);
        $self->setLabel($title);
        $self->set_label_widget($self->{label});
        $self->set_label_align(0,0);

        $self->{marginBox} = new Gtk2::HBox(0,0);
        $self->{marginBox}->set_border_width($GCUtils::halfMargin);
        $self->add($self->{marginBox});

        return $self;        
    }
    
    sub setLabel
    {
        my ($self, $label) = @_;
        
        $self->{label}->set_markup('<b>'.$label.'</b>');
    }
    
    sub addWidget
    {
        my ($self, $widget, $margin) = @_;
        $margin = $GCUtils::halfMargin if !$margin;
        $self->{marginBox}->pack_start($widget, 1, 1, $margin);
    }
    
    sub setPadding
    {
        my ($self, $value) = @_;
        
        $self->{marginBox}->set_border_width($value);
    }
}

{
    package GCExpander;
    
    use Glib::Object::Subclass
                Gtk2::Expander::
    ;
    
    @GCExpander::ISA = ('Gtk2::Expander', 'GCGraphicComponent');
    
    sub new
    {
        my ($proto, $label, $bold) = @_;
        my $class = ref($proto) || $proto;
    
        my $self = $class->SUPER::new($label);

        bless ($self, $class);
        $self->{hbox} = new Gtk2::HBox(0,0);
        $self->{label} = new Gtk2::Label($label);
        $self->{label}->set_alignment(0,0.5);
        $self->{label}->set_markup("<b>$label</b>")
            if $bold;
        $self->{description} = new Gtk2::Label;
        $self->{description}->set_alignment(0,0);
        eval {$self->{description}->set_line_wrap_mode('word');};
        $self->{hbox}->pack_start($self->{label}, 0, 0, 0);
        $self->{hbox}->pack_start($self->{description}, 1, 1, 0);
        $self->set_label_widget($self->{hbox});
        $self->{signalHandler} = undef;
        return $self;
    }

    sub setMode
    {
        my ($self, $mode) = @_;
        if ($mode eq 'asis')
        {
            $self->{description}->set_ellipsize('none');
            $self->{description}->set_line_wrap(0);
            if ($self->{signalHandler})
            {
                $self->signal_handler_disconnect($self->{signalHandler});
                $self->{signalHandler} = undef;
                $self->{description}->set_size_request(-1, -1);
            }
        }
        else
        {
            $self->{signalHandler} = $self->signal_connect('size-allocate' => sub {
                my $width = $self->allocation->width 
                          - $self->{label}->allocation->width
                          - ( 4 * $GCUtils::margin);
                $self->{description}->set_size_request(($width >= -1) ? $width : -1 , -1);
                return 0;
            });
            if ($mode eq 'wrap')
            {
                $self->{description}->set_ellipsize('none');
                $self->{description}->set_line_wrap(1);
            }
            else
            {
                $self->{description}->set_ellipsize('end');
                $self->{description}->set_line_wrap(0);
            }
        }
    }

    sub setValue
    {
        my ($self, $label, $description) = @_;

        $self->{label}->set_label($label);
        if ($description)
        {
            $self->{description}->set_label($description);
            $self->{description}->show;
        }
        else
        {
            $self->{description}->set_label('');
            $self->{description}->hide;
        }
    }
}

{
    package GCFieldSelector;

    use Glib::Object::Subclass
                Gtk2::ComboBox::
    ;
    
    @GCFieldSelector::ISA = ('GCMenuList');
    our $anyFieldValue = 'GCAnyField';
    
    sub valueToDisplayed
    {
        my ($self, $value) = @_;
        return '';
    }
    
    sub setValue
    {
        my ($self, $value) = @_;

        $self->{listModel}->foreach(sub {
            my ($model, $path, $iter) = @_;
            if ($model->get_value($iter, 0) eq $value)
            {
                $self->set_active_iter($iter);
                return 1;
            }
            return 0;
        });
    }
    
    sub getValues
    {
        my $self = shift;
        return [];
    }
    
    sub setValues
    {
        my ($self, $values, $separatorPosition, $preserveValue) = @_;
        return;
    }
    
    sub new
    {
        my ($proto, $withImages, $model, $advancedFilter, $withAnyField, $withoutEmpty, $uniqueType) = @_;
        my $class = ref($proto) || $proto;
        my $self = Gtk2::ComboBox->new;
        bless($self, $class);
        $self->{withImages} = $withImages;
        $self->{advancedFilter} = $advancedFilter;
        $self->{withAnyField} = $withAnyField;
        $self->{withoutEmpty} = $withoutEmpty;
        $self->{uniqueType} = $uniqueType;
        
        $self->{listModel} = Gtk2::TreeStore->new('Glib::String', 'Glib::String');
        $self->set_model($self->{listModel});
        my $renderer = Gtk2::CellRendererText->new;
        $self->pack_start($renderer, 1);
        $self->add_attribute($renderer, text => 1);

        $self->set_cell_data_func($renderer, sub {
            my ($layout, $cell, $model, $iter) = @_;
            my $sensitive = !$model->iter_has_child($iter);
            $cell->set('sensitive', $sensitive);
        });

        $self->{default} = 0;
        $self->set_focus_on_click(1);
        
        $self->setModel($model) if $model;

        return $self;
    }

    sub setModel
    {
        my ($self, $model) = @_;

        $self->{listModel}->clear;
        my $field;
        my @fieldsInfo = @{$model->getDisplayedInfo};
        
        if (! $self->{withoutEmpty})
        {
            $self->{listModel}->set($self->{listModel}->append(undef),
                                0 => '',
                                1 => '');
        }
        if ($self->{withAnyField})
        {
            $self->{listModel}->set($self->{listModel}->append(undef),
                                0 => $anyFieldValue,
                                1 => $model->getDisplayedText('AdvancedSearchAnyField'));
        }
        
        foreach my $group(@fieldsInfo)
        {
            my @fields;
            foreach $field (@{$group->{items}})
            {
                my $id = $field->{id};
                next if ($model->{fieldsInfo}->{$id}->{type} eq 'image') && (!$self->{withImages});
                next if ($self->{advancedFilter}
                      && (
                             ($id eq $model->{commonFields}->{id})
                          || ($id eq $model->{commonFields}->{title})
                          || ($id eq $model->{commonFields}->{url})
                         )
                        );
                next if ! $field->{label};
                next if $self->{uniqueType} && ($self->{uniqueType} ne $model->{fieldsInfo}->{$id}->{type});
                push @fields, $field;
            }
            if (scalar @fields)
            {
                my $groupIter = $self->{listModel}->append(undef);
                $self->{listModel}->set($groupIter,
                                    0 => undef,
                                    1 => $group->{title});
                foreach $field(sort {$a->{label} cmp $b->{label}} @fields)
                {
                    my $fieldIter = $self->{listModel}->append($groupIter);
                    $self->{listModel}->set($fieldIter,
                                        0 => $field->{id},
                                        1 => $field->{label});
                }
            }
        }
        $self->{model} = $model;
     }
    sub activateStateTracking
    {
        my $self = shift;
    }

    # Create a widget suitable to enter a value according to current field type
    # It will destroy the current widget if it exists
    sub createEntryWidget
    {
        # $parent is the class that contains needed information
        # $comparison is the kind of comparison. Mainly useful if it is 'range' to create 2 fields
        # $currentWidget is the one we are replacing
        my ($self, $parent, $comparison, $currentWidget) = @_;
        my $value;
        if ($currentWidget)
        {
            $value = $currentWidget->getValue;
            $currentWidget->destroy;
        }
        my $widget;
        my $field = $self->getValue;
        my $info = $self->{model}->{fieldsInfo}->{$field};

        # These ones are required for createWidget
        $self->{lang} = $parent->{lang};
        $self->{options} = $parent->{options};
        $self->{window} = $parent;

        ($widget, undef) = GCBaseWidgets::createWidget($self, $info, $comparison);

        if ($info->{type} eq 'history text')
        {
            $widget->setValues($parent->{parent}->{panel}->getValues($field));
        }
        elsif ($info->{type} eq 'single list')
        {
            $widget->setValues($parent->{parent}->{panel}->getValues($field)->[0]);            
        }
        $widget->setValue($value);

        return $widget;
    }
}

{
    package GCComparisonSelector;

    use Glib::Object::Subclass
                Gtk2::ComboBox::
    ;
    
    @GCComparisonSelector::ISA = ('GCMenuList');

    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        my $self = $class->SUPER::new;
        bless($self, $class);
        $self->setValues([
                          {value => 'contain', displayed => $parent->{lang}->{ModelFilterContain}},
                          {value => 'notcontain', displayed => $parent->{lang}->{ModelFilterDoesNotContain}},
                          {value => 'regexp', displayed => $parent->{lang}->{ModelFilterRegexp}},
                          {value => 'range', displayed => $parent->{lang}->{ModelFilterRange}},
                          {value => 'eq', displayed => '='},
                          {value => 'lt', displayed => '<'},
                          {value => 'le', displayed => '≤'},
                          {value => 'gt', displayed => '>'},
                          {value => 'ge', displayed => '≥'},
                        ]);
        return $self;
     }
}

1;
