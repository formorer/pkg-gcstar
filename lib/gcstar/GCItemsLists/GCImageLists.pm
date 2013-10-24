package GCImageLists;

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
use locale;

# Number of ms to wait before enhancing the next picture
my $timeOutBetweenEnhancements = 50;

{
    package GCBaseImageList;
    
    use File::Basename;
    use GCItemsLists::GCImageListComponents;
    use GCUtils;
    use GCStyle;
    use base "Gtk2::VBox";
    use File::Temp qw/ tempfile /;
    
    sub new
    {
        my ($proto, $container, $columns) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new(0,0);
        bless ($self, $class);
        
        my $parent = $container->{parent};
        
        $self->{preferences} = $parent->{model}->{preferences};
        $self->{imagesDir} = $parent->getImagesDir();
        $self->{coverField} = $parent->{model}->{commonFields}->{cover};
        $self->{titleField} = $parent->{model}->{commonFields}->{title};
        $self->{idField} = $parent->{model}->{commonFields}->{id};
        $self->{borrowerField} = $parent->{model}->{commonFields}->{borrower}->{name};
        # Sort field
        $self->{sortField} = $self->{preferences}->secondarySort
                                  || $self->{titleField};
        $self->{fileIdx} = "";
        $self->{selectedIndexes} = {};
        $self->{previousSelectedDisplayed} = 0;
        $self->{displayedToItemsArray} = {};
        $self->{container} = $container;
        $self->{scroll} = $container->{scroll};
        $self->{searchEntry} = $container->{searchEntry};
        

        $self->{preferences}->sortOrder(1)
            if ! $self->{preferences}->exists('sortOrder');
        
        $self->{parent} = $container->{parent};
        
        $self->{tooltips} = Gtk2::Tooltips->new();
        
        $self->{columns} = $columns;
        $self->{dynamicSize} = ($columns == 0);
        $self->clearCache;


        $self->set_border_width(0);

        $self->signal_connect('button_press_event' => sub {
            my ($widget, $event) = @_;
            if ($event->button eq 3)
            {
                $self->{parent}->{context}->popup(undef, undef, undef, undef, $event->button, $event->time)
            }
        });

        $self->can_focus(1);
        
        $self->{imageCache} = new GCImageCache($self->{imagesDir},
                                               $self->{preferences}->listImgSize,
                                               $container->{style},
                                               $self->{parent}->{defaultImage});
        
        return $self;
    }

    sub couldExpandAll
    {
        my $self = shift;
        
        return 0;
    }

    sub getCurrentIdx
    {
        my $self = shift;
        return $self->{displayedToIdx}->{$self->{current}};
    }

    sub getCurrentItems
    {
        my $self = shift;
        my @indexes = keys %{$self->{selectedIndexes}};
        return \@indexes;
    }

    sub isSelected
    {
        my ($self, $idx) = @_;
        foreach (keys %{$self->{selectedIndexes}})
        {
            return 1 if $_ == $idx;
        }
        return 0;
    }

    sub DESTROY
    {
        my $self = shift;
        
        #unlink $self->{style}->{tmpBgPixmap};
        $self->SUPER::DESTROY;
    }

    sub isUsingDate
    {
        my ($self) = @_;
        return 0;
    }

    sub setSortOrder
    {
        my ($self, $order) = @_;
        $order = 0 if !defined $order;
        $self->{currentOrder} = ($order == -1) ? (1 - $self->{currentOrder})
                                               : $self->{preferences}->sortOrder;

        if ($self->{itemsArray})
        {
            if ($order == -1)
            {
                @{$self->{itemsArray}} = reverse @{$self->{itemsArray}};
            }
            else
            {
                sub compare
                {
                    return (
                            GCUtils::gccmpe($a->{sortValue}, $b->{sortValue})
                           );
                }
                if ($self->{currentOrder} == 1)
                {
                    @{$self->{itemsArray}} = sort compare @{$self->{itemsArray}};
                }
                else
                {
                    @{$self->{itemsArray}} = reverse sort compare @{$self->{itemsArray}};
                }
            }
        }
        $self->refresh if ! $self->{initializing};
        $self->{initializing} = 0;
    }

    sub setFilter
    {
        my ($self, $filter, $items, $refresh, $splash) = @_;
        $self->{displayedNumber} = 0;
        $self->{filter} = $filter;
        $self->{displayedToItemsArray} = {};
        my $current = $self->{current};
        $self->restorePrevious;
        my $i = 0;
        foreach (@{$self->{itemsArray}})
        {
            $_->{displayed} = $filter->test($items->[$_->{idx}]);
            if ($_->{displayed})
            {
                $self->{displayedToItemsArray}->{$self->{displayedNumber}} = $i;
                $self->{displayedNumber}++;
            }
            $self->{container}->setDisplayed($_->{idx}, $_->{displayed});
            $i++;
        }
        my $newIdx = $self->getFirstVisibleIdx($current);
        my $conversionNeeded = 0;
        $conversionNeeded = 1 if ! exists $self->{boxes}->[$current];
        
        if ($refresh)
        {
            $self->refresh(1, $splash);
            $self->show_all;
        }
        
        $self->{initializing} = 0;
        return $self->displayedToItemsArrayIdx($newIdx)
            if $conversionNeeded;
        return $newIdx;
    }

    sub getFirstVisibleIdx
    {
        my ($self, $displayed) = @_;
        return $displayed if ! exists $self->{boxes}->[$displayed];
        my $currentIdx = $self->{boxes}->[$displayed]->{info}->{idx};
        my $info =  $self->{boxes}->[$displayed]->{info};

        return $currentIdx if (! exists $self->{boxes}->[$displayed])
                           || ($self->{boxes}->[$displayed]->{info}->{displayed});
        my $previous = -1;
        my $after = 0;
        foreach my $item(@{$self->{itemsArray}})
        {
            $after = 1 if $item->{idx} == $currentIdx;
            if ($after)
            {
                return $item->{idx} if $item->{displayed};
            }
            else
            {
                $previous = $item->{idx} if $item->{displayed};
            }
        }
        return $previous;
    }

    sub refresh
    {
        my ($self, $forceClear, $splash) = @_;
        return if $self->{columns} == 0;

        # Store current item index
        my $currentIdx = $self->{displayedToIdx}->{$self->{current}};
        $self->{boxes} = [];
        $self->{displayedToIdx} = {};
        $self->{idxToDisplayed} = {};

        $self->clearView if (! $self->{initializing}) || $forceClear;
        $self->{number} = 0;
        my $idx = 0;
        $self->{collectionDir} = dirname($self->{parent}->{options}->file);
        foreach (@{$self->{itemsArray}})
        {
            $splash->setProgressForItemsSort($idx++) if $splash;
            next if ! $_->{displayed};
            $self->addDisplayedItem($_);
        }
        delete $self->{collectionDir};
        # Determine new current displayed
        $self->{current} = $self->{idxToDisplayed}->{$currentIdx};
        if ($self->{toBeSelectedLater})
        {
            $self->{parent}->display($self->select(-1));
            $self->{toBeSelectedLater} = 0;
        }
        #$self->show_all;
    }

    sub getNbItems
    {
        my $self = shift;
        return $self->{displayedNumber};
    }

    sub clearCache
    {
        my $self = shift;
        
        if ($self->{cache})
        {
            foreach (@{$self->{cache}})
            {
                $_->{imageBox}->destroy
                    if $_->{imageBox};
            }
        }
        $self->{cache} = [];
    }

    sub reset
    {
        my $self = shift;
        #Restore current picture if modified
        $self->restorePrevious;
        
        $self->{itemsArray} = [];
        $self->{boxes} = [];
        $self->{number} = 0;
        $self->{count} = 0;
        $self->{displayedNumber} = 0;
        $self->{current} = 0;
        $self->{previous} = 0;
        $self->clearView;
    }

    sub clearView
    {
        my $self = shift;

        # TODO : This will be different with many lists
        #my $parent = $self->parent;
        #$self->parent->remove($self)
        #    if $parent;

        my @children = $self->get_children;
        foreach (@children)
        {
            my @children2 = $_->get_children;
            foreach my $child(@children2)
            {
                $_->remove($child);
            }
            $self->remove($_);
            $_->destroy;
        }
        $self->{rowContainers} = [];
        $self->{enhanceInformation} = [];
        
        # TODO : This will be different with many lists
        #$self->{scroll}->add_with_viewport($self)
        #    if $parent;

        $self->{initializing} = 1;
    }

    sub done
    {
        my ($self, $splash, $refresh) = @_;
        if ($refresh)
        {
            $self->refresh(0, $splash);
        }
        $self->{initializing} = 0;
    }
    
    sub setColumnsNumber
    {
        my ($self, $columns, $refresh) = @_;
        $self->{columns} = $columns;
        my $init = $self->{initializing};
        $self->{initializing} = 1;
        $self->refresh($refresh) if $refresh;
        $self->show_all;
        $self->{initializing} = $init;
    }

    sub getColumnsNumber
    {
        my $self = shift;
        return $self->{columns};
    }
    
    sub createImageBox
    {
        my ($self, $info) = @_;
        
        my $imageBox = new GCImageListItem($self, $info);
        return $imageBox;
    }

    sub getFromCache
    {
        my ($self, $info) = @_;
        if (! $self->{cache}->[$info->{idx}])
        {
            my $item = {};
            $item->{imageBox} = $self->createImageBox($info);
            $self->{cache}->[$info->{idx}] = $item;
        }
        return $self->{cache}->[$info->{idx}];
    }
    
    sub findPlace
    {
        my ($self, $item, $sortvalue) = @_;
        my $refSortValue = $sortvalue || $item->{sortValue};
        $refSortValue = uc($refSortValue);

        # First search where it should be inserted
        my $place = 0;
        my $itemsIdx = 0;
        if ($self->{currentOrder} == 1)
        {
            foreach my $followingItem(@{$self->{itemsArray}})
            {
                my $testSortValue = uc($followingItem->{sortValue});
                my $cmp = GCUtils::gccmpe($testSortValue, $refSortValue);
                $itemsIdx++ if ! ($cmp > 0);
                
                next if !$followingItem->{displayed};
                last if ($cmp > 0);
                $place++;
            }
        }
        else
        {
            foreach my $followingItem(@{$self->{itemsArray}})
            {
                my $testSortValue = uc($followingItem->{sortValue});
                my $cmp = GCUtils::gccmpe($refSortValue, $testSortValue);                           
                $itemsIdx++ if ! ($cmp > 0);
                next if !$followingItem->{displayed};
                last if ($cmp > 0);
                $place++;
            }
        }
        return ($place, $itemsIdx) if wantarray;
        return $place;
    }
    
    sub createItemInfo
    {
        my ($self, $idx, $info) = @_;
        my $displayedImage = GCUtils::getDisplayedImage($info->{$self->{coverField}},
                                                        undef,
                                                        $self->{parent}->{options}->file,
                                                        $self->{collectionDir});
        my $item = {
                     idx => $idx,
                     title => $self->{parent}->transformTitle($info->{$self->{titleField}}),
                     picture => $displayedImage,
                     borrower => $info->{$self->{borrowerField}},
                     sortValue => $self->{sortField} eq $self->{titleField}
                                                                            ? $self->{parent}->transformTitle($info->{$self->{titleField}})
                                                                            : $info->{$self->{sortField}},
                     favourite => $info->{favourite},
                     displayed => 1,
                     autoid => $info->{$self->{idField}}
                   };
        return $item;        
    }

    sub addItem
    {
        my ($self, $info, $immediate, $idx, $keepConversionTables) = @_;
        
        my $item = $self->createItemInfo($idx, $info);

        if ($immediate)
        {
            # When the flag is set, that means we modified an item and that it had
            # to be added to that group. In this case, we don't want to de-select
            # the current one.
            if (!$keepConversionTables)
            {
                $self->restorePrevious;
                # To force the selection
                $self->{current} = -1;
            }
            # First search where it should be inserted
            my ($place, $itemsArrayIdx) = $self->findPlace($item);
            # Prepare the conversions displayed <-> index
            if (!$keepConversionTables)
            {
                $self->{displayedToIdx}->{$place} = $idx;
                $self->{idxToDisplayed}->{$idx} = $place;
            }
            # Then we insert it at correct position
            $self->addDisplayedItem($item, $place);
            splice @{$self->{itemsArray}}, $itemsArrayIdx, 0, $item;
        }
        else
        {
            # Here we know it will be sorted after
            push @{$self->{itemsArray}}, $item;
        }
        
        $self->{count}++;
        $self->{displayedNumber}++;
        $self->{header}->show_all if $self->{header} && $self->{displayedNumber} > 0;
    }

    # Params:
    #         $info:  Information already formated for this class
    #         $place: Optional value to indicate where it should be inserted
    sub addDisplayedItem
    {
        # info is an iternal info generated 
        my ($self, $info, $place) = @_;
        return if ! $self->{columns};
        my $item = $self->getFromCache($info);
        my $imageBox = $item->{imageBox};
        my $i = $info->{idx};
        if (!defined $place)
        {
            $self->{displayedToIdx}->{$self->{number}} = $i;
            $self->{idxToDisplayed}->{$i} = $self->{number};
        }
        $imageBox->prepareHandlers($i, $info);

        if (($self->{number} % $self->{columns}) == 0)
        {
            #New row begin
            $self->{currentRow} = new Gtk2::HBox(0,0);
            push @{$self->{rowContainers}}, $self->{currentRow};
            $self->pack_start($self->{currentRow},0,0,0);
            $self->{currentRow}->show_all if ! $self->{initializing};
        }
        
        if (defined($place))
        {
            # Get the row and col where it should be inserted
            my $itemLine = int $place / $self->{columns};
            my $itemCol = $place % $self->{columns};
            # Insert it at correct place
            $self->{rowContainers}->[$itemLine]->pack_start($imageBox,0,0,0);
            $self->{rowContainers}->[$itemLine]->reorder_child($imageBox, $itemCol);
            $imageBox->show_all;
            $self->shiftItems($place, 1, 0, scalar @{$self->{boxes}});
            splice @{$self->{boxes}}, $place, 0, $imageBox;
            $self->initConversionTables;            
        }
        else
        {
            $self->{currentRow}->pack_start($imageBox,0,0,0);
            $self->{idxToDisplayed}->{$i} = $self->{number};
            push @{$self->{boxes}}, $imageBox;
        }

        $self->{number}++;
    }
    
    sub grab_focus
    {
        my $self = shift;
        $self->SUPER::grab_focus;
        $self->{boxes}->[$self->{current}]->grab_focus;
    }

    sub displayedToItemsArrayIdx
    {
        my ($self, $displayed) = @_;
        return 0 if ! exists $self->{boxes}->[$displayed];
        # If we have nothing, that means we have no filter. So displayed and idx are the same
        return $displayed if ! exists $self->{displayedToItemsArray}->{$displayed};
        return $self->{displayedToItemsArray}->{$displayed};
    }

    sub shiftItems
    {
        my ($self, $place, $direction, $justFromView, $maxPlace) = @_;
        my $idx = $self->{displayedToIdx}->{$place};
        my $itemLine = int $place / $self->{columns};
        my $itemCol = $place % $self->{columns};
        # Did we already remove or add the item ?
        my $alreadyChanged = ($direction < 0) || (defined $maxPlace);
        # Useful to always have the same comparison a few lines below
        # Should be >= for $direction == 1
        # This difference is because we didn't added it yet while it has
        # already been removed in the other direction
        #$itemCol-- if ! (defined $maxPlace);
        $itemCol++ if ($direction < 0);
        # Same here
        $idx-- if $alreadyChanged;
        my $newDisplayed = 0;
        my $currentLine = 0;
        my $currentCol;
        my $shifting = 0;
        # Limit indicates which value for column should make use take action
        # For backward, it's the 1st one. For forward, the last one
        my $limit = 0;
        $limit = ($self->{columns} - 1) if $direction > 0;
        foreach my $item(@{$self->{itemsArray}})
        {
            if (!$item->{displayed})
            {
                $item->{idx} += $direction if ((!defined $maxPlace) && ($item->{idx} > $idx));
                next;
            }
            $currentLine = int $newDisplayed / $self->{columns};
            $currentCol = $newDisplayed % $self->{columns};
            $shifting = $direction if (!$shifting)
                                   && (
                                       ($currentLine >  $itemLine)
                                    || (($currentLine == $itemLine)
                                     && ($currentCol  >=  $itemCol))
                                   );
            $shifting = 0 if (defined $maxPlace) && ($newDisplayed > $maxPlace);
            # When using maxPlace, we are only moving in view
            if ((!defined $maxPlace) && ($item->{idx} > $idx))
            {
                $item->{idx} += $direction;
                $self->{cache}->[$item->{idx}]->{imageBox}->{idx} = $item->{idx}
                    if ($item->{idx} > 0) && $self->{cache}->[$item->{idx}];
            }
            if ($shifting)
            {
                # Is this the first/last one in the line?
                if ($currentCol == $limit)
                {
                    $self->{rowContainers}->[$currentLine]->remove(
                        $self->{cache}->[$item->{idx}]->{imageBox}
                    );
                    $self->{rowContainers}->[$currentLine + $direction]->pack_start(
                        $self->{cache}->[$item->{idx}]->{imageBox},
                        0,0,0
                    );
                    # We can't directly insert on the beginning.
                    # So we need a little adjustement here
                    if ($direction > 0)
                    {
                        $self->{rowContainers}->[$currentLine + $direction]->reorder_child(
                            $self->{cache}->[$item->{idx}]->{imageBox},
                            0
                        );
                    }
                }
            }
            $newDisplayed++;
        }
    }

    sub shiftIndexes
    {
        my ($self, $indexes) = @_;
        my $nbIndexes = scalar @$indexes;
        my $nbLower;
        my $currentIdx;
        my @cache;
        foreach my $box(@{$self->{boxes}})
        {
            # Find how many are lowers in our indexes
            # We suppose they are sorted
            $nbLower = 0;
            $currentIdx = $box->{info}->{idx};
            foreach (@$indexes)
            {
                last if $_ > $currentIdx;
                $nbLower++;
            }
            $box->{info}->{idx} -= $nbLower;
            $cache[$box->{info}->{idx}] = $self->{cache}->[$box->{info}->{idx} + $nbLower];
        }
        $self->{cache} = \@cache;
    }

    sub initConversionTables
    {
        my $self = shift;
        my $displayed = 0;
        $self->{displayedToIdx} = {};
        $self->{idxToDisplayed} = {};
        foreach (@{$self->{boxes}})
        {
            $self->{displayedToIdx}->{$displayed} = $_->{info}->{idx};
            $self->{idxToDisplayed}->{$_->{info}->{idx}} = $displayed;
            $_->{idx} = $_->{info}->{idx};
            $displayed++;
        }
    }
    
    sub convertIdxToDisplayed
    {
        my ($self, $idx) = @_;
        return $self->{idxToDisplayed}->{$idx};
    }

    sub convertDisplayedToIdx
    {
        my ($self, $displayed) = @_;
        return $self->{displayedToIdx}->{$displayed};
    }

    sub removeItem
    {
        my ($self, $idx, $justFromView) = @_;
        $self->{count}--;
        $self->{displayedNumber}--;
        # Fix to remove header only when items are grouped
        $self->{header}->hide if $self->{container}->{groupItems} && $self->{displayedNumber} <= 0;
        my $displayed = $self->{idxToDisplayed}->{$idx};
        my $itemLine = int $displayed / $self->{columns};
        #my $itemCol = $displayed % $self->{columns};
        $self->{rowContainers}->[$itemLine]->remove(
            $self->{cache}->[$idx]->{imageBox}
        );

        # Remove event box from cache
        my $itemsArrayIdx = $self->displayedToItemsArrayIdx($displayed);

        $self->{cache}->[$idx]->{imageBox}->destroy;
        $self->{cache}->[$idx]->{imageBox} = 0;

        splice @{$self->{cache}}, $idx, 1 if !$justFromView;
        splice @{$self->{boxes}}, $self->{idxToDisplayed}->{$idx}, 1;

        if ($justFromView)
        {
            $self->shiftItems($displayed, -1, 0, scalar @{$self->{boxes}});
        }
        else
        {
            $self->shiftItems($displayed, -1);
        }
        $self->initConversionTables;

        splice @{$self->{itemsArray}}, $itemsArrayIdx, 1;
        my $next = $self->{displayedToIdx}->{$displayed};
        if ($displayed >= (scalar(@{$self->{boxes}})))
        {
            $next = $self->{displayedToIdx}->{--$displayed}
        }
        $self->{current} = $displayed;
        
        my $last = scalar @{$self->{itemsArray}};
        delete $self->{displayedToIdx}->{$last};
        # To be sure we still have consistent data, we re-initialize the other hash by swapping keys and values.
        $self->{idxToDisplayed} = {};
        my ($k,$v);
        $self->{idxToDisplayed}->{$v} = $k while (($k,$v) = each %{$self->{displayedToIdx}});
		
        # Fix to remove items from "displayed" list on delete
        my $numDisplayed = scalar(keys %{$self->{container}->{displayed}});
        delete $self->{container}->{displayed}->{$numDisplayed-1};		
		
        $self->{number}--;
        return $next;
    }

    sub removeCurrentItems
    {
        my ($self) = @_;
        my @indexes = sort {$a <=> $b} keys %{$self->{selectedIndexes}};
        my $nbRemoved = 0;
        $self->restorePrevious;
        my $next;
        foreach my $idx(@indexes)
        {
            $next = $self->removeItem($idx - $nbRemoved);
            $nbRemoved++;
        }
        $self->{selectedIndexes} = {};
        $self->select($next, 1);

        return $next;
    }

    sub restoreItem
    {
        my ($self, $idx) = @_;

        my $previous = $self->{idxToDisplayed}->{$idx};
        next if ($previous == -1) || (!defined $previous) || (!$self->{boxes}->[$previous]);
           
        $self->{boxes}->[$previous]->unhighlight;
        delete $self->{selectedIndexes}->{$idx};
    }

    sub restorePrevious
    {
        my ($self, $fromContainer) = @_;
        foreach my $idx(keys %{$self->{selectedIndexes}})
        {
            $self->restoreItem($idx);
        }
        $self->{container}->clearSelected($self) if !$fromContainer;
    }

    sub selectAll
    {
        my $self = shift;

        $self->restorePrevious;
        $self->select($self->{displayedToIdx}->{0}, 1, 0);
        foreach my $displayed(1..scalar(@{$self->{boxes}}) - 1)
        {
            $self->select($self->{displayedToIdx}->{$displayed}, 0, 1);
        }
        $self->{parent}->display(keys %{$self->{selectedIndexes}});
    }

    sub selectMany
    {
        my ($self, $lastSelected) = @_;
        
        my ($min, $max);
        if ($self->{previousSelectedDisplayed} > $self->{idxToDisplayed}->{$lastSelected})
        {
            $min = $self->{idxToDisplayed}->{$lastSelected};
            $max = $self->{previousSelectedDisplayed};
        }
        else
        {
            $min = $self->{previousSelectedDisplayed};
            $max = $self->{idxToDisplayed}->{$lastSelected};
        }
        foreach my $displayed($min..$max)
        {
            $self->select($self->{displayedToIdx}->{$displayed}, 0, 1);
        }
        
    }

    sub select
    {
        my ($self, $idx, $init, $keepPrevious) = @_;
        $self->{container}->setCurrentList($self);
        $idx = $self->{displayedToIdx}->{0} if $idx == -1;
        my $displayed = $self->{idxToDisplayed}->{$idx};
        if (! $self->{columns})
        {
            $self->{toBeSelectedLater} = 1;
            return $idx;
        }
        my @boxes = @{$self->{boxes}};
        
        return $idx if ! scalar(@boxes);
        my $alreadySelected = 0;
        $alreadySelected = $boxes[$displayed]->{selected}
            if exists $boxes[$displayed];
        my $nbSelected = scalar keys %{$self->{selectedIndexes}};

        return $idx if $alreadySelected && ($nbSelected < 2) && (!$init);
        if ($keepPrevious)
        {
            if (($alreadySelected) && ($nbSelected > 1))
            {

                $self->restoreItem($idx);
                # Special case where user has deselect items, so now only one item is left selected
                # and menus need to be updated to reflect that
                $self->updateMenus(1)
                    if $nbSelected <= 2;    
                                
                return $idx;
            }
            $self->{selectedIndexes}->{$idx} = 1;
        }
        else
        {
            $self->restorePrevious;
            $self->{selectedIndexes} = {$idx => 1};
        }
                   
        $self->{current} = $displayed;

        $boxes[$displayed]->highlight
            if exists $boxes[$displayed];

        $self->grab_focus;
        $self->{container}->setCurrentList($self)
            if $self->{container};
        
        # Update menu items to reflect number of items selected
        $self->updateMenus(scalar keys %{$self->{selectedIndexes}});
        return $idx;
    }

    sub displayDetails
    {
        my ($self, $createWindow, @idx) = @_;
        if ($createWindow)
        {
            $self->{parent}->displayInWindow($idx[0]);
        }
        else
        {
            $self->{parent}->display(@idx);
        }
    }

    sub showPopupMenu
    {
        my ($self, $button, $time) = @_;
        
        $self->{parent}->{context}->popup(undef, undef, undef, undef, $button, $time);
    }

    sub setPreviousSelectedDisplayed
    {
        my ($self, $idx) = @_;
        $self->{previousSelectedDisplayed} = $self->{idxToDisplayed}->{$idx}
            if !exists $self->{previousSelectedDisplayed};
    }

    sub unsetPreviousSelectedDisplayed
    {
        my ($self, $idx) = @_;
        delete $self->{previousSelectedDisplayed};
    }

    sub updateMenus
    {    
        # Update menu items to reflect number of items selected
        my ($self, $nbSelected) = @_;
        foreach (
                 # Menu labels
                 [$self->{parent}->{menubar}, 'duplicateItem', 'MenuDuplicate'],
                 [$self->{parent}->{menubar}, 'deleteCurrentItem', 'MenuEditDeleteCurrent'],
                 # Context menu labels
                 [$self->{parent}, 'contextNewWindow', 'MenuNewWindow'],
                 [$self->{parent}, 'contextDuplicateItem', 'MenuDuplicate'],
                 [$self->{parent}, 'contextItemDelete', 'MenuEditDeleteCurrent'],
                )
        {
            $self->{parent}->{menubar}->updateItem(
                $_->[0]->{$_->[1]},
                $_->[2].(($nbSelected > 1) ? 'Plural' : ''));
        }
    }

    sub setHeader
    {
        my ($self, $header) = @_;
        $self->{header} = $header;
    }

    sub showCurrent
    {
        my $self = shift;
        return if ! $self->{columns};
        if ($self->{initializing})
        {
            Glib::Timeout->add(100 ,\&showCurrent, $self);
            return;
        }
 
        my $adj = $self->{scroll}->get_vadjustment;
        my $totalRows = int $self->{number} / $self->{columns};
        my $row = (int $self->{current} / $self->{columns});

        my $ypos = 0;
        if ($self->{header})
        {
            $ypos = $self->{header}->allocation->y;
            # We scroll also the size of the header.
            # But we don't do that for the 1st row to have it displayed then.
            $ypos += $self->{header}->allocation->height
                if $row;
        }
        # Add the items before
        $ypos += (($row - 1) * $self->{style}->{vboxHeight});
        
        $adj->set_value($ypos);
        return 0;
    }

    sub changeItem
    {
        my ($self, $idx, $previous, $new, $withSelect) = @_;
        return $self->changeCurrent($previous, $new, $idx, 0);
    }

    sub changeCurrent
    {
        my ($self, $previous, $new, $idx, $wantSelect) = @_;
        my $forceSelect = 0;
        #To ease comparison, do some modifications.
        #empty borrower is equivalent to 'none'.
        $previous->{$self->{borrowerField}} = 'none' if $previous->{$self->{borrowerField}} eq '';
        $new->{$self->{borrowerField}} = 'none' if $new->{$self->{borrowerField}} eq '';
        my $previousDisplayed = $self->{idxToDisplayed}->{$idx};
        my $newDisplayed = $previousDisplayed;
        if ($new->{$self->{sortField}} ne $previous->{$self->{sortField}})
        {
            # Adjust title
            my $newTitle = $self->{parent}->transformTitle($new->{$self->{titleField}});
            my $newSort = $self->{sortField} eq $self->{titleField} ? $newTitle : $new->{$self->{sortField}};

            $self->{boxes}->[$previousDisplayed]->{info}->{title} = $newTitle;
            $self->{tooltips}->set_tip($self->{boxes}->[$previousDisplayed], $newTitle, '');
            my $newItemsArrayIdx;
            ($newDisplayed, $newItemsArrayIdx) = $self->findPlace(undef, $newSort);
            # We adjust the index as we'll remove an item
            $newDisplayed-- if $newDisplayed > $previousDisplayed;
            if ($previousDisplayed != $newDisplayed)
            {
                #$self->restorePrevious;
                my $itemPreviousLine = int $previousDisplayed / $self->{columns};
                my $itemNewLine = int $newDisplayed / $self->{columns};
                my $itemNewCol = $newDisplayed % $self->{columns};
                my ($direction, $origin, $limit);
                if ($previousDisplayed > $newDisplayed)
                {
                    $direction = 1;
                    $origin = $newDisplayed;
                    $limit = $previousDisplayed - 1;
                }
                else
                {
                    $direction = -1;
                    $origin = $previousDisplayed;
                    $limit = $newDisplayed;
                    $itemNewCol++ if ($itemNewLine > $itemPreviousLine) && ($itemNewCol != 0)
                }
                my $box = $self->{cache}->[$idx]->{imageBox};
                my $previousItemsArrayIdx = $self->displayedToItemsArrayIdx($previousDisplayed);
                $self->{rowContainers}->[$itemPreviousLine]->remove($box);
                splice @{$self->{boxes}}, $previousDisplayed, 1;
                $self->{rowContainers}->[$itemNewLine]->pack_start($box,0,0,0);
                $self->{rowContainers}->[$itemNewLine]->reorder_child($box, $itemNewCol);

                $self->shiftItems($origin, $direction, 0, $limit);
                my $item = splice @{$self->{itemsArray}}, $previousItemsArrayIdx, 1;
                $newItemsArrayIdx-- if $previousItemsArrayIdx < $newItemsArrayIdx;
                splice @{$self->{itemsArray}}, $newItemsArrayIdx, 0, $item;
                splice @{$self->{boxes}}, $newDisplayed, 0, $box;
                $self->initConversionTables;
            }
        }

        my @boxes = @{$self->{boxes}};
        my $item = $self->createItemInfo($idx, $new);
        if (($previous->{$self->{coverField}} ne $new->{$self->{coverField}})
         || ($previous->{$self->{borrowerField}} ne $new->{$self->{borrowerField}})
         || ($previous->{favourite} ne $new->{favourite}))
        {
            $boxes[$newDisplayed]->refreshInfo($item, 1);
            $forceSelect = 1;
            $wantSelect = 1 if $wantSelect ne '';
        }
        else
        {
            # Popup is refreshed by previous call.
            # So we just need to explicitely do it here
            if ($boxes[$newDisplayed])
            {
                $boxes[$newDisplayed]->setInfo($item);
                $boxes[$newDisplayed]->refreshPopup;
            }
        }
        if ($self->{filter})
        {
            # Test visibility
            my $previouslyVisible = $self->{filter}->test($previous);
            my $visible = $self->{filter}->test($new);
            if ($previouslyVisible && ! $visible)
            {
                $self->{displayedNumber}--;
                $self->restorePrevious if $wantSelect;
                my $itemLine = int $newDisplayed / $self->{columns};
                
                $self->{rowContainers}->[$itemLine]->remove(
                                                            $self->{cache}->[$idx]->{imageBox}
                                                            );
                my $info = $self->{boxes}->[$newDisplayed]->{info};
                splice @{$self->{boxes}}, $newDisplayed, 1;
                $self->shiftItems($newDisplayed, -1, 0, scalar @{$self->{boxes}});
                $self->initConversionTables;
                $info->{displayed} = $visible;
                $idx = $self->getFirstVisibleIdx($newDisplayed);
                $wantSelect = 0 if ! scalar @{$self->{boxes}}
            }
        }
        $self->select($idx, $forceSelect) if $wantSelect;
        return $idx;
    }

    sub showSearch
    {
        my ($self, $char) = @_;
        $self->{searchEntry}->set_text($char);
        $self->{searchEntry}->show_all;
        $self->activateSearch;
        $self->{container}->{searchTimeOut} = Glib::Timeout->add(4000, sub {
            $self->hideSearch;
            $self->{searchTimeOut} = 0;
            return 0;
        });
    }

    sub activateSearch
    {
        my ($self) = @_;
        $self->{searchEntry}->grab_focus;
        $self->{searchEntry}->select_region(length($self->{searchEntry}->get_text), -1);
    }

    sub hideSearch
    {
        my $self = shift;        
        $self->{searchEntry}->set_text('');
        $self->{searchEntry}->hide;
        $self->grab_focus;
        $self->{previousSearch} = '';
    }

    sub internalSearch
    {
        my $self = shift;
        
        my $query = $self->{searchEntry}->get_text;
        return if !$query;
        my $newDisplayed = -1;

        my $current = 0;
        my $length = length($query);
        if ($self->{currentOrder})
        {
            if (($length > 1) && ($length > length($self->{previousSearch})))
            {
                $current = $self->{idxToDisplayed}->{$self->{itemsArray}->[$self->{current}]->{idx}};            
            }
            foreach(@{$self->{itemsArray}}[$current..$self->{count} - 1])
            {
                next if !$_->{displayed};
                if ($_->{title} ge $query)
                {
                    $newDisplayed = $self->{idxToDisplayed}->{$_->{idx}};
                    last;
                }
            }
        }
        else
        {
            foreach(@{$self->{itemsArray}}[$current..$self->{count} - 1])
            {
                next if !$_->{displayed};
                if (($_->{title} =~ m/^\Q$query\E/i) || ($_->{title} lt $query))
                {
                    $newDisplayed = $self->{idxToDisplayed}->{$_->{idx}};
                    last;
                }
            }
        }

        if ($newDisplayed != -1)
        {
            my $valueIdx = $self->{displayedToIdx}->{$newDisplayed};
            $self->select($valueIdx);
            $self->{parent}->display($valueIdx);
            $self->{boxes}->[$newDisplayed]->grab_focus;
            $self->showCurrent;
            $self->activateSearch;
        }
        $self->{previousSearch} = $query;
    }

}

{
    package GCImageList;
    
    use base "Gtk2::VBox";
    use File::Temp qw/ tempfile /;

    my $defaultGroup = 'GCMAINDEFAULTGROUP';

    sub new
    {
        my ($proto, $parent, $columns) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new(0,0);
        bless ($self, $class);

        $self->{preferences} = $parent->{model}->{preferences};
        $self->{parent} = $parent;
        $self->{columns} = $columns;

        $self->{borrowerField} = $parent->{model}->{commonFields}->{borrower}->{name};

        $self->{scroll} = new Gtk2::ScrolledWindow;
        $self->{scroll}->set_policy ('automatic', 'automatic');
        $self->{scroll}->set_shadow_type('none');

        $self->{searchEntry} = new Gtk2::Entry;
        #$self->{list} = new GCBaseImageList($self, $columns);
        
        $self->{orderSet} = 0;
        $self->{sortButton} = Gtk2::Button->new;
        $self->setSortButton($self->{preferences}->sortOrder);
        $self->{searchEntry}->signal_connect('changed' => sub {
            return if ! $self->{searchEntry}->get_text;
            $self->internalSearch;
        });
        $self->{searchEntry}->signal_connect('key-press-event' => sub {
            my ($widget, $event) = @_;
            Glib::Source->remove($self->{searchTimeOut})
                if $self->{searchTimeOut};
            return if ! $self->{searchEntry}->get_text;
            my $key = Gtk2::Gdk->keyval_name($event->keyval);
            if ($key eq 'Escape')
            {
                $self->hideSearch;
                return 1;
            }
            $self->{searchTimeOut} = Glib::Timeout->add(4000, sub {
                $self->hideSearch;
                $self->{searchTimeOut} = 0;
                return 0;
            });

            return 0;
        });

        #$self->{scroll}->add_with_viewport($self->{list});
        $self->{mainList} = new Gtk2::VBox(0,0);
        $self->{scroll}->add_with_viewport($self->{mainList});
        #$self->{list}->initPixmaps;

        $self->pack_start($self->{sortButton},0,0,0);
        $self->pack_start($self->{scroll},1,1,0);
        $self->pack_start($self->{searchEntry},0,0,0);

        $self->{sortButton}->signal_connect('clicked' => sub {
            $self->setSortOrder(-1);
            $self->setSortButton;
        });
        
        $self->initStyle;
        $self->setGroupingInformation;
        $self->{empty} = 1;
        $self->{orderedLists} = [];
        $self->{displayed} = {};
        return $self;
    }
    
    sub setSortButton
    {
        my ($self, $order) = @_;
        $order = $self->{currentOrder}
            if !defined $order;
        my $image = Gtk2::Image->new_from_stock($order
                                                  ? 'gtk-sort-descending'
                                                  : 'gtk-sort-ascending',
                                                'button');
        my $stockItem = Gtk2::Stock->lookup($order
                                                  ? 'gtk-sort-ascending'
                                                  : 'gtk-sort-descending');
        $stockItem->{label} =~ s/_//g;
        $self->{sortButton}->set_label($stockItem->{label});
        $self->{sortButton}->set_image($image);
        
    }
    
    sub show_all
    {
        my $self = shift;
        $self->SUPER::show_all;
        $self->{mainList}->show_all;
        $self->{searchEntry}->hide;
    }

    sub done
    {
        my $self = shift;
        foreach (values %{$self->{lists}})
        {
            $_->done;
#            $self->{style}->{vboxWidth} = $_->{style}->{vboxWidth}
#                if !exists $self->{style}->{vboxWidth};
        }
        # We set a number of ms to wait before enhancing the pictures
        my $offset = 0;
        foreach (@{$self->{orderedLists}})
        {
            $self->{lists}->{$_}->{offset} = $offset;
            $offset += $timeOutBetweenEnhancements * ($self->{lists}->{$_}->{displayedNumber} + 1);
        }
        if ($self->{columns} == 0)
        {
            $self->signal_connect('size-allocate' => sub {
                $self->computeAllocation;
            });
            $self->computeAllocation;
        }
        else
        {
            foreach (values %{$self->{lists}})
            {
                $_->setColumnsNumber($self->{columns}, 0);
            }
        }
    }

    sub computeAllocation
    {
        my $self = shift;
        return if !$self->{style}->{vboxWidth};
        my $width = $self->{scroll}->child->allocation->width - 15;
        return if $width < 0;
        if (($self->{scroll}->get_hscrollbar->visible)
         || ($width > (($self->{columns} + 1) * $self->{style}->{vboxWidth})))
        {
            my $columns = int ($width / $self->{style}->{vboxWidth});
            if ($columns)
            {
                return if $columns == $self->{columns};
                $self->{columns} = $columns;
                foreach (values %{$self->{lists}})
                {
                    $_->setColumnsNumber($columns, 1);
                }
                # TODO : We should maybe select an item here
                #$self->{parent}->display($self->select(-1, 1))
                #    if !$self->{current};
            }
            else
            {
                $self->{columns} = 1;
            }
        }
        
    }

    sub initStyle
    {
        my $self = shift;
        my $parent = $self->{parent};

        my $size = $self->{preferences}->listImgSize;
        $self->{style}->{withAnimation} = $self->{preferences}->animateImgList;
        $self->{style}->{withImage} = $self->{preferences}->listBgPicture;
        $self->{style}->{useOverlays} = ($self->{preferences}->useOverlays) && ($parent->{model}->{collection}->{options}->{overlay}->{image});        
        $self->{preferences}->listImgSkin($GCStyle::defaultList) if ! $self->{preferences}->exists('listImgSkin');
        $self->{style}->{skin} = $self->{preferences}->listImgSkin;
        # Reflect setting can be enabled using "withReflect=1" in the listbg style file
        $self->{style}->{withReflect} = 0;
        $self->{preferences}->listImgSize(2) if ! $self->{preferences}->exists('listImgSize');
        
        my $bgdir;
        # Load in extra settings from the style file
        if ($self->{style}->{withImage})
        {
            $bgdir = $ENV{GCS_SHARE_DIR}.'/list_bg/'.$self->{style}->{skin};
            if (open STYLE, $bgdir.'/style')
            {
                while (<STYLE>)
                {
                    chomp;
                    next if !$_;
                    m/^(.*?)\s*=\s*(.*)$/;
                    my $item = $1;
                    (my $value = $2) =~ s/^"(.*?)"$/$1/;
                    $self->{style}->{$item} = $value;
                }                
                close STYLE;
            }
        }
        
        # Sets image width/height (for size = 2), getting value from the collection model or setting to
        # default values of 120, 160 if not specified in model file
        $self->{style}->{imgWidth} = (exists $parent->{model}->{collection}->{options}->{defaults}->{listImageWidth})
                          ? $parent->{model}->{collection}->{options}->{defaults}->{listImageWidth}
                          : 120;
        $self->{style}->{imgHeight} = (exists $parent->{model}->{collection}->{options}->{defaults}->{listImageHeight})
                           ? $parent->{model}->{collection}->{options}->{defaults}->{listImageHeight}
                           : 160;

        $self->{style}->{factor} = ($size == 0) ? 0.5
                        : ($size == 1) ? 0.8
                        : ($size == 3) ? 1.5
                        : ($size == 4) ? 2
                        :                        1;                        
        $self->{style}->{imgWidth} *= $self->{style}->{factor};
        $self->{style}->{imgHeight} *= $self->{style}->{factor};
        $self->{style}->{offsetX} = 11;
        if ($self->{style}->{withImage})
        {
            if (! $self->{style}->{useOverlays})
            {
                $self->{style}->{offsetX} = 26;
            }
        }
        else
        {
            $self->{style}->{offsetX} = 22;
        }
        
         $self->{style}->{vboxWidth} = $self->{style}->{imgWidth} + ($self->{style}->{offsetX} * $self->{style}->{factor});
        
        $self->{style}->{vboxHeight} = $self->{style}->{imgHeight} + (10 * $self->{style}->{factor});
        $self->{style}->{vboxHeight} += (20 * $self->{style}->{factor}) if $self->{style}->{withImage};
        $self->{style}->{vboxHeight} += (30 * $self->{style}->{factor}) if $self->{style}->{withReflect};
        $self->{style}->{pageCount} = int 5 / $self->{style}->{factor};

        # Pixbuf for lending icon
        my $lendImageFile = $ENV{GCS_SHARE_DIR}.'/overlays/lend_';
        $lendImageFile .= ($size < 1) ? 'verysmall'
                        : ($size < 2) ? 'small'
                        : ($size < 3) ? 'med'
                        : ($size < 4) ? 'large'
                        :                       'xlarge';  
        $self->{style}->{lendPixbuf} = Gtk2::Gdk::Pixbuf->new_from_file($lendImageFile.'.png');

        # Pixbuf for favourite icon
        my $favImageFile = $ENV{GCS_SHARE_DIR}.'/overlays/favourite_';
        $favImageFile .= ($size < 1) ? 'verysmall'
                       : ($size < 2) ? 'small'
                       : ($size < 3) ? 'med'
                       : ($size < 4) ? 'large'
                       :                       'xlarge';  
        $self->{style}->{favPixbuf} = Gtk2::Gdk::Pixbuf->new_from_file($favImageFile.'.png');

        if ($self->{style}->{useOverlays})
        {
            $self->{style}->{overlayImage} = $ENV{GCS_SHARE_DIR}.'/overlays/'.$parent->{model}->{collection}->{options}->{overlay}->{image};
            $self->{style}->{overlayPixbuf} = Gtk2::Gdk::Pixbuf->new_from_file($self->{style}->{overlayImage});

            $self->{style}->{overlayPaddingLeft} = $parent->{model}->{collection}->{options}->{overlay}->{paddingLeft};
            $self->{style}->{overlayPaddingRight} = $parent->{model}->{collection}->{options}->{overlay}->{paddingRight};
            $self->{style}->{overlayPaddingTop} = $parent->{model}->{collection}->{options}->{overlay}->{paddingTop};
            $self->{style}->{overlayPaddingBottom} = $parent->{model}->{collection}->{options}->{overlay}->{paddingBottom}; 
        }

        # Default value for align
        $self->{style}->{groupAlign} = 'center';

        if ($self->{style}->{withImage})
        {
            $self->{style}->{bgPixmap} = $bgdir.'/list_bg.png';

            my $tmpPixbuf = Gtk2::Gdk::Pixbuf->new_from_file($self->{style}->{bgPixmap});
            $tmpPixbuf = GCUtils::scaleMaxPixbuf($tmpPixbuf,
                                                 $self->{style}->{vboxWidth},
                                                 $self->{style}->{vboxHeight},
                                                 1);
            (my $fh, $self->{style}->{tmpBgPixmapFile}) = tempfile(UNLINK => 1);
            close $fh;
            if ($^O =~ /win32/i)
            {
                # It looks like Win32 version only supports JPEG pictures for background
                $tmpPixbuf->save($self->{style}->{tmpBgPixmap}, 'jpeg', quality => '100');
            }
            else
            {
                $tmpPixbuf->save($self->{style}->{tmpBgPixmapFile}, 'png');
            }
            
            #($self->{style}->{tmpBgPixmap}, $self->{style}->{tmpBgMask}) = $tmpPixbuf->render_pixmap_and_mask(255);
            
            GCUtils::setWidgetPixmap($self->{mainList}->parent, $self->{style}->{tmpBgPixmapFile});
            
            $self->{style}->{backgroundPixbuf} = Gtk2::Gdk::Pixbuf->new_from_file($self->{style}->{bgPixmap});
            $self->{style}->{backgroundPixbuf} = GCUtils::scaleMaxPixbuf($self->{style}->{backgroundPixbuf},
                                                                $self->{style}->{vboxWidth},
                                                                $self->{style}->{vboxHeight},
                                                                1);
            my @colors = split m/,/, $self->{preferences}->listFgColor;
            ($colors[0], $colors[1], $colors[2]) = (65535, 65535, 65535) if !@colors;
            my $red   = int($colors[0] / 257);
            my $green = int($colors[1] / 257);
            my $blue   = int($colors[2] / 257);
            $self->{style}->{activeBgValue} = ($red << 16) + ($green << 8) + $blue;

            if ($self->{style}->{withReflect}) 
            {
                $self->{style}->{foregroundPixbuf} = Gtk2::Gdk::Pixbuf->new_from_file($bgdir.'/list_fg.png');
                $self->{style}->{foregroundPixbuf} = GCUtils::scaleMaxPixbuf($self->{style}->{foregroundPixbuf},
                                                                    $self->{style}->{vboxWidth},
                                                                    $self->{style}->{vboxHeight},
                                                                    1);
            }
            
            $self->{groupBgFile} = $bgdir.'/group.png';
        }
        else
        {
            my @colors = split m/,/, $self->{preferences}->listBgColor;
            ($colors[0], $colors[1], $colors[2]) = (65535, 65535, 65535) if !@colors;
            $self->{style}->{inactiveBg} = new Gtk2::Gdk::Color($colors[0], $colors[1], $colors[2]);
            @colors = split m/,/, $self->{preferences}->listFgColor;
            ($colors[0], $colors[1], $colors[2]) = (0, 0, 0) if !@colors;
            $self->{style}->{activeBg} = new Gtk2::Gdk::Color($colors[0], $colors[1], $colors[2]);
            $self->{mainList}->parent->modify_bg('normal', $self->{style}->{inactiveBg});
            $self->{mainList}->parent->modify_bg('active', $self->{style}->{inactiveBg});
            $self->{mainList}->parent->modify_bg('prelight', $self->{style}->{inactiveBg});
            $self->{mainList}->parent->modify_bg('selected', $self->{style}->{inactiveBg});
            $self->{mainList}->parent->modify_bg('insensitive', $self->{style}->{inactiveBg});
        }
    }

    sub initListStyle
    {
        my ($self, $list) = @_;
        $list->{style} = $self->{style};
        if ($self->{style}->{withImage})
        {
            GCUtils::setWidgetPixmap($list->parent, $self->{style}->{tmpBgPixmapFile});
        }
        else
        {
            $self->set_border_width(5);
            $list->parent->modify_bg('normal', $self->{style}->{inactiveBg});
            $list->parent->modify_bg('active', $self->{style}->{inactiveBg});
            $list->parent->modify_bg('prelight', $self->{style}->{inactiveBg});
            $list->parent->modify_bg('selected', $self->{style}->{inactiveBg});
            $list->parent->modify_bg('insensitive', $self->{style}->{inactiveBg});
        }
    }

    sub setCurrentList
    {
        my ($self, $list) = @_;
        $self->{currentList} = $list;
    }

    sub setGroupingInformation
    {
        my $self = shift;

        $self->{collectionField} = $self->{preferences}->groupBy;
        $self->{groupItems} = ($self->{collectionField} ne '');
        if (!$self->{groupItems})
        {
            $self->addGroup($defaultGroup, uc $defaultGroup, 1)
                if !$self->{currentList};
        }
    }

    sub getGroups
    {
        my ($self, $info) = @_;

        my $field = $self->{collectionField};
        my $value = $info->{$field};
        my $type = '';
        $type = $self->{parent}->{model}->{fieldsInfo}->{$field}->{type}
            if defined $self->{parent}->{model}->{fieldsInfo}->{$field}->{type};
        
        $value = $self->{parent}->transformValue($value, $field, 1);

        if (ref($value) eq 'ARRAY')
        {
            if (!scalar (@$value))
            {
                $value = [$defaultGroup];
            }
        }
        else
        {
            $value = $defaultGroup
                if ($type =~ /text$/) && ($value eq '');
            my @array = ($value);
            $value = \@array;
        }
        
        
        return $value;
    }

    sub sortAndFind
    {
        my ($self, $group) = @_;

        # We insert it in the list
        my @tmpList = @{$self->{orderedLists}};
        #push @tmpList, $group;
        # We sort it
        if ($self->{currentOrder} == 0)
        {
            @tmpList = reverse sort {GCUtils::gccmpe($a, $b)} @tmpList;
        }
        else
        {
            @tmpList = sort {GCUtils::gccmpe($a, $b)} @tmpList;
        }
        
        # And now we find back its position
        $self->{orderedLists} = \@tmpList;
        return GCUtils::inArray($group, @tmpList);
    }

    sub getNbItems
    {
        my $self = shift;
        
        # We count the number of items in displayed hash where value is 1
        return scalar grep {$_ == 1} values %{$self->{displayed}};
    }

    sub createHeader
    {
        my ($self, $title) = @_;
        my $label;
        my $fixedTitle = $title;
        $fixedTitle =~ s/&/&amp;/;
        $fixedTitle =~ s/</&lt;/;
        $fixedTitle =~ s/>/&gt;/;        
        
        if ($self->{style}->{withImage})
        {
            $label = new GCColorLabel(Gtk2::Gdk::Color->parse('#000000'));
            $label->set_markup('<span '.$self->{style}->{groupStyle}.">$fixedTitle</span>");
            GCUtils::setWidgetPixmap($label, $self->{groupBgFile});
        }
        else
        {
            $label = new GCColorLabel($self->{style}->{activeBg});
            $label->set_markup('<span weight="bold" color="'.$self->{style}->{inactiveBg}->to_string."\">$fixedTitle</span>");
        }
        $label->set_justify($self->{style}->{groupAlign});
        $label->set_padding($GCUtils::halfMargin, $GCUtils::halfMargin);
        return $label;
        return new Gtk2::Label($title);
    }

    sub addGroup
    {
        my ($self, $group, $refGroup, $immediate) = @_;
        
        my $listBox = new Gtk2::VBox(0,0);
        my $list = new GCBaseImageList($self, $self->{columns});
        if ($self->{groupItems})
        {
            my $label;
            if ($refGroup eq $defaultGroup)
            {
                $label = $self->createHeader('');
            }
            else
            {
                $label = $self->createHeader($group);
            }
            $listBox->pack_start($label, 0, 0, 0);
            $list->setHeader($label);
            $list->{refGroup} = $refGroup;
            $label->show_all;
        }
        my $eventBox = new Gtk2::EventBox;
        $eventBox->add($list);
        $listBox->pack_start($eventBox, 0, 0, 0);
        $self->{mainList}->pack_start($listBox, 0, 0, 0);

        push @{$self->{orderedLists}}, $refGroup
            if ($refGroup ne $defaultGroup);
            
        if ($immediate && $self->{groupItems})
        {
            my $place = $self->sortAndFind($refGroup);
            $self->{mainList}->reorder_child($listBox, $place);
        }
            
        $listBox->show_all;
        $self->initListStyle($list);
        $self->{lists}->{$refGroup} = $list;
        $self->{listBoxes}->{$refGroup} = $listBox;
        $self->{currentList} = $list if ! $self->{currentList};
        $list->done(undef, 1) if $immediate;
        return $list;
    }

    sub addItem
    {
        my ($self, $info, $immediate) = @_;
        my $groups = [];
        if ($self->{groupItems})
        {
            $groups = $self->getGroups($info);
        }
        else
        {
            $groups = [$defaultGroup];
        }
        foreach my $group(@$groups)
        {
            my $refGroup = uc($group);
            if (! exists $self->{lists}->{$refGroup})
            {
                $self->addGroup($group, $refGroup, $immediate);
            }
            $self->{currentList} = $self->{lists}->{$refGroup} if $immediate;
            $self->{lists}->{$refGroup}->addItem($info, $immediate, $self->{count}, 0);
            # Storing conversion from index to the actual list
            $self->{idxToList}->{$self->{count}} = $self->{lists}->{$refGroup};
        }
        # Default is to display it. It will maybe be filtered later
        $self->{displayed}->{$self->{count}} = 1;
        $self->{count}++;
    }

    sub couldExpandAll
    {
        my $self = shift;
        
        return $self->{groupItems};
    }

    sub showCurrent
    {
        my $self = shift;
        # TODO:
        $self->{currentList}->showCurrent
            if $self->{currentList};
    }

    sub clearSelected
    {
        my ($self, $current) = @_;
        foreach (values %{$self->{lists}})
        {
            next if $_ == $current;
            $_->restorePrevious(1);
        }
        
    }

    sub reset
    {
        my $self = shift;
        foreach (values %{$self->{lists}})
        {
            $_->reset;
        }
        $self->{count} = 0;
        $self->{idxToList} = {};
    }

    sub clearCache
    {
        my ($self) = @_;
        foreach (values %{$self->{lists}})
        {
            $_->clearCache;
        }
        #$self->{vboxWidth} = 1;
    }

    sub setSortOrder
    {
        my ($self, $order) = @_;
        $self->{orderSet} = 1;

        if ($self->{groupItems})
        {
            my $first = 1;
            foreach (values %{$self->{lists}})
            {
                $_->setSortOrder($order);
                # We get it computed by the first internal list
                $self->{currentOrder} = $_->{currentOrder}
                    if $first;
                $first = 0;
            }
            # Now the internal lists are ordered, we need to order them
            my @tmpList = @{$self->{orderedLists}};

            # We sort the list, using gccmpe to handle sorting of numeric values and dates
            if ($self->{currentOrder} == 0)
            {
                @tmpList = reverse sort {GCUtils::gccmpe($a, $b)} @{$self->{orderedLists}};
            }
            else
            {
                @tmpList = sort {GCUtils::gccmpe($a, $b)} @{$self->{orderedLists}};
            }
            
            # Clear the current view
            my @children = $self->{mainList}->get_children;
            foreach my $child(@children)
            {
                $self->{mainList}->remove($child);
            }
            # And fill it again with the current order
            foreach my $refGroup(@tmpList, $defaultGroup)
            {
                next if !$self->{listBoxes}->{$refGroup};
                $self->{mainList}->pack_start($self->{listBoxes}->{$refGroup}, 0, 0, 0);
                $self->{listBoxes}->{$refGroup}->show_all;
            }
    
            # Save the new order
            $self->{orderedLists} = \@tmpList;
        }
        else
        {
            $self->{currentList}->setSortOrder($order);
            $self->{currentList}->show_all;
            # We get it computed by the first internal list
            $self->{currentOrder} = $self->{currentList}->{currentOrder};
        }
    }

    sub setFilter
    {
        my ($self, $filter, $items, $refresh, $splash) = @_;
        shift;
        my $current;
        my $result = -1;
        my $list;
        $self->{displayed} = {};
        foreach (keys %{$self->{lists}})
        {
            $list = $self->{lists}->{$_};
            $current = $list->setFilter(@_);
            $result = $current if $list == $self->{currentList};
            if ($list->{displayedNumber})
            {
                $self->{listBoxes}->{$_}->show_all;
            }
            else
            {
                $self->{listBoxes}->{$_}->hide;
            }
        }
        $result = -1 if !defined $result;
        return $result;
    }        

    sub setDisplayed
    {
        my ($self, $idx, $displayed) = @_;
        $self->{displayed}->{$idx} = $displayed;
    }

    sub select
    {
        my ($self, $idx, $init, $keepPrevious) = @_;
        my $list;
        if ($self->{groupItems})
        {
            if (($idx == -1) || (!defined $idx))
            {
                if (defined $self->{orderedLists}->[0])
                {
                    $list = $self->{lists}->{$self->{orderedLists}->[0]};
                }
                else
                {
                    $list = $self->{lists}->{$defaultGroup};
                }
            }
            else
            {
                $list = $self->{idxToList}->{$idx};
            }
        }
        else
        {
            $list = $self->{currentList};
        }
        $list->select($idx, $init, $keepPrevious)
            if $list;
    }

    sub savePreferences
    {
        my ($self, $preferences) = @_;
        return if !$self->{orderSet};
        $preferences->sortField($self->{titleField});
        $preferences->sortOrder($self->{currentOrder});
    }

    sub getCurrentIdx
    {
        my $self = shift;
        return 0 if !$self->{currentList};
        return $self->{currentList}->getCurrentIdx;
    }

    sub removeCurrentItems
    {
        my $self = shift;
        # TODO : This doesn't work if there are items selected in many lists

        my @indexes = sort @{$self->getCurrentItems};
        my $selected;
        my @listWhereAlreadyRemoved;
        # Find other lists where they were
        foreach my $list(values %{$self->{lists}})
        {
            next if $list == $self->{currentList};
            foreach my $idx(@indexes)
            {
                my $nbRemoved = 0;
                if (exists $list->{idxToDisplayed}->{$idx - $nbRemoved})
                {
                    $list->removeItem($idx - $nbRemoved);
                    push @listWhereAlreadyRemoved,  0 + $list;
                    $nbRemoved++;
                }
                #splice @{$list->{cache}}, $idx - $nbRemoved, 1;
                delete $self->{displayed}->{$idx};
            }
        }
        # Adjust the total number of items according to what we removed
        $self->{count} -= scalar @indexes;

        $selected = $self->{currentList}->removeCurrentItems;
        push @listWhereAlreadyRemoved, $self->{currentList};

        # Now we have to adjust all of the indexes in other lists
        foreach my $list(values %{$self->{lists}})
        {
            # We don't perform the switch if we already removed the item
            my $found = 0;
            foreach my $listRm(@listWhereAlreadyRemoved)
            {
                if ($listRm == $list)
                {
                    # Found a list where we removed it
                    $found = 1;
                    last;
                }
            }
            next if $found;
            $list->shiftIndexes(\@indexes);
            $list->initConversionTables;
        }
        
        # If we removed all the items in the current group, we are looking for the 1st one
        # of the next group (fallback on previous if last one)
        if (!defined $selected)
        {
            my $nextList;
            foreach my $i(0 .. $#{$self->{orderedLists}})
            {
                if ($self->{orderedLists}->[$i] eq $self->{currentList}->{refGroup})
                {
                    if ($i < $#{$self->{orderedLists}})
                    {
                        $nextList = $self->{orderedLists}->[$i+1];
                        last;
                    }
                    else
                    {
                        $nextList = $self->{orderedLists}->[$i-1]
                            if $i > 0;
                        last;
                    }
                }
            }
            if ($nextList)
            {
                my $currentList = $self->{lists}->{$nextList};
                $selected = $currentList->{displayedToIdx}->{0};
                $currentList->select($selected);
                $self->{currentList} = $currentList;
            }
        }
        return $selected;
    }

    sub getCurrentItems
    {
        my $self = shift;
        # TODO : This doesn't work if there are items selected in many lists
        return $self->{currentList}->getCurrentItems;
    }

    sub changeCurrent
    {
        my ($self, $previous, $new, $idx, $wantSelect) = @_;
        if ($self->{groupItems})
        {
            # Will be set to a true value if the 1st added item should be selected
            my $shouldBeSelected = 0;
            # Get the list where it was
            my @prevGroups = sort @{$self->getGroups($previous)};
            
            # And the one where it should be
            my @newGroups = sort @{$self->getGroups($new)};

            my ($found, $place);
            # First look for previous ones
            foreach my $pg(@prevGroups)
            {
                my $pg = uc $pg;
                ($found, $place) = (0, 0);
                # Try to find it in the new groups
                foreach my $ng (@newGroups)
                {
                    my $refGroup = uc($ng);
                    $found = 1 if $refGroup eq $pg;
                    # As it is sorted, we can stop when we find a greater one
                    last if $refGroup ge $pg;
                    $place++;
                }
                # If found, we just change it
                if ($found)
                {
                    $self->{lists}->{$pg}->changeCurrent($previous, $new, $idx, $wantSelect);
                    # And we remove it from the list
                    splice @newGroups, $place, 1;
                }
                # Otherwise, it means it was removed from this group
                else
                {
                    $shouldBeSelected = 1
                        if $self->{lists}->{$pg}->isSelected($idx);
                    $self->{lists}->{$pg}->removeItem($idx,1);
                }
            }
            # Now we should have a list whith just the new groups
            foreach my $ng(@newGroups)
            {
                my $refGroup = uc $ng;
                # We should create the list if it doesn't exist
                if (! exists $self->{lists}->{$refGroup})
                {
                    my $list = $self->addGroup($ng, $refGroup, 1);
                }
                
                # 2nd parameter means it should be added immediately
                # 4th one is that we should not change the conversion tables because it's not
                # a new item
                $self->{lists}->{$refGroup}->addItem($new, 1, $idx, 1);
                if ($shouldBeSelected)
                {
                    $self->{lists}->{$refGroup}->select($idx, 0, 1);
                    $shouldBeSelected = 0;
                }
            }
            # TODO It should return something else if filtered
            return $idx;
        }
        else
        {
            return $self->{currentList}->changeCurrent($previous, $new, $idx, $wantSelect);
        }
    }

    sub AUTOLOAD
    {
        return if our $AUTOLOAD =~ /::DESTROY$/;
        (my $name = $AUTOLOAD) =~ s/.*?::(.*)/$1/;
        my $self = shift;
        #GCUtils::printStack(6);
        #print "CALLING $name\n";
        return $self->{currentList}->$name(@_);
    }
}

1;
