package GCPlugins::GCcomics::GCmangasanctuary;

###################################################
#
#  Copyright 2005-2007 Tian
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

use GCPlugins::GCcomics::GCcomicsCommon;

{

	package GCPlugins::GCcomics::GCPluginmangasanctuary;

	use LWP::Simple qw($ua);

	use base qw(GCPlugins::GCcomics::GCcomicsPluginsBase);

	sub start
	{
		my ( $self, $tagname, $attr, $attrseq, $origtext ) = @_;
		if ( $self->{parsingList} )# partie en rapport à la page de résultats
		{

			#The interesting part to parse looks like this :
			#<li class="row1"><a href="/manhwa-rebirth-vol-2-simple-s1397-p682.html">Rebirth #2</a> <span>Manhwa</span></li>
			if ( $tagname eq "a" )
			{
				$self->{isDebut} = 1;
				$self->{itemIdx}++;
				$self->{itemsList}[ $self->{itemIdx} ]->{url} = "http://www.manga-sanctuary.com" . $attr->{href};
				$attr->{href} =~ m/\/(.*?)-.*-vol-\d+-(.*?)-s\d+-p\d+.html/;
				$self->{itemsList}[ $self->{itemIdx} ]->{type} =  $1;
				$self->{itemsList}[ $self->{itemIdx} ]->{format} = $2;
			}
		}
		else# partie en rapport à la page de l'élément
		{

			#Commencer par récupérer l'image
			#<a target="_blank" href="/couvertures/big/rebirth1gd.jpg"><img src="/couvertures/rebirth1gd.jpg"></a>
			if (   ( $tagname eq "a" ) && ( $attr->{href} =~ m/couvertures.*\.[jJ][pP][gG]/ ) )
			{
				my $response = $ua->get("http://www.manga-sanctuary.com" . $attr->{href});
				if ($response->content_type =~ m/text\/html/) #la grande image n'existe pas
				{
					$self->{downloadThumbnail} = 1;
				}
				else#la grande image existe
				{
					$self->{curInfo}->{image} = "http://www.manga-sanctuary.com" . $attr->{href};
				}
			}
			if (  ( $tagname eq "img" ) && ( $attr->{src} =~ m/couvertures.*\.[jJ][pP][gG]/ ) && ($self->{downloadThumbnail} == 1) )
			{
				$self->{curInfo}->{image} = "http://www.manga-sanctuary.com" . $attr->{src};
				$self->{downloadThumbnail} =0;
			}
			#Code général détection dt et dd
			if ( $tagname eq "dt")
			{
				$self->{tagDTdetected} =1;
			}elsif ( $tagname eq "dd")
			{
				$self->{tagDDdetected} =1;
			}elsif ( $tagname eq "h3")
			{
				$self->{tagH3detected} =1;
			}elsif ( $tagname eq "p")
			{
				$self->{tagPdetected} =1;
			}elsif ( $tagname eq "a")
			{
				$self->{tagAdetected} =1;
			}
			#Code pour différencier les types de titres (original /français)			
			if (  ( $tagname eq "img") && ( $attr->{src} =~ m/\/design\/img\/flags/ ) && ($self->{titleDetected} == 1) )
			{
				$attr->{src} =~ m/\/(\d*)\.png$/;
				if ($1 == 77)
				{
					$self->{titreFrancais} = 1;
				}
				else
				{
					$self->{titreFrancais} = 0;
				}
			}
			#Code pour récupérer la notation
			#<ul id="notation">\nStaff MS:<img src="/design/img/9.gif" title="8.5/10"/></ul>
			if (  ( $tagname eq "ul") && ( $attr->{id} =~ m/notation/ ) )
			{
				$self->{notationDetected} = 1;
			}elsif (  ( $tagname eq "img") && ( $self->{notationDetected} == 1 ) )
			{
				$attr->{title} =~ m/^(\d*\.?\d*)\/10/;
				$self->{curInfo}->{rating} = $1;
				$self->{notationDetected} = 0;
				
				#Récupération du format dans l'adresse de la page.
				#http://www.manga-sanctuary.com/manga-duds-hunt-vol-1-simple-s1169-p1477.html
				#Peut être fait dès que webPage est renseigné, placé ici pour être sûr de n'être lancé qu'une seule fois.
				$self->{curInfo}->{webPage} =~ m/vol-\d+-(.*?)-s\d+-p\d+\.html/;
				$self->{curInfo}->{format} = $1;
			}
		}
	}

	sub end
	{
		my ( $self, $tagname ) = @_;
		if ( $self->{parsingList} )# partie en rapport à la page de résultats
		{
			if ( ( $tagname eq "a" ) && $self->{isFin} == 1 )
			{
				#end of collection, next field is title
				$self->{isFin} = 0;
			}
		}
		else# partie en rapport à la page de l'élément
		{
			#Code général détection dt et dd
			if ( $tagname eq "dt")
			{
				$self->{tagDTdetected} =0;
			}elsif ( $tagname eq "dd")
			{
				$self->{tagDDdetected} =0;
				#RAZ en cas de champ vide
				$self->{titleDetected} =0;
				$self->{titreFrancais} = 1;
				$self->{publisherDetected} =0;
				$self->{collectionDetected} =0;
				$self->{publishdateDetected} =0;
				$self->{costDetected} =0;
				$self->{typeDetected} =0;
				$self->{categoryDetected} =0;
				$self->{genresDetected} =0;
				$self->{scenaristeDetected} =0;
				$self->{dessinateurDetected} =0;
			}elsif ( $tagname eq "div")#Le code à récupérer pour un titre h3 donné se trouve après la balise <\h3> donc on ne peut pas l'utiliser.
			{
				$self->{tagH3detected} =0;
			}elsif ( $tagname eq "p")
			{
				$self->{tagPdetected} =0;
				#RAZ en cas de champ vide
				$self->{synopsisDetected} =0;
				$self->{critiquesDetected} =0;
				$self->{reactionsDetected} =0;
			}elsif ( $tagname eq "a")
			{
				$self->{tagAdetected} =0;
			}elsif ( $tagname eq "ul" )
			{
				$self->{notationDetected} = 0;
			}
		}
	}

	sub text
	{
		my ( $self, $origtext ) = @_;

		return if ( $origtext eq " " );

		return if ( $self->{parsingEnded} );

		if ( $self->{parsingList} )# partie en rapport à la page de résultats
		{
			if ( $self->{isDebut} )
			{
				$self->{itemsList}[ $self->{itemIdx} ]->{title} = $origtext;
				$self->{isDebut}                                = 0;
				$self->{isFin}                                 	= 1;
			}
		}
		else# partie en rapport à la page de l'élément
		{
			
			if ( $self->{tagDTdetected} == 1 )
			{
				#Title
				#<dt><label>Titre <img src="/design/img/flags/112.png"></label></dt><dd>&#37507;&#22818; Last Order </dd><dt><label>Titre <img src="/design/img/flags/77.png"></label></dt><dd>Gunnm Last Order</dd>
				if ($origtext =~ m/^Titre/)
				{
					$self->{titleDetected} =1;
				}
				#Volume
				#<dt><label>Volume:</label></dt>\n<dd>1/23</dd>
				elsif ($origtext =~ m/^Volume/)
				{
					$self->{volumeDetected} =1;
				}
				#Publisher
				#<dt><label>Editeur:</label></dt>\n<dd><a href="http://www.manga-sanctuary.com/bdd/editeurs/6-glenat.html" title="Glénat">Glénat</a></dd>
				elsif ($origtext =~ m/^Editeur/)
				{
					$self->{publisherDetected} =1;
				}
				#collection
				#<dt><label>Label:</label></dt>\n<dd>Kana Shonen</dd>
				elsif ($origtext =~ m/^Label/)
				{
					$self->{collectionDetected} =1;
				}
				#PublishDate
				#<dt><label>Date de sortie:</label></dt>\n<dd>31/10/2002</dd>
				elsif ($origtext =~ m/^Date de sortie/)
				{
					$self->{publishdateDetected} =1;
				}
				#cost
				#<dt><label>Prix:</label></dt>\n<dd>6.5 EUR</dd>
				elsif ($origtext =~ m/^Prix/)
				{
					$self->{costDetected} =1;
				}
				#type
				#<dt><label>Type:</label></dt>\n<dd>Manga</dd>
				elsif ($origtext =~ m/^Type/)
				{
					$self->{typeDetected} =1;
				}
				#category
				#<dt><label>Catégorie:</label></dt>\n<dd>Seinen</dd>
				elsif ($origtext =~ m/^Catégorie/)
				{
					$self->{categoryDetected} =1;
				}
				#Genres [NOTE: pas d'accès aux tags alors je le mets dans synopsis]
				#<dt><label>Genres:</label></dt>\n<dd>Action, SF</dd>
				elsif ($origtext =~ m/^Genres/)
				{
					$self->{genresDetected} =1;
				}
				#scenariste  [de la fiche série]
				#<dt><label>ScÃ©nariste</label></dt>
				elsif ($origtext =~ m/^ScÃ©nariste/)
				{
					$self->{scenaristeDetected} =1;
				}
				#dessinateur  [de la fiche série]
				#<dt><label>Dessinateur</label></dt>
				elsif ($origtext =~ m/^Dessinateur/)
				{
					$self->{dessinateurDetected} =1;
				}
			}

			if ( $self->{tagDDdetected} == 1 )
			{
				if ($self->{titleDetected} == 1)
				{
					$origtext =~ m/^\s*(.*?)\s*$/;
					if ($self->{titreFrancais} == 1)
					{
						#$self->{curInfo}->{title} =  $1; #Je désactive le titre car c'est le même que la série
						$self->{curInfo}->{series} =  $1;
					}
					else
					{
						$self->{curInfo}->{synopsis} .= "Titre original :".$1."\n";
					}
					$self->{titleDetected} = 0;
				}
				elsif ($self->{volumeDetected} == 1)
				{
					$origtext =~ m/^(\d*)\//;
					$self->{curInfo}->{volume} = $1;
					$self->{volumeDetected} =0;
				}
				elsif ($self->{publisherDetected} == 1)
				{
					$self->{curInfo}->{publisher} = $origtext;
					$self->{publisherDetected} =0;
				}
				elsif ($self->{collectionDetected} == 1)
				{
					$self->{curInfo}->{collection} = $origtext;
					$self->{collectionDetected} =0;
				}
				elsif ($self->{publishdateDetected} == 1)
				{
					$self->{curInfo}->{publishdate} = $origtext;
					$self->{publishdateDetected} =0;
				}
				elsif ($self->{costDetected} == 1)
				{
					$origtext =~ m/^\s*(\d*\.\d*)/;
					$self->{curInfo}->{cost} = $1;
					$self->{costDetected} =0;
				}
				elsif ($self->{typeDetected} == 1)
				{
					$self->{curInfo}->{type} = $origtext;
					$self->{typeDetected} =0;
				}
				elsif ($self->{categoryDetected} == 1)
				{
					$self->{curInfo}->{category} = $origtext;
					$self->{categoryDetected} =0;
				}
				elsif ($self->{genresDetected} == 1)
				{
					$origtext =~ m/^\s*(.*?)\s*$/;
					$self->{curInfo}->{synopsis} .= "Genres : ".$1."\n\n";
					$self->{genresDetected} =0;
				}
			}
			if ( $self->{tagH3detected} == 1 )
			{
				#Code détection synopsis
				# <h3><span>Synopsis</span></h3>
				if ($origtext =~ m/^Synopsis/)
				{
					$self->{synopsisDetected} =1;
					$self->{curInfo}->{synopsis} .= "Synopsis :\n"
				}
				#Code détection critiques
				#<h3>Critiques du staff</h3>
				elsif ($origtext =~ m/^Critiques du staff/)
				{
					$self->{critiquesDetected} =1;
					$self->{curInfo}->{synopsis} .= "\n\nCritiques du staff :\n";
				}
			#Réactions désactivées car pas super intéressant
			#	#Code détection reactions
			#	#<h3>Réactions</h3>
			#	elsif ($origtext =~ m/^Réactions/)
			#	{
			#		$self->{reactionsDetected} =1;
			#		$self->{curInfo}->{synopsis} .= "\n\nRéactions :\n";
			#	}
			}
			if ( $self->{tagPdetected} == 1 )
			{
				if ($self->{synopsisDetected} == 1)
				{
					$origtext =~ m/^\s*(.*?)\s*$/;
					$self->{curInfo}->{synopsis} .= $1."\n";
					$self->{genresDetected} =0;
				}elsif ($self->{critiquesDetected} == 1)
				{
					$origtext =~ m/^\s*(.*?)\s*$/;
					$self->{curInfo}->{synopsis} .= $1."\n";
					$self->{genresDetected} =0;
				}
			#Réactions désactivées car pas super intéressant			
			#	elsif ($self->{reactionsDetected} == 1)
			#	{
			#		$origtext =~ m/^\s*(.*?)\s*$/;
			#		$self->{curInfo}->{synopsis} .= $1."\n";
			#		$self->{genresDetected} =0;
			#	}
			}
			if ( $self->{tagAdetected} == 1 )
			{
				if ($self->{scenaristeDetected} == 1)
				{
					$self->{curInfo}->{writer} = $origtext;
					$self->{scenaristeDetected} =0;
				}
				elsif ($self->{dessinateurDetected} == 1)
				{
					$self->{curInfo}->{illustrator} = $origtext;
					$self->{dessinateurDetected} =0;
				}
			}
		}
	}

	sub new
	{
		my $proto = shift;
		my $class = ref($proto) || $proto;
		my $self  = $class->SUPER::new();
		bless( $self, $class );
#pour la recherche: 
#		$self->{hasField} = {
#			series => 1,
#			title  => 1,
#			volume => 1,
#		};
		$self->{hasField} = {
			title   => 1,
			type   => 1,
			format => 1,
		};



		$self->{itemIdx} = 0;
		$self->{downloadThumbnail} = 0;
		$self->{tagDTdetected} =0;
		$self->{tagDDdetected} =0;
		$self->{tagH3detected} =0;
		$self->{tagPdetected} =0;
		$self->{titleDetected} =0;
		$self->{titreFrancais} = 1;#défaut francais
		$self->{publisherDetected} =0;
		$self->{collectionDetected} =0;
		$self->{publishdateDetected} =0;
		$self->{costDetected} =0;
		$self->{typeDetected} =0;
		$self->{categoryDetected} =0;
		$self->{genresDetected} =0;
		$self->{synopsisDetected} =0;
		$self->{critiquesDetected} =0;
		$self->{reactionsDetected} =0;
		$self->{scenaristeDetected} =0;
		$self->{dessinateurDetected} =0;
		$self->{notationDetected} = 0;

		return $self;
	}

	sub preProcess
	{
		my ( $self, $html ) = @_;

		if ( $self->{parsingList} ) # partie en rapport à la page de résultats 
		{
			#keep only Volumes
			$html =~ m/<h3>Volumes\s\(\d+\)<\/h3>\s*(.*?)\s*<h3>Critiques/s;
			$html = $1;
		}
		else # partie en rapport à la page de l'élément
		{
			$html =~ m/<div id="contenu">\s*(<ul id="menu_fiche">\s*<li><a href="(http:\/\/www.manga-sanctuary.com.*?)">.*?)\s*<h3><span>Mes actions<\/span><\/h3>/s;
			$html = $1;
			
			#récupération des infos de la fiche série 
			my $response = $ua->get($2);
			$response->content =~ m/<h3><span>Staff<\/span><\/h3>\s*(.*?<\/dl>)/s;

			$html .= "\n\n <fiche série>\n\n".$1; 

		}
		
		return $html;
	}

	sub getSearchUrl
	{
		my ( $self, $word ) = @_;
		$word =~ s/\+/ /g;
		return ('http://www.manga-sanctuary.com/recherche/tout/', ['keywords' => $word]);

	}

	sub getItemUrl
	{
		my ( $self, $url ) = @_;
	#Je fais le pari que cette partie n'est pas utilisée
	#	my @array = split( /#/, $url );
	#	$self->{site_internal_id} = $array[1];

		return $url if $url =~ /^http:/;
		return "http://www.manga-sanctuary.com" . $url;
	}

	sub getNumberPasses
	{
		return 1;
	}

	sub getName
	{
		return "Manga-Sanctuary";
	}

	sub getAuthor
	{
		return 'Biggriffon';
	}

	sub getLang
	{
		return 'FR';
	}
}

1;
