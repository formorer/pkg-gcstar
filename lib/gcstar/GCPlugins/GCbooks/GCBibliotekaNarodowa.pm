package GCPlugins::GCbooks::GCbooksBibliotekaNarodowa;

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
use utf8;

use GCPlugins::GCbooks::GCbooksCommon;

my $searchISBN = "";

{
    package GCPlugins::GCbooks::GCPluginBibliotekaNarodowa;

    use base qw(GCPlugins::GCbooks::GCbooksPluginsBase);
    use URI::Escape;

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;

        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
          if ($tagname eq 'frameset') #od razu mamy wynik
            {
                $self->{isBook} = 7;
                $self->{itemIdx}++;
            }
          if (($tagname eq 'frame') && ($attr->{name} eq 'bib_frame') && $self->{isBook} == 7) #od razu mamy wynik
            {
                $self->{isUrl} = 1;
                $self->{itemsList}[$self->{itemIdx}]->{url} = "http://alpha.bn.org.pl".$attr->{src};
                $self->{isUrl} = 0;
                $self->{isBook} = 0;
            }

            if (($tagname eq 'tr') && ($attr->{class} eq 'browseEntry'))
              {
                $self->{isBook} = 1;
                $self->{itemIdx}++;
              }
            if (($tagname eq 'td') && ($attr->{class} eq 'browseEntryData') && ($self->{isBook} == 1))
              {
                $self->{isAuthor} = 2;
              }
            if (($tagname eq 'a') && ($self->{isBook} == 1) && ($self->{isAuthor} > 0))
              {
                $self->{isUrl} = 1;
                $self->{itemsList}[$self->{itemIdx}]->{url} = "http://alpha.bn.org.pl".$attr->{href};
                $self->{itemsList}[$self->{itemIdx}]->{url} =~ s|frameset|bibframe|;
                $self->{isUrl} = 0;
                $self->{isAuthor} = 0;
                $self->{isTitle} = 1;
              }
            if (($tagname eq 'td') && ($attr->{class} eq 'browseEntryYear') && ($self->{isBook} == 1))
              {
                $self->{isPublication} = 1;
              }
        }
        else
        {
             if (($tagname eq 'div') && ($attr->{id} eq 'wrgTIAUTR'))
               {
                 $self->{isTitle} = 1;
                 $self->{isAuthor} = 1;
                 $self->{isTranslator} = 1;
               }
             if (($tagname eq 'div') && ($attr->{id} eq 'wrgISBN'))
               {
                 $self->{isISBN} = 1;
               }
             if (($tagname eq 'div') && ($attr->{id} eq 'wrgPAGES'))
               {
                 $self->{isPage} = 1;
               }
             if (($tagname eq 'div') && ($attr->{id} eq 'wrgPUBPD'))
               {
                   $self->{isPublisher} = 1;
                   $self->{isPublication} = 1;
               }
             if (($tagname eq 'div') && ($attr->{id} eq 'wrgSERIA'))
               {
                $self->{isSerie} = 1;
              }
             if (($tagname eq 'div') && ($attr->{id} eq 'wrgEDITI'))
               {
                 $self->{isEdition} = 1;
               }
        }
    }


    sub end
    {
        my ($self, $tagname) = @_;

        if ($self->{parsingList})
          {
            if (($tagname eq 'tr') && ($self->{isBook} == 1))
              {
                $self->{isBook} = 0;
              }
          }

        $self->{isFound} = 0;
        $self->{inside}->{$tagname}--;
    }

    sub text
    {
        my ($self, $origtext) = @_;

        $origtext =~ s|^\s*||m;
        $origtext =~ s|\s*$||m;

        if ($self->{parsingList})
        {
            if ($self->{isBook} == 1)
            {
              if ($self->{isTitle} == 1)
                {
                  $self->{itemsList}[$self->{itemIdx}]->{title} = $origtext;
                  $self->{isTitle} = 0;
                }
              if ($self->{isAuthor} > 0)
                {
                  $origtext =~ s|\s*\/\s*(.*)\s*;|$1|;
                  $self->{itemsList}[$self->{itemIdx}]->{authors} = $1;
                  $self->{isAuthor} = 1;
                }
              if ($self->{isPublication} == 1)
                {
                  $self->{itemsList}[$self->{itemIdx}]->{edition} = $origtext;
                  $self->{isPublication} = 0;
                }
            }

        }
        else
        {
            if (($self->{isTitle} == 1) && ($self->{isAuthor} == 1) && ($self->{isTranslator} == 1))
              {
                my ($ti, $au, $tr, $bubu);
                $origtext =~ m|.*(\.){1}$|;
                $bubu = $1;
                if ($bubu eq '.')
                  {
                    $origtext =~ s|(.*)\.$|$1|;
                  }
                $origtext =~ m/([^\/]+)(\/\s+[^;]*)?(;\s*.*(tł|przeł|przekł)\..*)?$/;
#                $origtext =~ m|([^/]+)(/\s[^;]+)?(;.*)?$|;
                $ti = $1;
                $au = $2;
                $tr = $3;
                $ti =~ s|([^:]*):?.*$|$1|;
                $ti =~ s|\s*$||;
                $self->{curInfo}->{title} = $ti;
                $self->{isTitle} = 0;
                $au =~ s|^(.*)il\..*$|$1|;
                $au =~ s/(\/|tekst)//g;
                $au =~ s| i |,|g;
                $au =~ s|, |,|g;
                $au =~ s|^\s*||;
                $au =~ s|\s*$||;
                $self->{curInfo}->{authors} = $au;
                $self->{isAuthor} = 0;
                $tr =~ s|[\[\]]||g;
                $tr =~ s/;\s*.*(tł|przeł|przekł)\. (\[.*\] )?(.*)\.?$/$3/;
                $tr =~ s|(z \w+\. )?(.*)|$2|;
                $self->{curInfo}->{translator} = $tr;
                $self->{isTranslator} = 0;
              }
            if (($self->{isPublisher} == 1) && ($self->{isPublication} == 1))
              {
                my ($pu, $pd);
                $origtext =~ m|(.*)\s:\s(.*),\s(.*)|;
                $pu = $2;
                $pd = $3;
                $pu =~ s|([^"]*")?([^"]*)"?|$2|;
                $pu =~ s|[\[\]]||g;
                $self->{curInfo}->{publisher} = $pu;
                $self->{isPublisher} = 0;
                $pd =~ s|[^\d]||g;
                $self->{curInfo}->{publication} = $pd;
                $self->{isPublication} = 0;
              }
              if ($self->{isISBN} eq '1')
                {
                  my ($pom1, $pom2);
                  if ($self->{searchField} eq 'isbn')
                    {
                      $pom1 = $self->{searchISBN};
                      $pom2 = $origtext;
                      $pom2 =~ s|[^\dX]||g;
                      $pom1 =~ s|-||g;
                      $pom2 =~ s|-||g;
                      if ($pom1 eq $pom2)
                        {
                          $self->{curInfo}->{isbn} = $self->{searchISBN};
                        }
                      else
                        {
                          $self->{curInfo}->{isbn} = $origtext;
                        }
                    }
                  else
                    {
                      $self->{curInfo}->{isbn} = $origtext;
                    }
                  $self->{isISBN} = 0;
                }
              if ($self->{isPage} eq '1')
                {
                  $self->{curInfo}->{pages} = $origtext;
                  $self->{isPage} = 0;
                }
              if ($self->{isEdition} eq '1')
                {
                  $origtext =~ s|[\[\]]||g;
                  $origtext =~ s|(.*)\.{1}$|$1|;
                  $self->{curInfo}->{edition} = $origtext;
                  $self->{isEdition} = 0;
                }
             if ($self->{isSerie} eq '1')
               {
                 $self->{curInfo}->{serie} = $origtext;
                 $self->{isSerie} = 0;
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
            format => 0,
            edition => 1,
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
        $self->{isTranslator} = 0;

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        $self->{parsingEnded} = 0;
        $self->{insideResults} = 0;

        if ($self->{parsingList})
        {
            $html =~ s|<b>(.*?)</b>|$1|gms;
            $html =~ s|<td class="browseEntryData">\s*<a(.*)/a>\s*(.*)\s*|<td class="browseEntryData">$2<a$1/a>|gm;
        }
        else
        {
             $html =~ s|</?strong>||gi;
             $html =~ s|</?br>||gi;
             $html =~ s|</?i>||gi;

             $html =~ s|<td.*>ISBN</td>\s*<.*>\s*(\w*)</td>|<div id="wrgISBN">$1</div>|m;
             $html =~ s|<td.*>Seria</td>\s*<.*>\s*(.*)\s*</td>|<div id="wrgSERIA">$1</div>|m;
             $html =~ s|<div id="wrgSERIA">(.*)( / [^<]*)</div>|<div id="wrgSERIA">$1</div>|;
             $html =~ s|<td.*>Opis fiz</td>\s*<.*>\s*(\d*)\D.*</td>|<div id="wrgPAGES">$1</div>|m;
             $html =~ s|<td.*>TytuŁ</td>\s*<.*>\s*(.*)\s*</td>|<div id="wrgTIAUTR">$1</div>|m;
             $html =~ s|<td.*>Adres wyd</td>\s*<.*>\s*(.*)\s*</td>|<div id="wrgPUBPD">$1</div>|m;
             $html =~ s|<td.*>Wydanie</td>\s*<.*>\s*(.*)\s*</td>|<div id="wrgEDITI">$1</div>|m;
        }

        return $html;
    }

    sub getSearchUrl
    {
	my ($self, $word) = @_;
        my $bubu;
        if ($self->{searchField} eq 'isbn')
          {
            $bubu = "i";
            $self->{searchISBN} = $word;
          }
        else
          {
            $bubu = "t";
            $self->{searchISBN} = "";
          }
        return "http://alpha.bn.org.pl/search*pol/".$bubu."?SEARCH=".$word;
    }

    sub getItemUrl
    {
        my ($self, $url) = @_;
        return $url if $url;
        return 'http://alpha.bn.org.pl'
    }

    sub getName
    {
        return "Biblioteka Narodowa";
    }

    sub getCharset
    {
        my $self = shift;
        #return "UTF-8";
        return "ISO-8859-2";
    }

    sub getAuthor
    {
        return 'WG';
    }

    sub getLang
    {
        return 'PL';
    }

    sub getSearchFieldsArray
    {
        return ['isbn', 'title'];
    }

}

1;
