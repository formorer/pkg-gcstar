package GCImport::GCImportMyMovies;

#################################################################################
# 
#  Created by Rob Maas rob@progob.nl | http://www.robmaas.eu (2008)
#	
# 
#  This file is strongly based op the already existing DVDProfiler
#  import class. It is also my first perl script :-)
#
#  Since MyMovies has some different fields then GCStar, there are some work
#  arounds to get as much of the original data.
#
#  If the field ExtraFeatures is filled, it will appear in the General tab in 
#  the synopsis.
#
#  The rating system will be calculated back to the Dutch rating system.
#
#  If data was imported from IMDB, the webpage button will link to the specific
#  movie site on IMDB.
#
#  Cause GCstar hasn´t (yet?) a real EAN field, the EAN code is placed on the
#  details tab under comments.
#
#  Special thanks goes to Tian who helped me with some array trouble :-P and
#  for creating this software.
#
#################################################################################

use strict;
use GCImport::GCImportBase;

{
    package GCImport::GCImporterMyMovies;

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
        return "MyMovies (.xml)";
    }
    
    sub getOptions
    {
        my $self = shift;
        my @options;
        return \@options;
    }
    
    sub getFilePatterns
    {
       return (['MyMovies (.xml)', '*.xml']);
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
	# Creates an object / Skip empty ellements
	$xml = new XML::Simple(suppressempty => 1);
	$data = $xml->XMLin ("$file");
	
	my @result; 
	my $film;

	# For each "Title" in the XML file
	foreach $film(@{$data->{Title}}){
		my $item;
		
		#General fields			   		
		$item->{title} = $film->{LocalTitle};
		$item->{original} = $film->{OriginalTitle};
		$item->{date} = $film->{ProductionYear};
		$item->{time} = $film->{RunningTime}.' min';
		$item->{synopsis} = $film->{Description};
		
		#Extra's on the disc
		if ($film->{ExtraFeatures}->{content}){
			$item->{synopsis} .= "\n\nEXTRA\n";
			$item->{synopsis} .= $film->{ExtraFeatures}->{content};
		}
		
		#Based on the Dutch ratings!
		
		$item->{age} = 
		   ($film->{ParentalRating}->{Value} == 1) ? 1
		 : ($film->{ParentalRating}->{Value} == 2) ? 2
		 : ($film->{ParentalRating}->{Value} == 3) ? 5
		 : ($film->{ParentalRating}->{Value} == 4) ? 12
		 :                                           16;
	
		if ($film->{DataProvider} eq 'IMDB.com'){
			$item->{webPage} = 'http://www.imdb.com/title/'.$film->{DataProviderId};
		}	
		$item->{country} = $film->{Country};
		
		###### GENRE #########
		my $type;
		if (ref ($film->{Genres}->{Genre}) eq "ARRAY"){
			foreach $type(@{$film->{Genres}->{Genre}}){				
				$item->{genre} .= $type.',';
			}
		}		
		else{
			$item->{genre} = $film->{Genres}->{Genre};
		}
		###### END GENRE #########	
		####### DIRECTOR AND ACTORS #########
		my $actor;
		if (ref ($film->{Persons}->{Person}) eq "ARRAY") {
			foreach $actor(@{$film->{Persons}->{Person}}){
				if ($actor->{Type} eq 'Director'){
					$item->{director} = $actor->{Name};
				}
				else{
					$item->{actors}.= $actor->{Name}.' ('.$actor->{Role}.'), ';
				}
			}
		}
		else{
			$item->{actors}.= $film->{Persons}->{Person}->{Name}.' ('.$film->{Persons}->{Person}->{Role}.')';
		}
		###### END DIRECTOR AND ACTORS ######
	
		##DETAIL
		$item->{format} = $film->{Type};
		$item->{video} = $film->{VideoStandard};
		$item->{added} = $film->{Added};
		$item->{identifier} = $film->{CollectionNumber};

		#Temporately cause a real barcode field is missing
		if (length($film->{Barcode}) gt 0){
			$item->{comment} = 'EAN: '.$film->{Barcode};
		}
			
		###### AUDIO #########
		my $audio;
		my @audioTracks;
		if (ref ($film->{AudioTracks}->{AudioTrack}) eq "ARRAY"){
			foreach $audio(@{$film->{AudioTracks}->{AudioTrack}}){
				push @audioTracks, [$audio->{Language}, $audio->{Type}.' '.$audio->{Channels}];
			}
			$item->{audio} = \@audioTracks;
		}
		else{
			$item->{audio} = [[$audio->{Language}, $audio->{Type}]];
		}
		###### END AUDIO #########
		###### SUBTITLES #########
		my $subt;
		if (ref ($film->{Subtitles}->{Subtitle}) eq "ARRAY"){
			foreach $subt(@{$film->{Subtitles}->{Subtitle}}){
				$item->{subt} .= $subt->{Language}.',';
			}
		}
		else{
			$item->{subt} = $subt->{Language};
		}
		###### END SUBTITLES #########
	
		#$item->{borrower} = $film->{Title};
		#$item->{lendDate} = $film->{Title};
		#$item->{history} = $film->{Title};
		#$item->{seen} = $film->{Title};# non par defaut ?
		#$item->{image} = $film->{Title};
		#$item->{number} = $film->{CollectionNumber};
		#$item->{rating} = $film->{Title};# note par defaut
		#$item->{place} = $film->{Title};	
		
		$item->{director} =~ s/, $//;
		$item->{actors} =~ s/, $//;
		$item->{audio} =~ s/, $//;
		$item->{subt} =~ s/, $//;
		$item->{genre} =~ s/, $//;
		push @result, $item;
	}
	return \@result;

	}
}

1;
