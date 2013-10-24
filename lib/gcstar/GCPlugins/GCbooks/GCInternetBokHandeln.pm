package GCPlugins::GCbooks::GCbooksInternetBokHandeln;

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
    package GCPlugins::GCbooks::GCPluginInternetBokHandeln;

    use base qw(GCPlugins::GCbooks::GCbooksPluginsBase);
    use URI::Escape;

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {

            if (($tagname eq 'span') && ($attr->{class} eq 'title1'))
            {
                $self->{isFound} = 1 ;
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{url} = $self->{loadedUrl};
            }
            elsif (($tagname eq 'td') && ($attr->{rowspan} eq '4') && ($self->{isBook} eq '0') && ($self->{isFound} eq 0))
            {
                # En fait la sequence est un peu tordue. Je cherche le deuxieme passage dans la sequence
                # rowspan/a
                $self->{isBook} = 1 ;
                $self->{isUrl} = 1 ;
            }
            elsif (($tagname eq 'img') && ($self->{isBook} eq '1') && ($self->{isUrl}))
            {
                $self->{isBook} = 2 ;
            }
            elsif (($tagname eq 'a') && ($self->{isBook} eq '2') && ($self->{isUrl}))
            {
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{url} = "http://www.internetbokhandeln.se" . $attr->{href};
                $self->{isUrl} = 0 ;
                $self->{isTitle} = 1 ;
            }
            elsif (($tagname eq 'span') && ($attr->{class} eq 'author') && ($self->{isFound} eq 0))
            {
                $self->{isAuthor} = 1 ;
                $self->{isBook} = 0 ;
            }
            elsif (($tagname eq 'span') && ($attr->{class} eq 'shaded') && ($self->{isFound} eq 0))
            {
                $self->{isEditor_Publication_Format_Lang} = 1 ;
                $self->{isBook} = 0 ;
            }
        }
        else
        {
            if ($self->{isAuthor} eq 1)
            {
                $self->{isAuthor} = 2 ;
            }
            elsif ($self->{isPublisher} eq 1)
            {
                $self->{isPublisher} = 2 ;
            }
            elsif ($self->{isISBN} eq 1)
            {
                $self->{isISBN} = 2 ;
            }
            elsif ($self->{isFormat} eq 1)
            {
                $self->{isFormat} = 2 ;
            }
            elsif ($self->{isEdition} eq 1)
            {
                $self->{isEdition} = 2 ;
            }
            elsif ($self->{isPage} eq 1)
            {
                $self->{isPage} = 2 ;
            }
            elsif ($self->{isLanguage} eq 1)
            {
                $self->{isLanguage} = 2 ;
            }
            elsif ($self->{isPublication} eq 1)
            {
                $self->{isPublication} = 2 ;
            }
            elsif ($self->{isSerie} eq 1)
            {
                $self->{isSerie} = 2 ;
            }
            elsif (($tagname eq 'span') && ($attr->{class} eq 'title1'))
            {
                $self->{isTitle} = 1 ;
                # On initialise la variable ( sinon d une fiche sur l autre est n est pas reinitialisee )
                $self->{isDescription} = 0;
            }
            elsif (($tagname eq 'span') && ($attr->{class} eq 'font5'))
            {
                $self->{isAnalyse} = 1 ;
            }
            elsif (($tagname eq 'p') && ($self->{curInfo}->{isbn} ne '') && ($self->{curInfo}->{description} eq '') && ($self->{isDescription} ne 2))
            {
                $self->{isDescription} = 1 ;
            }
            elsif (($tagname eq 'div') && ($attr->{id} eq 'largebook'))
            {
                # Pour etre sur s il n y a pas de commentaire de ne pas prendre n importe quoi
                $self->{isDescription} = 2 ;
            }
            elsif (($tagname eq 'td') && ($attr->{class} eq 'pricecolumn'))
            {
                $self->{isCover} = 1 ;
            }
            elsif (($tagname eq 'img') && ($self->{isCover} eq 1))
            {
                # le but est de determiner s il y a une couverture ou non, et s il y en a une, on recuperera
                # la version grand format qui est bien plus tard
                if ($attr->{onclick} eq 'return showBig();')
                {
                   $self->{isCover} = 2 ;
                }
                else
                {
                   if ($attr->{src} eq '/i/dummy.gif')
                   {
                      # Il n y a pas d image
                      $self->{isCover} = 3 ;
                   }
	                   else
                   {
                      $self->{curInfo}->{cover} = $attr->{src} ;
                      $self->{isCover} = 3 ;
                   }
                }
            }
            elsif (($tagname eq 'img') && ($attr->{onclick} eq 'return hideBig();') && ($self->{isCover} eq 2))
            {
                $self->{curInfo}->{cover} = $attr->{src} ;
                $self->{isCover} = 3 ;
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
            if ($self->{isTitle})
            {
                $self->{itemsList}[$self->{itemIdx}]->{title} = $origtext;
                $self->{isTitle} = 0 ;
            }
            elsif ($self->{isAuthor})
            {
                my @array = split(/;/,$origtext);
                my $element;
                foreach $element (@array)
                {
                   my @nom_prenom = split(/,/,$element);
                   # Enleve les blancs en debut de chaine
                   $nom_prenom[0] =~ s/^\s//;
                   $nom_prenom[1] =~ s/^\s//;
                   # Enleve les blancs en fin de chaine
                   $nom_prenom[0] =~ s/\s$//;
                   $nom_prenom[1] =~ s/\s$//;
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
                }

                $self->{isAuthor} = 0 ;
            }
            elsif ($self->{isEditor_Publication_Format_Lang})
            {
                my @Editor_Publication_Format_Lang = split(/\|/,$origtext);

                $self->{itemsList}[$self->{itemIdx}]->{publication} = $Editor_Publication_Format_Lang[1];
                $self->{itemsList}[$self->{itemIdx}]->{publication} =~ s/^\s+//;
                $self->{itemsList}[$self->{itemIdx}]->{publication} =~ s/\s$+//;

                $self->{itemsList}[$self->{itemIdx}]->{format} = $Editor_Publication_Format_Lang[2];
                $self->{itemsList}[$self->{itemIdx}]->{format} =~ s/^\s+//;
                $self->{itemsList}[$self->{itemIdx}]->{format} =~ s/\s$+//;

                $self->{isEditor_Publication_Format_Lang} = 0 ;
            }
        }
       	else
        {
            # Enleve les blancs en debut de chaine
            $origtext =~ s/^\s+//;
            if ($self->{isTitle})
            {
                $self->{curInfo}->{title} = $origtext;
                $self->{isTitle} = 0 ;
            }
            elsif ($self->{isAnalyse})
            {
                $self->{isAuthor} = 1 if ($origtext =~ m/F.*rfattare/i);
                $self->{isISBN} = 1 if ($origtext =~ m/ISBN/i);
                $self->{isPublisher} = 1 if ($origtext =~ m/F.*rlag/i);
                $self->{isFormat} = 1 if ($origtext =~ m/Band/i);
                $self->{isEdition} = 1 if ($origtext =~ m/Upplagenr/i);
                $self->{isPage} = 1 if ($origtext =~ m/Sidor/i);
                $self->{isLanguage} = 1 if ($origtext =~ m/Spr.*k/i);
                $self->{isPublication} = 1 if ($origtext =~ m/Utgivning/i);
                $self->{isSerie} = 1 if ($origtext =~ m/Serie/i);

                $self->{isAnalyse} = 0 ;
            }
            elsif ($self->{isAuthor} eq 2)
            {
                my @array = split(/;/,$origtext);
                my $element;
                foreach $element (@array)
                {
                   my @nom_prenom = split(/,/,$element);
                   # Enleve les blancs en debut de chaine
                   $nom_prenom[0] =~ s/^\s//;
                   $nom_prenom[1] =~ s/^\s//;
                   # Enleve les blancs en fin de chaine
                   $nom_prenom[0] =~ s/\s$//;
                   $nom_prenom[1] =~ s/\s$//;
                   if ($nom_prenom[1] ne '')
                   {
                      $self->{curInfo}->{authors} .= $nom_prenom[1] ." " . $nom_prenom[0];
                   }
                   else
                   {
                      $self->{curInfo}->{authors} .= $nom_prenom[0];
                   }
                   $self->{curInfo}->{authors} .= ",";
                }

                $self->{isAuthor} = 0 ;
            }
            elsif ($self->{isISBN} eq 2)
            {
                # Il y a 2 ISBN sur le site, seul le premier m interesse
                if ($self->{curInfo}->{isbn} eq '')
                {
                    $self->{curInfo}->{isbn} = $origtext;
                }
                $self->{isISBN} = 0 ;
            }
            elsif ($self->{isPublisher} eq 2)
            {
                $self->{curInfo}->{publisher} = $origtext;
                $self->{isPublisher} = 0 ;
            }
            elsif ($self->{isFormat} eq 2)
            {
                my @array = split(/\n/,$origtext);

                $self->{curInfo}->{format} = $array[0];
                $self->{isFormat} = 0 ;
            }
            elsif ($self->{isEdition} eq 2)
            {
                # There is some trouble on the site with this field : it is not accurrate. For example for ISBN 9113014528
                # this field is set to 7000. So for instance this field isn't taken.
#                $self->{curInfo}->{edition} = $origtext;
                $self->{isEdition} = 0 ;
            }
            elsif ($self->{isPage} eq 2)
            {
                $self->{curInfo}->{pages} = $origtext;
                $self->{isPage} = 0 ;
            }
            elsif ($self->{isLanguage} eq 2)
            {
                $self->{curInfo}->{language} = $origtext;
                $self->{isLanguage} = 0 ;
            }
            elsif ($self->{isPublication} eq 2)
            {
                $self->{curInfo}->{publication} = $origtext;
                $self->{curInfo}->{publication} =~ s|([0-9]*) ([A-Za-z]*) ([0-9]*)|$1.'/'.$self->{monthNumber}->{$2}.'/'.$3|e;
                $self->{curInfo}->{publication} =~ s|([A-Za-z]*) ([0-9]*)|$self->{monthNumber}->{$1}.'/'.$2|e;
                $self->{isPublication} = 0 ;
            }
            elsif ($self->{isSerie} eq 2)
            {
                $self->{curInfo}->{serie} = $origtext;
                $self->{isSerie} = 0 ;
            }
            elsif ($self->{isDescription} eq 1)
            {
                $self->{curInfo}->{description} = $origtext;
                $self->{isDescription} = 2 ;
            }

        }
    } 

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);

        $self->{monthNumber} = {
            Januari => '01',
            Februari => '02',
            Mars => '03',
            April => '04',
            Maj => '05',
            Juni => '06',
            Juli => '07',
            Augusti => '08',
            September => '09',
            Oktober => '10',
            November => '11',
            December => '12'
        };

        $self->{hasField} = {
            title => 1,
            authors => 1,
            publication => 1,
            format => 1,
            edition => 0,
        };

        $self->{isBook} = 0;
        $self->{isUrl} = 0;
        $self->{isEditor_Publication_Format_Lang} = 0 ;
        $self->{isAnalyse} = 0;
        $self->{isFound} = 0;
        $self->{isTitle} = 0;
        $self->{isAuthor} = 0;
        $self->{isPublisher} = 0;
        $self->{isISBN} = 0;
        $self->{isFormat} = 0;
        $self->{isEdition} = 0;
        $self->{isPage} = 0;
        $self->{isLanguage} = 0;
        $self->{isPublication} = 0;
        $self->{isSerie} = 0;
        $self->{isDescription} = 0;
        $self->{isCover} = 0;

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        if ($self->{parsingList})
        {
            $html =~ s|<b>||gi;
            $html =~ s|</b>||gi;
        }
        else
        {
            $html =~ s|<li>|\n* |gi;
            $html =~ s|<br>|\n|gi;
            $html =~ s|<br />|\n|gi;
            $html =~ s|<b>||gi;
            $html =~ s|</b>||gi;
            $html =~ s|<i>||gi;
            $html =~ s|</i>||gi;
        }
        
        return $html;
    }
    
    sub getSearchUrl
    {
		my ($self, $word) = @_;
	
        return "http://www.internetbokhandeln.se/results.html?new_search=1&all_search=" . $word. "&search_media=all";

    }
    
    sub getItemUrl
    {
		my ($self, $url) = @_;
		
        return $url if $url;
        return 'http://www.internetbokhandeln.se/';
    }

    sub getName
    {
        return "InternetBokHandeln";
    }
    
    sub getAuthor
    {
        return 'TPF';
    }
    
    sub getLang
    {
        return 'SV';
    }

    sub getSearchFieldsArray
    {
        return ['isbn', 'title'];
    }

}

1;
