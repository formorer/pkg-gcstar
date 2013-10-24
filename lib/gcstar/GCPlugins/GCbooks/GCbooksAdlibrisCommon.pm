package GCPlugins::GCbooks::GCbooksAdlibrisCommon;

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
    package GCPlugins::GCbooks::GCbooksAdlibrisPluginsBase;

    use base qw(GCPlugins::GCbooks::GCbooksPluginsBase);
    use URI::Escape;

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;

        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
            if (     (($tagname eq 'div') && ($attr->{class} eq 'productTitleFormat'))
                  || (($tagname eq 'a') && ($attr->{id} eq 'ctl00_main_frame_ctrlproduct_linkProductTitle'))
               )
            {
                $self->{isFound} = 1 ;
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{url} = $self->{loadedUrl};
            }
            elsif (($tagname eq 'a') && ($attr->{id} =~ m/_hlkTitle/i) && ($self->{isFound} eq '0'))
            {
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{url} = "http://www.adlibris.com/" . $self->{isLang} . "/" . $attr->{href};
                $self->{isTitle} = 1 ;
            }
            elsif (($tagname eq 'span') && ($attr->{id} =~ m/ctl00_main_frame_ctrlsearchhit_rptSearchHit_ctl/i) && ($attr->{id} =~ m/_Label2/i) && ($self->{isFound} eq '0'))
            {
                $self->{isAuthor} = 1 ;
            }
            elsif (($tagname eq 'span') && ($attr->{id} =~ m/ctl00_main_frame_ctrlsearchhit_rptSearchHit_ctl/i) && ($attr->{id} =~ m/_Label4/i) && ($self->{isFound} eq '0'))
            {
                $self->{isFormat} = 1 ;
            }
        }
        else
        {
            if (($tagname eq 'h1'))
            {
                $self->{isTitle} = 1 ;
            }
            elsif (($tagname eq 'li') && ($attr->{id} eq 'ctl00_main_frame_ctrlproduct_liISBN13'))
            {
                $self->{isbnLevel} = 1 ;
            }
            elsif ($self->{isbnLevel} > 0)
            {
                if ($self->{isbnLevel} < 5)
                {
                    $self->{isbnLevel}++ ;
                }
                else
                {
                    $self->{isISBN} = 1 ;
                    $self->{isbnLevel} = 0 ;
                }
            }
            elsif (($tagname eq 'a') && (($attr->{id} eq 'ctl00_main_frame_ctrlproduct_rptAuthor_ctl00_linkAuthor')) || ($attr->{id} eq 'ctl00_main_frame_ctrlproduct_rptAuthor_ctl01_linkAuthor'))
            {
                $self->{isAuthor} = 1 ;
            }
            elsif (($tagname eq 'a') && ($attr->{id} eq 'ctl00_main_frame_ctrlproduct_linkPublisher'))
            {
                $self->{isPublisher} = 1 ;
            }
            elsif (($tagname eq 'span') && ($attr->{id} eq 'ctl00_main_frame_ctrlproduct_lblPublished'))
            {
                $self->{isPublication} = 1 ;
            }
            elsif (($tagname eq 'span') && ($attr->{id} eq 'ctl00_main_frame_ctrlproduct_lblPages'))
            {
                $self->{isPages} = 1 ;
            }
            elsif (($tagname eq 'span') && ($attr->{id} eq 'ctl00_main_frame_ctrlproduct_lblLanguage'))
            {
                $self->{isLanguage} = 1 ;
            }
            elsif (($tagname eq 'span') && ($attr->{id} eq 'ctl00_main_frame_ctrlproduct_lblFormat'))
            {
                $self->{isReliure} = 1 ;
            }
            elsif (($tagname eq 'div') && ($attr->{class} eq 'productDescription'))
            {
                $self->{isDescription} = 1 ;
            }
            elsif (($tagname eq 'img') && ($attr->{id} eq 'ctl00_main_frame_ctrlproduct_imgProduct_ProductImageNotLinked') && !($attr->{src} =~ m/\/noimage./i))
            {
                $self->{curInfo}->{cover} = $attr->{src} ;
            }

        }
    }

    sub end
    {
        my ($self, $tagname) = @_;

        $self->{isFound} = 0 ;
        $self->{inside}->{$tagname}--;
        if (($self->{isDescription}) && ($tagname eq 'div'))
        {
            $self->{isDescription} = 0;
            $self->{curInfo}->{description} =~ s/^Beskrivning://g ;
            $self->{curInfo}->{description} =~ s/^Kuvaus://g ;
        }
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
                my @array = split(/&/,$origtext);
                my $element;
                foreach $element (@array)
                {
                   my @nom_prenom = split(/,/,$element);
                   # Enleve les blancs en debut de chaine
                   $nom_prenom[0] =~ s/^\s+//;
                   $nom_prenom[1] =~ s/^\s+//;
                   # Enleve les blancs en fin de chaine
                   $nom_prenom[0] =~ s/\s$+//;
                   $nom_prenom[1] =~ s/\s$+//;
                   if ($self->{itemsList}[$self->{itemIdx}]->{authors} eq '')
                   {
                      $self->{itemsList}[$self->{itemIdx}]->{authors} = $nom_prenom[1] ." " . $nom_prenom[0];
                   }
                   else
                   {
                      $self->{itemsList}[$self->{itemIdx}]->{authors} .= ", " . $nom_prenom[1] ." " . $nom_prenom[0];
                   }
                }

                $self->{isAuthor} = 0 ;
            }
            elsif ($self->{isFormat})
            {
                $self->{itemsList}[$self->{itemIdx}]->{format} = $origtext;
                $self->{isFormat} = 0 ;
            }
        }
        else
        {
            # Enleve les blancs en debut de chaine
            $origtext =~ s/^\s+//;
            $origtext =~ s/\s+$//;
            if ($self->{isTitle})
            {
                $self->{curInfo}->{title} = $origtext;
                $self->{isTitle} = 0 ;
            }
            elsif ($self->{isAuthor})
            {
                $self->{curInfo}->{authors} .= $origtext;
                $self->{curInfo}->{authors} .= ",";
                $self->{isAuthor} = 0 ;
            }
            elsif ($self->{isISBN})
            {
                $self->{curInfo}->{isbn} = $origtext;
                $self->{curInfo}->{isbn} =~ s/\s//g;
                $self->{isISBN} = 0 ;
            }
            elsif ($self->{isPublisher})
            {
                $self->{curInfo}->{publisher} = $origtext;
                $self->{isPublisher} = 0 ;
            }
            elsif ($self->{isPublication})
            {
                $self->{curInfo}->{publication} = $origtext;
                $self->{curInfo}->{publication} =~ s/(\d\d\d\d)(\d\d)/01\/$2\/$1/g;
                $self->{isPublication} = 0 ;
            }
            elsif ($self->{isPages})
            {
                $self->{curInfo}->{pages} = $origtext;
                $self->{isPages} = 0 ;
            }
            elsif ($self->{isLanguage})
            {
                $self->{curInfo}->{language} = $origtext;
                $self->{isLanguage} = 0 ;
            }
            elsif ($self->{isReliure})
            {
                $self->{curInfo}->{format} = $origtext;
                $self->{isReliure} = 0 ;
            }
            elsif ($self->{isDescription})
            {
                $self->{curInfo}->{description} .= $origtext ;
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
            publication => 0,
            format => 1,
            edition => 0,
        };

        $self->{isLang} = 'se';
        $self->{isFound} = 0;
        $self->{isTitle} = 0;
        $self->{isAuthor} = 0;
        $self->{isFormat} = 0;
        $self->{isPublisher} = 0;
        $self->{isISBN} = 0;
        $self->{isPublicationAndPages} = 0;
        $self->{isLangAndReliure} = 0;
        $self->{isDescription} = 0;

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        if ($self->{parsingList})
        {
        }
        else
        {
            $html =~ s|<li>|\n* |g;
            $html =~ s|<br>|\n|g;
            $html =~ s|<br />|\n|g;
            $html =~ s|<p>|\n|g;
            $html =~ s|<b>||g;
            $html =~ s|</b>||g;
            $html =~ s|<i>||g;
            $html =~ s|</i>||g;
        }
        
        return $html;
    }
    
    sub getSearchUrl
    {
                my ($self, $word) = @_;

        if ($self->{searchField} eq 'isbn')
        {
            return "http://www.adlibris.com/" . $self->{isLang} . "/searchresult.aspx?isbn=" . $word. "&amp%3BfromProduct=true";
        }
        else
        {
            return "http://www.adlibris.com/" . $self->{isLang} . "/searchresult.aspx?title=" . $word. "&amp%3BfromProduct=true";
        }

    }
    
    sub getItemUrl
    {
                my ($self, $url) = @_;

        return $url;
    }

    sub getName
    {
        return "Adlibris";
    }
    
    sub getAuthor
    {
        return 'TPF';
    }
    
    sub getLang
    {
        return 'SW';
    }

    sub getSearchFieldsArray
    {
        return ['isbn', 'title'];
    }

}

1;
