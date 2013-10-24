package GCPlugins::GCfilms::GCAnimeNfoA;

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

use GCPlugins::GCfilms::GCfilmsCommon;

{

    package GCPlugins::GCfilms::GCPluginAnimeNfoA;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;

        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
            if ($tagname eq "a")
            {
                if ($attr->{href} =~ m/animetitle,[0-9]*,[a-z]*,[a-z0-9_]*\.html/)
                {
                    $self->{isMovie} = 1;
                    $self->{isInfo}  = 1;
                    $self->{itemIdx}++;
                    $self->{itemsList}[ $self->{itemIdx} ]->{url} = $attr->{href};
                }
            }
            elsif ($tagname eq "td")
            {
                if ($attr->{class} eq "anime_info")
                {
                    $self->{couldBeYear} = 1;
                }
            }
        }
        else
        {
            if ($tagname eq 'table')
            {
                if ($attr->{class} eq 'anime_info')
                {
                    $self->{insideInfos} = 1;
                }
            }
            elsif ($tagname eq 'img')
            {
                if ($attr->{class} eq 'float')
                {
                    $self->{curInfo}->{image} = 'http://www.animenfo.com/' . $attr->{src};
                }
            }
            elsif ($tagname eq 'a')
            {
                if ($attr->{href} =~ /animebygenre\.php\?genre=/)
                {
                    $self->{insideGenre} = 1;
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

        return if (length($origtext) < 2) && ($origtext !~ /\d+$/);

        if ($self->{parsingList})
        {
            if ($self->{isMovie})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{"title"} = $origtext;
                $self->{isMovie}                                  = 0;
                $self->{isInfo}                                   = 1;
                return;
            }
            elsif ($self->{couldBeYear})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{date} = $origtext if $origtext =~ m/^[0-9]{4}$/;
                $self->{couldBeYear} = 0;
                return;
            }
        }
        else
        {
            if ($self->{insideInfos})
            {
                if ($origtext eq "Title")
                {
                    $self->{insideName} = 1;
                }
                elsif ($origtext eq "Japanese Title")
                {
                    $self->{insideOrig} = 1;
                }
                elsif ($origtext eq "Total Episodes")
                {
                    $self->{insideTime} = 1;
                }
                elsif ($origtext eq "Year Published")
                {
                    $self->{insideDate} = 1;
                }
                elsif ($origtext eq "Director")
                {
                    $self->{insideDirector} = 1;
                }
                elsif ($origtext eq "User Rating")
                {
                    $self->{insideRating} = 1;
                }
                elsif ($origtext =~ m/Description/)
                {
                    $self->{insideSynopsis} = 1;
                }
                elsif ($self->{insideName})
                {
                    $self->{curInfo}->{title} = $origtext;
                    $self->{insideName} = 0;
                }
                elsif ($self->{insideOrig})
                {
                    $self->{curInfo}->{original} = $origtext if $origtext ne "Official Site";
                    $self->{insideOrig} = 0;
                }
                elsif ($self->{insideTime})
                {
                    $origtext =~ s/^(\d+)\s*(.*)/$1 episodes $2/;
                    $self->{curInfo}->{time} .= $origtext;
                    $self->{insideTime} = 0;
                }
                elsif ($self->{insideGenre})
                {
                    $self->{curInfo}->{genre} .= $origtext . ',';
                    $self->{insideGenre} = 0;
                }
                elsif ($self->{insideDate})
                {
                    $self->{curInfo}->{date} = $origtext if $origtext =~ m/[0-9]{4}/;
                    $self->{insideDate} = 0;
                }
                elsif ($self->{insideDirector})
                {
                    $self->{curInfo}->{director} = $origtext if $origtext ne "US Distribution";
                    $self->{insideDirector} = 0;
                }
                elsif ($self->{insideRating})
                {
                    $origtext =~ m|([\d\.]+)/10\.0|;
                    $self->{curInfo}->{ratingpress} = int ($1 + 0.5);
                    $self->{insideRating} = 0;
                }
                elsif ($self->{insideSynopsis})
                {
                    $self->{curInfo}->{synopsis} = $origtext if !$self->{curInfo}->{synopsis};
                    $self->{insideSynopsis} = 0;
                }
            }
        }
    }

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless($self, $class);

        $self->{hasField} = {
            title    => 1,
            date     => 1,
            director => 0,
            actors   => 0,
        };

        $self->{isInfo}  = 0;
        $self->{isMovie} = 0;
        $self->{curName} = undef;
        $self->{curUrl}  = undef;

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        $html =~ s/<br \/>/\n/g;
        $html =~ s/<script language='JavaScript'>.*?<\/script>//g;
        $html =~ s|<i>([^<]*)</i>|$1|g;
        $html =~ s|\t||g;
        $html =~ s/<a onMouseOut='[^']*' onMouseOver='[^']*' href='animebygenre\.php\?genre=[0-9]*'>([^<]*)<\/a>/$1/g;
        $html =~ s/<a href='animebyyear\.php\?year=[0-9]{4}'>([0-9]{4})<\/a>/<font class='DefaultFont'>$1<\/font>/;

        return $html;
    }

    sub getSearchUrl
    {
        my ($self, $word) = @_;

        return "http://www.animenfo.com/search.php?option=keywords&queryin=anime_titles&query=$word";
    }

    sub getItemUrl
    {
        my ($self, $url) = @_;

        return 'http://www.animenfo.com/' . $url;
    }

    sub getName
    {
        return "AnimeNfo Anime";
    }

    sub getAuthor
    {
        return 'MeV';
    }

    sub getLang
    {
        return 'EN';
    }

    sub getNotConverted
    {
        my $self = shift;
        return ['orig'];
    }
}

1;
