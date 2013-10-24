package GCImport::GCImportCSV;

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
use utf8;

use GCImport::GCImportBase;

{
    package GCImport::GCImporterCSV;

    use base qw(GCImport::GCImportBaseClass);
    use Encode;

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
        return 1;
    }

    sub wantsIgnoreField
    {
        return 1;
    }

    sub wantsFileSelection
    {
        return 1;
    }
    
    sub getName
    {
        my $self = shift;
        
        return "CSV";
    }
    
    sub getFilePatterns
    {
       return (['CSV (*.csv)', '*.csv']);
    }
    
    sub getOptions
    {
        my $self = shift;

        my $charsets = '';
        my @charsetList = Encode->encodings(':all');
        foreach (@charsetList)
        {
            $charsets .= $_.',';
        }

        my $pluginsList = $self->{model}->{parent}->{lang}->{PluginDisabled}.',';
        foreach (@{$self->{model}->getPluginsNames})
        {
            my $plugin = $GCPlugins::pluginsMap{$self->{model}->getName}->{$_};
            $pluginsList .= $plugin->getName . ',';
        }
        
        my $searchFieldsList;
        foreach (@{$self->{model}->getSearchFields})
        {
            $searchFieldsList->{$_} = $self->{model}->getDisplayedText($self->{model}->{fieldsInfo}->{$_}->{label});
        }
 
        return [
            {
                name => 'sep',
                type => 'short text',
                label => 'Separator',
                default => ';'
            },

            {
                name => 'charset',
                type => 'options',
                label => 'Charset',
                valuesList => $charsets,
                default => 'utf8',
            },

            {
                name => 'withHeader',
                type => 'yesno',
                label => 'Header',
                default => '1'
            },
            
            {
                name => 'plugin',
                type => 'options',
                label => 'Plugin',
                valuesList => $pluginsList
            },
            
            {
                name => 'searchfield',
                type => 'options',
                label => 'SearchField',
                valuesList => $searchFieldsList,
                default => $self->{model}->{commonFields}->{title}
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
        
        # First we try to get the correct plugin
        my $plugin;
        my $titleField;
        my $pluginEnabled;
        $pluginEnabled = 1 if $self->{options}->{plugin}
                          && ($self->{options}->{plugin} ne $self->{options}->{lang}->{PluginDisabled});
        if ($pluginEnabled)
        {
            $plugin = $GCPlugins::pluginsMap{$self->{model}->getName}->{$self->{options}->{plugin}};
            $titleField = $self->{options}->{searchfield};
            
             # Force values of search field if it's incompatible with current plugin
            my $compatible = 1;
            $compatible = grep /^$titleField$/, @{$plugin->getSearchFieldsArray}
                if $titleField;
            if (!$compatible)
            {
                # If it is not, we use the 1st compatible one
                $titleField = $plugin->getSearchFieldsArray->[0];
            }

        }

        open ITEMS, $file;
        binmode(ITEMS, ':utf8')
            if $self->{options}->{charset} eq 'utf8';;

        my $sep = $self->{options}->{sep};
        my $ignoreFirstLine = $self->{options}->{withHeader};

        my $resultsDialog;
        if ((!$self->{options}->{first}) && ($pluginEnabled))
        {
            $resultsDialog = $self->{options}->{parent}->getDialog('Results');
            $resultsDialog->setModel($self->{model}, $self->{model}->{fieldsInfo});
            $resultsDialog->setMultipleSelection(0);
        }
        
        my $i = 0;

        while (<ITEMS>)
        {
            if ($ignoreFirstLine)
            {
                $ignoreFirstLine = 0;
                next;
            }
        
            chomp;
            # Special characters are escaped
            my @values =  split m/\Q$sep\E/;

            $result[$i] = {} if (!$pluginEnabled);
            
            my $j = 0;
            my $searchTitle = '';
            foreach (@{$self->{options}->{fields}})
            {
                $values[$j] = decode($self->{options}->{charset}, $values[$j])
                    if $self->{options}->{charset} ne 'utf8';
                $result[$i]->{$_} = $values[$j] if (!$pluginEnabled);
                $searchTitle = $values[$j] if (($_ eq $titleField) && ($pluginEnabled));
                $j++;
            }
	        
	        if (($pluginEnabled) && ($searchTitle ne ''))
	        {
                $plugin->{title} = $searchTitle;
                $plugin->{type} = 'load';
                $plugin->{urlField} = $self->{model}->{commonFields}->{url};
                $plugin->{searchField} = $titleField;

                #Initialize what will be pushed in the array
                my $info = {$titleField => $searchTitle};
                
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
                    my $j = 0;
                    foreach (@{$self->{options}->{fields}})
                    {
                        $values[$j] = decode($self->{options}->{charset}, $values[$j])
                            if $self->{options}->{charset} ne 'utf8';
                        $info->{$_} = $values[$j];
                        $j++;
                    }
                }
                
                push @result, $info;
                $self->{options}->{parent}->restoreCursor;  
            }	    
	    
            $i++;
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
