package GCCommandLine;

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

{
    package GCPseudoFrame;
    
    use File::Basename;
    use File::Temp qw(tempdir);
    use GCUtils;
    
    sub new
    {
        my ($proto, $parent, $options, $lang, $keepPictures) = @_;
        my $class = ref($proto) || $proto;
        my $self  = {
                        options => $options,
                        imagePrefix => 'gcstar_',
                        lang => $lang,
                        parent => $parent,
                        agent => 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.5) Gecko/20041111 Firefox/1.0',
                    };
        bless ($self, $class);
        $self->{tmpImageDir} = tempdir(CLEANUP => ($keepPictures ? 0 : 1));
        return $self;
    }

    sub setCurrentModel
    {
        my ($self, $model) = @_;
        return $self->{parent}->setModel($model);
    }

    sub transformTitle
    {
        my ($self, $title) = @_;
        return $title;
    }
    
    sub getImagesDir
    {
        my ($self, $suffix, $itemTitle, $imagesDir) = @_;
        return GCFrame::getImagesDir(@_);
    }

    sub getUniqueImageFileName
    {
        my ($self, $suffix, $itemTitle, $imagesDir) = @_;
        return GCFrame::getUniqueImageFileName(@_);
    }

    sub transformPicturePath
    {
        my ($self, $path, $file) = @_;
        return GCFrame::transformPicturePath(@_);
    }
    
    sub preloadModel
    {
        my ($self, $model) = @_;
        # Preload the model into the factory cache
        $self->{model} = $self->{modelsFactory}->getModel($model);
    }

    sub AUTOLOAD
    {
        our $AUTOLOAD;
        (my $name = $AUTOLOAD) =~ s/.*?::(.*)/$1/;
    }
}

{

    package GCCommandExecution;

    use File::Temp qw/ :POSIX /;
    use File::Basename;
    use GCData;
    use GCDisplay;
    use GCExport;
    use GCImport;
    use GCPlugins;
    use GCModel;

    sub new
    {
        my ($proto, $options, $model, $plugin, $import, $export, $output) = @_;
        my $class = ref($proto) || $proto;
        my $self  = {};
        bless ($self, $class);

        $self->{file} = $output;
        $self->{useStdOut} = 0;
        if (!$output)
        {
            (undef, $self->{file}) = tmpnam;
            $self->{useStdOut} = 1;
        }

        GCPlugins::loadAllPlugins;
        $self->{lang} = $GCLang::langs{$options->lang};
        $self->{parent} = new GCPseudoFrame($self, $options, $self->{lang}, $self->{useStdOut});

        $self->{modelsFactory} = new GCModelsCache($self->{parent});
        $self->{model} = $self->{modelsFactory}->getModel($model);
        $self->{parent}->{model} = $self->{model};
        $self->{parent}->{modelsFactory} = $self->{modelsFactory};

        $self->{plugin} = $pluginsMap{$model}->{$plugin};
        $self->leave("Fetch plugin $plugin doesn't exist") if $plugin && (!$self->{plugin});

        if ($import)
        {
            GCImport::loadImporters;
            foreach (@importersArray)
            {
                $_->setLangName($options->lang);
                if (($_->getName =~ /\Q$import/) || ($_ =~ /GCExport::GCExporter$export/))
                {
                    $self->{importer} = $_;
                    last;
                }
            }
            $self->leave("Import plugin $import doesn't exist") if $import && (!$self->{importer});
            $self->{importer}->setModel($self->{model});
            $self->{importOptions} = {};
            foreach (@{$self->{importer}->getOptions})
            {
                $self->{importOptions}->{$_->{name}} = $_->{default};
            }
        }
        if ($export)
        {
            GCExport::loadExporters;
            foreach (@exportersArray)
            {
                $_->setLangName($options->lang);
                if (($_->getName eq $export) || ($_ =~ /GCExport::GCExporter$export/))
                {
                    $self->{exporter} = $_;
                    last;
                }
            }
            $self->leave("Export plugin $export doesn't exist") if $export && (!$self->{exporter});
            $self->{exporter}->setModel($self->{model});
            $self->{exportOptions} = {
                                         lang => $self->{lang}
                                     };
            foreach (@{$self->{exporter}->getOptions})
            {
                $self->{exportOptions}->{$_->{name}} = $_->{default};
            }
        }
        
        $self->{toBeRemoved} = [];

        $self->{data} = new GCItems($self->{parent});
        $self->{data}->{options} = $options;

        return $self;
    }
    
    sub DESTROY
    {
        my $self = shift;
        
        unlink $_ foreach (@{$self->{toBeRemoved}});
    }

    sub leave
    {
        my ($self, $message) = @_;
        print "$message\n";
        $self->DESTROY;
        exit 1;
    }

    sub listPlugins
    {
        my $self = shift;

        foreach (sort keys %{$pluginsMap{$self->{model}->getName}})
        {
            print "$_\n";
            print "\t", $pluginsMap{$self->{model}->getName}->{$_}->getAuthor,"\n";
            print "\n";
        }
    }

    sub setModel
    {
        my ($self, $model) = @_;
        $self->{model} = $self->{modelsFactory}->getModel($model);
        if ($self->{exporter})
        {
            $self->{exporter}->setModel($self->{model});
            foreach (@{$self->{exporter}->getOptions})
            {
                $self->{exportOptions}->{$_->{name}} = $_->{default};
            }
        }
        if ($self->{importer})
        {
            $self->{importer}->setModel($self->{model});
            foreach (@{$self->{importer}->getOptions})
            {
                $self->{importOptions}->{$_->{name}} = $_->{default};
            }
        }
        return 1;
    }
    
    sub setFields
    {
        my ($self, $fieldsFile) = @_;

        $self->{fields} = [];
        open FIELDS, '<'.$fieldsFile;
        my $model = <FIELDS>;
        chop $model;
        while (<FIELDS>)
        {
            chop;
            push @{$self->{fields}}, $_;
        }
    }
    
    sub load
    {
        my ($self, $title) = @_;
        my @data;
        $self->leave("No fetch plugin specified") if !$self->{plugin};
        $self->{plugin}->{title} = $title;
        $self->{plugin}->{type} = 'load';
        $self->{plugin}->{urlField} = $self->{model}->{commonFields}->{url};
        $self->{plugin}->load;
        my $itemNumber = $self->{plugin}->getItemsNumber();
        $self->{plugin}->{type} = 'info';
        for (my $i = 0;
                $i < $itemNumber;
                $i++)
        {
            $self->{plugin}->{wantedIdx} = $i;
            my $info = $self->{plugin}->getItemInfo;
            foreach (@{$self->{model}->{managedImages}})
            {
                $info->{$_} = $self->downloadPicture($info->{$_});
            }
            push @data, $info;
        }
        $self->{data}->setItemsList(\@data);
    }
    
    sub save
    {
        my $self = shift;
        my $previousFile = $self->{data}->{options}->file;
        my $previousRelativePaths = $self->{data}->{options}->useRelativePaths;
        my $prevImages = $self->{parent}->getImagesDir;

        
        my $newFile = GCUtils::pathToUnix(File::Spec->rel2abs($self->{file}));
        $self->{data}->{options}->file($newFile);
        $self->{parent}->{file} = $newFile;

        # We re-generate it because it could have changed with new file name
        my $newImages = $self->{parent}->getImagesDir;
        if ($prevImages ne $newImages)
        {
            # The last parameter is for copy. When saving a new file, we move.
            $self->{data}->setNewImagesDirectory($newImages, $prevImages, 1);
        }

        $self->{data}->{model} = $self->{model};
        $self->{data}->{backend} = new GCBackend::GCBeXmlParser($self->{parent})
            if ! $self->{data}->{backend};
        $self->{data}->{options}->useRelativePaths(0) if $self->{useStdOut};
        $self->{data}->save;
        $self->{data}->{options}->useRelativePaths($previousRelativePaths);
        $self->{data}->{options}->file($previousFile);
        open IN, $self->{file};
        if ($self->{useStdOut})
        {
            print $_ while (<IN>);
        }
        close IN;
        unlink $self->{file} if $self->{useStdOut};
    }
    
    sub open
    {
        my ($self, $file) = @_;
        $self->{data}->load($file, undef, undef, 1);
        $self->{original} = $file;
    }

    sub import
    {
        my ($self, $file, $prefs) = @_;
        $self->{importOptions}->{parent} = $self->{parent};
        $self->{importOptions}->{file} = $file;
        $self->{importOptions}->{fields} = $self->{fields};
        $self->parsePrefs($prefs, $self->{importOptions});
        $self->{importer}->{options} = $self->{importOptions};
        $self->{data}->setItemsList($self->{importer}->getItemsArray($file));
        $self->setModel($self->{importer}->getModelName);
        $self->{data}->{model} = $self->{model}
            if $self->{data};
    }
    
    sub export
    {
        my ($self, $prefs) = @_;

        if (!scalar $self->{fields})
        {
            $self->{fields} = $self->{model}->{fieldsNames};
        }
        $self->{exportOptions}->{parent} = $self->{parent};
        $self->{exportOptions}->{fields} = $self->{fields};
        $self->{exportOptions}->{originalList} = $self->{data};
        $self->{exportOptions}->{withPictures} = 1;
        $self->{exportOptions}->{file} = $self->{file};
        $self->{exportOptions}->{collection} = $self->{original};
        $self->{exportOptions}->{fieldsInfo} = $self->{model}->{fieldsInfo};
        $self->{exportOptions}->{items} = $self->{data}->getItemsListFiltered;
        $self->{exportOptions}->{defaultImage} = $ENV{GCS_SHARE_DIR}.'/logos/no.png';
        $self->parsePrefs($prefs, $self->{exportOptions});
        $self->{data}->{model} = $self->{model}
            if $self->{data};

        $self->{exporter}->process($self->{exportOptions});

        CORE::open IN, $self->{exportOptions}->{file};
        if ($self->{useStdOut})
        {
            print $_ while (<IN>);
        }
        close IN;
        unlink $self->{exportOptions}->{file} if $self->{useStdOut};
    }

    sub downloadPicture
    {
        my ($self, $pictureUrl) = @_;
    
        return '' if ! $pictureUrl;
        my ($name,$path,$suffix) = fileparse($pictureUrl, "\.gif", "\.jpg", "\.jpeg", "\.png");
        (undef, my $picture) = tmpnam;
        $picture .= $suffix;

        GCUtils::downloadFile($pictureUrl, $picture, $self->{parent});
        push @{$self->{toBeRemoved}}, $picture;
        return $picture;
    }
    
    sub parsePrefs
    {
        my ($self, $prefs, $cont) = @_;
        
        foreach (split /,/, $prefs)
        {
            my @option = split /=>/, $_;
            $option[0] =~ s/^\s*//g;
            $option[0] =~ s/\s*$//g;
            $option[1] =~ s/^\s*//g;
            $option[1] =~ s/\s*$//g;
            $cont->{$option[0]} = $option[1];
        }
    }
}

1;
