package GCPlugins::GCgames::GCgamesAmazonCommon;

###################################################
#
#  Copyright 2005-2010 Tian
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
use GCPlugins::GCstar::GCAmazonCommon;

{
    package GCPlugins::GCgames::GCgamesAmazonPluginsBase;

    use base ('GCPlugins::GCgames::GCgamesPluginsBase', 'GCPlugins::GCstar::GCPluginAmazonCommon');

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
            if ( ($tagname eq 'div') && ($attr->{class} eq 'buying') && ($self->{isGame} ne 2) )
            {
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{url} = $self->{loadedUrl};
                $self->{isGame} = 2 ;
            }
            elsif ( ($tagname eq 'h1') && ($attr->{class} eq 'headerblocktitle') && ($self->{isGame} ne 2) )
            {
                $self->{isGame} = 1 ;
                $self->{isUrl} = 1 ;
            }
            elsif ( ($tagname eq 'td') && ($attr->{class} eq 'imageColumn') && ($self->{isGame} ne 2) )
            {
                $self->{isGame} = 1 ;
                $self->{isUrl} = 1 ;
            }
            elsif ( ($tagname eq 'a') && ($self->{isGame} eq 1) && ($self->{isUrl}) )
            {
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{url} = $attr->{href};
                $self->{isUrl} = 0 ;
            }
            elsif ( ($tagname eq 'span') && ($attr->{class} eq 'srTitle') && ($self->{isGame} eq 1) )
            {
                $self->{isName} = 1 ;
            }
            elsif ( ($tagname eq 'span') && ($attr->{class} eq 'binding') && ($self->{isGame} eq 1) )
            {
                $self->{isPlatform} = 1 ;
            }
            elsif ( ($tagname eq 'span') && ($attr->{class} eq 'avail') )
            {
                $self->{isGame} = 0 ;
            }
            elsif ( ($tagname eq 'div') && ($attr->{class} eq 'usedPrice') )
            {
                $self->{isGame} = 0 ;
            }
            elsif ( ($tagname eq 'input') && ($attr->{name} eq 'sdp-sai-asin') )
            {
                $self->{isCodeEAN} = 1 ;
            }
            elsif ( ($tagname eq 'a') && ($self->{isCodeEAN}))
            {
                $self->{SaveUrl} = $attr->{href};
                $self->{isCodeEAN} = 0 ;
            }
            elsif ( ($tagname eq 'b') && ($attr->{class} eq 'sans') )
            {
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{url} = $self->{SaveUrl};
            }
        }
        elsif ($self->{parsingTips})
        {
        }
        else
        {

            if ( ($tagname eq 'meta') && ($attr->{name} eq 'keywords') )
            {
                my ($name, $editor, @genre) = split(/,/,$attr->{content});
                $self->{curInfo}->{name} = $name;
                $self->{curInfo}->{editor} = $editor;
                my $element;
                foreach $element (@genre)
                {
                   $element =~ s/^\s+//;
                   if ( !($element =~ m/console/i) && !($element =~ m/cartouche/i) && !($element =~ m/video games/i) && !($element =~ /([0-9])/))
                   {
                      $self->{curInfo}->{genre} .= $element;
                      $self->{curInfo}->{genre} .= ",";
                   }
                }

                # Sur Amazon.com et amazon.co.jp je n ai pas reussi a trouver un critere pertinent pour la recherche des genres
                if (($self->{suffix} eq 'com') || ($self->{suffix} eq 'co.jp') )
                {
                   $self->{curInfo}->{genre} = '';
                }

                if ($self->{ean} ne '')
                {
                   $self->{curInfo}->{ean} = $self->{ean};
                }
            }
            elsif ($tagname eq 'tpfdateparution')
            {
                $self->{isDate} = 1 ;
            }
            elsif ($tagname eq 'tpfplateforme')
            {
                $self->{isPlatform} = 1 ;
            }
            elsif ($tagname eq 'tpfcouverture')
            {
                $self->{curInfo}->{boxpic} = $self->extractImage($attr);
            }
            elsif ($tagname eq 'tpfscreenshot1')
            {
                $self->{curInfo}->{screenshot1} = $self->extractImage($attr);
            }
            elsif ($tagname eq 'tpfscreenshot2')
            {
                $self->{curInfo}->{screenshot2} = $self->extractImage($attr);
            }
            elsif (($tagname eq 'tpfdescription') )
            {
                $self->{isDesc} = 1;
            }
            elsif ( ($tagname eq 'div') && ($attr->{class} eq 'bucket') && ($self->{isDesc} eq 1))
            {
                $self->{isDesc} = 0;
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
                $self->{itemsList}[$self->{itemIdx}]->{platform} = $self->transformPlatform($origtext);
                $self->{isPlatform} = 0;
            }
            elsif ($self->{isName})
            {
                $self->{itemsList}[$self->{itemIdx}]->{name} = $origtext;
                $self->{isName} = 0;
            }
        }
        elsif ($self->{parsingTips})
        {
        }
        else
        {
            # Enleve les blancs en debut de chaine
            $origtext =~ s/^\s+//;
            # Enleve les blancs en fin de chaine
            $origtext =~ s/\s+$//;

            if ($self->{isDate})
            {
                $self->{curInfo}->{released} = $origtext;
                $self->{isDate} = 0;
            }
            elsif ($self->{isPlatform})
            {
                if ($origtext ne '' )
                {
                   $self->{curInfo}->{platform} = $self->transformPlatform($origtext);
                   $self->{isPlatform} = 0;
                }
            }
            elsif (($self->{isDesc}) && ($origtext ne ""))
            {
                $self->{curInfo}->{description} .= $origtext ."\n";
            }
        }
    } 

    sub transformPlatform
    {
        my ($self, $platform) = @_;
        
        $platform =~ s/^([\w ]*)\W{2}.*$/$1/ms;
        $platform =~ s/SONY //i;
        if ($platform =~ m/windows/i)
        {
           $platform = 'PC';
        }
        return $platform;
    }

    sub getTipsUrl
    {
        my $self = shift;
        
        return;
    }

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);

        $self->{hasField} = {
            name => 1,
            platform => 1
        };

        $self->{isCodeEAN} = 0;
        $self->{SaveUrl} = '';
        $self->{isName} = 0;
        $self->{isGame} = 0;
        $self->{isUrl} = 0;
        $self->{isPlatform} = 0;
        $self->{isDate} = 0;
        $self->{isDesc} = 0;
        $self->{ean} = '';

        return $self;
    }

    sub getSearchUrl
    {
        my ($self, $word) = @_;

        if ($self->{searchField} eq 'ean')
        {
            $self->{ean} = $word;
            return "http://s1.amazon." . $self->{suffix} . "/exec/varzea/sdp/sai-condition/" . $word;
        }
        else
        {
            $self->{ean} = '';
        }

        return 'http://www.amazon.' . $self->{suffix} . '/gp/search/?redirect=true&search-alias=videogames&keywords=' .$word;
    }
    
    sub getItemUrl
    {
		my ($self, $url) = @_;
		
		return $url if $url;
        return 'http://www.amazon.' . $self->{suffix};
    }

    sub getName
    {
        return 'Amazon';
    }
    
    sub getAuthor
    {
        return 'TPF';
    }
    
    sub getLang
    {
        return 'FR';
    }

    sub getCharset
    {
        my $self = shift;
    
        return "ISO-8859-1";
    }

    sub getSearchFieldsArray
    {
        return ['ean', 'name'];
    }
}

1;
