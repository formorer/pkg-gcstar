package GCExport::GCExportBase;

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
    package GCExport::GCExportBaseClass;

    use base 'GCExportImportBase';

    use File::Basename;
    use File::Copy;
    use GCUtils 'glob';
    
    #Methods to be overriden in specific classes
    
    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new;

        bless ($self, $class);
        return $self;
    }

    sub getSuffix
    {
        return '';
    }
    
    sub getModels
    {
        return [];
    }
    
    sub needsUTF8
    {
        return 0;
    }
    
    sub getOptions
    {
    }
    
    sub wantsDirectorySelection
    {
        return 0;
    }
    
    sub wantsFieldsSelection
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
    
    sub getHeader
    {
    }

    sub getItem
    {
    }

    sub getFooter
    {
    }

    sub postProcess
    {
    }

    sub preProcess
    {
    }

    sub getEndInfo
    {
    }

    sub wantsOsSeparator
    {
        return 1;
    }    

    sub wantsSort
    {
        return 0;
    }

    sub getNewPictureHeight
    {
        return 0;
    }

    #End of methods to be overriden
    
    sub getUniqueImageFileName
    {
        my ($self, $suffix, $dir, $title) = @_;
        
        return $self->{options}->{parent}->getUniqueImageFileName($suffix, $title, $dir);
    }
    
    sub duplicatePicture
    {
        my ($self, $orig, $field, $dir, $title, $newHeight) = @_;
        $self->{saved}->{$field} = $orig;
        my $newPic = $orig;
        if ($orig && $self->{options}->{withPictures})
        {
            $newPic = GCUtils::getDisplayedImage($orig,
                                                 $self->{options}->{defaultImage},
                                                 $self->{original});
            if ($newPic eq $self->{options}->{defaultImage})
            {
                $newPic = $self->{defaultImage};
            }
            else
            {
                $newPic =~ /.*?(\.[^.]*)$/;
                my $suffix = $1;
                my $dest = $self->getUniqueImageFileName($suffix,
                                                         $dir,
                                                         $title);
                my $picHeight = $self->getNewPictureHeight;
                if ($picHeight)
                {
                    my $pixbuf = Gtk2::Gdk::Pixbuf->new_from_file($newPic);
                    my ($width, $height) = ($pixbuf->get_width, $pixbuf->get_height);
                    my $picWidth = $width * ($picHeight / $height);
                    $pixbuf = GCUtils::scaleMaxPixbuf($pixbuf, $picWidth, $picHeight, 1);
                    my $format;
                    if ($suffix =~ /png/i)
                    {
                        $format = 'png';
                    }
                    else
                    {
                        $dest =~ s/\.[^.]*$/\.jpg/;
                        $format = 'jpeg';
                    }
                    $pixbuf->save($dest, $format);
                }
                else
                {
                    copy($newPic, $dest);
                }
                $newPic = basename($dir).'/'.basename($dest);
            }
        }
        else
        {
            $newPic = basename($dir).'/'.basename($self->{options}->{defaultImage});
        }
        $newPic =~ s/\//\\/g if ($^O =~ /win32/i) && $self->wantsOsSeparator;
        return $newPic;
    }
    
    sub restorePicture
    {
        my $self = shift;
        return $self->{saved}->{image};
    }

    sub restoreInfo
    {
        my ($self, $info) = @_;

        foreach (keys %{$self->{saved}})
        {
            $info->{$_} = $self->{saved}->{$_};
        }
    }

    sub transformValue
    {
        my ($self, $value, $field) = @_;
        if ($self->{options}->{fieldsInfo}->{$field}->{type} eq 'image')
        {
            if ($self->{copyPictures})
            {
                $value = $self->duplicatePicture($value, $field,
                                                 $self->{dirName},
                                                 $self->{currentItem}->{
                                                     $self->{model}->{commonFields}->{title}
                                                 });
            }
            return $value;
        }
        return $self->{options}->{originalList}->transformValue($value, $field);
    }

    sub getStockLabel
    {
        my ($self, $stock) = @_;
        my $item = Gtk2::Stock->lookup($stock);
        my $label = '';
        ($label = $item->{label}) =~ s/_//
            if $item;
        return $label;
    }

    # If you need really specific processing, you can instead override the process method
    sub process
    {
        my ($self, $options) = @_;

        $self->{saved} = {};
        $self->{currentItem} = undef;

        $self->{options} = $options;

        $options->{file} .= $self->getSuffix
            if ($self->getSuffix) 
            && ($options->{file} !~ /\.\w*$/);
        $self->{fileName} = $options->{file};
        $self->{original} = $options->{collection};
        $self->{origDir} = dirname($self->{original});
        $options->{collectionDir} = $self->{origDir};

        ($self->{dirName} = $self->{fileName}) =~ s/\.[^.]*?$//;
        $self->{dirName} .= '_images';
        if ( -e $self->{dirName})
        {
            my @images = glob $self->{dirName}.'/*';
            unlink foreach (@images);
            rmdir $self->{dirName};
            unlink $self->{dirName} if ( -e $self->{dirName});
        }
        if ($self->{options}->{withPictures})
        {
            mkdir $self->{dirName};
            #Get a copy of default picture
            copy($self->{options}->{defaultImage},$self->{dirName});
            $self->{defaultImage} = basename($self->{dirName}).'/'
                                    .basename($self->{options}->{defaultImage});
       }

        if (! $self->preProcess)
        {
            return $self->getEndInfo;
        }

        my @tmpArray = @{$options->{items}};
        if ($self->wantsSort)
        {
            my $sorter = $self->{options}->{sorter};
            use locale;
            if ($self->{model}->{fieldsInfo}->{$sorter}->{type} eq 'number')
            {
                @tmpArray = sort {
                    my $val1 = $a->{$sorter};
                    my $val2 = $b->{$sorter};
                    return $val1 <=> $val2;
                } @tmpArray;
            }
            elsif ($self->{model}->{fieldsInfo}->{$sorter}->{type} eq 'date')
            {
                @tmpArray = sort {
                    my $val1 = GCPreProcess::reverseDate($a->{$sorter});
                    my $val2 = GCPreProcess::reverseDate($b->{$sorter});
                    return $val1 <=> $val2;
                } @tmpArray;
            }
            else
            {
                @tmpArray = sort {
                    my $val1 = uc $self->{options}->{originalList}->transformValue($a->{$sorter}, $sorter);
                    my $val2 = uc $self->{options}->{originalList}->transformValue($b->{$sorter}, $sorter);
                    return $val1 cmp $val2;
                } @tmpArray;
            }
            @tmpArray = reverse @tmpArray if $self->{options}->{order} eq 'desc';
        }

        $self->{sortedArray} = \@tmpArray;

        my $header = $self->getHeader($#tmpArray + 1);
        my $body = '';

        my $item;
        my $idx = 0;
        my $copyPictures = 0;
        my @copiedPicturesFields;
        if ($self->{options}->{withPictures})
        {
            # If we don't specify fields, the pictures will be copied with transform value
            # This one is used now
            $copyPictures = 1
                if $self->wantsFieldsSelection;
            # This one will be used by transform value
            $self->{copyPictures} = !$copyPictures;
            foreach my $field(@{$self->{options}->{fields}})
            {
                push @copiedPicturesFields, $field
                    if $self->{options}->{fieldsInfo}->{$field}->{type} eq 'image';
            }
        }
        foreach $item(@tmpArray)
        {
            $self->{currentItem} = $item;
            if ($copyPictures)
            {
                foreach my $pic(@copiedPicturesFields)
                {
                    $item->{$pic} = $self->duplicatePicture($item->{$pic}, $pic, $self->{dirName},
                                                            $item->{$self->{model}->{commonFields}->{title}});
                }
            }
            $body .= $self->getItem($item, $idx);
            $self->restoreInfo($item);
            $idx++;
        }
        $self->{currentItem} = undef;
        my $footer = $self->getFooter($#tmpArray + 1);

        $self->postProcess(\$header, \$body);

        open EXPORTFILE, ">".$options->{file};
        binmode( EXPORTFILE, ':utf8') if $self->needsUTF8;
        print EXPORTFILE "$header";
        print EXPORTFILE "$body";
        print EXPORTFILE "$footer";
        close EXPORTFILE;

        return $self->getEndInfo;
    }
}

1;
