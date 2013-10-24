package GCTextLists;

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

#
# This file handle the left list part, in text Mode and Detailed Mode
#

use strict;
use locale;        

{
    package GCBaseTextList;
    use base "Gtk2::ScrolledWindow";
    use GCUtils;

    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new;
        bless ($self, $class);
        $self->{parent} = $parent;
        $self->{preferences} = $parent->{model}->{preferences};
        $self->{preferences}->sortOrder(1)
            if ! $self->{preferences}->exists('sortOrder');
        $self->{count} = 0;
        return $self;
    }

    sub getNbItems
    {
        my $self = shift;
        return $self->{count};
    }

    sub convertIterToChildIter
    {
        my ($self, $iter) = @_;
        my $result = $self->{completeModel}->convert_iter_to_child_iter($iter);
        $result = $self->{subModel}->convert_iter_to_child_iter($result);
        return $result;
    }

    sub convertChildIterToIter
    {
        my ($self, $iter) = @_;
        my $result = $iter;
        $result = $self->{subModel}->convert_child_iter_to_iter($result);
        $result = $self->{completeModel}->convert_child_iter_to_iter($result);
        return $result;
    }

    sub convertIterToString
    {
        my ($self, $iter) = @_;
        return '' if ! $iter;

        return $self->{completeModel}->get_string_from_iter($iter);
    }
    
    sub convertIdxToIter
    {
        my ($self, $idx) = @_;
        $self->{completeModel}->foreach(sub {
            my ($model, $path, $iter) = @_;
            if (($self->convertIterToIdx($iter) == $idx)
             && (!$model->iter_n_children($iter)))
            {
                $self->{currentIterString} = $model->get_path($iter)->to_string;
                return 1;
            }
            return 0;
        });
    }

    sub selectAll
    {
        my $self = shift;

        $self->{list}->get_selection->select_all;
    }

    sub selectIter
    {
        my ($self, $iter, $deactivateUpdate) = @_;
        $self->{deactivateUpdate} = $deactivateUpdate;
        $self->{list}->get_selection->unselect_all;
        $self->{list}->get_selection->select_iter($iter);
        $self->{deactivateUpdate} = 0;
    }
    
    sub getCurrentIter
    {
        my $self = shift;
        my $iter = undef;
        #my $iter = $self->{list}->get_selection->get_selected;
        my @rows = $self->{list}->get_selection->get_selected_rows;
        $iter = $self->{list}->get_model->get_iter($rows[0]) if $rows[0];
        return $iter;
    }

    sub getCurrentItems
    {
        my $self = shift;
        my @indexes;
        my @iterators;
        my @rows = $self->{list}->get_selection->get_selected_rows;
        foreach (@rows)
        {
            my $iter = $self->{list}->get_model->get_iter($_);
            push @iterators, $iter;
            push @indexes, $self->convertIterToIdx($iter);
        }
        @indexes = sort @indexes;
        return (\@indexes, \@iterators) if wantarray;
        return \@indexes;
    }

    sub getCurrentIterFromString
    {
        my $self = shift;
        return ($self->{currentIterString})
              ? $self->{completeModel}->get_iter_from_string($self->{currentIterString})
              : $self->{completeModel}->get_iter_first;
    }

    sub removeCurrentItems
    {
        my ($self) = @_;
        my ($indexes, $iterators) = $self->getCurrentItems;

        $self->{deactivateSortCache} = 1;
        
        my ($nextIter, $newIdx) = $self->getNextIter($iterators->[-1], $indexes);
        my $realIter = $self->convertIterToChildIter($nextIter);
        my $nextPath = $self->{model}->get_path($realIter)->to_string;

        my $count = scalar @$indexes;

        $self->{count} -= $count;
        $self->{nextItemIdx} -= $count;
        
        $self->{list}->expand_to_path($self->{completeModel}->get_path($nextIter))
            if $self->{currentIterString} =~ /:/;
        $self->selectIter($nextIter)
            if ($nextIter);

        my @toBeRemoved;
        my %pathToChange;
        foreach my $number(@$indexes)
        {
            #Shift backward all following items.
            $self->{model}->foreach(sub {
                my ($model, $path, $iter) = @_;
                return 0 if $model->iter_has_child($iter);
                my $currentIdx = ($model->get($iter))[$self->{idxColumn}];
                if ($currentIdx > $number)
                {
                    $pathToChange{$path->to_string}++;
                }
                elsif ($currentIdx == $number)
                {
                    # We store them for future removal
                    push @toBeRemoved, new Gtk2::TreeRowReference($model, $path);
                }
                return 0;
            });
        }

        # Perform the actual shift
        my $offset = 0;
        foreach my $path(keys %pathToChange)
        {
            my $iter = $self->{model}->get_iter(Gtk2::TreePath->new($path));
            my $currentIdx = ($self->{model}->get($iter))[$self->{idxColumn}];
            $self->{model}->set($iter, $self->{idxColumn}, ($currentIdx - $pathToChange{$path}));
            if ($nextPath eq $path)
            {
                $newIdx = $currentIdx - $pathToChange{$path};
            }
            $offset++;
        }
        
        # Update caches
        $self->{sorter}->clear_cache;
        $self->{testCache} = [];

        # Removing all the instances
        foreach(@toBeRemoved)
        {
            $self->removeFromModel($self->{model}->get_iter($_->get_path));
        }

        $self->{deactivateSortCache} = 0;

        return $newIdx;
    }

    sub changeItem
    {
        # Apply the changes from $previous to $new to the listView entry $idx
        # Return the $idx of the new current item ($previous can now be hidden)
        my ($self, $idx, $previous, $new) = @_;
        $self->convertIdxToIter($idx);
        return $self->changeCurrent($previous, $new, $idx, 0);
    }
    
    sub updateMenus
    {    
        # Update menu items to reflect number of items selected
        my ($self, $nbSelected) = @_;
        
        my $menu = $self->{parent}->{menubar};
        my @updateList;
        if ($nbSelected > 1)
        {
            @updateList = (
                [$menu, 'duplicateItem', 'MenuDuplicatePlural'],
                [$menu, 'deleteCurrentItem', 'MenuEditDeleteCurrentPlural'],
                [$self->{parent}, 'contextDuplicateItem', 'MenuDuplicatePlural'],
                [$self->{parent}, 'contextItemDelete', 'MenuEditDeleteCurrentPlural'],
                [$self->{parent}, 'contextNewWindow', 'MenuNewWindowPlural'],
            );
        }
        else
        {
            @updateList = (
                [$menu, 'duplicateItem', 'MenuDuplicate'],
                [$menu, 'deleteCurrentItem', 'MenuEditDeleteCurrent'],
                [$self->{parent}, 'contextDuplicateItem', 'MenuDuplicate'],
                [$self->{parent}, 'contextItemDelete', 'MenuEditDeleteCurrent'],
                [$self->{parent}, 'contextNewWindow', 'MenuNewWindow'],
            );
        }
        foreach (@updateList)
	{
	    $menu->updateItem($_->[0]->{$_->[1]}, $_->[2]);
	}
    }
    
}

{
    package GCTextList;

    use Gtk2::SimpleList;
    use GCUtils;
    use base 'GCBaseTextList';

    sub new
    {
        my ($proto, $parent, $title) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent);
        bless ($self, $class);

        $self->{titleField} = $parent->{model}->{commonFields}->{title};
        $self->{idxColumn} = 1;
        $self->{orderSet} = 0;
        
        $self->set_policy ('automatic', 'automatic');
        $self->set_shadow_type('none');
        
        my $columnType = ($parent->{model}->{fieldsInfo}->{$self->{titleField}}->{type} eq 'number') ? 
                         'Glib::Int' :
                        'Glib::String';
        my $column = Gtk2::TreeViewColumn->new_with_attributes($title,  Gtk2::CellRendererText->new, 
                                                               'text' => 0);
        $column->set_resizable(1);
        $column->set_reorderable(1);
        $column->set_sort_column_id(0);
        # Columns are: Title, Index, isVisible
        $self->{model} = new Gtk2::TreeStore($columnType, 'Glib::Int', 'Glib::Boolean');
        $self->{filter} = new Gtk2::TreeModelFilter($self->{model});
        $self->{filter}->set_visible_column(2);
        {
            package GCSimpleTreeModelSort;
            use Glib::Object::Subclass
                Gtk2::TreeModelSort::,
                interfaces => [ 'Gtk2::TreeDragDest' ],
                ;
            
            sub new
            {
                my ($proto, $childModel) = @_;
                my $class = ref($proto) || $proto;
                return Glib::Object::new ($class, model => $childModel);
            }
        }
        $self->{sorter} = new GCSimpleTreeModelSort($self->{filter});
        $self->{subModel} = $self->{filter};
        $self->{completeModel} = $self->{sorter};
        $self->{list} = Gtk2::TreeView->new_with_model($self->{sorter});
        $self->{list}->append_column($column);
        $self->{list}->set_headers_clickable(1);
        $self->{list}->set_rules_hint(1);
        $self->{list}->set_name('GCItemsTextList');
        $self->{list}->get_selection->set_mode ('multiple');
        if ($parent->{model}->{fieldsInfo}->{$self->{titleField}}->{type} ne 'number')
        {
            $self->{sorter}->set_sort_func(0,
                                           \&sortCaseInsensitive,
                                           $self);
        }

        $self->{list}->get_selection->signal_connect ('changed' => sub {
            return if $self->{deactivateUpdate};
            my @indexes;
            my $nbSelected;
            $self->{list}->get_selection->selected_foreach(sub {
                my ($model, $path, $iter, $self) = @_;
                push @indexes, $self->{completeModel}->get_value($iter, 1);
                $nbSelected++;
            }, $self);
            return if scalar @indexes == 0;
            $parent->display(@indexes);
            my $iter = $self->getCurrentIter;
            $self->{currentIterString} = $self->convertIterToString($iter);
            
            # Update menus to reflect number of items selected
            $self->updateMenus($nbSelected);
        });

        $self->{list}->signal_connect ('row-activated' => sub {
           $parent->displayInWindow;
        });
        $self->{list}->signal_connect('button_press_event' => sub {
            my ($widget, $event) = @_;
            return 0 if $event->button ne 3;
            
            # Check if row clicked on is in the current selection
            my ($path, $column, $cell_x, $cell_y) = $widget->get_path_at_pos( $event->x, $event->y );
            my $selection = $widget->get_selection;
            my @rows = $selection->get_selected_rows;
            my $clickedOnSelection = 0;
            # Loop through selection to see if current row is selected
            foreach my $row(@rows)
            {
                if ($row->to_string eq $path->to_string)
                {
                    $clickedOnSelection = 1;
                }
            }

            # Popup the menu
            $self->{parent}->{context}->popup(undef, undef, undef, undef, $event->button, $event->time);
            
            # If row clicked on was in the selection, return true, else return false to clear selection
            # to clicked on item
            if ($clickedOnSelection)
            {
                return 1;
            }
            else
            {
                return 0;
            } 
        });

        $self->{list}->signal_connect('key-press-event' => sub {
                my ($widget, $event) = @_;
                my $key = Gtk2::Gdk->keyval_name($event->keyval);
                if ($key eq 'Delete')
                {
                    $self->{parent}->deleteCurrentItem;
                    return 1;
                }
                return 0;
        });

        $self->add($self->{list});
        $self->show_all;
        $self->{currentIdx} = 0;

        return $self;
    }

    sub savePreferences
    {
        my ($self, $preferences) = @_;
        return if !$self->{orderSet};
        my ($fieldId, $order) = $self->{sorter}->get_sort_column_id;
        $preferences->sortField($self->{titleField});
        $preferences->sortOrder(($order eq 'ascending') ? 1 : 0);
    }

    sub couldExpandAll
    {
        my $self = shift;
        
        return 0;
    }

    sub convertIterToIdx
    {
        my ($self, $iter) = @_;
        return 0 if ! $iter;
        return $self->{completeModel}->get_value($iter, 1)
    }

    sub getCurrentIdx
    {
        my $self = shift;
        my $currentIter = $self->getCurrentIter;
        return $self->{completeModel}->get_value(
            $self->getCurrentIter, 1
        )
            if $currentIter;
        return 0;
    }

    sub isUsingDate
    {
        my ($self) = @_;
        return 0;
    }

    sub setSortOrder
    {
        my ($self, $order, $splash, $willFilter) = @_;
        $self->{orderSet} = 1;
        my $progressNeeded = ($splash && !$willFilter);
        my $step;
        if ($progressNeeded)
        {
            $step = GCUtils::round($self->{count} / 7);
            $splash->setProgressForItemsSort(2*$step);
        }
        $self->{sorter}->set_sort_column_id(0,
                                           $self->{preferences}->sortOrder ? 'ascending' : 'descending');
        $self->{sorter}->set_default_sort_func(undef, undef);
        $splash->setProgressForItemsSort(4*$step) if $progressNeeded;
    }

    sub sortCaseInsensitive
    {
        my ($childModel, $iter1, $iter2, $self) = @_;
        
        if ($self->{deactivateSortCache})
        {
            my $val1 = uc($childModel->get_value($iter1, 0));
            my $val2 = uc($childModel->get_value($iter2, 0));
            # Use a natural string sort method
            return (GCUtils::gccmp($val1, $val2));
        }
        else
        {
            my $idx1 = $childModel->get_value($iter1, 1);
            my $idx2 = $childModel->get_value($iter2, 1);
            my $val1 = uc($childModel->get_value($iter1, 0));
            my $val2 = uc($childModel->get_value($iter2, 0));
            # Use a natural string sort method
            return (GCUtils::gccmp($val1, $val2));
        }
    }

    sub testIter
    {
        my ($self, $filter, $items, $iter) = @_;
        my $idx = ($self->{model}->get($iter))[1];
        my $displayed;
        if (defined $self->{testCache}->[$idx])
        {
            $displayed = $self->{testCache}->[$idx];
        }
        else
        {
            $displayed = $self->{testCache}->[$idx] = $filter->test($items->[$idx]);
            # We increment only here to count only unique items
            $self->{count}++ if $displayed;
        }
        $self->{model}->set($iter,
                            2,
                            $displayed
                           );
        return $displayed;
    }

    sub setFilter
    {
        my ($self, $filter, $items, $refresh, $splash) = @_;
        $self->{count} = 0;
        $self->{testCache} = [];
        $self->{tester} = $filter;
        my $iter = $self->{model}->get_iter_first;
        my $idx = 0;
        $self->{model}->foreach(sub {
            $splash->setProgressForItemsSort($idx++) if $splash;
            my ($model, $path, $iter) = @_;
            GCTextList::testIter($self, $filter, $items, $iter);
            return 0;
        });
        $self->{filter}->refilter;
        
        my $currentIter = $self->getCurrentIter;
        return $self->{completeModel}->get_value($currentIter, 1)
            if $currentIter;
        if ($self->{completeModel}->get_iter_first)
        {
            my $idx = $self->{completeModel}->get_value($self->{completeModel}->get_iter_first, 1);
            $self->select($idx);
            return $idx;
        }
        else
        {
            return 0;
        }
        
    }

    sub clearCache
    {
        my $self = shift;
    }

    sub reset
    {
        my $self = shift;
        $self->{list}->set_model(undef);
        $self->{model}->clear;
        $self->{currentIdx} = 0;
        $self->{nextItemIdx} = -1;
    }
    
    sub done
    {
        my $self = shift;
        $self->{list}->set_model($self->{sorter});
    }
    
    sub getNextIter
    {
        my ($self, $viewedIter) = @_;
        my $nextIter = $self->{completeModel}->iter_next($viewedIter);
        # If we removed the last one, we are using the previous one.
        $nextIter = $self->{completeModel}->iter_nth_child(undef, $self->{count} - 1)
            if !$nextIter && ($self->{count} > 0);
        my $newIdx = 0;
        if ($nextIter)
        {
            $newIdx = $self->{completeModel}->get_value($nextIter, 1);
            #$self->selectIter($nextIter);
        }
        return ($nextIter, $newIdx);
    }

    sub addItem
    {
        my ($self, $info, $immediate) = @_;
        $self->{nextItemIdx}++;
        $self->{count}++;
        my @data = (
                    0 => $self->{parent}->transformTitle($info->{$self->{titleField}}),
                    1 => $self->{nextItemIdx},
                    2 => 1
                    );
        $self->{model}->set($self->{model}->append(undef), @data);
    }
    
    sub removeFromModel
    {
        my ($self, $iter) = @_;
        $self->{model}->remove($iter);
    }

    sub removeItem
    {
        my ($self, $number) = @_;
        splice @{$self->{testCache}}, $number, 1;
        #Shift backward all following items.
        $self->{model}->foreach(sub {
            my ($model, $path, $iter) = @_;
            my $currentIdx = $model->get_value($iter,1);
            if ($currentIdx >= $number)
            {
                $model->set($iter, 1, $currentIdx - 1)
                    if $currentIdx != $number;
            }
            return 0;
        });

        $self->{count}--;
        $self->{nextItemIdx}--;
        my $viewedCurrentIter = $self->getCurrentIter;
        my $currentIter = $self->convertIterToChildIter($viewedCurrentIter);
        my $newIdx = $self->selectNextIter($viewedCurrentIter);
        $self->{model}->remove($currentIter);
        return $newIdx;
    }

    sub select
    {
        my ($self, $idx, $init) = @_;
        if ($idx == -1)
        {
            $self->{currentIterString} = '0';
            my $currentIter = $self->{completeModel}->get_iter_first;
            if (!$currentIter)
            {
                $idx = 0;
                return;
            }
            $idx = $self->{completeModel}->get_value($currentIter, 1);
            $self->selectIter($currentIter);
        }
        else
        {
            $self->{currentIterString} = '0' if ! $self->{currentIterString};
            $self->{completeModel}->foreach(sub {
                my ($model, $path, $iter) = @_;
                if ($model->get_value($iter, 1) == $idx)
                {
                    $self->{currentIterString} = $model->get_path($iter)->to_string;
                    $self->selectIter($iter);
                    return 1;
                }
                return 0;
            });
        }
        return $idx;
    }
    
    sub showCurrent
    {
        my $self = shift;
        
        my $path = $self->{list}->get_selection->get_selected_rows;
        $self->{list}->scroll_to_cell($path) if $path;
    }

    sub changeCurrent
    {
        my ($self, $previous, $new, $idx, $wantSelect) = @_;
        my $selected = $self->getCurrentIterFromString;;
        return if ! $selected;
        my $currentIter = $self->convertIterToChildIter($selected);
        my $newValue = $self->{parent}->transformTitle($new->{$self->{titleField}});
        my $newIdx = $idx;
        my $visible = $self->{tester} ? $self->{tester}->test($new) : 1;
        
        if (!$visible)
        {
            my $nextIter;
            ($nextIter, $newIdx) = $self->getNextIter($selected);
            $self->selectIter($nextIter, 1) if $nextIter && $wantSelect;
            $self->{count}--;
        }
        $self->{model}->set($currentIter, 0, $newValue);
        # Update the isVisible field
        $self->{model}->set($currentIter, 2, $visible);

        my $iter = $self->getCurrentIter;
        $self->{currentIterString} = $self->convertIterToString($iter);
        return $newIdx;
    }
    
}

{
    package GCDetailedList;
    
    use File::Basename;
    use base 'GCBaseTextList';
    use GCUtils;

    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent);
        bless ($self, $class);

        $self->{multi} = 1;
        $self->{orderSet} = 0;
        $self->{groupItems} = 0;
        $self->{isUsingDate} = 0;
        $self->{titleField} = $parent->{model}->{commonFields}->{title};
        
        $self->{imgWidth} = 60;
        $self->{imgHeight} = 80;
        
        # Setting default options if they don't exist
        $self->{preferences}->detailImgSize(2) if ! $self->{preferences}->exists('detailImgSize');
        $self->{preferences}->details($self->{titleField})
            if ! $self->{preferences}->details;
        $self->{preferences}->groupedFirst(1)
            if ! $self->{preferences}->exists('groupedFirst');
        $self->{preferences}->addCount(0)
            if ! $self->{preferences}->exists('addCount');

        # Image size
        my $size = $self->{preferences}->detailImgSize;
        $self->{factor} = ($size == 0) ? 0.5
                        : ($size == 1) ? 0.8
                        : ($size == 3) ? 1.5
                        : ($size == 4) ? 2
                        :                1;                        
        $self->{imgWidth} *= $self->{factor};
        $self->{imgHeight} *= $self->{factor};
        
        $self->clearCache;
        
        $self->set_policy ('automatic', 'automatic');
        $self->set_shadow_type('none');

        my @tmpArray = split m/\|/, $self->{preferences}->details;
        $self->{fieldsArray} = \@tmpArray;
        
        $self->{imageIndex} = -1;
        my @columnsType;
        $self->{columnsArray} = [];
        $self->{columns} = {};
        my $col = 0;

        $self->{borrowerField} = $parent->{model}->{commonFields}->{borrower}->{name};

        $self->setGroupingInformation;
        # We don't need count if not grouped
        $self->{addCount} = $self->{groupItems} && $self->{preferences}->addCount;

        $self->{secondaryField} = $self->{preferences}->secondarySort;
        $self->{secondaryIndex} = -1;
        $self->{addSecondary} = 0;

        foreach my $field(@tmpArray)
        {
            my $title = $parent->{model}->{fieldsInfo}->{$field}->{displayed};
        
            my $renderer;
            my $attribute;
            if ($parent->{model}->{fieldsInfo}->{$field}->{type} eq 'image')
            {
                push @columnsType, 'Gtk2::Gdk::Pixbuf';
                $renderer = Gtk2::CellRendererPixbuf->new;
                $attribute = 'pixbuf';
                $self->{imageIndex} = $col;
            }
            elsif ($parent->{model}->{fieldsInfo}->{$field}->{type} eq 'yesno')
            {
                push @columnsType, 'Glib::Boolean';
                $renderer = Gtk2::CellRendererToggle->new;
                $attribute = 'active';
            }
            elsif ($parent->{model}->{fieldsInfo}->{$field}->{type} eq 'number')
            {
                push @columnsType, 'Glib::Double';
                $renderer = Gtk2::CellRendererText->new;
                $attribute = 'text';
            }
            else
            {
                $self->{isUsingDate} = 1
                    if $parent->{model}->{fieldsInfo}->{$field}->{type} eq 'date';
                push @columnsType, 'Glib::String';
                $renderer = Gtk2::CellRendererText->new;
                $attribute = 'text';
            }
            $self->{secondaryIndex} = $col if $field eq $self->{secondaryField};
            $self->{columns}->{$field} = Gtk2::TreeViewColumn->new_with_attributes($title, $renderer, 
                                                                                   ($attribute) ? ($attribute => $col) : ());
            if ($parent->{model}->{fieldsInfo}->{$field}->{type} eq 'number')
            {
                $self->{columns}->{$field}->set_cell_data_func($renderer, sub {
                    my ($column, $cell, $model, $iter, $colNum) = @_;
                    my $value = $model->get_value($iter, $colNum);
                    # TODO - not returning correct value when first column is a number
                    # and a grouping field is set. 
                    # Remove trailing 0
                    $value =~ s/\.[0-9]*?0+$//;
                    $cell->set_property('text', $value);
                }, $col);
            }

            # We store the field name in it to ease the save of the column order in preferences
            $self->{columns}->{$field}->{field} = $field;
            $self->{columns}->{$field}->set_resizable(1);
            $self->{columns}->{$field}->set_reorderable(1);
            if ($parent->{model}->{fieldsInfo}->{$field}->{type} eq 'image')
            {
                $self->{columns}->{$field}->set_clickable(0);
            }
            else
            {
                $self->{columns}->{$field}->set_sort_column_id($col);
            }
            push @{$self->{columnsArray}}, $self->{columns}->{$field};
            $self->{fieldToId}->{$field} = $col;
            $col++;
        }
        push @columnsType, 'Glib::Int';
        $self->{idxColumn} = $col;
        push @columnsType, 'Glib::Boolean';
        $self->{visibleCol} = ++$col;
        
        # There is a secondary field for sort, but we didn't add it yet
        if ($self->{secondaryField} && ($self->{secondaryIndex} == -1))
        {
            push @columnsType, 'Glib::String';
            $self->{addSecondary} = 1;
            $self->{secondaryIndex} = ++$col;
        }

        $self->{model} = new Gtk2::TreeStore(@columnsType);        
        {
            package GCTreeModelSort;
            use Glib::Object::Subclass
                Gtk2::TreeModelSort::,
                interfaces => [ Gtk2::TreeDragDest:: ],
                ;
            
            sub new
            {
                my ($proto, $childModel) = @_;
                my $class = ref($proto) || $proto;
                return Glib::Object::new ($class, model => $childModel);
            }
        }

        $self->{filter} = new Gtk2::TreeModelFilter($self->{model});
        $self->{sorter} = new GCTreeModelSort($self->{filter});

        $self->{filter}->set_visible_column($self->{visibleCol});

        $self->{subModel} = $self->{filter};
        $self->{completeModel} = $self->{sorter};

        $self->{list} = Gtk2::TreeView->new_with_model($self->{completeModel});
        $self->{list}->append_column($_) foreach (@{$self->{columnsArray}});
        
        $self->{list}->set_name('GCItemsDetailsList');
        $self->{list}->set_headers_clickable(1);
        $self->{list}->set_rules_hint(1);
        $self->{list}->set_reorderable(1);

        # Restore size of columns
        if ($self->{preferences}->exists('columnsWidths'))
        {
            my $i = 0;
            my @widths = split /\|/, $self->{preferences}->columnsWidths;
             #/ For syntax highlighting
            foreach (@{$self->{columnsArray}})
            {
                $_->set_sizing('fixed');
                $_->set_resizable(1);
                $_->set_fixed_width($widths[$i] || 70);
                $i++;
            }
        }

        # Use grouping field for generated masters, or if that field isn't displayed,
        # fallback on title, or first column
        if (exists $self->{columns}->{$self->{collectionField}})
        {
            $self->{generatedField} = $self->{collectionField};        
        }
        elsif (exists $self->{columns}->{$self->{titleField}})
        {
            $self->{generatedField} = $self->{titleField};
        }
        else
        {
            $self->{generatedField} = $tmpArray[0];
        }
        $self->{generatedIndex} = $self->{fieldToId}->{$self->{generatedField}};
        $self->{list}->set_expander_column($self->{columns}->{$self->{generatedField}});
        
        if (exists $self->{columns}->{$self->{titleField}})
        {
            $self->{searchField} = $self->{titleField};
        }
        else
        {
            $self->{searchField} = $tmpArray[0];
        }
        $self->{searchIndex} = $self->{fieldToId}->{$self->{searchField}};
        $self->{list}->set_search_column($self->{searchIndex});

        $self->{sorter}->signal_connect('rows-reordered' => sub {
            my ($fieldId, $order) = $self->{sorter}->get_sort_column_id;
            $self->{list}->set_search_column($fieldId);
        });

        # Initializing sort methods
        my $colIdx = 0;
        #my $secondarySort = 1;
        my $sorttype = "";
        foreach my $field(@tmpArray)
        {
            my ($secondaryIndex, $secondaryField) = ($self->{secondaryIndex}==-1)
                                                  ? ($colIdx, $field)
                                                  : ($self->{secondaryIndex}, $self->{secondaryField});
            my $data = [$self, $colIdx, $secondaryIndex];
            foreach my $sorter($field, $secondaryField)
            {
                next if !$sorter;
                # Work out how to sort the column
                if ((!exists $self->{columns}->{$self->{collectionField}}) &&
                    ($self->{groupItems}) &&
                    ($sorter eq $self->{generatedField}))
                {
                    # The grouping field isn't visible, so we need to set 
                    # the sort order on the column we're using for the group
                    # headers to be sorted using the grouping field type 
                    if (($parent->{model}->{fieldsInfo}->{$self->{collectionField}}->{type} eq 'date') ||
                        ($parent->{model}->{fieldsInfo}->{$self->{collectionField}}->{sorttype} eq 'date'))
                    {
                        $sorttype = "date";
                    }
                    elsif (($parent->{model}->{fieldsInfo}->{$self->{collectionField}}->{type} eq 'number') ||
                             ($parent->{model}->{fieldsInfo}->{$self->{collectionField}}->{sorttype} eq 'number'))
                    {
                        $sorttype = "number";
                    }
                    else
                    {                
                        $sorttype = "text";                    
                    }                
                }
                elsif (($parent->{model}->{fieldsInfo}->{$sorter}->{type} eq 'number') ||
                       ($parent->{model}->{fieldsInfo}->{$sorter}->{sorttype} eq 'number'))
                {
                    $sorttype = "number";
                }
                elsif (($parent->{model}->{fieldsInfo}->{$sorter}->{type} eq 'date') ||
                       ($parent->{model}->{fieldsInfo}->{$sorter}->{sorttype} eq 'date'))
                {
                    $sorttype = "date";
                }
                else
                {
                    $sorttype = "text";
                }
                
                # Set the column for the desired type of sorting
                if ($sorttype eq "number")
                {
                    # Small trick to convert number as follows with a letter
                    # in front of them so cmp will work as expected
                    # e.g.: 3 -> b3; 42 -> c42; 56 -> c56; 5897446 -> h5897446
                    # This could not work if your system uses a character encoding
                    # which is not contiguous as EBCDIC
                    push @$data, sub {return chr(length($_[0]*1000)+ord('a')).($_[0]*1000)};
                }
                elsif ($sorttype eq "date")
                {
                    push @$data, \&GCPreProcess::reverseDate;
                }
                else
                {
                    #push @$data, \&uc;
                    push @$data, sub {return uc $_[0]};
                }
            }
            if ($self->{groupItems} && ($self->{preferences}->groupedFirst))
            {
                $self->{sorter}->set_sort_func($colIdx,
                                               \&sortWithParentFirst,
                                               $data);
            }
            else
            {
                $self->{sorter}->set_sort_func($colIdx,
                                               \&sortAll,
                                               $data);
            }
            $colIdx++;
        }
        $self->{list}->get_selection->set_mode ('multiple');
        
        $self->{list}->get_selection->signal_connect('changed' => \&onSelectionChanged,
                                                     $self);

#        $self->{list}->get_selection->set_select_function(sub {
#            my ($selection, $model, $path) = @_;
#            return !$model->iter_has_child($model->get_iter($path));
#        });

        $self->{list}->signal_connect ('row-activated' => sub {
           $parent->displayInWindow;
        });

        $self->add($self->{list});
        
        $self->{list}->signal_connect('button_press_event' => sub {
            my ($widget, $event) = @_;
            return 0 if $event->button ne 3;
           
            # Check if row clicked on is in the current selection
            my ($path, $column, $cell_x, $cell_y) = $widget->get_path_at_pos( $event->x, $event->y );
            my $selection = $widget->get_selection;
            my @rows = $selection->get_selected_rows;
            my $clickedOnSelection = 0;
            # Loop through selection to see if current row is selected
            foreach my $row(@rows)
            {
                if ($row->to_string eq $path->to_string)
                {
                    $clickedOnSelection = 1;
                }
            }

            # Popup the menu
            $self->{parent}->{context}->popup(undef, undef, undef, undef, $event->button, $event->time);
            
            # If row clicked on was in the selection, return true, else return false to clear selection
            # to clicked on item
            if ($clickedOnSelection)
            {
                return 1;
            }
            else
            {
                return 0;
            } 
        });

        $self->{list}->signal_connect('key-press-event' => sub {
            my ($treeview, $event) = @_;
            my $key = Gtk2::Gdk->keyval_name($event->keyval);
            if ($key eq 'Delete')
            {
                return 1 if !$self->{count};
                return 1 if !$self->getCurrentIter;
                return 1 if $self->{completeModel}->iter_has_child(
                    $self->getCurrentIter
                );
                $self->{parent}->deleteCurrentItem;
                return 1;
            }
            return 0;
        });

        if ($self->{groupItems})
        {
            my $targetEntryMove = {
                target => 'MY_ROW_TARGET',
                flags => ['same-widget'],
                info => 42,
            };
            
            $self->{list}->enable_model_drag_source('button1-mask','move', $targetEntryMove);
            $self->{list}->enable_model_drag_dest('move', $targetEntryMove);

            $self->{list}->signal_connect('drag_data_get' => sub {
                return 1;
            });
    
            $self->{list}->signal_connect('drag_data_received' => \&dropHandler, $self);
        }
        else
        {
            $self->{list}->unset_rows_drag_dest;
            $self->{list}->unset_rows_drag_source;
        }

        $self->reset;

        $self->show_all;
        return $self;
    }

    sub destroy
    {
        my $self = shift;
        # Unlock panel if we locked it when displaying a category
        $self->{parent}->{panel}->lock(0);
        $self->SUPER::destroy;
    }

    sub onSelectionChanged
    {
        my ($selection, $self) = @_;
        return if $self->{deactivateUpdate};
        my @indexes;
        my $nbSelected;
        $self->{list}->get_selection->selected_foreach(sub {
            my ($model, $path, $iter, $self) = @_;
            push @indexes, $self->convertIterToIdx($iter);
            $nbSelected++;
        }, $self);
        return if scalar @indexes == 0;
        my $iter = $self->getCurrentIter;
        $self->{selectedIterString} = $self->convertIterToString($iter);
        $self->{currentRemoved} = 0;
        $self->{parent}->display(@indexes);
        $self->{currentIterString} = $self->{selectedIterString}
            if !$self->{currentRemoved};
        $self->checkLock;
        
        # Update menu items to reflect number of items selected
        $self->updateMenus($nbSelected);
        
    }

    sub savePreferences
    {
        my ($self, $preferences) = @_;

        # Save the columns order and their sizes as pipe separated lists
        my $details = '';
        my $widths = '';
        foreach my $col($self->{list}->get_columns)
        {
            $details .= $col->{field}.'|';
            $widths .= $col->get_width.'|';
        }
        $preferences->details($details);
        $preferences->columnsWidths($widths);

        # We return here if the order has not been set previously
        return if !$self->{orderSet};
        my ($fieldId, $order) = $self->{sorter}->get_sort_column_id;
        $preferences->sortField($self->{fieldsArray}->[$fieldId]);
        $preferences->sortOrder(($order eq 'ascending') ? 1 : 0);

    }

    sub couldExpandAll
    {
        my $self = shift;
        
        return 1;
    }

    sub expandAll
    {
        my $self = shift;
        
        $self->{list}->expand_all;
    }

    sub collapseAll
    {
        my $self = shift;
        
        $self->{list}->collapse_all;
    }

    sub setGroupingInformation
    {
        my $self = shift;
        $self->{collectionField} = $self->{preferences}->groupBy;
        $self->{groupItems} = ($self->{collectionField} ne '');
    }

    sub sortAll
    {
        my ($childModel, @iter, $data);
        ($childModel, $iter[0], $iter[1], $data) = @_;
        my ($self, $colId1, $colId2, $converter1, $converter2) = @$data;

        my @val;
        my $colId;
        my $converter;
        foreach my $i(0..1)
        {
            ($colId, $converter) = ($childModel->iter_parent($iter[$i]))
                                 ? ($colId2, $converter2)
                                 : ($colId1, $converter1);
            push @val, $converter->($childModel->get_value($iter[$i], $colId));
        }
        return (GCUtils::gccmp($val[0], $val[1]));
    }

    sub sortWithParentFirst
    {
        my ($childModel, $iter1, $iter2, $data) = @_;
        my ($self, $colId1, $colId2, $converter1, $converter2) = @$data;

        my $hasChildren1 = $childModel->iter_has_child($iter1);
        my $hasChildren2 = $childModel->iter_has_child($iter2);

        my $colId;
        my $converter;
        if ($hasChildren1 == $hasChildren2)
        {
            ($colId, $converter) = ($childModel->iter_parent($iter1))
                                 ? ($colId2, $converter2)
                                 : ($colId1, $converter1);

            # FIXME If we don't copy the value first, it will crash on win32 systems
            # with an iterator not matching model
            my $val1 = $converter->($childModel->get_value($iter1, $colId));
            my $val2 = $converter->($childModel->get_value($iter2, $colId));
            return (GCUtils::gccmp($val1, $val2));
        }
        else
        {
            return ($hasChildren1 ? -1 : 1);
        }
    }

    sub dropHandler
    {
        my ($treeview, $context, $widget_x, $widget_y, $data, $info, $time, $self) = @_;
        my $source = $context->get_source_widget;
        return if ($source ne $treeview);
        my $model = $treeview->get_model;
        my ($targetPath, $targetPos) = $treeview->get_dest_row_at_pos($widget_x, $widget_y);
        if ($targetPath)
        {
            my $targetIter = $model->get_iter($targetPath);
            #my $origIter = $treeview->get_selection->get_selected;
            
            # Deactivate DnD for multiple selection
            my @rows = $self->{list}->get_selection->get_selected_rows;
            if (scalar(@rows) > 1)
            {
                $context->finish(1,0,$time);
                return;
            }

            my $origIter = $self->getCurrentIter;            
            if ($model->iter_has_child($origIter))     # We can't move a master
            {
                $context->finish(1,0,$time);
                return;
            }            
            
            my $origIdx = $self->convertIterToIdx($origIter);
            my $origCollection = '';
            my $origParentIter = $model->iter_parent($origIter);
            my ($origParentPath, $origParentChildIter);
            if ($origParentIter)
            {
                $origParentChildIter = $self->convertIterToChildIter($origParentIter);
                $origParentPath = $self->{model}->get_path($origParentChildIter)
                    if ($self->{addCount});
            }
            $origCollection = $self->getIterCollection($origParentChildIter)
                if $origParentChildIter;
            #We cannot drop an item on itself
            if ($targetIter == $origIter)
            {
                $context->finish(1,0,$time);
                return;
            }
            my @origData;
            my $i = 0;
            foreach ($model->get_value($origIter))
            {
                push @origData, $i, $_;
                $i++;
            }
            my $collectionIter = $model->iter_parent($targetIter);
            #if ($collectionIter)
            my $collection = $collectionIter
                           ? $self->getIterCollection($self->convertIterToChildIter($collectionIter))
                           : $self->getIterCollection($self->convertIterToChildIter($targetIter));

            my $newIter;
            my $refreshCountNeeded = 0;
            if ($targetPos =~ /^into/)
            {
                if (
                    (!$model->iter_has_child($targetIter))  # We can't drop on a single item
                 || ($targetPath->get_depth > 1)            # We can't add an item to an item in a collection.
                 || ($model->iter_has_child($origIter))     # We can't move a master
                   )
                {
                    $context->finish(1,0,$time);
                    return;
                }
                else
                {
                    #Creating a new collection item
                    $newIter = $self->{model}->append($self->convertIterToChildIter($targetIter));
                    $refreshCountNeeded = 1;
                }
            }
            else
            {
                my $origPath = $model->get_path($origIter);
                if ($targetPath->get_depth == 1)
                {
                    if  ($origPath->get_depth == 1)
                    {
                        #Just moving a master item is not allowed
                        $context->finish(1,0,$time);
                        return;
                    }
                    else
                    {
                        #We get an item out of a collection
                        $newIter = $self->{model}->append(undef);
                        $collection = '';
                    }
                }
                else
                {
                    #We are placing a collection item
                    $newIter = $self->{model}->append(
                        $self->convertIterToChildIter($model->iter_parent($targetIter))
                    );
                    $refreshCountNeeded = 1;
                }
            }
            
            $self->{model}->set($newIter, @origData);
            if ($self->{addCount})
            {
                # Refreshing target
                $self->refreshCount($self->{model}->iter_parent($newIter))
                    if ($refreshCountNeeded);

                # Refreshing origin
                # We remove 1 to the count because the original has not been removed yet
                # It will be removed when returning from this method
                $self->refreshCount($self->{model}->get_iter($origParentPath), 0, -1)
                    if $origParentPath;
            }
            #$origIter = $treeview->get_selection->get_selected;
            $origIter = $self->getCurrentIter;
            #$self->removeParentIfNeeded($origIter);
            
            # Removing previous instances in other collections
            $self->removeOtherInstances($origCollection, $origIdx);
            
            $self->{parent}->{items}->setValue($origIdx, $self->{collectionField}, $collection);
            $context->finish(1,1,$time);
            $self->select($origIdx);
            $self->{parent}->markAsUpdated;
        }
    }

    sub removeOtherInstances
    {
        my ($self, $collection, $idx, $fullCollection) = @_;
        if ($collection)
        {
            my $collectionArray = 
                $self->transformValue(
                    $fullCollection || $self->{parent}->{items}->getValue($idx, $self->{collectionField}),
                    $self->{collectionField},
                    0,
                    $self->{groupItems}
                );
            if (ref($collectionArray) eq 'ARRAY')
            {
                foreach (@$collectionArray)
                {
                    next if $_ eq $collection;
                    $self->removeInCollection($_, $idx);
                }
            }
            
        }
    }        

    sub removeParentIfNeeded
    {
        my ($self, $iter) = @_;
        #Destroy the previous auto-generated item if there was only one child
        my $parentIter = $self->{model}->iter_parent($self->convertIterToChildIter($iter));
        if ($parentIter && ($self->{model}->iter_n_children($parentIter) <= 1))
        {
            $self->{model}->remove($parentIter);
        }
    }

    sub removeFromModel
    {
        my ($self, $iter) = @_;
        my $parentToRemove = undef;

        my $parentIter = $self->{model}->iter_parent($iter);
        my $refreshCountNeeded = 0;
        if ($parentIter)
        {
            if ($self->{model}->iter_n_children($parentIter) <= 1)
            {
                $parentToRemove = $parentIter;
            }
            else
            {
                # If we removed the 1st one, we should change the index of the master
                # to be the new 1st
                my $removedIdx = $self->convertChildIterToIdx($iter);
                my $firstIdx = $self->convertChildIterToIdx($self->{model}->iter_children($parentIter));
                if ($firstIdx == $removedIdx)
                {
                    my $newIdx = $self->convertChildIterToIdx($self->{model}->iter_nth_child($parentIter, 1));
                    $self->{model}->set($parentIter, $self->{idxColumn}, $newIdx);
                }
            }
            # Update count if needed
            if (($self->{addCount})
             && ($self->{model}->get($iter, $self->{visibleCol}))
             && ($self->{model}->get($parentIter, $self->{visibleCol})))
            {
                $refreshCountNeeded = 1;
            }

        }

        $self->{model}->remove($iter);
        $self->refreshCount($parentIter) if $refreshCountNeeded;
        $self->{model}->remove($parentToRemove) if $parentToRemove;        
    }

    sub isUsingDate
    {
        my ($self) = @_;
        return $self->{isUsingDate};
    }

    sub setSortOrder
    { 
        my ($self, $order, $splash, $willFilter) = @_;
        $self->{orderSet} = 1;
        my $progressNeeded = ($splash && !$willFilter);
        my ($realOrder, $field) = ($self->{preferences}->sortOrder, $self->{preferences}->sortField);
        my $step;
        if ($progressNeeded)
        {
            $step = GCUtils::round($self->{count} / 7);
            $splash->setProgressForItemsSort(2*$step);
        }
        $self->{sorter}->set_sort_column_id($self->{fieldToId}->{$field},
                                           $realOrder ? 'ascending' : 'descending');
        $self->{list}->set_search_column($self->{fieldToId}->{$field});
        $self->{sorter}->set_default_sort_func(undef, undef);
        $splash->setProgressForItemsSort(4*$step) if $progressNeeded;
    }

    sub testIter
    {
        my ($self, $filter, $items, $iter) = @_;
        my $idx = $self->convertChildIterToIdx($iter);
        my $displayed;
        if (exists $self->{testCache}->[$idx])
        {
            $displayed = $self->{testCache}->[$idx];
        }
        else
        {
            $displayed = $self->{testCache}->[$idx] = $filter->test($items->[$idx]);
            # We increment only here to count only unique items
            $self->{count}++ if $displayed;
        }
        $self->{model}->set($iter,
                            $self->{visibleCol},
                            $displayed
                           );
        return $displayed;
    }

    sub setFilter
    {
        my ($self, $filter, $items, $refresh, $splash) = @_;
        $self->{count} = 0;
        $self->{testCache} = [];
        $self->{tester} = $filter;
        my $idx = 0;
        my $iter = $self->{model}->get_iter_first;
        while ($iter)
        {
            $splash->setProgressForItemsSort($idx++) if $splash;
            if ($self->{model}->iter_has_child($iter))
            {
                my $showParent = 0;
                my $childIter = $self->{model}->iter_children($iter);
                while ($childIter)
                {
                    my $displayed = GCDetailedList::testIter($self, $filter, $items, $childIter);
                    $showParent ||= $displayed;
                    $childIter = $self->{model}->iter_next($childIter);
                }
                $self->{model}->set($iter,
                                    $self->{visibleCol},
                                    $showParent
                                   );
            }
            else
            {
                GCDetailedList::testIter($self, $filter, $items, $iter);
            }
            $iter = $self->{model}->iter_next($iter);
        }
        $self->{filter}->refilter;
        $self->refreshCounts if ($self->{addCount});
        my $currentIter = $self->getCurrentIter;
        return $self->convertIterToIdx($currentIter)
            if $currentIter;
        $idx = $self->convertIterToIdx($self->{completeModel}->get_iter_first);
        return $idx;
    }

    sub getPixbufFromCache
    {
        my ($self, $path) = @_;
        
        my $realPath = GCUtils::getDisplayedImage($path,
                                                  $self->{parent}->{defaultImage},
                                                  $self->{parent}->{options}->file);
        
        if (! $self->{cache}->{$realPath})
        {
            my $pixbuf;
            eval {
                $pixbuf = Gtk2::Gdk::Pixbuf->new_from_file($realPath);
            };
            $pixbuf = Gtk2::Gdk::Pixbuf->new_from_file($self->{parent}->{defaultImage})
                if $@;

            $pixbuf = GCUtils::scaleMaxPixbuf($pixbuf,
                                              $self->{imgWidth},
                                              $self->{imgHeight},
                                              $self->{withImage});
            $self->{cache}->{$realPath} = $pixbuf;
        }
        return $self->{cache}->{$realPath};
    }

    sub clearCache
    {
        my $self = shift;
        $self->{cache} = {};
    }

    sub reset
    {
        my $self = shift;
        $self->{list}->set_model(undef);
        $self->{model}->clear;
        $self->{alreadyInserted} = {};
        $self->{currentIdx} = 0;
        $self->{nextItemIdx} = -1;

        $self->setGroupingInformation;
    }

    sub done
    {
        my $self = shift;
        $self->{list}->set_model($self->{completeModel});
        $self->refreshCounts if ($self->{addCount});
    }

    sub refreshCount
    {
        my ($self, $iter, $added, $offset) = @_;

        my $subIter = $self->{subModel}->convert_child_iter_to_iter($iter);
        my $nbChildren = $subIter
                       ? $self->{subModel}->iter_n_children($subIter)
                       : ($added ? 1 : 0);
        $nbChildren += $offset if defined $offset;
        # Version below still works if the orders of filter and sorter are inverted
        #my $nbChildren = 0;
        #my $childIter = $self->{model}->iter_children($iter);
        #while ($childIter)
        #{
        #    $nbChildren++ if $self->{model}->get($childIter, $self->{visibleCol});
        #    $childIter = $self->{model}->iter_next($childIter);
        #}
        my $original = $self->getIterCollection($iter);
        my $generated = "$original ($nbChildren)";
        $self->{model}->set($iter,
                            $self->{fieldToId}->{$self->{generatedField}},
                            $generated);
        $self->{originalValue}->{$generated} = $original;
        $self->{model}->set($iter, $self->{visibleCol}, $nbChildren);
    }

    sub refreshCounts
    {
        my $self = shift;
        $self->{model}->foreach(sub {
            my ($model, $path, $iter) = @_;
            if ($model->iter_has_child($iter))
            {
                $self->refreshCount($iter);
            }
            return 0;
        });
    }

    sub transformValue
    {
        my ($self, $value, $field, $isGeneratedMaster, $multiAllowed, $isForSort, $forceArray) = @_;
        
        my $type = '';
        $type = $self->{parent}->{model}->{fieldsInfo}->{$field}->{type}
            if defined $self->{parent}->{model}->{fieldsInfo}->{$field}->{type};

        if ($type eq 'image')
        {
            $value = ($isGeneratedMaster ? undef : $self->getPixbufFromCache($value));
        }
        else
        {
            $value = $self->{parent}->transformValue($value, $field, ($multiAllowed && $self->{multi}));
        }
        if ($isForSort)
        {
            if ($type eq 'date')
            {
                $value = GCPreProcess::reverseDate($value);
            }
            else
            {
                $value = uc $value;
            }
        }
        if ($forceArray)
        {
            if (ref($value) ne 'ARRAY')
            {
                my @array = ($value);
                $value = \@array;
            }
        }
        return $value;
    }

    sub convertChildPathToPath
    {
        my ($self, $path) = @_;

        my $result = $path;
        $result = $self->{subModel}->convert_child_path_to_path($result);
        $result = $self->{completeModel}->convert_child_path_to_path($result)
            if $result;
        return $result;
    }

    sub getIterCollection
    {
        my ($self, $iter, $model) = @_;
        $model ||= $self->{model};
        my $val = ($model->get($iter))[$self->{generatedIndex}];
        if ($self->{addCount} && ($val =~ / \(\d+\)$/))
        {
            $val = $self->{originalValue}->{$val}
                if exists $self->{originalValue}->{$val};
        }
        return $val;
    }

    # This one should be called with a sorted/filtered iterator
    sub convertIterToIdx
    {
        my ($self, $iter) = @_;
        return 0 if ! $iter;
        # If we have a master, we return idx from its 1st displayed child
        if ($self->{completeModel}->iter_has_child($iter))
        {
            $iter = $self->{completeModel}->iter_children($iter);
        }
        return $self->{completeModel}->get_value($iter, $self->{idxColumn});
    }

    # This one should be called with an iterator from real model
    sub convertChildIterToIdx
    {
        my ($self, $iter) = @_;
        return 0 if ! $iter;
        return ($self->{model}->get($iter))[$self->{idxColumn}];
    }

    sub getCurrentIdx
    {
        my $self = shift;
        return $self->convertIterToIdx($self->getCurrentIter);
    }
    
    sub findMaster
    {
        my ($self, $collection) = @_;
        my $realCollection = $self->{parent}->transformTitle($collection);
        my $master = $self->{model}->get_iter_first;

        while ($master)
        {
            return $master if ($self->{model}->iter_has_child($master))
                           && ($self->getIterCollection($master) eq $realCollection);
            $master = $self->{model}->iter_next($master);
        }
        return undef;
    }

    sub removeInCollection
    {
        my ($self, $collec, $idx) = @_;
        my $master = $self->findMaster($collec);
        my $iter = $self->{model}->iter_nth_child($master, 0) || $master;
        while ($iter)
        {
            last if $idx == $self->convertChildIterToIdx($iter);
            $iter = $self->{model}->iter_next($iter);
        }
        if ($iter)
        {
            my $removedCurrent = ($self->{selectedIterString} eq $self->{currentIterString});
            $self->removeFromModel($iter);
            $self->{currentRemoved} = $removedCurrent;
        }
    }

    sub createRowsData
    {
        my ($self, $info, $idx, $withTest) = @_;
        my @data;
        my $col = 0;
        my $displayed = 1;
        if ($withTest)
        {
            $displayed = $self->{tester}->test($info)
                if $self->{tester};
            $self->{testCache}->[$idx] = $displayed;
        }
        foreach my $field(@{$self->{fieldsArray}})
        {
            my $value = $self->transformValue($info->{$field}, $field, $info->{isGeneratedMaster});
            push @data, $col, $value;
            $col++;
        }
        push @data, $col++, $idx;
        push @data, $col++, $displayed;
        push @data, $col++, $self->transformValue($info->{$self->{secondaryField}})
             if $self->{addSecondary};
        return @data;
    }

    sub addItem
    {
        my ($self, $info, $immediate) = @_;

        $self->{nextItemIdx}++;
        $self->{count}++;

        my $collection = $self->transformValue($info->{$self->{collectionField}}, $self->{collectionField},
                                               0, $self->{groupItems});

        #Creating data;
        my @data = $self->createRowsData($info, $self->{nextItemIdx});

        if (
              (! defined $collection)
           || ($collection eq '')
           || (!$self->{groupItems})
           || (
                (ref($collection) eq 'ARRAY')
             && (
                  (! scalar @$collection)
               || ((scalar @$collection == 1) && ((! defined $collection->[0]) || $collection->[0] eq ''))
                )
              )
           )
        {
            #Simple entry
            $self->{model}->set($self->{model}->append(undef), @data);
            return;
        }
        
        if (ref($collection) ne 'ARRAY')
        {
            my @array = ($collection);
            $collection = \@array;
        }
        foreach (@$collection)
        {
            next if $_ eq '';
            if (exists $self->{alreadyInserted}->{$_})
            {
                #Master already exists
                my $master;
                $master = $self->findMaster($_);
                my $childIter = $self->{model}->append($master);
                $self->{model}->set($childIter, @data);
            }
            else
            {
                #No master and we are a child;
                #Create the master
                my $master = $self->{model}->append(undef);
                $self->{alreadyInserted}->{$_} = 1;
                my $masterName = $_;
                my %info = (
                            $self->{generatedField} => $masterName,
                            #$self->{collectionField} => $_,
                            isGeneratedMaster => 1
                            );
                my @masterData = $self->createRowsData(\%info, -1);
                $self->{model}->set($master, @masterData);
                #Insert the child
                my $childIter = $self->{model}->append($master);
                $self->{model}->set($childIter, @data);
            }
        }
    }

    sub getNextIter
    {
        my ($self, $iter, $indexes) = @_;
        # Return index of iter following current one in view
        my $nextIter = $self->{completeModel}->iter_next($iter);
        if (!$nextIter)
        {
            my $parentIter = $self->{completeModel}->iter_parent($iter);
            if ($parentIter)
            {
                $nextIter = $self->{completeModel}->iter_next($parentIter);
            }
            if (!$nextIter)
            {
                my $nbChildren = $self->{completeModel}->iter_n_children($parentIter);
                if ($nbChildren > 1)
                {
                    $nextIter = $self->{completeModel}->iter_nth_child(
                        $parentIter,
                        $self->{completeModel}->iter_n_children($parentIter) - 2
                    );
                }
                else
                {
                    $nextIter = $self->{completeModel}->iter_nth_child(undef, 0);
                }
            }
        }
        my $idx = $self->convertIterToIdx($nextIter);

        # If the one we got is in the list of the removed ones,
        # We don't try to get another one, but we return the 1st one
        if (GCUtils::inArrayTest($idx, @$indexes))
        {
            $nextIter = $self->{completeModel}->iter_nth_child(undef, 0);
            $idx = $self->convertIterToIdx($nextIter);
        }
        
        return ($nextIter, $idx);
    }

    sub select
    {
        my ($self, $idx, $init) = @_;
        my $currentIter;
        if ($idx == -1)
        {
            $self->{currentIterString} = '0';
            $currentIter = $self->{completeModel}->get_iter_first;
        }
        else
        {
            $self->convertIdxToIter($idx);
            $self->{currentIterString} = '0' if ! $self->{currentIterString};
            $currentIter = $self->getCurrentIterFromString;
        }
        $idx = $self->convertIterToIdx($currentIter);
        return if !$currentIter;
        if ($init)
        {
            my $parent = $self->{completeModel}->iter_parent($currentIter);
            if ($parent)
            {
                my $treePath = $self->{completeModel}->get_path($parent);
                if (!$self->{list}->row_expanded($treePath))
                {
                    $self->{currentIterString} = $self->convertIterToString($parent);
                    $idx = $self->getCurrentIdx;
                }
            }
            if ($self->{completeModel}->iter_has_child($currentIter))
            {
                $currentIter =  $self->{completeModel}->iter_children($currentIter);
                $idx = $self->convertIterToIdx($currentIter);
                $self->{currentIterString} = $self->convertIterToString($currentIter);
            }
        }
        $self->{list}->expand_to_path(Gtk2::TreePath->new($self->{currentIterString}))
            if $self->{currentIterString} =~ /:/;
        #Lock panel if we are on a master
        $self->checkLock($currentIter);
        if ($self->{list}->get_model)
        {
            $self->selectIter($currentIter);
        }
        return $idx;
    }

    sub checkLock
    {
        my ($self, $iter) = @_;
        $iter = $self->getCurrentIter if !$iter;
        if ($self->{completeModel}->iter_n_children($iter) > 0)
        {
            $self->{parent}->{panel}->lock(1);
        }
        else
        {
            $self->{parent}->{panel}->lock(0);
        }
    }
    
    sub showCurrent
    {
        my $self = shift;

        my $path = $self->{list}->get_selection->get_selected_rows;
        $self->{list}->scroll_to_cell($path) if $path;
    }

    sub changeCurrent
    {
        my ($self, $previous, $new, $idx, $wantSelect) = @_;
        my @data = ();
        my $col = 0;
        my $refilterNeeded = 0;
        my $currentIter = $self->getCurrentIterFromString;
        return $idx if !$currentIter;
        my $currentDepth = $self->{completeModel}->get_path($currentIter)->get_depth;
        my $newIdx = $idx;
        if (($currentDepth == 1)
         && $self->{completeModel}->iter_has_child($currentIter))
        {
            # We do nothing for generated masters
            return $newIdx;
        }
        $idx = $self->convertIterToIdx($currentIter);

        my $previousCollection = $self->transformValue($previous->{$self->{collectionField}}, $self->{collectionField});
        my $newCollection = $self->transformValue($new->{$self->{collectionField}}, $self->{collectionField});
        @data = $self->createRowsData($new, $idx, 1);
        # If we hide it, we select next one
        # We double the index because @data contains both values and indexes
        my $visible = $data[2 * $self->{visibleCol} + 1];
        if (! $visible)
        {
            my $nextIter;
            ($nextIter, $newIdx) = $self->getNextIter($currentIter);
            $self->selectIter($nextIter, 1) if $nextIter && $wantSelect;
            $self->{count}--;
        }

        if ($self->{groupItems})
        {
            if ($previousCollection ne $newCollection)
            {
                my $previousCollectionArray;
                my $newCollectionArray;
                #An item is integrated or moved into a collection
                #First we find its master
                my @parents;

                #Changing collection
                $previousCollectionArray = $self->transformValue($previous->{$self->{collectionField}}, $self->{collectionField}, 0, $self->{groupItems}, 0, 1);
                $newCollectionArray = $self->transformValue($new->{$self->{collectionField}}, $self->{collectionField}, 0, $self->{groupItems}, 0, 1);
                foreach my $collec(@$newCollectionArray)
                {
                    next if $collec eq '';
                    push @parents, $self->findMaster($collec);

                    if (!$parents[-1])
                    {
                        $refilterNeeded = 1;
                        #We have to create a new parent
                        #Create the master
                        $parents[-1] = $self->{model}->append(undef);
                        $self->{alreadyInserted}->{$newCollection} = 1;
                        my %info = (
                                    $self->{generatedField} => $collec,
                                    $self->{collectionField} => $newCollection,
                                    isGeneratedMaster => 1
                                    );
                        my @masterData = $self->createRowsData(\%info, -1);
                        $self->{model}->set($parents[-1], @masterData);
                    }
                    else
                    {
                        # The parent already exists
                        # Check if the child were already there
                        
                        # If it was, we remove it from parents
                        pop @parents if GCUtils::inArrayTest($collec, @$previousCollectionArray);
                    }
                }

                my $childIter = 0;
                if (!scalar @$newCollectionArray)
                {
                    $childIter = $self->{model}->append(undef);
                    $self->{model}->set($childIter, @data);
                }
                else
                {
                    foreach my $parent(@parents)
                    {
                        #First we insert it at correct position
                        my $cIter = $self->{model}->append($parent);
                        $self->{model}->set($cIter, @data);
                        # We point to the 1st one
                        $childIter = $cIter if !$childIter;
                        # Update count if needed
                        $self->refreshCount($parent, 1) if ($self->{addCount});
                    }
                }
                
                #First we store if we are removing the one that has been selected
                $self->{currentRemoved} = ($self->{selectedIterString} eq $self->{currentIterString});

                # For generated master, we could have copies of our item in many places.
                # So we need to loop on all the previous collections
                # If we have a real master, we have juste one occurrence, the current one
                if (!scalar @$previousCollectionArray)
                {
                        $self->removeInCollection(undef, $idx);
                }
                else
                {
                    foreach my $collec(@$previousCollectionArray)
                    {
                        $self->removeInCollection($collec, $idx)
                            if !GCUtils::inArrayTest($collec, @$newCollectionArray);
                    }
                }
                if ($childIter)
                {
                    my $childPath = $self->{model}->get_path($childIter);
                    $childPath = $self->convertChildPathToPath($childPath);
                    if ($childPath)
                    {
                        $self->{list}->expand_to_path($childPath);
                        $self->selectIter(
                            $self->{completeModel}->get_iter($childPath)
                        ) if $self->{currentRemoved} && $visible;
                    }
                }
            }
            else
            {
                $self->{model}->foreach(sub {
                    my ($model, $path, $iter) = @_;
                    return 0 if $idx != $self->convertChildIterToIdx($iter);
                    $model->set($iter, @data);
                    return 0;
                });
            }
        }
        else
        {
            $self->{model}->set(
                $self->convertIterToChildIter($currentIter),
                @data
            );               
        }

        # Update count for each parents only if we are not changing collection
        # Because we already did it otherwise
        if ((! $visible)
         && ($self->{groupItems})
         && ($previousCollection eq $newCollection))
        {
            my $collectionArray = $self->transformValue($new->{$self->{collectionField}},
                                                        $self->{collectionField},
                                                        0,
                                                        1,
                                                        0,
                                                        1);
            foreach my $collec(@$collectionArray)
            {
                next if $collec eq '';
                $self->refreshCount($self->findMaster($collec))
                    if ($self->{addCount});
            }
        }
        
        #my $iter = $self->{list}->get_selection->get_selected;
        my $iter = $self->getCurrentIter;
        $self->{selectedIterString} = $self->convertIterToString($iter);
        $self->{currentIterString} = $self->{selectedIterString};
        $self->showCurrent;
        $self->{filter}->refilter if $refilterNeeded;
        return $newIdx;
    }
    
}


1;
