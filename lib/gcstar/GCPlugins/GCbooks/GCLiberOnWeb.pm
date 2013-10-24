package GCPlugins::GCbooks::GCLiberOnWeb;

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
    package GCPlugins::GCbooks::GCPluginLiberOnWeb;

    use base qw(GCPlugins::GCbooks::GCbooksPluginsBase);
    use URI::Escape;

    use Encode;
    use HTML::Entities;

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {

            if (($tagname eq 'font') && ($attr->{color} eq '#E7E4D8') && ($attr->{face} eq 'Arial'))
            {
                $self->{itemIdx}++;
                $self->{isBook} = 1 ;
                $self->{isUrl} = 1 ;
                $self->{isAuthor} = 1 ;
            }
            elsif (($tagname eq 'font') && ($attr->{color} eq '#D90000') && ($attr->{size} eq '3') && ($self->{isBook}))
            {
                $self->{isAuthor} = 0 ;
                $self->{isTitle} = 1 ;
            }
            elsif (($tagname eq 'font') && ($attr->{color} eq '#FFFFFF') && ($attr->{size} eq '2') && ($attr->{face} eq 'Arial') && ($self->{isBook}))
            {
                $self->{isPublisher} = 1 ;
            }
            elsif (($tagname eq 'a') && ($attr->{href} =~ m|libro.asp|i) && ($self->{isBook}) && ($self->{isUrl}))
            {
                $self->{itemsList}[$self->{itemIdx}]->{url} = "http://www.liberonweb.com/asp/" . $attr->{href};
                $self->{isUrl} = 0 ;
            }
            elsif (($tagname eq 'font') && ($attr->{color} eq '#D90000') && ($attr->{size} eq '5') && ($self->{searchField} eq 'isbn'))
            {
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{url} = $self->{loadedUrl};
            }
        }
        else
        {
            if (($tagname eq 'font') && ($attr->{color} eq '#E7E4D8') && ($attr->{size} eq '4'))
            {
                $self->{isAuthor} = 1 ;
            }
            elsif (($tagname eq 'font') && ($attr->{color} eq '#D90000') && ($attr->{size} eq '5'))
            {
                $self->{isTitle} = 1 ;
            }
            elsif (($tagname eq 'font') && ($attr->{face} eq 'Arial') && ($attr->{size} eq '2'))
            {
                $self->{isGenre} = 1 ;
            }
            elsif (($tagname eq 'font') && ($attr->{face} eq 'Verdana, Arial, Helvetica') && ($attr->{size} eq '2') && ($attr->{color} eq ''))
            {
                $self->{isFormat} = 1 ;
            }
            elsif (($tagname eq 'font') && ($attr->{color} eq '#6F6948') && ($attr->{size} eq '4'))
            {
                $self->{isAnalyse} = 0 ;
                $self->{isDescription} = 1 ;
            }
            elsif ($tagname eq 'tpfserie')
            {
                $self->{isSerie} = 1 ;
            }
            elsif ($tagname eq 'tpfanalysecarac')
            {
                $self->{isSerie} = 0 ;
                $self->{isAnalyse} = 1 ;
            }
            elsif ($tagname eq 'tpffindesc')
            {
                $self->{isDescription} = 0 ;
            }
            elsif (($tagname eq 'tpfsautdeligne') && ($self->{isDescription}))
            {
                $self->{curInfo}->{description} .= "\n";
            }
            elsif (($tagname eq 'img') && ($attr->{src} =~ m|/images/books/|i))
            {
                $self->{curInfo}->{cover} = 'http://www.liberonweb.com/asp/' .$attr->{src};

                my $isbn = reverse($attr->{src});
                my $found = index($isbn,"/");
                if ( $found >= 0 )
                {
                   $isbn = substr($isbn, 0,$found);
                   $isbn = reverse($isbn);
                   $found = index($isbn,".");
                   if ( $found >= 0 )
                   {
                      $self->{curInfo}->{isbn} = substr($isbn, 0,$found);
                   }
                }
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
                $self->{itemsList}[$self->{itemIdx}]->{authors} = $origtext;
                $self->{isAuthor} = 0 ;
            }
            elsif ($self->{isPublisher})
            {
                if (($origtext =~ m/Collana:/i) && ($self->{itemsList}[$self->{itemIdx}]->{edition} eq ''))
                {
                   my @array = split(/-/,$origtext);
                   # Enleve les blancs en debut de chaine
                   $array[0] =~ s/^\s+//;
                   # Enleve les blancs en fin de chaine
                   $array[0] =~ s/\s+$//g;
                   $self->{itemsList}[$self->{itemIdx}]->{edition} = $array[0];
                }
                elsif (($origtext =~ m/Anno /i) && ($self->{itemsList}[$self->{itemIdx}]->{publication} eq ''))
                {
                   my $found = index($origtext,"Anno ");
                   if ( $found >= 0 )
                   {
                      $origtext = substr($origtext, $found +length('Anno '),length($origtext)- $found -length('Anno '));
                      my @array = split(/,/,$origtext);
                      $self->{itemsList}[$self->{itemIdx}]->{publication} = $array[0];
                      # Enleve les blancs en fin de chaine
                      $self->{itemsList}[$self->{itemIdx}]->{publication} =~ s/\s+$//g;
                   }
                }
                $self->{isPublisher} = 0 ;
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
            elsif ($self->{isGenre})
            {
                if ($origtext =~ m/Argomenti:/i)
                {
                   my @array = split(/:/,$origtext);
                   # Enleve les blancs en debut de chaine
                   $array[1] =~ s/^\s+//;
                   $array[1] =~ s|, |,|gi;
                   $self->{curInfo}->{genre} = $array[1];
                }
                $self->{isGenre} = 0 ;
            }
            elsif ($self->{isFormat})
            {
                if ($origtext =~ m/Caratteristiche:/i)
                {
                   my @array = split(/:/,$origtext);
                   # Enleve les blancs en debut de chaine
                   $array[1] =~ s/^\s+//;
                   $self->{curInfo}->{format} = $array[1];
                }
                $self->{isFormat} = 0 ;
            }
            elsif ($self->{isAuthor})
            {
                my @array = split(/-/,$origtext);
                my $element;

                foreach $element (@array)
                {
                   my @array = split(/\(/,$element);
                   # Enleve les blancs en debut de chaine
                   $array[0] =~ s/^\s+//;
                   # Enleve les blancs en fin de chaine
                   $array[0] =~ s/\s+$//;

                   if ($array[0] ne '')
                   {
                      $self->{curInfo}->{authors} .= $array[0];
                      $self->{curInfo}->{authors} .= ",";
                   }
                }

                $self->{isAuthor} = 0 ;
            }
            elsif ($self->{isSerie})
            {
                if ($origtext =~ m/Collana:/i)
                {
                   my @array = split(/:/,$origtext);
                   # Enleve les blancs en debut de chaine
                   $array[1] =~ s/^\s+//;
                   $self->{curInfo}->{serie} = $array[1];
                }
                elsif (($origtext ne '') && ($self->{curInfo}->{serie} eq ''))
                {
                   $self->{curInfo}->{publisher} = $origtext;
                }
            }
            elsif ($self->{isAnalyse})
            {

                   my @array = split(/ - /,$origtext);
                   my $element;

                   foreach $element (@array)
                   {
                      # Enleve les blancs en debut de chaine
                      $element =~ s/^\s+//;
                      # Enleve les blancs en fin de chaine
                      $element =~ s/\s+$//;

                      if ($element =~ m/Pagine/i)
                      {
                         $element =~ s/Pagine //i;
                         $element =~ s/-/,/i;
                         my @array2 = split(/,/,$element);
                         if ($array2[1] eq '')
                         {
                            $self->{curInfo}->{pages} = $array2[0];
                         }
                         else
                         {
                            $self->{curInfo}->{pages} = $array2[1];
                         }
                         # Enleve les blancs en debut de chaine
                         $self->{curInfo}->{pages} =~ s/^\s+//;
                         # Enleve les blancs en fin de chaine
                         $self->{curInfo}->{pages} =~ s/\s+$//;
                      }
                      elsif ($element =~ m/Anno/i)
                      {
                         my @array2 = split(/ /,$element);
                         $self->{curInfo}->{publication} = $array2[1];
                      }
                   }

            }
            elsif ($self->{isDescription})
            {
                if ($origtext ne '')
                {
                   $self->{curInfo}->{description} .= $origtext;
                   $self->{curInfo}->{description} .= "\n";
                }
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

        $self->{isTitle} = 0;
        $self->{isBook} = 0;
        $self->{isUrl} = 0;
        $self->{isAuthor} = 0;
        $self->{isSerie} = 0;
        $self->{isGenre} = 0;
        $self->{isFormat} = 0;
        $self->{isDescription} = 0;

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
            $html =~ s|\n||gi;
            $html =~ s|\r||gi;
            $html =~ s|\t||gi;

            $html =~ s|<li>|\n* |gi;
            $html =~ s|<br>|<tpfsautdeligne>|gi;
            $html =~ s|<br />|<tpfsautdeligne>|gi;
            $html =~ s|<br clear=all>|<tpfsautdeligne>|gi;
            $html =~ s|<b>||gi;
            $html =~ s|</b>||gi;
            $html =~ s|<!--Visualizzazione delle Note del libro-->|<tpfanalysecarac>|gi;
            $html =~ s|<!--Visualizzazione dell'Editore e della Collana-->|<tpfserie>|gi;
            $html =~ s|<font face=Verdana, Arial, Helvetica size=2>|<font face="Verdana, Arial, Helvetica" size=2>|gi;
            $html =~ s|<!--mstheme-->|<tpffindesc>|gi;
            $html =~ s|<i>||gi;
            $html =~ s|</i>||gi;
            $html =~ s|<p>|\n|gi;
            $html =~ s|</p>||gi;
            $html =~ s|\x{92}|'|g;
            $html =~ s|&#146;|'|gi;
            $html =~ s|&#149;|*|gi;
        }
        
        return $html;
    }
    
    sub getSearchUrl
    {
		my ($self, $word) = @_;
	
        if ($self->{searchField} eq 'isbn')
        {
           return "http://www.liberonweb.com/asp/libro.asp?ISBN=" . $word;
        }
        else
        {
            return "http://www.liberonweb.com/asp/lista.asp?D1=Titolo&T1=" . $word. "&I1=1";
        }

    }
    
    sub getItemUrl
    {
		my ($self, $url) = @_;
		
        return $url;
    }

    sub getName
    {
        return "LiberOnWeb";
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
        return 'IT';
    }

    sub getSearchFieldsArray
    {
        return ['isbn', 'title'];
    }

}

1;
