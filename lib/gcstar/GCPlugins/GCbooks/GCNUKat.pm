package GCPlugins::GCbooks::GCbooksNUKat;

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

my $searchURL = "";
my $searchISBN = "";

{
    package GCPlugins::GCbooks::GCPluginNUKat;

    use base qw(GCPlugins::GCbooks::GCbooksPluginsBase);
    use URI::Escape;

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;

        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
          if ($tagname eq 'title') #od razu mamy wynik
            {
                $self->{isBook} = 7;
            }

            if (($tagname eq 'tr') && ($attr->{class} eq 'intrRow'))
              {
                $self->{isBook} = 1;
                $self->{itemIdx}++;
              }
            if (($tagname eq 'td') && ($attr->{class} eq 'intrRowCell1') && ($self->{isBook} == 1))
              {
                $self->{isUrl} = 2;
              }
            if (($tagname eq 'a') && ($self->{isUrl} == 2) && ($origtext =~ /.*function=CARDSCR.*/))
              {
                $self->{isUrl} = 1;
                $self->{itemsList}[$self->{itemIdx}]->{url} = $attr->{href};
                $self->{itemsList}[$self->{itemIdx}]->{url} =~ s|skin=portal&||;
                $self->{isUrl} = 0;
              }
            if (($tagname eq 'td') && ($attr->{class} eq 'intrAutor') && ($self->{isBook} == 1))
              {
                $self->{isAuthor} = 1;
              }
            if (($tagname eq 'td') && ($attr->{class} eq 'intrTytul') && ($self->{isBook} == 1))
              {
                $self->{isTitle} = 1;
              }
            if (($tagname eq 'td') && ($attr->{class} eq 'intrWydaw') && ($self->{isBook} == 1))
              {
                $self->{isPublication} = 1;
              }
        }
        else
        {
             if (($tagname eq 'td') && ($attr->{class} eq 'wrgTITLE'))
               {
                 $self->{isTitle} = 1;
                 $self->{isAuthor} = 1;
                 $self->{isTranslator} = 1;
                 $self->{isArtist} = 1;
                 $self->{isISBN} = 2;
               }
             if (($tagname eq 'td') && ($attr->{class} eq 'wrgPAGES'))
               {
                 $self->{isPage} = 1;
               }
             if (($tagname eq 'td') && ($attr->{class} eq 'wrgSERIA'))
               {
                $self->{isSerie} = 1;
              }
             if (($tagname eq 'td') && ($attr->{class} eq 'wrgPUBLI'))
               {
                   $self->{isPublisher} = 1;
                   $self->{isPublication} = 1;
               }
             if (($tagname eq 'td') && ($attr->{class} eq 'wrgEDITI'))
               {
                 $self->{isEdition} = 1;
               }
             if (($tagname eq 'td') && ($attr->{class} eq 'wrgISBN') && ($self->{isISBN} == 2))
               {
                 $self->{isISBN} = 1;
               }

            if (($tagname eq 'div') && ($attr->{class} eq 'prodFeatureSpec') && ($self->{isFormat} eq '2'))
              {
                $self->{isFormat} = 1;
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
          if ($self->{isBook} == 7) #od razu mamy wynik?
            {
              if ($origtext =~ /Pełny opis/)
                {
                  $self->{isUrl} = 1;
                  $self->{itemIdx}++;
                  $self->{itemsList}[$self->{itemIdx}]->{url} = $searchURL;
                  $self->{isUrl} = 0;
                  $self->{isBook} = 0;
                }
            }
            if ($self->{isBook} == 1)
            {
              $origtext =~ s/^\s*//m;
              $origtext =~ s/\s*$//m;
              if ($self->{isTitle} == 1)
                {
                  $origtext =~ s|^\s*([^/]*)/?|$1|m;
                  $origtext =~ s|^\s*([^:]*):?|$1|m;
                  $origtext =~ s|\s*$||m;
                  $self->{itemsList}[$self->{itemIdx}]->{title} = $origtext;
                  $self->{isTitle} = 0;
                }
              if ($self->{isAuthor} == 1)
                {
                  $origtext =~ s|\s*\/\s*(.*)\s*|$1|;
                  $origtext =~ s|^\s*([^\.]*)\.?|$1|m;
                  $origtext =~ s|([^\(]*)(\([^\)]*\))?|$1|;
                  $origtext =~ s|\s*$||m;
                  $origtext =~ s|([^,]*), (.*)|$2 $1|m;
                  $self->{itemsList}[$self->{itemIdx}]->{authors} = $origtext;
                  $self->{isAuthor} = 0;
                }
              if ($self->{isPublication} == 1)
                {
                  $origtext =~ s|(.*)(\d{4})\D*|$2|s;
                  $origtext =~ s|^\s*([^\.]*)\.?|$1|m;
                  $self->{itemsList}[$self->{itemIdx}]->{edition} = $origtext;
                  $self->{isPublication} = 0;
                  $self->{isBook} = 0;
                }
            }

        }
        else
        {
            $origtext =~ s/^\s*//m;
            $origtext =~ s/\s*$//m;

            if ($self->{isFormat} eq '1')
            {
                $origtext =~ s|okładka: ||m;
                $self->{curInfo}->{format} = $origtext;
                $self->{isFormat} = 0;
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
                        $self->{curInfo}->{isbn} = $origtext;
                        $self->{isISBN} = 0;
                      }
                    else
                      {
                        $self->{isISBN} = 2;
                      }
                  }
                else
                  {
                    $origtext =~ s|[^\dX]||g;
                    $self->{curInfo}->{isbn} = $origtext;
                    $self->{isISBN} = 0;
                  }
              }
            if ($self->{isTitle} eq '1')
              {
                my ($pom1, $pom2, $ti, $au, $tr, $il);
                $origtext =~ m|([^/]*)/\s*([^;]*)(; )?([^;]*)(; )?([^;]*)$|;
                $ti = $1;
                $au = $2;
                $pom1 = $4;
                $pom2 = $6;
                $ti =~ s|^\s*||;
                $ti =~ s|\s*$||;
                $self->{curInfo}->{title} = $ti;
                $self->{isTitle} = 0;
                $au =~ s| i |,|g;
                $au =~ s|, |,|g;
                $au =~ s|[\[\]]||g;
                $au =~ s|tekst||g;
                $au =~ s|^\s*||;
                $au =~ s|\s*$||;
                $au =~ s|(.*)(\.{1})|$1|;
                $self->{curInfo}->{authors} = $au;
                $self->{isAuthor} = 0;
                $pom1 =~ s|[\[\]]||g;
                $pom1 =~ m|(.*)(.{1})|;
                if ($2 eq '.')
                  {
                    $pom1 = $1;
                  }
                $pom2 =~ s|[\[\]]||g;
                $pom2 =~ m|(.*)(.{1})|;
                if ($2 eq '.')
                  {
                    $pom2 = $1;
                  }
                if ($pom2 =~ /(przeł\.|przekł\.|tł\.|tłum\.)/)
                  {
                    $tr = $pom2;
                  }
                if ($pom2 =~ /(il\.|oprac\. graf\.)/)
                  {
                    $il = $pom2;
                  }
                if ($pom1 =~ /(przeł\.|przekł\.|tł\.|tłum\.)/)
                  {
                    $tr = $pom1;
                  }
                if ($pom1 =~ /(il\.|oprac\. graf\.)/)
                  {
                    $il = $pom1;
                  }
                $tr =~ s/(przeł\.|przekł\.|tł\.|tłum\.)//;
                $tr =~ s|z \w+\.||;
                $tr =~ s|^\s*||;
                $tr =~ s|\s*$||;
                $tr =~ s| i |,|g;
                $tr =~ s|, |,|g;
                $self->{curInfo}->{translator} = $tr;
                $self->{isTranslator} = 0;
                $il =~ s/(il\.|oprac\. graf\.)//;
                $il =~ s|^\s*||;
                $il =~ s|\s*$||;
                $il =~ s| i |,|g;
                $il =~ s|, |,|g;
                $self->{curInfo}->{artist} = $il;
                $self->{isArtist} = 0;
              }
              if ($self->{isPage} eq '1')
                {
                  $origtext =~ s|(\d*)\D.*|$1|;
                  $self->{curInfo}->{pages} = $origtext;
                  $self->{isPage} = 0;
                }
              if ($self->{isEdition} eq '1')
                {
                  $origtext =~ s|\D*(\d*)\D.*|$1|;
                  $self->{curInfo}->{edition} = $origtext;
                  $self->{isEdition} = 0;
                }
              if ($self->{isPublisher} eq '1')
                {
                  my $pom = $origtext;
                  $origtext =~ s|[^:]*:\s*(.*),.*|$1|;
                  $origtext =~ s|^\s*||;
                  $origtext =~ s|"(.*)"|$1|;
                  $self->{curInfo}->{publisher} = $origtext;
                  $pom =~ s|(.*)(\d{4})(\D*)|$2|;
                  $self->{curInfo}->{publication} = $pom;
                  $self->{isPublisher} = 0;
                  $self->{isPublication} = 0;
                }
             if ($self->{isSerie} eq '1')
               {
                 $origtext =~ s|([^;]*)(;.*)|$1|;
                 $origtext =~ s|\s*$||;
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
        $self->{isArtist} = 0;

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        $self->{parsingEnded} = 0;
        $self->{insideResults} = 0;
        $self->{actorsCounter} = 0;

        if ($self->{parsingList})
        {
            $html =~ s|<b>(.*?)</b>|$1|gms;
            $html =~ s|<img .*/book.gif">||g;
            $html =~ s|<font.*</font>||g;
            $html =~ s|<span class="highlight[^>]+>||g;
            $html =~ s|</?span[^>]*>||g;
            $html =~ s|<th[^>]*>Autor</th>\s*<td><a[^>]*>([^<]*)</a>|<td class="intrAutor">$1|gs;
            $html =~ s|<th[^>]*>Tytuł</th>\s*<td><a[^>]*>([^<]*)</a>|<td class="intrTytul">$1|gs;
            $html =~ s|<th[^>]*>Adres wyd.</th>\s*<td>|<td class="intrWydaw">|gs;
        }
        else
        {
             $html =~ s|</?strong>||gi;
             $html =~ s|</?i>||gi;
             $html =~ s|</?br>||gi;

             $html =~ s|<th[^>]*>Tytuł</th>\s*<td>\s*<a[^>]*>([^<]*)</a>|<td class="wrgTITLE">$1|gs;
             $html =~ s|<th[^>]*>Strefa serii</th>\s*<td>\s*<a[^>]*>([^<]*)</a>|<td class="wrgSERIA">$1|gs;
             $html =~ s|<th[^>]*>Adres wydawniczy</th>\s*<td>|<td class="wrgPUBLI">|gs;
             $html =~ s|<th[^>]*>Opis fizyczny</th>\s*<td>|<td class="wrgPAGES">|gs;
             $html =~ s|<th[^>]*>Oznaczenie wydania</th>\s*<td>|<td class="wrgEDITI">|gs;
             $html =~ s|<th[^>]*>ISBN</th>\s*<td>|<td class="wrgISBN">|gs;
        }

        return $html;
    }
    
    sub getSearchUrl
      {
        my ($self, $word) = @_;
        my $bubu;
        if ($self->{searchField} eq 'isbn')
          {
            $bubu = "7";
            $self->{searchISBN} = $word;
          }
        else
          {
            $bubu = "4";
            $self->{searchISBN} = "";
          }
        $searchURL = "http://www.nukat.edu.pl/cgi-bin/gw_43_3/chameleon?host=193.0.118.2%2b1111%2bDEFAULT&search=KEYWORD&function=INITREQ&conf=.%2fchameleon.conf&lng=pl&u1=".$bubu."&t1=".$word;
        return $searchURL;
      }

    sub getItemUrl
    {
        my ($self, $url) = @_;
        return $url if $url;
        return 'http://www.nukat.edu.pl/';
    }

    sub getName
    {
        return "NUKat";
    }
    
    sub getCharset
    {
        my $self = shift;
        return "UTF-8";
        #return "ISO-8859-2";
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
