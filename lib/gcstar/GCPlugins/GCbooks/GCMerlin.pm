package GCPlugins::GCbooks::GCbooksMerlin;

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

{
    package GCPlugins::GCbooks::GCPluginMerlin;

    use base qw(GCPlugins::GCbooks::GCbooksPluginsBase);
    use URI::Escape;

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;
		
        if ($self->{parsingList})
        {
            if (($tagname eq 'li') && ($attr->{class} eq 'tytul'))
              {
                $self->{isBook} = 1;
                $self->{isUrl} = 1;
                $self->{itemIdx}++;
              }
            if (($tagname eq 'li') && ($attr->{class} eq 'wydawca'))
              {
                $self->{isPublisher} = 1;
              }
            if (($tagname eq 'a')
             && ($self->{isUrl} eq '1'))
            {
                $self->{itemsList}[$self->{itemIdx}]->{url} = "http://www.merlin.com.pl".$attr->{href};
                $self->{isUrl} = 0;
            }
        }
        else
        {
             if (($tagname eq 'div') && ($attr->{id} eq 'wrgISBN'))
               {
                 $self->{isISBN} = 1;
               }
             if (($tagname eq 'div') && ($attr->{id} eq 'wrgPAGES'))
               {
                 $self->{isPage} = 1;
               }
             if (($tagname eq 'div') && ($attr->{id} eq 'wrgPUBLI'))
               {
                   $self->{isPublisher} = 1;
               }
             if (($tagname eq 'div') && ($attr->{id} eq 'wrgPDATE'))
               {
                   $self->{isPublication} = 1;
               }
             if (($tagname eq 'div') && ($attr->{id} eq 'wrgSERIA'))
               {
                 $self->{isSerie} = 2;
               }
            if (($tagname eq 'a') && ($self->{isSerie} eq '2'))
              {
                $self->{isSerie} = 1;
              }
             if (($tagname eq 'div') && ($attr->{id} eq 'wrgEDITI'))
               {
                 $self->{isEdition} = 1;
               }
             if (($tagname eq 'div') && ($attr->{id} eq 'prodHead'))
               {
                 $self->{isCover} = 2;
                 $self->{isTitle} = 2;
                 $self->{isFormat} = 2;
               }
            if (($tagname eq 'h1') && ($attr->{class} eq 'prodTitle') && ($self->{isTitle} eq '2'))
              {
                $self->{isTitle} = 1;
              }
            if (($tagname eq 'h2') && ($attr->{class} eq 'prodPerson'))
              {
                $self->{isAuthor} = 2;
              }
            if ($tagname eq 'a')
              {
                if ($self->{isAuthor} eq '1')
                  {
                    $self->{isAuthor} = 2;
                  }
                elsif ($self->{isAuthor} eq '2')
                  {
                    $self->{isAuthor} = 1;
                  }
              }
             if (($tagname eq 'dd') && ($attr->{id} eq 'wrgTRANS'))
               {
                 $self->{isTranslator} = 2;
               }
             if ($tagname eq 'a')
               {
                 if ($self->{isTranslator} eq '1')
                   {
                     $self->{isTranslator} = 2;
                   }
                 elsif ($self->{isTranslator} eq '2')
                   {
                     $self->{isTranslator} = 1;
                   }
               }
            if (($tagname eq 'div') && ($attr->{id} eq 'prodImg') && ($self->{isCover} eq '2'))
              {
                $self->{isCover} = 1;
              }
            if (($tagname eq 'img') && ($self->{isCover} eq '1'))
              {
                $self->{curInfo}->{cover} = "http://www.merlin.com.pl".$attr->{src};
                $self->{isCover} = 0;
              }
            if (($tagname eq 'div') && ($attr->{class} eq 'prodFeatureSpec') && ($self->{isFormat} eq '2'))
              {
                $self->{isFormat} = 1;
              }
            if (($tagname eq 'div') && ($attr->{class} eq 'productDesc'))
              {
                $self->{isDescription} = 1;
              }
        }
    }


    sub end
    {
        my ($self, $tagname) = @_;

       if ($tagname eq 'h2')
         {
           $self->{isAuthor} = 0;
         }
       if ($tagname eq 'dd')
         {
           $self->{isTranslator} = 0;
         }

        $self->{isFound} = 0;
        $self->{inside}->{$tagname}--;
    }

    sub text
    {
        my ($self, $origtext) = @_;

        if ($self->{parsingList})
        {
            if ($self->{isBook} eq '1')
            {
              $origtext =~ s/^\s*//m;
              $origtext =~ s/\s*$//m;
              $self->{isBook} = 0;
              if ($self->{inside}->{a})
                {
                  $self->{itemsList}[$self->{itemIdx}]->{title} = $origtext;
                  $self->{isBook} = 1;
                }
              else
                {
                  $self->{itemsList}[$self->{itemIdx}]->{authors} = $origtext;
                }
            }
          if ($self->{isPublisher} eq '1')
            {
              $origtext =~ s/^\s*//m;
              $origtext =~ s/\s*$//m;
              $self->{itemsList}[$self->{itemIdx}]->{edition} = $origtext;
              $self->{isPublisher} = 0;
            }

        }
        else
        {
            $origtext =~ s/^\s*//m;
            $origtext =~ s/\s*$//m;

            if ($self->{isTitle} eq '1')
            {
                $self->{curInfo}->{title} = $origtext;
                $self->{isTitle} = 0;
            }
            if ($self->{isAuthor} eq '1')
            {
              $origtext =~ s|^\s*||;
              $origtext =~ s|\s*$||;
              if ($origtext ne '')
                {
                  $self->{curInfo}->{authors} .= $origtext;
                }
              $self->{isAuthor} = 2;
            }
            if ($self->{isTranslator} eq '1')
            {
              $origtext =~ s|^\s*||;
              $origtext =~ s|\s*$||;
              if ($self->{curInfo}->{translator} eq '')
                {
                  $self->{curInfo}->{translator} = $origtext;
                }
              else
                {
                  $self->{curInfo}->{translator} .= ", ".$origtext;
                }
              $self->{isTranslator} = 2;
            }
            if ($self->{isFormat} eq '1')
            {
                $origtext =~ s|okładka: ||m;
                $self->{curInfo}->{format} = $origtext;
                $self->{isFormat} = 0;
            }
            if ($self->{isDescription} eq '1')
              {
                $self->{curInfo}->{description} = $origtext;
                $self->{isDescription} = 0;
              }
            
              if ($self->{isISBN} eq '1')
                {
                  $self->{curInfo}->{isbn} = $origtext;
                  $self->{isISBN} = 0;
                }
              if ($self->{isPage} eq '1')
                {
                  $self->{curInfo}->{pages} = $origtext;
                  $self->{isPage} = 0;
                }
              if ($self->{isEdition} eq '1')
                {
                  $self->{curInfo}->{edition} = $origtext;
                  $self->{isEdition} = 0;
                }
              if ($self->{isPublisher} eq '1')
                {
                  $self->{curInfo}->{publisher} = $origtext;
                  $self->{isPublisher} = 0;
                }
              if ($self->{isPublication} eq '1')
                {
                  $origtext =~ s|(\S*)\s*(\S{4})|$2|;
                  $self->{curInfo}->{publication} = $origtext;
                  $self->{isPublication} = 0;
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
        $self->{actorsCounter} = 0;

        if ($self->{parsingList})
        {
            $html =~ s|<b>(.*?)</b>|$1|gms;
            $html =~ s|<li class="tytul">(.*)</li>\s*<li>|<li class="tytul">$1</li><li class="wydawca">|gm;
        }
        else
        {
             $html =~ s|</?strong>||gi;
             $html =~ s|</?i>||gi;
             $html =~ s|</?br>||gi;
             $html =~ s|<dfn>(.*?)</dfn>||gs;

             $html =~ s|<dt>ISBN:</dt><dd>(.*)</dd>|<div id="wrgISBN">$1</div>|;
             $html =~ s|<dt>Liczba stron:</dt><dd>(.*)</dd>|<div id="wrgPAGES">$1</div>|;
             $html =~ s|<dt>Seria:</dt>\s*<dd>(.*)</dd>|<div id="wrgSERIA">$1</div>|m;
             $html =~ s|<dt>Wydanie:</dt><dd>(.*)</dd>|<div id="wrgEDITI">$1</div>|;
             $html =~ s|<dt>Wydawnictwo:</dt>\s*<dd>\s*(.*)\s*,*\s*(.*)\s*</dd>|<div id="wrgPUBLI">$1</div><div id="wrgPDATE">$2</div>|m;
             $html =~ s|<dt>Tłumaczenie:\s*</dt>\s*<dd>|<dd id="wrgTRANS">|m;
        }

        return $html;
    }
    
    sub getSearchUrl
    {
	my ($self, $word) = @_;
        return "http://www.merlin.com.pl/frontend/browse/search/1.html?phrase=$word";
    }
    
    sub getItemUrl
    {
        my ($self, $url) = @_;
        return $url if $url;
        return 'http://www.merlin.com.pl/';
    }

    sub getName
    {
        return "Merlin";
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
