package GCPlugins::GCbooks::GCBol;

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
    package GCPlugins::GCbooks::GCPluginBol;

    use base qw(GCPlugins::GCbooks::GCbooksPluginsBase);
    use URI::Escape;

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
        	if ($tagname eq 'td')
            {
            	if($self->{bookStep} == 0)
            	{
            		$self->{bookStep} = 1 ;	
            	}
            }
            elsif ($tagname eq 'img')
            {
            	if($self->{bookStep} == 1)
            	{
            		$self->{bookStep} = 2;	
            	}
            }
            elsif ($tagname eq 'a')
            {
            	if($self->{bookStep}==2)
            	{
            		$self->{url} = "http://www.bol.it" . $attr->{href};
                	$self->{bookStep} = 3 ;
                	$self->{isTitle} = 1 ;
            	}
            	elsif($self->{bookStep}==3)
            	{
                	$self->{bookStep} = 4 ;
                	$self->{isAuthor} = 1 ;
            	}
            }
            elsif ($tagname eq 'br')
            {
            	if($self->{bookStep}==4)
            	{
                	$self->{isBook} = 1;
            		$self->{itemIdx}++;
                	$self->{itemsList}[$self->{itemIdx}]->{url} = $self->{url};
                	$self->{itemsList}[$self->{itemIdx}]->{title} = $self->{title};
                	$self->{itemsList}[$self->{itemIdx}]->{authors} = $self->{author};
                
                	$self->{isFormat} = 1 ;
                	#$self->{bookStep} = 0 ;
            	}
            }
            elsif (
            		(($tagname ne 'h3') || ( ($tagname eq 'h3') && ($self->{bookStep} != 2) )) &&
            	    (($tagname ne 'p') || ( ($tagname eq 'p') && ($self->{bookStep} != 3) ))  &&
            	    (($tagname ne 'span') || ( ($tagname eq 'span') && ($self->{bookStep} != 4) ))
            	  )
            {	
            	$self->{isTitle} = 0;
        		$self->{isAuthor} = 0;
        		$self->{isAnalyse} = 0;
        		$self->{isDescription} = 0;
        		$self->{isTranslator} = 0;
        		$self->{isCover} = 0;
        		$self->{isGenre} = 0;
        		$self->{isFormat} = 0;
        		$self->{isPage} = 0;
        		$self->{isLanguage} = 0;
        		$self->{isPublisher} = 0;
        		$self->{isPublication} = 0;
        		$self->{isISBN} = 0;
        
       	 		$self->{isBook} = 0;
        		$self->{bookStep} = 0;
            }
        }
        else
        {
        	if (($tagname eq 'img') && ($attr->{class} eq 'cover'))
            {
                $self->{curInfo}->{cover} = "http://www.bol.it" . $attr->{src};
                $self->{bookStep} = 1;
            }
            elsif (($tagname eq 'h1') && ($self->{bookStep} == 1))
            {
                $self->{curInfo}->{title} = "http://www.bol.it" . $attr->{src};
                $self->{isTitle} = 1;
                $self->{bookStep} = 2;
            }
            elsif ($self->{bookStep} == 2)
            {
            	if (($tagname eq 'a') && ($self->{areAuthors} == 0))
            	{
            		$self->{isAuthor} = 1;
            		$self->{areAuthors} = 1;
            	}
            	if ($self->{areAuthors} == 1)
            	{
            		if ($tagname eq 'a')
            		{
            			$self->{isAuthor} = 1;
            		}
            		else
            		{
            			$self->{bookStep} = 3;
            			$self->{areAuthors} = 0;
            		}
            	}
            }
            elsif ($self->{bookStep} == 4)
            {
            	if (($tagname eq 'a') && ($self->{areGenres} == 0))
            	{
            		$self->{isGenre} = 1;
            		$self->{areGenres} = 1;
            	}
            	if ($self->{areGenres} == 1)
            	{
            		if ($tagname eq 'a')
            		{
            			$self->{isGenre} = 1;
            		}
            		else
            		{
            			$self->{bookStep} = 5;
            			$self->{areGenres} = 0;
            		}
            	}
            }
            elsif ($self->{bookStep} == 6)
            {
            	if (($tagname eq 'a') && ($self->{areTranslators} == 0))
            	{
            		$self->{isTranslator} = 1;
            		$self->{areTranslators} = 1;
            	}
            	if ($self->{areTranslators} == 1)
            	{
            		if ($tagname eq 'a')
            		{
            			$self->{isTranslator} = 1;
            		}
            		else
            		{
            			$self->{bookStep} = 6;
            			$self->{areTranslators} = 0;
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
                $self->{title} = $origtext;
                $self->{isTitle} = 0;
            }
            elsif ($self->{isAuthor})
            {
                $self->{author} = $origtext;
                $self->{isAuthor} = 0;
            }
            elsif ($self->{isFormat})
            {
            	my @array = split(/\|/,$origtext);

                $self->{itemsList}[$self->{itemIdx}]->{format} = $array[0];
                $self->{itemsList}[$self->{itemIdx}]->{format} =~ s/^\s+//;
                $self->{isFormat} = 0;
                $self->{isPublisher} = 1;
            }
            elsif ($self->{isPublisher})
            {
            	$self->{itemsList}[$self->{itemIdx}]->{edition} = $origtext;
            	$self->{isPublisher} = 0;
            	$self->{isPublication} = 1;
            }
            elsif ($self->{isPublication})
            {
            	my @array = split(/\|/,$origtext);
            	
            	$self->{itemsList}[$self->{itemIdx}]->{publication} = $array[1];
                $self->{itemsList}[$self->{itemIdx}]->{publication} =~ s/^\s+//;
                $self->{isPublication} = 0;
            }
        }
       	else
        {
            # Enleve les blancs en debut de chaine
            $origtext =~ s/^\s+//;
            # Enleve les blancs en fin de chaine
            $origtext =~ s/\s+$//g;
            
            if ($origtext eq 'I contenuti')
            {
            	$self->{isDescription} = 1;
            }
            elsif ($origtext eq 'Formato:')
            {
            	$self->{isFormat} = 1; 
            }
            elsif (substr($origtext,0,7) eq 'Pagine:')
            {
            	$self->{isPage} = 1;
            }
            elsif ($origtext eq 'Lingua:')
            {
            	$self->{isLanguage} = 1;
            }
            elsif ($origtext eq 'Editore:')
            {
            	$self->{isPublisher} = 1;
            }
            elsif ($origtext eq 'Anno di pubblicazione')
            {
            	$self->{isPublication} = 1;
            }
            elsif ($origtext eq 'Codice EAN:')
            {
            	$self->{isISBN} = 1;
            }
            elsif (($origtext eq 'Traduttore:') || ($origtext eq 'Traduttori:'))
            {
            	$self->{bookStep} = 6;
            }
            elsif ($origtext eq 'Generi:')
            {
            	$self->{bookStep} = 4;
            }
            elsif ($origtext ne '')
            {
            	if ($self->{isTitle})
            	{
            		$self->{curInfo}->{title} = $origtext;
                	$self->{isTitle} = 0 ;
            	}
            	elsif ($self->{isAuthor})
            	{
            		if ($self->{curInfo}->{authors} eq '')
                	{
                   		$self->{curInfo}->{authors} = $origtext;
                	}
                	else
                	{
                   		$self->{curInfo}->{authors} .= ", " . $origtext;
                	}
                	$self->{isAuthor} = 0 ;
            	}
            	elsif ($self->{isDescription})
            	{
            		$self->{curInfo}->{description} = $origtext;
                	$self->{isDescription} = 0 ;
            	}
            	elsif ($self->{isFormat})
            	{
            		$self->{curInfo}->{format} = $origtext;
            		$self->{isFormat} = 0;
            	}
            	elsif ($self->{isPage})
            	{
            		$self->{curInfo}->{pages} = $origtext;
            		$self->{isPage} = 0;
            	}
            	elsif ($self->{isLanguage})
            	{
            		$self->{curInfo}->{language} = $origtext;
            		$self->{isLanguage} = 0;
            	}
            	elsif ($self->{isPublisher})
            	{
            		$self->{curInfo}->{publisher} = $origtext;
            		$self->{isPublisher} = 0;
            	}
            	elsif ($self->{isPublication})
            	{
            		$self->{curInfo}->{publication} = $origtext;
            		$self->{isPublication} = 0;
            	}
            	elsif ($self->{isISBN})
            	{
            		$self->{curInfo}->{isbn} = $origtext;
            		$self->{isISBN} = 0;
            	}
            	elsif ($self->{isGenre})
            	{
            		if ($self->{curInfo}->{genre} eq '')
                	{
                   		$self->{curInfo}->{genre} = $origtext;
                	}
                	else
                	{
                   		$self->{curInfo}->{genre} .= ", " . $origtext;
                	}
                	$self->{isGenre} = 0 ;
            	}
            	elsif ($self->{isTranslator})
            	{
            		if ($self->{curInfo}->{translator} eq '')
                	{
                   		$self->{curInfo}->{translator} = $origtext;
                	}
                	else
                	{
                   		$self->{curInfo}->{translator} .= ", " . $origtext;
                	}
                	$self->{isTranslator} = 0 ;
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
            format => 1,
            edition => 1,
            serie => 0,
        };

        $self->{isTitle} = 0;
        $self->{isAuthor} = 0;
        $self->{isAnalyse} = 0;
        $self->{isDescription} = 0;
        $self->{isTranslator} = 0;
        $self->{isCover} = 0;
        $self->{isGenre} = 0;
        $self->{isFormat} = 0;
        $self->{isPage} = 0;
        $self->{isLanguage} = 0;
        $self->{isPublisher} = 0;
        $self->{isPublication} = 0;
        $self->{isISBN} = 0;
        $self->{areAuthors} = 0;
        $self->{areGenres} = 0;
        $self->{areTranslators} = 0;
        
        $self->{isBook} = 0;
        $self->{bookStep} = 0;
        $self->{title} = 0;
        $self->{author} = 0;

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        if ($self->{parsingList})
        {
            $html =~ s|<br><i>|<i>|gi;
            #$html =~ s/[\n\r\t]//g;
        }
        else
        {
            my $found = index($html,'<a name="commenti">');
            if ( $found >= 0 )
            {
               $html = substr($html, 0, $found);
            }

            $html =~ s|<u>||gi;
            $html =~ s|<li>|\n* |gi;
            #$html =~ s|<br>|\n|gi;
            #$html =~ s|<br />|\n|gi;
            #$html =~ s|<b>||gi;
            #$html =~ s|</b>||gi;
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
           return ('http://www.bol.it/libri/ricerca', ["crc" => "100", "crcselect" => "100", "g" => "$word", "tpr" => "10"] );
        }
        else
        {
           $word =~ s/\+/ /g;
           return ('http://www.bol.it/libri/ricerca', ["crc" => "100", "crcselect" => "100", "g" => "$word", "tpr" => "10"] );
        }

    }
    
    sub getItemUrl
    {
		my ($self, $url) = @_;
		
        return $url if $url;
        return 'http://www.bol.it';
    }

    sub getName
    {
        return "Bol";
    }
    
    sub getCharset
    {
        my $self = shift;
        return "ISO-8859-15";
    }

    sub getAuthor
    {
        return 'TPF, UnclePetros';
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
