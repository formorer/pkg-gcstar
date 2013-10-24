package GCExport::GCExportTarGz;

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
    package GCExport::GCExporterTarGz;

    use File::Copy;
    use File::Basename;
    use Cwd;
    use XML::Simple;
    use GCUtils 'glob';
    use GCBackend::GCBackendXmlParser;
    use base qw(GCExport::GCExportBaseClass);

    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent);
        bless ($self, $class);

        $self->checkModule('Compress::Zlib');
        $self->checkModule('Archive::Tar');

        return $self;
    }
    
    sub wantsOsSeparator
    {
        return 0;
    }    

    sub transformPicturePath
    {
        my ($self, $path, $file, $item, $field) = @_;
        return $self->duplicatePicture($path,
                                       $field,
                                       $self->{currentDir}.'/'.$self->{imageDir},
                                       $item->{$self->{model}->{commonFields}->{title}});
    }

    sub process
    {
        my ($self, $options) = @_;
        $self->{parsingError} = '';
        $self->{options} = $options;
        $self->{options}->{withPictures} = 1;
        $self->{fileName} = $options->{file};
        $self->{fileName} .= '.tar.gz' if ($self->{fileName} !~ m/\.tar\.gz$/);
        
        my $listFile = 'collection.gcs';
        my $baseDir = 'tmp_items_tar_gz';
        my $imagesSubDir = 'images';
        $self->{imageDir} = $baseDir.'/'.$imagesSubDir;
        $self->{original} = $options->{collection};
        #$self->{original} =~ s/\\/\//g if ($^O =~ /win32/i);
        $self->{origDir} = dirname($self->{original});
        (my $tarfile = $self->{fileName}) =~ s/\.gz$//;

        eval {
            chdir dirname($self->{fileName});
            die 'Directory not writable' if !-w '.';
            mkdir $baseDir;
            mkdir $self->{imageDir};

            $self->{currentDir} = getcwd;

            my $backend = new GCBackend::GCBeXmlParser($self);
            $backend->setParameters(file => $baseDir.'/'.$listFile,
                                    version => $self->{options}->{parent}->{version},
                                    wantRestore => 1,
                                    standAlone => 1);
    
            my $result = $backend->save($options->{items},
                                        $options->{originalList}->getInformation,
                                        undef);

            if ($result->{error})
            {
                die $result->{error}->[1];
            }

            chdir $self->{currentDir};

            my $tar = Archive::Tar->new();
            chdir $baseDir;
    
            $tar->add_files($listFile, $imagesSubDir);
            my @images = glob $imagesSubDir.'/*';
            $tar->add_files($_) foreach (@images);
            $tar->write($tarfile);

            my $gz = Compress::Zlib::gzopen($self->{fileName}, "wb");
            $gz or die 'Cannot write';
            open(TAR, $tarfile) or die "Cannot open $tarfile";
            binmode(TAR);
            my $buff;
            while (read(TAR, $buff, 8 * 2**10))
            {
                $gz->gzwrite($buff);
            }
            $gz->gzclose;
            close TAR;
            unlink foreach (@images);
        };
        
        if ($@)
        {
            $self->{parsingError} = GCUtils::formatOpenSaveError(
                $self->{options}->{parent}->{lang},
                $self->{fileName},
                ['SaveError', $@]
            );
        }
        
        eval {
            unlink $listFile;
            rmdir $imagesSubDir;
            chdir '..';
            rmdir $baseDir;
            $tarfile =~ s/\\/\//g if ($^O =~ /win32/i);
            unlink $tarfile;
        };
        return $self->getEndInfo;
    }

    sub getOptions
    {
        my $self = shift;
        my @options;
        return \@options;
    }

    sub getName
    {
        my $self = shift;
        
        return ".tar.gz";
    }
    
    sub getEndInfo
    {
        my $self = shift;
        return ($self->{parsingError}, 'error')
            if $self->{parsingError};
        
        return ($self->getLang->{Info}.$self->{fileName}, 'info');
    }
}
