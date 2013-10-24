package GCImport::GCImportList;

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

use GCImport::GCImportBase;

{
    package GCScannerDialog;
    use base 'GCModalDialog';
    use XML::Simple;
    
    sub new
    {
        my ($proto, $parent, $lang, $model, $serverSocket) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent,
                                       $lang->{Waiting});
        bless($self, $class);

        $self->{lang} = $lang;
        $self->{model} = $model;
        $self->{accepted} = 0;
        if ($serverSocket)
        {
            $self->{network} = 1;
            $self->{serverSocket} = $serverSocket;
        }
        my $table = new Gtk2::Table(2, 2);
        $table->set_row_spacings($GCUtils::halfMargin);
        $table->set_col_spacings($GCUtils::margin);
        $table->set_border_width($GCUtils::margin);
        $self->{previousLabel} = new GCLabel('');
        $self->{promptLabel} = new GCLabel($lang->{ScanPrompt});
        $table->attach($self->{previousLabel}, 0, 1, 0, 1, 'fill', 'fill', 0, 0);
        $table->attach($self->{promptLabel}, 0, 1, 1, 2, 'fill', 'fill', 0, 0);
        my $eanLabel = new GCLabel($lang->{EAN});
        $self->{ean} = new GCShortText;
        $self->{ean}->signal_connect('activate' => sub {$self->response('ok')} );
        if (!$self->{network})
        {
            $table->attach($eanLabel, 0, 1, 2, 3, 'fill', 'fill', 0, 0);
            $table->attach($self->{ean}, 1, 2, 2, 3, ['fill', 'expand'], 'fill', 0, 0);
        }
        $self->vbox->pack_start($table, 1, 1, 0);
        $table->show_all;
        $self->setCancelLabel($lang->{Terminate});
        $self->action_area->remove(($self->action_area->get_children)[$self->{okPosition}]);
        return $self;
    }
    
    sub setPrevious
    {
        my ($self, $previous) = @_;
        if (!$self->{first})
        {
            $self->{first} = 1;
            return;
        }
        my $label;
        if ($previous)
        {
            ($label = $self->{lang}->{Previous}) =~ s|%s|<b>$previous</b>|;
        }
        else
        {
            my $previous = $self->{previousCode};
            ($label = $self->{lang}->{NothingFound}) =~ s|%s|<b>$previous</b>|;            
        }
        $self->{previousLabel}->set_markup($label);
        $self->{promptLabel}->set_label($self->{lang}->{ScanOtherPrompt});
    }
    
    sub readSocket
    {
        my ($self) = @_;
        Glib::Source->remove($self->{socketWatch});
        my $socket = $self->{socket};
        my $line = <$socket>;
        $self->response('cancel') if !$line;
        my $xs = XML::Simple->new;
        my $scan = $xs->XMLin($line);
        my $code = $scan->{scan}->{content};
        $code = $self->eanToIsbn($code)
            if $self->{model} eq 'GCbooks';
        $self->{ean}->setValue($code);
        $self->{previousCode} = $code;
        $self->response('ok');
    }
    
    sub waitForCode
    {
        my $self = shift;
        $self->{socketWatch} = Glib::IO->add_watch($self->{socket}->fileno,
          'in',
          sub {
              $self->readSocket;
          });
    }

    sub eanToIsbn
    {
        my ($self, $code) = @_;
        return $code if $code !~ /978(\d{9})/;
        my $sub = $1;
        my $multiplier = 1;
        my $checkSum = 0;
        foreach (split(//, $sub))
        {
            $checkSum += $_ * $multiplier++;
        }
        $checkSum %= 11;
        $checkSum = 'X' if $checkSum == 10;
        return $sub.$checkSum;
    }

    sub show
    {
        my $self = shift;
        $self->SUPER::show();
        $self->show_all;
        $self->showMe;
        if ($self->{network})
        {
            if (!$self->{accepted})
            {
                $self->{serverWatch} = Glib::IO->add_watch($self->{serverSocket}->fileno,
                    'in',
                    sub {
                        $self->{socket} = $self->{serverSocket}->accept;
                        $self->{accepted} = 1;
                        $self->waitForCode;
                    });
            }
            else
            {
                $self->waitForCode;
            }
        }
        else
        {
            $self->{ean}->setValue('');
            $self->{ean}->grab_focus;
        }
        my $code = $self->run;
        $self->hide;
        return $self->{ean}->getValue if $code eq 'ok';
        $self->{socket}->close;
        return undef;
    }
}

{
    package GCImport::GCImporterScanner;

    use base qw(GCImport::GCImportBaseClass);

    use IO::Socket; 
    use GCPlugins;

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        
        bless ($self, $class);
        return $self;
    }

    sub wantsFieldsSelection
    {
        return 0;
    }

    sub wantsFileSelection
    {
        return 0;
    }
    
    sub hideFileSelection
    {
        return 1;
    }
    
    sub getFilePatterns
    {
       return ();
    }
    
    sub checkPortField
    {
        my ($self, $data) = @_;
        my ($parent, $list) = @{$data};
        my $model = $list->getValue ;
        $parent->{options}->{port}->set_sensitive($model eq 'Network');
    }

    sub getOptions
    {
        my $self = shift;
        
        my $pluginsList = '';
        foreach (@{$self->{model}->getPluginsNames})
        {
            my $plugin = $GCPlugins::pluginsMap{$self->{model}->getName}->{$_};
            $pluginsList .= $plugin->getName . ','
                if $plugin->getEanField;
        }
        
        
        return [
            {
                name => 'type',
                type => 'options',
                label => 'Type',
                valuesList => 'Local,Network',
                default => 'Local',
                changedCallback => sub {shift; $self->checkPortField(@_)},
            },
                      
    	    {
                name => 'port',
                type => 'number',
                label => 'Port',
                default => 50007,
                min => 1024,
                max => 65536,
            },   

            {
                name => 'plugin',
                type => 'options',
                label => 'Plugin',
                valuesList => $pluginsList
            },

            {
                name => 'first',
                type => 'yesno',
                label => 'UseFirst',
                default => '1'
            },
        ];
    }
      
    sub getModelName
    {
        my $self = shift;
        return $self->{model}->getName;
    }

    sub getBarCode
    {
        my ($self, $previous) = @_;
        #my $dialog = new 
        $self->{dialog}->setPrevious($previous);
        return $self->{dialog}->show;
    }

    sub getItemsArray
    {
        my ($self, $file) = @_;
        my @result;
        
        #First we try to get the correct plugin
        my $plugin = $GCPlugins::pluginsMap{$self->{model}->getName}->{$self->{options}->{plugin}};
        $plugin->{bigPics} = $self->{options}->{parent}->{options}->bigPics;

        my $titleField = $self->{model}->{commonFields}->{title};
        my $searchField = $plugin->getEanField;

        my $i = 0;

        my $resultsDialog;
        if (!$self->{options}->{first})
        {
            $resultsDialog = $self->{options}->{parent}->getDialog('Results');
            $resultsDialog->setModel($self->{model}, $self->{model}->{fieldsInfo});
            $resultsDialog->setMultipleSelection(0);
        }
        my $search;
        
        my $socket;
        if ($self->{options}->{type} eq 'Network')
        {
            $socket = new IO::Socket::INET(
                LocalPort => $self->{options}->{port},
                Proto => 'tcp',
                Listen => 1,
                Reuse => 1
            ); 
        }
        
        $self->{dialog} = new GCScannerDialog($self->{options}->{parent},
                                              $self->getLang,
                                              $self->{model}->getName,
                                              $socket);
        my $previous = '';
        while ($search = $self->getBarCode($previous))
        {
            chomp $search;
            next if ! $search;
            # $_ contains the title to search
            $plugin->{title} = $search;
            $plugin->{type} = 'load';
            $plugin->{urlField} = $self->{model}->{commonFields}->{url};
            $plugin->{searchField} = $searchField;
            #Initialize what will be pushed in the array
            my $info = {$searchField => $search};
            
            $self->{options}->{parent}->setWaitCursor($self->{options}->{lang}->{StatusSearch}.' ('.$search.')');
            $plugin->load;

            my $itemNumber = $plugin->getItemsNumber;

            if ($itemNumber != 0)
            {
                $plugin->{type} = 'info';
                if (($itemNumber == 1) || ($self->{options}->{first}))
                {
                    $plugin->{wantedIdx} = 0;
                }
                else
                {
                    my $withNext = 0;
                    my @items = $plugin->getItems;
                    $resultsDialog->setWithNext(0);
                    $resultsDialog->setSearchPlugin($plugin);
                    $resultsDialog->setList($search);
                    $resultsDialog->show;
                    if ($resultsDialog->{validated})
                    {
                        $plugin->{wantedIdx} = $resultsDialog->getItemsIndexes->[0];
                    }
                }
                $info = $plugin->getItemInfo;
                my $title = $info->{$titleField};
                $self->{options}->{parent}->{defaultPictureSuffix} = $plugin->getDefaultPictureSuffix;
                foreach my $field(@{$self->{model}->{managedImages}})
                {
                    $info->{$field} = '' if $info->{$field} eq 'empty';
                    next if !$info->{$field};
                    ($info->{$field}) = $self->{options}->{parent}->downloadPicture($info->{$field}, $title);
                }

                # Add the default value
                my $defaultInfo = $self->{model}->getDefaultValues;
                foreach my $field(keys %$defaultInfo)
                {
                    next if exists $info->{$field};
                    $info->{$field} = $defaultInfo->{$field};
                }
            }
            $previous = $info->{$titleField};
            push @result, $info;
            $self->{options}->{parent}->restoreCursor;            
        }
        $socket->close if $socket;
        return \@result;
    }
    
    
    sub getEndInfo
    {
        my $self = shift;
        my $message;
        return $message;
    }
}


1;
