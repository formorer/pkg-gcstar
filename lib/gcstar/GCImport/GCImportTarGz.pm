package GCImport::GCImportTarGz;

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
    package GCImport::GCImporterTarGz;

    use base qw(GCImport::GCImportBaseClass);
 
    use GCBackend::GCBackendXmlParser;

    use File::Spec;
    use File::Temp qw/ tempfile tempdir /;
    use Cwd;
    use File::Copy;
    
    #use GCData;

    
    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);

        $self->checkModule('Compress::Zlib');
        $self->checkModule('Archive::Tar');
        $self->checkModule('File::Path');

        return $self;
    }

    sub getName
    {
        return ".tar.gz";
    }
    
    sub getFilePatterns
    {
       return (['Tar gzip (.tar.gz)', '*.tar.gz']);
    }
    
    sub getModelName
    {
        my $self = shift;
        
        return $self->{model}->getName;
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
        my $self = shift;
        return ($self->{parsingError}, 'error');
    }
    
    sub addFieldsToDefaultModel
    {
        my ($self, $inlineModel) = @_;
        my $model = GCModelLoader->newFromInline($self, {inlineModel => $inlineModel, defaultModifier => 1});
        $self->{model}->addFields($model);
        $self->{options}->{parent}->setCurrentModel($self->{model});
        $self->{modelAlreadySet} = 1;
    }

    sub getItemsArray
    {
        my ($self, $file) = @_;
        
        my ($tarFh, $tarFilename) = tempfile();
        my $gz = Compress::Zlib::gzopen($file, "rb");
        my $buffer;
        print $tarFh $buffer while $gz->gzread($buffer) > 0 ;
        close $tarFh;
        $gz->gzclose;

        my $tmpDir = tempdir();
        my $oldCwd = getcwd;
        chdir $tmpDir;
        my $tar = Archive::Tar->new($tarFilename);
        $tar->extract;
        my $listFile = './collection.gcs';

        my $parent = $self->{options}->{parent};
        $self->{modelsFactory} = $parent->{modelsFactory};
        $self->{modelAlreadySet} = 0;

        my $backend = new GCBackend::GCBeXmlParser($self);            
        $backend->setParameters(file => $listFile);
        my $loaded = $backend->load(0);
        my $itemsArray = [];
        if ($loaded->{error})
        {
            $self->{parsingError} = GCUtils::formatOpenSaveError(
                $parent->{lang},
                $file,
                $loaded->{error}
            );
        }
        else
        {
            $itemsArray = $loaded->{data};

            #Copying pictures
            $self->copyPictures($itemsArray, $file);
        }

        #Cleaning
        chdir $oldCwd;
        File::Path::rmtree($tmpDir);
        unlink $tarFilename;
        
        return $itemsArray;
    }
}

1;
