package GCPanel;

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
use GCBorrowings;
use GCGraphicComponents::GCBaseWidgets;

use strict;

{
    package GCItemPanel;
    @GCItemPanel::ISA = ('Gtk2::Frame');
    
    sub new
    {
        my ($proto, $parent, $options, $layout) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();

        bless ($self, $class);

        $self->{disableBorrowerChange} = 0;
        $self->{autoUpdate} = 1;
        $self->{previouslyHidden} = 0;

        $self->{expanders} = [];
        $self->{dateFields} = [];
        $self->{longTextFields} = [];
        $self->{formatted} = [];
        #Stores for each fields the widgets which depends on it
        # (used for formatted and launcher)
        $self->{dependencies} = {};

        $self->{parent} = $parent;
        $self->{lang} = $parent->{lang};
        $self->{options} = $options;
        $self->{layout} = $layout;
        $self->set_shadow_type('none');
        
        #$self->{defaultImage} = $parent->getDefaultImage;
        $self->{tooltips} = $parent->{tooltips};
        
        $self->{infoBox} = new Gtk2::VBox(1,0);
        $self->{viewAllBox} = new Gtk2::EventBox;
        $self->{viewAllVBox} = new Gtk2::VBox(0,0);
        $self->{viewAll} = new Gtk2::HBox(0,0);
        $self->{viewAllButton} = new Gtk2::Button->new_from_stock('gtk-refresh');
        $self->{viewAll}->pack_start($self->{viewAllButton},1,0,50);
        $self->{viewAllVBox}->pack_start($self->{viewAll},0,0,0);
        $self->{viewAllBox}->add($self->{viewAllVBox});
        $self->{viewAllButton}->signal_connect('clicked' => sub {
            $self->{parent}->viewAllItems;
        });

        $self->{margin} = $GCUtils::margin;
        $self->{halfMargin} = $GCUtils::halfMargin;
        $self->{quarterMargin} = $GCUtils::quarterMargin;

        return $self;
    }
    
    sub loadStyles
    {
        my ($self, $style) = @_;
    }    


    sub setExpandersMode
    {
        my ($self, $mode) = @_;
        $_->setMode($mode)
            foreach (@{$self->{expanders}});
    }

    sub setDateFormat
    {
        my ($self, $format) = @_;
        foreach (@{$self->{dateFields}})
        {
            $_->setFormat($format);
            $_->resetChanged;
        }
    }

    sub setSpellChecking
    {
        my ($self, $activate, $lang) = @_;
        foreach (@{$self->{longTextFields}})
        {
            $_->setSpellChecking($activate, $lang);
        }
    }

    sub createContent
    {
        my ($self, $model) = @_;
        return if $self->{model}
              && ($self->{model}->getName eq $model->getName);

        if ($self->{model})
        {
            my @children = $self->{mainBox}->get_children;
            $self->{mainBox}->remove($_) foreach (@children);
            foreach (@{$self->{toDestroy}})
            {
                $_->destroy if $_;
            }
        }

        $self->{model} = $model;
        $self->{fieldsInfo} = $self->{model}->{fieldsInfo};
        $self->{toDestroy} = [];
        foreach (@{$model->{fieldsNames}})
        {
            $self->{$_} = $self->createItem($self->{model}->{fieldsInfo}->{$_});
            push @{$self->{toDestroy}}, $self->{$_};
            $self->{$_.'Label'} = $self->createLabel($self->{model}->{fieldsInfo}->{$_}, $self->{withSeparator});
            push @{$self->{toDestroy}}, $self->{$_.'Label'};
        }
        $self->createSpecial;

        $self->{displayedValues} = {};
        $self->createLayout($self->{layout}, $self->{layoutBox});

        $self->show_all;
    }
    
    sub initShow
    {
        my ($self, $show, $hasToShow) = @_;

        $self->{show} = $show;
       
        if ($hasToShow)
        {
            $self->show_all;
            $self->{infoBox}->hide;
            return 1;
        }
        else
        {
            $self->hide(0);
            $self->{previouslyHidden} = 1;
            return 0;
        }
    }
    
    sub show
    {
        my $self = shift;
        $self->{mainBox}->show;
        $self->{infoBox}->hide;
        $self->setShowOption($self->{show}, 1) if $self->{previouslyHidden};
        $self->{previouslyHidden} = 0;
    }
    
    sub setShowOption
    {
        my ($self, $show, $hasToShow) = @_;
        return if ! $self->initShow($show, $hasToShow);
        my %parentsToHide;
        foreach (keys %{$show})
        {
            $self->{$_.'Label'}->hide if (! $show->{$_}) && ($self->{$_.'Label'});
            my $widget = $self->{$_};
            if ($widget)
            {
                if ($show->{$_})
                {
                    # Useful for GCLinkedComponent
                    $widget->show if !$widget->isa('Gtk2::Widget');
                    #$parentsToHide{$widget->{realParent}} = 0;
                    my $parent = $widget->{realParent};
                    while ($parent)
                    {
                        $parentsToHide{$parent} = 0;
                        $parent = $parent->{realParent};
                    }
                    foreach my $dependency(@{$self->{dependencies}->{$_}})
                    {
                        $parentsToHide{$dependency->{realParent}} = 0;
                    }
                }
                else
                {
                    $widget->hide;
                    $parentsToHide{$widget->{realParent}} = $widget->{realParent} if ! exists $parentsToHide{$widget->{realParent}};
                    foreach my $dependency(@{$self->{dependencies}->{$_}})
                    {
                        $dependency->hide;
                    }
                }
            }
        }

        foreach (keys %parentsToHide)
        {
            if ($parentsToHide{$_})
            {
                $parentsToHide{$_}->hide;
                $parentsToHide{$_}->{realParent}->hide
                    if ($parentsToHide{$_}->{realParent})
                    && ($parentsToHide{$_}->{realParent}->isa('GCExpander'));
            }
        }
        
        $self->setShowOptionForSpecials($show, $hasToShow);
    }

    sub setShowOptionForSpecials
    {
        my ($self, $show, $hasToShow) = @_;
    }

    sub hide
    {
        my ($self, $filtering) = @_;
        $self->{infoBox}->show_all;
        if ($filtering)
        {
            $self->{warning}->set_markup('<b>'.$self->{lang}->{AllItemsFiltered}.'</b>');
        }
        else
        {
            $self->{warning}->set_markup($self->{lang}->{Warning}) if !$filtering;
            $self->{viewAllBox}->hide;
        }
        $self->{mainBox}->hide;
    }
    
    sub showMe
    {
        my $self = shift;
        my $parent = $self->parent;
        while ($parent)
        {
           last if ($parent->isa('Gtk2::Window'));
           $parent = $parent->parent;
        }
        $parent->present if $parent;
    }
    
    sub isReadOnly
    {
        return 1;
    }
    
    sub getAsHash
    {
        my $self = shift;
        my $hash = {};
        $hash->{$_} = $self->$_ foreach(@{$self->{parent}->{model}->{fieldsNames}});
        return $hash;
    }
    
    sub getValue
    {
        my ($self, $field) = @_;
        
        return $self->$field;
    }
    
    sub disableBorrowerChange
    {
        my $self = shift;
        $self->{disableBorrowerChange} = 1;
    }
    
    sub disableAutoUpdate
    {
        my $self = shift;
        $self->{autoUpdate} = 0;
    }

    sub dataChanged
    {
        my ($self, $info, $withoutPanel) = @_;

        if (!$withoutPanel)
        {
            foreach (@{$self->{expanders}})
            {
                $self->setExpanderLabel($_, 1);
            }
        }
        foreach (@{$self->{formatted}})
        {
            $self->setFormattedLabel($_, 1, $info, $withoutPanel);
        }
    }

    sub createLabel
    {
        my ($self, $info, $withSeparator) = @_;

        my $label = $self->{model}->getDisplayedText($info->{label});
        $label .= $self->{parent}->{lang}->{Separator} if $withSeparator;
        my $widget = new Gtk2::Label($label);
        $widget->set_alignment(0, 0.5);
        return $widget;
    }

    sub createExpander
    {
        my ($self, $label) = @_;

        return new GCExpander($label);
    }
    
    sub formatLabel
    {
        my ($self, $format, $info) = @_;

        my $label = $format;
        
        # Remove from format conditional part using this format:
        # =field.....=
        $label =~ s/\=(\w*)([^\=]*)\=/($self->{show}->{$1}) ? $2 : ''/eg;
        
        # Allow formatting using %fields[format]%
        if ($info)
        {
            $label =~ s/%(.*?)(\[(.*?)\])*%/$3 ? sprintf($3,$info->{$1}) : $info->{$1}/eg;
        }
        else
        {
            $label =~ s/%(.*?)(\[(.*?)\])*%/$3 ? sprintf($3,$self->{$1}->getValue(1)) : $self->{$1}->getValue(1)/eg;
        }
        if ($label =~ /^=(.*)$/)
        {
            $label = eval $1;
        }

        $label =~ s/@(.*?)@/$self->{model}->getDisplayedText($1)/eg;
        
        # Strings between ^ cannot be on the end or on the beginning.
        # Typically used for separators
        $label =~ s/^\^([^\^]*)\^//;
        $label =~ s/\^([^\^]*)\^$//;
        $label =~ s/\^//g;
        
        return $label;
    }
    
    sub setExpanderLabel
    {
        my ($self, $expander, $init) = @_;

        if ($expander->{collapsedTemplate}
        && ($expander->get_expanded xor $init))
        {
            my $label = $self->formatLabel($expander->{collapsedTemplate});
            $expander->setValue($expander->{originalLabel}.($label ? $self->{parent}->{lang}->{Separator} : ""),
                                $self->formatLabel($expander->{collapsedTemplate}));
        }
        else
        {
            $expander->setValue($expander->{originalLabel});
        }
    }
    
    sub setAsFormatted
    {
        my ($self, $widget, $name, $format) = @_;
        $widget->{format} = $format;
        $widget->{name} = $name;
        push @{$self->{formatted}}, $widget;
        while ($format =~ /%(.*?)%/g)
        {
            push @{$self->{dependencies}->{$1}}, $widget;
        }
    }

    sub setFormattedLabel
    {
        my ($self, $label, $init, $info, $withoutPanel) = @_;

        my $name = $label->{name};
        if ($withoutPanel)
        {
            $info->{$name} = $self->formatLabel($label->{format}, $info);
        }
        else
        {
            $self->$name($self->formatLabel($label->{format}));
            # We store here the value so it could be used by caller if needed
            # The user is GCData::updateSelectedItemInfoFromPanel
            $info->{$name} = $self->$name if defined $info;
        }
    }

    sub prepareDate
    {
        my ($self, $value) = @_;

        return GCUtils::timeToStr($value, $self->{parent}->{options}->dateFormat)
    }

    sub addToContainer
    {
        my ($self, $container, $widget, $info) = @_;
        $info->{expand} = 'default' if !exists $info->{expand};
        if ($container->isa('Gtk2::Notebook'))
        {
            $container->append_page($widget,
                                    $self->{model}->getDisplayedText($info->{title}));
        }
        elsif ($container->isa('Gtk2::Table'))
        {
            my $left = $info->{col};
            my $right = $left + ($info->{colspan} ? $info->{colspan} : 1);
            my $top = $info->{row};
            my $bottom = $top + ($info->{rowspan} ? $info->{rowspan} : 1);
            my $fill = [];
            push @$fill, 'fill' if $info->{expand} ne 'false';
            push @$fill, 'expand' if $info->{expand} eq 'true';
            if ($info->{expand} eq 'shrink')
            {
                $fill = ['expand', 'fill'];
                my $hbox = new Gtk2::HBox(0,0);
                $hbox->pack_start($widget,0,0,0);
                $widget = $hbox;
            }
            if ($info->{expand} eq 'horizontal')
            {
                $container->attach($widget,
                                   $left, $right, $top, $bottom,
                                   ['expand', 'fill'], [],
                                   0, 0);
            }
            else
            {
                $container->attach($widget,
                                   $left, $right, $top, $bottom,
                                   $fill, $fill,
                                   0, 0);
            }
        }
        else
        {
            my $expand = ($info->{expand} eq 'true') ? 1 : 0;
            if ($container->isa('Gtk2::VBox'))
            {
                my $margin = $self->{halfMargin};
                $margin = 0 if (exists $info->{nomargin}) && ($info->{nomargin} eq 'true');
                if ((exists $info->{place}) && ($info->{place} eq 'end'))
                {
                    $container->pack_end($widget, $expand, $expand, $margin);
                }
                else
                {
                    $container->pack_start($widget, $expand, $expand, $margin);
                }
            }
            else
            {
                my $margin = $self->{halfMargin};
                $margin = 0 if (exists $info->{nomargin}) && ($info->{nomargin} eq 'true');
                if (($container->get_children) && (!$container->get_homogeneous) && ($margin > 0))
                {
                    my $marginBox = new Gtk2::HBox(0,0);
                    $container->pack_start($marginBox, 0, 0, $margin);
                }
                $container->pack_start($widget, $expand, $expand, 0)
                    if ref($widget) ne 'HASH';
            }
        }
    }
    
    sub setWidgetStyle
    {
        my ($self, $widget, $name, $style) = @_;
    }
    
    sub getWidget
    {
        my ($self, $field, $info) = @_;
        return $self->{$field};
    }
    
    sub createLayout
    {
        my ($self, $xml, $container, $parent, $noTab) = @_;
        #
        foreach (@{$xml->{item}})
        {
            my $widget;
            my $box;
            my $isContainer = 0;

            # TODO We should return an error here
            $_->{type} = 'default' if ! exists $_->{type};

            if ($_->{type} eq 'formatted')
            {
                my $info = {};
                $info->{type} = 'short text';
                $info->{value} = $_->{name};
                $widget = $self->createItem($info);
                $self->{$_->{name}} = $widget;
                $self->setAsFormatted($widget, $_->{name}, $_->{value});
                $_->{for} = $widget->{name};
            }
            elsif ($_->{type} eq 'value')
            {
                $widget = $self->getWidget($_->{for}, $_);
                if ($widget)
                {
                    $widget->setWidth($_->{width}) if $_->{width};
                    $widget->setHeight($_->{height}) if $_->{height};
                    $widget->expand if (exists $_->{expand}) && ($_->{expand} eq 'true');
                    if ($_->{values} || $self->{model}->{fieldsInfo}->{$_->{for}}->{values})
                    {
                        $self->{displayedValues}->{$_->{for}} = 
                                $_->{values}
                             || $self->{model}->{fieldsInfo}->{$_->{for}}->{values};
                    }
                    # If the item is related to another, it has to be hidden with it
                    if (exists $self->{model}->{fieldsInfo}->{$_->{for}}->{relatedto})
                    {
                        my $relatedTo = $self->{model}->{fieldsInfo}->{$_->{for}}->{relatedto};
                        push @{$self->{dependencies}->{$relatedTo}}, $widget;
                    }
                }
            }
            elsif ($_->{type} eq 'label')
            {
                if ($_->{for})
                { 
                    $widget = $self->{$_->{for}.'Label'};
                }
                else
                {
                    $widget = $self->createLabel($_, $self->{withSeparator});
                }
                if ((exists $_->{align}) && ($_->{align} eq 'center'))
                {
                    $widget->set_alignment(0.5, 0.5);
                    if ($self->{withSeparator})
                    {
                        my $label = $widget->get_label;
                        my $sep = $self->{parent}->{lang}->{Separator};
                        $label =~ s/$sep$//;
                        $widget->set_label($label);
                    }
                }
                $widget->set_alignment(0, 0) if (exists $_->{align}) && ($_->{align} eq 'top');
            }
            elsif ($_->{type} eq 'special')
            {
                $widget = $self->{$_->{for}};
                $widget->{param} = $_->{param};
            }
            elsif ($_->{type} eq 'launcher')
            {
                my $valueWidget = $self->{$_->{for}};
                my $format = $self->{model}->{fieldsInfo}->{$_->{for}}->{format};
                
                # If the launcher is for a video or music file, label the button 'play'
                if (($format eq 'video') || ($format eq 'audio'))
                {
                    $widget = Gtk2::Button->new_from_stock('gtk-media-play');
                }
                elsif ($format eq 'program')
                {
                    # For program launchers, label the button 'launch'
                    $widget = Gtk2::Button->new($self->{parent}->{lang}->{PanelLaunch});
                }
                else
                {
                    # Label the button 'open'
                    $widget = Gtk2::Button->new_from_stock('gtk-open');
                }
                
                $widget->signal_connect('clicked' => sub {
                    $self->{parent}->launch($valueWidget->getValue, $format);
                });
                push @{$self->{dependencies}->{$_->{for}}}, $widget;
            }
            elsif ($_->{type} eq 'extractor')
            {
                $widget = Gtk2::Button->new($self->{parent}->{lang}->{ExtractButton});
                my $valueWidget = $self->{$_->{for}};
                $widget->signal_connect('clicked' => sub {
                    $self->{parent}->extractInfo($valueWidget->getValue, $self);
                });
                push @{$self->{dependencies}->{$_->{for}}}, $widget;
            }
            elsif ($_->{type} eq 'line')
            {
                my $homogeneous = (exists $_->{homogeneous} && ($_->{homogeneous} eq 'true'))
                                ? 1 : 0;
                $widget = new Gtk2::HBox($homogeneous, $self->{margin});
                #$widget->set_border_width($self->{halfMargin});
                $widget->set_size_request(-1, $_->{height}) if $_->{height};
                $box = $widget;
                $isContainer = 1;
            }
            elsif ($_->{type} eq 'box')
            {
                $widget = new Gtk2::VBox(0,0);
                #$widget->set_border_width($self->{halfMargin});
                $box = $widget;
                if ($_->{width})
                {
#                    $widget = new Gtk2::EventBox;
#                    $widget->add($box);
                    $widget->set_size_request($_->{width}, -1);
                }
                $isContainer = 1;
            }
            elsif ($_->{type} eq 'notebook')
            {
                if ($noTab)
                {
                    $widget = new Gtk2::VBox(0,0);
                }
                else
                {
                    $widget = new Gtk2::Notebook;
                }
                #$widget->set_border_width($self->{margin});
                $box = $widget;
                $isContainer = 1;
            }
            elsif ($_->{type} eq 'tab')
            {
                $widget = new Gtk2::VBox(0,0);
                if ($noTab)
                {
                    my $label = new Gtk2::Label;
                    $label->set_markup('<b>'.$self->{model}->getDisplayedText($_->{title}).'</b>');
                    $label->set_alignment(0,0);
                    $widget->pack_start($label, 0, 0, 0);
                    $widget->set_border_width(0);
                    $box = new Gtk2::VBox(0,0);
                    $box->set_border_width($self->{margin});
                    $widget->pack_start($box, 1, 1, 0);
                }
                else
                {
                    $widget->set_border_width($self->{margin});
                    $box = $widget;
                }
                $isContainer = 1;
            }
            elsif ($_->{type} eq 'table')
            {
                $widget = new Gtk2::Table($_->{rows},$_->{cols});
                #$widget->set_border_width($self->{margin});
                $widget->set_col_spacings($self->{colSpacing});
                $widget->set_row_spacings($self->{rowSpacing});
                $box = $widget;
                $isContainer = 1;
            }
            elsif ($_->{type} eq 'frame')
            {
                $widget = new GCGroup($self->{model}->getDisplayedText($_->{title}));
                $widget->set_border_width(0);
                $widget->setPadding(0);
                $box = new Gtk2::Table($_->{rows},$_->{cols});
                $box->set_border_width($self->{halfMargin});
                $box->set_col_spacings($self->{margin});
                $box->set_row_spacings($self->{halfMargin});
                $widget->addWidget($box);
                $isContainer = 1;
            }
            elsif ($_->{type} eq 'expander')
            {
                #$widget = new GCExpander($self->{model}->getDisplayedText($_->{title}));
                $widget = $self->createExpander($self->{model}->getDisplayedText($_->{title}));
                $widget->setMode($self->{parent}->{options}->expandersMode);
                $widget->{originalLabel} = $self->{model}->getDisplayedText($_->{title});
                $widget->{collapsedTemplate} = $_->{collapsed};
                $self->setExpanderLabel($widget, 1);
                $widget->signal_connect('activate' => sub {
                    $self->setExpanderLabel($widget, 0);
                });
                $widget->set_expanded(1) if (defined $_->{expanded}) && ($_->{expanded} eq 'true');
                push @{$self->{expanders}}, $widget;
                $box = new Gtk2::VBox(0,0);
                $box->set_border_width($self->{halfMargin});
                $widget->add($box);
                $isContainer = 1;
                $_->{style} = 'expander' if !exists $_->{style};
            }
            
            if (exists $_->{border})
            {
                $widget->set_border_width($_->{border});
            }
            
            if (exists $_->{collapse})
            {
                $widget->{collapse} = $_->{collapse};            
            }
            
            if ($isContainer)
            {
                $self->createLayout($_, $box, $widget, $noTab);
            }
            push @{$self->{toDestroy}}, $widget;
            $widget->{realParent} = $parent if $parent;
            $self->setWidgetStyle($widget, $_->{for}, $_->{style}) if $_->{style};
            $self->addToContainer($container, $widget, $_) if $widget;
        }
    }
}

{
    package GCReadOnlyPanel;

    use Glib::Object::Subclass
                Gtk2::Frame::
    ;

    @GCReadOnlyPanel::ISA = ('GCItemPanel');

    use File::Basename;

    sub new
    {
        my ($proto, $parent, $options, $layout) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent, $options, $layout);

        bless ($self, $class);

        $self->{withSeparator} = 0;
        $self->{colSpacing} = $self->{quarterMargin};
        $self->{rowSpacing} = $self->{quarterMargin};
        $self->loadStyles($options->panelStyle);

        $self->{inBox} = new Gtk2::VBox(0, 0);
        $self->{inBox}->set_border_width($self->{margin});
       
        $self->set_name('GCItemFrame');

        $self->{inBox} = new Gtk2::VBox(0, 0);
        my $hboxMargins = new Gtk2::HBox(0,0);
        $hboxMargins->pack_start($self->{inBox}, 1, 1, 50);
        $self->{mainBox} = new Gtk2::EventBox;
        $self->{mainBox}->modify_bg('normal', $self->{styles}->{page}->{bgColor});
        $self->{mainBox}->add($hboxMargins);

        my $realMain = new Gtk2::VBox(0,0);

#        GCUtils::setWidgetPixmap($self->{mainBox},$ENV{GCS_SHARE_DIR}.'/logos/splash.png');

#        $self->{backgroundPixbuf} = Gtk2::Gdk::Pixbuf->new_from_file($ENV{GCS_SHARE_DIR}.'/logos/splash.png');
#        $self->{mainBox}->signal_connect('expose-event' => sub {
#            $self->paintBg;
#        });

        $realMain->pack_start($self->{mainBox},1,1,0);

        $self->{layoutBox} = $self->{inBox};

        $self->add($realMain);
        $self->show_all;


        $self->{warning} = new Gtk2::Label;
        
        $self->{infoBox}->pack_start($self->{warning},1,1,0);
        $self->{infoBox}->pack_start($self->{viewAllBox},1,1,0);
        $realMain->pack_start($self->{infoBox},1,1,0);

        return $self;
    }
    
    sub loadStyles
    {
        my ($self, $style) = @_;
        
        $self->{styles} = {};
        my $styleFile = $ENV{GCS_SHARE_DIR}.'/panels/'.$style;
        
        open STYLE, $styleFile;
        while (<STYLE>)
        {
            chomp;
            next if !$_;
            m/^(.*?)\s*=\s*(.*)$/;
            my $item = $1;
            (my $value = $2) =~ s/^"(.*?)"$/$1/;
            $item =~ /(.*?)(Bg|Color|Style|Justify|Arrow|Prelight)/;
            my $comp = $1;
            my $style = lc $2;
            $self->{styles}->{$comp}->{$style} = $value;
        }            
        close STYLE;
        foreach (keys %{$self->{styles}})
        {
            $self->{styles}->{$_}->{bgColor} = Gtk2::Gdk::Color->parse($self->{styles}->{$_}->{bg});
            $self->{styles}->{$_}->{style} = $self->{styles}->{$_}->{style}
                                           . " foreground='".$self->{styles}->{$_}->{color}."'";
        }
        #$self->{styles}->{invisible}->{}
    }
    
    sub deactivate
    {
        my $self = shift;
    }

    sub getValues
    {
        my ($self, $field) = @_;
        if ($field eq $self->{model}->{commonFields}->{borrower}->{name})
        {
            my $borrowers = $self->{model}->getValues($self->{model}->{commonFields}->{borrower}->{name});
            shift @{$borrowers} if !$borrowers->[0]->{displayed};
            return $borrowers;
        }
        else
        {        
            return $self->{$field}->getValues;                
        }
    }
    

    sub selectTitle
    {
        my $self = shift;
        $self->myRealize;
    }

#    sub paintBg
#    {
#        my $self = shift;
#        my $window = $self->{mainBox}->window;
#        $self->{mainBox}->set_app_paintable(1);
#        if (! $self->{gcMain})
#        {
#            $self->{gcMain} = Gtk2::Gdk::GC->new($window);
#        }
#        $window->draw_pixbuf($self->{gcMain}, $self->{backgroundPixbuf}, 0, 0, 0, 0, -1, -1, "none", 5, 5); 
#    }

    sub setBorrowers
    {
        my ($self) = @_;
    }

    sub createSpecial
    {
        my $self = shift;
    }
    
    sub createLabel
    {
        my ($self, $info) = @_;
        
        my $label = $self->{model}->getDisplayedText($info->{label});
        my $widget = new GCColorLabel($self->{styles}->{label}->{bgColor});
        $widget->set_selectable(0);
        $widget->set_padding(5,5);
        $widget->set_justify('fill');
        $widget->set_markup("<span ".$self->{styles}->{label}->{style}.">".$label.'</span>');
        return $widget;
    }
    
    sub createExpander
    {
        my ($self, $label) = @_;

        return new GCColorExpander($label,
                                   $self->{styles}->{expander}->{bgColor},
                                   $self->{styles}->{expander}->{style});
    }

    sub setWidgetStyle
    {
        my ($self, $widget, $name, $style) = @_;
        $self->{style}->{$name} = $style;
        if ($self->{styles}->{$style}->{bgColor})
        {
            $widget->modify_bg('normal', $self->{styles}->{$style}->{bgColor});
        }

        if ($widget->isa('GCColorLabel') || $widget->isa('GCColorText'))
        {
            my $justify = $self->{styles}->{$style}->{justify};
            $widget->set_justify($justify) if $justify;
        }
        
        if ($widget->isa('GCColorExpander'))
        {
            my $arrowColor = Gtk2::Gdk::Color->parse($self->{styles}->{expander}->{arrow});
            my $prelightColor;
            if (exists $self->{styles}->{expander}->{prelight})
            {
                $prelightColor = Gtk2::Gdk::Color->parse($self->{styles}->{expander}->{prelight});
            }
            else
            {
                $prelightColor = $self->{styles}->{expander}->{bgColor};
            }
            
            $widget->modify_bg('prelight', $prelightColor);
            $widget->get_label_widget->modify_bg('prelight', $prelightColor);
            $widget->modify_fg('normal', $arrowColor);
            $widget->modify_fg('prelight', $arrowColor);
        }
    }
    
    sub createItem
    {
        my ($self, $info) = @_;
        
        my $widget;
        
        if ($info->{type} eq 'long text')
        {
            $widget = new GCColorText($self->{styles}->{field}->{bgColor}, 0);
            $self->{style}->{$info->{value}} = 'field';
        }
        elsif ($info->{type} eq 'image')
        {
            $widget = new GCItemImage($self->{parent}->{options}, 
                                      $self->{parent});
        }
        elsif ($info->{type} eq 'button')
        {
            $widget = new GCButton($self->{model}->getDisplayedText($info->{label}));
        }
        elsif($info->{type} =~ /list$/o)
        {
            my $number = GCUtils::listNameToNumber($info->{type});
            my @labels;
            for my $i (1..$number)
            {
                push @labels, $self->{model}->getDisplayedText($info->{'label'.$i});
            }
            $widget = new GCColorTable($number, \@labels,
                                       $self->{styles}->{label},
                                       $self->{styles}->{field},
                                       $self->{model}->getDisplayedText($info->{label}));            
        }
        elsif ($info->{type} eq 'url')
        {
            $widget = new GCColorLink($self->{styles}->{field}->{bgColor}, $self->{parent});
            $self->{style}->{$info->{value}} = 'field';
            $widget->set_selectable(0);
        }
        else
        {
            # See GCColorLabel constructor for the meaning of listType;
            $widget = new GCColorLabel($self->{styles}->{field}->{bgColor});
            if ($info->{value} eq $self->{model}->{commonFields}->{borrower}->{name})
            {
                $self->{prepare}->{$info->{value}}->{func} = 'prepareBorrower';
            }
            elsif ($info->{type} eq 'date')
            {
                $self->{prepare}->{$info->{value}}->{func} = 'prepareDate';
            }
            $self->{style}->{$info->{value}} = 'field';
            $widget->set_selectable(0);
            $widget->set_padding(5,5);
            $widget->set_justify('fill');
            $self->setAsFormatted($widget, $info->{value}, $info->{init})
                if ($info->{type} eq 'formatted');
        }
        $widget->{name} = $info->{value};        
        return $widget;
    }

    sub getWidget
    {
        my ($self, $field, $info) = @_;

        my $widget = $self->{$field};
        if ($info->{height} && $widget->isa('GCColorLabel'))
        {
            my $style = $info->{style};
            $style = 'field' if !$style;
            $widget->destroy;
            $widget = new GCColorText($self->{styles}->{$style}->{bgColor}, 0);
            $widget->{name} = $self->{$field}->{name};
            $self->{$field} = $widget;
        }
        elsif ($widget->isa('GCColorTable') && ($info->{flat} eq 'true'))
        {
            my $columns = $widget->{number};
            $widget->destroy;
            $self->{prepare}->{$field}->{func} = 'prepareMultipleList';
            $self->{prepare}->{$field}->{extra} = $columns;
            if ($info->{height})
            {
                $widget = new GCColorText($self->{styles}->{field}->{bgColor}, 0, $columns);
            }
            else
            {
                $widget = new GCColorLabel($self->{styles}->{field}->{bgColor}, $columns);
                $widget->set_selectable(0);
                $widget->set_padding(5,5);
                $widget->set_justify('fill');
            }
            $self->{style}->{$field} = 'field';
            $self->{$field} = $widget;
        }

        return $widget;
    }

    sub prepareMultipleList
    {
        my ($self, $value, $extra) = @_;
        return GCPreProcess::multipleList($value, $extra);
    }
    
    sub prepareBorrower
    {
        my ($self, $value) = @_;

        $value = $self->{lang}->{PanelNobody} if $value eq 'none';
        $value = $self->{lang}->{PanelUnknown} if $value eq 'unknown';
        return $value;
    }

    sub AUTOLOAD
    {
        return if our $AUTOLOAD =~ /::DESTROY$/;
        (my $name = $AUTOLOAD) =~ s/.*?::(.*)/$1/;
        return if !$name;
        no strict 'refs';
        
        *{$AUTOLOAD} = sub {
            my $self = shift;
            return 0 if !$self->{$name};
            return $self->{$name.'Value'}
                if !(scalar @_);
            my $text = shift;
            $self->{$name.'Value'} = $text;
            if (my $func = $self->{prepare}->{$name}->{func})
            {
                $text = $self->$func($text, $self->{prepare}->{$name}->{extra});
            }
            $text = ' ' if ! defined $text;
            $text = $self->{model}->getDisplayedValue($self->{displayedValues}->{$name}, $text)
                if ($self->{displayedValues}->{$name});
            if ($self->{$name})
            {
                # Hide collapsible fields if the field is empty
                if (($text !~ m/\S+/) && ($self->{$name}->{collapse}))
                {
                    $self->{$name}->hide;
                }
                else
                {
                    # Otherwise, make sure the field is shown
                    $self->{$name}->show;                    
                }
            
                if ($self->{$name}->acceptMarkup)
                {
                    $self->{$name}->setMarkup("<span ".
                                              $self->{styles}->{$self->{style}->{$name}}->{style}.
                                              ">".$self->{$name}->cleanMarkup($text, 1).'</span>');
                }
                else
                {
                    $self->{$name}->setValue($text);
                }
                #$self->{$name}->resetChanged;
            }
        };
        goto &{$AUTOLOAD};
    }
}


{
    package GCFormPanel;

    use Glib::Object::Subclass
                Gtk2::Frame::
    ;
    @GCFormPanel::ISA = ('GCItemPanel');

    sub createSpecial
    {
        my $self = shift;
    
        $self->{mailButton} = new GCButton($self->{parent}->{lang}->{MailTitle});
        $self->{mailButton}->signal_connect('clicked' => sub {
            $self->sendBorrowerEmail;
        });
        push @{$self->{toDestroy}}, $self->{mailButton};

        $self->{itemBackButton} = new GCButton($self->{parent}->{lang}->{PanelReturned});
        $self->{itemBackButton}->signal_connect('clicked' => sub {
            $self->itemBack;
        });
        push @{$self->{toDestroy}}, $self->{mailButton};

        $self->{searchButton} = GCButton->newFromStock('gtk-jump-to');
        $self->{searchButton}->signal_connect('clicked' => sub {
            $self->searchItem;
        });
        my @subMenuSearch;
        $subMenuSearch[0]=Gtk2::ImageMenuItem->new_with_mnemonic($self->{parent}->{lang}->{PanelSearchContextChooseOne});
        $subMenuSearch[0]->signal_connect("activate" , sub {$self->searchItem('ask')});
        
        $subMenuSearch[1]=Gtk2::ImageMenuItem->new_with_mnemonic($self->{parent}->{lang}->{PanelSearchContextMultiSite});
        $subMenuSearch[1]->signal_connect("activate" ,sub {$self->searchItem('multi')});
        
        $subMenuSearch[2]=Gtk2::ImageMenuItem->new_with_mnemonic($self->{parent}->{lang}->{PanelSearchContextMultiSitePerField});
        $subMenuSearch[2]->signal_connect("activate" ,sub {$self->searchItem('multiperfield')});
        
        $subMenuSearch[3]=Gtk2::ImageMenuItem->new_with_mnemonic($self->{parent}->{lang}->{PanelSearchContextOptions});
        $subMenuSearch[3]->signal_connect("activate" ,sub {$self->{parent}->options(0,3)});
        
        $self->{searchButton}->setContextMenu(\@subMenuSearch);
        $self->{searchButton}->enableContextMenu;
        $self->{tooltips}->set_tip($self->{searchButton}, $self->{parent}->{lang}->{PanelSearchTip}, '');
        push @{$self->{toDestroy}}, $self->{searchButton};
        
        $self->{deleteButton} = GCButton->newFromStock('gtk-delete');
        $self->{deleteButton}->signal_connect("clicked" => \&deleteItem, $self);
        $self->{tooltips}->set_tip($self->{deleteButton}, $self->{parent}->{lang}->{PanelRemoveTip}, '');
        push @{$self->{toDestroy}}, $self->{deleteButton};
        
        $self->{refreshButton} = new GCButton($self->{parent}->{lang}->{PanelRefresh});
        $self->{refreshButton}->signal_connect("clicked" =>  sub {
            $self->searchItem('refresh');
            });
        $self->{tooltips}->set_tip($self->{refreshButton}, $self->{parent}->{lang}->{PanelRefreshTip}, '');
        push @{$self->{toDestroy}}, $self->{refreshButton};
    }

    sub new
    {
        my ($proto, $parent, $options, $layout) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent, $options, $layout);

        bless ($self, $class);

        $self->{withSeparator} = 1;
        $self->{locked} = 0;
        $self->{colSpacing} = $self->{margin};
        $self->{rowSpacing} = $self->{halfMargin};

        $self->{mainBox} = new Gtk2::VBox(0, 0);
        $self->{mainBox}->set_border_width($self->{margin});

        $self->set_name('GCItemFrame');

        my $realMain = new Gtk2::VBox(0,0);

        $realMain->pack_start($self->{mainBox},1,1,0);
        $self->{layoutBox} = $self->{mainBox};

        $self->add($realMain);
        $self->show_all;

        $self->{warning} = new Gtk2::Label;
        
        $self->{infoBox}->pack_start($self->{warning},1,1,0);
        $self->{infoBox}->pack_start($self->{viewAllBox},1,1,0);
        $realMain->pack_start($self->{infoBox},1,1,0);
        
        return $self;
    }
    
    sub isReadOnly
    {
        return 0;
    }

    sub searchItem
    {
        my ($self, $pluginType) = @_;

        #$self->{parent}->searchItemForPanel($self->{$self->{model}->{commonFields}->{title}}->getValue, $self);
        if ($pluginType eq 'refresh')
        {
            $self->{parent}->refreshItemForPanel($self, $self->{$self->{model}->{commonFields}->{url}}->getValue);
        } 
        else
        {
            $self->{parent}->searchItemForPanel($self, $pluginType);
            $self->showMe;
        }
    }

    sub checkBorrowerButtons
    {
        my $self = shift;
        my $borrowerField = $self->{model}->{commonFields}->{borrower}->{name};
        return if ! $self->{$borrowerField};
        my $locked = (($self->{$borrowerField}->getValue eq 'none')
                   || ($self->{$borrowerField}->getValue eq 'unknown'));
        $self->{mailButton}->lock($locked)
            if $self->{mailButton};
        $locked = ($self->{locked} || ($self->{$borrowerField}->getValue eq 'none'));
        $self->{itemBackButton}->lock($locked)
            if $self->{itemBackButton};
    }
    
    sub itemBack
    {
        my $self = shift;

        my $isBack = 0;
        my $dialog = new GCDateSelectionDialog($self->{parent}, $self->{lang}->{PanelReturned});
        if ($dialog->show)
        {
            my $borrowerField = $self->{model}->{commonFields}->{borrower}->{name};
            my $lendDateField = $self->{model}->{commonFields}->{borrower}->{date};
            my $borrowingsField = $self->{model}->{commonFields}->{borrower}->{history};
            my $coverField = $self->{model}->{commonFields}->{cover};
            my @data = ($self->{$borrowerField}->getDisplayedValue,
                        $self->{$lendDateField}->getValue,
                        $dialog->date);
            foreach (@data[1..2])
            {
                $_ = $self->prepareDate($_);
            }
            $self->{$borrowingsField}->addValues(@data);
            my $previous = $self->getAsHash;
            $self->{$borrowerField}->setValue('none');
            $self->{$lendDateField}->clear;
            my $new = $self->getAsHash;
            $self->{parent}->{itemsView}->changeCurrent($previous, $new, $self->{parent}->{items}->getCurrent, 1)
                if $self->$coverField;
            $isBack = 1;
        }
        $self->showMe;
        return $isBack;
    }
    
    sub lock
    {
        my ($self, $value) = @_;
        $self->changeState($self, $value);
    }
    
    sub deactivate
    {
        my $self = shift;
        $self->changeState($self,1);
    }

    sub changeState
    {
        my ($caller, $self, $locked)  = @_;
        $locked = 1 if $self->{parent}->{items}->getLock;
        return if $self->{locked} == $locked;
        $self->{locked} = $locked;
        my $info;
        foreach (@{$self->{parent}->{model}->{fieldsNames}})
        {
            $info = $self->{model}->{fieldsInfo}->{$_};
            next if $info->{type} eq 'button';
            $self->{$_}->lock($locked) if ($self->{$_});
        }

        $self->{searchButton}->lock($locked);
        $self->checkBorrowerButtons;
        $self->{deleteButton}->lock($locked);
        $self->{refreshButton}->lock($locked);
    }
    
    sub setShowOptionForSpecials
    {
        my ($self, $show, $hasToShow) = @_;

        if (! $show->{$self->{model}->{commonFields}->{borrower}->{name}})
        {
            $self->{mailButton}->hide;
            $self->{itemBackButton}->hide;
        }
   }

    sub setBorrowers
    {
        my $self = shift;

        return if ! $self->{borrowerControl};
  
        my $borrowers = $self->{model}->getValues($self->{model}->{commonFields}->{borrower}->{name});
        shift @{$borrowers} if !$borrowers->[0]->{displayed};
        $self->{borrowerControl}->setValues($borrowers);

        return;
    }

    sub sendBorrowerEmail
    {
        use GCDialogs;

        my $self = shift;

        my %info;
        $info{title} = $self->{$self->{model}->{commonFields}->{title}}->getValue;
        $info{borrower} = $self->{$self->{model}->{commonFields}->{borrower}->{name}}->getValue;
        $info{lendDate} = $self->prepareDate(
            $self->{$self->{model}->{commonFields}->{borrower}->{date}}->getValue
        );
        $self->{parent}->sendBorrowerEmail(\%info);
    }

    sub selectTitle
    {
        my $self = shift;
        my $titleField = $self->{model}->{commonFields}->{title};
        #$self->{$titleField}->select_region(0, length($self->{$titleField}->getValue));
        $self->{$titleField}->selectAll;
    }

    sub deleteItem
    {
       my ($widget, $self) = @_;

       $self->{parent}->deleteCurrentItem;
    }

    sub createItem
    {
        my ($self, $info) = @_;
        
        my $widget;
        
        if (exists $info->{linkedto})
        {
            $widget = new GCLinkedComponent($self->{$info->{linkedto}});
        }
        elsif ($info->{type} eq 'short text')
        {
            $widget = new GCShortText;
            $widget->signal_connect('activate', sub {
                $self->searchItem;
            }) if $self->{model}->isSearchField($info->{value});
        }
        elsif ($info->{type} eq 'long text')
        {
            $widget = new GCLongText;
            $widget->setSpellChecking($self->{parent}->{options}->spellCheck);
            push @{$self->{longTextFields}}, $widget;
        }
        elsif ($info->{type} eq 'history text')
        {
            $widget = new GCHistoryText;
        }
        elsif ($info->{type} eq 'options')
        {
            $info->{values} = $info->{value} if !$info->{values};
            if ($info->{value} eq $self->{model}->{commonFields}->{borrower}->{name})
            {
                $widget = new GCMenuList;
                #When borrower not found, we use the last choice: unknown
                $widget->setLastForDefault;
                $self->{borrowerControl} = $widget;
                $widget->signal_connect('changed' => sub {
                    $self->checkBorrowerButtons;
                });
                $self->setBorrowers;
            }
            else
            {
                $widget = new GCMenuList($self->{model}->getValues($info->{values}), $info->{separator});
            }
        }
        elsif ($info->{type} =~ /list$/o)
        {
            my $number;
            my $readonly = 0;
            my $withHistory = 1;
            my @types;
            my @labels;
            $withHistory = 0
                if (exists $info->{history}) && ($info->{history} eq 'false');
            $readonly = 1
                if $info->{value} eq $self->{model}->{commonFields}->{borrower}->{history};
            $number = GCUtils::listNameToNumber($info->{type});
            @types=split / / ,$info->{subtypes} if $info->{subtypes};
            my $typesRef = \@types;
            undef $typesRef if scalar(@types)!=$number;
            if ($number == 1)
            {
                @labels = ($self->{model}->getDisplayedText($info->{label}));
            }
            else
            {
                for my $i (1..$number)
                {
                    push @labels, $self->{model}->getDisplayedText($info->{'label'.$i});
                }
            }
            $widget = new GCMultipleList($self, $number, \@labels, $withHistory, $readonly,0,$typesRef);
        }
		elsif ($info->{type} eq 'checked text')
		{
			$widget = new GCCheckedText($info->{format});
			$widget->signal_connect('activate', sub {
				$self->searchItem;
			}) if $self->{model}->isSearchField($info->{value});
		}
        elsif ($info->{type} eq 'number')
        {
            if (($info->{displayas} eq 'graphical')
             && ($self->{parent}->{options}->useStars))
            {
                $widget = new GCNumeric($info->{init}, 0, $info->{max}, 0, 'graphical');
            }
            else
            {
                if ((exists $info->{min}) && ($info->{min} ne ''))
                {
                    $widget = new GCNumeric($info->{init}, 
                                            $info->{min},
                                            $info->{max},
                                            $info->{step},
                                            'text');
                }
                else
                {
                    $widget = new GCCheckedText('0-9.');
                    $widget->setReadOnly
                        if ($info->{value} eq $self->{model}->{commonFields}->{id});
                }
                $widget->signal_connect('activate', sub {
                    $self->searchItem;
                }) if $self->{model}->isSearchField($info->{value});
            }
        }
        elsif ($info->{type} eq 'image')
        {
            my $img = new GCItemImage($self->{parent}->{options}, 
                                      $self->{parent});
            my $isCover = 0;
            $isCover = 1 if $info->{value} eq $self->{model}->{commonFields}->{cover};
            #$img->setImmediate if $isCover;
            $widget = new GCImageButton($self, $img, $isCover, $info->{default});
        }
        elsif ($info->{type} eq 'button')
        {
            if ($info->{format} eq 'url')
            {
                $widget = new GCUrlButton($self->{model}->getDisplayedText($info->{label}),
                                          $self->{parent});
                $info->{tip} = $self->{lang}->{PanelWebTip}
                    if $info->{value} eq $self->{model}->{commonFields}->{url};
            }
            else
            {
                $widget = new GCButton($self->{model}->getDisplayedText($info->{label}));
            }
        }
        elsif ($info->{type} eq 'url')
        {
            $widget = new GCUrl($self->{parent});
        }
        elsif ($info->{type} eq 'yesno')
        {
            $widget = new GCCheckBox($self->{model}->getDisplayedText($info->{label}));
        }
        elsif ($info->{type} eq 'file')
        {
            $widget = new GCFile($self, undef, undef, undef, undef, 1, $info->{format});
        }
        elsif ($info->{type} eq 'date')
        {
            $widget = new GCDate($self, $self->{lang}, 0,
                                 $self->{parent}->{options}->dateFormat);
            push @{$self->{dateFields}}, $widget;
        }
        elsif ($info->{type} eq 'formatted')
        {
            $widget = new GCShortText;
            $widget->setReadOnly;
            $self->setAsFormatted($widget, $info->{value}, $info->{init});
        }
        else
        {
            print "Invalid type : ",$info->{type}," for ",$info->{value},"\n";
            $widget = 0;
        }
        
        $widget->{name} = $info->{value} if $widget;
        $self->{tooltips}->set_tip($widget, $self->{model}->getDisplayedText($info->{tip}), '')
            if $info->{tip};
        $widget->activateStateTracking;
        return $widget;
    }
    
    sub getValues
    {
        my ($self, $field) = @_;
        return $self->{$field}->getValues
            if exists $self->{$field};
        return [];
    }
    
    sub AUTOLOAD
    {
        return if our $AUTOLOAD =~ /::DESTROY$/;
        (my $name = $AUTOLOAD) =~ s/.*?::(.*)/$1/;
        return if !$name;
        my $self = $_[0];
        no strict 'refs';
        {
            *{$AUTOLOAD} = sub {
                my $self = shift;
                return 0 if !$self->{$name};
                return $self->{$name}->getValue
                    if !(scalar @_);
                $self->{$name}->setValue(shift);
            };
        }
        goto &{$AUTOLOAD};
    }
}

1;
