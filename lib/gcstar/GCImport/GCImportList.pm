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
    package GCImport::GCImporterList;

    use base qw(GCImport::GCImportBaseClass);

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
        return 1;
    }
    
    sub getFilePatterns
    {
       return ();
    }
    
    sub getOptions
    {
        my $self = shift;
        
        my $pluginsList = '';
        foreach (@{$self->{model}->getPluginsNames})
        {
            my $plugin = $GCPlugins::pluginsMap{$self->{model}->getName}->{$_};
            $pluginsList .= $plugin->getName . ',';
        }
        
        
        return [
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

    sub getItemsArray
    {
        my ($self, $file) = @_;
        my @result;

        #First we try to get the correct plugin
        my $plugin = $GCPlugins::pluginsMap{$self->{model}->getName}->{$self->{options}->{plugin}};
        $plugin->{bigPics} = $self->{options}->{parent}->{options}->bigPics;

        my $titleField = $self->{model}->{commonFields}->{title};

        open ITEMS, $file;
        binmode(ITEMS, ':utf8');

        my $i = 0;

        my $resultsDialog;
        if (!$self->{options}->{first})
        {
            $resultsDialog = $self->{options}->{parent}->getDialog('Results');
            $resultsDialog->setModel($self->{model}, $self->{model}->{fieldsInfo});
            $resultsDialog->setMultipleSelection(0);
        }
        while (<ITEMS>)
        {
            chomp;
            next if ! $_;
            # $_ contains the title to search
            $plugin->{title} = $_;
            $plugin->{type} = 'load';
            $plugin->{urlField} = $self->{model}->{commonFields}->{url};
            $plugin->{searchField} = $titleField;
            #Initialize what will be pushed in the array
            my $info = {$titleField => $_};
            
            $self->{options}->{parent}->setWaitCursor($self->{options}->{lang}->{StatusSearch}.' ('.$_.')');
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
                    $resultsDialog->setList($_, @items);
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
                $info->{comment} = $self->getLang->{CommentAuto}
                                 . "\n"
                                 . $self->getLang->{CommentSite}
                                 . $plugin->getName()
                                 . "\n"
                                  . $self->getLang->{CommentTitle}
                                 . $_
                                 . "\n";

                # Add the default value
                my $defaultInfo = $self->{model}->getDefaultValues;
                foreach my $field(keys %$defaultInfo)
                {
                    next if exists $info->{$field};
                    $info->{$field} = $defaultInfo->{$field};
                }
            }
            
            push @result, $info;
            $self->{options}->{parent}->restoreCursor;            
        }
        close ITEMS;
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
