package GCImport::GCImportGCfilms;

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
    package GCImport::GCImporterGCfilms;
    use base qw(GCImport::GCImportBaseClass);
    use File::Basename;
    use File::Copy;
    use GCUtils;
    
    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();

        bless ($self, $class);
        $self->{errors} = '';
        
        #The fields as they were in GCfilms 6.1
        # If name has changed in GCstar, the comment contains the original one
        $self->{fields} = [
                            'id',
                            'title',
                            'date',
                            'time',
                            'director',
                            'country',      # nat
                            'genre',        # type
                            'image',
                            'actors',
                            'original',     # orig
                            'synopsis',
                            'webPage',      # url
                            'seen',
                            'format',
                            'number',
                            'place',
                            'rating',
                            'comment',
                            'audio',
                            'subt',
                            'borrower',
                            'lendDate',
                            'borrowings',   # history
                            'age',
                            'video',
                            'serie',        # collection
                            'rank',
                            'trailer',
                          ];
        
        return $self;
    }

    sub getName
    {
        return "GCfilms (.gcf)";
    }
    
    sub getFilePatterns
    {
       return (['GCfilms (.gcf)', '*.gcf']);
    }
    
    #Return supported models name
    sub getModels
    {
        return ['GCfilms'];
    }

    sub getOptions
    {
        my $self = shift;
        return [
            {
                name => 'generate',
                type => 'yesno',
                label => 'ImportGenerateId',
                default => '1'
            },
        ];
    }
    
    # Ignored for the moment
    sub wantsFieldsSelection
    {
        return 0;
    }
    sub generateId
    {
        my $self = shift;
        return $self->{options}->{generate};
    }
    sub getEndInfo
    {
        return "";
    }
    
    sub getItemsArray
    {
        my ($self, $file) = @_;
        my @result;

        open MOVIES, "<$file";
        my $gotFirstLine = 0;
        my $i = 0;
        while (<MOVIES>)
        {
            chomp;
            my @values =  split m/\|/;

            if (!$gotFirstLine)
            {
                $gotFirstLine = 1;
                if ($values[0] eq 'GCfilms')
                {
                    binmode( MOVIES, ':utf8' ) if $values[2] eq 'UTF8';
                    next;
                }
            }
            my $idx = 0;
            for my $field (@{$self->{fields}})
            {
                my $value = $values[$idx];
                if ($field eq 'image')
                {
                    my $origPath = GCUtils::getDisplayedImage($value, '', $file);
                    my $origFile = basename($origPath);
                    $origFile = $origPath = '' if ! -f $origPath;
                    # We copy the image only if it was a generated one and if we use the default path
                    if ($origFile =~ /^gcfilms_/)
                    {
                        # We don't change the filename as gcstar has a different pattern for automatic files
                        my $destPath = $self->{options}->{parent}->getImagesDir;
                        copy($origPath, $destPath) if $origPath ne $destPath;
                        $result[$i]->{image} = $destPath.$origFile;
                    }
                    else
                    {
                        # We use the full path
                        $result[$i]->{image} = $origPath;
                    }
                }
                else
                {
                    $value =~ s|:|;|gm if $field eq 'borrowings';
                    $value =~ s|<br>|\n|gm;
                    $value =~ s|<.*?>||gm;
                    if (!$value)
                    {
                        $value = 0 if $field eq 'age';
                        $value = 'none' if $field eq 'borrower';
                    }
                    $result[$i]->{$field} = $value;
                }
                $idx++;
            }
            $i++;
        }
        return \@result;
        
    }
}

1;
