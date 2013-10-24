package GCPlugins::GCgames::GCAlapage;

###################################################
#
#  Copyright 2005-2011 Christian Jodar
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

use GCPlugins::GCgames::GCgamesCommon;

{
    package GCPlugins::GCgames::GCPluginAlapage;

    use base 'GCPlugins::GCgames::GCgamesPluginsBase';

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
            if (($tagname eq 'div') && ($attr->{class} eq 'infosProduit'))
            {
                $self->{itemIdx}++;
                $self->{isGame} = 1 ;
            }
            elsif (($tagname eq 'a') && ($self->{isGame}))
            {
                $self->{itemsList}[$self->{itemIdx}]->{url} = $attr->{href};
                $self->{itemsList}[$self->{itemIdx}]->{name} = $attr->{title};
                $self->{isGame} = 0 ;
            }
            elsif (($tagname eq 'span') && ($attr->{class} eq 'liensAriane') && ($self->{isGame}) && ($self->{itemsList}[$self->{itemIdx}]->{platform} eq ''))
            {
                $self->{isPlatform} = 1 ;
            }
        }
        elsif ($self->{parsingTips})
        {
        }
        else
        {

            if (($tagname eq 'h1') && ($attr->{id} eq 'zm_name_description'))
            {
                $self->{isName} = 1 ;
            }
            elsif (($tagname eq 'div') && ($attr->{id} eq 'zm_description_long'))
            {
                $self->{isDescription} = 1 ;
            }
            elsif (($tagname eq 'span') && ($attr->{rel} eq 'images nocount') && ($self->{bigPics}))
            {
                $self->{curInfo}->{boxpic} = $attr->{href_img} ;
            }
            elsif (($tagname eq 'img') && ($attr->{id} eq 'zm_main_image') && !($self->{bigPics}))
            {
                $self->{curInfo}->{boxpic} = $attr->{src} ;
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
            if ($self->{isPlatform})
            {
                # Enleve les blancs en debut de chaine
                $origtext =~ s/^\s+//;
                # Enleve les blancs en fin de chaine
                $origtext =~ s/\s+$//;

                $origtext =~ s/Sony //i;
                $origtext =~ s/Jeux PC/PC/i;

                $self->{itemsList}[$self->{itemIdx}]->{platform} = $origtext;
                $self->{Save_plateforme} = $self->{itemsList}[$self->{itemIdx}]->{platform};
                $self->{isPlatform} = 0;

            }
        }
        elsif ($self->{parsingTips})
        {
        }
        else
        {
            # Enleve les blancs en debut de chaine
            $origtext =~ s/^\s+//;
            if ($self->{isName})
            {
                $self->{curInfo}->{name} = $origtext;
                $self->{curInfo}->{platform} = $self->{Save_plateforme};
                $self->{isName} = 0 ;

                if ($self->{ean} ne '')
                {
                   $self->{curInfo}->{ean} = $self->{ean};
                }

            }
            elsif ($self->{isDescription} eq 1)
            {
                # Enleve les blancs dans le texte
                $origtext =~ s/  / /g;
                $self->{curInfo}->{description} = $origtext;
                $self->{isDescription} = 0 ;
            }

        }
    } 

    sub getTipsUrl
    {
        my $self = shift;
        
        return ;

    }

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);

        $self->{hasField} = {
            name => 1,
            platform => 1,
            released => 0,
            genre => 0
        };

        $self->{isName} = 0;
        $self->{isGame} = 0;
        $self->{isPlatform} = 0;
        $self->{Save_plateforme} = '';
        $self->{isDescription} = 0;
        $self->{ean} = '';

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        if ($self->{parsingList})
        {
        }
        else
        {
            $html =~ s|<br>||gi;
            $html =~ s|<br />||gi;

            $html =~ s|<b>||gi;
            $html =~ s|</b>||gi;
            $html =~ s|<i>||gi;
            $html =~ s|</i>||gi;
            $html =~ s|<p>|\n|gi;
            $html =~ s|</p>||gi;
            $html =~ s|\x{92}|'|gi;
            $html =~ s|&#146;|'|gi;
            $html =~ s|&#149;|*|gi;
            $html =~ s|&#156;|oe|gi;
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

        if ($self->{searchField} eq 'ean')
        {
            $self->{ean} = $word;
        }
        else
        {
            $self->{ean} = '';
        }

        return 'http://search.alapage.com/search?a=8584451-0-0&s='.$word;
    }
    
    sub getItemUrl
    {
	my ($self, $url) = @_;

        return $url;
    }

    sub getName
    {
        return 'Alapage';
    }
    
    sub getCharset
    {
        my $self = shift;
        #return "UTF-8";
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
        return ['ean', 'name'];
    }

    sub getDefaultPictureSuffix
    {
        return '.jpg';
    }

}

1;
