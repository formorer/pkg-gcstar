package GCPlugins::GCbooks::GCbooksMareno;

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

{
    package GCPlugins::GCbooks::GCPluginMareno;

    use base qw(GCPlugins::GCbooks::GCbooksPluginsBase);
    use URI::Escape;

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;
		
        if ($self->{parsingList})
        {
          if ($tagname eq 'title') #od razu mamy wynik?
            {
                $self->{isBook} = 7;
            }

            if (($tagname eq 'table') && ($attr->{class} eq 'bookData'))
              {
                $self->{itemIdx}++;
                $self->{isBook} = 1;
              }
            if (($tagname eq 'a') && ($self->{isBook} == 1))
              {
                $self->{isUrl} = 1;
                $self->{itemsList}[$self->{itemIdx}]->{url} = "http://www.mareno.pl".$attr->{href};
                $self->{isUrl} = 0;
                $self->{isTitle} = 1;
              }
            if (($tagname eq 'div') && ($attr->{class} eq 'bookAuthor') && ($self->{isBook} == 1))
              {
                $self->{isAuthor} = 1;
                $self->{isFormat} = 1;
                $self->{isPublisher} = 1;
                $self->{isPublication} = 1;
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
             if (($tagname eq 'div') && ($attr->{id} eq 'wrgFORMAT'))
               {
                 $self->{isFormat} = 1;
               }
            if (($tagname eq 'div') && ($attr->{id} eq 'wrgDESCR'))
              {
                $self->{isDescription} = 1;
              }
            if (($tagname eq 'div') && ($attr->{id} eq 'wrgTITLE'))
              {
                $self->{isTitle} = 1;
              }
            if (($tagname eq 'div') && ($attr->{id} eq 'wrgAUTOR'))
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
            if (($tagname eq 'a') && ($attr->{href} =~ /okladki\/big/))
              {
                $self->{isCover} = 1;
                $self->{curInfo}->{cover} = "http://www.mareno.pl".$attr->{href};
                $self->{isCover} = 0;
              }
        }
    }


    sub end
    {
        my ($self, $tagname) = @_;

       if ($tagname eq 'table')
         {
           $self->{isBook} = 0;
         }
       if ($tagname eq 'div')
         {
           $self->{isAuthor} = 0;
         }

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
              $origtext =~ s|^\s*||gs;
              $origtext =~ s|\s*$||gs;
              if (($origtext ne '') && ($origtext !~ /wyszukiwanie/))
                {
                  $self->{isUrl} = 1;
                  $self->{itemIdx}++;
                  $self->{itemsList}[$self->{itemIdx}]->{url} = $searchURL;
                  $self->{isUrl} = 0;
                }
              $self->{isBook} = 0;
            }
          $origtext =~ s/^\s*//m;
          $origtext =~ s/\s*$//m;
          if ($self->{isAuthor} == 1)
            {
              my ($au, $fo, $pu, $pd);
              $origtext =~ m|(#\^#- [^#]+#\^#)?(okładka\s*[^,]+,\s*)?([^,]+,\s*)?(\d*)?|s;
              $au = $1;
              $fo = $2;
              $pu = $3;
              $pd = $4;
              $au =~ s|#\^#- ([^#]+)#\^#|$1|g;
              $self->{itemsList}[$self->{itemIdx}]->{authors} = $au;
              $self->{isAuthor} = 0;
              $fo =~ s|okładka\s*([^,]+),\s*|$1|g;
              $self->{itemsList}[$self->{itemIdx}]->{format} = $fo;
              $self->{isFormat} = 0;
              $pu =~ s|([^,]+),\s*|$1|g;
              $self->{itemsList}[$self->{itemIdx}]->{publisher} = $pu;
              $self->{isPublisher} = 0;
              $self->{itemsList}[$self->{itemIdx}]->{publication} = $pd;
              $self->{isPublication} = 0;
            }
          if ($self->{isTitle} == 1)
            {
              $self->{itemsList}[$self->{itemIdx}]->{title} = $origtext;
              $self->{isTitle} = 0;
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
            if ($self->{isAuthor} == 1)
            {
              $origtext =~ s|^\s*||;
              $origtext =~ s|\s*$||;
              if ($origtext ne '')
                {
                  if ($self->{curInfo}->{authors} ne '')
                    {
                      $self->{curInfo}->{authors} .= ",";
                    }
                  $self->{curInfo}->{authors} .= $origtext;
                }
              $self->{isAuthor} = 2;
            }
            if ($self->{isFormat} == 1)
            {
                $self->{curInfo}->{format} = $origtext;
                $self->{isFormat} = 0;
            }
            if ($self->{isDescription} == 1)
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
            $html =~ s/<\/?(b|strong)>//gi;
            $html =~ s|</?font[^>]*>||gi;
            $html =~ s|<br>|#\^#|gi;
            $html =~ s|<TABLE border="0">\s*<tr>\s*<td valign=top>\s*</td>|<table border="0" class="bookData">|gs;
            $html =~ s|<td valign=top align=center><a href="[^"]*" class="left-menulink">\s*<IMG SRC[^>]*></a></td>||gs;
            $html =~ s|<td valign=top align=left><A HREF([^>]*)>\s*|<a href$1>|gm;
            $html =~ s|</a>&nbsp;\s*|</a>\n<div class="bookAuthor">|gm;
            $html =~ s|</td></tr>|</div>|g;
          }
        else
          {
             $html =~ s/<\/?(i|br|strong)>//gi;

             $html =~ s|<h1>([^<]*)</h1>|<div id="wrgTITLE">$1</div>|s;
             $html =~ s|<h2><A(.*)</A></h2>|<div id="wrgAUTOR"><A$1</A></div>|s;
             $html =~ s|<span class=textsmall>\s*ISBN:\s*([\dX]*)\s*</span>|<div id="wrgISBN">$1</div>|s;
             $html =~ s|<span class=textsmall>\s*okładka:\s*([^,]*),?\s*(\d*)[^<]*</span>|<div id="wrgFORMAT">$1</div><div id="wrgPAGES">$2</div>|s;
             $html =~ s|<span class=textsmall>\s*wydawnictwo:\s*([^,]*),\s*(\d*)\s*</span>|<div id="wrgPUBLI">$1</div><div id="wrgPDATE">$2</div>|s;
             $html =~ s|opis produktu:\s*([^<]*)<hr>|<div id="wrgDESCR">$1</div><hr>|;
#             $html =~ s|<dt>Seria:</dt>$*\s*<dd>(.*)</dd>|<div id="wrgSERIA">$1</div>|;
#             $html =~ s|<dt>Wydanie:</dt><dd>(.*)</dd>|<div id="wrgEDITI">$1</div>|;
#             $html =~ s|<dt>Tłumaczenie:\s*</dt>$*\s*<dd>|<dd id="wrgTRANS">|;
          }

        return $html;
    }
    
    sub getSearchUrl
    {
        my ($self, $word) = @_;
        $searchURL = "http://www.mareno.pl/rezultat.php?tytul=".$word;
        return $searchURL;
    }
    
    sub getItemUrl
    {
        my ($self, $url) = @_;
        return $url if $url;
        return 'http://www.mareno.pl/';
    }

    sub getName
    {
        return "Mareno";
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
