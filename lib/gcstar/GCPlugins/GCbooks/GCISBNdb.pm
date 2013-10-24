package GCPlugins::GCbooks::GCISBNdb;

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
    package GCPlugins::GCbooks::GCPluginISBNdb;

    use base qw(GCPlugins::GCbooks::GCbooksPluginsBase);
    use URI::Escape;

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {

            if (($tagname eq 'div') && ($attr->{class} eq 'bookInfo') && ($self->{searchField} ne 'isbn'))
            {
                $self->{isBook} = 1 ;
            }
            elsif (($tagname eq 'a') && ( index($attr->{href},"/d/book/") >= 0) && ($self->{isBook}))
            {
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{url} = "http://isbndb.com" . $attr->{href};
                $self->{isTitle} = 1 ;
            }
            elsif (($tagname eq 'a') && ( index($attr->{href},"/d/person/") >= 0) && ($self->{isBook}))
            {
                $self->{isAuthor} = 1 ;
            }
            elsif (($tagname eq 'a') && ( index($attr->{href},"/d/publisher/") >= 0) && ($self->{isBook}))
            {
                $self->{isPublisher} = 1 ;
            }
            elsif (($tagname eq 'a') && ( index($attr->{onclick},"isbndbTrackBuy") >= 0) && ($self->{itemIdx} eq '-1'))
            {
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{url} = $self->{loadedUrl} ;
            }
            elsif (($tagname eq 'span') && ($attr->{class} eq 'inactive'))
            {
                $self->{isBook} = 0 ;
            }
        }
        else
        {
            if ($tagname eq 'title')
            {
                $self->{isTitle} = 1 ;
            }
            elsif (($tagname eq 'a') && ( index($attr->{href},"/d/person/") >= 0))
            {
                $self->{isAuthor} = 1 ;
            }
            elsif (($tagname eq 'a') && ( index($attr->{href},"/d/publisher/") >= 0))
            {
                $self->{isPublisher} = 1 ;
            }
            elsif (($tagname eq 'a') && ( index($attr->{href},"/c/Library_Shelves/Dewey") >= 0))
            {
                $self->{isGenre} = 1 ;
            }
            elsif ($tagname eq 'h2')
            {
                $self->{isAnalyse} = 1 ;
            }
            elsif (($tagname eq 'iframe') && ($self->{curInfo}->{cover} eq ''))
            {
                my $html = $self->loadPage( $attr->{src}, 0, 1 );
                my $found = index($html,"<img src=\"");
                if ( $found >= 0 )
                {
                   $html = substr($html, $found +length('<img src="'),length($html)- $found -length('<img src="'));

                   my @array = split(/"/,$html);
                   $self->{curInfo}->{cover} = $array[0];
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
            elsif ($self->{isPublisher})
            {
                $self->{itemsList}[$self->{itemIdx}]->{edition} = $origtext;
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
            elsif ($self->{isAuthor})
            {
                $self->{curInfo}->{authors} .= $origtext;
                $self->{curInfo}->{authors} .= ",";
                $self->{isAuthor} = 0 ;
            }
            elsif ($self->{isPublisher})
            {
                $self->{curInfo}->{publisher} = $origtext;
                $self->{isPublisher} = 0 ;
            }
            elsif ($self->{isAnalyse})
            {
                $self->{isFormat} = 1 if ($origtext =~ m/Book Details:/i);
                $self->{isDescription} = 1 if ($origtext =~ m/Notes:/i);
                $self->{isDescription} = 1 if ($origtext =~ m/Summary:/i);

                $self->{isAnalyse} = 0 ;
            }
            elsif ($self->{isFormat})
            {
                my @array = split(/\n/,$origtext);
                my @array2;
                my @array3;
                my $element;
                my $element2;
                foreach $element (@array)
                {
                   @array2 = split(/:/,$element);
                   # Enleve les blancs en debut de chaine
                   $array2[1] =~ s/^\s+//;
                   # Enleve les blancs en fin de chaine
                   $array2[1] =~ s/\s+$//g;
                   if ($array2[0] =~ m/Language/i)
                   {
                      $self->{curInfo}->{language} = $array2[1];
                   }
                   elsif ($array2[0] =~ m/Physical Description/i)
                   {
                      @array3 = split(/;/,$array2[1]);
                      foreach $element2 (@array3)
                      {
                         # Enleve les blancs en debut de chaine
                         $element2 =~ s/^\s+//;
                         $_= $element2;
                         if (/(^[0-9]+)(\s[p])(.*)/)
                         {
                            $self->{curInfo}->{pages} = $1;
                         }
                         elsif (/(.*)(\s)([0-9]+)(\s[p])(.*)/)
                         {
                            $self->{curInfo}->{pages} = $3;
                         }
                      }
                   }
                   elsif ($array2[0] =~ m/Edition Info/i)
                   {
                      @array3 = split(/;/,$array2[1]);
                      $self->{curInfo}->{format} = $array3[0];
                      $_= $array3[1];
                      if (/(.*)([0-9][0-9][0-9][0-9])(.*)/)
                      {
                         $self->{curInfo}->{publication} = $array3[1];
                         # Enleve les blancs en debut de chaine
                         $self->{curInfo}->{publication} =~ s/^\s+//;
                      }
                   }
                }
                $self->{isFormat} = 0 ;
            }
            elsif ($self->{isDescription})
            {
                $origtext =~ s/\n\n/\n/g;
                $self->{curInfo}->{description} = $origtext;
                $self->{isDescription} = 0 ;
            }
            elsif ($self->{isGenre})
            {
                 my @array = split(/--/,$origtext);

                 $self->{curInfo}->{genre} = $array[1];
                 # Enleve les blancs en debut de chaine
                 $self->{curInfo}->{genre} =~ s/^\s+//;
                 $self->{isGenre} = 0 ;
            }
            elsif (($origtext =~ m/ISBN:/i) && ($self->{curInfo}->{isbn} eq ''))
            {
                my @array = split(/:/,$origtext);

                # Enleve les blancs en debut de chaine
                $array[1] =~ s/^\s+//;
                # Enleve les blancs en fin de chaine
                $array[1] =~ s/\s+$//g;
                my @array2 = split(/ /,$array[1]);

                $self->{curInfo}->{isbn} = $array2[0];
                # Enleve les blancs en debut de chaine
                $self->{curInfo}->{isbn} =~ s/^\s+//;
                # Enleve les blancs en fin de chaine
                $self->{curInfo}->{isbn} =~ s/\s+$//g;
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
            serie => 0,
        };

        $self->{isBook} = 0;
        $self->{isTitle} = 0;
        $self->{isAuthor} = 0;
        $self->{isAnalyse} = 0;
        $self->{isDescription} = 0;
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
        }
        else
        {
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
            $html =~ s|\x{8C}|OE|gi;
            $html =~ s|\x{9C}|oe|gi;

        }
        
        return $html;
    }
    
    sub getSearchUrl
    {
		my ($self, $word) = @_;
	
        if ($self->{searchField} eq 'isbn')
        {
           return "http://isbndb.com/search-all.html?kw=" .$word;
        }
        else
        {
           return "http://isbndb.com/search-title.html?kw=" .$word ."&isn=";
        }

    }
    
    sub getItemUrl
    {
		my ($self, $url) = @_;
		
        return $url;
    }

    sub getName
    {
        return "ISBNdb";
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
        return 'EN';
    }

    sub getSearchFieldsArray
    {
        return ['isbn', 'title'];
    }
}

1;
