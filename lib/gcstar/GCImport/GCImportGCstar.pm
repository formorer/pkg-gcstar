package GCImport::GCImportGCstar;

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
    package GCImport::GCImporterGCstar;
    use base qw(GCImport::GCImportBaseClass);

    use GCBackend::GCBackendXmlParser;
    
    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);
        return $self;
    }

    sub getName
    {
        return "GCstar (.gcs)";
    }
    
    sub getFilePatterns
    {
       return (['GCstar (.gcs)', '*.gcs']);
    }
    
    sub getModelName
    {
        my $self = shift;
        return $self->{model}->getName;
    }

    sub getOptions
    {
        my $self = shift;
        return [
        {
            name => 'copyPics',
            type => 'yesno',
            label => 'CopyPictures',
            default => '1'
        }];
    }
    
    # Ignored for the moment
    sub wantsFieldsSelection
    {
        return 0;
    }
    sub getEndInfo
    {
        return "";
    }

    sub getItemsArray
    {
        my ($self, $file) = @_;

        my $parent = $self->{options}->{parent};
        $self->{modelsFactory} = $parent->{modelsFactory};
        $self->{modelAlreadySet} = 0;

        my $copyPics = 1;
        $copyPics = $self->{options}->{copyPics}
            if exists $self->{options}->{copyPics};

        my $backend = new GCBackend::GCBeXmlParser($self);            
        $backend->setParameters(file => $file);
        my $loaded = $backend->load(0);
        my $itemsArray = $loaded->{data};
        if ($copyPics)
        {
            $self->copyPictures($itemsArray, $file);
        }
        return $itemsArray;

    }
}

1;
