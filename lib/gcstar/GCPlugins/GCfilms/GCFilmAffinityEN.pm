package GCPlugins::GCfilms::GCFilmAffinityEN;

###################################################
#
#  Copyright 2005-2007 Tian
#  Edited 2009 by FiXx
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

    package GCPlugins::GCfilms::GCPluginFilmAffinityEN;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;

        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
            if ($self->{parsingEnded})
            {
                if (   ($tagname eq 'a')
                    && ($attr->{href} =~ /\/en\/.*\.php\?movie_id=([0-9]*)/))
                {
                    $self->{hasUrl} = 'film' . $1 . '.html';
                }
            }
            elsif (!$self->{isMovie}
                && ($tagname eq 'a')
                && ($attr->{href} =~ /^\/en\/(film.*)$/))
            {
                my $url = $1;
                $self->{isMovie} = 1;
                $self->{itemIdx}++;
                $self->{itemsList}[ $self->{itemIdx} ]->{url} = $url;
            }
            elsif (($tagname eq 'span')
                && ($attr->{style} eq 'font-size: 10px; color:#666666'))
            {
                $self->{isDirector} = 1;
            }
            elsif (($tagname eq 'div')
                && ($attr->{style} eq 'font-size: 10px'))
            {
                $self->{isActors} = 1;
            }
        }
        else
        {
            if (   ($tagname eq 'span')
                && ($attr->{style} eq 'color:#990000; font-size:16; font-weight: bold;'))
            {
                $self->{isTitle} = 1;
            }
            elsif ($tagname eq 'img')
            {
                if ($attr->{src} =~ /^\/imgs\/countries/)
                {
                    $self->{curInfo}->{country} = $attr->{title};
                }
                elsif ($attr->{src} =~ /pics.*filmaffinity\.com\/.*-full\.jpg/)
                {
                    $self->{curInfo}->{image} = $attr->{src}
                      if not exists $self->{curInfo}->{image};
                }
            }
            elsif ($tagname eq 'a')
            {
                if ($attr->{href} =~ /pics.*filmaffinity\.com\/.*-large\.jpg/)
                {
                    $self->{curInfo}->{image} = $attr->{href};
                }
            }
            elsif ($tagname eq 'td')
            {
                if ($attr->{style} =~ /font-size:22px; font-weight: bold;/)
                {
                    $self->{isRating} = 1;
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
            if ($self->{parsingEnded})
            {
                if ($self->{hasUrl})
                {
                    $self->{itemsList}[0]->{url} = $self->{hasUrl};
                    $self->{hasUrl} = 0;
                }
                return;
            }
            if ($self->{inside}->{title} && ($origtext !~ /^Search\s+for /))
            {
                $self->{parsingEnded} = 1;
                $self->{hasUrl}       = 0;
                $self->{itemIdx}      = 0;
            }
            elsif ($self->{isMovie})
            {
                return if $origtext !~ /\w/;
                return if $origtext eq 'Add to lists';
                $self->{itemsList}[ $self->{itemIdx} ]->{title} = $origtext;
                $self->{isMovie}                                = 0;
                $self->{isTitle}                                = 1;
            }
            elsif ($self->{isTitle})
            {
                (my $year = $origtext) =~ s/\s*\(([0-9]{4})\)\s*/$1/;
                $self->{itemsList}[ $self->{itemIdx} ]->{date} = $year;
                $self->{isTitle} = 0;
            }
            elsif ($self->{isDirector})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{director} = $origtext;
                $self->{isDirector} = 0;
            }
            elsif ($self->{isActors})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{actors} = $origtext;
                $self->{isActors} = 0;
            }
        }
        else
        {
            $origtext =~ s/^\s*//;

            return if !$origtext;
            if ($self->{isTitle})
            {
                $self->{curInfo}->{title} = $origtext;
                $self->{isTitle} = 0;
            }
            elsif ($self->{isOrig})
            {
                $self->{curInfo}->{original} = $origtext;
                $self->{isOrig} = 0;
            }
            elsif ($self->{isDate})
            {
                $self->{curInfo}->{date} = $origtext;
                $self->{isDate} = 0;
            }
            elsif ($self->{isTime})
            {
                $self->{curInfo}->{time} = $origtext;
                $self->{isTime} = 0;
            }
            elsif ($self->{isDirector})
            {
                $self->{curInfo}->{director} = $origtext;
                $self->{isDirector} = 0;
            }
            elsif ($self->{isActors})
            {
                if ($self->{inside}->{a} && $origtext)
                {
                    $origtext =~ s/\n//g;
                    $self->{curInfo}->{actors} .= $origtext . ', ';
                }
            }
            elsif ($self->{isGenre})
            {
                $self->{curInfo}->{genre} = $origtext;
                $self->{curInfo}->{genre} =~ s/\s*\/\s*/,/g;
                $self->{isGenre} = 0;
            }
            elsif ($self->{isSynopsis})
            {
                $self->{curInfo}->{synopsis} = $origtext;
                $self->{isSynopsis} = 0;
            }
            elsif ($self->{isRating})
            {
                $origtext =~ s/,/\./;	# replace comma
                $self->{curInfo}->{ratingpress} = int($origtext + 0.5);
                $self->{isRating} = 0;
            }

            if ($self->{inside}->{b})
            {
                if ($origtext eq 'ORIGINAL TITLE')
                {
                    $self->{isOrig} = 1;
                }
                elsif ($origtext eq 'YEAR')
                {
                    $self->{isDate} = 1;
                }
                elsif ($origtext eq 'RUNNING TIME')
                {
                    $self->{isTime} = 1;
                }
                elsif ($origtext eq 'DIRECTOR')
                {
                    $self->{isDirector} = 1;
                }
                elsif ($origtext eq 'CAST')
                {
                    $self->{isActors} = 1;
                }
                elsif ($origtext eq 'STUDIO/PRODUCER')
                {
                    $self->{curInfo}->{actors} =~ s/, $//;
                    $self->{isActors} = 0;
                }
                elsif ($origtext eq 'GENRE')
                {
                    $self->{isGenre} = 1;
                }
                elsif ($origtext eq 'SYNOPSIS/PLOT')
                {
                    $self->{isSynopsis} = 1;
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
            director => 1,
            actors   => 1,
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

        $self->{parsingEnded} = 0;

        return $html;
    }

    sub getSearchUrl
    {
        my ($self, $word) = @_;

        return "http://www.filmaffinity.com/en/search.php?"
              ."stext=$word&stype=title";
    }

    sub getItemUrl
    {
        my ($self, $url) = @_;

        return 'http://www.filmaffinity.com/en/' . $url;
    }

    sub changeUrl
    {
        my ($self, $url) = @_;

        return $url;
    }

    sub getName
    {
        return "Film affinity (EN)";
    }

    sub getCharset
    {
        my $self = shift;

        return "ISO-8859-1";
    }

    sub getAuthor
    {
        return 'Tian & PIN edited by FiXx';
    }

    sub getLang
    {
        return 'EN';
    }
}

1;
