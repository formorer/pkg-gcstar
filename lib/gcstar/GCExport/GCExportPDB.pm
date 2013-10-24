package GCExport::GCExportPDB;

###################################################
#
#  Copyright 2009-2010 Andrew Ross
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
    package GCExport::GCExporterPDB;
    
    use base qw(GCExport::GCExportBaseClass);
    use Encode;
    
    my @record_lengths;

    my $EPOCH_1904 = 2082844800;  # Difference between Palm's
                                  # epoch (Jan. 1, 1904) and
                                  # Unix's epoch (Jan. 1, 1970),
                                  # in seconds.


    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        
        bless ($self, $class);
        return $self;
    }

    sub getOptions
    {
        my $self = shift;
        
        return [
            {
                name => 'dbname',
                type => 'short text',
                label => 'DatabaseName',
                default => 'gcstar'
            },
        ];
        
    }
      
    sub wantsFieldsSelection
    {
        return 1;
    }
    
    sub wantsImagesSelection
    {
        return 0;
    }

    sub wantsSort
    {
        return 1;
    }

    sub needsUTF8
    {
        my $self = shift;
        return 0;
    }

    sub getSuffix
    {
        my $self = shift;
        
        return ".pdb";
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
        $value =~ s/\n|\r//g;
        $value =~ s/<br\/>/ /g;

        return $value;
    }

    sub getHeader
    {
        my ($self, $number) = @_;
        my $result = '';
        
        # clear the record lengths array
        @record_lengths = ();

        # Add database title
        my $name = $self->{options}->{'dbname'};
        if (length($name) > 31) 
        {
            $name = substr($name, 0, 31);
        }
        while (length($name) < 32) 
        {
            $name .= "\x00"; # pack out with null's
        }
        $result .= $name;

        # Add attribute flags (=0)
        $result .= pack('n', 0);
        
        # Add file version (=0)
        $result .= pack('n', 0);

        # Add dates for create time, modify time, backup time
        # These dates are the number of seconds since 1st Jan 1904
        my $now = time() + $EPOCH_1904;

        $result .= pack('N', $now);
        $result .= pack('N', $now);
        $result .= pack('N', $now);

        # Add the Modification Number (=0)
        $result .= pack('N', 0);

        # Add the offset to the Application Info
        # offset calculated as:
        # Title:                       0x20
        # flags + version + 3 x dates  0x10
        # mod_number + app_offset      0x08
        # sortID + type                0x08
        # creator + seed               0x08
        # recordListID + cnt + 2byte   0x08
        # 8 bytes per record           8 * $number
        $result .= pack('N', 0x50 + (8 * $number));

        # Add null for the sortInfoID since we don't create a sortInfo
        $result .= pack('N', 0);

        # Add the type
        $result .= "DB00";

        # Add the creator
        $result .= "DBOS";

        # add the uniqueIDseed = 0
        $result .= pack('N', 0);

        # Add the nextRecordListID = 0 when on disk
        $result .= pack('N', 0);

        # add the record count
        $result .= pack('n',$number);
        
        # The record offset table goes here, but is added in postProcess()

        # "Traditional" 2-byte gap to data
        $result .= pack('n', 0);

        # Start the AppInfoID section
        $result .= pack('N', 2);


        # CHUNK_FIELD_NAMES (0)
        $result .= pack('n',0);
        my $fieldstring = '';
        foreach (@{$self->{options}->{fields}})
        {
            my $column = $self->{model}->{fieldsInfo}->{$_}->{displayed};
            $fieldstring .= $self->transformValue($column)."\x00";
        }
        $result .= pack('n', length($fieldstring));
        $result .= $fieldstring;

        # CHUNK_FIELD_TYPES (1)
        $result .= pack('n',1);
        $fieldstring = '';
        foreach (@{$self->{options}->{fields}})
        {
            $fieldstring .= pack('n',0);
        }
        $result .= pack('n', length($fieldstring));
        $result .= $fieldstring;

        # CHUNK_LISTVIEW_OPTIONS (65)
        $result .= pack('n',65);
        $result .= pack('n',4);
        $result .= pack('n',0);
        $result .= pack('n',0);

        # CHUNK_LFIND_OPTIONS (128)
        $result .= pack('n',128);
        $result .= pack('n',2);
        $result .= pack('n',0);

        return $result;
    }

    sub getItem
    {
        my ($self, $item, $number) = @_;
        my $result;

        my @lengths = ();
        my $fieldstr;
        foreach (@{$self->{options}->{fields}})
        {
            my $value = $item->{$_};
            my $str = $self->transformValue($value, $_)."\x00";
            push (@lengths, length($str));
            $fieldstr .= $str;
        }

        my $al = scalar(@lengths) * 2;
        for(my $i=0;$i<=$#lengths;$i++) 
        {
            $result .= pack('n', $al);
            $al += $lengths[$i];
        }
        $result .= $fieldstr;
        push (@record_lengths, length($fieldstr)+(2 * scalar(@lengths)));

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

        # add the index:
        my $index = "";

        my $numrecs = scalar(@record_lengths);
        my $offset = length($$header) + (8*$numrecs);

        for (my $i=0;$i<$numrecs;$i++)
        {
            $index .= pack('N', $offset);
            $index .= pack('n', 0);
            $index .= pack('n', $i);
            $offset += $record_lengths[$i];
        }

        # Insert the index into the header
        $$header = substr($$header, 0, 0x4e).$index.substr($$header,0x4e);
    }

    sub getEndInfo
    {
        my $self = shift;
        my $message;
        
        return $message;
    }


}

1;
