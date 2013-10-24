package GCPlugins::GCfilms::GCAllocine;

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

use GCPlugins::GCfilms::GCfilmsCommon;

{

    package GCPlugins::GCfilms::GCPluginAllocine;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
            if ($self->{insideResults} eq 1)
            {
                if (   ($tagname eq "a")
                    && ($attr->{href} =~ /^\/film\/fichefilm_gen_cfilm=/)
                    && ($self->{isMovie} eq 0))
                {
                    my $url = $attr->{href};
                    $self->{isMovie} = 1;
                    $self->{isInfo}  = 0;
                    $self->{itemIdx}++;
                    $self->{itemsList}[ $self->{itemIdx} ]->{url} = $url;
                }
                elsif (($tagname eq "td") && ($self->{isMovie} eq 1))
                {
                    $self->{isMovie} = 2;
                }
                elsif (($tagname eq "a") && ($self->{isMovie} eq 2))
                {
                    $self->{isMovie} = 3;
                }
                elsif (($tagname eq "br") && ($self->{isMovie} eq 3))
                {
                    $self->{itemsList}[ $self->{itemIdx} ]->{title} =~ s/^\s*//;
                    $self->{itemsList}[ $self->{itemIdx} ]->{title} =~ s/\s*$//;
                    $self->{itemsList}[ $self->{itemIdx} ]->{title} =~ s/\s+/ /g;
                    $self->{isMovie} = 4;
                }
                elsif (($tagname eq "span")
                    && ($attr->{class}   eq "fs11")
                    && ($self->{isMovie} eq 4))
                {
                    $self->{isInfo}  = 1;
                    $self->{isMovie} = 0;
                }
                elsif (($tagname eq "br") && ($self->{isInfo} eq 1))
                {
                    $self->{isInfo} = 2;
                }
                elsif (($tagname eq "br") && ($self->{isInfo} eq 2))
                {
                    $self->{isInfo} = 3;
                }
            }
        }
        else
        {
		if (($tagname eq "div") && ($attr->{class} eq "poster"))
            	{
                	$self->{insidePicture} = 1;
            	}
		elsif (($tagname eq "img") && ($self->{insidePicture} eq 1))
		{
                	my $src = $attr->{src};
                	if (!$self->{curInfo}->{image})
                	{
                        if ($src =~ /r_160_240/)
                    		{
                        	$self->{curInfo}->{image} = $src;
				}
                    	else
                    		{
                        	$self->{curInfo}->{image} = "empty";
                    		}
			}
                }
            	elsif ($tagname eq "h1")
        	{
        		$self->{insideTitle} = 1;
        	}
		elsif (($tagname eq "span") && ($self->{insideDate} eq 1))
        	{
        	        $self->{insideDate} = 2;
        	}
		elsif (($tagname eq "span") && ($attr->{itemprop} eq "duration"))
            	{
                	$self->{insideTime} = 1;
            	}
		elsif (($tagname eq "span") && ($self->{insideDirector} eq 1))
            	{
                	$self->{insideDirector} = 2;
            	}
		elsif (($tagname eq "a") && ($self->{insideActor} eq 1))
            	{
                	$self->{insideActor} = 2;
            	}
		elsif (($tagname eq "span") && ($self->{insideGenre} eq 1))
            	{
                	$self->{insideGenre} = 2;
            	}
		elsif (($tagname eq "span") && ($self->{insideCountry} eq 1))
            	{
                	$self->{insideCountry} = 2;
            	}
		elsif (($tagname eq "span") && ($attr->{class} eq "note") && ($self->{insidePressRating} eq 1))
            	{
            		$self->{insidePressRating} = 2;
            	}
	    	elsif (($tagname eq "div") && ($attr->{class} eq "breaker"))
	    	{
	    		$self->{insidePressRating} = 0;
	    	}
		elsif (($tagname eq "p") && ($attr->{itemprop} eq "description"))
            	{
                	$self->{insideSynopsis} = 1;
            	}
		elsif (($tagname eq "td") && ($self->{insideOriginal} eq 1))
            	{
                	$self->{insideOriginal} = 2;
            	}    

        }
    }

    sub end
    {
        my ($self, $tagname) = @_;
        $self->{inside}->{$tagname}--;

	if ($tagname eq "li")
        {
        	$self->{insideDirector} = 0;
		$self->{insideActor} = 0;
		$self->{insideGenre} = 0;
        }
	elsif ($tagname eq "div") 
        {
           	$self->{insideCountry} = 0;
		$self->{insideSynopsis} = 0;
		$self->{insideActor} = 0;
        }
	elsif ($tagname eq "th")
        {
           $self->{insideSynopsis} = 0;
        }
	elsif ($tagname eq "table")
        {
            $self->{insideResults} = 0;
        }
	
    }

    sub text
    {
        my ($self, $origtext) = @_;

        if ($self->{parsingList})
        {
            if (($origtext =~ m/(\d+) r..?sultats? trouv..?s? dans les titres de films/) && ($1 > 0))
            {
                $self->{insideResults} = 1;
            }
            if ($self->{isMovie} eq 3)
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{title} .= $origtext;
            }
            if ($self->{isInfo} eq 1)
            {
                if ($origtext =~ /\s*([0-9]{4})/)
                {
                    $self->{itemsList}[ $self->{itemIdx} ]->{date} = $1;
                }
            }
            elsif ($self->{isInfo} eq 2)
            {
                if ($origtext =~ /^\s*de (.*)/)
                {
                    $self->{itemsList}[ $self->{itemIdx} ]->{director} = $1;
                }
            }
            elsif ($self->{isInfo} eq 3)
            {
                if (   ($origtext =~ m/^\s*avec (.*)/)
                    && (!$self->{itemsList}[ $self->{itemIdx} ]->{actors}))
                {
                    $self->{itemsList}[ $self->{itemIdx} ]->{actors} = $1;
                }
                $self->{isInfo} = 0;
            }
        }
        else
        {
		my ($self, $origtext) = @_;
		$origtext =~ s/[\r\n]//g;
	        $origtext =~ s/^\s*//;
	        $origtext =~ s/\s*$//;
	
		if ($self->{insideTitle} eq 1)	
		{
			$self->{curInfo}->{title} = $origtext;
			$self->{insideTitle} = 0;
		}	
		elsif (($self->{insideDate} eq 2) && (length($origtext) > 1))
	        {
	               	$self->{curInfo}->{date} = $origtext
	               	if !($origtext =~ /inconnu/);
	               	$self->{insideDate} = 0;
	        }
	        elsif (($origtext =~ /^Date de sortie/)
	        && (!$self->{curInfo}->{date}))
	        {
	        	$self->{insideDate} = 1;
	        }
	        elsif (($origtext =~ /^Date de reprise/)
	        && (!$self->{curInfo}->{date}))
	        {
	        	$self->{insideDate} = 1;
	        }
		elsif ($self->{insideTime} eq 1)
		{
			$origtext =~ /(\d+)h\s*(\d+)m/;
			my $time = ($1*60) + $2;
			$self->{curInfo}->{time} = $time." m.";
			$self->{insideTime} = 0;
		}
		elsif ($self->{insideDirector} eq 2)
                {
                    $origtext = ", " if $origtext =~ m/^,/;
                    $self->{curInfo}->{director} .= $origtext;
                }
                elsif ($origtext =~ /^R..?alis..? par/)
                {
                    $self->{insideDirector} = 1;
                }
		elsif ($self->{insideActor} eq 2)
                {
		    $origtext =~ s/plus//;
                    $origtext = "," if $origtext =~ m/^,/;
                    $self->{curInfo}->{actors} .= $origtext;
                }
                elsif ($origtext =~ /^Avec/)
                {
                    $self->{insideActor} = 1;
                }
		elsif ($self->{insideGenre} eq 2)
                {
                    $origtext = "," if $origtext =~ m/^,/;
                    $self->{curInfo}->{genre} .= $origtext;
		}
                elsif ($origtext =~ /^[\s\n]*Genre/)
                {
                    $self->{insideGenre}   = 1;
                }
		elsif ($self->{insideCountry} eq 2)
                {
                       $origtext = "," if $origtext =~ m/^,/;
                       $self->{curInfo}->{country} .= $origtext;
                }
                elsif ($origtext =~ /Nationalité/)
                {
                    $self->{insideCountry} = 1;
                }
		elsif ($origtext =~ /^Presse$/)
                {
                    $self->{insidePressRating} = 1;
                }
                elsif ($self->{insidePressRating} eq 2)
                {
                $origtext =~ s/,/./;
		$self->{curInfo}->{ratingpress} .= $origtext * 2;
		}
		elsif ($origtext =~ /^Interdit aux moins de (\d+) ans/)
                {
                $self->{curInfo}->{age} = $1;
                }
		elsif ($self->{insideSynopsis} eq 1)
                {
                   $self->{curInfo}->{synopsis} .= $origtext;		    
                }
		elsif ($self->{insideOriginal} eq 2)
                {
                    $self->{curInfo}->{original} = $origtext;
                    $self->{insideOriginal} = 0;
                }
                elsif ($origtext =~ /^Titre original/)
                {
                    $self->{insideOriginal} = 1;
                }
		
		
            
        }
    }

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();

        $self->{hasField} = {
            title    => 1,
            date     => 1,
            director => 1,
            actors   => 1,
        };

        $self->{isInfo}        = 0;
        $self->{isMovie}       = 0;
        $self->{insideResults} = 0;
        $self->{curName}       = undef;
        $self->{curUrl}        = undef;
        $self->{actorsCounter} = 0;

        bless($self, $class);
        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;
        
        return $html;
    }

    sub getSearchUrl
    {
        my ($self, $word) = @_;

        # f=3 ?
        # return "http://www.allocine.fr/recherche/?q=$word&f=3&rub=1";
        return "http://www.allocine.fr/recherche/1/?q=$word";
    }

    sub getSearchCharset
    {
        my $self = shift;

        # Need urls to be double character encoded
        return "utf8";
    }

    sub getItemUrl
    {
        my ($self, $url) = @_;

        return "http://www.allocine.fr" . $url;
    }

    sub getName
    {
        return "Allocine.fr";
    }

    sub getAuthor
    {
        return 'Tian';
    }

    sub getLang
    {
        return 'FR';
    }
    
    sub getCharset
    {
        # return "UTF-8"; # For 1.5.0 Win32
        return "ISO-8859-1"; # For 1.5.0 Win32 with /lib/gcstar/GCPlugins/ ver.1.5.9svn
    }
}

1;
