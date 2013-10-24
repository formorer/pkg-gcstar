package GCBookmarks;

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

our $bookmarksFile = 'GCbookmarks.conf';

use strict;
{
    package GCBookmarksLoader;
    
    sub new
    {
        my ($proto, $parent, $menu) = @_;
        my $class = ref($proto) || $proto;
        my $self  = {parent => $parent,
                     menu => $menu};
        bless ($self, $class);
        $self->load;
        return $self;
    }
    
    sub load
    {
        my $self = shift;
        
        open BOOKMARKS, $ENV{GCS_CONFIG_HOME}."/$bookmarksFile";
        my $xmlString = do {local $/; <BOOKMARKS>};
        close BOOKMARKS;
        $self->{menu}->clearBookmarks;
        my $bookmarks;
        if ($xmlString)
        {
            my $xs = XML::Simple->new;
            $bookmarks = $xs->XMLin($xmlString,
                                    ForceArray => ['file', 'dir'],
                                    KeyAttr => {
                                                'dir' => 'id'
                                               });
            $self->{menu}->setBookmarks($bookmarks);
        }
        $self->{bookmarks} = $bookmarks;
    }
    
    sub save
    {
        my ($self, $bookmarks) = @_;
        
        return if !$bookmarks->{file};
        $self->{bookmarks} = $bookmarks;
        my $xs = XML::Simple->new;
        my $xmlString = $xs->XMLout($bookmarks,
                                    XMLDecl => '<?xml version="1.0" encoding="UTF-8"?>',
                                    RootName => 'bookmarks');
        open BOOKMARKS, '>'.$ENV{GCS_CONFIG_HOME}."/$bookmarksFile";
        binmode(BOOKMARKS, ':utf8');
        print BOOKMARKS $xmlString;
        close BOOKMARKS;
        $self->{menu}->clearBookmarks;
        $self->{menu}->setBookmarks($bookmarks);
    }
}

{
    package GCBookmarksFolders;
    use base 'Gtk2::TreeView';

    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;

        my $self = $class->SUPER::new();
        $self->{class} = $class;
        $self->{model} = new Gtk2::TreeStore('Glib::String', 'Glib::Int');
        $self->set_model($self->{model});
        $self->{parent} = $parent;
        my $column = Gtk2::TreeViewColumn->new_with_attributes($parent->{lang}->{BookmarksFolder}, Gtk2::CellRendererText->new, 
                                                               'text' => 0, 'editable' => 1);
        $self->append_column($column);
        
        $self->signal_connect (cursor_changed => sub {
            my ($sl, $path, $column) = @_;
            my $iter = $sl->get_selection->get_selected;
            $self->{currentIdx} = ($self->{model}->get($iter))[1];
            $self->{parent}->setBookmarksList($self->{bookmarks}->[$self->{currentIdx}]);
        });

        my $targetEntryReorder = {
            target => 'text/plain',
            flags => ['same-widget'],
            info => 0,
        };
        my $targetEntryMove = {
            target => 'text/plain',
            flags => ['same-app'],
            info => 1,
        };
        
        $self->enable_model_drag_source('button1-mask','move', $targetEntryReorder, $targetEntryMove);
        $self->enable_model_drag_dest('move', $targetEntryReorder, $targetEntryMove);
        $self->signal_connect_after('drag_data_received' => \&dropHandler, $self);

        $self->signal_connect('key-press-event' => sub {
                my ($widget, $event) = @_;
                my $key = Gtk2::Gdk->keyval_name($event->keyval);
                if ($key eq 'Delete')
                {
                    $self->removeFolder;
                    return 1;
                }
                return 0;
        });

        bless($self, $class);
        return $self;
    }
    
    sub dropHandler
    {
        my ($treeview, $context, $widget_x, $widget_y, $data, $info,$time, $self) = @_;
        my $source = $context->get_source_widget;
        my ($targetPath, $targetPos) = $treeview->get_dest_row_at_pos($widget_x, $widget_y);
        return if !$targetPath;
        my $targetIter = $self->get_model->get_iter($targetPath);
        my $origIter = $source->get_selection->get_selected;
        if ($source == $self)
        {
            if (($targetPath->to_string eq $self->get_model->get_path($origIter)->to_string)
            || ($self->{model}->is_ancestor($origIter, $targetIter)))
            {
                $context->finish(1,0,$time);
                return;
            }
            my $newIter;
            my $parent;
            my $pos;
            my $ref;
            if ($targetPos =~ /^into/)
            {
                $parent = $targetIter;
                $pos = 0;
                $ref = 0;
            }
            else
            {
                $parent = $self->{model}->iter_parent($targetIter);
                $pos = ($targetPos eq 'before') ? 1 : 0;
                $ref = $targetIter;
            }
            $self->copyIter($origIter, $parent, $pos, $ref);
        }
        else
        {
            my @origData = $source->get_model->get_value($origIter);
            my $bookmark = {'name' => $origData[0], 'path' => $origData[1]};
            my $idx = ($self->{model}->get($targetIter))[1];
            push @{$self->{bookmarks}->[$idx]}, $bookmark;
            my @bookmarks;
            my $i = -1;
            my $selected = ($source->get_selected_indices)[0];
            foreach (@{$source->{data}})
            {
                $i++;
                next if $i == $selected;
                push @bookmarks, {name => $_->[0], path => $_->[1]};
            }
            $self->{bookmarks}->[$self->{currentIdx}] = \@bookmarks;
        }
        $context->finish(1,1,$time);
    }

    sub copyIter
    {
        my ($self, $iter, $parent, $pos, $ref) = @_;
        
        my @origData;
        my $i = 0;
        foreach ($self->get_model->get_value($iter))
        {
            push @origData, $i, $_;
            $i++;
        }
        my $newIter;
        if ($ref)
        {
            if ($pos)
            {
                $newIter = $self->{model}->insert_before($parent,
                                                         $ref);
            }
            else
            {
                $newIter = $self->{model}->insert_after($parent,
                                                        $ref);
            }
        }
        else
        {
            $newIter = $self->{model}->append($parent);
        }
        $self->{model}->set($newIter, @origData);
        my $childIter = $self->{model}->iter_children($iter);
        while ($childIter)
        {
            $self->copyIter($childIter, $newIter);
            $childIter = $self->{model}->iter_next($childIter);
        }
    }
    
    sub setBookmarks
    {
        my ($self, $bookmarks) = @_;
        $self->{bookmarks} = [];
        $self->{bookmarkIdx} = 0;
        $self->{currentIdx} = 0;
        $self->{model}->clear;
        $self->addBookmarksDir($bookmarks, undef);
        $self->expand_row(Gtk2::TreePath->new_from_string('0'), 0);
        $self->{parent}->setBookmarksList($self->{bookmarks}->[$self->{currentIdx}]);
    }

    sub addBookmarksDir
    {
        my ($self, $dir, $parent) = @_;
        my $name = $dir->{name};
        ($name = $self->{parent}->{lang}->{MenuBookmarks}) =~ s/_//g if !$parent;
        my @data = (0 => $name, 1 => $self->{bookmarkIdx});
        $self->{bookmarks}->[$self->{bookmarkIdx}] = $dir->{file};
        $self->{bookmarkIdx}++;
        my $newDir = $self->{model}->append($parent);
        $self->{model}->set($newDir, @data);
        foreach my $sub(@{$dir->{dir}})
        {
            $self->addBookmarksDir($sub, $newDir);
        }
    }
    
    sub addBookmark
    {
        my ($self, $path, $name) = @_;
        push(@{$self->{bookmarks}->[$self->{currentIdx}]}, {name => $name, path => $path});
    }
    
    sub addFolder
    {
        my ($self, $name) = @_;
        my @data = (0 => $name, 1 => $self->{bookmarkIdx});
        $self->{bookmarks}->[$self->{bookmarkIdx}] = [];
        $self->{bookmarkIdx}++;
        my $parent = $self->get_selection->get_selected;
        $parent ||= $self->{model}->get_iter_first;
        $self->{model}->set($self->{model}->append($parent), @data);
    }

    sub removeFolder
    {
        my $self = shift;
        my $iter = $self->get_selection->get_selected;
        $self->{model}->remove($iter);
    }
    
    sub getBookmarks
    {
        my $self = shift;
        
        my $result = {};
        $self->dumpTree($result, $self->{model}->get_iter_first, 1);
        return $result;
    }
    
    sub dumpTree
    {
        my ($self, $dir, $iter, $first) = @_;
        my @data = $self->{model}->get($iter);
        $dir->{name} = $data[0] if ! $first;
        $dir->{file} = $self->{bookmarks}->[$data[1]];
        $dir->{dir} = [];
        my $i = 0;
        my $child;
        while ($child = $self->{model}->iter_nth_child($iter, $i))
        {
            $dir->{dir}->[$i] = {};
            $self->dumpTree($dir->{dir}->[$i], $child);
            $i++;
        }
    }
    
    sub setBookmarksInCurrentFolder
    {
        my ($self, $bookmarksList) = @_;
        
        $self->{bookmarks}->[$self->{currentIdx}] = $bookmarksList;
    }
}

use GCDialogs;

{
    package GCBookmarkNewFolderDialog;
    use base 'GCModalDialog';
    
    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent,
                                       $parent->{lang}->{BookmarksNewFolder},
                                       'gtk-add',
                                      );
        bless($self, $class);
        $self->{entry} = new GCShortText;
        $self->{entry}->signal_connect('activate' => sub {$self->response('ok')} );
        my $hbox = new Gtk2::HBox(0,0);
        $hbox->pack_start($self->{entry},1,1,$GCUtils::margin);
        $self->vbox->pack_start($hbox,1,1,$GCUtils::margin);
        return $self;
    }
    
    sub show
    {
        my $self = shift;
        $self->SUPER::show();
        $self->show_all;
        $self->{entry}->grab_focus;
        my $code = $self->run;
        $self->hide;
        return ($code eq 'ok');
    }
}

{
    package GCBookmarkPropertiesDialog;
    use base 'GCModalDialog';
    
    sub new
    {
        my ($proto, $parent, $title, $okLabel) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent,
                                       $title,
                                       $okLabel,
                                      );
        bless($self, $class);

        my $table = new Gtk2::Table(2, 2);
        $table->set_row_spacings($GCUtils::halfMargin);
        $table->set_col_spacings($GCUtils::margin);
        $table->set_border_width($GCUtils::margin);
        my $labelLabel = new GCLabel($parent->{lang}->{BookmarksLabel});
        $self->{label} = new GCShortText;
        $self->{label}->signal_connect('activate' => sub {$self->response('ok')} );
        my $pathLabel = new GCLabel($parent->{lang}->{BookmarksPath});
        $self->{path} = new GCShortText;
        $self->{path}->signal_connect('activate' => sub {$self->response('ok')} );
        $table->attach($labelLabel, 0, 1, 0, 1, 'fill', 'fill', 0, 0);
        $table->attach($self->{label}, 1, 2, 0, 1, ['fill', 'expand'], 'fill', 0, 0);
        $table->attach($pathLabel, 0, 1, 1, 2, 'fill', 'fill', 0, 0);
        $table->attach($self->{path}, 1, 2, 1, 2, ['fill', 'expand'], 'fill', 0, 0);
        $self->vbox->pack_start($table, 1, 1, 0);
        $table->show_all;
        return $self;
    }
    
    sub show
    {
        my $self = shift;
        $self->SUPER::show();
        $self->show_all;
        $self->{label}->grab_focus;
        my $code = $self->run;
        $self->hide;
        return ($code eq 'ok');
    }
}


{
    package GCBookmarkAdderDialog;
    use base 'GCModalDialog';
    
    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        (my $title = $parent->{lang}->{MenuBookmarksAdd}) =~ s/_//g;
        my $self  = $class->SUPER::new($parent,
                                       $title,
                                       'gtk-add',
                                       0,
                                       $parent->{lang}->{BookmarksNewFolder} => 'yes',
                                      );
                                      
        $self->{lang} = $parent->{lang};

        my $table = new Gtk2::Table(2, 2);
        $table->set_row_spacings($GCUtils::halfMargin);
        $table->set_col_spacings($GCUtils::margin);
        $table->set_border_width($GCUtils::margin);
        my $labelLabel = new GCLabel($parent->{lang}->{BookmarksLabel});
        $self->{label} = new GCShortText;
        my $pathLabel = new GCLabel($parent->{lang}->{BookmarksPath});
        $self->{path} = new GCShortText;
        
        $table->attach($labelLabel, 0, 1, 0, 1, 'fill', 'fill', 0, 0);
        $table->attach($self->{label}, 1, 2, 0, 1, ['fill', 'expand'], 'fill', 0, 0);
        $table->attach($pathLabel, 0, 1, 1, 2, 'fill', 'fill', 0, 0);
        $table->attach($self->{path}, 1, 2, 1, 2, ['fill', 'expand'], 'fill', 0, 0);
        
        $self->{folders} = new GCBookmarksFolders($self);        
        my $scroller = new Gtk2::ScrolledWindow;
        $scroller->set_policy ('automatic', 'automatic');
        $scroller->add($self->{folders});
        $table->attach($scroller, 0, 2, 2, 3, ['fill', 'expand'], ['fill', 'expand'], 0, 0);

        $self->vbox->pack_start($table, 1, 1, 0);
        $self->set_default_size(400, 300);
        
        bless ($self, $class);
    }
    
    sub setBookmark
    {
        my ($self, $path, $label) = @_;
        $self->{path}->setValue($path);
        $self->{label}->setValue($label);
    }

    sub setBookmarksFolders
    {
        my ($self, $bookmarks) = @_;
        $self->{folders}->setBookmarks($bookmarks);
        
    }

    sub setBookmarksList
    {
    }

    sub getBookmarks
    {
        my $self = shift;
        return $self->{folders}->getBookmarks;
    }

    sub addFolder
    {
        my $self = shift;
        my $dialog = new GCBookmarkNewFolderDialog($self);
        $self->{folders}->addFolder($dialog->{entry}->getValue) if $dialog->show;
    }

    sub show
    {
        my $self = shift;
        $self->SUPER::show();
        $self->show_all;
        my $response;
        my $done = 0;
        while (!$done)
        {
            $response = $self->run;
            if ($response eq 'ok')
            {
                $self->{folders}->addBookmark($self->{path}->getValue, $self->{label}->getValue);
            }
            $self->addFolder if ($response eq 'yes');
            $done = 1 if ($response eq 'ok') || ($response eq 'cancel') || ($response eq 'delete-event');
        }
        $self->hide;
        return ($response eq 'ok');
    }
}

{
    package GCBookmarksEditDialog;
    use base 'GCModalDialog';
    
    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        (my $title = $parent->{lang}->{MenuBookmarksEdit}) =~ s/_//g;
        my $self  = $class->SUPER::new($parent,
                                       $title,
                                       'gtk-save',
                                      );
        bless ($self, $class);
                                      
        $self->{lang} = $parent->{lang};

        $self->{folders} = new GCBookmarksFolders($self);        
        my $scroller1 = new Gtk2::ScrolledWindow;
        $scroller1->set_policy ('automatic', 'automatic');
        $scroller1->set_shadow_type('etched-in');
        $scroller1->add($self->{folders});
        $self->{bookmarksList} = new Gtk2::SimpleList($parent->{lang}->{BookmarksBookmarks} => 'text',
                                                      'Path' => 'text');
        $self->{blockAddSignal} = 0;
        $self->{bookmarksList}->get_model->signal_connect('row-inserted' => sub {
            return if $self->{blockAddSignal};
            $self->saveBookmarks;
        });
        $self->{bookmarksList}->set_rules_hint(1);
        $self->{bookmarksList}->get_column(1)->set_visible(0);
        my $targetEntryMove = {
            target => 'text/plain',
            flags => ['same-app'],
            info => 14,
        };
        $self->{bookmarksList}->enable_model_drag_source('button1-mask','move', $targetEntryMove);
        $self->{bookmarksList}->signal_connect('key-press-event' => sub {
                my ($widget, $event) = @_;
                my $key = Gtk2::Gdk->keyval_name($event->keyval);
                if ($key eq 'Delete')
                {
                    $self->deleteBookmark;
                    return 1;
                }
                return 0;
        });

        my $hboxFolders = new Gtk2::HBox(0,0);
        my $vboxFolders = new Gtk2::VBox(0,0);
        my $newFolder = new Gtk2::Button->new_from_stock('gtk-new');
        $newFolder->signal_connect('clicked' => sub {
            $self->addFolder;
        });
        my $removeFolder = new Gtk2::Button->new_from_stock('gtk-delete');
        $removeFolder->signal_connect('clicked' => sub {
            $self->{folders}->removeFolder;
        });
        $vboxFolders->pack_start($newFolder,0,0,$GCUtils::halfMargin);
        $vboxFolders->pack_start($removeFolder,0,0,$GCUtils::halfMargin);
        $hboxFolders->pack_start($vboxFolders,0,0,$GCUtils::margin);
        $hboxFolders->pack_start($scroller1,1,1,0);


        my $scroller2 = new Gtk2::ScrolledWindow;
        $scroller2->set_policy ('automatic', 'automatic');
        $scroller2->set_shadow_type('etched-in');
        $scroller2->add($self->{bookmarksList});
        
        my $hboxList = new Gtk2::HBox(0,0);
        $hboxList->pack_start($scroller2,1,1,0);
        my $vboxList = new Gtk2::VBox(0,0);
        $hboxList->pack_start($vboxList,0,0,$GCUtils::margin);
        
        my $up = new Gtk2::Button->new_from_stock('gtk-go-up');
        $up->signal_connect('clicked' => sub {
            $self->moveDownUp(-1);
        });
        my $down = new Gtk2::Button->new_from_stock('gtk-go-down');
        $down->signal_connect('clicked' => sub {
            $self->moveDownUp(1);
        });
        my $edit = new Gtk2::Button->new_from_stock('gtk-edit');
        $edit->signal_connect('clicked' => sub {
            $self->edit;
        });
        my $new = new Gtk2::Button->new_from_stock('gtk-new');
        $new->signal_connect('clicked' => sub {
            $self->newBookmark;
        });
        my $delete = new Gtk2::Button->new_from_stock('gtk-delete');
        $delete->signal_connect('clicked' => sub {
            $self->deleteBookmark;
        });
        $vboxList->pack_start($up,0,0,$GCUtils::halfMargin);
        $vboxList->pack_start($down,0,0,$GCUtils::halfMargin);
        $vboxList->pack_start($edit,0,0,$GCUtils::halfMargin);
        $vboxList->pack_start($new,0,0,$GCUtils::halfMargin);
        $vboxList->pack_start($delete,0,0,$GCUtils::halfMargin);
        
        my $paned = new Gtk2::HPaned;
        $paned->pack1($hboxFolders, 1, 0);
        $paned->pack2($hboxList, 1, 0);

        $self->vbox->pack_start($paned, 1, 1, $GCUtils::margin);
        $self->set_default_size(600, 400);
        return $self;
    }
    
    sub edit
    {
        my $self = shift;
        my $currentId = ($self->{bookmarksList}->get_selected_indices)[0];
        return if (!defined($currentId)) || ($currentId < 0);
        my ($label, $path) = @{$self->{bookmarksList}->{data}->[$currentId]};
        (my $title = Gtk2::Stock->lookup('gtk-edit')->{label}) =~ s/_//;
        my $dialog = new GCBookmarkPropertiesDialog($self, $title);
        $dialog->{label}->setValue($label);
        $dialog->{path}->setValue($path);
        if ($dialog->show)
        {
            $self->{bookmarksList}->{data}->[$currentId] = [$dialog->{label}->getValue,
                                                            $dialog->{path}->getValue];
            $self->saveBookmarks;
        }
        $dialog->destroy;
    }
    
    sub newBookmark
    {
        my $self = shift;
        $self->{blockAddSignal} = 1;
        (my $title = Gtk2::Stock->lookup('gtk-new')->{label}) =~ s/_//;
        my $dialog = new GCBookmarkPropertiesDialog($self, $title, 'gtk-new');
        $dialog->{label}->clear();
        $dialog->{path}->clear();
        if ($dialog->show)
        {
            push @{$self->{bookmarksList}->{data}}, [$dialog->{label}->getValue, $dialog->{path}->getValue];
            $self->saveBookmarks;
            $self->{bookmarksList}->select($#{$self->{bookmarksList}->{data}});
        }
        $dialog->destroy;
        $self->{blockAddSignal} = 0;
    }
    
    sub deleteBookmark
    {
        my $self = shift;
        my $currentId = ($self->{bookmarksList}->get_selected_indices)[0];
        return if (!defined($currentId)) || ($currentId < 0);
        splice (@{$self->{bookmarksList}->{data}}, $currentId, 1);
        $currentId--;
        $currentId = 0 if $currentId < 0;
        $self->saveBookmarks;
        $self->{bookmarksList}->select($currentId);
    }

    sub moveDownUp
    {
        my ($self, $dir) = @_;
        $self->{blockAddSignal} = 1;
        my $currentId = ($self->{bookmarksList}->get_selected_indices)[0];
        my $newId = $currentId + $dir;
        return if ($newId < 0) || ($newId >= scalar @{$self->{bookmarksList}->{data}});
        my @data;
        foreach (@{$self->{bookmarksList}->{data}})
        {
            push @data, [$_->[0], $_->[1]];
        }
        ($data[$currentId], $data[$newId]) = ($data[$newId], $data[$currentId]);
        @{$self->{bookmarksList}->{data}} = @data;
        $self->{bookmarksList}->select($newId);
        $self->saveBookmarks;
        $self->{blockAddSignal} = 0;
    }

    sub addFolder
    {
        my $self = shift;
        my $dialog = new GCBookmarkNewFolderDialog($self);
        $self->{folders}->addFolder($dialog->{entry}->getValue) if $dialog->show;
    }

    sub setBookmarksFolders
    {
        my ($self, $bookmarks) = @_;
        
        $self->{folders}->setBookmarks($bookmarks);
        
    }

    sub setBookmarksList
    {
        my ($self, $list) = @_;
        $self->{blockAddSignal} = 1;
        @{$self->{bookmarksList}->{data}} = ();
        foreach (@$list)
        {
            push @{$self->{bookmarksList}->{data}}, [$_->{name}, $_->{path}];
        }
        $self->{blockAddSignal} = 0;
    }

    sub getBookmarks
    {
        my $self = shift;
        return $self->{folders}->getBookmarks;
    }

    sub saveBookmarks
    {
        my $self = shift;
        my @bookmarks;
        foreach (@{$self->{bookmarksList}->{data}})
        {
            push @bookmarks, {name => $_->[0], path => $_->[1]};
        }
        $self->{folders}->setBookmarksInCurrentFolder(\@bookmarks);
    }

    sub show
    {
        my $self = shift;
        $self->SUPER::show();
        $self->show_all;
        my $done = 0;
        my $response = $self->run;
        $self->hide;
        return ($response eq 'ok');
    }
}

1;
