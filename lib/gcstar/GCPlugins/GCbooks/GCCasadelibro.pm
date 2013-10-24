package GCPlugins::GCbooks::GCbooksCasadelibro;

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

use GCPlugins::GCbooks::GCbooksCommon;

{
    package GCPlugins::GCbooks::GCPluginCasadelibro;

    use base qw(GCPlugins::GCbooks::GCbooksPluginsBase);
    use URI::Escape;

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {

            if (($tagname eq 'p') && ($attr->{class} eq 'tit'))
            {
                $self->{isBook} = 1 ;
                $self->{isUrl} = 1 ;
            }
            elsif (($tagname eq 'a') && ($self->{isBook}) && ($self->{isUrl}))
            {
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{url} = "http://www.casadelibro.com" . $attr->{href};
                $self->{isUrl} = 0 ;
                $self->{isTitle} = 1 ;
            }
            elsif (($tagname eq 'p') && ($attr->{class} eq 'liz'))
            {
                $self->{isBook} = 0 ;
            }
            elsif (($tagname eq 'span') && ($attr->{class} eq 'autor') && ($self->{isBook}))
            {
                $self->{isAuthor} = 1 ;
            }
            elsif (($tagname eq 'a') && ($attr->{class} =~ m/autor/i) && ($self->{isBook}))
            {
                $self->{isAuthor} = 1 ;
            }
            elsif (($tagname eq 'p') && ($attr->{class} eq 'puestoEditorial') && ($self->{isBook}))
            {
                $self->{isEditionPublication} = 1 ;
            }
        }
        else
        {
            if ($self->{isLanguage} eq 1)
            {
                $self->{isLanguage} = 2 ;
            }
            elsif ($self->{isEdition} eq 1)
            {
                $self->{isEdition} = 2 ;
            }
            elsif ($self->{isFormat} eq 1)
            {
                $self->{isFormat} = 2 ;
            }
            elsif ($self->{isSerie} eq 1)
            {
                $self->{isSerie} = 2 ;
            }
            elsif ($self->{isPublication} eq 1)
            {
                $self->{isPublication} = 2 ;
            }
            elsif ($self->{isISBN} eq 1)
            {
                $self->{isISBN} = 2 ;
            }
            elsif (($tagname eq 'span') && ($attr->{class} eq 'tit_ficha'))
            {
                $self->{isTitle} = 1 ;
            }
            elsif ($tagname eq 'tpfnoauthortpf')
            {
                $self->{isAuthor} = 1 ;
            }
            elsif (($tagname eq 'a') && ($attr->{class} eq 'autor2'))
            {
                $self->{isAuthor} = 1 ;
            }
            elsif (($tagname eq 'div') && ($attr->{class} eq 'edicion_ficha'))
            {
                $self->{isPublisher} = 1 ;
            }
            elsif ($tagname eq 'tpfstarttagtpf')
            {
                $self->{isAnalyse} = 1 ;
            }
            elsif (($tagname eq 'div') && ($attr->{class} eq 'txt_resumen'))
            {
                $self->{isDescription} = 1 ;
            }
            elsif (($tagname eq 'img') && ($attr->{id} eq 'imgFicha') && ($attr->{src} ne '/l/grande.gif'))
            {
                $self->{curInfo}->{cover} = "http://www.casadelibro.com" . $attr->{src} ;
            }

        }
    }

    sub end
    {
        my ($self, $tagname) = @_;

        $self->{inside}->{$tagname}--;
    }

    sub text
    {
        my ($self, $origtext) = @_;

        if ($self->{parsingList})
        {
            if ($self->{isTitle})
            {
                $self->{itemsList}[$self->{itemIdx}]->{title} = $origtext;
                $self->{isTitle} = 0 ;
            }
            elsif ($self->{isAuthor})
            {
                my @nom_prenom = split(/,/,$origtext);
                # Enleve les blancs en debut de chaine
                $nom_prenom[0] =~ s/^\s//;
                $nom_prenom[1] =~ s/^\s//;
                # Enleve les blancs en fin de chaine
                $nom_prenom[0] =~ s/\s+$//;
                $nom_prenom[1] =~ s/\s+$//;
                if ($self->{itemsList}[$self->{itemIdx}]->{authors} eq '')
                {
                   if ($nom_prenom[1] ne '')
                   {
                      $self->{itemsList}[$self->{itemIdx}]->{authors} = $nom_prenom[1] ." " . $nom_prenom[0];
                   }
                   else
                   {
                      $self->{itemsList}[$self->{itemIdx}]->{authors} = $nom_prenom[0];
                   }
                 }
                else
                {
                   if ($nom_prenom[1] ne '')
                   {
                      $self->{itemsList}[$self->{itemIdx}]->{authors} .= ", " . $nom_prenom[1] ." " . $nom_prenom[0];
                   }
                   else
                   {
                      $self->{itemsList}[$self->{itemIdx}]->{authors} .= ", " . $nom_prenom[0];
                   }
                }

                $self->{isAuthor} = 0 ;
            }
            elsif ($self->{isEditionPublication})
            {
                $_= $origtext;
                if (/(.*),\s([0-9][0-9][0-9][0-9]$)/)
                {
                   $self->{itemsList}[$self->{itemIdx}]->{edition} = $1;
                }
                else
                {
                   $self->{itemsList}[$self->{itemIdx}]->{edition} = $origtext;
                }

                $_= $origtext;
                if (/(.*)\s([0-9][0-9][0-9][0-9]$)/)
                {
                   $self->{itemsList}[$self->{itemIdx}]->{publication} = $2;
                }

                $self->{isEditionPublication} = 0 ;
            }
        }
       	else
        {
            if ($self->{isTitle})
            {
                $self->{curInfo}->{title} = $origtext;
                $self->{isTitle} = 0 ;
            }
            elsif ($self->{isPublisher})
            {
                $self->{curInfo}->{publisher} = $origtext;
                $self->{isPublisher} = 0 ;
            }
            elsif ($self->{isLanguage} eq 2)
            {
                my @array = split(/:/,$origtext);
                $self->{curInfo}->{language} = $array[1];
                $self->{curInfo}->{language} =~ s/^\s//;
                $self->{curInfo}->{language} =~ s/\s+$//;
                $self->{isLanguage} = 0 ;
            }
            elsif ($self->{isEdition} eq 2)
            {
                my @array = split(/:/,$origtext);
                $self->{curInfo}->{edition} = $array[1];
                $self->{curInfo}->{edition} =~ s/^\s//;
                $self->{curInfo}->{edition} =~ s/\s+$//;
                $self->{isEdition} = 0 ;
            }
            elsif ($self->{isFormat} eq 2)
            {
                my @array = split(/:/,$origtext);
                $self->{curInfo}->{format} = $array[1];
                $self->{curInfo}->{format} =~ s/^\s//;
                $self->{curInfo}->{format} =~ s/\s+$//;
                $self->{isFormat} = 0 ;
            }
            elsif ($self->{isSerie} eq 2)
            {
                my @array = split(/:/,$origtext);
                $self->{curInfo}->{serie} = $array[1];
                $self->{curInfo}->{serie} =~ s/^\s//;
                $self->{curInfo}->{serie} =~ s/\s+$//;
                $self->{isSerie} = 0 ;
            }
            elsif ($self->{isPublication} eq 2)
            {
                $self->{curInfo}->{publication} = $origtext;
                $self->{curInfo}->{publication} =~ s/^\s//;
                $self->{curInfo}->{publication} =~ s/\s+$//;
                $self->{isPublication} = 0 ;
            }
            elsif ($self->{isAnalyse})
            {
                $self->{isISBN} = 1 if ($origtext =~ m/ISBN/i);
                $self->{isLanguage} = 1 if ($origtext =~ m/Lengua/i);
                $self->{isEdition} = 1 if ($origtext =~ m/^n(.*)\sEdici/i);
                $self->{isFormat} = 1 if ($origtext =~ m/Encuadernaci/i);
                $self->{isSerie} = 1 if ($origtext =~ m/Colecci/i);
                $self->{isPublication} = 1 if ($origtext =~ m/^A(.*)o de Edici/i);

                $self->{isAnalyse} = 0 ;
            }
            elsif ($self->{isAuthor})
            {
                my @nom_prenom = split(/,/,$origtext);
                # Enleve les blancs en debut de chaine
                $nom_prenom[0] =~ s/^\s//;
                $nom_prenom[1] =~ s/^\s//;
                # Enleve les blancs en fin de chaine
                $nom_prenom[0] =~ s/\s+$//;
                $nom_prenom[1] =~ s/\s+$//;
                if ($nom_prenom[1] ne '')
                {
                   $self->{curInfo}->{authors} .= $nom_prenom[1] ." " . $nom_prenom[0];
                }
                else
                {
                   $self->{curInfo}->{authors} .= $nom_prenom[0];
                }
                $self->{curInfo}->{authors} .= ",";

                $self->{isAuthor} = 0 ;
            }
            elsif ($self->{isISBN} eq 2)
            {
                my @array = split(/:/,$origtext);
                $self->{curInfo}->{isbn} = $array[1];
                $self->{curInfo}->{isbn} =~ s/^\s//;
                $self->{isISBN} = 0 ;
            }
            elsif ($self->{isDescription})
            {
                $self->{curInfo}->{description} = $origtext;
                $self->{curInfo}->{description} =~ s/\t//g;
                $self->{curInfo}->{description} =~ s/^\s//;
                $self->{curInfo}->{description} =~ s/\s+$//;
                $self->{isDescription} = 0 ;
            }

        }
    } 

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);

        $self->{hasField} = {
            title => 1,
            authors => 1,
            publication => 1,
            format => 0,
            edition => 1,
        };

        $self->{isBook} = 0;
        $self->{isUrl} = 0;
        $self->{isEditionPublication} = 0 ;
        $self->{isAnalyse} = 0;
        $self->{isTitle} = 0;
        $self->{isAuthor} = 0;
        $self->{isPublisher} = 0;
        $self->{isLanguage} = 0;
        $self->{isEdition} = 0;
        $self->{isFormat} = 0;
        $self->{isSerie} = 0;
        $self->{isPublication} = 0;
        $self->{isISBN} = 0;
        $self->{isDescription} = 0;

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        if ($self->{parsingList})
        {
            $html =~ s|'| |gi;
        }
        else
        {
            my $found = index($html,"<div class=\"azul3\">");
            if ( $found >= 0 )
            {
               $html = substr($html, 0, $found);
            }

            $html =~ s|<li>|\n* |gi;
            $html =~ s|<br>|\n|gi;
            $html =~ s|<br />|\n|gi;
            $html =~ s|<b>||gi;
            $html =~ s|</b>||gi;
            $html =~ s|<i>||gi;
            $html =~ s|</i>||gi;
            $html =~ s|"tit_ficha"><strong>|"tit_ficha">|gi;
            $html =~ s|de </span>|<TPFNOAUTHORTPF>|gi;
            $html =~ s|<strong>|<TPFSTARTTAGTPF>|gi;
            $html =~ s|</strong>|<TPFSTOPTAGTPF>|gi;
        }
        
        return $html;
    }
    
    sub getSearchUrl
    {
		my ($self, $word) = @_;
	
        if ($self->{searchField} eq 'isbn')
        {

            return "http://www.casadellibro.com/busquedas/resultados2?titbus=&autorbus=&isbnbus=" . $word. "&editbus=&idibus=0&encbus=0&sl1=-1";
#            return "http://www.casadellibro.com/busquedas/quickResults/0,,1-i-" . $word. ",00.html?tBusq=t&tValueForSearch=" .$word. "&cFo=true&rOd=&NotQueryAgain=false";
        }
        else
        {
            my $word2 = $word;
            $word2 =~ s|\+|%20|gi;
            return "http://www.casadellibro.com/busquedas/quickResults2/0,," . $word2. ",00.html?Buscar=" .$word;
        }

    }
    
    sub getItemUrl
    {
		my ($self, $url) = @_;
		
        return $url if $url;
        return 'http://www.casadellibro.com/';
    }

    sub getName
    {
        return "Casadelibro";
    }
    
    sub getAuthor
    {
        return 'TPF';
    }
    
    sub getLang
    {
        return 'ES';
    }

    sub getSearchFieldsArray
    {
        return ['isbn', 'title'];
    }

}

1;
