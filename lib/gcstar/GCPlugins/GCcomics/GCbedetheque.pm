package GCPlugins::GCcomics::GCbedetheque;

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
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
###################################################

use strict;
use utf8;

use GCPlugins::GCcomics::GCcomicsCommon;

{

	package GCPlugins::GCcomics::GCPluginbedetheque;

	use LWP::Simple qw($ua);

	use base qw(GCPlugins::GCcomics::GCcomicsPluginsBase);
	sub getSearchUrl
	{
		my ( $self, $word ) = @_;
		if ($self->{searchField} eq 'series')
		{
		    return "http://www.bedetheque.com/index.php?R=1&RechSerie=$word";
		}
		elsif ($self->{searchField} eq 'writer')
		{
		    return "http://www.bedetheque.com/index.php?R=1&RechAuteur=$word";
		}
		else
		{
		    return '';
		}
		#return "http://www.bedetheque.com/index.php?R=1&RechTexte=$word";
	}

    sub getSearchFieldsArray
    {
        return ['series', 'writer'];
    }

	sub getItemUrl
	{
		my ( $self, $url ) = @_;
		my @array = split( /#/, $url );
		$self->{site_internal_id} = $array[1];

		return $url if $url =~ /^http:/;
		return "http://www.bedetheque.com/" . $url;
	}

	sub getNumberPasses
	{
		return 1;
	}

	sub getName
	{
		return "Bedetheque";
	}

	sub getAuthor
	{
		return 'Mckmonster';
	}

	sub getLang
	{
		return 'FR';
	}

	sub new
	{
		my $proto = shift;
		my $class = ref($proto) || $proto;
		my $self  = $class->SUPER::new();
		bless( $self, $class );

		$self->{hasField} = {
			series => 1,
			title  => 1,
			volume => 1,
		};

		$self->{isResultsTable}   = 0;
		$self->{isCover}          = 0;
		$self->{itemIdx}          = 0;
		$self->{last_cover}       = "";
		$self->{site_internal_id} = "";
		$self->{serie}            = "";
		$self->{synopsis}         = "";
		$self->{current_field}    = "";
		

		return $self;
	}

	sub preProcess
	{
		my ( $self, $html ) = @_;
		
		$self->{parsingEnded}   = 0;
		
		if ( $self->{parsingList} )
		{
			#keep only albums, no series or objects
			$html =~ m/(\d+\salbum\(s\).+)/;
			$html = $1;
		}
		else
		{
			$self->{isResultsTable} = 0;
			$self->{parsingEnded}   = 0;
			$self->{isCover} = 0;
			$self->{itemIdx}++;;
		}

		return $html;
	}
	
	sub start
	{
		my ( $self, $tagname, $attr, $attrseq, $origtext ) = @_;
		
		return if ( $self->{parsingEnded} );
		
		if ( $self->{parsingList} )
		{
			if ( ( $tagname eq "a" ) && ( $attr->{href} =~ m/album-/ ) )
			{
				$self->{isCollection} = 1;
				$self->{itemIdx}++;
				
				my $searchUrl =  substr($attr->{href},0,index($attr->{href},".")).substr($attr->{href},index($attr->{href},"."));
                $self->{itemsList}[$self->{itemIdx}]->{url} = $searchUrl;
				
				#$self->{itemsList}[ $self->{itemIdx} ]->{url} =
				#  "http://www.bedetheque.com/" . $attr->{href};
			}
			else
			{
				if ( $tagname eq "i" )
				{
					$self->{isSerie} = 1;
				}
			}
		}
		else
		{
			if ( $tagname eq "title")
			{
				$self->{isIssue} = 1;
				$self->{isTitle} = 1;
			}
			
			if ( $origtext eq "<table cellpadding=0 cellspacing=0 width=\"100%\">" )
			{
				$self->{isResultsTable}    = 1;
			}
			
			if ( ( $self->{isCover} == 0 ) && ( $tagname eq "a" ) && ( $attr->{href} =~ m/Couvertures.*\.[jJ][pP][gG]/ ) )
			{
				$self->{curInfo}->{image} = 'http://www.bedetheque.com/' . $attr->{href};
				$self->{isCover} = 1;
			}
		}
	}

	sub text
	{
		my ( $self, $origtext ) = @_;

		return if ( $origtext eq " " );

		return if ( $self->{parsingEnded} );

		if ( $self->{parsingList} )
		{
			if ( $self->{isSerie} == 1)
			{
				$self->{itemsList}[ $self->{itemIdx} ]->{series}  = $origtext;
				$self->{isSerie} = 0;
			}
			else 
			{
				if ( $self->{isTitle} == 1)
				{
					#sometimes the field is "-vol-title", sometimes "--vol-title"
					$origtext =~ s/-+/-/;
					my @fields = split( /-/, $origtext );
					$self->{itemsList}[ $self->{itemIdx} ]->{volume} = $fields[1];
					$self->{itemsList}[ $self->{itemIdx} ]->{title}  = $fields[2];
					$self->{isTitle}                                 = 0;
				}
			}
		}
		else
		{
			if ( $self->{isResultsTable} == 1 )
			{
				my %td_fields_map = (
					"Identifiant :"   => '',
					"Scénario :"     => 'writer',
					"Dessin :"        => 'illustrator',
					"Couleurs :"      => 'colourist',
					"Dépot légal :" => 'publishdate',
					"Achevé impr. :" => 'printdate ',
					"Estimation :"    => 'cost',
					"Editeur :"       => 'publisher',
					"Collection : "   => 'collection',
					"Taille :"        => 'format',
					"ISBN :"          => 'isbn',
					"Planches :"      => 'numberboards'
				);

				if ( exists $td_fields_map{$origtext} )
				{
					$self->{current_field} = $td_fields_map{$origtext};
				}
				else
				{
					$self->{curInfo}->{$self->{current_field}} = $origtext;
					$self->{current_field} = "";
				}
			}
			
			if ( $self->{isTitle} == 1 )
			{
				$origtext =~ m/(.+)\s-(\d+)-\s(.+)\s-/;    #remove ". " in front of title.
				$self->{curInfo}->{series} = $1;
				$self->{curInfo}->{volume} = $2;
				$self->{curInfo}->{title} = $3;
				$self->{isTitle} = 0;
			}
		}
	}
	
	sub end
	{
		my ( $self, $tagname ) = @_;
		
		return if ( $self->{parsingEnded} );
		
		if ( $self->{parsingList} )
		{
			if ( ( $tagname eq "i" ) && $self->{isCollection} == 1)
			{
				#end of collection, next field is title
				$self->{isTitle}      = 1;
				$self->{isCollection} = 0;
			}
		}
		else
		{
			if ( ( $tagname eq "table" ) && $self->{isResultsTable} == 1 )
			{
				$self->{isIssue} = 0;
				$self->{isResultsTable} = 0;
				$self->{parsingEnded}   = 1;
			}
		}
	}
}
