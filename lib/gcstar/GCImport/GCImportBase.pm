package GCImport::GCImportBase;

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
use GCExportImport;

{
    package GCImport::GCImportBaseClass;

    use base 'GCExportImportBase';
    use File::Basename;
    use File::Copy;
    
    #Methods to be overriden in specific classes
    
    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new;

        $self->{parsingError} = '';
        $self->{modelAlreadySet} = 0;

        bless ($self, $class);
        return $self;
    }

    sub getFilePatterns
    {
       return (['*.*', '*.*']);
    }

    sub getSuffix
    {
        my $self = shift;
        return '' if ! ($self->getFilePatterns)[0];
        (my $pattern = ($self->getFilePatterns)[0]->[1]) =~ s/.*?([[:alnum:]]+)/$1/;
        return $pattern;
    }

    #Return supported models name
    sub getModels
    {
        return [];
    }

    #Return current model name
    sub getModelName
    {
        return 'GCfilms';
    }

    sub getOptions
    {
    }
    
    sub wantsFieldsSelection
    {
        return 0;
    }

    sub wantsIgnoreField
    {
        return 0;
    }

    sub wantsImagesSelection
    {
        return 0;
    }
    
    sub wantsFileSelection
    {
        return 1;
    }
    
    sub wantsDirectorySelection
    {
        return 0;
    }
    
    # Returns true if the module should be hidden from
    # the menu when a collection of an incompatible kind is open.
    sub shouldBeHidden
    {
        return 0;
    }
    
    sub generateId
    {
        return 1;
    }
    
    sub getEndInfo
    {
    }
    
    sub getItemsArray
    {
    }

    #End of methods to be overriden
    
    # If you need really specific processing, you can instead override the process method
    
    sub process
    {
        my ($self, $options) = @_;
        $self->{options} = $options;

        $options->{parent}->{items}->updateSelectedItemInfoFromPanel;
        my $alreadySaved = 0;
        if ($options->{newList})
        {
            return if !$options->{parent}->checkAndSave;
            $alreadySaved = 1;
            $options->{parent}->setFile('');
        }
        $self->{options}->{parent}->setWaitCursor($self->{options}->{lang}->{ImportListTitle}.' ('.$options->{file}.')');
        my @tmpArray = @{$self->getItemsArray($options->{file})};

        if ($self->{parsingError})
        {
            $self->{options}->{parent}->restoreCursor;
            return $self->getEndInfo;
        }

        my $realModel = $self->getModelName;

        # Here we really know the model so we force a new list if needed
        if (($options->{newList})
         || ($options->{parent}->{model}->getName ne $realModel))
        {
            $options->{parent}->newList($realModel, $self->{modelAlreadySet}, $alreadySaved);
        }

        my $generateId = $self->generateId;
        foreach (@tmpArray)
        {
            $options->{parent}->{items}->addItem($_, !$generateId, 1);
        }
        $options->{parent}->{items}->unselect;
        $self->{options}->{parent}->restoreCursor;
        
        $options->{parent}->checkPanelVisibility;
        $options->{parent}->selectFirst;
        $options->{parent}->markAsUpdated;
        $options->{parent}->viewAllItems;
        return $self->getEndInfo;
    }

    # This method could only be use if $self->{model} has been initialized
    sub copyPictures
    {
        my ($self, $itemsArray, $file) = @_;
        return if !$self->{model};
        foreach my $item(@$itemsArray)
        {
            my $title = $item->{$self->{model}->{commonFields}->{title}};
            foreach my $field(@{$self->{model}->{fieldsImage}})
            {
                (my $suffix = $item->{$field}) =~ s/.*?(\.[^.]*)$/$1/;
                my $imageFile = $self->{options}->{parent}->getUniqueImageFileName($suffix, $title);
                copy(GCUtils::getDisplayedImage($item->{$field}, '', $file),
                     $imageFile)
                    if $item->{$field};
                $item->{$field} = $imageFile;
            }
        }
    }

    # 3 methods below are created to implement interface
    # from GCFrame plugins could need to simulate if using
    # some backends
    sub preloadModel
    {
        my ($self, $model) = @_;
        # Preload the model into the factory cache
        $self->{modelsFactory}->getModel($model);
    }

    sub setCurrentModel
    {
        my ($self, $model) = @_;
        $self->{model} = $self->{modelsFactory}->getModel($model);
    }

    sub setCurrentModelFromInline
    {
        my ($self, $container) = @_;
        $self->{model} = GCModelLoader->newFromInline($self, $container);
    }
}

1;
