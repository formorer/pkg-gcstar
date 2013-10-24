package GCPlugins::GCboardgames::GCboardgamegeek;

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

use GCPlugins::GCboardgames::GCboardgamesCommon;

{
    package GCPlugins::GCboardgames::GCPluginboardgamegeek;
    
    use base qw(GCPlugins::GCboardgames::GCboardgamesPluginsBase);
    use XML::Simple;
    use HTML::Entities;
    use Encode;

    sub parse
    {
        my ($self, $page) = @_;
        return if $page =~ /^<!DOCTYPE html/;
        my $xml;
        my $xs = XML::Simple->new;

        if ($self->{parsingList})
        {
            $xml = $xs->XMLin($page, ForceArray => ['boardgame'], KeyAttr => ['objectid']);
            my $game;
            foreach $game ( keys( %{ $xml -> {'boardgame'}} ) )
            {
                 $self->{itemIdx}++;
                 $self->{itemsList}[$self->{itemIdx}]->{url} = "http://www.boardgamegeek.com/xmlapi/boardgame/".$game;
                 # Better check how the name is returned, the bgg api can be a little funny here
                 if (ref($xml->{'boardgame'}->{$game}->{'name'})) 
                 {
                    $self->{itemsList}[$self->{itemIdx}]->{name} = $xml->{'boardgame'}->{$game}->{'name'}->{'content'};
                 }
                 else
                 {
                    $self->{itemsList}[$self->{itemIdx}]->{name} = $xml->{'boardgame'}->{$game}->{'name'};
                 }   
                 
                 if (!ref($xml->{'boardgame'}->{$game}->{'yearpublished'}))
                 {
                      $self->{itemsList}[$self->{itemIdx}]->{released} = $xml->{'boardgame'}->{$game}->{'yearpublished'};
                 }
            }
        }
        else
        {
            $xml = $xs->XMLin($page, ForceArray => ['name','boardgamedesigner','boardgameartist','boardgamepublisher',
                                                    'boardgamecategory','boardgamemechanic','boardgameexpansion'],
                                                    KeyAttr => []);

            $self->{curInfo}->{released} = $xml->{boardgame}->{yearpublished};
            $self->{curInfo}->{released} =~ s/([^0-9])//g;
            $self->{curInfo}->{players} = $xml->{boardgame}->{minplayers}."-".$xml->{boardgame}->{maxplayers};
            $self->{curInfo}->{playingtime} = $xml->{boardgame}->{playingtime}." mins";
            $self->{curInfo}->{suggestedage} = $xml->{boardgame}->{age};
            
            my $primaryName = "";
            for my $name (@{$xml->{boardgame}->{name}})
            {
                $primaryName = $name->{content}
                    if $name->{primary} eq "true";
            } 

            if (($primaryName ne $self->{itemsList}[$self->{wantedIdx}]->{name})
                && ($self->{itemsList}[$self->{wantedIdx}]->{name}))
            {
                # Name returned by boardgamegeek is different to the one the user selected
                # this means they choose an translated name, so use the name they choose
                # as the default, and put boardgamegeek's name in as the original (untranslated) name of the game
                $self->{curInfo}->{name} = $self->{itemsList}[$self->{wantedIdx}]->{name};   
                $self->{curInfo}->{original} = $primaryName;
            }
            else
            {
                $self->{curInfo}->{name} = $primaryName;
            }            
            
            # Have to decode the html type characters here
            $self->{curInfo}->{description} = decode_entities($xml->{boardgame}->{description});
            $self->{curInfo}->{description} =~ s/\<br\/>/\n/g;
            $self->{curInfo}->{description} =~ s/<.*?>//g;
            
            if ($self->{bigPics})
            {
                $self->{curInfo}->{boxpic} =  $xml->{boardgame}->{image};
            }
            else
            {
                $self->{curInfo}->{boxpic} =  $xml->{boardgame}->{thumbnail};            
            }
            
            for my $designer (@{$xml->{boardgame}->{boardgamedesigner}})
            {
                $self->{curInfo}->{designedby} .= $designer->{content}.', ';
            }     
            $self->{curInfo}->{designedby} =~ s/, $//;
            
            for my $artist (@{$xml->{boardgame}->{boardgameartist}})
            {
                $self->{curInfo}->{illustratedby} .= $artist->{content}.', ';
            }     
            $self->{curInfo}->{illustratedby} =~ s/, $//;
            
            for my $publisher (@{$xml->{boardgame}->{boardgamepublisher}})
            {
                $self->{curInfo}->{publishedby} .= $publisher->{content}.', ';
            }     
            $self->{curInfo}->{publishedby} =~ s/, $//;    
            
            for my $category (@{$xml->{boardgame}->{boardgamecategory}})
            {
                push @{$self->{curInfo}->{category}}, [$category->{content}];
            }                    

            for my $mechanic (@{$xml->{boardgame}->{boardgamemechanic}})
            {
                push @{$self->{curInfo}->{mechanics}}, [$mechanic->{content}];
            }    
            
            for my $expansion (@{$xml->{boardgame}->{boardgameexpansion}})
            {
                if ($expansion->{inbound})
                {
                    if ($self->{curInfo}->{expansionfor})
                    {
                        $self->{curInfo}->{expansionfor} .= ", ";
                    }
                    $self->{curInfo}->{expansionfor} .= $expansion->{content};
                }
                else
                {
                    push @{$self->{curInfo}->{expandedby}}, [$expansion->{content}];
                }
            }                         
            $self->{curInfo}->{web} = "http://boardgamegeek.com/boardgame/".$xml->{boardgame}->{objectid};
        }
    }

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);

        $self->{hasField} = {
            name => 1,
            released => 1,
        };

        return $self;
    }
    
    sub getItemUrl
    {
        my ($self, $url) = @_;
        
        if (!$url)
        {
            # If we're not passed a url, return a hint so that gcstar knows what type
            # of addresses this plugin handles
            $url = "http://www.boardgamegeek.com";
        }
        elsif (index($url,"xmlapi") < 0)
        {
            # Url isn't for the bgg api, so we need to find the game id
            # and return a url corresponding to the api page for this game       
            $url =~ /\/([0-9]+)[\/]*/;
            my $id = $1;
            $url = "http://www.boardgamegeek.com/xmlapi/boardgame/".$id;
        }
        return $url;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        return $html;
    }
    
    sub decodeEntitiesWanted
    {
        return 0;
    }

    sub getSearchUrl
    {
        my ($self, $word) = @_;
        # Quick and dirty fixes because the bgg api struggles with some words. Should not be required anymore (7/6/2010)
        # $word =~ s/the\+/\+/ig;
        # $word =~ s/\+and+/\+/g;
        # $word =~ s/\+of\+/\+/g;

        return "http://www.boardgamegeek.com/xmlapi/search?search=$word";
    }
    
    sub changeUrl
    {
        my ($self, $url) = @_;
        # Make sure the url is for the api, not the main movie page
        return $self->getItemUrl($url);
    }

    sub getName
    {
        return "Board Game Geek";
    }
    
    sub getAuthor
    {
        return 'Zombiepig';
    }

    sub isPreferred
    {
        return 1;
    }
    
    sub getLang
    {
        return 'EN';
    }

    sub getCharset
    {
        my $self = shift;
    
        return "UTF-8";
    }
    
    sub getSearchCharset
    {
        my $self = shift;
        
        # Need urls to be double character encoded
        return "utf8";
    }

    sub convertCharset
    {
        my ($self, $value) = @_;
        return $value;
    }

    sub getNotConverted
    {
        my $self = shift;
        return [];
    }

}

1;
