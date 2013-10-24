package GCExport::GCExportExternal;

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
    package GCExport::GCExporterExternal;

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

        $self->{useZip} = $self->checkOptionalModule('Archive::Zip');

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
                                       $self->{imageDir},
                                       $item->{$self->{model}->{commonFields}->{title}});
    }

    sub process
    {
        my ($self, $options) = @_;
        $self->{parsingError} = '';
        $self->{options} = $options;
        $self->{options}->{withPictures} = 1;
        #$self->{fileName} = $options->{file};
        my $ext = ($self->{options}->{zip} ? 'gcz' : 'gcs');
        my $outFile = $options->{file};
        $outFile .= ".$ext" if ($outFile !~ m/\.$ext$/);
        #$self->{fileName} .= '.gcs' if ($self->{fileName} !~ m/\.gcs$/);
        $self->{fileName} = $outFile;
        $self->{fileName} =~ s/z$/s/;
        my $listFile = $self->{fileName};
        my $baseDir = dirname($listFile);
        my $baseName = basename($listFile, '.gcs');
        my $imagesSubDir = $baseName.'_pictures';
        $self->{imageDir} = $baseDir.'/'.$imagesSubDir;
        $self->{original} = $options->{collection};
        #$self->{original} =~ s/\\/\//g if ($^O =~ /win32/i);
        $self->{origDir} = dirname($self->{original});

        eval {
            chdir $baseDir;
            die 'Directory not writable' if !-w '.';
            mkdir $self->{imageDir};

            $self->{currentDir} = getcwd;

            my $backend = new GCBackend::GCBeXmlParser($self);
            $backend->setParameters(file => $listFile,
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
        };
        
        if ($@)
        {
            $self->{parsingError} = GCUtils::formatOpenSaveError(
                $self->{options}->{parent}->{lang},
                $self->{fileName},
                ['SaveError', $@]
            );
        }
        
        if ($self->{options}->{zip})
        {
            chdir $baseDir;
            my $zip = Archive::Zip->new();
            $zip->addFile(basename($self->{fileName}));
            $zip->addDirectory(basename($self->{imageDir}));
            my @images = glob $imagesSubDir.'/*';
            $zip->addFile($_) foreach @images;
            my $result = $zip->writeToFileNamed($outFile);
            if ($result)
            {
                $self->{parsingError} = GCUtils::formatOpenSaveError(
                    $self->{options}->{parent}->{lang},
                    $outFile,
                    ['SaveError', $@]
                );
            }
            else
            {
                # Cleanup to remove everything but the .gcz file
                unlink $self->{fileName};
                unlink foreach (@images);
                rmdir $imagesSubDir;
            }
        }
        chdir;
        return $self->getEndInfo;
    }

    sub getOptions
    {
        my $self = shift;
        my @options;

        if ($self->{useZip})
        {
            push @options, {
                name => 'zip',
                type => 'yesno',
                label => 'ZipAll',
                default => '0'
            };
        }

        return \@options;
    }

#    sub getName
#    {
#        my $self = shift;
#        
#        return "External";
#    }
    
    sub getEndInfo
    {
        my $self = shift;
        return ($self->{parsingError}, 'error')
            if $self->{parsingError};
        
        return '';
    }
}
