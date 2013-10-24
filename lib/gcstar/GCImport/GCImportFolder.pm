package GCImport::GCImportFolder;

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
    package GCImport::GCImporterFolder;

    use File::Find;
    use File::Basename;
    use base qw(GCImport::GCImportBaseClass);

    use GCPlugins;

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        
        bless ($self, $class);
        return $self;
    }

    sub wantsFieldsSelection
    {
        return 0;
    }

    sub wantsFileSelection
    {
        return 1;
    }
    
    sub wantsDirectorySelection
    {
        return 1;
    }
    
    sub shouldBeHidden
    {
        return 1;
    }

    sub getFilePatterns
    {
       return ();
    }
    
    #Return supported models name
    sub getModels
    {
        return ['GCfilms', 'GCMusics'];
    }

    sub getOptions
    {
        my $self = shift;
        
        my $pluginsList;
        foreach (@{$self->{model}->getPluginsNames})
        {
            my $plugin = $GCPlugins::pluginsMap{$self->{model}->getName}->{$_};
            push @$pluginsList,$plugin->getName;
        }
        
        
        return [
            {
                name => 'plugin',
                type => 'options',
                label => 'Plugin',
                valuesList => $pluginsList
            },
            {
                name => 'multipleResult',
                type => 'options',
                label => 'MultipleResult',
                tooltip => 'MultipleResultTooltip',
                valuesList => 'Ask,AskEnd,AddWithoutInfo,DontAdd,TakeFirst',
                default => 'Ask',
            },
            {
                name => 'noResult',
                type => 'options',
                label => 'NoResult',
                tooltip => 'NoResultTooltip',
                valuesList => 'AddWithoutInfo,DontAdd', # TODO AskNewName AskNewPlugin at End
                default => 'AddEmpty',
            },
            {
                name => 'recursive',
                type => 'yesno',
                label => 'Recursive',
                default => '1'
            },

            {
                name => 'suffixes',
                type => 'short text',
                label => 'Suffixes',
                tooltip => 'SuffixesTooltip',
                default => '',
            },

            {
                name => 'remove',
                type => 'short text',
                label => 'Remove',
                tooltip => 'RemoveTooltip',
                default => '',
            },
            {
                name => 'removeWholeWord',
                type => 'yesno',
                label => 'RemoveWholeWord',
                tooltip => 'RemoveTooltipWholeWord',
                default => '1',
            },
            {
                name => 'removeRegularExpr',
                type => 'yesno',
                label => 'RemoveRegularExpr',
                tooltip => 'RemoveTooltipRegularExpr',
                changedCallback => sub { 
                        my ($self,$widget) =@_;
                            $widget->[0]->{options}->{removeWholeWord}->lock($self->getValue);
                        },
                default => '0',
            },
            {
                name => 'skipFileAlreadyInCollection',
                type => 'options',
                label => 'SkipFileAlreadyInCollection',
                tooltip => 'SkipFileAlreadyInCollectionTooltip',
                valuesList => 'SkipFileNo,SkipFileFullPath,SkipFileFileName,SkipFileFileNameAndUpdate',
                default => 'SkipFileNo',
            },
            {
                name => 'infoFromFileNameRegExp',
                type => 'history text',
                label => 'InfoFromFileNameRegExp',
                tooltip => 'InfoFromFileNameRegExpTooltip',
                initValues => ['',
                                '^$A\s*([[\(]part $x( of $y)?[)\]])?\s*([[\(]$Y[)\]])?\s*$',
                                '^$N\s+[^\w ]\s+S$SE$E\s+[^\w ]\s+$T\s+([[(]part $x( of $y)?[)\]])?\s*$',
                                ],
                default => '',
             },
        ];
        
        
    }
      
    sub getModelName
    {
        my $self = shift;
        return $self->{model}->getName;
    }

    # Required by extracter to make this class acts as a panel
    sub AUTOLOAD
    {
        return [];
    }

    sub getItemsArray
    {
        my ($self, $directory) = @_;
        my @result;
        my @filesList;

        #First we try to get the correct plugin
        my $plugin = $GCPlugins::pluginsMap{$self->{model}->getName}->{$self->{options}->{plugin}};
        $plugin->{bigPics} = $self->{options}->{parent}->{options}->bigPics;
        my $titleField = $self->{model}->{commonFields}->{title};
        my $fileField = $self->{model}->{commonFields}->{play};

        # Required by extracter
        $self->{lang} = $self->{options}->{lang};

        (my $suffixes = $self->{options}->{suffixes}) =~ s/[,; ]/\|/g;
        $suffixes =~ s/\*\.//g;
        # Create list of files
        if ($self->{options}->{recursive})
        {
            find(sub {
                return if -d $File::Find::name;
                return if ! /$suffixes$/;
                my $name=Encode::decode_utf8($File::Find::name);
                push @filesList, $name;
            }, $directory);
        }
        else
        {
            foreach (glob "$directory/*")
            {
                next if -d $_;
                next if ! /$suffixes$/;
                push @filesList, $_;
            }
        }
        my $resultsDialog;
        # initialize choose good result dialog if needed
        if (($self->{options}->{multipleResult} ne 'Ask') || ($self->{options}->{multipleResult} ne 'AskEnd'))
        {
            $resultsDialog = $self->{options}->{parent}->getDialog('Results');
            $resultsDialog->setModel($self->{model}, $self->{model}->{fieldsInfo});
            $resultsDialog->setMultipleSelection(0);
        }
        #Initialize stuff to retrieve info from name with regexp
        my $infoFromName;
        if ($self->{options}->{infoFromFileNameRegExp} ne '')
        {
            my %knownParam=($titleField=>'T',alphabTitle=>'A',year=>'Y',season=>'S',episode=>'E',alphabSeries=>'N',number=>'x',totNumber=>'y');
            my $orderStr= $self->{options}->{infoFromFileNameRegExp};
            $orderStr=~ s/(?<!\$).//g;
            # Search the order of $A $T ... in the user regexp
            my %places;
            foreach my $key (keys %knownParam) {
                my $i=1+index $orderStr,$knownParam{$key};
                $places{$i} = $key;
            }
            my $myRegExp=$self->{options}->{infoFromFileNameRegExp};
            # avoid capturing something else than $T,$A ... make already present () not capturing
            $myRegExp =~ s/(?<!\\)\(/(?:/g;
            my $articles='(?:'.join('|',@{$self->{model}->{parent}->{articles}}).')\'?\b';
            our $myRegExpArt=qr/^(.*?)(?:, ?($articles))?$/i;
            
            $myRegExp =~ s/\$A/(.*?(?:, ?$articles)?)/g;
            $myRegExp =~ s/\$N/(.*?(?:, ?$articles)?)/g;
            $myRegExp =~ s/\$T/(.*?)/;
            $myRegExp =~ s/\$Y/(\\d{2}|\\d{4}?)/;
            $myRegExp =~ s/\$x/(\\d{1,2})/;
            $myRegExp =~ s/\$y/(\\d{1,2})/;
            $myRegExp =~ s/\$E/(\\d{1,4}?)/;
            $myRegExp =~ s/\$S/(\\d{1,2}?)/;
            sub deAlpha{
                my $s;
                $_[0] =~ $myRegExpArt;
                $s=$1;
                my $a=$2.' ' if $2 && (substr($2,-1) ne '\'');
                $s=$a.$s if $a;
                return $s;
            }
            # Check if regexp is good
            my $pattern = shift;
            my $test = eval { $myRegExp=qr/$myRegExp/i };
            #print $myRegExp;
            #
            if ($@)
            {
                $myRegExp= qr/./ ;print $@;
            }
            my $i=2;
            $infoFromName=sub {
                my $n=$_[0] ;
                $n=~ $myRegExp;
                my %info; # TODO Can be more readable in Perl 5.10 by using named capturing
                $info{$places{1}}=$1 if $1;$info{$places{2}}=$2 if $2;$info{$places{3}}=$3 if $3;$info{$places{4}}=$4 if $4;$info{$places{5}}=$5 if $5;
                $info{$places{6}}=$6 if $6;$info{$places{7}}=$7 if $7;$info{$places{8}}=$8 if $8;$info{$places{9}}=$9 if $9;$info{$places{10}}=$10 if $10;
                $info{$places{11}}=$11 if $11;$info{$places{12}}=$12 if $12;$info{$places{13}}=$13 if $13;$info{$places{14}}=$14 if $14;$info{$places{15}}=$15 if $15;
                $info{$places{16}}=$16 if $16;$info{$places{17}}=$17 if $17;$info{$places{18}}=$18 if $18;$info{$places{19}}=$19 if $19;$info{$places{20}}=$20 if $20;

                $info{$titleField}=deAlpha($info{alphabTitle}) if($info{alphabTitle});
                $info{series}=deAlpha($info{alphabSeries}) if($info{alphabSeries});
                return \%info;
            }
        }
        # initialize regexp word to remove
        my $removed =$self->{options}->{remove};
        if(!$self->{options}->{removeRegularExpr})
        {
            $removed =~ s/[,; ]/\|/g;
            if($self->{options}->{removeWholeWord})
            {
                $removed=~s/\|/\\b\|\\b/g ;
                $removed='\b'.$removed.'\b';
            }
        }
        # if we want to ignore files already in the list
        # we initialize a hash with filenames to be fast !
        my %fileNameKnown;
        if($self->{options}->{skipFileAlreadyInCollection} ne 'SkipFileNo')
        {
            if($self->{options}->{skipFileAlreadyInCollection} eq 'SkipFileFullPath')
            {
                foreach my $originalFilm(@{$self->{options}->{originalList}->{itemArray}})
                {
                    $fileNameKnown{$originalFilm->{$fileField}}=$originalFilm;
                }
            }
            else
            {
                foreach my $originalFilm(@{$self->{options}->{originalList}->{itemArray}})
                {
                    $fileNameKnown{basename($originalFilm->{$fileField})}=$originalFilm;
                }
            }
        }
        my $hasFileWaiting=0;my $inWaitingQueue=0;
        # Main loop on files entries
        file: foreach my $file(@filesList)
        {
            if($file eq 'WaitingList')
            {
                $inWaitingQueue=1;
                next file;
            }
            # Skip file already in the collection
                next file if(($self->{options}->{skipFileAlreadyInCollection} eq 'SkipFileFullPath') && (exists $fileNameKnown{$file}));
                next file if(($self->{options}->{skipFileAlreadyInCollection} eq 'SkipFileFileName') && (exists $fileNameKnown{basename($file)}));
                if(($self->{options}->{skipFileAlreadyInCollection} eq 'SkipFileFileNameAndUpdate') && (exists $fileNameKnown{basename($file)}))
                {
                    # if filename already in collection, and collection full path invalid : correct it
                    if (!(-e $fileNameKnown{basename($file)}->{$fileField}))
                    {
                        print "Path updated : ",$fileNameKnown{basename($file)}->{$fileField},"\n";
                        print "           --> ",$file,"\n";
                        $fileNameKnown{basename($file)}->{$fileField}=$file;
                    }
                    next file;
                }
            
            # Get info from the file (avi, mp3, ...)
            my $extracter = $self->{model}->getExtracter($self, $file, $self, $self->{model});
            my $extracted = $extracter->getInfo;
             # Add info from file
            my $infoFromFile={$fileField => $file};
            foreach my $field(keys %$extracted)
            {
                $infoFromFile->{$field} = $extracted->{$field}->{value};
            }
            
            # Test if subtitle is present
            if ($self->{model}->getName eq 'GCfilms')
            {
                my @subtitlesExt=qw(sub srt);
                my @subtitlesFiles;
                my $startFileName=$file;
                $startFileName=~s/\.[^.]*$//;
                for my $ext(@subtitlesExt)
                {
                    my $fileSubsName=$startFileName.'.'.$ext;
                    if(-e $fileSubsName)
                    {
                        #TODO Try to guess the language see cpan 
                        my $lang=["Yes"];
                        push @subtitlesFiles,$lang;
                    }
                }
                $infoFromFile->{subt}=\@subtitlesFiles if (@subtitlesFiles);
            }
            my $infoFromFileName;
            my $name = basename($file);
            # Filter the name
            # Remove suffix
            $name =~ s/\.[^.]*$//;
            # Try to apply regexp on filename
            if ($self->{options}->{infoFromFileNameRegExp} ne '')
            {
                $infoFromFileName=&$infoFromName($name);
                $name = $infoFromFileName->{$titleField} if ($infoFromFileName->{$titleField} ne '');
                #TODO: Use this known info to search with plugin
            }
            # Remove everything between () {} []
            $name =~ s/[\(\[\{].*?[\)\]\}]/ /g;
            # Remove special characters
            $name =~ s/[-\._,#@"']/ /g;
            #'"
            # Remove info from extracter for movies
            if ($self->{model}->getName eq 'GCfilms')
            {
                my $info = $extracted->{video}->{value}.'|'.$extracted->{audio}->{value}->[0]->[1];
                $info =~ s/ (.*?)//g;
                $name =~ s/$info//g;
            }
            $name =~ s/$removed//gi;

            # $name contains the title to search
            $plugin->{title} = $name;
            $plugin->{type} = 'load';
            $plugin->{urlField} = $self->{model}->{commonFields}->{url};
            $plugin->{searchField} = $titleField;

            #Initialize what will be pushed in the array
            my $infoPlugin = {$titleField => $name};
        
            $self->{options}->{parent}->setWaitCursor($self->{options}->{lang}->{StatusSearch}.' ('.$name.')');
            $plugin->load;

            my $itemNumber = $plugin->getItemsNumber;

            if ($itemNumber == 0)
            {
                goto endPluginGetItemInfo if (($self->{options}->{noResult} eq 'AddEmpty'));
                next file if (($self->{options}->{noResult} eq 'DontAdd'));
            }
            else
            {
                $plugin->{type} = 'info';
                if (($itemNumber == 1) || ($self->{options}->{multipleResult} eq 'TakeFirst'))
                {
                    $plugin->{wantedIdx} = 0;
                }
                elsif($self->{options}->{multipleResult} eq 'AddWithoutInfo' )
                {
                    goto endPluginGetItemInfo;
                }
                elsif($self->{options}->{multipleResult} eq 'DontAdd' )
                {
                    next file;
                }
                elsif($self->{options}->{multipleResult} eq 'AskEnd' && !$inWaitingQueue)
                {
                    # re push the filename at the end of the list, to be proceded
                    push @filesList,'WaitingList' if !$hasFileWaiting;
                    push @filesList,$file;
                    $hasFileWaiting=1;
                    next file;
                }
                else
                {
                    # Ask the user to choose
                    my $withNext = 0;
                    my @items = $plugin->getItems;
                    $resultsDialog->setWithNext(0);
                    $resultsDialog->setSearchPlugin($plugin);
                    $resultsDialog->setList($name, @items);
                    $resultsDialog->show;
                    if ($resultsDialog->{validated})
                    {
                        $plugin->{wantedIdx} = $resultsDialog->getItemsIndexes->[0];
                    }
                }
                $infoPlugin = $plugin->getItemInfo;
                my $title = $infoPlugin->{$titleField};
                $self->{options}->{parent}->{defaultPictureSuffix} = $plugin->getDefaultPictureSuffix;
                foreach my $field(@{$self->{model}->{managedImages}})
                {
                    $infoPlugin->{$field} = '' if $infoPlugin->{$field} eq 'empty';
                    next if !$infoPlugin->{$field};
                    ($infoPlugin->{$field}) = $self->{options}->{parent}->downloadPicture($infoPlugin->{$field}, $title);
                }
                $infoPlugin->{plugin} =$plugin->getName();
                $infoPlugin->{comment} = $self->getLang->{CommentAuto}
                                 . "\n"
                                 . $self->getLang->{CommentSite}
                                 . $plugin->getName()
                                 . "\n"
                                 . $self->getLang->{CommentTitle}
                                 . $name
                                 . "\n"
                                 . $extracted->{comment}->{displayed};
           }
            endPluginGetItemInfo:
           
            # Add the default value
            my $defaultInfo = $self->{model}->getDefaultValues;
            
            my $info;
            # TODO : ask the user for order, or even for order on each fields
            my @order=($defaultInfo,$infoFromFile,$infoFromFileName,$infoPlugin);
            for my $infoSource(@order)
            {
                foreach my $field(keys %$infoSource)
                {
                    $info->{$field} =$infoSource->{$field} if $infoSource->{$field};
                }
            }
            push @result, $info;
            $self->{options}->{parent}->restoreCursor;            
        }
        return \@result;
    }
    
    
    sub getEndInfo
    {
        my $self = shift;
        my $message;
                
        return $message;
    }
}

1;
