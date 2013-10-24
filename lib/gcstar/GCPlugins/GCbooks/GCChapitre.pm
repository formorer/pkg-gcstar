package GCPlugins::GCbooks::GCChapitre;

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
    package GCPlugins::GCbooks::GCPluginChapitre;

    use base qw(GCPlugins::GCbooks::GCbooksPluginsBase);
    use URI::Escape;

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {

            if (($tagname eq 'a') && ( $attr->{id} =~ m/ctl00_PHCenter_SearchResult1_rpResult_ctl.._searchResultTitle_hlProduct/))
            {
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{url} = "http://www.chapitre.com" . $attr->{href};
                $self->{isTitle} = 1 ;
            }
            elsif ($tagname eq 'tpfauthortpf')
            {
                $self->{isAuthor} = 1 ;
            }
            elsif ($tagname eq 'strong')
            {
                $self->{isAnalyse} = 1 ;
            }
        }
        else
        {
            if ($self->{isAuthor} eq 2)
            {
                if ($tagname ne 'a')
                {
                   $self->{isAuthor} = 0 ;
                }
            }
            elsif (($tagname eq 'div') && ($attr->{class} eq 'clear'))
            {
                $self->{isDescription} = 0 ;
            }
            elsif ($tagname eq 'td')
            {
                if ($self->{isPublisher} eq 1)
                {
                   $self->{isPublisher} = 2 ;
                }
                elsif ($self->{isPublication} eq 1)
                {
                   $self->{isPublication} = 2 ;
                }
                elsif ($self->{isISBN} eq 1)
                {
                   $self->{isISBN} = 2 ;
                }
                elsif ($self->{isLanguage} eq 1)
                {
                   $self->{isLanguage} = 2 ;
                }
                elsif ($self->{isCollection} eq 1)
                {
                   $self->{isCollection} = 2 ;
                }
                elsif ($self->{isGenre} eq 1)
                {
                   $self->{isGenre} = 2 ;
                }
            }
            elsif (($tagname eq 'a') && ( $attr->{id} eq 'ctl00_PHCenter_ProductFile1_ProductTitle1_linkTitleProduct'))
            {
                $self->{isTitle} = 1 ;
            }
            elsif (($tagname eq 'div') && ( $attr->{id} eq 'ctl00_PHCenter_ProductFile1_ProductTitle1_pnlAuthor'))
            {
                $self->{isAuthor} = 1 ;
            }
            elsif (($tagname eq 'h2') && ( $self->{isAuthor} eq 1))
            {
                $self->{isAuthor} = 2 ;
            }
            elsif (($tagname eq 'div') && ( $attr->{id} eq 'ctl00_PHCenter_ProductFile1_ProductTitle1_pnlTranslator'))
            {
                $self->{isTranslator} = 1 ;
            }
            elsif (($tagname eq 'tpftraducteurtpf') && ( $self->{isTranslator} eq 1))
            {
                $self->{isTranslator} = 2 ;
            }
            elsif (($tagname eq 'img') && ( $attr->{id} eq 'ctl00_PHCenter_ProductFile1_ProductPicture1_imgProduct') && ( index($attr->{src},"http://images.chapitre.com/indispo") eq -1 ))
            {
                $self->{curInfo}->{cover} = $attr->{src};
            }
            elsif (($tagname eq 'div') && ($attr->{class} eq 'presentation'))
            {
                $self->{isDescription} = 1 ;
            }
            elsif (($tagname eq 'tpfdescriptiontpf') && ($self->{isDescription} eq 1))
            {
                $self->{isDescription} = 2 ;
            }
            elsif ($tagname eq 'th')
            {
                $self->{isAnalyse} = 1 ;
            }
            elsif (($tagname eq 'a') && ( $attr->{href} =~ m|/CHAPITRE/fr/search/Default.aspx\?collection=|i))
            {
                $self->{isCollection} = 2 ;
            }
            elsif (($tagname eq 'a') && ( $attr->{href} =~ m|/CHAPITRE/fr/search/Default.aspx\?themeId=|i))
            {
                $self->{isGenre} = 2 ;
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
                # Enleve les blancs en debut de chaine
                $origtext =~ s/^\s+//;
                # Enleve les blancs en fin de chaine
                $origtext =~ s/\s+$//g;
                if ($self->{itemsList}[$self->{itemIdx}]->{authors} eq '')
                {
                   $self->{itemsList}[$self->{itemIdx}]->{authors} = $origtext;
                }
                else
                {
                   $self->{itemsList}[$self->{itemIdx}]->{authors} .= ', ';
                   $self->{itemsList}[$self->{itemIdx}]->{authors} .= $origtext;
                }
                $self->{isAuthor} = 0 ;
            }
            elsif ($self->{isAnalyse})
            {
                $self->{isPublisher} = 1 if ($origtext =~ m/Editeur :/i);
                $self->{isSerie} = 1 if ($origtext =~ m/Collection :/i);
                $self->{isPublication} = 1 if ($origtext =~ m/Date :/i);

                $self->{isAnalyse} = 0 ;
            }
            elsif ($self->{isPublisher})
            {
                my @array = split(/\n/,$origtext);
                $self->{itemsList}[$self->{itemIdx}]->{edition} = $array[0];
                $self->{isPublisher} = 0 ;
            }
            elsif ($self->{isPublication})
            {
                my @array = split(/\n/,$origtext);
                $self->{itemsList}[$self->{itemIdx}]->{publication} = $array[0];
                $self->{isPublication} = 0 ;
            }
            elsif ($self->{isSerie})
            {
                my @array = split(/\n/,$origtext);
                $self->{itemsList}[$self->{itemIdx}]->{serie} = $array[0];
                $self->{isSerie} = 0 ;
            }
        }
       	else
        {
            # Enleve les blancs en debut de chaine
            $origtext =~ s/^\s+//;
            # Enleve les blancs en fin de chaine
            $origtext =~ s/\s+$//g;
            if ($self->{isTitle})
            {
                $self->{curInfo}->{title} = $origtext;
                $self->{isTitle} = 0 ;
            }
            elsif ($self->{isAuthor} eq 2)
            {
                if ( $origtext ne '')
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
                      $nom_prenom[0] =~ s/\s+$//;
                      $nom_prenom[1] =~ s/\s+$//;
                      if ($self->{curInfo}->{authors} eq '')
                      {
                         if ($nom_prenom[1] ne '')
                         {
                            $self->{curInfo}->{authors} = $nom_prenom[1] ." " . $nom_prenom[0];
                         }
                         else
                         {
                            $self->{curInfo}->{authors} = $nom_prenom[0];
                         }
                      }
                      else
                      {
                         if ($nom_prenom[1] ne '')
                         {
                            $self->{curInfo}->{authors} .= ", " . $nom_prenom[1] ." " . $nom_prenom[0];
                         }
                         else
                         {
                            $self->{curInfo}->{authors} .= ", " . $nom_prenom[0];
                         }
                      }
                   }
                   $self->{isAuthor} = 0 ;
                }
            }
            elsif ($self->{isTranslator} eq 2)
            {
                $self->{curInfo}->{translator} = $origtext;
                $self->{isTranslator} = 0 ;
            }
            elsif ($self->{isPublisher} eq 2)
            {
                $self->{curInfo}->{publisher} = $origtext;
                $self->{isPublisher} = 0 ;
            }
            elsif ($self->{isDescription} eq 2)
            {
                $self->{curInfo}->{description} = $origtext;
                $self->{isDescription} = 0 ;
            }
            elsif ($self->{isPublication} eq 2)
            {
                $self->{curInfo}->{publication} = $origtext;
                $self->{isPublication} = 0 ;
            }
            elsif ($self->{isAnalyse})
            {
                $self->{isPublication} = 1 if ($origtext =~ m/parution/i);
                $self->{isISBN} = 1 if ($origtext =~ m/EAN13/i);
                $self->{isPublisher} = 1 if ($origtext =~ m/Editeur/i);
                $self->{isLanguage} = 1 if ($origtext =~ m/Langue/i);
                $self->{isCollection} = 1 if ($origtext =~ m/Collection/i);
                $self->{isGenre} = 1 if ($origtext =~ m/Genre/i);

                $self->{isAnalyse} = 0 ;
            }
            elsif ($self->{isISBN} eq 2)
            {
                $self->{curInfo}->{isbn} = $origtext;
                $self->{isISBN} = 0 ;
            }
            elsif ($self->{isLanguage} eq 2)
            {
                $self->{curInfo}->{language} = $origtext;
                $self->{isLanguage} = 0 ;
            }
            elsif ($self->{isCollection} eq 2)
            {
                $self->{curInfo}->{serie} = $origtext;
                $self->{isCollection} = 0 ;
            }
            elsif ($self->{isGenre} eq 2)
            {
                $origtext =~ s|/|,|gi;
                $self->{curInfo}->{genre} = $origtext;
                $self->{isGenre} = 0 ;
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
            serie => 1,
        };

        $self->{isTitle} = 0;
        $self->{isAuthor} = 0;
        $self->{isPublisher} = 0;
        $self->{isSerie} = 0;
        $self->{isPublication} = 0;
        $self->{isAnalyse} = 0;
        $self->{isDescription} = 0;
        $self->{isISBN} = 0;
        $self->{isLanguage} = 0;
        $self->{isCollection} = 0;
        $self->{isTranslator} = 0;
        $self->{isGenre} = 0;

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        if ($self->{parsingList})
        {
            $html =~ s|<b>||gi;
            $html =~ s|</b>||gi;
            $html =~ s|</a>,|</a>,<tpfauthortpf>|gi;
        }
        else
        {

            $html =~ s|</strong>|</strong><tpftraducteurtpf>|gi;
            $html =~ s|</h3>|</h3><tpfdescriptiontpf>|gi;

            $html =~ s|<u>||gi;
            $html =~ s|<li>|\n* |gi;
            $html =~ s|<br>|\n|gi;
            $html =~ s|<br />|\n|gi;
            $html =~ s|<b>||gi;
            $html =~ s|</b>||gi;
            $html =~ s|<i>||gi;
            $html =~ s|</i>||gi;
            $html =~ s|<p>|\n|gi;
            $html =~ s|</p>||gi;
            $html =~ s|\x{92}|'|g;
            $html =~ s|&#146;|'|gi;
            $html =~ s|&#149;|*|gi;
            $html =~ s|&#133;|...|gi;
            $html =~ s|\x{85}|...|gi;
            $html =~ s|\x{8C}|OE|gi;
            $html =~ s|\x{9C}|oe|gi;

        }

        return $html;
    }
    
    sub getSearchUrl
    {
		my ($self, $word) = @_;

        $word =~ s/\+/ /g;
        return ('http://www.chapitre.com/CHAPITRE/fr/search/Default.aspx?search=true', ["quicksearch" => "$word"] );

    }
    
    sub getItemUrl
    {
		my ($self, $url) = @_;
		
        return $url;
    }

    sub getName
    {
        return "Chapitre.com";
    }
    
    sub getCharset
    {
        my $self = shift;
        return "ISO-8859-15";
    }

    sub getAuthor
    {
        return 'TPF';
    }
    
    sub getLang
    {
        return 'FR';
    }

    sub getSearchFieldsArray
    {
        return ['ISBN', 'title'];
    }
}

1;
