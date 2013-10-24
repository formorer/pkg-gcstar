package GCBorrowings;

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
use GCDialogs;
use GCUtils;

{
    package GCImportBorrowersDialog;
    use base 'GCModalDialog';

    use XML::Simple;

    sub importClaws
    {
        my ($self, $file) = @_;
        my @result;
        open XML, $file;
        my $xmlString = do {local $/; <XML>};
        close XML;
        my $xs = XML::Simple->new;
        my $addressBook = $xs->XMLin($xmlString,
                                     ForceArray => ['address', 'person']
                                    );
        foreach (@{$addressBook->{person}})
        {
            push @result, [$_->{cn}, $_->{'address-list'}->{address}->[0]->{email}];
        }
        return \@result;
    }

    sub importLdif
    {
        my ($self, $file) = @_;
        my @result;
        open DATA, $file;
        my %current;
        while (<DATA>)
        {
            if (/^dn/)
            {
                push @result, [$current{name}, $current{email}] if %current;
                %current = {};
            }
            $current{name} = $1 if (/^cn:\s*(.*)$/);
            $current{email} = $1 if (/^mail:\s*(.*)$/);
        }
        close DATA;
        push @result, [$current{name}, $current{email}] if %current;
        return \@result;
    }

    sub importVcard
    {
        my ($self, $file) = @_;
        my @result;
        open DATA, $file;
        my %current;
        while (<DATA>)
        {
            push @result, [$current{name}, $current{email}] if /^END:VCARD/i;
            $current{name} = $1 if (/^FN:(.*)$/i);
            $current{email} = $1 if (/^EMAIL;INTERNET:(.*)$/);
        }
        close DATA;
        return \@result;
    }

    sub show
    {
        my $self = shift;
        $self->SUPER::show();
        $self->show_all;
        $self->set_position('center');
        my $done = 0;
        my $code;
        while (!$done)
        {
            $code = $self->run;
            if ($code ne 'ok')
            {
                $done = 1;
            }
            else
            {
                my $type = $self->{type}->getValue;
                my $file = $self->{file}->getValue;
                if (!$file)
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
                if ($type eq 'claws')
                {
                    $self->{borrowers} = $self->importClaws($file);
                }
                elsif ($type eq 'ldif')
                {
                    $self->{borrowers} = $self->importLdif($file);
                }
                elsif ($type eq 'vcard')
                {
                    $self->{borrowers} = $self->importVcard($file);
                }
                $done = 1;
            }
        }
        $self->hide;
        return ($code eq 'ok');
    }

    sub getBorrowers
    {
        my $self = shift;
        return $self->{borrowers};
    }

    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent,
                                       $parent->{lang}->{BorrowersImportTitle},
                                       'gtk-convert'
                                      );
        bless ($self, $class);
        $self->{parent} = $parent;
        $self->{lang} = $parent->{lang};

        my $table = new Gtk2::Table(2,2,0);
        $table->set_row_spacings($GCUtils::halfMargin);
        $table->set_col_spacings($GCUtils::halfMargin);
        $table->set_border_width($GCUtils::margin);

        my $typeLabel = new GCLabel($parent->{lang}->{BorrowersImportType});
        $self->{type} = new GCMenuList;
        $self->{type}->setValues([
            {value => 'ldif', displayed => 'LDIF'},
            {value => 'claws', displayed => 'Claws Mail'},
            {value => 'vcard', displayed => 'VCARD'},
        ]);
        my $fileLabel = new GCLabel($parent->{lang}->{BorrowersImportFile});
        $self->{file} = new GCFile($self);

        $table->attach($typeLabel, 0, 1, 0, 1, 'fill', 'fill', 0, 0);
        $table->attach($self->{type}, 1, 2, 0, 1, ['expand', 'fill'], 'fill', 0, 0);
        $table->attach($fileLabel, 0, 1, 1, 2, 'fill', 'fill', 0, 0);
        $table->attach($self->{file}, 1, 2, 1, 2, ['expand', 'fill'], 'fill', 0, 0);

        $self->vbox->pack_start($table, 1, 1, 0);

        return $self;
    }
}

{
    package GCBorrowersDialog;
    use base 'GCModalDialog';

    sub initValues
    {
        use locale;
        
        my $self = shift;
        my $keepPrevious = shift;

        my @borrowers;
        my @emails;

        if ($keepPrevious)
        {
            foreach my $line(@{$self->{people}->{data}})
            {
                push @borrowers, $line->[0];
                push @emails, $line->[1];
            }
        }
        else
        {
            @borrowers = split m/\|/, $self->{options}->borrowers;
            @emails = split m/\|/, $self->{options}->emails;
        }
        
        @{$self->{people}->{data}} = ();
        my %directory;
        
        for (my $i = 0; $i < scalar(@borrowers); $i++)
        {
            $directory{$borrowers[$i]} = $emails[$i];
        }
        
        my @keys = sort keys %directory;
        @keys = reverse @keys if $self->{reverse};
        foreach (@keys)
        {
            my @infos = [$_, $directory{$_}];
            push @{$self->{people}->{data}}, @infos;
        }
        $self->{people}->select(0);
        
        (my $template = $self->{options}->template) =~ s|<br/>|\n|g;
        $self->{mailTemplate}->setValue($template);
        
        $self->{subject}->set_text($self->{options}->subject);
   }
    
   sub saveValues
   {
        my $self = shift;
       
        my $borrowers = '';
        my $emails = '';
        foreach (@{$self->{people}->{data}})
        {
            $borrowers .= $_->[0].'|';
            $emails .= $_->[1].'|';
        }
        $borrowers =~ s/.$//;
        $emails =~ s/.$//;
        $self->{options}->borrowers($borrowers);
        $self->{options}->emails($emails);
        
        (my $template = $self->{mailTemplate}->getValue) =~ s/\n/<br\/>/g;
        $self->{options}->template($template);
 
        $self->{options}->subject($self->{subject}->get_text);
        
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

    sub importBorrowers
    {
        my $self = shift;
        
        $self->{importDialog} = new GCImportBorrowersDialog($self)
            if ! $self->{importDialog};
            
        if ($self->{importDialog}->show)
        {
            unshift @{$self->{people}->{data}}, @{$self->{importDialog}->getBorrowers};
        }
    }

    sub removeCurrent
    {
        my $self = shift;
        my @idx = $self->{people}->get_selected_indices;
                
        if ($^O =~ /win32/i)
        {
            my @newData;
            my $i = 0;
            foreach (@{$self->{people}->{data}})
            {
                push @newData, [$_->[0], $_->[1]] if $i != $idx[0];
                $i++;
            }
            @{$self->{people}->{data}} = @newData;
        }
        else
        {
            splice @{$self->{people}->{data}}, $idx[0], 1;
        }
    }
    
    sub add
    {
        my $self = shift;
        
        my $dialog = new Gtk2::Dialog($self->{parent}->{lang}->{BorrowersAdd},
                                                        $self,
                                                        [qw/modal destroy-with-parent/],
                                                        @GCDialogs::okCancelButtons
                                                    );
        
        my $table = new Gtk2::Table(2,2,0);
                                                    
        my $labelName = new Gtk2::Label($self->{parent}->{lang}->{BorrowersName});
        $table->attach($labelName, 0, 1, 0, 1, 'expand', 'fill', 5, 5);
        my $name = new Gtk2::Entry;
        $name->signal_connect('activate' => sub {$dialog->response('ok')});
        $table->attach($name, 1, 2, 0, 1, 'expand', 'fill', 5, 5);
 
        my $labelEmail = new Gtk2::Label($self->{parent}->{lang}->{BorrowersEmail});
        $table->attach($labelEmail, 0, 1, 1, 2, 'expand', 'fill', 5, 5);
        my $email = new Gtk2::Entry;
        $email->signal_connect('activate' => sub {$dialog->response('ok')});
        $table->attach($email, 1, 2, 1, 2, 'expand', 'fill', 5, 5);
       
        $dialog->vbox->pack_start($table,1,1,0);
        $dialog->vbox->show_all;
                                                    
        if ($dialog->run eq 'ok')
        {
            unshift @{$self->{people}->{data}}, [$name->get_text, $email->get_text];
        }
        
        $dialog->destroy;
    }
    
    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent,
                                       $parent->{lang}->{BorrowersTitle},
                                      );

        bless ($self, $class);
 
        #$self->set_modal(1);
		$self->set_position('center');
        $self->set_default_size(400,400);

        $self->{reverse} = 0;

        $self->{parent} = $parent;
        $self->{lang} = $parent->{lang};
        $self->{options} = $parent->{options};

        my $borrowersFrame = new GCGroup($self->{parent}->{lang}->{BorrowersList});
        my $hbox = new Gtk2::HBox(0,0);
        
        $self->{people} = new Gtk2::SimpleList($parent->{lang}->{BorrowersName} => "text",
                                                $parent->{lang}->{BorrowersEmail} => "text");
        $self->{people}->set_column_editable(1, 1);
        $self->{people}->set_rules_hint(1);

        $self->{people}->get_column(0)->set_sort_column_id(0);
        $self->{people}->get_model->set_sort_column_id(0, 'ascending');

        for my $i (0..1)
        {
            $self->{people}->get_column($i)->set_resizable(1);
        }
        $self->{order} = 1;
        $self->{sort} = -1;

        my $scrollPanelList = new Gtk2::ScrolledWindow;
        $scrollPanelList->set_policy ('never', 'automatic');
        $scrollPanelList->set_shadow_type('etched-in');
        $scrollPanelList->set_border_width(0);
        $scrollPanelList->add($self->{people});
        
        my $vboxButtons = new Gtk2::VBox(0,0);
        my $addButton = Gtk2::Button->new_from_stock('gtk-add');
        $addButton->signal_connect('clicked' => sub {
                $self->add;
            });
        my $removeButton = Gtk2::Button->new_from_stock('gtk-remove');
        $removeButton->signal_connect('clicked' => sub {
                $self->removeCurrent;
            });
            
        my $importButton = Gtk2::Button->new_from_stock('gtk-convert');
        $importButton->signal_connect('clicked' => sub {
                $self->importBorrowers;
            });
            
        #my $editButton = new Gtk2::Button($parent->{lang}->{BorrowersEdit});
        $vboxButtons->pack_start($addButton,0,0,$GCUtils::halfMargin);
        $vboxButtons->pack_start($removeButton,0,0,$GCUtils::halfMargin);
        $vboxButtons->pack_start($importButton,0,0,$GCUtils::halfMargin);
        #$vboxButtons->pack_start($editButton,0,0,0);
       
        $hbox->pack_start($scrollPanelList,1,1,0);
        $hbox->pack_start($vboxButtons,0,0,$GCUtils::margin);
        $hbox->set_border_width(0);
        $borrowersFrame->addWidget($hbox);
        $self->vbox->pack_start($borrowersFrame,1,1,0);

        my $templateFrame = new GCGroup($self->{parent}->{lang}->{BorrowersTemplate});
        my $templateBox = new Gtk2::VBox(0,0);
        $templateFrame->addWidget($templateBox);

        $self->{mailTemplate} = new GCLongText;
        $self->{mailTemplate}->set_size_request(-1,80);

        my $hboxSubject = new Gtk2::HBox(0,0);
        my $labelSubject = new Gtk2::Label($self->{parent}->{lang}->{BorrowersSubject});
        $self->{subject} = new Gtk2::Entry;
        $hboxSubject->pack_start($labelSubject,0,0,0);
        $hboxSubject->pack_start($self->{subject},0,0,$GCUtils::halfMargin);
        

#        $templateBox->pack_start($labelTemplate,0,0,$GCUtils::halfMargin);
        $templateBox->pack_start($hboxSubject,0,0,0);
        $templateBox->pack_start($self->{mailTemplate},1,1,$GCUtils::halfMargin);
        
        my $label1 = new Gtk2::Label($self->{parent}->{lang}->{BorrowersNotice1});
        $label1->set_alignment(0,0);
        my $label2 = new Gtk2::Label($self->{parent}->{lang}->{BorrowersNotice2});
        $label2->set_alignment(0,0);
        my $label3 = new Gtk2::Label($self->{parent}->{lang}->{BorrowersNotice3});
        $label3->set_alignment(0,0);
        $templateBox->pack_start($label1,0,0,0);
        $templateBox->pack_start($label2,0,0,0);
        $templateBox->pack_start($label3,0,0,0);
        
        $self->vbox->pack_start($templateFrame, 1, 1, 0);
        
        return $self;
    }
    
}

{
    package GCBorrowedDialog;
    use base "Gtk2::Dialog";

    sub setList
    {
        my ($self, $data, $model) = @_;

        $self->setModel($model);
        my $items = $data->getItemsListFiltered;
        $self->{data} = $data;
 
        $self->{itemsList} = [];
        $self->{listModel}->clear;
        my ($listId, $dataId) = (-1, -1);
        foreach (@{$items})
        {
            $dataId++;
            next if (!$_->{$self->{borrowerField}}) || ($_->{$self->{borrowerField}} eq 'none');
            $listId++;
            my $borrower = $_->{$self->{borrowerField}};
            $borrower = $self->{parent}->{model}->getDisplayedText('PanelUnknown')
                if $borrower eq 'unknown';
            my $lendDate = GCUtils::timeToStr($_->{$self->{lendDateField}},
                                              $self->{parent}->{options}->dateFormat);
            push @{$self->{itemsList}}, {
                $self->{titleField} => $_->{$self->{titleField}},
                $self->{borrowerField} => $borrower,
                $self->{lendDateField} => $_->{$self->{lendDateField}}
            };
            $self->{listModel}->set($self->{listModel}->append,
                                    0 => $_->{$self->{titleField}},
                                    1 => $borrower,
                                    2 => $lendDate,
                                    3 => $listId,
                                    4 => $dataId);
        }
        
        $self->{listView}->columns_autosize;
        return if $listId == -1;
        $self->{listView}->get_selection->select_iter($self->{listModel}->get_iter_first);
    }
    
    sub show
    {
        my $self = shift;

        $self->SUPER::show();
        $self->show_all;
        $self->run;
        $self->hide;
    }

    sub setModel
    {
        my ($self, $model) = @_;
        $self->{titleField} = $model->{commonFields}->{title};
        $self->{borrowerField} = $model->{commonFields}->{borrower}->{name};
        $self->{lendDateField} = $model->{commonFields}->{borrower}->{date};
        $self->{historyField} = $model->{commonFields}->{borrower}->{history};
 
        $self->{titleColumn}->set_title($model->getDisplayedItems);
    }

    sub displayItem
    {
        my ($self, $idx) = @_;
        $self->{data}->display($idx);
        $self->{data}->select($idx);
    }

    sub returnItem
    {
        my $self = shift;
        my $current = $self->{data}->getCurrent;
        my $iter = $self->{listView}->get_selection->get_selected;
        my $idx = $self->{listModel}->get($iter, 4);
        $self->displayItem($idx);
        if ($self->{data}->{panel}->itemBack)
        {
            $self->{listModel}->remove($iter);
        }
        $self->displayItem($current);
        return;
    }

    sub showHistory
    {
        my $self = shift;
        my $iter = $self->{listView}->get_selection->get_selected;
        return if !$iter;
        my $idx = $self->{listModel}->get($iter, 4);
        $self->{history}->setValue(
            $self->{data}->getValue($idx, $self->{historyField})
        );
    }

    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent->{lang}->{BorrowedTitle},
                              $parent,
                              [qw/modal destroy-with-parent/],
                              'gtk-ok' => 'ok'
                            );

        bless ($self, $class);
        
        $self->{parent} = $parent;

        $self->set_modal(1);
        $self->set_position('center');
        $self->set_default_size(400,400);

        $self->{parent} = $parent;
        $self->{options} = $parent->{options};

        my $hbox = new Gtk2::HBox(0,0);
        
        $self->{listModel} = new Gtk2::ListStore('Glib::String', 'Glib::String', 'Glib::String',
                                                 'Glib::Int', 'Glib::Int');
        $self->{listView} = Gtk2::TreeView->new_with_model($self->{listModel});
        $self->{listView}->set_rules_hint(1);
        $self->{listView}->set_headers_clickable(1);

        my @columns;
        push @columns, Gtk2::TreeViewColumn->new_with_attributes('',
                                                                 Gtk2::CellRendererText->new, 
                                                                 'text' => 0);
        push @columns, Gtk2::TreeViewColumn->new_with_attributes($parent->{lang}->{PanelBorrower},
                                                                 Gtk2::CellRendererText->new, 
                                                                 'text' => 1);
        push @columns, Gtk2::TreeViewColumn->new_with_attributes($parent->{lang}->{BorrowedDate},
                                                                 Gtk2::CellRendererText->new, 
                                                                 'text' => 2);
        $self->{titleColumn} = $columns[0];
        for my $i (0..2)
        {
            $columns[$i]->set_resizable(1);
            $columns[$i]->set_sort_column_id($i);
            $columns[$i]->set_reorderable(1);
            $self->{listView}->append_column($columns[$i]);
        }
        $self->{listModel}->set_sort_func(2, sub {
            my ($model, $a, $b) = @_;
            my ($day, $month, $year) = split m/\//, 
                $self->{itemsList}->[$model->get($a, 3)]->{$self->{lendDateField}};
            my $dateA = join "_", $year, $month, $day;
            ($day, $month, $year) = split m/\//, 
                $self->{itemsList}->[$model->get($b, 3)]->{$self->{lendDateField}};
            my $dateB = join "_", $year, $month, $day;
            return $dateA cmp $dateB;
            
        });

        $self->{listView}->get_selection->signal_connect ('changed' => sub {
            $self->showHistory;
        });

        my $scrollPanelList = new Gtk2::ScrolledWindow;
        $scrollPanelList->set_policy ('never', 'automatic');
        $scrollPanelList->set_shadow_type('etched-in');
        $scrollPanelList->set_border_width($GCUtils::margin);
        $scrollPanelList->add($self->{listView});

        $self->{context} = new Gtk2::Menu;
        $self->{returned} = Gtk2::MenuItem->new($parent->{lang}->{PanelReturned});
        $self->{returned}->signal_connect('activate', sub {
            $self->returnItem;
        });
        $self->{context}->append($self->{returned});
        $self->{display} = Gtk2::MenuItem->new($parent->{lang}->{BorrowedDisplayInPanel});
        $self->{display}->signal_connect('activate', sub {
            my $iter = $self->{listView}->get_selection->get_selected;
            my $idx = $self->{listModel}->get($iter, 4);
            $self->displayItem($idx);
        });
        $self->{context}->append($self->{display});
        $self->{context}->show_all;

        $self->{listView}->signal_connect('button_press_event' => sub {
            my ($widget, $event) = @_;
            return 0 if $event->button ne 3;
            $self->{context}->popup(undef, undef, undef, undef, $event->button, $event->time);
            return 0;
        });

        my $historyExpander = new GCExpander($parent->{lang}->{PanelHistory});
        $historyExpander->setValue($parent->{lang}->{PanelHistory});

        my @labels = ($parent->{lang}->{PanelBorrower},
                      $parent->{lang}->{PanelLendDate},
                      $parent->{lang}->{PanelReturnDate});
        $self->{history} = new GCMultipleList($self, 3, \@labels, 0, 2);

        my $historyBox = new Gtk2::VBox(0,0);
        $historyBox->set_border_width($GCUtils::margin);
        $historyBox->pack_start($self->{history}, 1, 1, 0);

        $historyExpander->add($historyBox);
        $historyExpander->show_all;

        $self->vbox->pack_start($scrollPanelList,1,1,0);
        $self->vbox->pack_start($historyExpander,0,0, $GCUtils::halfMargin);
 
        return $self;
    }
}

1;
