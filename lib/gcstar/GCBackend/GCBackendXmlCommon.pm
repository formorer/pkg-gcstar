package GCBackend::GCBackendXmlCommon;

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

{
    package GCBackend::GCBeXmlBase;
    
    use File::Temp qw/ tempfile /;
    use File::Copy;

    my %xmlConv = (
                   '&' => '&amp;',
                   '"' => '&quot;',
                   '<' => '&lt;',
                   '>' => '&gt;',
                   '' => '',
                  );
    my $toBeReplaced = join '', keys %xmlConv;

    sub new
    {
        my ($proto, $modelLoader) = @_;
        my $class = ref($proto) || $proto;
        my $self  = {modelLoader => $modelLoader};
        bless $self, $class;
        return $self;
    }

    sub getVersion
    {
        my $self = shift;
        my $version = undef;
        return $version if (! -r $self->{file});
        open DATA, $self->{file};
        binmode(DATA, ':utf8');
        while (<DATA>)
        {
            next if ! /^\s*<collection.*/;
            $version = $1
                if /version="([^"]*)"/;
            last;
        }
        close DATA;
        return $version;
    }

    sub prepareModel
    {
        my ($self, $file) = @_;
        open COLLECTION, $file;
        my $model;
        while (<COLLECTION>)
        {
            if (/type="(.*?)"/)
            {
                $model = $1;
                last;
            }
        }
        close COLLECTION;
        $self->{modelLoader}->preloadModel($model);
    }

    sub setParameters
    {
        my ($self, %options) = @_;
        $self->{$_} = $options{$_} foreach keys %options;
    }

    sub hashToXMLString
    {
        my %hash = @_;
        my $result = '';
        foreach (keys %hash)
        {
            $result .= " $_=\"".$hash{$_}.'"';
        }
        return $result;
    }
    
    sub listToXml
    {
        my $value = shift;
        my $xml = '';
        my $col;
        foreach (@{$value})
        {
            $xml .= '   <line>
';
            foreach $col(@{$_})
            {
                (my $newCol = $col) =~ s/([$toBeReplaced])/$xmlConv{$1}/go;
                #"
                $xml .= "    <col>$newCol</col>\n";
            }
            $xml .= '   </line>
';
        }
        return $xml;
    }

    sub setHistories
    {
        my ($self, $histories) = @_;

        $self->{histories} = $histories;
    }

    sub save
    {
        my ($self, $data, $info, $splash, $keepCurrentValueForDate) = @_;

        # Save into a new file to prevent crashes during saving
        (my ($tmpFd, $tmpFile)) = tempfile();
        if (!$tmpFd)
        {
            my @error = ('SaveError', '');
            return {error => \@error};
        }

        binmode($tmpFd, ':utf8');

        my $xmlModel = '';
        my $xmlPreferences = '';
        my $collectionType;
        my $versionString = '';
        
        if (exists $self->{version})
        {
            $versionString = ' version="'.$self->{version}.'"';
        }
        if (($self->{modelLoader}->{model}->isInline)
         || ($self->{modelLoader}->{model}->isPersonal && $self->{standAlone}))
        {
            $xmlModel = $self->{modelLoader}->{model}->toString('collectionInlineDescription', 1);
            $xmlPreferences = $self->{modelLoader}->{model}->{preferences}->toXmlString;
            $collectionType = 'inline';
        }
        else
        {
            $collectionType = $self->{modelLoader}->{model}->getName;
            $xmlModel = $self->{modelLoader}->{model}->toStringAddedFields('userCollection');
        }
        my $information = ' <information>
';
        $information .= "  <$_>".GCUtils::encodeEntities($info->{$_})."</$_>\n"
            foreach (sort keys %{$info});
        $information .= ' </information>';

        # Change this to 1 to save history. Not fully functional yet
        # Because we don't remove item that are no more present in data.
        my $withHistory = 0;
        my $histories;
        if ($withHistory)
        {
            $histories = ' <histories>
';
            foreach (keys %{$self->{histories}})
            {
                $histories .= "  <history name=\"$_\">\n";
                foreach my $value(@{$self->{histories}->{$_}})
                {
                    if (ref($value) eq 'ARRAY')
                    {
                        $histories .= '   <values>
';
                        foreach my $entry(@$value)
                        {
                            next if $entry eq '';
                            $entry =~ GCUtils::encodeEntities($entry);
                            $histories .= "    <value>$entry</value>\n";
                        }
                        $histories .= '   </values>
';
                    }
                    else
                    {
                        next if $value eq '';
                        $histories .= '   <value>'.GCUtils::encodeEntities($value)."</value>\n";
                    }
                }
                $histories .= '  </history>
';
            }
            $histories .= ' </histories>';
        }

        my $number = 0;
        $number = scalar @$data;

        print $tmpFd '<?xml version="1.0" encoding="UTF-8"?>
<collection type="',$collectionType,'" items="',$number,'"', $versionString,'>
',$information,'
',$xmlModel,'
',$xmlPreferences,'
',$histories,'
';
        my $i = 1;
        foreach (@$data)
        {
            #Perform the transformation for each image value
            foreach my $pic(@{$self->{modelLoader}->{model}->{managedImages}})
            {
                $_->{$pic} 
                    = $self->{modelLoader}->transformPicturePath($_->{$pic}, undef, $_, $pic);
            }

            print $tmpFd ' <item
';
            my @complexFields;
            my @longFields;
            foreach my $field(@{$self->{modelLoader}->{model}->{fieldsNames}})
            {
                if (ref($_->{$field}) eq 'ARRAY')
                {
                    push @complexFields, $field;
                }
                elsif ($self->{modelLoader}->{model}->{fieldsInfo}->{$field}->{type}
                       eq 'long text')
                {
                    push @longFields, $field;
                }
                else
                {
                    (my $data = $_->{$field}) =~ s/([$toBeReplaced])/$xmlConv{$1}/go;
                    if (($self->{modelLoader}->{model}->{fieldsInfo}->{$field}->{type} eq 'date')
                     && ($data eq 'current')
                     && (!$keepCurrentValueForDate))
                    {
                        my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
                        $data = sprintf('%02d/%02d/%4d', $mday, $mon+1, 1900+$year);
                    }
                    print $tmpFd '  ', $field, '="', $data, '"
';
                }
            }
            print $tmpFd ' >
';
            foreach my $field(@longFields)
            {
                #(my $data = $_->{$field}) =~ s/&/&amp;/g;
                #$data =~ s/</&lt;/g;
                #$data =~ s/>/&gt;/g;
                #$data =~ s/"/&quot;/g;
                (my $data = $_->{$field}) =~ s/([$toBeReplaced])/$xmlConv{$1}/go;
                #"
                print $tmpFd '  <', $field, '>', $data, '</', $field, '>
';
            }
            foreach my $field(@complexFields)
            {
                print $tmpFd '  <', $field, '>
', listToXml($_->{$field}), '  </', $field, '>
';
            }

            print $tmpFd ' </item>
';
            $splash->setProgressForItemsDisplay($i) if $splash;

            $self->{modelLoader}->restoreInfo($_)
                if $self->{wantRestore};

            $i++;
        }
        print $tmpFd '</collection>
';
        close $tmpFd;

        # Now everything is OK, we move the temporary file over the correct one
        if (!move($tmpFile, $self->{file}))
        {
            my @error = ('SaveError', $!);
            return {error => \@error};
        }

        return {error => undef};
    }
}

1;
