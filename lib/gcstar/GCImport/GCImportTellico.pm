package GCImport::GCImportTellico;

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
    package GCImport::GCImporterTellico;

    use base qw(GCImport::GCImportBaseClass);
    use File::Spec;
 
    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);

        $self->checkModule('Archive::Zip');
        $self->checkModule('MIME::Base64');

        # Associate a Tellico type to a GCstar model
        $self->{models} = {
                              2 => 'GCbooks',
                              3 => 'GCfilms',
                              4 => 'GCmusics',
                              8 => 'GCcoins',
                              11 => 'GCgames'
                          };

        return $self;
    }

    sub getName
    {
        return "Tellico (.tc)";
    }
    
    sub getOptions
    {
        my $self = shift;
        my @options;
        return \@options;
    }
    
    sub getFilePatterns
    {
        my $self = shift;
    
        return (['Tellico Format (.tc)', '*.tc'], ['Tellico XML (.xml)', '*.xml']);
    }
    
    #Return supported models name
    sub getModels
    {
        my $self = shift;
        my @models = values %{$self->{models}};
        return \@models;
    }

    sub getModelName
    {
        my $self = shift;
        
        return $self->{extractedModel};
    }
    
    sub wantsFieldsSelection
    {
        return 0;
    }
    
    sub getEndInfo
    {
        my $self = shift;
    
        return $self->{parsingError};
    }
    
    sub getItemsArray
    {
        my ($self, $file) = @_;

        my @result = ();
    	
    	my $xml;
    	
    	# File type is based on suffix
    	# T is for Tellico (zipped file)
    	# X is for XML
    	$self->{type} = ($file =~ m/tc$/) ? 'T' : 'X';
    	#Then we test to be sure
    	eval
    	{
            $self->{zip} = Archive::Zip->new($file);
    	};
    	#First we uncompress file
        if (($self->{type} eq 'T') && ($self->{zip}))
        {
            $xml = $self->{zip}->contents('tellico.xml');
        }
        else
        {
            $self->{type} = 'X';
            open XML, $file;
            $xml = do {local $/; <XML>};
            close XML;
        }
	
        #Then we parse XML data
        my $xs = XML::Simple->new;
        my $tellico = $xs->XMLin($xml,
                                 SuppressEmpty => '',
                                 ForceArray => 1);
        my $collection = $tellico->{collection}->[0];
	
    	$self->{extractedModel} = $self->{models}->{$collection->{type}};
        #We check we know this model
        if (! $self->{extractedModel})
        {
            $self->{parsingError} = $self->getLang->{NotSupported};
            return \@result;
        }

        my %tmpMap;
        # If there are no ids, we have an array in $collection
        if (ref ($collection->{entry}) eq 'ARRAY')
        {
            my $i = 0;
            #Then we prepare a map
            foreach (@{$collection->{entry}})
            {
                $tmpMap{$i} = $_;
                $i++;
            }
        }
        else
        {
            %tmpMap = %{$collection->{entry}};
        }
	    #Loop on entries
	    my $i = 0;

	    my $methodName = 'get'.$self->{extractedModel}.'Item';
	    
        while (my ($id, $entry) = each (%tmpMap))
        {
            $result[$i] = $self->$methodName($entry, $collection);
            $i++;
        }
        return \@result;

    }

    sub getGCfilmsItem
    {
        my ($self, $entry, $collection) = @_;
        
        my %result;
    
        $result{title} = $entry->{title}->[0];
        $result{format} = $entry->{medium}->[0];
        $result{date} = $entry->{year}->[0];
        my $certification = $entry->{certification}->[0];
        if ($certification eq 'U (USA)')
        {
            $result{age} = 1;
        }
        elsif ($certification eq 'G (USA)')
        {
            $result{age} = 2;
        }
        elsif ($certification eq 'PG (USA)')
        {
            $result{age} = 5;
        }
        elsif ($certification eq 'PG-13 (USA)')
        {
            $result{age} = 13;
        }
        elsif ($certification eq 'R (USA)')
        {
            $result{age} = 17;
        }
        $result{genre} = [];
        if ($entry->{genres}->[0])
        {
            for my $genre(@{$entry->{genres}->[0]->{genre}})
            {
                push @{$result{genre}}, [$genre];
            }
        }
        if ($entry->{nationalitys}->[0])
        {
            for my $country(@{$entry->{nationalitys}->[0]->{nationality}})
            {
                $result{country} .= $country.', ';
            }
        }
        $result{country} =~ s/, $//;
    
        $result{video} = $entry->{format}->[0];
        if ($entry->{casts}->[0])
        {
            for my $cast(@{$entry->{casts}->[0]->{cast}})
            {
                $result{actors} .= $cast->{column}->[0];
                $result{actors} .= ' ('.$cast->{column}->[1].')' if $cast->{column}->[1];
                $result{actors} .= ', ';
            }
        }
        $result{actors} =~ s/, $//;
    
        if ($entry->{directors}->[0])
        {
            for my $director(@{$entry->{directors}->[0]->{director}})
            {
                $result{director} .= $director.', ';
            }
        }
        $result{director} =~ s/, $//;
        
        $result{audio} = [];
        if ($entry->{languages}->[0])
        {
            for my $language(@{$entry->{languages}->[0]->{language}})
            {
                push @{$result{audio}}, [$language];
            }
        }
        $result{subt} = [];
        if ($entry->{subtitles}->[0])
        {
            for my $subtitle(@{$entry->{subtitles}->[0]->{subtitle}})
            {
                push @{$result{subt}}, [$subtitle];
            }
        }    
        $result{time} = $entry->{'running-time'}->[0];
        $result{synopsis} = $entry->{plot}->[0];
        $result{synopsis} =~ s{(<|&lt;)br/>}{\n}g;
    
        $result{rating} = $self->convertRating($entry->{rating}->[0]);
        #$result{borrower} = 'none' if (! $entry->{loaned});
        $result{borrower} = 'Unknown' if ($entry->{loaned}->[0] eq 'true');
        $result{comment} = $entry->{comments}->[0];
    
        #Picture management
        $result{image} = $self->getPicture($collection, $entry->{cover}->[0], $result{title});
        
        return \%result;
    }
	
    sub getGCgamesItem
    {
        my ($self, $entry, $collection) = @_;
        
        my %result;
    
        $result{name} = $entry->{title}->[0];
        $result{platform} = $entry->{platform}->[0];
        $result{released} = $entry->{year}->[0];
        $result{genre} = [];
        if ($entry->{genres}->[0])
        {
            for my $genre(@{$entry->{genres}->[0]->{genre}})
            {
                push @{$result{genre}}, [$genre];
            }
        }
        if ($entry->{publishers}->[0])
        {
            for my $editor(@{$entry->{publishers}->[0]->{publisher}})
            {
                $result{editor} .= $editor.', ';
            }
            $result{editor} =~ s/, $//;
        }
        if ($entry->{developers}->[0])
        {
            for my $developer(@{$entry->{developers}->[0]->{developer}})
            {
                $result{developer} .= $developer.', ';
            }
            $result{developer} =~ s/, $//;
        }
        $result{description} = $entry->{description}->[0];
        $result{rating} = $self->convertRating($entry->{rating}->[0]);
        $result{completion} = 100 if $entry->{completed}->[0] eq 'true';
        $result{borrower} = 'Unknown' if ($entry->{loaned}->[0] eq 'true');
        $result{boxpic} = $self->getPicture($collection, $entry->{cover}->[0], $result{name});
        return \%result;
    }
	
    sub getGCbooksItem
    {
        my ($self, $entry, $collection) = @_;
        
        my %result;
    
        $result{title} = $entry->{title}->[0];
        $result{isbn} = $entry->{isbn}->[0];
        $result{authors} = [];
        if ($entry->{authors}->[0])
        {
            for my $author(@{$entry->{authors}->[0]->{author}})
            {
                push @{$result{authors}}, [$author];
            }
        }
        $result{publisher} = $entry->{publisher}->[0];
        $result{publication} = $entry->{pub_year}->[0];
        if ($entry->{languages}->[0])
        {
            for my $language(@{$entry->{languages}->[0]->{language}})
            {
                $result{language} .= $language.', ';
            }
            $result{language} =~ s/, $//;
        }
        $result{serie} = $entry->{series}->[0];
        $result{rank} = $entry->{series_num}->[0];
        $result{edition} = $entry->{edition}->[0];
        $result{format} = $entry->{binding}->[0];
        $result{description} = $entry->{comments}->[0];
        $result{pages} = $entry->{pages}->[0];
        $result{read} = 1 if ($entry->{read}->[0] eq 'true');
        $result{acquisition} = $entry->{pur_date}->[0];
        $result{genre} = [];
        if ($entry->{genres}->[0])
        {
            for my $genre(@{$entry->{genres}->[0]->{genre}})
            {
                push @{$result{genre}}, [$genre];
            }
        }
        $result{rating} = $self->convertRating($entry->{rating}->[0]);
        $result{borrower} = 'Unknown' if ($entry->{loaned}->[0] eq 'true');
        $result{cover} = $self->getPicture($collection, $entry->{cover}->[0], $result{title});
        return \%result;
    }

    sub getGCmusicsItem
    {
        my ($self, $entry, $collection) = @_;
        
        my %result;
    
        $result{title} = $entry->{title}->[0]; 
        $result{format} = $entry->{medium}->[0]; 
        if ($entry->{artists}->[0])
        {
            for my $artist(@{$entry->{artists}->[0]->{artist}})
            {
                $result{artist} .= $artist.', ';
            }
            $result{artist} =~ s/, $//;
        }
        if ($entry->{labels}->[0])
        {
            for my $label(@{$entry->{labels}->[0]->{label}})
            {
                $result{label} .= $label.', ';
            }
            $result{label} =~ s/, $//;
        }
        $result{release} = $entry->{year}->[0];
        $result{genre} = [];
        if ($entry->{genres}->[0])
        {
            for my $genre(@{$entry->{genres}->[0]->{genre}})
            {
                push @{$result{genre}}, [$genre];
            }
        }
        if ($entry->{tracks}->[0])
        {
            my $trackNum = 1;
            for my $track(@{$entry->{tracks}->[0]->{track}})
            {
                push @{$result{tracks}}, [$trackNum,
                                          $track->{column}->[0],
                                          $track->{column}->[2]];
                $trackNum++;
            }
        }
        $result{comment} = $entry->{comments}->[0];        
        $result{rating} = $self->convertRating($entry->{rating}->[0]);
        $result{borrower} = 'Unknown' if ($entry->{loaned}->[0] eq 'true');
        $result{cover} = $self->getPicture($collection, $entry->{cover}->[0], $result{title});
        return \%result;
    }

    sub getGCcoinsItem
    {
        my ($self, $entry, $collection) = @_;
        
        my $i = 0;
        my %result;
    
        #$result{name} = $entry->{title}->[0];
        
        $result{currency} = $entry->{type}->[0];
        $result{value} = $entry->{denomination}->[0];
        $result{year} = $entry->{years}->[0]->{year}->[0];
        $result{country} = $entry->{country}->[0];
        $result{type} = ($entry->{set}->[0] eq 'true') ? 'coin' : 'banknote';
        # TODO: Import grade
        $result{added} = $entry->{pur_date}->[0];
        $result{estimate} = $entry->{pur_price}->[0];
        $result{location} = $entry->{location}->[0];

        $result{comments} = $entry->{comments}->[0];

        $result{name} = $result{currency}.' '.$result{value}.' ('.$result{year}.')';

        $result{picture} = $self->getPicture($collection, $entry->{obverse}->[0], $result{name});
        $result{front} = $self->getPicture($collection, $entry->{obverse}->[0], $result{name}.'_front');
        $result{back} = $self->getPicture($collection, $entry->{reverse}->[0], $result{name}.'_back');
        return \%result;
    }

    sub getPicture
    {
        my ($self, $collection, $imageId, $title) = @_;
	   
	    my $result = undef;
        if ($imageId && (ref($imageId) ne 'HASH'))
        {
            (my $suffix = $imageId) =~ s/.*?(\.[^.]*)$/$1/;
            my $fileName = $self->{options}->{parent}->getUniqueImageFileName($suffix, $title);
            if ((exists $collection->{images}->[0]->{image}->{$imageId}) &&
                (exists $collection->{images}->[0]->{image}->{$imageId}->{content}))
            {
                # Picture is embedded
                my $data = MIME::Base64::decode_base64($collection->{images}->[0]->{image}->{$imageId}->{content});
                open PIC, ">$fileName";
                print PIC $data;
                close PIC;
            }
            else
            {
                if ($self->{type} eq 'T')
                {
                    # Only zipped file may have external pictures
                    my $picName = 'images/'.$imageId;
                    $self->{zip}->extractMember($picName, $fileName);
                }
                else
                {
                    $fileName = '';
                }
            }
            $result = $self->{options}->{parent}->transformPicturePath($fileName);
        }
        return $result;
    }

    sub convertRating
    {
        my ($self, $rating) = @_;
        return 10 if $rating =~ /^5/;
        return 7 if $rating =~ /^4/;
        return 3 if $rating =~ /^2/;
        return 0 if $rating =~ /^1/;
        return 5; #if ($rating =~ /^3/) || ($rating == undef);
	}
	
}




1;
