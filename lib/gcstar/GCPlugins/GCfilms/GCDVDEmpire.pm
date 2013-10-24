package GCPlugins::GCfilms::GCDVDEmpire;

###################################################
#
#  Copyright 2009 by FiXx
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

use GCPlugins::GCfilms::GCfilmsCommon;

{

    package GCPlugins::GCfilms::GCPluginDVDEmpire;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    sub start {
        my ( $self, $tagname, $attr, $attrseq, $origtext ) = @_;

        $self->{inside}->{$tagname}++;

        if ( $self->{parsingList} ) {
            if ( $self->{outOfMovieList} )
	    {
                return;
            }
            elsif (( $self->{inMovieList} )
                && ( $self->{inMovie} eq 0 )
                && ( $tagname eq 'a' )
                && ( $attr->{href} =~ /^(\/Exec\/v4_item.asp\?item_id=[0-9]*)$/ ) )
            {
                my $url = $1;
                $self->{isMovie} = 1;
                $self->{inMovie} = 1;
                $self->{itemIdx}++;
                $self->{itemsList}[ $self->{itemIdx} ]->{url} = $url;
            }
            elsif (( $self->{inMovie} )
                && ( $tagname eq 'img' )
                && ( $attr->{src} =~ /(.*gen\/movies\/[0-9]*t.jpg)/ ) )
            {
                (my $image = $attr->{src}) =~ s/t.jpg$/h.jpg/;
                $self->{itemsList}[ $self->{itemIdx} ]->{image} = $image;
            }
            elsif (( $self->{inMovie} )
                && ( $tagname eq 'a' )
                && ( $attr->{href} =~ /cast_id/ ) )
            {
                $self->{isActors} = 1;
            }
            elsif (( $self->{inMovie} )
                && ( $tagname eq 'td' )
                && ( $attr->{bgcolor} eq '#D7DDE7' ) )
            {
                $self->{inMovie} = 0;
            }
            elsif (( $tagname eq 'div' )
                && ( $attr->{id} eq 'Search_Container' ) )
            {
                $self->{inMovieList} = 1;
            }
            elsif  (  ( $self->{inMovieList} ) 
                && ( $tagname eq 'endsearch' ))
            {
                $self->{inMovieList}    = 0;
                $self->{outOfMovieList} = 1;
            }
        }
        else {
            if ( $self->{parsingEnded} ) 
	    {
		if (!$self->{infoSet})
		{
			$self->{curInfo}->{image} = $self->{itemsList}[$self->{wantedIdx}]->{image};
			$self->{curInfo}->{date} = $self->{itemsList}[$self->{wantedIdx}]->{date}; #"short text"
			$self->{curInfo}->{time} = $self->{itemsList}[$self->{wantedIdx}]->{time}; #"short text"
			$self->{curInfo}->{age} = $self->{itemsList}[$self->{wantedIdx}]->{age}; #"options"
			($self->{curInfo}->{backpic} = $self->{curInfo}->{image}) =~ s/h.jpg/b.jpg/; #"image"

			$self->{infoSet} = 1;
		}
                return;
            }
	    elsif ( ($tagname eq 'div')
		 && ($attr->{id} eq 'Search_Container') )
	    {
		$self->{isContent} = 1;
	    }
            elsif  (  ( $self->{isContent} ) 
                && ( $tagname eq 'div' ) )
            {
                $self->{inNonContentDiv}    = 1;
            }
	    elsif ( $self->{isContent})
	    {
	        if ( ($tagname eq 'td')
		  && ($attr->{class} eq 'fontxlarge') )
		{
		    $self->{isTitle} = 1 ;
		}
	        elsif ($tagname eq 'rating')
		{
		    $self->{isRating} = 1 ;
		}
	        elsif ($tagname eq 'actors')
		{
		    $self->{isActors} = 1 ;
		}
	        elsif ( ($self->{isActors})
		  && ($tagname eq 'a')
		  && ($attr->{href} =~ /v4_list_cast.asp/) )
		{
		    $self->{isActor} = 1 ;
		}
	        elsif ($tagname eq 'directors')
		{
		    $self->{isDirectors} = 1 ;
		}
	        elsif ( ($self->{isDirectors})
		  && ($tagname eq 'a')
		  && ($attr->{href} =~ /v4_list_cast.asp/) )
		{
		    $self->{isDirector} = 1 ;
		}
	        elsif ($tagname eq 'genres')
		{
		    $self->{isGenres} = 1 ;
		}
	        elsif ( ($self->{isGenres})
		  && ($tagname eq 'a')
		  && ($attr->{href} =~ /v2_category.asp/) )
		{
		    $self->{isGenre} = 1 ;
		}
	        elsif ($tagname eq 'audio')
		{
		    $self->{inAudio} = 1 ;
		}
	        elsif ( ($self->{inAudio})
		  && ($tagname eq 'td') )
		{
		    $self->{isAudio} = 1 ;
		}
	        elsif ( ($self->{isTitle})
		  && ($tagname eq 'strong') )
		{
		    $self->{isTitle} = 2 ;
		}
	        elsif ( ($self->{startSynopsis})
		  && ($tagname eq 'td') )
		{
		    $self->{isSynopsis} = 1 ;
		}
	        elsif ( ($self->{isSynopsis})
		  && ($tagname eq 'br') )
		{
		    $self->{synopsisLineBreak} = 1 ;
		}
	    }
        }
    }

    sub end {
        my ( $self, $tagname ) = @_;

        $self->{inside}->{$tagname}--;

        if ( !$self->{parsingList} ) 
	{
            if ( $self->{parsingEnded} ) 
	    {
                return;
            }
	    if ($self->{isContent})
	    {
		if  ( ( $tagname eq 'div' )
		    && ( !$self->{inNonContentDiv} ) )
		{
		    $self->{isContent}    = 0;
		    $self->{parsingEnded} = 1;
		}
		elsif  (  ( $tagname eq 'div' )
		    && ( $self->{inNonContentDiv} ) )
		{
		    $self->{inNonContentDiv}    = 0;
		}
		elsif  (  ( $tagname eq 'table' )
		    && ( $self->{isSynopsis} ) )
		{
		    $self->{startSynopsis}    = 0;
		    $self->{SynopsisEnded}    = 1;
		    $self->{isSynopsis}    = 0;
		}		
	        elsif ( ($self->{isActors} ) && ($tagname eq 'actors') )
		{
		    $self->{isActors} = 0 ;
		}
	        elsif ( ($self->{isGenres} ) && ($tagname eq 'genres') )
		{
		    $self->{isGenres} = 0 ;
		}
	        elsif ( ($self->{isDirectors} ) && ($tagname eq 'directors') )
		{
		    $self->{isDirectors} = 0 ;
		}
	        elsif ( ($self->{isAudio})
		  && ($tagname eq 'td') )
		{
		    $self->{isAudio} = 0 ;
		    $self->{inAudio} = 0 ;
		}
	    }
	}

    }

    sub text {
        my ( $self, $origtext ) = @_;

        if ( $self->{parsingList} ) 
	{
            if ( ( $self->{inMovieList} ) && ( $self->{isMovie} ) ) 
	    {
                $self->{itemsList}[ $self->{itemIdx} ]->{title} = $origtext;
                $self->{isMovie} = 0;
            }
            elsif ( ( $self->{inMovie} ) && ( $origtext =~ /([^~]*)~~~([0-9]*)mins.~~~Release Date:[^~]*~~~Prod Year: ([0-9]{4})/ ) )
            {
		    $self->{itemsList}[ $self->{itemIdx} ]->{age} = 1
		      if ( $1 eq 'Unrated' ) || ( $1 eq 'Open' );
		    $self->{itemsList}[ $self->{itemIdx} ]->{age} = 2
		      if ( $1 eq 'G' ) || ( $1 eq 'Approved' );
		    $self->{itemsList}[ $self->{itemIdx} ]->{age} = 5
		      if ( $1 eq 'PG' ) || ( $1 eq 'M' ) || ( $1 eq 'GP' );
		    $self->{itemsList}[ $self->{itemIdx} ]->{age} = 13
		      if $1 eq 'PG-13';
		    $self->{itemsList}[ $self->{itemIdx} ]->{age} = 17
		      if $1 eq 'R';
		    $self->{itemsList}[ $self->{itemIdx} ]->{age} = 18
		      if ( $1 eq 'NC-17' ) || ( $1 eq 'X' );

		    $self->{itemsList}[ $self->{itemIdx} ]->{time} = $2 . ' min';

		    $self->{itemsList}[ $self->{itemIdx} ]->{date} = $3;
            }
            elsif ( ( $self->{inMovie} ) && ( $self->{isActors} ) ) 
	    {
                $self->{itemsList}[ $self->{itemIdx} ]->{actors} .= $origtext . ', ';
                $self->{isActors} = 0;
            }
        }
        else {
            $origtext =~ s/^\s*//;

            return if !$origtext;
            if ( $self->{parsingEnded} ) 
	    {
                return;
            }
	    if ($self->{isContent})
	    {
		    if ( $self->{isTitle} eq 2) 
		    {
			$self->{curInfo}->{title} = $origtext; #"short text"
			$self->{curInfo}->{original} = $origtext; #"short text"
			$self->{isTitle} = 0 ;
		    }
		    elsif ( $self->{isRating}) 
		    {
			$self->{curInfo}->{ratingpress} = int($origtext * 2); #"number"
			$self->{isRating} = 0 ;
		    }
		    elsif ( ( !$self->{SynopsisEnded} ) 
			 && ( $origtext eq 'Synopsis' ) )
		    {
			$self->{startSynopsis} = 1 ;
		    }
		    elsif ( $self->{isSynopsis} ) 
		    {
			$self->{curInfo}->{synopsis} .= "\n\n" if $self->{synopsisLineBreak};
			$self->{curInfo}->{synopsis} .= $origtext ; #"long text"
			$self->{curInfo}->{synopsis} .= " " if $self->{synopsisLineBreak};
			$self->{synopsisLineBreak} = 0 ;
		    }
		    elsif ( $self->{isActor} ) 
		    {
		        push @{$self->{curInfo}->{actors}}, [$origtext]
		            if ($self->{actorsCounter} < $GCPlugins::GCfilms::GCfilmsCommon::MAX_ACTORS);
		        $self->{actorsCounter}++;
		        $self->{isActor} = 0 ;
		    }
		    elsif ( $self->{isGenre} ) 
		    {
		        push @{$self->{curInfo}->{genre}}, [$origtext];
		        $self->{isGenre} = 0 ;
		    }
		    elsif ( $self->{isDirector} ) 
		    {
			$self->{curInfo}->{director} .= $origtext; #"long text"
		        $self->{isDirector} = 0 ;
		        $self->{isDirectors} = 0 ;
		    }
		    elsif ( $self->{isAudio} ) 
		    {
			(my $language = $origtext) =~ s/([^:]*):(.*)/$1/ ;
			my $audio = $2 ;
			$language =~ s/\s// ;
			$audio =~ s/\r// ;
		        push @{$self->{curInfo}->{audio}}, [$language, $audio];
		    }
	    }
        }
    }

    sub new {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless( $self, $class );

        $self->{hasField} = {
            title  => 1,
            date   => 1,
            actors => 1,
            age    => 1,
            time   => 1,
	    image  => 1,
        };

        $self->{isInfo}   = 0;
        $self->{isMovie}  = 0;
        $self->{inMovie}  = 0;
	$self->{isContent} = 0;
        $self->{curName}  = undef;
        $self->{curUrl}   = undef;

        return $self;
    }

    sub preProcess {
        my ( $self, $html ) = @_;

        $self->{parsingEnded} = 0;

	if ($self->{parsingList})
	{
	    $html =~ s/<\/nobr>[ ]*~[ ]*<nobr>/~~~/g ;
	    $html =~ s/<b>Phone #:<\/b>/<endsearch>here<\/endsearch>/g ;

	}
	else
	{
		$html =~ s/<b>([0-9\.]*)<\/b> out of <b>5<\/b>/<rating>$1<\/rating>/g ; #/
		$html =~ s/<b>Actors:<\/b>/<actors>/g ;
		$html =~ s/<b>Writers:<\/b>/<\/actors>/g ;
		$html =~ s/<b>Directors:<\/b>(.*cast_id[^\/]*<\/a>)/<directors>$1<\/directors>/g ; #/
		$html =~ s/<b>Genre<\/b>(.*cat_id[^\/]*<\/a>)/<genres>$1<\/genres>/g ; #/
		$html =~ s/<b>Audio:<\/b>/<audio><\/audio>/g ;
		$html =~ s/<font face='[^']*' size='[^']*' color='#FFFFFF'>i<\/font>/ /g ;
	}

        return $html;
    }

    sub getSearchUrl {
        my ( $self, $word ) = @_;

	my $searchvalue = 32 ;
	my $strictmatching = 0;
	if ($strictmatching)
	{
	    $searchvalue = 64 ;
	}
        return "http://www.dvdempire.com/Exec/v1_search_all.asp?string=$word&pp=5&search_refined=$searchvalue";
    }

    sub getItemUrl {
        my ( $self, $url ) = @_;

        return 'http://www.dvdempire.com/' . $url;
    }

    sub changeUrl {
        my ( $self, $url ) = @_;

        return $url;
    }

    sub getName {
        return "DVDEmpire (EN)";
    }

    sub getCharset {
        my $self = shift;

        return "ISO-8859-1";
    }

    sub getAuthor {
        return 'FiXx';
    }

    sub getLang {
        return 'EN';
    }
}

1;
