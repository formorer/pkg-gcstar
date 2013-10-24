package GCDoubleLists;

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
use utf8;
use Gtk2;

use GCUtils;
    
{
    #Class that is used to let user select
    #item from a list and order them.
    package GCDoubleListWidget;

    use base 'Gtk2::HBox';

    sub init
    {
        my $self = shift;
        $self->setListData($self->{dataHandler}->getData) if !$self->{initialized};
        $self->{initialized} = 1;
    }
    
    sub compareItems
    {
        my ($self, $item1, $item2) = @_;
        if ($self->{withPixbuf} && (ref $item1 eq 'ARRAY'))
        {
            return $item1->[1] cmp $item2->[1];
        }
        else
        {
            return $item1 cmp $item2;
        }
    }

    sub moveFromTo
    {
        my ($self, $from, $to) = @_;
        my $fromId = ($self->{$from}->get_selected_indices)[0];
        my $fromItem = $self->{$from.'Array'}->[$fromId];
        my $fromString;
        if ($self->{withPixbuf})
        {
            $fromString = $fromItem->[1];
        }
        else
        {
            $fromString = $fromItem;
        }
        return if !$fromString;
        my $toId = ($self->{$to}->get_selected_indices)[0];
        my $toTotal = scalar @{$self->{$to.'Array'}};
        $toId = $toTotal if $toId eq '';
        $toId++ if $toId < $toTotal;
        $toId = 0 if ($toId < 0);

        if (($to eq 'unused') || (!$self->{permanent}->{$fromString}))
        {
            splice(@{$self->{$from}->{data}}, $fromId, 1);
            splice(@{$self->{$from.'Array'}}, $fromId, 1);
        }
        if (($to eq 'used') || (!$self->{permanent}->{$fromString}))
        {
            splice(@{$self->{$to}->{data}}, $toId, 0, $fromItem);
            splice(@{$self->{$to.'Array'}}, $toId, 0, $fromItem);
        }
        
        if ($to eq 'unused')
        {
            my @tmpSortedArray = sort 
                {$self->compareItems($a, $b)}
                @{$self->{unusedArray}};
            $self->{unusedArray} = \@tmpSortedArray;
            @{$self->{unused}->{data}} = ();
            my $i = 0;
            $toId = 0;
            foreach (@tmpSortedArray)
            {
                $toId = $i if $_ eq $fromString;
                my @item = ($self->{withPixbuf} ? $_ : [$_]);
                push @{$self->{unused}->{data}}, @item;
                $i++;
            }
        }
        $self->{$to}->select($toId);
        $self->{$from}->select($fromId);
        $self->{$from}->grab_focus;
    }
    
    sub moveDownUp
    {
        my ($self, $dir) = @_;
        my $currentId = ($self->{used}->get_selected_indices)[0];
        my $newId = $currentId + $dir;
        return if ($newId < 0) || ($newId >= scalar @{$self->{usedArray}});
        ($self->{usedArray}->[$currentId], $self->{usedArray}->[$newId])
         = ($self->{usedArray}->[$newId], $self->{usedArray}->[$currentId]);
        @{$self->{used}->{data}} = ();
        foreach (@{$self->{usedArray}})
        {
            if ($self->{withPixbuf})
            {
                push @{$self->{used}->{data}}, $_;               
            }
            else
            {
                push @{$self->{used}->{data}}, [$_];               
            }
        }
        $self->{used}->select($newId);
    }

    sub setListData
    {
        my ($self, $new) = @_;
        my $initial = $self->{dataHandler}->getInitData;
        $self->{initialized} = 1;
        my %tmpMap;
        if ($self->{withPixbuf})
        {
            $tmpMap{$_->[1]} = $_ foreach (@$initial);
        }
        else
        {
            $tmpMap{$_} = 1 foreach (@$initial);
        }
        $self->{usedArray} = $new;
        my $label;
        foreach (@$new)
        {
            my $label = ($self->{withPixbuf} ? $_->[1] : $_);
            delete $tmpMap{$label} if !$self->{permanent}->{$label};
        }
        my @tmpArray = sort {$self->compareItems($a, $b)} keys %tmpMap;
        if ($self->{withPixbuf})
        {
            my @unusedArray = map {$tmpMap{$_}} @tmpArray;
            $self->{unusedArray} = \@unusedArray;
        }
        else
        {
            $self->{unusedArray} = \@tmpArray;
        }
        @{$self->{unused}->{data}} = ();
        
        push @{$self->{unused}->{data}}, $_ foreach (@{$self->{unusedArray}});
        @{$self->{used}->{data}} = ();
        push @{$self->{used}->{data}}, $_ foreach (@{$self->{usedArray}});
    }

    sub setListFromIds
    {
        my ($self, $new) = @_;
        my $count = scalar(@$new) - 1;
        for my $i (0..$count)
        {
            $new->[$i] = $self->{fieldIdToName}->{$new->[$i]};
        }
        $self->setListData($new);
    }

    sub clearList
    {
        my $self = shift;
        
        $self->setListData(());
    }
    sub fillList
    {
        my $self = shift;
        my @array = grep !$self->{permanent}->{$_},
                         sort {$self->compareItems($a, $b)} @{$self->{dataHandler}->getInitData};
        $self->setListData(\@array);
    }

    sub addToPermanent
    {
        my ($self, $id) = @_;
        $self->{permanent}->{$id} = 1;
    }
            
    sub removeFromPermanent
    {
        my ($self, $id) = @_;
        delete $self->{permanent}->{$id};
    }

    sub getUsedItems
    {
        my $self = shift;
        return $self->{usedArray};
    }

    sub addBottomButtons
    {
        my ($self, $unusedButton, $usedButton) = @_;
        $self->{vboxUnused}->pack_start($unusedButton, 0, 0, 0);
        $self->{vboxUsed}->pack_start($usedButton, 0, 0, 0);
        
    }

    sub addRightButtons
    {
        my ($self, $button1, $button2) = @_;
        $self->{vboxRight}->pack_start($button1, 0, 0, $GCUtils::halfMargin);
        $self->{vboxRight}->pack_start($button2, 0, 0, $GCUtils::halfMargin);
        
    }

    sub setDataHandler
    {
        my ($self, $dataHandler) = @_;
        $self->{dataHandler} = $dataHandler;
    }

    sub new
    {
        my ($proto, $withPixbuf, $unusedLabel, $usedLabel) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new(0,0);

        bless ($self, $class);

        $self->{initialized} = 0;
        $self->{withPixbuf} = $withPixbuf;
        $self->{unusedLabel} = $unusedLabel;
        $self->{usedLabel} = $usedLabel;
        
        if ($withPixbuf)
        {
            $self->{unused} = new Gtk2::SimpleList(
                '' => 'pixbuf',
                $self->{unusedLabel} => 'text'
            );
            $self->{used} = new Gtk2::SimpleList(
                '' => 'pixbuf',
                $self->{usedLabel} => 'text'
            );
        }
        else
        {
            $self->{unused} = new Gtk2::SimpleList(
                $self->{unusedLabel} => "text"
            );
            $self->{used} = new Gtk2::SimpleList(
                $self->{usedLabel} => "text"
            );
        }
        $self->{scrollPanelUnused} = new Gtk2::ScrolledWindow;
        $self->{scrollPanelUnused}->set_policy ('never', 'automatic');
        $self->{scrollPanelUnused}->set_shadow_type('etched-in');
        $self->{scrollPanelUnused}->add($self->{unused});
        $self->{vboxUnused} = new Gtk2::VBox(0,0);
        $self->{vboxUnused}->pack_start($self->{scrollPanelUnused}, 1, 1, 0);

        my $vboxChange = new Gtk2::VBox(1,1);
        my $tmpVbox = new Gtk2::VBox(0,0);
        my $toRight = new Gtk2::Button('->');
        $toRight->remove($toRight->child);
        $toRight->add(Gtk2::Image->new_from_stock('gtk-go-forward', 'button'));
        $toRight->signal_connect('clicked' => sub {
            $self->moveFromTo('unused', 'used');
        });
        my $toLeft = new Gtk2::Button('<-');
        $toLeft->remove($toLeft->child);
        $toLeft->add(Gtk2::Image->new_from_stock('gtk-go-back', 'button'));
        $toLeft->signal_connect('clicked' => sub {
            $self->moveFromTo('used', 'unused');
        });
        $tmpVbox->pack_start($toRight,0,0,$GCUtils::margin);
        $tmpVbox->pack_start($toLeft,0,0,$GCUtils::margin);
        $vboxChange->pack_start($tmpVbox,1,0,0);
        
        $self->{scrollPanelUsed} = new Gtk2::ScrolledWindow;
        $self->{scrollPanelUsed}->set_policy ('never', 'automatic');
        $self->{scrollPanelUsed}->set_shadow_type('etched-in');
        $self->{scrollPanelUsed}->add($self->{used});
        $self->{vboxUsed} = new Gtk2::VBox(0,0);
        $self->{vboxUsed}->pack_start($self->{scrollPanelUsed}, 1, 1, 0);

        $self->{unused}->signal_connect ('row-activated' => sub {
            $self->moveFromTo('unused', 'used');
        });
        $self->{used}->signal_connect ('row-activated' => sub {
            $self->moveFromTo('used', 'unused');
        });
                     
        $self->{vboxRight} = new Gtk2::VBox(0,0);
        my $toUp = new Gtk2::Button('^');
        $toUp->remove($toUp->child);
        $toUp->add(Gtk2::Image->new_from_stock('gtk-go-up', 'button'));
        $toUp->signal_connect('clicked' => sub {
            $self->moveDownUp(-1);
        });
        my $toDown = new Gtk2::Button('_');
        $toDown->remove($toDown->child);
        $toDown->add(Gtk2::Image->new_from_stock('gtk-go-down', 'button'));
        $toDown->signal_connect('clicked' => sub {
            $self->moveDownUp(1);
        });
        $self->{vboxRight}->pack_start($toUp, 0, 0, $GCUtils::margin);
        $self->{vboxRight}->pack_start($toDown, 0, 0, $GCUtils::margin);
                    
        $self->pack_start(new Gtk2::HBox,0,0,$GCUtils::margin);
        $self->pack_start($self->{vboxUnused},1,1,$GCUtils::halfMargin);
        $self->pack_start($vboxChange,0,0,$GCUtils::halfMargin);
        $self->pack_start($self->{vboxUsed},1,1,$GCUtils::halfMargin);
        $self->pack_start($self->{vboxRight},0,0,$GCUtils::halfMargin);
        $self->pack_start(new Gtk2::HBox,0,0,$GCUtils::quarterMargin);

        $self->{scrollPanelUnused}->set_size_request(150,-1);
        $self->{scrollPanelUsed}->set_size_request(150,-1);
        
        return $self;
    }
}

{
    package GCFieldsSelectionWidget;
    
    use base 'GCDoubleListWidget';
    
    sub getInitData
    {
        my $self = shift;
        my @array;
        @array = keys %{$self->{fieldNameToId}};
        return \@array;
    }
    
    sub getData
    {
        my $self = shift;
        
        my @array;
        foreach (@{$self->{selectedFields}})
        {
            push @array, $self->{fieldIdToName}->{$_};
        }
        
        return \@array;
    }

    sub saveList
    {
        my ($self, $list) = @_;

        my @array;
        foreach (@{$list})
        {
            push @array, $self->{fieldNameToId}->{$_};
        }
        $self->{selectedFields} = \@array;
    }

    sub getSelectedIds
    {
        my $self = shift;
        $self->saveList($self->getUsedItems);
        return $self->{selectedFields};
    }

    sub loadFromFile
    {
        my $self = shift;
        my $fileDialog = new GCFileChooserDialog($self->{parent}->{lang}->{FieldsListOpen}, $self, 'open', 1);
        $fileDialog->set_filename($self->{filename});
        my $response = $fileDialog->run;
        if ($response eq 'ok')
        {
            $self->{filename} = $fileDialog->get_filename;
            open FILE, '<'.$self->{filename};
            my $model = <FILE>;
            chop $model;
            if ($model eq $self->{model}->getName)
            {
                $self->clearList;
                my @data;
                while (<FILE>)
                {
                    chop;
                    push @data, $self->{fieldIdToName}->{$_};
                }
                $self->setListData(\@data);
            }
            else
            {
                my $dialog = Gtk2::MessageDialog->new($self,
                                          [qw/modal destroy-with-parent/],
                                          'error',
                                          'ok',
                                          $self->{parent}->{lang}->{FieldsListError});
                $dialog->set_position('center-on-parent');
                $dialog->run();
                $dialog->destroy ;
            }
            close FILE;
        }        
        $fileDialog->destroy;
    }

    sub saveToFile
    {
        my $self = shift;
        my $fileDialog = new GCFileChooserDialog($self->{parent}->{lang}->{FieldsListSave}, $self, 'save', 1);
        $fileDialog->set_filename($self->{filename});
        my $response = $fileDialog->run;
        if ($response eq 'ok')
        {
            $self->{filename} = $fileDialog->get_filename;
            open FILE, '>'.$self->{filename};
            print FILE $self->{model}->getName, "\n" if $self->{model};
            foreach (@{$self->{usedArray}})
            {
                print FILE $self->{fieldNameToId}->{$_}, "\n";
            }
            close FILE;
        }        
        $fileDialog->destroy;
    }

    sub compareItems
    {
        my ($self, $item1, $item2) = @_;
        use locale;
        my @values1 = split $self->{separator}, $item1;
        my @values2 = split $self->{separator}, $item2;
        if ($values1[0] eq $values2[0])
        {
            return $values1[1] cmp $values2[1];
        }
        else
        {
            return $self->{groupsOrder}->{$values1[0]} <=> $self->{groupsOrder}->{$values2[0]};
        }
    }
    
    sub addIgnoreField
    {
        my ($self, $ignoreField) = @_;
        $self->{ignoreString} = $self->{parent}->{lang}->{FieldsListIgnore};
        $self->{fieldNameToId}->{$self->{ignoreString}} = $ignoreField;
        $self->{fieldIdToName}->{$ignoreField} = $self->{ignoreString};
        $self->addToPermanent($self->{ignoreString});
    }

    sub removeIgnoreField
    {
        my ($self) = @_;
        $self->removeFromPermanent($self->{ignoreString});
    }

    sub new
    {
        my ($proto, $parent, $preList, $isIdList, $ignoreField) = @_;

        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new(
                                0,
                                $parent->{lang}->{ImportExportFieldsUnused},
                                $parent->{lang}->{ImportExportFieldsUsed}
                            );
        bless $self, $class;
        
        $self->{parent} = $parent;
        
        $self->{ignoreField} = $ignoreField;
        $self->{lang} = $parent->{lang};
        $self->{tooltips} = Gtk2::Tooltips->new();

        $self->setDataHandler($self);
        my $fillButton = new Gtk2::Button($parent->{lang}->{ImportExportFieldsFill});
        $fillButton->set_border_width($GCUtils::margin);
        $fillButton->signal_connect('clicked' => sub {
            $self->fillList;
        });
        my $clearButton = new Gtk2::Button($parent->{lang}->{ImportExportFieldsClear});
        $clearButton->set_border_width($GCUtils::margin);
        $clearButton->signal_connect('clicked' => sub {
            $self->clearList;
        });            

        $self->addBottomButtons($fillButton, $clearButton);        
        
        my $loadButton = new Gtk2::Button('open');
        $self->{tooltips}->set_tip($loadButton,
                                   $parent->{lang}->{FieldsListOpen});
        $loadButton->remove($loadButton->child);
        $loadButton->add(Gtk2::Image->new_from_stock('gtk-open', 'button'));
        $loadButton->signal_connect('clicked' => sub {
            $self->loadFromFile;
        });
        my $saveButton = new Gtk2::Button('save');
        $self->{tooltips}->set_tip($saveButton,
                                   $parent->{lang}->{FieldsListSave});
        $saveButton->remove($saveButton->child);
        $saveButton->add(Gtk2::Image->new_from_stock('gtk-save', 'button'));
        $saveButton->signal_connect('clicked' => sub {
            $self->saveToFile;
        });            

        $self->addRightButtons($loadButton, $saveButton);        

        $self->{fieldNameToId} = {};
        $self->{groupsOrder} = {};

        my $model = $self->{parent}->{model};
        if ($model)
        {
            my $groups = $model->getGroups;
            $self->{separator} = $model->getDisplayedText('Separator');
            while (my ($key, $value) = each %{$model->{fieldsInfo}})
            {
                next if !$value->{displayed};
                my $displayed = $groups->{$value->{group}}->{displayed}
                              . $self->{separator}
                              . $value->{displayed};
                $self->{fieldNameToId}->{$displayed} = $key;
                $self->{fieldIdToName}->{$key} = $displayed;
            }
            my $order = 0;
            foreach (@{$model->{groups}})
            {
                $self->{groupsOrder}->{$groups->{$_->{id}}->{displayed}} = $order++;
            }
            $self->{model} = $model;
        }
        
        if ($preList)
        {
            $self->setListData($preList) if !$isIdList;
            $self->setListFromIds($preList) if $isIdList;
        }
        else
        {
             $self->fillList
        }
        $self->saveList(\@{$self->{usedArray}});

        return $self;
    }
}

1;
