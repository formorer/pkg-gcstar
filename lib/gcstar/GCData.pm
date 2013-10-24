package GCData;

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
    package GCItems;
    #
    # This is seen as $main->{items}
    #    
    use XML::Parser;
    use Storable;
    use File::Copy;
    use File::Path;
    use File::Basename;

    use GCModel;
    use GCBackend::GCBackendXmlParser;

    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        my $self  = {};

        $self->{parent} = $parent;

        $self->{imagesToBeRemoved} = [];
        $self->{imagesToBeAdded} = [];
        $self->{loaded} = {};

        $self->{currentItem} = -1;
        $self->{hasBeenDeleted} = 0;
        $self->{block} = 0;
        $self->{previousFile} = 0;
        #$self->{filterSearch} = new GCFilterSearch;

        bless ($self, $class);
        return $self;
    }

    sub initModel
    {
        #if $modelChanged is set, that means we updated the currently used model
        # and not that we changed the model 
        my ($self, $model, $modelUpdated) = @_;
        $self->{model} = $model;
        $self->{parent}->notifyModelChange($modelUpdated);
    }

    sub setPanel
    {
        my ($self, $panel) = @_;
        $self->{panel} = $panel;
    }

    sub unselect
    {
        my ($self) = @_;
        
        $self->{currentItem} = -1;
    }

    sub updateSelectedItemInfoFromGivenPanel
    {
        my ($self, $panel) = @_;
        my $previousPanel = $self->{panel};
        $self->{panel} = $panel;
        $self->updateSelectedItemInfoFromPanel(1);
        $self->{panel} = $previousPanel;
    }

    sub getInfoFromPanel
    {
        # $info contains default values that will be merged with new ones
        my ($self, $panel, $info) = @_;
        
        my $idField = $self->{model}->{commonFields}->{id};
        my $panelId = $panel->$idField;
        my $previousId = $info->{$idField};
        
        my $changed = 0;
        if ($panelId &&
           ($panelId != $previousId))
        {
            $info->{$idField} = $panel->$idField;
            $self->{loaded}->{information}->{maxId} = $panelId
                if ($panelId > $self->{loaded}->{information}->{maxId});
            $self->findMaxId if $previousId == $self->{loaded}->{information}->{maxId};
            $changed = 1;
        }
        $panel->$idField($info->{$idField}) if $panel->$idField;

        my $previous = {$idField => $previousId};

        for my $field (@{$self->{model}->{fieldsNames}})
        {
            next if $field eq $idField;
            $previous->{$field} = $info->{$field};
            next if !$panel->{$field}->hasChanged;
            $panel->{$field}->addHistory if ($self->{model}->{fieldsInfo}->{$field}->{hasHistory});
            $changed = 1;
            $info->{$field} = $panel->$field;
            $self->{parent}->{menubar}->checkFilter($field);
        }
        
        return ($changed, $info, $previous);
    }

    sub updateSelectedItemInfoFromPanel
    {
        my ($self, $withSelect, $forced) = @_;
        my $selectedChanged = 0;
        my $filtered = 0;
        return $selectedChanged if $self->{currentItem} == -1;
        my $info;
        if ($self->{multipleMode})
        {
            $info = {};
        }
        else
        {
            $info = ($self->getItemsListFiltered)->[$self->{currentItem}];
        }

        my $changed;
        my $previous;
        ($changed, $info, $previous) = $self->getInfoFromPanel($self->{panel}, $info);
        if ($forced)
        {
            $previous->{$_} = 'GCS_FORCED' foreach @$forced;
        }
        if ($changed)
        {
            if ($self->{multipleMode})
            {
                my $newIdx;
                # Propagate the changes to all the items
                foreach (@{$self->{multipleCurrentItems}})
                {
                    my $previous = Storable::dclone(($self->getItemsListFiltered)->[$_]);
                    my $item = ($self->getItemsListFiltered)->[$_];
                    for my $field (keys %$info)
                    {
                        $item->{$field} = $info->{$field};
                    }
                    $self->{panel}->dataChanged($item, 1);
                    $newIdx = $self->{parent}->{itemsView}->changeItem($_, $previous, $item);
                    if ($newIdx != $_)
                    {
                        $selectedChanged = 1;
                    }
                }
                if ($selectedChanged)
                {
                    $self->{currentItem} = $self->{parent}->{itemsView}->getCurrentIdx;
                    $self->{multipleMode} = 0;
                    $self->displayCurrent;
                }
            }
            else
            {
                $self->{panel}->dataChanged($info);
                my $current = $self->{parent}->{itemsView}->changeCurrent($previous,
                                                                          $info,
                                                                          $self->{currentItem},
                                                                          $withSelect);
                # If we didn't selected the same, the selection didn't change
                if ($current != $self->{currentItem})
                {
                    $self->{currentItem} = $current;
                    $self->displayCurrent if $withSelect;
                    $selectedChanged = 1;
                }
                if ($selectedChanged)
                {
                    $filtered = 1;
                    $selectedChanged = 0 if !$withSelect;
                }
            }
            $self->{parent}->checkPanelVisibility;
            $self->{parent}->markAsUpdated;
        }
        return ($selectedChanged, $filtered);
    }
    
    sub getTitle
    {
        my ($self, $idx) = @_;
        if ($self->{multipleMode})
        {
            # Multiple items selected, so just use collection title or filename
            my $name;
            if ($self->{parent}->{options}->file)
            {
                $name = $self->{parent}->{items}->getInformation->{name}
                    if $self->{parent}->{items};
                $name ||= basename($self->{parent}->{options}->file);
            }
            else
            {
                $name = $self->{parent}->{lang}->{UnsavedCollection};
            }
            return $name;
        }
        else
        {
            my $realIdx = $idx;
            $realIdx = $self->{currentItem} if ! defined $idx;
            return ($self->getItemsListFiltered)->[$realIdx]->{$self->{model}->{commonFields}->{title}};
        }    
    }

    sub getCurrent
    {
        my ($self) = @_;
        return $self->{currentItem};
    }

    sub displayCurrent
    {
        my ($self) = @_;
        $self->displayInPanel($self->{panel}, undef);
    }
    
    sub displayInPanel
    {
        my ($self, $panel, $idx) = @_;
        my $info;
        if ($self->{multipleMode})
        {
            # We merge all the items here
            my %fields = map {$_ => 1} @{$self->{model}->{fieldsNotFormatted}};
            foreach (@{$self->{multipleCurrentItems}})
            {
                my $item = ($self->getItemsListFiltered)->[$_];
                for my $field (keys %fields)
                {
                    if (exists $info->{$field})
                    {
                        if ($self->transformValue($info->{$field}, $field)
                            ne
                            $self->transformValue($item->{$field}, $field))
                        {
                            $info->{$field} = '';
                            delete $fields{$field};
                            # TODO store the information also elsewhere to mark
                            # the fields in panel. Or mark it immediately with something
                            # such as
                            # panel->markAsDirty($field);
                        }
                    }
                    else
                    {
                        $info->{$field} = $item->{$field};
                    }
                }
            }
        }
        else
        {
            $idx = $self->{currentItem} if ! defined $idx;
            return if $self->{currentItem} < 0;
            $info = ($self->getItemsListFiltered)->[$idx];
        }
        $self->displayDataInPanel($panel, $info);
    }

    sub displayDataInPanel
    {
        my ($self, $panel, $info) = @_;
        for my $field (@{$self->{model}->{fieldsNotFormatted}})
        {
            $panel->$field($info->{$field});
            $panel->{$field}->resetChanged
                if $panel->{$field};
        }
        
        $panel->dataChanged;
        $GCGraphicComponent::somethingChanged = 0;
    }

    sub display
    {
        my $self = shift;
        return if (! $self->{itemArray}) || (! scalar @{$self->{itemArray}});
        my @numbers = @_;
        my $number;
        my $multipleMode;
        my $withSelect = 0;
        my $noUpdate = 0;
        if ($#numbers > 0)
        {
            $multipleMode = 1;
            $self->{multipleCurrentItems} = \@numbers;
        }
        else
        {
            $multipleMode = 0;
            $number = $numbers[0];
            if ($number == -1)
            {
                $number = 0;
                $noUpdate = 1;
            }
            # We want a selection if user clicked on the same one
            $withSelect = ($number == $self->{currentItem});
        }
        my ($selectedHasChanged, $filtered) = (0, 0);

        if ((!$noUpdate) && ($self->{currentItem} > -1) && !($self->{hasBeenDeleted}))
        {
            ($selectedHasChanged, $filtered) = $self->updateSelectedItemInfoFromPanel($withSelect);
        }
        else
        {
            $self->{currentItem} = $number
                if !$multipleMode;
        }
        $self->{multipleMode} = $multipleMode;
        $self->{hasBeenDeleted} = 0;

        $self->{currentItem} = $number if !$selectedHasChanged && !$multipleMode;
        $self->displayCurrent if !$selectedHasChanged;
        return ($selectedHasChanged || $filtered);
    }

    sub valueToDisplayed
    {
        my ($self, $value, $field) = @_;
        my $displayed = $self->{model}->getDisplayedValue($self->{model}->{fieldsInfo}->{$field}->{values}, $value);
        return $displayed if $displayed;
        # For personal models, it won't return a value. Then we keep the original one.
        return $value;
    }
                
    sub transformValue
    {
        my ($self, $value, $field, $type) = @_;
        
        $type ||= $self->{model}->{fieldsInfo}->{$field}->{type};
        $value = $self->{parent}->transformTitle($value) if $field eq $self->{model}->{commonFields}->{title};
        #$value = GCPreProcess::reverseDate($value) if $type eq 'date';
        $value = GCUtils::timeToStr($value, $self->{parent}->{options}->dateFormat)
            if $type eq 'date';
        $value = $self->valueToDisplayed($value, $field) if $type eq 'options';
        $value = GCPreProcess::multipleList($value, $type) if $type =~ /list$/o;
        return $value;
    }

    sub getValue
    {
        my ($self, $idx, $field) = @_;
        
        return ($self->getItemsListFiltered)->[$idx]->{$field};
    }
    
    sub setValue
    {
        my ($self, $idx, $field, $value) = @_;

        ($self->getItemsListFiltered)->[$idx]->{$field} = $value;
        if ($idx == $self->{currentItem})
        {
            $self->{panel}->$field($value);
            $self->{panel}->dataChanged;
        }
    }

    sub getItemsListFiltered
    {
        my ($self, $filter) = @_;
        
        return $self->{itemArray} if ! $filter;
        my @results = ();
        foreach (@{$self->{itemArray}})
        {
            if ($self->{parent}->{filterSearch}->test($_))
            {
                push @results, $_;
            }
        }
        return \@results;
    }
    
    # Should only be used by GCCommandExecution
    sub setItemsList
    {
        my ($self, $itemsList) = @_;

        $self->{itemArray} = $itemsList;
    }

    sub getInformation
    {
        my $self = shift;
        $self->{loaded}->{information} ||= {};
        return $self->{loaded}->{information};
    }

   sub setInformation
    {
        my ($self, $info) = @_;
        $self->{loaded}->{information} = $info;
    }

    sub reloadList
    {
        my ($self, $splash, $fullProgress, $filtering) = @_;
        return if $self->{block};
        if ($splash)
        {
            $splash->initProgress if $fullProgress;
            $splash->setItemsTotal(scalar @{$self->{itemArray}})
                if $self->{itemArray};
        }
        $self->{parent}->{itemsView}->reset if $self->{parent}->{itemsView};
        
        my $lastDisplayed = -1;
        my $hasId = 0;
        my $j = 0;
        my $idField = $self->{model}->{commonFields}->{id};
        my $currentId;

        # If we don't get an history from BE, we will have to initialize it now
        my $historyNeeded = ! $self->{loaded}->{gotHistory};
        my %histories;

        foreach (@{$self->{itemArray}})
        {
            if ($historyNeeded)
            {
                foreach my $field (@{$self->{model}->{fieldsHistory}})
                {
                    #push @{$histories{$field}}, $_->{$field};
                    $self->{panel}->addHistory($_->{$field}, 1);
                }
            }

            $currentId = $_->{$idField};

            $self->{parent}->{itemsView}->addItem($_, 0);               
            $lastDisplayed = $j;
            $splash->setProgressForItemsDisplay($j) if $splash;
            $j++;
        }

        if ($historyNeeded)
        {
            for my $hfield(@{$self->{model}->{fieldsHistory}})
            {
                $self->{panel}->{$hfield}->setDropDown;
            }
            # Now we are sure we got one
            $self->{loaded}->{gotHistory} = 2;
        }

        $self->{panel}->show if $j;

        #if ($splash && $fullProgress)
        #{
        #    $splash->endProgress;
        #}

        if (! $self->{parent}->{initializing})
        {
            $self->{parent}->reloadDone(0, $splash);
            $self->select($self->{currentItem}, 0);
        }
    }

    sub select
    {
        my ($self, $value, $init) = @_;
        return if !$self->{parent}->{itemsView};
        return $self->{parent}->{itemsView}->select($value, $init) unless  $value < -1;
    }

    sub removeCurrentItems
    {
        my $self = shift;

        my $numbers = $self->{parent}->{itemsView}->getCurrentItems;

        my $nbRemoved = 0;
        # Numerically sort list
        foreach my $number(sort {$a <=> $b} @$numbers)
        {
            # We need to adjust it because we already removed other ones.
            my $actualNumber = $number - $nbRemoved;
            foreach (@{$self->{model}->{managedImages}})
            {
                my $image = $self->{itemArray}->[$actualNumber]->{$_};
                $self->{parent}->checkPictureToBeRemoved($image);
            }

            splice @{$self->{itemArray}}, $actualNumber, 1;
            $nbRemoved++;
        }
        my $newIdx = $self->{parent}->{itemsView}->removeCurrentItems; #($number);

        $self->{currentItem} = $newIdx;
        $self->{multipleMode} = 0;
        $self->{hasBeenDeleted} = 1;
        $self->displayCurrent;
    }

    sub addItem
    {
        my ($self, $info, $keepId, $noSelect) = @_;
        my $nbItems = scalar @{$self->{itemArray}};
#        $self->{panel}->show if ! $nbItems;

        my $currentId;
        if ($keepId)
        {
            $currentId = $self->{itemArray}->[$nbItems]->{$self->{model}->{commonFields}->{id}};
        }
        else
        {
            $self->{loaded}->{information}->{maxId}++;        
            $currentId = $self->{loaded}->{information}->{maxId};
            $self->{itemArray}->[$nbItems]->{$self->{model}->{commonFields}->{id}} = $currentId;
        }
        
        for my $field (@{$self->{model}->{fieldsNames}})
        {
            next if $field eq $self->{model}->{commonFields}->{id};
            if ($self->{model}->{fieldsInfo}->{$field}->{hasHistory})
            {
                $self->{panel}->{$field}->addHistory($info->{$field});
            }
            $self->{itemArray}->[$nbItems]->{$field} = $info->{$field};
        }

        $self->{parent}->{itemsView}->addItem($self->{itemArray}->[$nbItems], 1);

        $self->{multipleMode} = 0;
        $self->{currentItem} = $nbItems;
        $self->displayCurrent;
        $self->select($nbItems, 0)
            if !$noSelect;
        
        $self->{parent}->{itemsView}->showCurrent;
        
        return $currentId;
    }
    
    sub setOptions
    {
        my ($self, $options) = @_;

        $self->{options} = $options;

        #return $self->load($options->file, $splash, 0);
    }

    sub markToBeRemoved
    {
        my ($self, $image) = @_;
        push @{$self->{imagesToBeRemoved}}, $image;
    }

    sub markToBeAdded
    {
        my ($self, $image) = @_;
        push @{$self->{imagesToBeAdded}}, $image;        
    }
    
    sub removeMarkedPictures
    {
        my $self = shift;
        my $image;
        foreach $image(@{$self->{imagesToBeRemoved}})
        {
            unlink $image;
        }

        $self->{imagesToBeRemoved} = [];
    }

    sub addMarkedPictures
    {
        my $self = shift;

        $self->{imagesToBeAdded} = [];
    }
    
    sub clean
    {
        my $self = shift;
        my $image;
        foreach (@{$self->{imagesToBeAdded}})
        {
            unlink $_;
        }
        $self->{oldImagesDirectory} = {};
        $self->{newImagesDirectory} = undef;
        $self->{copyImagesWhenChangingDir} = 0;
    }

    sub setNewImagesDirectory
    {
        # $prev is also a parameter because we didn't store it here
        my ($self, $new, $prev, $withCopy) = @_;
        $new =~ s|/$||;
        $self->{newImagesDirectory} = $new;
        $self->{copyImagesWhenChangingDir} = $withCopy;
        # We stored the previous one as a hash so it will be easier for tests
        $prev =~ s|/$||;
        $self->{oldImagesDirectory}->{$prev} = 1;
    }

    sub setPreviousFile
    {
        my ($self, $prev) = @_;
        
        $self->{previousFile} = $prev;
    }

    sub queryReplace
    {
        my ($self, $field, $old, $new, $caseSensitive) = @_;
        foreach (@{$self->{itemArray}})
        {
            if (ref($_->{$field}) eq 'ARRAY')
            {
                foreach my $subval(@{$_->{$field}})
                {
                    foreach my $val(@$subval)
                    {
                        if ($caseSensitive)
                        {
                            $val =~ s/$old/$new/g;
                        }
                        else
                        {
                            $val =~ s/$old/$new/gi;
                        }
                    }
                }
            }
            else
            {
                if ($caseSensitive)
                {
                   $_->{$field} =~ s/$old/$new/g;
                }
                else
                {
                   $_->{$field} =~ s/$old/$new/gi;
                }
            }
        }
        $self->displayCurrent;
        $self->reloadList;
    }
    
    sub findMaxId
    {
        my $self = shift;

        $self->{loaded}->{information}->{maxId} = -1;
        foreach (@{$self->{itemArray}})
        {
            $self->{loaded}->{information}->{maxId} = $_->{$self->{model}->{commonFields}->{id}}
                if $_->{$self->{model}->{commonFields}->{id}} > $self->{loaded}->{information}->{maxId};
        }
    }
    
    sub clearList
    {
        my $self = shift;
        $self->{currentItem} = -1;
        $self->{loaded} = {};
        $self->{itemArray} = [];
        $self->{panel}->hide if $self->{panel};
        $self->{parent}->{itemsView}->clearCache if $self->{parent}->{itemsView};
        $self->{parent}->{itemsView}->reset if $self->{parent}->{itemsView};
        #$self->{parent}->reloadDone(1) if ! $self->{parent}->{initializing};
        #$self->reloadList if ! $self->{parent}->{initializing};
    }

    sub getNbItems
    {
        my $self = shift;
        return 0 if ! $self->{itemArray};
        return scalar @{$self->{itemArray}};
    }

    sub setLock
    {
        my ($self, $value) = @_;
        $self->{loaded}->{information}->{locked} = $value;
    }

    sub getLock
    {
        my $self = shift;
        return $self->{loaded}->{information}->{locked};
    }

    sub getBackend
    {
        my ($self, $file) = @_;
        $self->{backend} = new GCBackend::GCBeXmlParser($self->{parent})
           if !$self->{backend};
        $self->{backend}->setParameters(file => $file,
                                        version => $self->{parent}->{version});
        return $self->{backend};
    }

    sub getVersion
    {
        my ($self, $file) = @_;
        
        return $self->getBackend($file)->getVersion;
    }

    sub load
    {
        my ($self, $file, $splash, $fullProgress, $noReload) = @_;

        my $initTime;
        if ($ENV{GCS_PROFILING} > 0)
        {
            eval 'use Time::HiRes';
            eval '$initTime = [Time::HiRes::gettimeofday()]';
        }

        $self->clean;
        if (!$file)
        {
            $self->{parent}->setCurrentModel;
            return 0;
        }

        my $collection;

        $self->{block} = 1;
        $self->clearList;
        $self->{block} = 0;
        $self->{splash} = $splash;
        my $backend;
        eval
        {
            $backend = $self->getBackend($file);
            
            $self->{loaded} = $backend->load($splash);
            # We keep a direct access to this one
            $self->{itemArray} = $self->{loaded}->{data};
        };
        if ($@)
        {
            my @error = ('Fatal error while reading file', $@);
            return (0, \@error);
        }
        elsif ($self->{loaded}->{error})
        {
            return (0, $self->{loaded}->{error});
        }

        # Perform Models Change if needed
        if(!$self->{model}->{isInline} && ($backend->getVersion() ne $backend->{version}))
        {
            my $modelFormatUpdater=GCModelsChanges->new($self,$self->{model}->{collection}->{name});
            $modelFormatUpdater->applyChanges($self->{itemArray}, $backend->getVersion(), $backend->{version});
        }

        # Hide the panel if no item
        if (! scalar @{$self->{itemArray}})
        {
            $self->{panel}->hide;
        }

        # gotHistory = 1 means we got one but it has not been set in components
        if ($self->{loaded}->{gotHistory} == 1)
        {
            for my $hfield(@{$self->{model}->{fieldsHistory}})
            {
                if (exists $self->{loaded}->{histories}->{$hfield})
                {
                    $self->{panel}->{$hfield}->setValues($self->{loaded}->{histories}->{$hfield}, 1);
                }
                $self->{panel}->{$hfield}->setDropDown;
            }
#            $self->{loaded}->{gotHistory} = 2;
        }
        elsif ($self->{loaded}->{gotHistory} == 2)
        {
            for my $hfield(@{$self->{model}->{fieldsHistory}})
            {
                $self->{panel}->{$hfield}->setDropDown;
            }
        }

        $self->reloadList($splash, $fullProgress) unless $noReload;
                
        if ($ENV{GCS_PROFILING} > 0)
        {
            my $elapsed;
            eval '$elapsed = Time::HiRes::tv_interval($initTime)';
            print "Load time : $elapsed\n";
        }

        return 1;
    }

    sub movePictures
    {
        my ($self) = @_;
        eval {
            mkpath $self->{newImagesDirectory};
            my $file;
            my $dataFile = $self->{previousFile} ? $self->{previousFile}  : $self->{options}->file;
            foreach (@{$self->getItemsListFiltered})
            {
                foreach my $pic(@{$self->{model}->{fieldsImage}})
                {
                    $file = GCUtils::getDisplayedImage($_->{$pic},
                                                       '',
                                                       $dataFile);
                    # Not moving picture if it is not in the previous directory
                    next if !$file;
                    next if ! exists $self->{oldImagesDirectory}->{Cwd::realpath(dirname($file))};
                    (my $suffix = $file) =~ s/.*?(\.[^.]*)$/$1/;
                    my $new = 
                        $self->{parent}->getUniqueImageFileName(
                            $suffix, 
                            $_->{$self->{model}->{commonFields}->{title}});
                    
                    if ($self->{copyImagesWhenChangingDir})
                    {
                        copy $file, $new;
                    }
                    else
                    {
                        move $file, $new;
                    }
                    $_->{$pic} = $new;
                }
            }
        };
        $self->{previousFile} = 0;
        return $@ if $@;
        $self->displayCurrent;
        $self->{newImagesDirectory} = undef;
        $self->{copyImagesWhenChangingDir} = 0;
        $self->{oldImagesDirectory} = {};
        return 0;
    }

    sub save
    {
        my ($self, $splash) = @_;

        my $initTime;
        if ($ENV{GCS_PROFILING} > 0)
        {
            eval 'use Time::HiRes';
            eval '$initTime = [Time::HiRes::gettimeofday()]';
        }

        $self->updateSelectedItemInfoFromPanel if ($self->{currentItem} > -1);

        # TODO : Use progress bar for this operation also
        my $moveError = $self->movePictures
            if $self->{newImagesDirectory};
        return (0, ['SaveError', $moveError])
            if $moveError;
        

        if ($splash)
        {
            $splash->initProgress($self->{parent}->{lang}->{StatusSave});
            $splash->setItemsTotal(scalar @{$self->{itemArray}});
        }
        $self->addMarkedPictures;
        $self->removeMarkedPictures;

        my $backend = $self->getBackend($self->{options}->file);

        # We re-generate histories to give it to backend
        # Deactivated for the moment
#        if ($self->{panel})
#        {
#            my %histories;
#            for my $hfield(@{$self->{model}->{fieldsHistory}})
#            {
#                $histories{$hfield} = $self->{panel}->{$hfield}->getValues;
#            }
#            $backend->setHistories(\%histories);
#        }

        my $result = $backend->save($self->{itemArray},
                                    $self->{loaded}->{information},
                                    $splash);

        $self->{parent}->endProgress;
        if ($result->{error})
        {
            return (0, $result->{error});
        }
        $self->{parent}->removeUpdatedMark;

        if ($ENV{GCS_PROFILING} > 0)
        {
            my $elapsed;
            eval '$elapsed = Time::HiRes::tv_interval($initTime)';
            print "Save time : $elapsed\n";
        }
        return 1;
    }

    sub getSummary
    {
        my ($self, $idx) = @_;
        
        my $info = ($self->getItemsListFiltered)->[$idx];

        my $summary = "<b>".GCUtils::encodeEntities($info->{$self->{model}->{commonFields}->{title}})."</b>\n";
        
        for my $field (@{$self->{model}->getSummaryFields})
        {
            my $value = $info->{$field};
            
            if ($field eq $self->{model}->{commonFields}->{borrower}->{name})
            {
                $value = $self->{parent}->{lang}->{PanelNobody}
                    if $value eq 'none';
                $value = $self->{parent}->{lang}->{PanelUnknown}
                    if $value eq 'unknown';
            }
            else
            {
                $value =  GCUtils::encodeEntities($self->transformValue($value, $field));
            }
            $summary .= "\n<b>"
                       .GCUtils::encodeEntities($self->{model}->getDisplayedLabel($field))
                       .$self->{parent}->{lang}->{Separator}
                       ."</b>"
                       .$value;
        }
        return $summary;
    }
}

1;
