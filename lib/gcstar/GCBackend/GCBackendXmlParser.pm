package GCBackend::GCBackendXmlParser;

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
use utf8;
use filetest 'access';
use GCBackend::GCBackendXmlCommon;

{
    package GCBackend::GCBeXmlParser;

    use File::Temp qw/ tempfile /;
    use File::Copy;

    use base 'GCBackend::GCBeXmlBase';
    
    my $globalInstance;
    my $globalSplash;
    my $globalModelLoader;
    #my @data;
    #my %information;
    #my %histories;
    my $maxId;
    my $savedMaxId;
    my $historyInline;

    sub load
    {
        my ($self, $splash) = @_;

        if (! -r $self->{file})
        {
            my @error = ('OpenError', '');
            return {error => \@error};
        }

        $self->{data} = [];
        $self->{information} = {};
        $self->{histories} = ();
        $maxId = 0;
        $savedMaxId = 0;

        $globalInstance = $self;
        $globalSplash = $splash;
        $globalModelLoader = $self->{modelLoader};
        
        my $parser = XML::Parser->new(Handlers => {
            Init  => \&StartDocument,
            Final => \&EndDocument,
            Start => \&StartTag,
            End   => \&EndTag,
            Char  => \&Text,
        });
        # We have to preload the model into cache because XML::Parser is not
        # re-entrant. Then when we begin parsing, we cannot parse the model
        $self->prepareModel($self->{file});
        my $error = undef;
        while (1)
        {
            eval {
                $parser->parsefile($self->{file});
            };
            if ($@)
            {
                my $errorDesc = $@;

                # Here we will fix the collection if an invalid character was found by trying to remove it.
                # There should be room for optimisation here

                if ($errorDesc =~ /not\s*well-formed\s*\(invalid\s*token\)\s*.*?byte\s*(\d+)/)
                {
                    my $charPosition = $1;
                    # We would have failed before if it cannot be opened, so we don't check that.
                    open COL, $self->{file};
                    seek COL, $charPosition, 0;
                    my $badChar;
                    read COL, $badChar, 1;
                    seek COL, 0, 0;
                    (my ($newCol, $tmpFile)) = tempfile();
                    while (<COL>)
                    {
                        s/$badChar//g;
                        print $newCol $_;
                    }
                    close $newCol;
                    close COL;
                    move($tmpFile, $self->{file});
                }
                else
                {
                    $errorDesc =~ s/^\n*//;
                    my @errorArray = ('OpenFormatError', $errorDesc);
                    $error = \@errorArray;
                    last;
                }
            }
            else
            {
                last;
            }
        }

        # TODO : Compare performances with and without the compact below because the duplicates are checked
        # also when adding to the graphical components
        # Compact histories. We didn't filtered previously for performances issues
        #GCUtils::compactHistories(\%histories);

        $self->{information}->{maxId} = $maxId
            if ! exists $self->{information}->{maxId};

        # gotHistory:
        #  0: Nothing done
        #  1: Returning history
        #  2: Already initialized

        return {
            error => $error,
            data => $self->{data},
            information => $self->{information},
            histories => \$self->{histories},
            gotHistory => (1 + ($historyInline ? 0 : 1)),   # We always have an initalized history with this BE.
        };
    }

    # Parser routines
    
    # Some globals to speed up things
    my $inCol;
    my $inLine;
    my $currentTag;
    my $currentCol;
    my $currentCount;
    my $currentIsList;
    my $isItem;
    my $isInfo;
    my $newItem;
    my $modCap;
    my $prefCap;
    my $anyCap;
    my $isInline;
    my $inlineModel;
    my $inlinePreferences;

    my $inHistories;
    my $historyField;
    # history type : 
    #  1 : Single list
    #  2 : Multiple list
    my $historyType;
    my $historyCap;
    
    sub StartDocument
    {
        $isItem = 0;
        $inLine = 0;
        $inCol = 0;
        $currentCol = '';
        $currentCount = 0;
        $modCap = 0;
        $prefCap = 0;
        $anyCap = 0;
        $inlineModel = '';
        $inlinePreferences = '';

# SAVED HISTORIES DEACTIVATED
#        $inHistories = 0;
#        $historyField = '';
#        $historyCap = 0;
        $historyInline = 0;
    }
    
    sub EndDocument
    {
        if (($inlineModel) &&  ($isInline))
        {
            $globalModelLoader->setCurrentModelFromInline({inlineModel => $inlineModel,
                                                           inlinePreferences => $inlinePreferences});
        }
    }
    
    sub StartTag
    {
        #my ($expat, $tag, %attrs) = @_;
        if ($isItem)
        {
            if ($inLine)
            {
                #Only a col could start in a line
                $inCol = 1;
            }
            elsif ($_[1] eq 'line')
            {
                $inLine = 1;
                $currentIsList = 1;
                $newItem->{$currentTag} = [] if (ref($newItem->{$currentTag}) ne 'ARRAY');
                push @{$newItem->{$currentTag}}, [];
            }
            else
            {
                $currentIsList = 0;
                $currentTag = $_[1];
            }
        }
        elsif ($isInfo)
        {
            $currentTag = $_[1];
            $savedMaxId = 1 if $currentTag eq 'maxId';
        }
        else
        {
            my ($expat, $tag, %attrs) = @_;
            if ($modCap)
            {
                $tag =~ s/^user(.)/\L$1\E/;;
                $inlineModel .= "<$tag".GCBackend::GCBeXmlBase::hashToXMLString(%attrs).'>';
            }
            elsif ($prefCap)
            {
                $inlinePreferences .= "<$tag".GCBackend::GCBeXmlBase::hashToXMLString(%attrs).'>';
            }
            elsif ($tag eq 'item')
            {
                $newItem = \%attrs;
                $isItem = 1;
            }
            elsif ($tag eq 'information')
            {
                $isInfo = 1;
            }
            elsif (($tag eq 'collectionInlineDescription') || ($tag eq 'userCollection'))
            {
                $modCap = 1;
                $anyCap = 1;
                $inlineModel = '<collection'.GCBackend::GCBeXmlBase::hashToXMLString(%attrs).">\n";
            }
            elsif ($tag eq 'collectionInlinePreferences')
            {
                $prefCap = 1;
                $anyCap = 1;
                $inlinePreferences = '<preferences'.GCBackend::GCBeXmlBase::hashToXMLString(%attrs).">\n";
            }
            elsif ($tag eq 'collection')
            {
                $globalSplash->setItemsTotal($attrs{items})
                    if $globalSplash;
                if ($attrs{type} eq 'inline')
                {
                    $isInline = 0;
                }
                else
                {
                    if (! $globalModelLoader->setCurrentModel($attrs{type}))
                    {
                        die $globalModelLoader->{lang}->{ErrorModelNotFound}.$attrs{type}
                           ."\n\n"
                           .$globalModelLoader->getUserModelsDirError."\n";
                    }
                }
            }
# SAVED HISTORIES DEACTIVATED
#            elsif ($tag eq 'histories')
#            {
#                $inHistories = 1;
#                $historyInline = 1;
#            }
#            elsif ($inHistories)
#            {
#                if ($tag eq 'history')
#                {
#                    $historyField = $attrs{name};
#                    # Default is single
#                    $historyType = 1;
#                }
#                elsif ($tag eq 'values')
#                {
#                    push @{$globalInstance->{histories}->{$historyField}}, [];
#                    $historyType = 2;
#                }
#                elsif ($tag eq 'value')
#                {
#                    if ($historyType == 1)
#                    {
#                        push @{$globalInstance->{histories}->{$historyField}}, ''; 
#                    }
#                    else
#                    {
#                        push @{$globalInstance->{histories}->{$historyField}->[-1]}, '';
#                    }
#                    $historyCap = 1;
#                }
#            }
        }
    }

    sub EndTag
    {
        if ($anyCap)
        {
            if ($modCap)
            {
                if (($_[1] eq 'collectionInlineDescription') || ($_[1] eq 'userCollection'))
                {
                    $anyCap = $prefCap;
                    $modCap = 0;
                    $inlineModel .= '</collection>';
                    if ($inlinePreferences)
                    {
                        $globalModelLoader->setCurrentModelFromInline({inlineModel => $inlineModel,
                                                                       inlinePreferences => $inlinePreferences});
                        $inlineModel = undef;
                    }
                    elsif($_[1] eq 'userCollection')
                    {
                        $globalModelLoader->addFieldsToDefaultModel($inlineModel);
                        $inlineModel = undef;
                    }
                        
                }
                else
                {
                    (my $tag = $_[1]) =~ s/^user(.)/\L$1\E/;
                    $inlineModel .= "</$tag>\n";
                }
                return;
            }
            else
            {
                if ($_[1] eq 'collectionInlinePreferences')
                {
                    $anyCap = $modCap;
                    $prefCap = 0;
                    $inlinePreferences .= '</preferences>';
                    if ($inlineModel)
                    {
                        $globalModelLoader->setCurrentModelFromInline({inlineModel => $inlineModel,
                                                                       inlinePreferences => $inlinePreferences});
                        $inlineModel = '';
                    }
                }
                else
                {
                    $inlinePreferences .= '</'.$_[1].">\n";
                }
                return;
            }
        }

        if ($_[1] eq 'item')
        {
            push @{$globalInstance->{data}}, $newItem;
            $currentCount++;
#           SAVED HISTORIES DEACTIVATED
#            if (!$historyInline)
#            {
                #foreach (@{$globalModelLoader->{model}->{fieldsHistory}})
                #{
                #    push @{$globalInstance->{histories}->{$_}}, $newItem->{$_};
                #}
                if ($globalModelLoader->{panel})
                {
                    foreach (@{$globalModelLoader->{model}->{fieldsHistory}})
                    {
                        $globalModelLoader->{panel}->{$_}->addHistory($newItem->{$_}, 1);
                    }
                }
#            }
            foreach (@{$globalModelLoader->{model}->{fieldsNotNull}})
            {
                $newItem->{$_} = $globalModelLoader->{model}->{fieldsInfo}->{$_}->{init} if ! $newItem->{$_};
            }
            
            if (!$savedMaxId)
            {
                my $id = $newItem->{$globalModelLoader->{model}->{commonFields}->{id}};
                $maxId = $id
                    if $id > $maxId;
            }

            $globalSplash->setProgressForItemsLoad($currentCount)
                if $globalSplash;

            $isItem = 0;
        }
        elsif ($_[1] eq 'information')
        {
            $isInfo = 0 if !$isItem;
        }
        elsif ($inCol)
        {
            # We are closing a col as it could not have tags inside
            push @{$newItem->{$currentTag}->[-1]}, $currentCol;
            $currentCol = '';
            $inCol = 0;            
        }
# SAVED HISTORIES DEACTIVATED
#        elsif ($inHistories)
#        {
#            $inHistories = 0 if $_[1] eq 'histories';
#            $historyField = '' if $_[1] eq 'history';
#            $historyCap = 0 if $_[1] eq 'value';
#
#        }
        else
        {
            # The only tag that could prevent us from closing a line is col, but it has
            # already been managed
            if ($inLine)
            {
                $inLine = 0;
            }
            else
            {
                $currentTag = '';
            }
        }
    }

    sub Text
    {
        if ($isItem)
        {
            if ((! $currentTag)
             || $inLine
             || $currentIsList
             || ((!$newItem->{$currentTag}) && ($_[1] =~ /^\s*$/oms)))
            {
                if ($inCol)
                {
                    return if $_[1] =~ /^\s*$/oms;
                    $currentCol .= $_[1];
                }
            }
            else
            {
                $newItem->{$currentTag} .= $_[1];
            }
        }
        elsif ($isInfo)
        {
            return if $_[1] =~ /^\s*$/oms;
            $globalInstance->{information}->{$currentTag} .= $_[1];
        }
        else
        {
            if ($modCap)
            {
                $inlineModel .= $_[1];
            }
            elsif ($prefCap)
            {
                $inlinePreferences .= $_[1];
            }
#            elsif ($historyCap)
#            {
#                if ($historyType == 1)
#                {
#                    $globalInstance->{histories}->{$historyField}->[-1] .= $_[1];
#                }
#                else
#                {
#                    $globalInstance->{histories}->{$historyField}->[-1]->[-1] .= $_[1];
#                }
#            }
        }
    }

}


1;
