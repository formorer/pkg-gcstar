package GCListOptions;

###################################################
#
#  Copyright 2005-2011 Christian Jodar
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
    package GCListOptionsPanel;
    use base "Gtk2::Frame";
    
    sub setView
    {
        my ($self, $view) = @_;
        if ((!exists $self->{currentView}) || ($view != $self->{currentView}))
        {
            $self->{currentView} = $view;
            if ($self->{panel})
            {
                $self->{scroll}->remove($self->{scroll}->get_child);
                $self->{panel}->destroy;
            }
            
            $self->{cancel}->set_sensitive(1);
            $self->{apply}->set_sensitive(1);
    
            if ($view == 0)
            {
                $self->{panel} = new GCEmptyOptionsPanel($self->{parent}->{model}->{preferences}, $self->{parent});
                $self->{cancel}->set_sensitive(0);
                $self->{apply}->set_sensitive(0);
            }
            elsif ($view == 1)
            {
                $self->{panel} = new GCImagesOptionsPanel($self->{parent}->{model}->{preferences}, $self->{parent});
            }
            else
            {
                $self->{panel} = new GCDetailedOptionsPanel($self->{parent}->{model}->{preferences}, $self->{parent});
            }
            $self->{scroll}->add_with_viewport($self->{panel});
            $self->{scroll}->child->set_shadow_type('none');
        }
        $self->{panel}->initValues;
    }
    
    sub new
    {
        my ($proto, $optionsManager, $parent) = @_;
        my $class = ref($proto) || $proto;
        
        my $self  = $class->SUPER::new;
        $self->{optionsManager} = $optionsManager;
        $self->{parent} = $parent;
        $self->{scroll} = new Gtk2::ScrolledWindow;
        $self->{scroll}->set_policy ('automatic', 'automatic');
        $self->{scroll}->set_shadow_type('none');
        $self->{hboxButtons} = new Gtk2::HBox(0,0);
        $self->{cancel} = GCButton->newFromStock('gtk-clear');
        $self->{apply} = GCButton->newFromStock('gtk-apply');
        
        $self->{vbox} = new Gtk2::VBox(0,0);

        $self->{hboxButtons}->pack_end($self->{apply}, 0, 0, $GCUtils::halfMargin);
        $self->{hboxButtons}->pack_end($self->{cancel}, 0, 0, $GCUtils::halfMargin);
        $self->add($self->{vbox});

        $self->{vbox}->pack_start($self->{scroll}, 1, 1, $GCUtils::quarterMargin);
        $self->{vbox}->pack_start($self->{hboxButtons}, 0, 0, $GCUtils::quarterMargin);

        $self->{cancel}->signal_connect('clicked' => sub {
            $self->{panel}->initValues
                if $self->{panel};
        });
        $self->{apply}->signal_connect('clicked' => sub {
            if ($self->{panel})
            {
                $self->{panel}->saveValues;
                $self->{parent}->setItemsList(0, 1);
            }
        });
        

        bless $self, $class;
        return $self;    
    }
}

{
    # Class used when there is no option
    package GCEmptyOptionsPanel;
    use base "Gtk2::VBox";
    use GCStyle;
    
    sub initValues
    {
        my $self = shift;
    }
    sub saveValues
    {
        my $self = shift;
    }
    sub new
    {
        my ($proto, $optionsManager, $parent) = @_;
        my $class = ref($proto) || $proto;
        
        my $self  = $class->SUPER::new(0,0);
        bless $self, $class;
        # TODO to be replaced with a translatable label
        my $label = new GCLabel("No option");
        $self->pack_start($label,1,1,0);
        $self->show_all;
        return $self;
    }        
}
    
{
    # Class used to let user select images options
    package GCImagesOptionsPanel;
    use base "Gtk2::Table";
    #use base "Gtk2::VBox";
    use GCStyle;
    
    sub initValues
    {
        my $self = shift;
        $self->{resizeImgList}->set_active($self->{optionsManager}->resizeImgList);
        $self->{animateImgList}->set_active($self->{optionsManager}->animateImgList);
        $self->{columns}->set_value($self->{optionsManager}->columns);
        $self->{imgSizeOption}->setValue($self->{optionsManager}->listImgSize);
        $self->{optionStyle}->setValue($self->{optionsManager}->listImgSkin);
        $self->{useOverlays}->set_active($self->{optionsManager}->useOverlays);             
        $self->{listBgPicture}->set_active($self->{optionsManager}->listBgPicture);
        $self->activateColors(! $self->{optionsManager}->listBgPicture);
        $self->{mlbg} = $self->{optionsManager}->listBgColor;
        $self->{mlfg} = $self->{optionsManager}->listFgColor;
        $self->{groupByOption}->setValue($self->{optionsManager}->groupBy);
        $self->{secondarySortOption}->setValue($self->{optionsManager}->secondarySort);        
    }
    
    sub saveValues
    {
        my $self = shift;
        
        $self->{optionsManager}->resizeImgList(($self->{resizeImgList}->get_active) ? 1 : 0);
        $self->{optionsManager}->animateImgList(($self->{animateImgList}->get_active) ? 1 : 0);
        $self->{optionsManager}->columns($self->{columns}->get_value);
        $self->{optionsManager}->listImgSize($self->{imgSizeOption}->getValue);
        $self->{optionsManager}->listImgSkin($self->{optionStyle}->getValue);
        $self->{optionsManager}->listBgColor($self->{mlbg});
        $self->{optionsManager}->listFgColor($self->{mlfg});
        $self->{optionsManager}->listBgPicture(($self->{listBgPicture}->get_active) ? 1 : 0);
        $self->{optionsManager}->useOverlays(($self->{useOverlays}->get_active) ? 1 : 0);
        $self->{optionsManager}->groupBy($self->{groupByOption}->getValue);
        $self->{optionsManager}->secondarySort( $self->{secondarySortOption}->getValue);
    }
    
    sub changeColor
    {
        my ($self, $type) = @_;
        
        my $dialog = new Gtk2::ColorSelectionDialog($self->{lang}->{ImagesOptionsSelectColor});
        my $vboxPicture = new Gtk2::VBox(0,0);
        my @colors = split m/,/, $self->{'ml'.$type};
        my $previous = new Gtk2::Gdk::Color($colors[0], $colors[1], $colors[2]);
        $dialog->colorsel->set_current_color($previous) if $previous;
        my $response = $dialog->run;
        if ($response eq 'ok')
        {
            my $color = $dialog->colorsel->get_current_color;
            $self->{'ml'.$type} = join ',',$color->red, $color->green, $color->blue;
        }
        $dialog->destroy;
    }
    
    sub activateColors
    {
        my ($self, $value) = @_;
        
        $self->{labelStyle}->set_sensitive(!$value);
        $self->{optionStyle}->set_sensitive(!$value);
        $self->{labelBg}->set_sensitive($value);
        $self->{buttonBg}->set_sensitive($value);
    }
    
    sub new
    {
        my ($proto, $optionsManager, $parent) = @_;
        my $class = ref($proto) || $proto;
        
        my $self  = $class->SUPER::new(14,4);
        #my $self  = $class->SUPER::new(0,0);
        
        $self->{optionsManager} = $optionsManager;
        $self->{lang} = $parent->{lang};

#        $self->set_row_spacings($GCUtils::halfMargin);
        $self->set_col_spacings($GCUtils::margin);
        $self->set_border_width($GCUtils::margin);

        $self->{labelColumns} = new GCLabel($self->{lang}->{OptionsColumns});
        my  $adj = Gtk2::Adjustment->new(0, 1, 20, 1, 1, 0) ;
        $self->{columns} = Gtk2::SpinButton->new($adj, 0, 0);

        $self->{resizeImgList} = new Gtk2::CheckButton($self->{lang}->{ImagesOptionsResizeImgList});
        $self->{resizeImgList}->signal_connect('clicked' => sub {
            $self->{columns}->set_sensitive(! $self->{resizeImgList}->get_active);
        });
        $self->{resizeImgList}->set_active($self->{resizeImgList});

        $self->{animateImgList} = new Gtk2::CheckButton($self->{lang}->{ImagesOptionsAnimateImgList});
        $self->{animateImgList}->signal_connect('clicked' => sub {
            $self->{columns}->set_sensitive(! $self->{animateImgList}->get_active);
        });
        $self->{animateImgList}->set_active($self->{animateImgList});

        $self->{imgSizeLabel} = new GCLabel($self->{lang}->{ImagesOptionsSizeLabel});
        $self->{imgSizeOption} = new GCMenuList;
        my %imgSizes = %{$self->{lang}->{ImagesOptionsSizeList}};
        my @imgValues = map {{value => $_, displayed => $imgSizes{$_}}}
                                 (sort keys %imgSizes);
        $self->{imgSizeOption}->setValues(\@imgValues);

        $self->{useOverlays} = new Gtk2::CheckButton($self->{lang}->{ImagesOptionsUseOverlays});
        $self->{useOverlays}->set_active($self->{useOverlays});

        $self->{listBgPicture} = new Gtk2::CheckButton($self->{lang}->{ImagesOptionsBgPicture});
        $self->{listBgPicture}->signal_connect('clicked' => sub {
            $self->activateColors(! $self->{listBgPicture}->get_active);
        });
        
        $self->{labelStyle} = new GCLabel($self->{lang}->{OptionsStyle});
        $self->{optionStyle} = new GCMenuList;
        my @styleValues;
        foreach (@GCStyle::lists)
        {
            (my $displayed = $_) =~ s/_/ /g;
            push @styleValues, {value => $_, displayed => $displayed};
        }
        $self->{optionStyle}->setValues(\@styleValues);
       
        $self->{labelBg} = new GCLabel($self->{lang}->{ImagesOptionsBg});
        $self->{buttonBg} = new Gtk2::Button($self->{lang}->{ImagesOptionsSelectColor});
        $parent->{tooltips}->set_tip($self->{buttonBg},
                                     $self->{lang}->{ImagesOptionsBgTooltip});
        $self->{buttonBg}->signal_connect('clicked' => sub {
            $self->changeColor('bg');
        });
        
        $self->{labelFg} = new GCLabel($self->{lang}->{ImagesOptionsFg});
        $self->{buttonFg} = new Gtk2::Button($self->{lang}->{ImagesOptionsSelectColor});
        $self->{buttonFg}->signal_connect('clicked' => sub {
            $self->changeColor('fg');
        });
        $parent->{tooltips}->set_tip($self->{buttonFg},
                                     $self->{lang}->{ImagesOptionsFgTooltip});

        $self->{groupItems} = new GCLabel($self->{lang}->{DetailedOptionsGroupItems});
        $self->{groupByOption} = new GCFieldSelector(0, undef, 1);
        $self->{groupByOption}->setModel($parent->{model});
        
        $self->{secondarySort} = new GCLabel($self->{lang}->{DetailedOptionsSecondarySort});
        $self->{secondarySortOption} = new GCFieldSelector(0, undef, 1);
        $self->{secondarySortOption}->setModel($parent->{model});

#        my $tableDisplay = new Gtk2::Table(5,2);
#        $tableDisplay->set_row_spacings($GCUtils::halfMargin);
#        $tableDisplay->set_col_spacings($GCUtils::margin);
#        $tableDisplay->set_border_width($GCUtils::margin);
        my $imagesDisplayExpander = new GCExpander($self->{lang}->{OptionsImagesDisplayGroup}, 1);
        $self->attach($imagesDisplayExpander, 0, 4, 0, 1, 'fill', 'fill', 0, $GCUtils::quarterMargin);
        $self->attach($self->{resizeImgList}, 2, 4, 1, 2, 'fill', 'fill', 0, $GCUtils::quarterMargin);
        $self->attach($self->{animateImgList}, 2, 4, 2, 3, 'fill', 'fill', 0, $GCUtils::quarterMargin);
        $self->attach($self->{labelColumns}, 2, 3, 3, 4, 'fill', 'fill', 0, $GCUtils::quarterMargin);
        $self->attach($self->{columns}, 3, 4, 3, 4, 'fill', 'fill', 0, $GCUtils::quarterMargin);
        $self->attach($self->{imgSizeLabel}, 2, 3, 4, 5, 'fill', 'fill', 0, $GCUtils::quarterMargin);
        $self->attach($self->{imgSizeOption}, 3, 4, 4, 5, 'fill', 'fill', 0, $GCUtils::quarterMargin);
        $self->attach($self->{groupItems}, 2, 3, 5, 6, 'fill', 'fill', 0, $GCUtils::quarterMargin);
        $self->attach($self->{groupByOption}, 3, 4, 5, 6, 'fill', 'fill', 0, $GCUtils::quarterMargin);
        $self->attach($self->{secondarySort}, 2, 3, 6, 7, 'fill', 'fill', 0, $GCUtils::quarterMargin);
        $self->attach($self->{secondarySortOption}, 3, 4, 6, 7, 'fill', 'fill', 0, $GCUtils::quarterMargin);        

        my $imagesStyleExpander = new GCExpander($self->{lang}->{OptionsImagesStyleGroup}, 1);
        $self->attach($imagesStyleExpander, 0, 4, 8, 9, 'fill', 'fill', 0, $GCUtils::quarterMargin);
        $self->attach($self->{useOverlays}, 2, 4, 9, 10, 'fill', 'fill', 0, $GCUtils::quarterMargin);
        $self->attach($self->{listBgPicture}, 2, 4, 10, 11, 'fill', 'fill', 0, $GCUtils::quarterMargin);
        $self->attach($self->{labelStyle}, 2, 3, 11, 12, 'fill', 'fill', 0, $GCUtils::quarterMargin);
        $self->attach($self->{optionStyle}, 3, 4, 11, 12, 'fill', 'fill', 0, $GCUtils::quarterMargin);
        $self->attach($self->{labelBg}, 2, 3, 12, 13, 'fill', 'fill', 0, $GCUtils::quarterMargin);
        $self->attach($self->{buttonBg}, 3, 4, 12, 13, 'fill', 'fill', 0, $GCUtils::quarterMargin);
        $self->attach($self->{labelFg}, 2, 3, 13, 14, 'fill', 'fill', 0, $GCUtils::quarterMargin);
        $self->attach($self->{buttonFg}, 3, 4, 13, 14, 'fill', 'fill', 0, $GCUtils::quarterMargin);
        
        $imagesDisplayExpander->signal_connect('activate' => sub {
            if (!$imagesDisplayExpander->get_expanded)
            {
                $self->{resizeImgList}->show_all;
                $self->{labelColumns}->show_all;
                $self->{columns}->show_all;
                $self->{imgSizeLabel}->show_all;
                $self->{imgSizeOption}->show_all;
                $self->{groupItems}->show_all;
                $self->{groupByOption}->show_all;
                $self->{secondarySort}->show_all;
                $self->{secondarySortOption}->show_all;
            }
            else
            {
                $self->{resizeImgList}->hide_all;
                $self->{labelColumns}->hide_all;
                $self->{columns}->hide_all;
                $self->{imgSizeLabel}->hide_all;
                $self->{imgSizeOption}->hide_all;
                $self->{groupItems}->hide_all;
                $self->{groupByOption}->hide_all;
                $self->{secondarySort}->hide_all;
                $self->{secondarySortOption}->hide_all;
            }
        });  
        $imagesStyleExpander->signal_connect('activate' => sub {
            if (!$imagesStyleExpander->get_expanded)
            {
                $self->{useOverlays}->show_all;
                $self->{listBgPicture}->show_all;
                $self->{labelStyle}->show_all;
                $self->{optionStyle}->show_all;
                $self->{labelBg}->show_all;
                $self->{buttonBg}->show_all;
                $self->{labelFg}->show_all;
                $self->{buttonFg}->show_all;
            }
            else
            {
                $self->{useOverlays}->hide_all;
                $self->{listBgPicture}->hide_all;
                $self->{labelStyle}->hide_all;
                $self->{optionStyle}->hide_all;
                $self->{labelBg}->hide_all;
                $self->{buttonBg}->hide_all;
                $self->{labelFg}->hide_all;
                $self->{buttonFg}->hide_all;
            }
        });

        $self->show_all;
        $imagesDisplayExpander->set_expanded(1);
        $imagesStyleExpander->set_expanded(1);

        bless ($self, $class);
        return $self;
    }
}



{
    # Class used to let user select detailed options
    package GCDetailedOptionsPanel;
    use base "Gtk2::VBox";
   
    
    sub initValues
    {
        my $self = shift;
        
        $self->{imgSizeOption}->setValue($self->{optionsManager}->detailImgSize);
        $self->{groupByOption}->setValue($self->{optionsManager}->groupBy);
        $self->{secondarySortOption}->setValue($self->{optionsManager}->secondarySort);
        $self->{groupedFirst}->setValue($self->{optionsManager}->groupedFirst);
        $self->{addCount}->setValue($self->{optionsManager}->addCount);
        
        my @tmpFieldsArray = split m/\|/, $self->{optionsManager}->details;
        $self->{fieldsSelection}->setListFromIds(\@tmpFieldsArray);

    }
    
    sub saveValues
    {
        my $self = shift;
        $self->{optionsManager}->detailImgSize($self->{imgSizeOption}->getValue);
        $self->{optionsManager}->groupBy($self->{groupByOption}->getValue);
        $self->{optionsManager}->secondarySort($self->{secondarySortOption}->getValue);
        $self->{optionsManager}->groupedFirst($self->{groupedFirst}->getValue);
        $self->{optionsManager}->addCount($self->{addCount}->getValue);
        my $details = join('|', @{$self->{fieldsSelection}->getSelectedIds});
        $self->{optionsManager}->details($details);
    }
    
    sub hideExtra
    {
        my $self = shift;

    }

    sub show
    {
        my $self = shift;

        $self->initValues;
        
        my $code = $self->SUPER::show;
        if ($code eq 'ok')
        {
            $self->saveValues;
        }
        $self->hide;
    }
    
    sub new
    {
        my ($proto, $optionsManager, $parent, $preIdList) = @_;
        my $class = ref($proto) || $proto;
        my $self = $class->SUPER::new(0,0);

        $self->{lang} = $parent->{lang};
        $self->{optionsManager} = $optionsManager;

        bless ($self, $class);

        $self->set_border_width($GCUtils::margin);

        $self->{groupItems} = new GCLabel($self->{lang}->{DetailedOptionsGroupItems});
        $self->{groupByOption} = new GCFieldSelector(0, undef, 1);
        $self->{groupByOption}->setModel($parent->{model});

        $self->{secondarySort} = new GCLabel($self->{lang}->{DetailedOptionsSecondarySort});
        $self->{secondarySortOption} = new GCFieldSelector(0, undef, 1);
        $self->{secondarySortOption}->setModel($parent->{model});

        $self->{groupedFirst} = new GCCheckBox($self->{lang}->{DetailedOptionsGroupedFirst});
        $self->{addCount} = new GCCheckBox($self->{lang}->{DetailedOptionsAddCount});
        
        $self->{imgSizeLabel} = new GCLabel($self->{lang}->{DetailedOptionsImageSize});
        $self->{imgSizeOption} = new GCMenuList;
        my %imgSizes = %{$self->{lang}->{ImagesOptionsSizeList}};
        my @imgValues = map {{value => $_, displayed => $imgSizes{$_}}}
                                 (sort keys %imgSizes);
        $self->{imgSizeOption}->setValues(\@imgValues);

        my $preferencesExpander = new GCExpander($self->{lang}->{OptionsDetailedPreferencesGroup}, 1);
        $self->pack_start($preferencesExpander, 0, 0, $GCUtils::quarterMargin);

        my $tablePreferences = new Gtk2::Table(4, 5);
        $tablePreferences->set_col_spacings($GCUtils::margin);

        $tablePreferences->attach($self->{imgSizeLabel}, 2, 3, 1, 2, 'fill', 'fill', 0, $GCUtils::quarterMargin);
        $tablePreferences->attach($self->{imgSizeOption}, 3, 4, 1, 2, 'fill', 'fill', 0, $GCUtils::quarterMargin);

        $tablePreferences->attach($self->{groupItems}, 2, 3, 2, 3, 'fill', 'fill', 0, $GCUtils::quarterMargin);
        $tablePreferences->attach($self->{groupByOption}, 3, 4, 2, 3, 'fill', 'fill', 0, $GCUtils::quarterMargin);
        $tablePreferences->attach($self->{secondarySort}, 2, 3, 3, 4, 'fill', 'fill', 0, $GCUtils::quarterMargin);
        $tablePreferences->attach($self->{secondarySortOption}, 3, 4, 3, 4, 'fill', 'fill', 0, $GCUtils::quarterMargin);

        $tablePreferences->attach($self->{groupedFirst}, 2, 4, 4, 5, 'fill', 'fill', 0, $GCUtils::quarterMargin);
        $tablePreferences->attach($self->{addCount}, 2, 4, 5, 6, 'fill', 'fill', 0, $GCUtils::quarterMargin);

        $preferencesExpander->add($tablePreferences);

        my $fieldsExpander = new GCExpander($self->{lang}->{DetailedOptionsFields}, 1);
        my @tmpFieldsArray = split m/\|/, $optionsManager->details;
        $self->{fieldsSelection} = new GCFieldsSelectionWidget($parent, \@tmpFieldsArray, 1);

        $self->pack_start($fieldsExpander, 0, 0, $GCUtils::quarterMargin);
        $fieldsExpander->add($self->{fieldsSelection});
        $self->{fieldsSelection}->set_border_width($GCUtils::margin);

        $preferencesExpander->set_expanded(1);
        $fieldsExpander->set_expanded(1);

        $self->show_all;
        return $self;
    }
}

1;
