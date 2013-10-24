package GCExportImport;

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

{
    package GCExportImportBase;
    
    sub setLangName
    {
        my ($self, $langName) = @_;
        
        $self->{langName} = $langName;
    }
    
    sub getLang
    {
        my ($self) = @_;
        if (! $self->{langContainer})
        {
            my $langFile = $self->{moduleName};
            my %tmpLang;
            eval "use GCLang::".$self->{langName}."::$langFile\n";
            eval "%tmpLang = %GCLang::".$self->{langName}."::".$langFile."::lang";
            $self->{langContainer} = \%tmpLang;
        }
        return $self->{langContainer};
    }

    sub getName
    {
        my $self = shift;
        
        return $self->getLang->{Name};
    }
    
    sub setModel
    {
        my ($self, $model) = @_;
        $self->{model} = $model;
    }
    
    sub checkModule
    {
        my ($self, $module, $version) = @_;

        eval "use $module";
        ($self->{errors} .= "$module\n", return 0) if $@;
        return 1 if !defined $version;
        no strict 'refs';
        ($self->{errors} .= "$module\n", return 0)
            if (${$module.'::VERSION'} < $version);
        return 1;
    }
    
    sub checkOptionalModule
    {
        my ($self, $module, $version) = @_;
        # Save errors
        my $errors = $self->{errors};
        my $code = $self->checkModule($module, $version);
        # And restore them so it won't impact detecting if the module is broken
        $self->{errors} = $errors;
        return $code;
    }
    
    sub hideFileSelection
    {
        return 0;
    }
    
    sub new
    {
        my ($proto) = @_;
        my $class = ref($proto) || $proto;
        
        (my $moduleName = $class) =~ s/(GC..port)er/$1/;
        
        my $self = {moduleName => $moduleName,
                    errors => ''};
        bless($self, $class);
        return $self;
    }
}

use GCDialogs;

{
    package GCExportImportDialog;
    use base 'GCModalDialog';

    sub show
    {
        my $self = shift;
        $self->SUPER::show();
        $self->show_all;
        
        $self->{optionsFrame}->hide if ! $self->{nbOptions};
        if (($self->{type} eq 'export') && (! $self->{module}->wantsSort))
        {
            $self->{sorter}->hide;
            $self->{sortLabel}->hide;
            $self->{order}->hide;
            $self->{orderLabel}->hide;
        }

        if ($self->{module}->hideFileSelection)
        {
            $self->{file}->hide;
            $self->{labelFile}->hide;
        }
        
        $self->resize(1,1);
        my $ok = 0;
        while (!$ok)
        {
            my $response = $self->run;
            if ($response eq 'ok')
            {
                if (($self->{module}->wantsFieldsSelection)
                    && (scalar @{$self->{fields}} == 0))
                {
                    my $dialog = Gtk2::MessageDialog->new($self,
                                                              [qw/modal destroy-with-parent/],
                                                              'error',
                                                              'ok',
                                                              $self->{parent}->{lang}->{ImportExportFieldsEmpty});

                    $dialog->set_position('center-on-parent');
                    $dialog->run();
                    $dialog->destroy;
                    next;
                }
                my $file = $self->{file}->getValue;
                if ($file || ! $self->{module}->wantsFileSelection)
                {
                    my %options = $self->getOptions;     
                    $self->addOptions(\%options);
                    $options{model} = $self->{parent}->{model};
                    $options{file} = $file;
                    $options{lang} = $self->{parent}->{lang};
                    $options{fields} = $self->{fields};
                    $options{fieldsInfo} = $self->{parent}->{model}->{fieldsInfo};
                    $options{originalList} = $self->{parent}->{items};
                    $options{parent} = $self->{parent};
                    
                    my ($info, $type) = $self->{module}->process(\%options);
                    $type ||= 'info';
                    if ($info)
                    {
                        my $dialog = Gtk2::MessageDialog->new($self,
                                                              [qw/modal destroy-with-parent/],
                                                              $type,
                                                              'ok',
                                                              $info);

                        $dialog->set_position('center-on-parent');
                        $dialog->run();
                        $dialog->destroy ;
                    }
                    $self->{parent}->setNbItems;
                }
                else
                {
                    my $dialog = Gtk2::MessageDialog->new($self,
                                                          [qw/modal destroy-with-parent/],
                                                          'error',
                                                          'ok',
                                                          $self->{parent}->{lang}->{ImportExportFileEmpty});

                    $dialog->set_position('center-on-parent');
                    $dialog->run();
                    $dialog->destroy;
                
                    next;
                }
            }
            $ok = 1;
        }
        $self->hide;
    }

    sub setModule
    {
        my ($self, $module) = @_;
        $self->set_title($self->{title}." [".$module->getName."]");
        if ($module->wantsDirectorySelection)
        {
            $self->{labelFile}->set_label($self->{parent}->{lang}->{FileChooserDirectory});
            $self->{file}->setTitle($self->{parent}->{lang}->{FileChooserOpenDirectory});
            $self->{file}->setType('select-folder', 0);
        }
        else
        {
            $self->{labelFile}->set_label($self->{parent}->{lang}->{ImportExportFile});
            $self->{file}->setTitle($self->{parent}->{lang}->{FileChooserOpenFile});
            $self->{file}->setType($self->{fileType}, $self->{withFilter});
        }
        $self->{file}->setPatternFilter($module->getFilePatterns)
            if ($self->{type} eq 'import');

        $module->setModel($self->{parent}->{model});
        # sorter will only be created for export modules.
        # It's initialized with the title field
        if ($self->{sorter})
        {
            $self->{sorter}->setModel($self->{parent}->{model});
            $self->{sorter}->setValue($self->{parent}->{model}->{commonFields}->{title});
            $self->{sorter}->setValue($module->{options}->{sorter})
                if exists $module->{options};
        }
        if ($self->{order})
        {
            $self->{order}->setValue(0);
            $self->{order}->setValue($module->{options}->{order})
                if exists $module->{options};
        }
        foreach ($self->{optionsTable}->get_children)
        {
            $self->{optionsTable}->remove($_);
            $_->destroy;
        }
        my @optionsList = @{$module->getOptions};
        $self->{optionsTable}->resize($#optionsList + 1, 3)
            if $#optionsList >= 0;
        
        $self->{module} = $module;
        my %options;
        my $option;
        my $row = 0;
        my @widgetSignals;
        foreach $option (@optionsList)
        {
            my $label = $module->getLang->{$option->{label}};
            if (!$label)
            {
                if ($self->{parent}->{model})
                {
                    $label = $self->{parent}->{model}->getDisplayedText($option->{label});
                }
                else
                {
                    $label = $self->{parent}->{lang}->{$option->{label}};
                }
            }
            my $widget;
            my @vExpand = ('fill');
            my $type = $option->{type};
            my $value = ((exists $module->{options}) ? $module->{options}->{$option->{name}} : $option->{default});
            if ($type eq 'yesno')
            {
                $widget = new GCCheckBox($label);
                $self->{optionsTable}->attach($widget, 0, 2, $row, $row + 1, 'fill', 'fill', 0, 0);
                if ($option->{changedCallback})
                {
                    $widget->signal_connect('toggled' => $option->{changedCallback}, [$self,$widget]);
                    push @widgetSignals, [$widget, 'toggled'];
                }
            }
            elsif ( ($type eq 'short text') || 
                      ($type eq 'long text') ||
                      ($type eq 'number') ||
                      ($type eq 'options') ||
                      ($type eq 'file') ||
                      ($type eq 'history text'))
            {
                my $labelWidget = GCLabel->new($label);
                $self->{optionsTable}->attach($labelWidget, 0, 1, $row, $row + 1, 'fill', 'fill', 0, 0);

                if ($type eq 'short text')
                {
                    $widget = new GCShortText;
                }
                elsif ($type eq 'long text')
                {
                    $widget = new GCLongText;
                    $widget->set_size_request(-1,$option->{height});
                    push @vExpand, 'expand';
                }
                elsif ($type eq 'number')
                {
                    $widget = new GCNumeric($value, $option->{min}, $option->{max}, $option->{step});
                    
                }
                elsif ($type eq 'file')
                {
                    $widget = new GCFile($self, $label, 'open');
                }
                elsif ($type eq 'options')
                {
                    $widget = new GCMenuList;
                    my @valuesList;
                    if (UNIVERSAL::isa( $option->{valuesList}, "HASH" ))
                    {
                        foreach $value(keys %{$option->{valuesList}})
                        {
                            my $item = {
                                           value => $value,
                                           displayed => $option->{valuesList}->{$value}
                                       };
                            $item->{displayed} = $module->getLang->{$item->{displayed}}
                                if ($module->getLang->{$item->{displayed}});
                            push @valuesList, $item;
                        }
                    }
                    else
                    {
                        my @values;
                        @values=split m/,/,$option->{valuesList} if(scalar($option->{valuesList}));
                        @values=@{$option->{valuesList}} if (UNIVERSAL::isa( $option->{valuesList}, "ARRAY" ));
                        foreach $value(@values)
                        {
                            my $item = {
                                           value => $value,
                                           displayed => $value
                                       };
                            $item->{displayed} = $module->getLang->{$item->{displayed}}
                                if ($module->getLang->{$item->{displayed}});
                            push @valuesList, $item;
                        }
                    }
                    $widget->setValues(\@valuesList);
                    if ($option->{changedCallback})
                    {
                        $widget->signal_connect('changed' => $option->{changedCallback}, [$self,$widget]);
                        push @widgetSignals, [$widget, 'changed'];
                    }
                }
                elsif ($type eq 'history text')
                {
                    $widget = new GCHistoryText;
                    my @initValues = @{$option->{initValues}} if $option->{initValues};
                    $widget->setValues(\@initValues);
                }
                if ($option->{changedCallback})
                {
                    $widget->signal_connect('changed' => $option->{changedCallback}, [$self,$widget]);
                    push @widgetSignals, [$widget, 'changed'];
                }
                if ($option->{buttonLabel})
                {
                    my $button = Gtk2::Button->new($module->getLang->{$option->{buttonLabel}});
                    $button->signal_connect('clicked' => $option->{buttonCallback}, [$self,$widget]);
                    $self->{optionsTable}->attach($button, 2, 3, $row, $row + 1, 'fill', 'fill', 0, 0);
                }
                $self->{optionsTable}->attach($widget, 1, 2, $row, $row + 1, ['expand', 'fill'], \@vExpand, 0, 0);
            }
#            elsif ($type eq 'colorSelection')
#            {
#                $widget = new Gtk2::HBox(0,0);
#                $widget->pack_start(new Gtk2::Label($label), 0,0,0);
#                my $entry = new Gtk2::Entry;
#                $entry->set_text($value);
#                $widget->pack_start($entry, 1,1,5);
#
#                my $button = Gtk2::Button->new_from_stock('gtk-select-color');
#                $button->signal_connect('clicked' => sub {
#                    my $dialog = new Gtk2::ColorSelectionDialog($label);
#                    my $previous = Gtk2::Gdk::Color->parse($entry->get_text);
#                    $dialog->colorsel->set_current_color($previous) if $previous;
#                    my $response = $dialog->run;
#                    if ($response eq 'ok')
#                    {
#                        my $color = $dialog->colorsel->get_current_color;
#                        my $red = $color->red / 257;
#                        my $blue = $color->blue / 257;
#                        my $green = $color->green / 257;
#                        my $colorString = sprintf ("#%X%X%X", $red, $blue, $green);
#                        $entry->set_text($colorString);
#                    }
#                    $dialog->destroy;
#                });
#                $widget->pack_start($button, 0,0,0);
#            }
            $widget->set_sensitive(0) if $option->{insensitive};
            $widget->setValue($value);
            $self->{parent}->{tooltips}->set_tip($widget,
                                                 $module->getLang->{$option->{tooltip}})
                if $option->{tooltip};
            $options{$option->{name}} = $widget;
            $row++;
        }
        
        $options{withPictures} = new GCCheckBox($self->{parent}->{lang}->{ExportWithPictures});
        if ($module->wantsImagesSelection)
        {
            $self->{optionsTable}->resize($row, 3);
            my $value = ((exists $module->{options}) ? $module->{options}->{withPictures} : 1);
            $options{withPictures}->set_active($value);
            $self->{optionsTable}->attach($options{withPictures}, 0, 2, $row, $row + 1, 'fill', 'fill', 0, 0);
            $row++;
            $options{withPictures}->show;
        }
        else
        {
            $options{withPictures}->set_active(0);
        }
        
        if ($module->wantsFieldsSelection)
        {
            $self->{optionsTable}->resize($row, 3);
            $self->{fieldsSelection} = new Gtk2::Button($self->{fieldsButtonLabel});
            $self->{parent}->{tooltips}->set_tip($self->{fieldsSelection},
                                                 $self->{fieldsTip});
            $self->{optionsTable}->attach($self->{fieldsSelection},
                                          0, 1, $row, $row + 1, 'fill', 'fill', 0, 0);
            $self->{fieldsSelection}->signal_connect('clicked' => sub {
                $self->{fields} = $self->{fieldsDialog}->getSelectedIds
                    if $self->{fieldsDialog}->show;
            });
            $row++;
        }

        $self->{nbOptions} = $row;
        $self->{options} = \%options;
        $self->{optionsFrame}->show_all;
        foreach my $pair(@widgetSignals)
        {
            $pair->[0]->signal_emit($pair->[1])
        }
        
    }
    
    sub getOptions
    {
        my $self = shift;
        my %result;
        
        foreach (keys %{$self->{options}})
        {
            my $value;
            my $widget = $self->{options}->{$_};
            $result{$_} = $widget->getValue;
        }
        
        return %result;
    }
    
    sub new
    {
        my ($proto, $parent, $title, $type) = @_;
        my $class = ref($proto) || $proto;
        
        my $okLabel;
        #$okLabel = $parent->{lang}->{'Menu'.ucfirst($type)};
        $okLabel = ($type eq 'import') ? 'gtk-convert' : 'gtk-revert-to-saved';
        $okLabel =~ s/_//g;
        
        my $self  = $class->SUPER::new($parent,
                                       $title,
                                       $okLabel
                                      );

        $self->{parent} = $parent;
        $self->{title} = $title;
        $self->{lang} = $parent->{lang};
        $self->{fields} = [];
        $self->{type} = $type;
        
        $self->{optionsFrame} = new GCGroup($parent->{lang}->{OptionsTitle});
        $self->{optionsTable} = new Gtk2::Table(0,3);
        $self->{optionsTable}->set_border_width($GCUtils::halfMargin);
        $self->{optionsTable}->set_col_spacings($GCUtils::margin);
        $self->{optionsTable}->set_row_spacings($GCUtils::halfMargin);
        $self->{optionsFrame}->addWidget($self->{optionsTable});

        #$self->{fileVbox} = new Gtk2::VBox(0,0);

        #my $sep = new Gtk2::HSeparator;
        #my $hbox = new Gtk2::HBox(0,0);
        
        $self->{dataFrame} = new GCGroup($parent->{lang}->{ImportExportData});
        $self->{dataTable} = new Gtk2::Table(1,2);
        $self->{dataTable}->set_border_width($GCUtils::halfMargin);
        $self->{dataTable}->set_col_spacings($GCUtils::margin);
        $self->{dataTable}->set_row_spacings($GCUtils::halfMargin);
        $self->{dataFrame}->addWidget($self->{dataTable});
        
        $self->{labelFile} = new GCLabel($parent->{lang}->{ImportExportFile});
        #$hbox->pack_start($labelFile,0,0,5);
        
        $self->{fileType} = ($type eq 'import') ? 'open' : 'save';
        $self->{withFilter} = ($self->{type} eq 'import') ? 1 : 0;
        $self->{file} = new GCFile($self,
                                   $parent->{lang}->{FileChooserOpenFile},
                                   $self->{fileType},
                                   $self->{withFilter});

        #$hbox->pack_start($self->{file},1,1,5);

        #$self->{fileVbox}->pack_start($sep, 0, 0, 2);
        #$self->{fileVbox}->pack_start($hbox, 0, 0, 10);

        $self->vbox->set_homogeneous(0);
        $self->vbox->pack_start($self->{optionsFrame},1,1,0);
        $self->vbox->pack_start($self->{dataFrame},0,0,0);
        #$self->vbox->pack_start($self->{fileVbox}, 0, 0, 0);

        bless ($self, $class);
        return $self;
    }
    
}

1;
