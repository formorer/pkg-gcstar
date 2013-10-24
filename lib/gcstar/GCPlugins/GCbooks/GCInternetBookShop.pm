package GCPlugins::GCbooks::GCInternetBookShop;

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
    package GCPlugins::GCbooks::GCPluginInternetBookShop;

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
            		$self->{url} = $attr->{href} ;
                	$self->{bookStep} = 3 ;
                	$self->{isTitle} = 1 ;
            	}
            }
            elsif (($tagname eq 'br') && ($self->{bookStep}==3))
            {
                $self->{bookStep} = 4 ;
                $self->{isAuthor} = 1 ;
            }
            elsif (($tagname eq 'i') && ($self->{bookStep}==4))
            {
            	$self->{isBook} = 1;
            	$self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{url} = $self->{url};
                $self->{itemsList}[$self->{itemIdx}]->{title} = $self->{title};
                
                if ($self->{itemsList}[$self->{itemIdx}]->{authors} eq '' )
                {
                   my @fields = split /,/, $self->{authorAndYear};
                   $self->{itemsList}[$self->{itemIdx}]->{authors} = $fields[0];
                }
                $self->{isPublisher} = 1;
            }
            elsif ($tagname ne 'b')
            {	
            	$self->{bookStep} = 0;
            	$self->{url} = '';
            	$self->{isBook} = 0;
                $self->{isUrl} = 0;
                $self->{isTitle} = 0;
                $self->{isAuthor} = 0;
                $self->{isPublisher} = 0;
                $self->{isPage} = 0;
                $self->{isSerie} = 0;
                $self->{isTranslator} = 0;
                $self->{isDescription} = 0;
            }
        }
        else
        {   
        	if (($tagname eq 'input') && ( $attr->{name} eq 'isbn') && ($self->{curInfo}->{isbn} eq ''))
            {
                $self->{curInfo}->{isbn} = $attr->{value} ;
            }
            elsif (($tagname eq 'img') && ($attr->{src} =~ m/$self->{curInfo}->{isbn}/i) && ($attr->{src} =~ m/cop/i))
            {
                $self->{curInfo}->{cover} = $attr->{src};
            }
            elsif ($self->{bookStep} == 1)
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
            			$self->{bookStep} = 2;
            			$self->{areAuthors} = 0;
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
                $self->{isTitle} = 0 ;
            }
            elsif ($self->{isAuthor})
            {
				$self->{authorAndYear} = $origtext;
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
            if ($origtext eq 'Titolo')
            {
            	$self->{isTitle} = 1;
            }
            elsif ($origtext eq 'Autore')
            {
            	$self->{bookStep} = 1;
            }
            elsif ($origtext eq 'Dati')
            {
            	$self->{isPage} = 1;
            }
            elsif ($origtext eq 'Editore')
            {
            	$self->{isPublisher} = 1;
            }
            elsif ($origtext eq 'Traduttore')
            {
            	$self->{isTranslator} = 1;
            }
            elsif ($origtext eq '(collana')
            {
            	$self->{isSerie} = 1;
            }
            elsif ($origtext eq 'Descrizione')
            {
            	$self->{isDescription} = 1;
            }
            else
            {
            	if ($self->{isTitle})
            	{
            		$self->{curInfo}->{title} = $origtext;
                	$self->{isTitle} = 0;
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
            	elsif ($self->{isPage})
            	{
                	my @array = split(/,/,$origtext);

                	$self->{curInfo}->{publication} = $array[0];
                	$self->{curInfo}->{pages} = $array[1];
                	# Enleve les blancs en debut de chaine
                	$self->{curInfo}->{pages} =~ s/^\s+//;
                	$self->{curInfo}->{pages} =~ s/p.//;
                	if ($array[3] ne '')
                	{
                   		$self->{curInfo}->{format} = $array[2] . "," .$array[3];
                	}
                	else
                	{
                   		$self->{curInfo}->{format} = $array[2];
                	}
                	# Enleve les blancs en debut de chaine
                	$self->{curInfo}->{format} =~ s/^\s+//;

                	$self->{isPage} = 0 ;
            	}
            	elsif ($self->{isPublisher})
            	{
                	$self->{curInfo}->{publisher} = $origtext;
                	$self->{isPublisher} = 0 ;
            	}
            	elsif ($self->{isTranslator})
            	{
                	$self->{curInfo}->{translator} = $origtext;
                	$self->{isTranslator} = 0 ;
            	}
            	elsif ($self->{isDescription})
            	{
                	$self->{curInfo}->{description} .= $origtext;
                	$self->{isDescription} = 0 ;
            	}
            	elsif ($self->{isSerie})
            	{
                	$self->{curInfo}->{serie} = $origtext;
                	$self->{isSerie} = 0 ;
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
            publication => 0,
            format => 0,
            edition => 1,
        };

        $self->{isBook} = 0;
        $self->{isUrl} = 0;
        $self->{isTitle} = 0;
        $self->{isAuthor} = 0;
        $self->{isPublisher} = 0;
        $self->{isPage} = 0;
        $self->{isSerie} = 0;
        $self->{isTranslator} = 0;
        $self->{isDescription} = 0;
        $self->{areAuthors} = 0;
        
        $self->{bookStep} = 0;
        $self->{url} = '';
        $self->{authorAndYear} = '';
        $self->{title} = '';
        

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        if ($self->{parsingList})
        {
            $html =~ s|<br><i>|<i>|gi;
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
            $html =~ s|<br>|\n|gi;
            $html =~ s|<br />|\n|gi;
            $html =~ s|<b>||gi;
            $html =~ s|</b>||gi;
            $html =~ s|<i>||gi;
            $html =~ s|</i>||gi;
            $html =~ s|<p>|\n|gi;
            $html =~ s|</p>||gi;
            $html =~ s|</h4>||gi;
            $html =~ s|\x{92}|'|g;
            $html =~ s|&#146;|'|gi;
            $html =~ s|&#149;|*|gi;
            $html =~ s|<center>||gi;
            $html =~ s|</center>||gi;
            $html =~ s|</embed>||gi;
            $html =~ s|</object>||gi;

        }
        
        return $html;
    }
    
    sub getSearchUrl
    {
		my ($self, $word) = @_;
		
		return "http://www.internetbookshop.it/ser/serpge.asp?type=keyword&x=".$word;
    }
    
    sub getItemUrl
    {
		my ($self, $url) = @_;
        return $url if $url;
        return 'http://www.internetbookshop.it/';
    }

    sub getName
    {
        return "InternetBookShop";
    }
    
    sub getCharset
    {
        my $self = shift;
        return "ISO-8859-1";
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
        return ['title'];
    }
}

1;
