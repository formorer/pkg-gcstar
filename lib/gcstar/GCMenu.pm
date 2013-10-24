package GCMenu;

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
{
    package GCMenuBar;
    use base 'Gtk2::MenuBar';

    use GCExport;
    use GCImport;
    use GCStats;

    sub addHistoryMenu
    {
        my ($self, $historyArray) = @_;
        my $parent = $self->{parent};

        my @tmpHistory;
        if (! $historyArray)
        {
            my @tmpHistory = split(/\|/, $parent->{options}->history);
            $historyArray = \@tmpHistory;
        }
        foreach my $filename(@$historyArray)
        {
            next if !$filename || ($filename eq 'none');
            my $item = Gtk2::MenuItem->new_with_label($filename);
            $item->signal_connect ('activate' => sub {
                        $parent->openFile($filename);
                    });
            $self->{menuHistory}->append($item);
            $item->show();
        }
        $self->{menuHistoryItem}->set_submenu($self->{menuHistory});
    }

    sub setBookmarks
    {
        my ($self, $bookmarks) = @_;
        $self->{bookmarks} = $bookmarks;
        $self->addBookmarksDir($self->{bookmarks}, undef);
        $self->{menuBookmarks}->show_all;
    }

    sub clearBookmarks
    {
        my $self = shift;
        my $i = 0;
        foreach ($self->{menuBookmarks}->get_children)
        {
            $i++;
            next if ($i < 4 + ($self->{parent}->{options}->tearoffMenus ? 1 : 0));
            $self->{menuBookmarks}->remove($_);
            $_->destroy;
        }
    }
    
    sub addBookmarksDir
    {
        my ($self, $dir, $parent) = @_;
        if ($parent)
        {
            my $subMenu = Gtk2::Menu->new();
            my $item = Gtk2::MenuItem->new_with_mnemonic($dir->{name});
            $item->set_submenu($subMenu);
            $parent->append($item);
            $parent = $subMenu;
            $dir->{menu} = $subMenu;
        }
        else
        {
            $parent = $self->{menuBookmarks};
        }
        foreach my $sub(@{$dir->{dir}})
        {
            $self->addBookmarksDir($sub, $parent);
        }
        return if !$dir->{file};
        foreach my $file(@{$dir->{file}})
        {
            $self->addBookmark($file, $parent);
        }
    }
    
    sub addBookmark
    {
        my ($self, $bookmark, $parent) = @_;
        
        my $item = Gtk2::MenuItem->new_with_mnemonic($bookmark->{name});
        $item->signal_connect ('activate' => sub {
                    $self->{parent}->openFile($bookmark->{path});
                });        
        $parent->append($item);
        
    }

    sub setModel
    {
        my ($self, $model) = @_;
        $self->{model} = $model;
        $self->createFilters($model,
                             $model->{fieldsInfo});
        $self->initExportImportList($model);
        
        # Update menu labels which are collection dependant
        $self->updateMenus;

    }
    
    sub updateItem
    {
        my ($self, $item, $label) = @_;
        foreach my $child($item->get_children)
        {
            if ($child->isa('Gtk2::Label'))
            {
                $child->set_label($self->{parent}->{lang}->{$label});
            }
        }
    }

    sub updateMenus
    {
        my ($self) = @_;
        
        # Update labels which are collection dependant
	# list for each item is: [parent, item name, label index in language]
        foreach (
                 # Menu labels
                 [$self, 'viewAllItems', 'MenuViewAllItems'],
                 [$self, 'menuLend', 'MenuLend'],
                 [$self, 'duplicateItem', 'MenuDuplicate'],
                 [$self, 'newitem', 'MenuAddItem'],
                 [$self, 'deleteCurrentItem', 'MenuEditDeleteCurrent'],
                 [$self, 'selectAllItem', 'MenuEditSelectAllItems'],
                 [$self, 'defaultValues', 'MenuDefaultValues'],
                 # Context menu labels
                 [$self->{parent}, 'contextNewWindow', 'MenuNewWindow'],
                 [$self->{parent}, 'contextDuplicateItem', 'MenuDuplicate'],
                 [$self->{parent}, 'contextSelectAllItem', 'MenuEditSelectAllItems'],
                 [$self->{parent}, 'contextItemDelete', 'MenuEditDeleteCurrent'],
                 [$self->{parent}, 'contextViewAllItems', 'MenuViewAllItems'],
                )
        {
            $self->updateItem($_->[0]->{$_->[1]}, $_->[2]);
        }
    }

    sub initFilters
    {
        my ($self, $info) = @_;

        $self->selectAll(1);
        $self->block;
        my $fieldsInfo = $self->{fieldsInfo};
        foreach (keys %$info)
        {
            my $activeIdx = 0;
            my $filtersInfo = $self->{filtersInfo}->{$_};
            next if !$filtersInfo;
            
            if ($fieldsInfo->{$_}->{type} eq 'options')
            {
                foreach my $valueInfo(@{$self->{model}->getValues($fieldsInfo->{$_}->{'values'})})
                {
                    last if $valueInfo->{value} eq $info->{$_};
                    $activeIdx++;
                }
                $activeIdx++ if $activeIdx >= $fieldsInfo->{$_}->{separator};
            }
            elsif ($fieldsInfo->{$_}->{type} eq 'number')
            {
                #The value that means no check
                my $boundary = $fieldsInfo->{$_}->{min};
                $boundary = $fieldsInfo->{$_}->{max}
                    if ($filtersInfo->{type}->{comparison} =~ /^l/);
                if ($info->{$_} != $boundary)
                {
                    $activeIdx = 1;
                    $self->{numberValues}->{$_} = $info->{$_};
                }
            }
            elsif ($fieldsInfo->{$_}->{type} eq 'date')
            {
                #The value that means no check
                if ($info->{$_})
                {
                    $activeIdx = 1;
                    $self->{dateValues}->{$_} = $info->{$_};
                }
            }
            elsif (($fieldsInfo->{$_}->{type} eq 'history text')
                || ($fieldsInfo->{$_}->{type} eq 'single list'))
            {
                my @values;
                @values = @{$self->{parent}->{panel}->getValues($_)}
                    if ($fieldsInfo->{$_}->{type} eq 'history text');
                @values = @{$self->{parent}->{panel}->getValues($_)->[0]}
                    if ($fieldsInfo->{$_}->{type} eq 'single list');
                foreach my $value(@values)
                {
                    last if $value eq $info->{$_};
                    $activeIdx++;
                }
                $activeIdx = 0 if $activeIdx >= $#values;
            }
            elsif ($fieldsInfo->{$_}->{type} eq 'yesno')
            {
                $activeIdx = 1;
                $activeIdx = 0 if (($filtersInfo->{values} eq 'off') && ($info->{$_} == 1))
                               || (($filtersInfo->{values} eq 'on') && ($info->{$_} == 0));
                $activeIdx = 2 if ($filtersInfo->{values} eq 'both') && ($info->{$_} == 0);
            }
            
            $self->{'menuFilter'.$_}->set_active($activeIdx);
            $self->{'menuFilter'.$_}->get_active->set_active(1);
        }

        $self->unblock;
    }
    
    sub initExportImportList
    {
        my ($self, $model) = @_;
        
        my $modelName = $model->getName;
        #It will hide the export/import modules that don't support current model
        # This code may be factorized.
        foreach my $exporter(@GCExport::exportersArray)
        {
            my $item = $self->{exporters}->{$exporter->getName};
            my @models = @{$exporter->getModels};
            my $show = 0;
            $show = 1 if !@models;
            foreach (@models)
            {
                $show = 1 if $modelName eq $_;
                last if $show;
            }
            $item->hide if !$show;
            $item->show if $show;
        }
        foreach my $importer(@GCImport::importersArray)
        {
            my $item = $self->{importers}->{$importer->getName};
            my @models = @{$importer->getModels};
            my $show = 0;
            $show = 1 if (!$importer->shouldBeHidden || !@models);
            foreach (@models)
            {
                $show = 1 if $modelName eq $_;
                last if $show;
            }
            $item->hide if !$show;
            $item->show if $show;
        }
    }
    
    sub createFilters
    {
        my ($self, $model, $fieldsInfo) = @_;
        foreach (@{$self->{existingFilters}})
        {
            $self->{menuDisplay}->remove($_);
            $_->destroy;
        }

        $self->{existingFilters} = [];
        $self->{existingFiltersMenu} = [];
        $self->{dynamicFilters} = {};
        $self->{fieldsInfo} = $fieldsInfo;
        $self->{filtersInfo} = {};
        my $position = ($self->{parent}->{options}->tearoffMenus ? 1 : 0);
        $self->createUserFilters($model, $position + 1);
        foreach my $filter(@{$model->{filters}})
        {
            next if (!defined $filter->{quick}) || ($filter->{quick} ne 'true');
            my $field = $filter->{field};
            $self->{filtersInfo}->{$field} = $filter;
            $self->{'menuFilter'.$field} = Gtk2::Menu->new;
            $self->{'menuFilter'.$field}->set_accel_path("<main>/Filter/$field");
            $self->{'menuFilter'.$field}->set_accel_group($self->{accel});
            
            my $all = Gtk2::RadioMenuItem->new_with_mnemonic(undef,$self->{parent}->{lang}->{MenuNoFilter});
            $self->{'group'.$field} = $all->get_group();
            $self->{'menuFilter'.$field}->append($all);
            $all->signal_connect('activate' => sub {
                $self->changeFilter(shift, $field, '');
            });

            if (($fieldsInfo->{$field}->{type} eq 'history text') ||
                ($fieldsInfo->{$field}->{type} eq 'single list'))
            {
                $self->{dynamicFilters}->{$field} = 1;
                #$self->checkFilter($field);
            }
            elsif ($fieldsInfo->{$field}->{type} eq 'yesno')
            {
                $filter->{'values'} = 'both' if ! $filter->{'values'} ;
                if (($filter->{'values'} eq 'on') || ($filter->{'values'} eq 'both'))
                {
                    my $labelOn = $filter->{labelon} || 'CheckYes';
                    my $on = Gtk2::RadioMenuItem->new_with_mnemonic($self->{'group'.$field},
                                                                    $model->getDisplayedText($labelOn));
                    $self->{'menuFilter'.$field}->append($on);
                    $on->signal_connect('activate' => sub {
                        $self->changeFilter(shift, $field, 1);
                    });
                }
                if (($filter->{'values'} eq 'off') || ($filter->{'values'} eq 'both'))
                {
                    my $labelOff = $filter->{labeloff} || 'CheckNo';
                    my $off = Gtk2::RadioMenuItem->new_with_mnemonic($self->{'group'.$field},
                                                                     $model->getDisplayedText($labelOff));
                    $self->{'menuFilter'.$field}->append($off);
                    $off->signal_connect('activate' => sub {
                        $self->changeFilter(shift, $field, 0);
                    });
                }
            }
            elsif ($fieldsInfo->{$field}->{type} eq 'options')
            {
                $self->{dynamicFilters}->{$field} = 1
                    if $field eq $self->{parent}->{model}->{commonFields}->{borrower}->{name};
                my $i = 0;
                foreach my $valueInfo(@{$model->getValues($fieldsInfo->{$field}->{'values'})})
                {
                    $self->{'menuFilter'.$field}->append(Gtk2::SeparatorMenuItem->new)
                        if (exists $fieldsInfo->{$field}->{separator})
                        && ($fieldsInfo->{$field}->{separator} == $i);
                    $i++;
                    next if $valueInfo->{displayed} eq '';
                    my $item = Gtk2::RadioMenuItem->new_with_mnemonic($self->{'group'.$field},
                                                                      $valueInfo->{displayed});
                    $self->{'menuFilter'.$field}->append($item);
                    $item->signal_connect('activate' => sub {
                        $self->changeFilter(shift, $field, $valueInfo->{value});
                    });
                }
            }
            elsif ($fieldsInfo->{$field}->{type} eq 'number')
            {
                my $item = Gtk2::RadioMenuItem->new_with_mnemonic($self->{'group'.$field},
                                                                  $model->getDisplayedText($filter->{labelselect}));
                $self->{'menuFilter'.$field}->append($item);
                $item->signal_connect('activate' => sub {
                    my $widget = shift;
                    return if ! $widget->get_active;
                    return if $self->{deactivated};
                    my $title = $model->getDisplayedText($filter->{labelselect});
                    $title =~ s/_//g;
                    $title =~ s/\.\.\.//g;
                    my $dialog = new GCNumberEntryDialog($self->{parent},
                                                         $title,
                                                         $fieldsInfo->{$field}->{min},
                                                         $fieldsInfo->{$field}->{max},
                                                         $fieldsInfo->{$field}->{step});
                    $dialog->setValue($self->{numberValues}->{$field})
                        if $self->{numberValues} != undef;
                    my $value = $dialog->getUserValue;
                    if ($value >= 0)
                    {
                        $self->changeFilter($widget, $field, $value);
                        $self->{numberValues}->{$field} = $value;
                    }
                });
            }
            elsif ($fieldsInfo->{$field}->{type} eq 'date')
            {
                my $item = Gtk2::RadioMenuItem->new_with_mnemonic($self->{'group'.$field},
                                                                  $model->getDisplayedText($filter->{labelselect}));
                $self->{'menuFilter'.$field}->append($item);
                $item->signal_connect('activate' => sub {
                    my $widget = shift;
                    return if ! $widget->get_active;
                    return if $self->{deactivated};
                    my $title = $model->getDisplayedText($filter->{labelselect});
                    $title =~ s/_//g;
                    $title =~ s/\.\.\.//g;
                    my $dialog = new GCDateSelectionDialog($self->{parent});

                    $dialog->date(GCPreProcess::restoreDate($self->{dateValues}->{$field}))
                        if $self->{dateValues} != undef;
                    if ($dialog->show)
                    {
                        my $value = GCPreProcess::reverseDate($dialog->date);
                        $self->changeFilter($widget, $field, $value);
                        $self->{dateValues}->{$field} = $value;
                    }
                });
            }
            
            my $label = $fieldsInfo->{$field}->{displayed};
            $label = $model->getDisplayedText($filter->{label}) if $filter->{label};            
            $self->{'item'.$field} = Gtk2::MenuItem->new_with_mnemonic($label);
            $self->{'item'.$field}->set_accel_path("<main>/Display/$field");
            $self->{'item'.$field}->set_submenu($self->{'menuFilter'.$field});
            $self->{menuDisplay}->insert($self->{'item'.$field}, $position);
            $self->{'item'.$field}->show_all;
            
            push @{$self->{existingFilters}}, $self->{'item'.$field};
            push @{$self->{existingFiltersMenu}}, $self->{'menuFilter'.$field};
            
            $position++;
        }
    }

    sub createUserFilters
    {
        my ($self, $model, $position) = @_;
        if (!defined $position)
        {
            # Here we need to find the correct position
            $position = 0;
            foreach ($self->{menuDisplay}->get_children)
            {
                $position++;
                last if $_->isa('Gtk2::SeparatorMenuItem');
            }
        }
        if ($self->{userFiltersMenu})
        {
            foreach ($self->{userFiltersMenu}->get_children)
            {
                $self->{userFiltersMenu}->remove($_);
                $_->destroy;
            }
            $self->{menuDisplay}->remove($self->{userFiltersItem});
            $self->{userFiltersMenu}->destroy;
            $self->{userFiltersItem}->destroy;
            $self->{userFiltersMenu} = 0;
        }
        return if !$model->getName;
        my @userFilters = @{$model->getUserFilters};
        $self->{userFiltersMenu} = new Gtk2::Menu;
        # Setting the accel group to be able to use also shortcuts on user filters
        $self->{userFiltersMenu}->set_accel_group($self->{accel});
        $self->{userFiltersItem} = Gtk2::MenuItem->new_with_mnemonic($self->{parent}->{lang}->{MenuSavedSearches});
        $self->{userFiltersItem}->set_accel_path('<main>/Display/SavedSearches');
        $self->{userFiltersItem}->set_submenu($self->{userFiltersMenu});
        $self->{menuDisplay}->insert($self->{userFiltersItem}, $position);
        if (@userFilters)
        {
            foreach my $userFilter(@userFilters)
            {
                my $filter = Gtk2::MenuItem->new($userFilter->{name});
                $filter->set_accel_path('<main>/Display/SavedSearches/'.$userFilter->{name});
                $filter->signal_connect('activate' => sub {
                    my ($widget, $filter) = @_;
                    $self->selectAll(1);
                    $self->{parent}->setSearchWithTypes(info => $filter->{info},
                                                        mode => $filter->{mode},
                                                        regexp => $filter->{regexp},
                                                        case => $filter->{case},
                                                        ignoreDiacritics => $filter->{ignoreDiacritics});
                }, $userFilter);
                $self->{userFiltersMenu}->append($filter);
            }
        }
        $self->{userFiltersMenu}->append(Gtk2::SeparatorMenuItem->new);
        my $newUserFilter = Gtk2::MenuItem->new($self->{parent}->{lang}->{MenuSavedSearchesSave});
        $newUserFilter->signal_connect('activate' => sub {
            $self->{parent}->saveCurrentSearch;
        });
        $self->{userFiltersMenu}->append($newUserFilter);
        my $editUserFilter = Gtk2::MenuItem->new($self->{parent}->{lang}->{MenuSavedSearchesEdit});
        $editUserFilter->signal_connect('activate' => sub {
            $self->{parent}->editSavedSearches;
        });
        $self->{userFiltersMenu}->append($editUserFilter);

        $self->{userFiltersItem}->show_all;
        $self->{menuDisplay}->show_all;
    }

    sub refreshFilters
    {
        my $self = shift;
        foreach (keys %{$self->{dynamicFilters}})
        {
            $self->checkFilter($_);
        }
    }
    
    sub checkFilter
    {
        my ($self, $field) = @_;
        return if ! exists $self->{dynamicFilters}->{$field};
        $self->{deactivated} = 1;
        my $values = $self->{parent}->{panel}->getValues($field);
        $values = $values->[0] if ref($values->[0]) eq 'ARRAY';
        my $current = $self->{'menuFilter'.$field}->get_active->child->get_label;
        my $first = 1;
        foreach ($self->{'menuFilter'.$field}->get_children)
        {
            if ($first)
            {
                $first = 0;
                $_->set_active(1);
            }
            else
            {
                $self->{'menuFilter'.$field}->remove($_);
            }
        }
        my $active = 0;
        my $i = 0;
        foreach (@$values)
        {
            next if !$_;
            my ($label, $value) = ($_, $_);
            if (ref($_) eq 'HASH')
            {
                $label = $_->{displayed};
                $value = $_->{value};
            }
            my $item = Gtk2::RadioMenuItem->new_with_mnemonic($self->{'group'.$field}, $label);
            $self->{'menuFilter'.$field}->append($item);
            $item->signal_connect('activate' => sub {
                $self->changeFilter(shift, $field, $value);
            });
            if ($label eq $current)
            {
                $item->set_active(1);
                $active = $i + 1;
            }
            $i++;
        }
        $self->{'menuFilter'.$field}->show_all;
        $self->{'menuFilter'.$field}->set_active($active);

        $self->{deactivated} = 0;
    }
    
    sub changeFilter
    {
        my ($self, $widget, $filter, $value) = @_;
        return if $self->{deactivated};
        return if ! $widget->get_active;
        $self->{parent}->setFilter($filter, $value);
    }
    
    sub setSaveActive
    {
        my ($self, $value) = @_;
        $self->{savedb}->set_sensitive($value);
    }
    
    sub setAddBookmarkActive
    {
        my ($self, $value) = @_;
        $self->{addBookmark}->set_sensitive($value);
    }
    
    sub setCollectionLock
    {
        my ($self, $value) = @_;
        $self->{menuEditLockItemsItem}->set_active(0);
    }
    
    sub new
    {
        my ($proto, $parent, $accelMapFile) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);

        $self->{parent} = $parent;
        $self->{accel} = Gtk2::AccelGroup->new();

        ############################
        # File Menu
        ############################

        $self->{menuFile} = Gtk2::Menu->new;
        $self->{menuFile}->set_accel_path('<main>/File');
        $self->{menuFile}->set_accel_group($self->{accel});

        if ($parent->{options}->tearoffMenus)
        {
            my $fto = Gtk2::TearoffMenuItem->new();
            $self->{menuFile}->append($fto);
        }

        my $newdb = Gtk2::ImageMenuItem->new_from_stock('gtk-new');
        $newdb->set_accel_path('<main>/File/gtk-new');
        $newdb->signal_connect ('activate' => sub {
            $self->{parent}->newList;
        });
        $self->{menuFile}->append($newdb);

        my $opendb = Gtk2::ImageMenuItem->new_from_stock('gtk-open');
        $opendb->set_accel_path('<main>/File/gtk-open');
        $opendb->signal_connect ('activate' => sub {
            $self->{parent}->openList;
        });
        $self->{menuFile}->append($opendb);

        $self->{menuFile}->append(Gtk2::SeparatorMenuItem->new);
        ############################

        $self->{savedb} = Gtk2::ImageMenuItem->new_from_stock('gtk-save');
        $self->{savedb}->set_accel_path('<main>/File/gtk-save');
        $self->{savedb}->signal_connect ('activate' => sub {
            $self->{parent}->saveList;
        });
        $self->{menuFile}->append($self->{savedb});

        my $saveasdb = Gtk2::ImageMenuItem->new_from_stock('gtk-save-as');
        $saveasdb->set_accel_path('<main>/File/gtk-save-as');
        $saveasdb->signal_connect ('activate' => sub {
            $self->{parent}->saveAs;
        });
        $self->{menuFile}->append($saveasdb);


        $self->{menuFile}->append(Gtk2::SeparatorMenuItem->new);
        ############################

        $self->{newitem} = Gtk2::ImageMenuItem->new_from_stock('gtk-add');
        $self->{newitem}->set_accel_path('<main>/File/gtk-add');
        $self->{newitem}->signal_connect ('activate' => sub { 
                   $self->{parent}->newItem;
        });
        $self->{menuFile}->append($self->{newitem});

        my $properties = Gtk2::ImageMenuItem->new_from_stock('gtk-properties');
        $properties->set_accel_path('<main>/File/gtk-properties');
        $properties->signal_connect ('activate' => sub {
            $self->{parent}->properties;
        });
        $self->{menuFile}->append($properties);

        if ($GCStats::statisticsActivated)
        {
            my $statistics = Gtk2::ImageMenuItem->new_with_mnemonic($parent->{lang}->{MenuStats});
            $statistics->set_accel_path('<main>/File/Stats');
            $statistics->signal_connect ('activate' => sub {
                $self->{parent}->stats;
            });
            $self->{menuFile}->append($statistics);
        }

        $self->{menuLend} = Gtk2::MenuItem->new_with_mnemonic($parent->{lang}->{MenuLend});
        $self->{menuLend}->set_accel_path('<main>/File/Borrowers');
        $self->{menuLend}->signal_connect ('activate' => sub {
             $self->{parent}->showBorrowed;
        });
        $self->{menuFile}->append($self->{menuLend});

        $self->{menuFile}->append(Gtk2::SeparatorMenuItem->new);
        ############################

        $self->{menuHistoryItem} = Gtk2::MenuItem->new_with_mnemonic($parent->{lang}->{MenuHistory});
        $self->{menuHistoryItem}->set_accel_path('<main>/File/History');
        $self->{menuHistory} = Gtk2::Menu->new();
        addHistoryMenu($self);
        $self->{menuFile}->append($self->{menuHistoryItem});

        $self->{menuFile}->append(Gtk2::SeparatorMenuItem->new);
        ############################
                
        my $importItem = Gtk2::ImageMenuItem->new_from_stock('gtk-convert');
        $importItem->set_accel_path('<main>/File/gtk-convert');
        $self->{menuImport} = Gtk2::Menu->new;
        $self->{menuImport}->set_accel_path('<main>/Import');
        $self->{menuImport}->set_accel_group($self->{accel});
        $self->{importers} = {};
        my $langName = $parent->{options}->lang;
        foreach my $importer(@GCImport::importersArray)
        {
            $importer->setLangName($langName);
            my $name = $importer->getName;
            my $item = Gtk2::MenuItem->new_with_mnemonic($name);
            $item->signal_connect ('activate' => sub {
                $self->{parent}->import($importer);
            });
            $self->{importers}->{$name} = $item;
        }
        foreach my $importerName(sort keys %{$self->{importers}})
        {
            $self->{menuImport}->append($self->{importers}->{$importerName});
        }        
        $importItem->set_submenu($self->{menuImport});
        $self->{menuFile}->append($importItem);        

        my $exportItem = Gtk2::ImageMenuItem->new_from_stock('gtk-revert-to-saved');
        $self->{menuExport} = Gtk2::Menu->new;
        $self->{menuExport}->set_accel_path('<main>/Export');
        $self->{menuExport}->set_accel_group($self->{accel});
        $self->{exporters} = {};
        foreach my $exporter(@GCExport::exportersArray)
        {
            $exporter->setLangName($langName);
            my $item = Gtk2::MenuItem->new_with_mnemonic($exporter->getName);
            $item->signal_connect ('activate' => sub {
                    $self->{parent}->export($exporter);
                });
            $self->{exporters}->{$exporter->getName} = $item;
        }
        foreach my $exportName(sort keys %{$self->{exporters}})
        {
            $self->{menuExport}->append($self->{exporters}->{$exportName});
        }
        $exportItem->set_submenu($self->{menuExport});
        $self->{menuFile}->append($exportItem);        

        $self->{menuFile}->append(Gtk2::SeparatorMenuItem->new);
        ############################

        my $leave = Gtk2::ImageMenuItem->new_from_stock('gtk-quit');
        $leave->set_accel_path('<main>/File/gtk-quit');
        $self->{menuFile}->append($leave);
        $leave->signal_connect('activate' ,sub {
            $self->{parent}->leave;
        });

        my $fileitem = Gtk2::MenuItem->new_with_mnemonic($parent->{lang}->{MenuFile});
        $fileitem->set_submenu($self->{menuFile});

        $self->append($fileitem);

        ############################
        # Edit Menu
        ############################
        $self->{menuEdit} = Gtk2::Menu->new;
        $self->{menuEdit}->set_accel_path('<main>/Edit');
        $self->{menuEdit}->set_accel_group($self->{accel});

        if ($parent->{options}->tearoffMenus)
        {
            my $eto = Gtk2::TearoffMenuItem->new();
            $self->{menuEdit}->append($eto);
        }

        $self->{duplicateItem} = Gtk2::ImageMenuItem->new_from_stock('gtk-dnd');
        $self->{duplicateItem}->set_accel_path('<main>/Edit/gtk-dnd');
        $self->{duplicateItem}->signal_connect('activate' , sub {
            $self->{parent}->duplicateItem;
        });
        $self->{menuEdit}->append($self->{duplicateItem});

        $self->{selectAllItem} = Gtk2::ImageMenuItem->new_from_stock('gtk-select-all');
        $self->{selectAllItem}->set_accel_path('<main>/Edit/gtk-select-all');
        $self->{selectAllItem}->signal_connect('activate' , sub {
            $self->{parent}->selectAll;
        });
        $self->{menuEdit}->append($self->{selectAllItem});

        $self->{deleteCurrentItem} = Gtk2::ImageMenuItem->new_from_stock('gtk-delete');
        $self->{deleteCurrentItem}->set_accel_path('<main>/Edit/gtk-delete');
        $self->{deleteCurrentItem}->signal_connect('activate' , sub {
            $self->{parent}->deleteCurrentItem;
        });
        $self->{menuEdit}->append($self->{deleteCurrentItem});

        $self->{menuEdit}->append(Gtk2::SeparatorMenuItem->new);
        ############################

        $self->{editFieldsItem} = Gtk2::MenuItem->new_with_mnemonic($parent->{lang}->{MenuEditFields});
        $self->{editFieldsItem}->set_accel_path('<main>/Edit/Collection');
        $self->{editFieldsItem}->signal_connect('activate' , sub {
            $self->{parent}->editModel;
        });
        $self->{menuEdit}->append($self->{editFieldsItem});

        $self->{menuEdit}->append(Gtk2::SeparatorMenuItem->new);
        ############################

        my $queryReplaceItem = Gtk2::ImageMenuItem->new_from_stock('gtk-find-and-replace');
        $queryReplaceItem->set_accel_path('<main>/Edit/gtk-find-and-replace');
        $queryReplaceItem->signal_connect('activate' , sub {
            $self->{parent}->queryReplace;
        });
        $self->{menuEdit}->append($queryReplaceItem);

        $self->{menuEdit}->append(Gtk2::SeparatorMenuItem->new);
        ############################

        my $lockItemsItem = Gtk2::CheckMenuItem->new_with_mnemonic($parent->{lang}->{MenuEditLockItems});
        $lockItemsItem->set_accel_path('<main>/Edit/Lock');
        $self->{menuEdit}->append($lockItemsItem);
         #$lockItemsItem->set_active($parent->{items}->getLock);
        $lockItemsItem->signal_connect('activate' , sub {
                        my $parent = $self;
                        my $self = shift;
                        return if $parent->{deactivated};
                        $parent->{parent}->setLock($self->get_active);
                        $self->toggled();
        },$lockItemsItem);
        $self->{menuEditLockItemsItem}=$lockItemsItem;
        $lockItemsItem->{parent}=$self->{menuEdit};

        my $editItem = Gtk2::MenuItem->new_with_mnemonic($parent->{lang}->{MenuEdit});
        $editItem->set_submenu($self->{menuEdit});
        $self->append($editItem);

        ############################
        # Display Menu
        ############################
        $self->{menuDisplay} = Gtk2::Menu->new;
        $self->{menuDisplay}->set_accel_path('<main>/Display');
        $self->{menuDisplay}->set_accel_group($self->{accel});

        if ($parent->{options}->tearoffMenus)
        {
            my $dto = Gtk2::TearoffMenuItem->new;
            $self->{menuDisplay}->append($dto);
        }
        ############################
        
        $self->{menuDisplay}->append(Gtk2::SeparatorMenuItem->new);

        my $search = Gtk2::ImageMenuItem->new_from_stock('gtk-find');
        $search->set_accel_path('<main>/Display/gtk-find');
        $search->signal_connect('activate' , sub {
                $self->{parent}->search('all');
        }); 
        $self->{menuDisplay}->append($search);

        my $advancedSearch = Gtk2::ImageMenuItem->new_with_mnemonic($parent->{lang}->{MenuAdvancedSearch});
        $advancedSearch->set_accel_path('<main>/Display/Advanced');
        my $advancedImage = Gtk2::Image->new_from_stock('gtk-find', 'menu');
        $advancedSearch->set_image($advancedImage);
        $advancedSearch->signal_connect('activate' , sub {
                $self->{parent}->advancedSearch;
        }); 
        $self->{menuDisplay}->append($advancedSearch);

        my $random = Gtk2::ImageMenuItem->new_from_stock('gtk-execute');
        $random->set_accel_path('<main>/Display/gtk-execute');
        $random->signal_connect('activate' , sub {
                $self->{parent}->randomItem;
        }); 
        $self->{menuDisplay}->append($random);

        $self->{menuDisplay}->append(new Gtk2::SeparatorMenuItem);
        ############################

        $self->{'viewAllItems'} = Gtk2::ImageMenuItem->new_with_mnemonic($parent->{lang}->{MenuViewAllItems});
        $self->{'viewAllItems'}->set_accel_path('<main>/Display/All');
        my $refreshImage = Gtk2::Image->new_from_stock('gtk-refresh', 'menu');
        $self->{'viewAllItems'}->set_image($refreshImage);
        $self->{'viewAllItems'}->signal_connect('activate' , sub {
                $self->selectAll
        });
        $self->{menuDisplay}->append($self->{'viewAllItems'});

        $self->{displayItem} = Gtk2::MenuItem->new_with_mnemonic($parent->{lang}->{MenuDisplay});
        $self->{displayItem}->set_submenu($self->{menuDisplay});

        $self->append($self->{displayItem});

        ############################
        # Configuration Menu
        ############################
        $self->{menuConfig} = Gtk2::Menu->new;
        $self->{menuConfig}->set_accel_path('<main>/Config');
        $self->{menuConfig}->set_accel_group($self->{accel});

        if ($parent->{options}->tearoffMenus)
        {
            my $cto = Gtk2::TearoffMenuItem->new;
            $self->{menuConfig}->append($cto);
        }

        my $options = Gtk2::ImageMenuItem->new_from_stock('gtk-preferences');
        $options->set_accel_path('<main>/Config/gtk-preferences');
        $options->signal_connect('activate' , sub {
            my ($widget, $window) = @_;
            $window->options;
        }, $self->{parent});
        $self->{menuConfig}->append($options);

        $self->{displayItem} = Gtk2::MenuItem->new_with_mnemonic($parent->{lang}->{MenuDisplayMenu});
        $self->{displayItem}->set_accel_path('<main>/Config/DisplayItem');
        #$self->{displayItem}->set_submenu($self->createDisplayMenu);
        $self->attachDisplayMenu;
        $self->{menuConfig}->append($self->{displayItem});

        my $toolbarConfig = Gtk2::MenuItem->new_with_mnemonic($parent->{lang}->{MenuToolbarConfiguration});
        $toolbarConfig->set_accel_path('<main>/Config/Toolbar');
        $toolbarConfig->signal_connect ('activate' => sub {
            $self->{parent}->toolbarOptions;
        });
        $self->{menuConfig}->append($toolbarConfig);

        $self->{menuConfig}->append(new Gtk2::SeparatorMenuItem);

        my $displayOptions = Gtk2::MenuItem->new_with_mnemonic($parent->{lang}->{MenuDisplayOptions});
        $displayOptions->set_accel_path('<main>/Config/Display');
        $displayOptions->signal_connect ('activate' => sub {
            $self->{parent}->displayOptions;
        });
        $self->{menuConfig}->append($displayOptions);

        $self->{defaultValues} = Gtk2::MenuItem->new_with_mnemonic($parent->{lang}->{MenuDefaultValues});
        $self->{defaultValues}->set_accel_path('<main>/Config/DefaultValues');
        $self->{defaultValues}->signal_connect ('activate' => sub {
            $self->{parent}->setDefaultValues;
        });
        $self->{menuConfig}->append($self->{defaultValues});

        my $borrowers = Gtk2::MenuItem->new_with_mnemonic($parent->{lang}->{MenuBorrowers});
        $borrowers->set_accel_path('<main>/Config/Borrowers');
        $borrowers->signal_connect ('activate' => sub {
            $self->{parent}->borrowers;
        });
        $self->{menuConfig}->append($borrowers);

        my $configitem = Gtk2::MenuItem->new_with_mnemonic($parent->{lang}->{MenuConfiguration});
        $configitem->set_submenu($self->{menuConfig});
        $self->append($configitem);

        ############################
        # Bookmarks Menu
        ############################
        $self->{menuBookmarks} = Gtk2::Menu->new;
        $self->{menuBookmarks}->set_accel_path('<main>/Bookmarks');
        $self->{menuBookmarks}->set_accel_group($self->{accel});

        if ($parent->{options}->tearoffMenus)
        {
            my $bto = Gtk2::TearoffMenuItem->new;
            $self->{menuBookmarks}->append($bto);
        }

        $self->{addBookmark} = Gtk2::ImageMenuItem->new_with_mnemonic($parent->{lang}->{MenuBookmarksAdd});
        my $addBookmarkImage = Gtk2::Image->new_from_stock('gtk-add', 'menu');
        $self->{addBookmark}->set_image($addBookmarkImage);
        $self->{addBookmark}->set_accel_path('<main>/Bookmarks/Add');
        $self->{addBookmark}->signal_connect('activate' , sub {
            $self->{parent}->addBookmark;
        });
        $self->{menuBookmarks}->append($self->{addBookmark});

        my $editBookmark = Gtk2::MenuItem->new_with_mnemonic($parent->{lang}->{MenuBookmarksEdit});
        $editBookmark->set_accel_path('<main>/Bookmarks/Edit');
        $editBookmark->signal_connect('activate' , sub {
            $self->{parent}->editBookmark;
        });
        $self->{menuBookmarks}->append($editBookmark);

        $self->{menuBookmarks}->append(new Gtk2::SeparatorMenuItem);

        my $bookmarksitem = Gtk2::MenuItem->new_with_mnemonic($parent->{lang}->{MenuBookmarks});
        $bookmarksitem->set_submenu($self->{menuBookmarks});
        $self->append($bookmarksitem);

        ############################
        # Help Menu
        ############################
        $self->{menuHelp} = Gtk2::Menu->new;
        $self->{menuHelp}->set_accel_path('<main>/Help');
        $self->{menuHelp}->set_accel_group($self->{accel});

        if ($parent->{options}->tearoffMenus)
        {
            my $hto = Gtk2::TearoffMenuItem->new;
            $self->{menuHelp}->append($hto);
        }

        my $help = Gtk2::ImageMenuItem->new_from_stock('gtk-help');
        $help->set_accel_path('<main>/Help/Content');
        $help->signal_connect('activate' , sub {
            my ($widget, $window) = @_;
            $window->help;
        }, $self->{parent});
        $self->{menuHelp}->append($help);
        my $plugins = Gtk2::MenuItem->new_with_mnemonic($parent->{lang}->{MenuAllPlugins});
        $plugins->set_accel_path('<main>/Help/Plugins');
        $plugins->signal_connect ('activate' => sub {
            $self->{parent}->showAllPlugins;
        });
        $self->{menuHelp}->append($plugins);
        my $depend = Gtk2::MenuItem->new_with_mnemonic($parent->{lang}->{InstallDependencies});
        $depend->set_accel_path('<main>/Help/Dependencies');
        $depend->signal_connect ('activate' => sub {
            $self->{parent}->showDependencies;
        });
        $self->{menuHelp}->append($depend);
        my $bug = Gtk2::ImageMenuItem->new_with_mnemonic($parent->{lang}->{MenuBugReport});
        $bug->set_accel_path('<main>/Help/Bug');
        $bug->signal_connect('activate' , sub {
            my ($widget, $window) = @_;
            $window->reportBug;
        }, $self->{parent});
        $self->{menuHelp}->append($bug);
        my $about = Gtk2::ImageMenuItem->new_from_stock('gtk-about');
        $about->set_accel_path('<main>/Help/gtk-about');
        $about->signal_connect('activate' , sub {
            my ($widget, $window) = @_;
            $window->about;
        }, $self->{parent});
        $self->{menuHelp}->append($about);

        my $helpitem = Gtk2::MenuItem->new_with_mnemonic($parent->{lang}->{MenuHelp});
        $helpitem->set_submenu($self->{menuHelp});
        $self->append($helpitem);

        $parent->add_accel_group($self->{accel});

        $self->{deactivateFilters} = 0;
        $self->{contextUpdating} = 0;

        $self->setSaveActive(0);

        $self->{AccelMapFile} = $accelMapFile;
        if (-f $accelMapFile)
        {
            Gtk2::AccelMap->load($accelMapFile);
        }
        else
        {
            $self->restoreDefaultAccels;
        }
        $self->get_settings->set(gtk_can_change_accels => 1);

        return $self;
        
    }

    sub save
    {
        my $self = shift;
        Gtk2::AccelMap->save($self->{AccelMapFile});
    }

    sub restoreDefaultAccels
    {
        my $self = shift;

        Gtk2::AccelMap->foreach(undef, sub {
            my ($path, $key, $modifier, $changed) = @_;
            if ($path =~ m|(gtk-.*?)$|)
            {
                my $stockItem = Gtk2::Stock->lookup($1);
                Gtk2::AccelMap->change_entry($path,
                                             $stockItem->{keyval},
                                             $stockItem->{modifier},
                                             1);
            }
            else
            {
                Gtk2::AccelMap->change_entry($path,
                                             undef,
                                             [],
                                             1);
            }
        });

        Gtk2::AccelMap->change_entry('<main>/Bookmarks/Add',
                                     ord('d'),
                                     'control-mask',
                                     1);
        

        return $self;
    }

    sub setLock
    {
        my ($self, $value) = @_;
        $self->block;
        $self->{menuEditLockItemsItem}->set_active($value);
        $self->unblock;
    }

    sub selectAll
    {
        my ($self, $noRefresh) = @_;
        
        $self->block;
        $self->{parent}->removeSearch($noRefresh);

        foreach (@{$self->{existingFiltersMenu}})
        {
            $_->set_active(0);
            $_->get_active->set_active(1);
        }
        $self->unblock;
    }
    
    sub block
    {
        my $self = shift;

        $self->{parent}->blockListUpdates(1);
        $self->{deactivated} = 1;
    }
    
    sub unblock
    {
        my $self = shift;

        $self->{deactivated} = 0;
        $self->{parent}->blockListUpdates(0);
    }
    
    sub attachDisplayMenu
    {
        my ($self, $newParent) = @_;

        $newParent = $self->{displayItem}
            if !$newParent;

        my $displayMenu;
        if ($self->{displayMenu})
        {
            $displayMenu = $self->{displayMenu};
            $displayMenu->detach;
        }
        else
        {
            $displayMenu = Gtk2::Menu->new;
            $displayMenu->set_accel_path('<main>/Config/DisplayMenu');
            $displayMenu->set_accel_group($self->{accel});
    
            my $fullScreen = Gtk2::CheckMenuItem->new_with_mnemonic($self->{parent}->{lang}->{MenuDisplayFullScreen});
            $fullScreen->set_accel_path('<main>/Config/DisplayMenu/Fullscreen');
            $fullScreen->signal_connect ('activate' => sub {
                            my $parent = $self;
                            my $self = shift;
                            $parent->{parent}->setFullScreen($self->get_active);
                            $self->toggled();
            }, $fullScreen);
            $displayMenu->append($fullScreen);
            
            $displayMenu->append(new Gtk2::SeparatorMenuItem);
    
            my $menuBar = Gtk2::CheckMenuItem->new_with_mnemonic($self->{parent}->{lang}->{MenuDisplayMenuBar});
            $menuBar->set_accel_path('<main>/Config/DisplayMenu/MenuBar');
            $menuBar->set_active($self->{parent}->{options}->displayMenuBar);
            $menuBar->signal_connect ('activate' => sub {
                            my $parent = $self;
                            my $self = shift;
                            $parent->{parent}->setDisplayMenuBar($self->get_active);
                            $self->toggled();
            }, $menuBar);
            $displayMenu->append($menuBar);
            
            $self->{displayToolBar} = Gtk2::CheckMenuItem->new_with_mnemonic($self->{parent}->{lang}->{MenuDisplayToolBar});
            $self->{displayToolBar}->set_accel_path('<main>/Config/DisplayMenu/ToolBar');
            $self->{displayToolBar}->set_active($self->{parent}->{options}->toolbar);
            $self->{displayToolBar}->signal_connect ('activate' => sub {
                            my $parent = $self;
                            my $self = shift;
                            return if !$self->{acceptEvents};
                            my $value = $self->get_active;
                            # If activated, we set it to the system setting
                            $value = 3
                                if $value;
                            $parent->{parent}->setDisplayToolBar($value);
                            $self->toggled();
            }, $self->{displayToolBar});
            $self->{displayToolBar}->{acceptEvents} = 1;
            $displayMenu->append($self->{displayToolBar});

            my $statusBar = Gtk2::CheckMenuItem->new_with_mnemonic($self->{parent}->{lang}->{MenuDisplayStatusBar});
            $statusBar->set_accel_path('<main>/Config/DisplayMenu/StatusBar');
            $statusBar->set_active($self->{parent}->{options}->status);
            $statusBar->signal_connect ('activate' => sub {
                            my $parent = $self;
                            my $self = shift;
                            $parent->{parent}->setDisplayStatusBar($self->get_active);
                            $self->toggled();
            }, $statusBar);
            $displayMenu->append($statusBar);

            $self->{displayMenu} = $displayMenu;
        }

        $newParent->set_submenu($displayMenu);
        $newParent->show_all;
        #return $self->{displayMenu};
    }
    
    sub setDisplayToolbarState
    {
        my ($self, $value) = @_;
        #$self->{displayToolBar}->{acceptEvents} = 0;
        $self->{displayToolBar}->set_active($value);
        $self->{displayToolBar}->{acceptEvents} = 1;
    }
}

{
    package GCToolBar;
    use base 'Gtk2::Toolbar';

    our $CONFIGURATION_FILE = 'Toolbar';
    our @DEFAULT_CONTROLS = (
            'gtk-add', 'gtk-save', 'gtk-preferences',
            'ToolbarSeparator',
            'gtk-find', 'gtk-refresh', 'gtk-execute', 'gtk-media-play',
            'ToolbarSeparator',
            'ToolbarGroupBy'        
    );

    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();

        bless($self, $class);

        $self->{parent} = $parent;
        $self->{lang} = $parent->{lang};
        
        $self->set_name('GCToolbar');
        $self->set_show_arrow (1);

        $self->{configFile} = $ENV{GCS_CONFIG_HOME}.'/'.$GCToolBar::CONFIGURATION_FILE;
        
        $self->{stockIdToWidget} = {
            'gtk-add' => {
                           tooltip => $self->{lang}->{NewItemTooltip},
                           callback => sub {$parent->newItem}
            },
            'gtk-save' => {
                           tooltip => $self->{lang}->{SaveListTooltip},
                           callback => sub {$parent->saveList}
            },
            'gtk-preferences' => {
                           tooltip => $self->{lang}->{PreferencesTooltip},
                           callback => sub {$parent->options}
            },
            'gtk-find' => {
                           tooltip => $self->{lang}->{SearchTooltip},
                           callback => sub {$parent->search('all')}
            },
            'gtk-refresh' => {
                           tooltip => $self->{lang}->{ToolbarAllTooltip},
                           callback => sub {$parent->viewAllItems}
            },
            'gtk-execute' => {
                           tooltip => $self->{lang}->{RandomTooltip},
                           callback => sub {$parent->randomItem}
            },
            'gtk-media-play' => {
                           tooltip => $self->{lang}->{PlayTooltip},
                           callback => sub {$parent->playItem}
            },
            'gtk-new' => {
                           tooltip => undef,
                           callback => sub {$parent->newList}
            },
            'gtk-open' => {
                           tooltip => undef,
                           callback => sub {$parent->openList}
            },
            'gtk-properties' => {
                           tooltip => undef,
                           callback => sub {$parent->properties}
            },
            'gtk-quit' => {
                           tooltip => undef,
                           callback => sub {$parent->leave}
            },
            'gtk-dnd' => {
                           tooltip => undef,
                           callback => sub {$parent->duplicateItem}
            },
            'gtk-delete' => {
                           tooltip => undef,
                           callback => sub {$parent->deleteCurrentItem}
            },
            'gtk-find-and-replace' => {
                           tooltip => undef,
                           callback => sub {$parent->queryReplace}
            },
            'gtk-help' => {
                           tooltip => undef,
                           callback => sub {$parent->help}
            },
        };
        
        $self->loadControls;

        $self->{blocked} = 1;
        $self->setSaveActive(0);
        $self->{showFieldsSelection} = 1;

        return $self;
    }

    sub loadControls
    {
        my $self = shift;
        my @controls;
        if (! -f $self->{configFile})
        {
            @controls = @GCToolBar::DEFAULT_CONTROLS;
        }
        else
        {
            open CONFIG, $self->{configFile};
            my @array;
            foreach (<CONFIG>)
            {
                s/\s+$//;
                push @controls, $_;
            }
            close CONFIG;
        }
        foreach (@controls)
        {
            if (/^gtk-/)
            {
                $self->{controls}->{$_} = Gtk2::ToolButton->new_from_stock($_);
                
                # Set the important property on the add and save buttons
                # (shows text in toolbar, depending on gtk settings)
                if (/add|save/)
                {
                    $self->{controls}->{$_}->set_is_important(1);
                }

                $self->{controls}->{$_}->signal_connect('clicked' => $self->{stockIdToWidget}->{$_}->{callback});
                $self->{parent}->{tooltips}->set_tip($self->{controls}->{$_}, $self->{stockIdToWidget}->{$_}->{tooltip}, '')
                    if $self->{stockIdToWidget}->{$_}->{tooltip};
                $self->insert($self->{controls}->{$_}, -1);

            }
            elsif ($_ eq 'ToolbarSeparator')
            {
                $self->insert(Gtk2::SeparatorToolItem->new, -1);
            }
            else
            {
                if ($_ eq 'ToolbarGroupBy')
                {
                    $self->{controls}->{groupLabel} = new Gtk2::Label($self->{lang}->{ToolbarGroupBy});
                    $self->{controls}->{groupOption} = new GCFieldSelector(0, undef, 1);
                    $self->{controls}->{groupOption}->set_focus_on_click(0);
                    $self->{controls}->{groupOption}->signal_connect('changed' => sub {
                        return if $self->{blocked};
                        my $field = $self->{controls}->{groupOption}->getValue;
                        return if $self->{currentGroupField} eq $field;
                        $self->{parent}->setGrouping($field);
                    });
                    my $groupVBox = new Gtk2::VBox(0,0);
                    $groupVBox->set_border_width(0);
                    $groupVBox->pack_start($self->{controls}->{groupOption}, 1, 0, 0);
                    $self->{parent}->{tooltips}->set_tip($self->{controls}->{groupOption}, $self->{lang}->{ToolbarGroupByTooltip}, '');
                    my $groupBox = new Gtk2::HBox(0,0);
                    $groupBox->pack_start($self->{controls}->{groupLabel}, 0, 0, 0);
                    $groupBox->pack_start($groupVBox, 1, 1, $GCUtils::halfMargin);
                    my $groupItem = new Gtk2::ToolItem;
                    $groupItem->add($groupBox);
                    $self->insert($groupItem, -1);
                }
                elsif ($_ eq 'OptionsView')
                {                    
                    my %views = %{$self->{lang}->{OptionsViews}};
                    $self->{controls}->{viewOption} = new GCMenuList;
                    my @viewsOptions = map {{value => $_, displayed => $views{$_}}}
                                           (sort keys %views);
                    $self->{controls}->{viewOption}->setValues(\@viewsOptions);
                    $self->{controls}->{viewOption}->signal_connect('changed' => sub {
                        return if $self->{blocked};
                        $self->{parent}->{options}->view($self->{controls}->{viewOption}->getValue);
                        $self->{parent}->setItemsList(0, 1);
                    });
                    my $listViewBox = new Gtk2::VBox(0,0);
                    $listViewBox->set_border_width(0);
                    $listViewBox->pack_start($self->{controls}->{viewOption}, 1, 0, 0);
                    my $viewItem = new Gtk2::ToolItem;
                    $viewItem->add($listViewBox);
                    $self->insert($viewItem, -1);
                }
                elsif ($_ eq 'OptionsLayout')
                {                    
                    $self->{controls}->{layoutOption} = new GCMenuList;
                    $self->{controls}->{layoutOption}->signal_connect('changed' => sub {
                        return if $self->{blocked};
                        $self->{model}->{preferences}->layout($self->{controls}->{layoutOption}->getValue);
                        $self->{parent}->changePanel(0, 0);
                    });
                    my $layoutBox = new Gtk2::VBox(0,0);
                    $layoutBox->set_border_width(0);
                    $layoutBox->pack_start($self->{controls}->{layoutOption}, 1, 0, 0);
                    my $layoutItem = new Gtk2::ToolItem;
                    $layoutItem->add($layoutBox);
                    $self->insert($layoutItem, -1);
                }
                elsif ($_ eq 'MenuSavedSearches')
                {                    
                    $self->{controls}->{userFiltersOption} = new GCMenuList;
                    $self->{controls}->{userFiltersOption}->setTitle($self->{parent}->{lang}->{MenuSavedSearches});
                    $self->{controls}->{userFiltersOption}->signal_connect('changed' => sub {
                        return if $self->{blocked};
                        my $idx = $self->{controls}->{userFiltersOption}->getValue;
                        $self->{controls}->{userFiltersOption}->{changeInProgress} = 1;
                        if ($idx == -1)
                        {
                            $self->{parent}->removeSearch(0);
                        }
                        else
                        {
                            $self->{parent}->removeSearch(1);
                            $self->{parent}->setSearchWithTypes(%{$self->{userFilters}->[$idx]});
                        }
                        $self->{controls}->{userFiltersOption}->{changeInProgress} = 0;
                    });
                    
                    my $filterBox = new Gtk2::VBox(0,0);
                    $filterBox->set_border_width(0);
                    $filterBox->pack_start($self->{controls}->{userFiltersOption}, 1, 0, 0);
                    my $filterItem = new Gtk2::ToolItem;
                    $filterItem->add($filterBox);
                    $self->insert($filterItem, -1);
                }
                elsif ($_ eq 'ToolbarQuickSearch')
                {
                    my $quickBox = new Gtk2::HBox(0,0);
                    $self->{controls}->{quickLabel} = new Gtk2::Label($self->{lang}->{ToolbarQuickSearchLabel});
                    $quickBox->pack_start($self->{controls}->{quickLabel}, 0, 0, 0);

                    $self->{controls}->{quickEntry} = new GCShortText;
                    $self->{controls}->{quickEntry}->signal_connect('activate' => sub {
                        $self->{parent}->setQuickSearch($self->{controls}->{quickFields}->getValue,
                                                        $self->{controls}->{quickEntry}->getValue);
                        $self->{controls}->{quickEntry}->grab_focus;
                    });

                    $self->{controls}->{quickFields} = new GCFieldSelector(0, undef, 0, 1, 1);
                    $self->{controls}->{quickFields}->set_focus_on_click(0);

                    # Without 2 handlers below, the focus goes out of the toolbar when
                    # pressing Tab or Shift-Tab
                    $self->{controls}->{quickEntry}->signal_connect('key-press-event' => sub {
                        my ($widget, $event) = @_;
                        my $key = Gtk2::Gdk->keyval_name($event->keyval);
                        if ($key eq 'Tab')
                        {
                            $self->{controls}->{quickFields}->grab_focus;
                            return 1;
                        }
                        # Let key be managed by Gtk2
                        return 0;
                    });
                    $self->{controls}->{quickFields}->signal_connect('key-press-event' => sub {
                        my ($widget, $event) = @_;
                        my $key = Gtk2::Gdk->keyval_name($event->keyval);
                        my $state = $event->get_state;
                        if (($key =~ /Tab$/) && ($state =~ /shift-mask/))
                        {
                            $self->{controls}->{quickEntry}->grab_focus;
                            return 1;
                        }
                        # Let key be managed by Gtk2
                        return 0;
                    });
                    $quickBox->pack_start($self->{controls}->{quickEntry}, 0, 0, $GCUtils::halfMargin);
                    my $quickFieldsBox = new Gtk2::VBox(0,0);
                    $quickFieldsBox->set_border_width(0);
                    $quickFieldsBox->pack_start($self->{controls}->{quickFields}, 1, 0, 0);
                    $quickBox->pack_start($quickFieldsBox, 0, 0, 0);
                    $self->{parent}->{tooltips}->set_tip($self->{controls}->{quickEntry}, $self->{lang}->{ToolbarQuickSearchTooltip}, '');
                    $self->{parent}->{tooltips}->set_tip($self->{controls}->{quickFields}, $self->{lang}->{ToolbarQuickSearchTooltip}, '');
                    my $quickItem = new Gtk2::ToolItem;
                    $quickItem->add($quickBox);
                    $self->insert($quickItem, -1);
                }
            }
        }
        my $separator = Gtk2::SeparatorToolItem->new;
        $separator->set_expand(1);
        $separator->set_draw(0);

        my $logoPixbuf = Gtk2::Gdk::Pixbuf->new_from_file($self->{parent}->{logosDir}.'/button.png');
        my ($width, $height) = Gtk2::IconSize->lookup($self->get_icon_size);
        $logoPixbuf = GCUtils::scaleMaxPixbuf($logoPixbuf, $width, $height);
        
        my $logo = Gtk2::Image->new_from_pixbuf($logoPixbuf);
        my $logoButton = new Gtk2::Button;
        $logoButton->add($logo);
        my $logoItem = new Gtk2::ToolItem;
        $logoItem->add($logoButton);
        $logoButton->set_relief('none');
        $self->{parent}->{tooltips}->set_tip($logoButton,
                                             $self->{lang}->{AboutTitle});
        $logoButton->signal_connect('clicked' , sub {
            $self->{parent}->about;
        });

        $self->insert($separator, -1);
        $self->insert($logoItem, -1);
    }

    sub createUserFilters
    {
        my ($self, $model) = @_;
        $self->{blocked} = 1;
        if ($self->{controls}->{userFiltersOption})
        {
            $self->{userFilters} = $model->getUserFilters;
            my $i = 0;
            my @filters = map {{value => $i++,
                               displayed => $model->getDisplayedText($_->{name})}}
                             @{$self->{userFilters}};
            $self->{controls}->{userFiltersOption}->setValues(\@filters);
        }
        $self->{blocked} = 0;
    }

    sub setShowFieldsSelection
    {
        my ($self, $value) = @_;
        return;
        return if ! $self->{controls}->{groupOption};
        if ($value)
        {
            $self->{controls}->{groupLabel}->show;
            $self->{groupBox}->show;
        }
        else
        {
            $self->{controls}->{groupLabel}->hide;
            $self->{groupBox}->hide;
        }
    }

    sub setSaveActive
    {
        my ($self, $value) = @_;
        $self->{controls}->{'gtk-save'}->set_sensitive($value)
            if $self->{controls}->{'gtk-save'};
    }
    
    sub setAddActive
    {
        my ($self, $value) = @_;
        $self->{controls}->{'gtk-add'}->set_sensitive($value)
            if $self->{controls}->{'gtk-add'};
    }
    
    sub setModel
    {
        my ($self, $model) = @_;
        $self->{blocked} = 1;
        $self->{model} = $model;
        $self->{controls}->{groupOption}->setModel($model)
            if $self->{controls}->{groupOption};
        $self->setGroupField($model->{preferences}->groupBy, 1);
        
        if ($self->{controls}->{quickFields})
        {
            $self->{controls}->{quickFields}->signal_handler_disconnect(
                $self->{quickFieldsHandler}
            ) if $self->{quickFieldsHandler};
            $self->{controls}->{quickFields}->setModel($model);
            $self->{controls}->{quickFields}->setValue($model->{preferences}->quickSearchField);
            $self->{quickFieldsHandler} = $self->{controls}->{quickFields}->signal_connect(
            'changed' => sub {
               my $value = $self->{controls}->{quickFields}->getValue;
               $self->{model}->{preferences}->quickSearchField($value)
                    if $value;
            });
        }

        if ($self->{controls}->{layoutOption})
        {
            my @panels = map {{value => $_,
                               displayed => $model->getDisplayedText($model->{panels}->{$_}->{label})}}
                             @{$model->{panelsNames}};
            $self->{controls}->{layoutOption}->setValues(\@panels);
        }

        $self->createUserFilters($model);

        # Update tooltip text
        $self->{parent}->{tooltips}->set_tip($self->{controls}->{'gtk-add'},
                                             $self->{lang}->{NewItemTooltip})
	    if $self->{controls}->{'gtk-add'};
        $self->{parent}->{tooltips}->set_tip($self->{controls}->{'gtk-find'},
                                             $self->{lang}->{SearchTooltip})
	    if $self->{controls}->{'gtk-find'};
        $self->{parent}->{tooltips}->set_tip($self->{controls}->{'gtk-refresh'},
                                             $self->{lang}->{ToolbarAllTooltip})
	    if $self->{controls}->{'gtk-refresh'};
        
        # Update add button text
        if ($self->{controls}->{'gtk-add'})
        {
            my $addText = $self->{lang}->{MenuAddItem};
            $addText =~ s/\_//g;
            my $widget = $self->{controls}->{'gtk-add'}->get_children;
            while ($widget)
            {
                if ($widget->isa(Gtk2::Label::))
                {
                    $widget->set_text($addText);
                    last;
                }
                elsif ($widget->isa(Gtk2::Image::))
                {
                    last;
                }
                $widget = $widget->get_children;
            }
        }
        
        # Hide tonight button if needed
        if ($self->{controls}->{'gtk-execute'})
        {
            $self->{controls}->{'gtk-execute'}->show;
            $self->{controls}->{'gtk-execute'}->hide if !$model->hasRandom;
        }
        
        # Hide play button if needed
        if ($self->{controls}->{'gtk-media-play'})
        {
            $self->{controls}->{'gtk-media-play'}->show;
            # Update button tooltip
            $self->{parent}->{tooltips}->set_tip($self->{controls}->{'gtk-media-play'},
                                                 $self->{lang}->{PlayTooltip});
            $self->{controls}->{'gtk-media-play'}->hide if !$model->hasPlay;
        }

        $self->{blocked} = 0;
    }
    
    sub setGroupField
    {
        my ($self, $field, $force) = @_;
        my $i = 0;
        return if (defined $self->{currentGroupField}) && ($self->{currentGroupField} eq $field) && !$force;
        $self->{currentGroupField} = $field;
        $self->{controls}->{groupOption}->setValue($field)
            if $self->{controls}->{groupOption};
    }
    
    sub setItemsList
    {
        my ($self, $view) = @_;
        return if ! $self->{controls}->{viewOption};
        $self->{controls}->{viewOption}->setValue($view);
    }
    
    sub setLayout
    {
        my ($self, $layout) = @_;
        return if ! $self->{controls}->{layoutOption};
        $self->{controls}->{layoutOption}->setValue($layout);
    }
    
    sub setSize
    {
        my ($self, $size) = @_;
        
        if ($size == 3)
        {
            $self->unset_icon_size;
        }
        else
        {
            $self->set_icon_size($size == 1 ? 'small-toolbar' : 'large-toolbar');
        }
    }

    sub removeSearch
    {
        my $self = shift;
        $self->{blocked} = 1;
        $self->{controls}->{quickEntry}->setValue('')
            if $self->{controls}->{quickEntry};
        if ($self->{controls}->{userFiltersOption})
        {
            $self->{controls}->{userFiltersOption}->clear
                if !$self->{controls}->{userFiltersOption}->{changeInProgress};
        }
        $self->{blocked} = 0;
    }

}


{
    package GCToolbarOptionsDialog;
    use base 'GCDoubleListDialog';

    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent, 'Toolbar configuration', 1,
            $parent->{lang}->{ImportExportFieldsUnused}, $parent->{lang}->{ImportExportFieldsUsed});

        bless($self, $class);

        $self->{separatorString} = $self->{parent}->{lang}->{ToolbarSeparator};

        my $defaultButton = new GCButton->newFromStock('gtk-undo', 0, $parent->{lang}->{PanelRestoreDefault});
        $defaultButton->set_border_width($GCUtils::margin);
        $defaultButton->signal_connect('clicked' => sub {
            $self->preFill;
        });
        my $clearButton = new GCButton->newFromStock('gtk-clear');
        $clearButton->set_border_width($GCUtils::margin);
        $clearButton->signal_connect('clicked' => sub {
            $self->clearList;
        });            
        
        $self->getDoubleList->addToPermanent($self->{separatorString});
        $self->getDoubleList->setDataHandler($self);
        $self->getDoubleList->addBottomButtons($defaultButton,$clearButton);

        $self->{configFile} = $ENV{GCS_CONFIG_HOME}.'/'.$GCToolBar::CONFIGURATION_FILE;
        $self->{conversionMap} = {};

        my @separatorXpm = (
            '16 16 3 1',
            ' 	c None', '-	c grey', '+	c black',
            '       +-       ', '       +-       ', '       +-       ', '       +-       ',
            '       +-       ', '       +-       ', '       +-       ', '       +-       ',
            '       +-       ', '       +-       ', '       +-       ', '       +-       ',
            '       +-       ', '       +-       ', '       +-       ', '       +-       ');
        $self->{separatorPixbuf} = Gtk2::Gdk::Pixbuf->new_from_xpm_data(@separatorXpm);

        return $self;
    }

    sub getInitData
    {
        my $self = shift;
        
        return $self->getDataFromList([
            'ToolbarSeparator',
            'gtk-add', 'gtk-save', 'gtk-preferences',
            'gtk-find', 'gtk-refresh', 'gtk-execute', 'gtk-media-play',
            'gtk-new', 'gtk-open', 'gtk-properties', 'gtk-quit',
            'gtk-dnd', 'gtk-delete', 'gtk-find-and-replace',
            'gtk-help',
            'ToolbarGroupBy', 'ToolbarQuickSearch', 'OptionsView', 'OptionsLayout',
            'MenuSavedSearches'
        ], 1);
    }
    
    sub getData
    {
        my $self = shift;
        if (! -f $self->{configFile})
        {
            return $self->getDefaultData;
        }
        open CONFIG, $self->{configFile};
        my @array;
        foreach (<CONFIG>)
        {
            s/\s+$//;
            push @array, $_;
        }
        close CONFIG;
        return $self->getDataFromList(\@array);
    }
    
    sub getDefaultData
    {
        my $self = shift;
        return $self->getDataFromList(\@GCToolBar::DEFAULT_CONTROLS);
    }

    sub saveList
    {
        my ($self, $list) = @_;

        open CONFIG, '>',$self->{configFile};
        foreach (@$list)
        {
            print CONFIG $self->{conversionMap}->{$_->[1]}, "\n";
        }
        close CONFIG;
    }
        
    sub preFill
    {
        my $self = shift;
        
        my @data;
        $self->getDoubleList->setListData($self->getDefaultData);
    }
    
    sub getDataFromList
    {
        my ($self, $list, $init) = @_;
        my @data;
        foreach my $id (@$list)
        {
            if ($id =~ /^gtk-/)
            {
                my $stockItem = Gtk2::Stock->lookup($id);
                # Make sure string has model dependant parts translated:
                (my $label = $self->{parent}->GCLang::getGenericModelString($stockItem->{label})) =~ s/_//g;
                my $pixbuf = $self->{parent}->render_icon($id, 'menu');                            
                push @data, [$pixbuf, $label];
                $self->{conversionMap}->{$label} = $id if $init;
            }
            else
            {
                my $pixbuf = undef;
                if ($id eq 'ToolbarSeparator')
                {
                    $pixbuf = $self->{separatorPixbuf};
                }
                my $label = $self->{parent}->{lang}->{$id};
                push @data, [$pixbuf, $label];
                $self->{conversionMap}->{$label} = $id if $init;
            }
        }
        return \@data;
    }
}

1;
