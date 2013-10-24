package GCExport::GCExportXML;

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
    package GCExport::GCExporterXML;
    use base qw(GCExport::GCExportBaseClass);

    use File::Basename;    
    use GCUtils 'glob';

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        

        bless ($self, $class);
        return $self;
    }

    sub transformValue
    {
        my ($self, $value, $field) = @_;
        
        $value = $self->SUPER::transformValue($value, $field);
        $value =~ s/&(\W)/&amp;$1/g;
        $value =~ s/"/&#34;/g;
        #"
        $value =~ s/'/&#39;/g;
        #'
        return $value;
    }

    sub getName
    {
        my $self = shift;
        
        return "XML";
    }

    sub getSuffix
    {
        my $self = shift;
        
        return "";
    }
    
    sub needsUTF8
    {
        my $self = shift;
    
        return 1;
    }

    sub getOptions
    {
        my $self = shift;

        $self->{modelsFiles} = '';

        if ($self->{model}->getName)
        {
            $self->{modelsDir} = $ENV{GCS_SHARE_DIR}.'/xml_models/'.$self->{model}->getName;
            foreach (glob $self->{modelsDir}.'/*')
            {
                next if $_ =~ /\/CVS$/;
                (my $mod = basename($_)) =~ s/_/ /g;
                $self->{modelsFiles} .= ','.$mod;
            }
        }

        return [
            {
                name => 'models',
                type => 'options',
                label => 'Models',
                default => 'UseModel',
                valuesList => 'UseModel,UseFile'.$self->{modelsFiles}
            },
            
            {
                name => 'templatefile',
                type => 'file',
                label => 'ModelFile',
                default => ''
            },

            {
                name => 'model',
                type => 'long text',
                label => 'ModelText',
                default => '',
                height => 100
            },
            
        ];
    }
      
    sub wantsFieldsSelection
    {
        return 0;
    }
    
    sub wantsImagesSelection
    {
        return 1;
    }
    
    sub preProcess
    {
        my $self =  shift;
                
        my $model;

        if ($self->{options}->{models} eq 'UseModel')
        {
            $model = $self->{options}->{model};
        }
        else
        {
            my $file;
            if ($self->{options}->{models} eq 'UseFile')
            {
                $file = $self->{options}->{templatefile};
            }
            else
            {
                (my $fileName = $self->{options}->{models}) =~ s/ /_/g;
                $file = $self->{modelsDir}.'/'.$fileName;
                $file =~ s/"//g;
                #"
            }
            open FILE, $file;
            #Read full file
            $model = do { local $/; <FILE> };
            close FILE;
        }
        $model =~ m{
            \[HEADER\]\n?(.*?)\n?\[\/HEADER\].*?
            \[ITEM\]\n?(.*?)\n?\[\/ITEM\].*?
            \[FOOTER\]\n?(.*?)\n?\[\/FOOTER\]
        }xms;
        $self->{header} = $1;
        $self->{item} = $2;
        $self->{footer} = $3;
        return 1;
    }

    sub getHeader
    {
        my ($self, $number) = @_;
        my $result = $self->{header};

        $result =~ s/\$\{file\}/$self->{options}->{collection}/g;
        $result =~ s/\$\{number\}/$number/g;
        
        return $result."\n";
    }

    sub getItem
    {
        my ($self, $item, $number) = @_;
        my $result = $self->{item};
        
        while ($result =~ m/\[LOOP\s+(.*?)\]\n?(.*?)\n\s*\[\/LOOP\]/gms)
        {
            my $values = $self->transformValue($item->{$1}, $1);
            my $motif = $2;
            my $string;
            foreach my $value(split /,/, $values)
            {
                $value =~ s/^\s*//;
                (my $line = $motif) =~ s/\$\$/$value/gms;
                $string .= $line;
            }
            $result =~ s/(\n?)\s*\[LOOP\s+$1\].*?\[\/LOOP\]/$1$string/gms;
        }
        
        while ($result =~ m/\[SPLIT\s+value=(.*?)\s+sep=(.)\]\n?(.*?)\n\s*\[\/SPLIT\]/gms)
        {
            my $values = $1;
            $values = $item->{$values} if exists $item->{$values};
            $values = $self->transformValue($values, $1);
            my $sep = ${2};
            my $motif = ${3};
            my $i = 0;
            foreach my $value(split /$sep/, $values)
            {
                $value =~ s/^\s*//;
                $motif =~ s/\$$i/$value/gms;
                $i++;
            }
            do {$motif =~ s/\s*\$[0-9]+//mgs;};
            $result =~ s/(\n?)\s*\[SPLIT\s+value=\Q$1\E\s+sep=($sep)\].*?\[\/SPLIT\]/$1$motif/gms;
        }

        foreach (keys %$item)
        {
            my $value = $self->transformValue($item->{$_}, $_);
            $result =~ s/\$\{$_\}/$value/g;
        }        

        if ($item->{time})
        {
            my $min = 0;
            my $time = $item->{time};
            $min = ($1 * 60) + $2 if ($time =~ /([0-9]*)h\.?\s+([0-9]*)m/)
                                  || ($time =~ /([0-9]*):([0-9]*)/);
            $min = $1 if !$min && ($time =~ /([0-9]*)/);
            $result =~ s/\$\{length\}/$min/g;
        }
        
        if ($item->{date})
        {
            my $year = 0;
            $item->{date} =~ /([0-9]{4})/;
            $year = $1;
            $result =~ s/\$\{year\}/$year/g;
        }

        $result =~ s/\$\{.*?\}//g;

        return $result."\n";
    }
    
    sub getFooter
    {
        my $self = shift;
        my $result = $self->{footer};
        
        return $result."\n";
    }

    # postProcess
    # Called after all processing. Use it if you need to perform extra stuff on the header.
    # $header is a reference to the header string.
    sub postProcess
    {
        my ($self, $header, $body) = @_;

        # Your code here
        # As header is a reference, it can be modified on place with $$header
    }

    # getEndInfo
    # Used to display some information to user when export is ended.
    # To localize your message, use $self->{options}->{lang}.
    # Returns a string that will be displayed in a message box.
    sub getEndInfo
    {
        my $self = shift;
        my $message;
        
        # Your code here
        # Don't do put anything in message if you don't want information to be displayed.
        
        return $message;
    }
}

1;
