package GCPlugins::GCgames::GCJeuxVideoCom;

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
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
###################################################

use strict;
use utf8;

use GCPlugins::GCgames::GCgamesCommon;

{
    package GCPlugins::GCgames::GCPluginJeuxVideoCom;

    use base 'GCPlugins::GCgames::GCgamesPluginsBase';

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
        $self->{inside}->{$tagname}++;
        return if $self->{parsingEnded};
        if ($self->{parsingList})
        {
            if (($tagname eq 'div') && (($attr->{id} eq 'new_mc') || ($attr->{id} eq 'old_mc')))
            {
                $self->{inResults} = 1;
            }
            elsif ($self->{inResults})
            {
                if ($tagname eq 'img')
                {
                    $self->{currentPlatform} = $attr->{alt};
                }
                elsif (($tagname eq 'a') && ($attr->{href} =~ /^http/))
                {
                    $self->{itemIdx}++;
                    $self->{itemsList}[$self->{itemIdx}]->{url} = $attr->{href};
                    $self->{itemsList}[$self->{itemIdx}]->{platform} = $self->{currentPlatform};
                    $self->{isGame} = 1;
                }
            }
        }
        else
        {
            if (($tagname eq 'meta') && ($attr->{property} eq 'og:image'))
            {
                my $cover = $attr->{content};
                $cover =~ s|(http://[^/]*)/([^i])|$1/images/$2|;
                if ($self->{bigPics})
                {
                    $cover =~ s/-p(-|\.)/-g$1/;
                    $cover =~ s/t(\.jpg)/$1/;
                }
                my $back = $cover;
                if (!($back =~ s/-avant(-|\.)/-arriere$1/))
                {
                    $back =~ s/f(t?\.jpg)/r$1/;
                }
                $self->{curInfo}->{boxpic} = $cover;
                $self->{curInfo}->{backpic} = $back;
		print "GOT : ",$cover," AND ",$back,"\n";
            }
            elsif (($tagname eq 'li') && ($attr->{class} eq 'note_redac'))
            {
                 $self->{is} = 'ratingpress';
            }
            elsif ( ($tagname eq 'div') && ($attr->{class} eq 'series_images') )
            {
                    $self->{inScreenshots} = 1;
            }
            elsif ( ($tagname eq 'img') && ($self->{inScreenshots}) )
            {
                if (! $self->{curInfo}->{screenshot1})
                {
                    $self->{curInfo}->{screenshot1} = $attr->{src};
                    $self->{curInfo}->{screenshot1} =~ s/.gif/.jpg/;
                }
                elsif (! $self->{curInfo}->{screenshot2})
                {
                    $self->{curInfo}->{screenshot2} = $attr->{src};
                    $self->{curInfo}->{screenshot2} =~ s/.gif/.jpg/;
                    $self->{isScreen} = 0;
                }
            }
        }
    }

    sub end
    {
        my ($self, $tagname) = @_;
		
        $self->{inside}->{$tagname}--;
        return if $self->{parsingEnded};
        if ($self->{parsingList})
        {
            if ($tagname eq 'div')
            {
                $self->{inResults} = 0;
            }
        }
    }

    sub text
    {
        my ($self, $origtext) = @_;

        return if $self->{parsingEnded};
        if ($self->{parsingList})
        {
            if ($self->{isGame})
            {
                $self->{itemsList}[$self->{itemIdx}]->{name} = $origtext;
                $self->{isGame} = 0;
            }
        }
        else
        {
            if ($self->{inside}->{h1})
            {
                if ($self->{inside}->{a})
                {
                    $self->{curInfo}->{name} = $origtext;
                }
                elsif ($self->{inside}->{span})
                {
                    if ($origtext !~ /^Fiche /)
                    {
                        $origtext =~ s/^\s*-?\s*//;
                        $self->{curInfo}->{platform} = $origtext;
                    }
                }
            }
            elsif ($self->{inside}->{strong})
            {
                $self->{is} = 'released' if ($origtext =~ /Sortie :/) || ($origtext =~ /Sortie France :/);
                $self->{is} = 'genre' if $origtext =~ /Type :/;
                $self->{is} = 'description' if $origtext =~ /Descriptif :/;
                $self->{is} = 'editor' if $origtext =~ /Editeur :/;
                $self->{is} = 'developer' if $origtext =~ /D.*?veloppeur :/;
                $self->{is} = 'players' if $origtext =~ /Multijoueurs :/;
                $self->{curInfo}->{exclusive} = 'false' if $origtext =~ /Existe aussi sur :/;
            }
            elsif ($self->{is})
            {
                $origtext =~ s/^\s*//;
                $origtext =~ s/\n$//;
                if ($origtext)
                {
                    if ($self->{is} eq 'players')
                    {
                        $origtext =~ s/-/1/;
                        $origtext =~ s/non/1/i;
                        $origtext =~ s/oui/Multijoueurs/i;
                    }
                    if ($self->{is} eq 'ratingpress')
                    {
                        $origtext =~ m|(\d*)/20|;
                        $origtext = int($1 / 2);
                    }                
                    $self->{curInfo}->{$self->{is}} = $origtext;
                    $self->{is} = '';
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
            name => 1,
            platform => 1
        };

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;
        if ($self->{parsingList})
        {
            $self->{parsingEnded} = 0;
            $self->{inResults} = 0;
            $self->{isGame} = 0;
        }
        else
        {
            $self->{is} = '';
            $self->{curInfo}->{exclusive} = 'true';
            $self->{inScreenshots} = 0;
        }
        return $html;
    }
    
    sub getSearchUrl
    {
        my ($self, $word) = @_;
        $word =~ s/\+/ /g;
        return 'http://www.jeuxvideo.com/recherche/jeux/'.$word.'.htm';
    }
    
    sub getItemUrl
    {
        my ($self, $url) = @_;
		
        return $url if $url;
        return 'http://www.jeuxvideo.com/';
    }

    sub getName
    {
        return 'jeuxvideo.com';
    }
    
    sub getAuthor
    {
        return 'Tian & TPF';
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
    sub isPreferred
    {
        return 1;
    }
}

1;
