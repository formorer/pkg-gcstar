package GCExport::GCExportSQL;

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

use GCExport::GCExportBase;

{
    package GCExport::GCExporterSQL;
    use base qw(GCExport::GCExportBaseClass);

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        

        bless ($self, $class);
        return $self;
    }
    
    sub getSuffix
    {
        my $self = shift;
        
        return "";
    }

    sub getOptions
    {
        my $self = shift;
        
        return [
            {
                name => 'table',
                type => 'short text',
                label => 'TableName',
                default => 'items'
            },                        
            {
                name => 'withDrop',
                type => 'yesno',
                label => 'WithDrop',
                default => '1'
            },
            {
                name => 'withCreate',
                type => 'yesno',
                label => 'WithCreate',
                default => '1'
            },
                    ]
    }
    
    sub wantsFieldsSelection
    {
        return 1;
    }
    
    sub wantsImagesSelection
    {
        return 1;
    }
    
    sub getName
    {
        my $self = shift;
        
        return "SQL";
    }
    
    sub preProcess
    {
        my $self =  shift;
        return 1;
    }

    sub getHeader
    {
        my ($self, $number) = @_;

        my $result = '';

        if ($self->{options}->{withDrop})
        {
            $result .= 'DROP TABLE '.$self->{options}->{table}.";\n";
        }
        if ($self->{options}->{withCreate})
        {
            $result .= 'CREATE TABLE '.$self->{options}->{table}.' (';
            
            foreach (@{$self->{options}->{fields}})
            {
                my $type = $self->{model}->{fieldsInfo}->{$_}->{type};
                my $format = 'TEXT';
                $format = 'NUMBER' if ($type eq 'number') || ($type eq 'yesno');
                $result .= "$_ $format, ";
            }
            $result =~ s/, $//;
            $result .= ");\n";
        }

        return $result;
    }

    sub getFooter
    {
        my $self = shift;

        my $result = "COMMIT;\n";
        return $result;
    }

    sub getItem
    {
        my ($self, $item, $number) = @_;
        my $result;
     
        $result = 'INSERT INTO '.$self->{options}->{table}.' (';
        my $values = '';
        foreach (@{$self->{options}->{fields}})
        {
            $result .= "$_, ";
            my $value = $self->transformValue($item->{$_}, $_);
            $value =~ s/'/''/g;
            #'
            $values .= "'".$value."', ";
        }
        $result =~ s/, $//;
        $values =~ s/, $//;
        
        $result .= ") VALUES ($values);\n";
        return $result;
    }

    sub postProcess
    {
        my ($self, $value, $body) = @_;

    }

    sub getEndInfo
    {
        my $self = shift;
        my $message = $self->getLang->{InfoFile}.$self->{fileName};
        return $message;
    }
}

1;