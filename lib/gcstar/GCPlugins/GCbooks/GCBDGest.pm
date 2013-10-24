package GCPlugins::GCbooks::GCBDGest;

###################################################
#
#  Copyright 2005-2006 Tian
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

use GCPlugins::GCbooks::GCbooksCommon;

{
    package GCPlugins::GCbooks::GCPluginBDGest;

    use base qw(GCPlugins::GCbooks::GCbooksPluginsBase);
    use URI::Escape;
    # tableau pour stocker l'identifiant propre à bdgest
    my @tableau;
    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

		# parse une liste de résultat
        if ($self->{parsingList})
        {
			if (($tagname eq 'tr'))
            {
                $self->{isBook} = 1 ;
                $self->{isUrl} = 1 ;
            }
            elsif (($tagname eq 'a') && ($self->{isUrl}) && ($self->{isBook}) && (index($attr->{href},"serie-") >= 0))
            {
				$self->{itemIdx}++;
				$self->{isFound} = 1 ;
				$tableau[$self->{itemIdx}] = substr($attr->{href},index( $attr->{href},"#")+1);
				#on retravaille l'url pour avoir toutes les pages de la série
				my $urlRecherche =  substr($attr->{href},0,index($attr->{href},"."))."__10000".substr($attr->{href},index($attr->{href},"."));
                $self->{itemsList}[$self->{itemIdx}]->{url} = $urlRecherche;
                $self->{isSerie} = 1 ;
                $self->{isUrl} = 0 ;
            }
            elsif (($tagname eq 'a') && ($attr->{name} eq 'TitreAlbum')&& ($self->{isBook}) && ($attr->{title} ne ''))
            {
				$self->{isTitle} = 1 ;
                $self->{itemsList}[$self->{itemIdx}]->{title} = $attr->{title};
            }
            elsif (($tagname eq 'td') && $self->{isTitle} eq 1)
			{
				$self->{isPublisher} = 1 ;
				$self->{isTitle} = 0;
			}
			elsif (($tagname eq 'td') && $self->{isPublisher} eq 2)
			{
				$self->{isPublication} = 1 ;
				$self->{isPublisher} = 0;
			}
        }
        else # parse un item
        {
            if (($tagname eq 'a') && ($attr->{name} eq $tableau[$self->{wantedIdx}]))
            {
                $self->{isTitle} = 1 ;
                $self->{isCover} = 1;
                $self->{isBook} = 1 ;
            }
            elsif ($tagname eq 'html')
            {
                $self->{isCover} = 0 ;
            }
            elsif ($tagname eq 'head')
            {
                $self->{isCover} = 0 ;
            }
            elsif (($tagname eq 'a') && ($attr->{name} ne $tableau[$self->{wantedIdx}]) && ($attr->{name} ne ''))
            {
                $self->{isBook} = 0 ;
            }
            elsif (($tagname eq 'font') && ($attr->{color} eq '#294A6B') && ($attr->{style} eq 'font-family:Trebuchet MS; FONT-SIZE: 11pt;') && ($self->{isTitle} eq 1))
            {
                $self->{isTitle} = 2 ;
            }
#            elsif (($tagname eq 'a') && ($self->{isCover} eq 0) && (index($attr->{href},"Couvertures") >= 0))
            elsif (($tagname eq 'a') && ($self->{isCover} eq 0))
            {
                my $urlimage = $attr->{href};
                $urlimage =~ s/\'//g;
                $urlimage =~ s/\)//g;
                $urlimage = substr($urlimage,index($urlimage,"Couvertures/"));
                $self->{curInfo}->{cover} = 'http://www.bedetheque.com/'.$urlimage;
            }
            elsif (($tagname eq 'a') && ($self->{isBook}) && (index($attr->{href},"auteur") >= 0))
            {
               $self->{isAuthor} = 1 ;
            }
            elsif (($tagname eq 'td') && ($self->{isPublisher} eq 1))
            {
               $self->{isPublisher} = 2 ;
            }
            elsif (($tagname eq 'td') && $self->{isPublication} eq 1)
            {
               $self->{isPublication} = 2 ;
            }
            elsif (($tagname eq 'td') && $self->{isEdition} eq 1)
            {
               $self->{isEdition} = 2 ;
            }
            elsif (($tagname eq 'td') && $self->{isFormatPublication} eq 1)
            {
               $self->{isFormatPublication} = 2 ;
            }
            elsif (($tagname eq 'td') && $self->{isISBN} eq 1)
            {
               $self->{isISBN} = 2 ;
            }
            elsif (($tagname eq 'td') && $self->{isPage} eq 1)
            {
               $self->{isPage} = 2 ;
            }
            elsif (($tagname eq 'i') && $self->{isDescription} eq 1)
            {
               $self->{isDescription} = 2 ;
            }
        }
    }

    sub end
    {
		my ($self, $tagname) = @_;
	
        $self->{isFound} = 0;
        $self->{inside}->{$tagname}--;
        
    }

    sub text
    {
        my ($self, $origtext) = @_;

        if ($self->{parsingList})
        {
            if ($self->{isSerie})
            {
                $self->{itemsList}[$self->{itemIdx}]->{serie} = $origtext;
                $self->{isSerie} = 0 ;
            }
            if ($self->{isPublisher} eq 1)
            {
                $self->{itemsList}[$self->{itemIdx}]->{edition} = $origtext;
                $self->{isPublisher} = 2 ;
            }
            if ($self->{isPublication} eq 1)
            {
                $self->{itemsList}[$self->{itemIdx}]->{publication} = $origtext;
                $self->{isPublication} = 0 ;
            }
        }
       	else
        {
            # Enleve les blancs en debut de chaine
            $origtext =~ s/^\s+//;
            # Je reinitialise le champs s il est cense etre vide
            $origtext =~ s/#TPFCHAMPSVIDE#//;
            if ($self->{isTitle} eq 2)
            {
                # si le titre contient INT (cas intégrale et donc sans titre de la série) on concaténe la série au titre.
                if($origtext =~ /INT/i)
                {
                   # on enléve le préfixe INT ou int et le point
                   $origtext =~ s/INT//i;
                   $origtext =~ s/.//;
                   $self->{curInfo}->{title} = $self->{itemsList}[$self->{wantedIdx}]->{serie}." ".$origtext;
                }
                else
                {
                   # si numéro avant titre on le transforme en tome et on concaténe avec le nom de la série.
                   if($origtext =~ /[0-9]./)
                   {
                      my $tome = substr($origtext,0,index($origtext,"."));
                      $tome =~ s/^\s+//;
                      my $titre = substr($origtext,index($origtext,".")+1);
                      $titre  =~ s/^\s+//;
                      $self->{curInfo}->{title} = $self->{itemsList}[$self->{wantedIdx}]->{serie}." Tome ".$tome ." : ".$titre;	
                   }
                   else
                   {
                      $self->{curInfo}->{title} = $origtext;
                   }
                }
                $self->{curInfo}->{web} = "http://www.bedetheque.com/".$self->{itemsList}[$self->{wantedIdx}]->{url};
                $self->{curInfo}->{serie} = $self->{itemsList}[$self->{wantedIdx}]->{serie};
                $self->{curInfo}->{language} = 'Français';
                $self->{isTitle} = 0 ;
            }
            elsif (($self->{isAuthor}) && ($self->{nbAuthor} < 3))
            {
               # Enleve la virgule entre le nom et le prenom
               $origtext =~ s/,//g;
               if (($origtext ne '') && ($origtext ne '#TPF NOIR ET BLANC TPF#'))
               {
                  $self->{curInfo}->{authors} .= $origtext;
                  $self->{curInfo}->{authors} .= ",";
               }
               $self->{isAuthor} = 0;
               $self->{nbAuthor} = $self->{nbAuthor} + 1;
            }
            elsif ($self->{isPublisher} eq 2)
            {
               $self->{curInfo}->{publisher} = $origtext;
               $self->{isPublisher} = 3 ;
            }
            elsif ($self->{isPublication} eq 2)
            {
               $self->{curInfo}->{publication} = $origtext;
               $self->{isPublication} = 3 ;
            }
            elsif ($self->{isEdition} eq 2)
            {
               $self->{curInfo}->{edition} = $origtext;
               $self->{isEdition} = 3 ;
            }
            elsif ($self->{isFormatPublication} eq 2 )
            {
               $self->{curInfo}->{format} = $origtext;
               $self->{isFormatPublication} = 3 ;
            }
            elsif ($self->{isISBN} eq 2)
            {
               $origtext =~ s/978\-//;
               $self->{curInfo}->{isbn} = $origtext;
               $self->{isISBN} = 3 ;
            }
            elsif ($self->{isPage} eq 2)
            {
               $self->{curInfo}->{pages} = $origtext;
               $self->{isPage} = 3 ;
            }
            elsif ($self->{isDescription} eq 2)
            {
               if($origtext ne '')
               {
                  if($self->{curInfo}->{description} ne '')
                  {
                     $self->{curInfo}->{description} .= "\n\n";
                  }
                  $self->{curInfo}->{description} .= "Info sur cette edition : ".$origtext;
               }
               $self->{isDescription} = 3 ;
            }
            elsif ($self->{isBook} eq 1)
            {
               if (($origtext eq "Editeur :") && ($self->{isPublisher} ne 3))
               {
                  $self->{isPublisher} = 1;
               }
               elsif (($origtext eq "Dépot légal :") && ($self->{isPublication} ne 3))
               {
                  $self->{isPublication} = 1;
               }
               elsif (($origtext eq "Collection :") && ($self->{isEdition} ne 3))
               {
                  $self->{isEdition} = 1;
               }
               elsif (($origtext eq "Taille :") && ($self->{isFormatPublication} ne 3))
               {
                  $self->{isFormatPublication} = 1;
               }
               elsif (($origtext eq "ISBN :") && ($self->{isISBN} ne 3))
               {
                  $self->{isISBN} = 1;
               }
               elsif (($origtext eq "Planches :") && ($self->{isPage} ne 3))
               {
                  $self->{isPage} = 1;
               }
               elsif (($origtext eq "Info édition : ") && ($self->{isDescription} ne 3))
               {
                  $self->{isDescription} = 1;
               }
            }
        }
    } 

    sub new
    {
		#la classe est instancié une seule fois au démarrage de l'appli.
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);

        $self->{hasField} = {
			serie => 1,
            title => 1,
            publication => 1,
            format => 0,
            edition => 1,
        };
        $self->{idPage} = 0;
        $self->{nbAuthor} = 0;
        $self->{isFound} = 0;
        $self->{isSerie} = 0;
        $self->{isBook} = 0;
        $self->{isUrl} = 0;
        $self->{isTitle} = 0;
        $self->{isAuthor} = 0;
        $self->{isFormatPublication} = 0;
        $self->{isPublisher} = 0;
        $self->{isISBN} = 0;
        $self->{isPublication} = 0;
        $self->{isFormat} = 0;
        $self->{isSerie} = 0;
        $self->{isPage} = 0;
        $self->{isDescription} = 0;
        $self->{isCover} = 0;
	
        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;
        
        #RAZ des variables (entre 2 recherches la classe reste en mémoire)
        $self->{idPage} = 0;
	$self->{nbAuthor} = 0;
	$self->{isFound} = 0;
        $self->{isSerie} = 0;
        $self->{isEdition} = 0;
        $self->{isBook} = 0;
        $self->{isUrl} = 0;
        $self->{isTitle} = 0;
        $self->{isAuthor} = 0;
        $self->{isFormatPublication} = 0;
        $self->{isPublisher} = 0;
        $self->{isISBN} = 0;
        $self->{isPublication} = 0;
        $self->{isFormat} = 0;
        $self->{isSerie} = 0;
        $self->{isPage} = 0;
        $self->{isDescription} = 0;
        $self->{isCover} = 0;
        
        if ($self->{parsingList})
        {
        }
        else
        {
            $html =~ s|<u>||gi;
            $html =~ s|<li>|\n* |gi;
            $html =~ s|<br>|\n|gi;
            $html =~ s|<br />|\n|gi;
            $html =~ s|<b>||gi;
            $html =~ s|</b>||gi;
#            $html =~ s|<i>||gi;
#            $html =~ s|</i>||gi;
            $html =~ s|<p>|\n|gi;
            $html =~ s|</p>||gi;
            $html =~ s|\x{92}|'|g;
            $html =~ s|&#146;|'|gi;
            $html =~ s|&#149;|*|gi;
            $html =~ s|&#133;|...|gi;
            $html =~ s|\x{8C}|OE|gi;
            $html =~ s|\x{9C}|oe|gi;

            # Quand un champs n est pas renseigne il peut y avoir un souci
            $html =~ s|<td><font color="#5C7994"></font></td>|<td><font color="#5C7994"></font>#TPFCHAMPSVIDE#</td>|gi;

            $html =~ s|<font color="#D19159">||gi;
            $html =~ s|</font>||gi;
            # Ce n est pas un coloriste donc il ne faut pas le rajouter a la liste des auteurs
            $html =~ s|&lt;N&amp;B&gt;|#TPF NOIR ET BLANC TPF#|gi;
        }

        return $html;
    }
    
    sub getSearchUrl
    {
		my ($self, $word) = @_;
		# si isbn renseigné alors url de recherche différent
		if((length($word) eq 13 || length($word) eq 10) && ($word =~ /[0-9]/))
		{
			# si contient pas de caractére - alors insertion de ceux ci pour recherche chez bdgest (ISBN sur 10 au lieu de 13)
			if($word =~ /\-/)
			{
				$word =~ s/978\-//;
				return "http://www.bedetheque.com/index.php?R=1&RechISBN=". $word;
			}
			else
			{
				# Ajouts des - et enléve le 978 en début si présent
				$word =~ s/978//;
				
				#re calcul de la clé de vérification
				my $total = substr($word,0,1)*10;
				$total = $total + (substr($word,1,1)*9);
				$total = $total + (substr($word,2,1)*8);
				$total = $total + (substr($word,3,1)*7);
				$total = $total + (substr($word,4,1)*6);
				$total = $total + (substr($word,5,1)*5);
				$total = $total + (substr($word,6,1)*4);
				$total = $total + (substr($word,7,1)*3);
				$total = $total + (substr($word,8,1)*2);
				$total = 11 - ($total%11);
				
				if($total eq 10)
				{
					$total = 'X';
				}
				
				$word = substr($word,0,1)."-".substr($word,1,2)."%25-%25".substr($word,7,2)."-".$total;
				return "http://www.bedetheque.com/index.php?R=1&RechISBN=". $word;
			}
		}
		else
		{
			return "http://www.bedetheque.com/index.php?R=1&RechSerie=". $word;
        	}
    }
    
    sub getItemUrl
    {
		my ($self, $url) = @_;
		
        return "http://www.bedetheque.com/" . $url;
    }

    sub getName
    {
        return "BDGest";
    }
    
    sub getCharset
    {
        my $self = shift;
        return "ISO-8859-1";
    }

    sub getAuthor
    {
        return 'Rataflo';
    }
    
    sub getLang
    {
        return 'FR';
    }

    sub getSearchFieldsArray
    {
        return ['isbn','title'];
    }


}

1;
