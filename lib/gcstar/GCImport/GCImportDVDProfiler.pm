package GCImport::GCImportDVDProfiler;

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
    package GCImport::GCImporterDVDProfiler;

    use base qw(GCImport::GCImportBaseClass);
    
    use XML::Simple;    
        
    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);
        
        return $self;
    }

    sub getName
    {
        return "DVDProfiler (.xml)";
    }
    
    sub getOptions
    {
        my $self = shift;
        my @options;
        return \@options;
    }
    
    sub getFilePatterns
    {
       return (['DVDProfiler (.xml)', '*.xml']);
    }
    
    #Return supported models name
    sub getModels
    {
        return ['GCfilms'];
    }

    # Ignored for the moment
    sub wantsFieldsSelection
    {
        return 0;
    }
    sub getEndInfo
    {
        return "";
    }
    
    sub getItemsArray
    {
	my ($self, $file) = @_;
	my $xml;
	my $data;
	# creer un objet
	$xml = XML::Simple->new; # sans keyAttr les dvd seront dans une liste ou chaque dvd sera identifie par l'emplacement qu'il a dans cette liste
	$data = $xml->XMLin ("$file");

	
	my @result; 
	my $film;
	
	foreach $film(@{$data->{DVD}}){
		my $item;
		
		$item->{title} = $film->{Title};
		$item->{date} = $film->{ProductionYear};
		$item->{time} = $film->{RunningTime}.' mn';
		$item->{synopsis} = $film->{Overview};
		####### DIRECTOR #########
		my $director;
		
		if (ref ($film->{Credits}->{Credit}) eq "ARRAY") {
			foreach $director(@{$film->{Credits}->{Credit}}){
				if (($director->{CreditType}) eq 'Direction') {
					$item->{director} .= $director->{FirstName}.' '.$director->{LastName}.', ';
					
				}
			}
		}
		else {
			if (($film->{Credits}->{Credit}->{CreditType}) eq 'Direction') {
					$item->{director} .= $film->{Credits}->{Credit}->{FirstName}.' '.$film->{Credits}->{Credit}->{LastName};
				}
		}
		###### END DIRECTOR ######
		
		####### ACTORS #########
		my $actor;
		if (ref ($film->{Actors}->{Actor}) eq "ARRAY") {
			foreach $actor(@{$film->{Actors}->{Actor}}){
				$item->{actors} .= $actor->{FirstName}.' '.$actor->{LastName}.' '.'('.$actor->{Role}.')'.', ';
				
			}
			}
		else {
		$item->{actors} .= $film->{Actors}->{Actor}->{'FirstName'}.' '.$film->{Actors}->{Actor}->{LastName}.' '.'('.$film->{Actors}->{Actor}->{Role}.')';
		}
		###### END ACTORS ######
		
		####### AUDIO #########
		my $audio;
		if (ref ($film->{Audio}->{AudioFormat}) eq "ARRAY"){
			foreach $audio(@{$film->{Audio}->{AudioFormat}}){
				$item->{audio} .= $audio->{AudioLanguage}.', ';
				
				}
		}
		else  {
			$item->{audio} .= $film->{Audio}->{AudioFormat}->{'AudioLanguage'};
		}
		###### END AUDIO ######
		####### SUBT #########
		my $subt;
		if (ref ($film->{Subtitles}->{Subtitle}) eq "ARRAY"){
			foreach $subt(@{$film->{Subtitles}->{Subtitle}}){
				$item->{subt} .= $subt.', ';
				
			}
		}
		else {
			$item->{subt} = $film->{Subtitles}->{Subtitle};
		}
		####### END SUBT #########
		####### TYPE #########
		my $type;
		if (ref ($film->{Genres}->{Genre}) eq "ARRAY"){
			foreach $type(@{$film->{Genres}->{Genre}}){
				$item->{type} .= $type.',';
				
			}
		}
		else {
			$item->{type} = $film->{Genres}->{Genre};
		}
		####### END TYPE #########
		
		#$item->{original} = $film->{Title};
		#$item->{subt} = $film->{Subtitles}->{Subtitle};
		#$item->{borrower} = $film->{Title};
		#$item->{lendDate} = $film->{Title};
		#$item->{history} = $film->{Title};
		#$item->{seen} = $film->{Title};# non par defaut ?
		#$item->{comment} = $film->{Title};
		#$item->{image} = $film->{Title};
		#$item->{country} = $film->{Title};
		#$item->{number} = $film->{CollectionNumber};
		#$item->{rating} = $film->{Title};# note par defaut
		#$item->{format} = $film->{Title};#DVD par d�faut ?
		#$item->{webPage} = $film->{Title};
		#$item->{place} = $film->{Title};
		$item->{director} =~ s/, $//;
		$item->{actors} =~ s/, $//;
		$item->{audio} =~ s/, $//;
		$item->{subt} =~ s/, $//;
		$item->{type} =~ s/, $//;
		push @result, $item;
	}
	return \@result;

	}
}

1;