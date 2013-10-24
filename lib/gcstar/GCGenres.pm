package GCGenres;

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

use strict;
use Gtk2;

{
    package GCGenresGroupsDialog;
    use base "Gtk2::Dialog";
    use utf8;

    sub initValues
    {
        use locale;
        
        my $self = shift;
        my $keepPrevious = shift;

        my %directory;

        if ($keepPrevious)
        {
            foreach my $line(@{$self->{categories}->{data}})
            {
                $directory{$line->[0]} = $line->[1];
            }
        }
        else
        {
            foreach (keys %{$self->{convertor}->{groups}})
            {
                $directory{$_} = join ',', @{$self->{convertor}->{groups}->{$_}};
            }
        }

        @{$self->{categories}->{data}} = ();

        my @keys = sort keys %directory;
        @keys = reverse @keys if $self->{reverse};
        foreach (@keys)
        {
            my @infos = [$_, $directory{$_}];
            push @{$self->{categories}->{data}}, @infos;
        }
        $self->{categories}->select(0);
        
   }
    
   sub generateString
   {
        my $self = shift;
        my $genresString;

        foreach (@{$self->{categories}->{data}})
        {
            $genresString .= $_->[0];
            $genresString .= '|'.$_->[1].';';
        }
        $genresString =~ s/.$//;
        return $genresString;        
   }
    
   sub saveValues
   {
        my $self = shift;
       
        my $genresString = $self->generateString;
       
        $self->{options}->genres($genresString);
        $self->{convertor}->loadValues;
        $self->{options}->save;
    }
   
    sub show
    {
        my $self = shift;

        $self->initValues;
        
        $self->SUPER::show();
        $self->show_all;
        
        if ($self->run eq 'ok')
        {
            $self->saveValues;
        }
        $self->hide;
    }

    sub removeCurrent
    {
        my $self = shift;
        my @idx = $self->{categories}->get_selected_indices;
                
        splice @{$self->{categories}->{data}}, $idx[0], 1;
        
        $self->{categories}->select((($idx[0] - 1) > 0) ? ($idx[0] - 1) : 0);
    }
    
    sub add
    {
        my $self = shift;
        
        unshift @{$self->{categories}->{data}}, ['',''];
    }
    
    sub editCurrent
    {
        my $self = shift;
        
        my @idxtmp = $self->{categories}->get_selected_indices;
        my $idx = $idxtmp[0];
        my $line = $self->{categories}->{data}->[$idx];
        
        my $dialog = new Gtk2::Dialog($self->{parent}->{lang}->{GenresModify},
                                                        $self,
                                                        [qw/modal destroy-with-parent/],
                                                        @GCDialogs::okCancelButtons
                                                    );
        
        my $table = new Gtk2::Table(3,2,0);
         
        my $labelCategory = new Gtk2::Label($self->{parent}->{lang}->{GenresCategoryName});
        $table->attach($labelCategory, 0, 1, 0, 1, 'fill', 'fill', 5, 5);
        my $category = new Gtk2::Entry;
        $category->set_text($line->[0]);
        my $hbox1 = new Gtk2::HBox(0,0);
        $hbox1->pack_start($category,1,1,0);
        $table->attach($hbox1, 1, 2, 0, 1, 'fill', 'fill', 5, 5);
 
        my $labelMembers = new Gtk2::Label($self->{parent}->{lang}->{GenresCategoryMembers});
        $table->attach($labelMembers, 0, 1, 1, 2, 'fill', 'fill', 5, 5);
        my $members = new Gtk2::Entry;
        $members->set_text($line->[1]);
        my $hbox2 = new Gtk2::HBox(0,0);
        $hbox2->pack_start($members,1,1,0);
        $table->attach($hbox2, 1, 2, 1, 2, 'fill', 'fill', 5, 5);
       
        my $labelFoo = new Gtk2::Label('');
        my $labelBar = new Gtk2::Label('');
        $table->attach($labelFoo, 0, 1, 2, 3, 'fill', 'fill', 0, 0);
        $table->attach($labelBar, 1, 2, 2, 3, 'expand', 'expand', 0, 0);
       
        $dialog->set_default_size(500,1);
        
        $dialog->vbox->pack_start($table,1,1,0);
        $dialog->vbox->show_all;
                                                    
        if ($dialog->run eq 'ok')
        {
            splice @{$self->{categories}->{data}}, $idx, 1, [$category->get_text, $members->get_text];
        }
        
        $dialog->destroy;
    }
    
    sub load
    {
        my $self = shift;
        
        my $response = $self->{loadDialog}->run;
        if ($response eq 'ok')
        {
            my $fileName = $self->{loadDialog}->get_filename;
            $self->{convertor}->loadValues(undef, $fileName);
            $self->initValues;
        }
        $self->{loadDialog}->hide;
    }

    sub export
    {
        my $self = shift;
        
        my $response = $self->{exportDialog}->run;
        if ($response eq 'ok')
        {
            my $fileName = $self->{exportDialog}->get_filename;
            $self->{convertor}->saveValues($self->generateString, $fileName);
            $self->initValues;
        }
        $self->{exportDialog}->hide;
    }
    
    sub clear
    {
        my $self = shift;
        @{$self->{categories}->{data}} = ();
    }
    
    sub sort
    {
        my $self = shift;

        $self->{reverse} = 1 - $self->{reverse};

        $self->{categories}->get_column(0)->set_sort_indicator(1);
        $self->{categories}->get_column(0)->set_sort_order($self->{reverse} ? 'descending' : 'ascending');
        $self->initValues(1);
    }

    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent->{lang}->{GenresTitle},
                              $parent,
                              [qw/modal destroy-with-parent/],
                              @GCDialogs::okCancelButtons
                            );

        bless ($self, $class);
 
        $self->set_modal(1);
		$self->set_position('center');
        $self->set_default_size(600,400);

        $self->{reverse} = 0;

        $self->{parent} = $parent;
        $self->{lang} = $parent->{lang};
        $self->{options} = $parent->{options};

        my $hbox = new Gtk2::HBox(0,0);
        
        $self->{categories} = new Gtk2::SimpleList($parent->{lang}->{GenresCategoryName} => "text",
                                                $parent->{lang}->{GenresCategoryMembers} => "text");
        $self->{categories}->set_column_editable(0, 1);
        $self->{categories}->set_column_editable(1, 1);
        $self->{categories}->set_rules_hint(1);
        $self->{categories}->get_column(0)->signal_connect('clicked' => sub {
                $self->sort;
            });
        $self->{categories}->get_column(0)->set_sort_indicator(1);
        $self->{categories}->get_column(0)->set_clickable(1);
        for my $i (0..1)
        {
            $self->{categories}->get_column($i)->set_resizable(1);
        }
        $self->{order} = 1;
        $self->{sort} = -1;

        my $scrollPanelList = new Gtk2::ScrolledWindow;
        $scrollPanelList->set_policy ('never', 'automatic');
        $scrollPanelList->set_shadow_type('etched-in');
        $scrollPanelList->add($self->{categories});
        
        my $vboxButtons = new Gtk2::VBox(0,0);
        my $addButton = Gtk2::Button->new_from_stock('gtk-add');
        $addButton->signal_connect('clicked' => sub {
                $self->add;
            });
        my $removeButton = Gtk2::Button->new_from_stock('gtk-remove');
        $removeButton->signal_connect('clicked' => sub {
                $self->removeCurrent;
            });
            
        my $clearButton = Gtk2::Button->new_from_stock('gtk-clear');
        $clearButton->signal_connect('clicked' => sub {
                $self->clear;
            });

        my $editButton = Gtk2::Button->new_from_stock('gtk-properties');
        $editButton->signal_connect('clicked' => sub {
                $self->editCurrent;
            });
        my $openButton = Gtk2::Button->new_from_stock('gtk-open');
        $openButton->signal_connect('clicked' => sub {
                $self->load;
            });
        my $exportButton = Gtk2::Button->new_from_stock('gtk-save-as');
        $exportButton->signal_connect('clicked' => sub {
                $self->export;
            });
            
        $vboxButtons->pack_start($addButton,0,0,5);
        $vboxButtons->pack_start($removeButton,0,0,5);
        $vboxButtons->pack_start($clearButton,0,0,5);
        $vboxButtons->pack_start($editButton,0,0,5);
        $vboxButtons->pack_start($openButton,0,0,5);
        $vboxButtons->pack_start($exportButton,0,0,5);
        
        $hbox->pack_start($scrollPanelList,1,1,10);
        $hbox->pack_start($vboxButtons,0,0,10);
      
        $self->vbox->pack_start($hbox,1,1,10);
        
        $self->{convertor} = new GCGenresConvertor($self->{options});
        
        $self->{loadDialog} = new GCFileChooserDialog($self->{lang}->{GenresLoad}, $self, 'open', 1);
        $self->{loadDialog}->set_pattern_filter((['*.genres', '*.genres']));
        $self->{loadDialog}->set_filename($ENV{GCS_SHARE_DIR}.'/genres/');

        $self->{exportDialog} = new GCFileChooserDialog($self->{lang}->{GenresExport}, $self, 'save');
        
        return $self;
    }
}

{
    package GCGenresConvertor;

    sub new
    {
        my ($proto, $options) = @_;
        my $class = ref($proto) || $proto;
        my $self = {};
        bless ($self, $class);
        
        $self->{options} = $options;
        $self->loadValues($options->genres);

        return $self;
    }
    
    sub loadValues
    {
        my ($self, $values, $file) = @_;

        $self->{groups} = {};
        $self->{genres} = {};

        my @groups;

        if ($file)
        {
            open FG, "< $file" or return -1;
            binmode( FG, ':utf8' );
            foreach(<FG>)
            {
                chomp;
                s/(.*?)\W*$/$1/;
                push (@groups,$_);
            }
            close FG;
        }
        else
        {        
            $values = $self->{options}->genres unless $values;
            @groups = split /;/, $values;
        }
        
        foreach my $group(@groups)
        {
            my @details = split /\|/, $group;
            my $groupName = $details[0];
            my @groupList;
            foreach my $genre(split /,/,$details[1])
            {
                push @groupList, $genre;
                $self->{genres}->{uc $genre} = $groupName;
            }
            $self->{genres}->{uc $groupName} = $groupName;
            $self->{groups}->{$groupName} = \@groupList;
        }
    }
    
    sub saveValues
    {
        my ($self, $value, $file) = @_;
        
        open FG, "> $file" or return -1;
        my @values = split /;/, $value;
        
        foreach (@values)
        {
            print FG "$_\n";
        }
        close FG;
    }
    
    sub convert
    {
        my ($self, $genre) = @_;
        
        my $ucGenre = uc $genre;
        
        return $genre if ! exists $self->{genres}->{$ucGenre};
        return $self->{genres}->{$ucGenre};
    }
}

1;
