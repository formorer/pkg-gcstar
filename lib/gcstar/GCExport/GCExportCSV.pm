package GCExport::GCExportCSV;

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
    package GCExport::GCExporterCSV;

    use base qw(GCExport::GCExportBaseClass);
    use Encode;

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
        my $self = shift;
        
        return "CSV";
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

        return [
            {
                name => 'sep',
                type => 'short text',
                label => 'Separator',
                default => ';'
            },

            {
                name => 'rep',
                type => 'short text',
                label => 'Replacement',
                default => ','
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

        ];
        
    }
      
    sub wantsFieldsSelection
    {
        return 1;
    }
    
    sub wantsImagesSelection
    {
        return 1;
    }

    sub wantsSort
    {
        return 1;
    }

    sub needsUTF8
    {
        my $self = shift;
        return $self->{options}->{charset} eq 'utf8';
    }

    sub preProcess
    {
        my $self =  shift;
        return 1;
    }

    sub transformValue
    {
        my ($self, $value, $field) = @_;
        
        if ($field)
        {
            $value = $self->SUPER::transformValue($value, $field);
        }
        $value =~ s/,+$//;
        $value =~ s /$self->{options}->{sep}/$self->{options}->{rep}/g;            
        $value =~ s/\n|\r//g;
        $value =~ s/<br\/>/ /g;
        $value = encode($self->{options}->{charset}, $value)
            if $self->{options}->{charset} ne 'utf8';
        return $value;
    }

    sub getHeader
    {
        my ($self, $number) = @_;
        my $result = '';
        
        if ($self->{options}->{withHeader})
        {
            foreach (@{$self->{options}->{fields}})
            {
                #my $column = $self->{options}->{lang}->{FieldsList}->{$_};
                my $column = $self->{model}->{fieldsInfo}->{$_}->{displayed};
                $result .= $self->transformValue($column).$self->{options}->{sep};
            }
            $result =~ s/$self->{options}->{sep}$//;
            $result .= "\n";
        }
        
        return $result;
    }

    sub getItem
    {
        my ($self, $item, $number) = @_;
        my $result;
        foreach (@{$self->{options}->{fields}})
        {
            my $value = $item->{$_};
            $result .= $self->transformValue($value, $_).$self->{options}->{sep};
        }
        $result =~ s/$self->{options}->{sep}$//;
        $result .= "\n";
        
        return $result;
    }
    
    sub getFooter
    {
        my $self = shift;
        my $result;

        return $result;
    }

    sub postProcess
    {
        my ($self, $header, $body) = @_;
    }

    sub getEndInfo
    {
        my $self = shift;
        my $message;
        
        return $message;
    }
}

1;
