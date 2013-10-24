package GCImport::GCImportAMC;

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
    package GCImport::GCImporterAMC;
    use base qw(GCImport::GCImportBaseClass);
    
    use File::Basename;
    use File::Copy;
        
    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        $self->{fileId} = " AMC_X.Y Ant Movie Catalog 3.5.x   www.buypin.com    www.antp.be ";

        bless ($self, $class);
        return $self;
    }

    sub getName
    {
        return "Ant Movie Catalog (.amc)";
    }
    
    sub getFilePatterns
    {
       return (['Ant Movie Catalog (.amc)', '*.amc']);
    }
    
    #Return supported models name
    sub getModels
    {
        return ['GCfilms'];
    }

    #Return current model name
    sub getModelName
    {
        return 'GCfilms';
    }

    sub getOptions
    {
        my $self = shift;
        my @options;
        return \@options;
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
    
    sub readBool
    {
        my $self = shift;
        
        my $value;
        read $self->{file}, $value, 1;
        return unpack('C',$value);
    }

    sub readInt
    {
        my $self = shift;
        
        my $value;
        read $self->{file}, $value, 4;
        $value = unpack('L',$value);
        return undef  if $value == 4294967295;
        return $value;
    }
    
    sub readString
    {
        my $self = shift;
        my $binary = shift;
        
        my $length = $self->readInt;
        my $string;
        
        return '' if $length == 0;
        read $self->{file}, $string, $length;
        
        #$string =~ s/\n/<br\/>/gm if !$binary;
        $string =~ s/\|/,/gm if !$binary;
        
        return $string;
    }
    
    sub getItemsArray
    {
        my ($self, $file) = @_;
        my @result;
        
        open ITEMS, $file;
        binmode ITEMS;
        $self->{file} = \*ITEMS;
        
        my $identifier;
        read ITEMS, $identifier, length($self->{fileId});
        ($self->{AMCVersion} = $identifier) =~ s/.*?AMC_(\d+)\.(\d+).*/$1.$2/;
        my @versions = split m/\./, $self->{AMCVersion};
        $self->{AMCMajorVersion} = $versions[0];
        $self->{AMCMinorVersion} = $versions[1];
        
        $self->readString; # name
        $self->readString; # mail
        if (($self->{AMCMinorVersion} <= 3) && ($self->{AMCMinorVersion} < 5))
        {
            $self->readString; # icq
        }
        $self->readString; # site
        $self->readString; # description

        my $baseDir = dirname($file);

        my $i = 0;

        while (! eof ITEMS)
        {
            $result[$i]->{identifier} = $self->readInt;  #Id
            $self->readInt;  #Add date
            $result[$i]->{rating} = $self->readInt;
            
            if (($self->{AMCMinorVersion} >= 3) && ($self->{AMCMinorVersion} >= 5))
            {
                use integer;
                $result[$i]->{rating} /= 10;
            }
            
            $result[$i]->{date} = $self->readInt;
            $result[$i]->{time} = $self->readInt;
            my $ vb = $self->readInt;  #Video bitrate
            my $ab = $self->readInt;  #Audio bitrate
            $result[$i]->{number}  = $self->readInt;
            
            $self->readBool;  #Checked
            
            $result[$i]->{place} = $self->readString;  #Media label
            $result[$i]->{format} = $self->readString;
            $self->readString;  #Source
            $result[$i]->{borrower} = $self->readString;
            $result[$i]->{borrower} = 'none' if ! $result[$i]->{borrower};
            $result[$i]->{original} = $self->readString;
            $result[$i]->{title} = $self->readString;
            $result[$i]->{title} = $result[$i]->{original} if !$result[$i]->{title};

            $result[$i]->{director} = $self->readString;
            $self->readString;  #Producer
            $result[$i]->{country} = $self->readString;     
            $result[$i]->{genre} = [[$self->readString]];
            $result[$i]->{actors} = $self->readString;
            $result[$i]->{webPage} = $self->readString;            
            $result[$i]->{synopsis} = $self->readString;
            $result[$i]->{comment} = $self->readString;
            $result[$i]->{video} = $self->readString;
            my $encodings = $self->readString;  #Audio format
            my $res = $self->readString;  #Resolution
            $self->readString;  #Framerate
            $result[$i]->{audio} = $self->readString;
            if ($result[$i]->{audio})
            {
                my @encodings = split /,/,$encodings;
                $result[$i]->{audio} =~ s/(^|,)([^;]*?)(,|$)/$1$2;$_$3/ foreach (@encodings);
                $result[$i]->{audio} =~ s/, +/,/g;
                $result[$i]->{audio} =~ s/; +/;/g;
            }
            $result[$i]->{subt} = [[$self->readString]];
            $self->readString;  #File size
            $result[$i]->{image} = $self->readString;

            my $picture = $self->readString(1);

            if ($result[$i]->{image} =~ /^\..{3}/)
            {
                my $pictureName = $self->{options}->{parent}->getUniqueImageFileName($result[$i]->{image},
                                                                                     $result[$i]->{title});            
                open PIC, "> $pictureName";
                binmode PIC;
                print PIC $picture;
                close PIC;
                $result[$i]->{image} = $self->{options}->{parent}->transformPicturePath($pictureName);
            }
            else
            {
                if (! File::Spec->file_name_is_absolute($result[$i]->{image}))
                {
                    $result[$i]->{image} = $baseDir . $result[$i]->{image};
                }
                #copy $result[$i]->{image}, $pictureName;
            }

            $i++;
        }

        close ITEMS;

        return \@result;     
    }
}

1;
