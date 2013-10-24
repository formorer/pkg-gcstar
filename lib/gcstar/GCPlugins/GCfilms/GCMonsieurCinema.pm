package GCPlugins::GCfilms::GCMonsieurCinema;

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

###################################
#														   #
#			Plugin soumis par MeV			   #
#														   #
###################################

use strict;
use utf8;

use GCPlugins::GCfilms::GCfilmsCommon;

{

    package GCPlugins::GCfilms::GCPluginMonsieurCinema;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;

        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
            if ($tagname eq "a")
            {
                if ($attr->{href} =~ /^http\:\/\/cinema\.tiscali\.fr\/fichefilm\.aspx/)
                {
                    my $url = $attr->{href};
                    $self->{isMovie} = 1;
                    $self->{isInfo}  = 1;
                    $self->{itemIdx}++;
                    $self->{itemsList}[ $self->{itemIdx} ]->{url} = $url;
                }
            }
        }
        else
        {
            if ($tagname eq "img")
            {
                if ($attr->{src} =~ 
                  m|^http\://media\.monsieurcinema\.com/film/[0-9]*/[0-9]*/[0-9]*\.jpg|)
                {
                    $self->{curInfo}->{image} = $attr->{src};
                }
            }
            elsif ($tagname eq "b")
            {
                if ($attr->{class} eq "sous_titre")
                {
                    $self->{insideName} = 1;
                }
            }
            elsif ($tagname eq "span")
            {
                if ($attr->{class} eq "sous_titre")
                {
                    $self->{insideDate} = 1;
                }
            }
            elsif ($tagname eq "div")
            {
                if ($attr->{class} eq "movie_infos")
                {
                    $self->{insideInfos} = 1;
                }
                elsif ($attr->{align} eq "justify")
                {
                    $self->{insideSynopsis} = 1;
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

        return if length($origtext) < 2;

        if ($self->{parsingList})
        {
            if ($self->{isMovie})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{"title"} = $origtext;
                $self->{isMovie}                                  = 0;
                $self->{isInfo}                                   = 1;
                return;
            }
            elsif ($origtext =~ /, de ([^(]*)�\(([0-9]{4})\)/)
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{"director"} = $1;
                $self->{itemsList}[ $self->{itemIdx} ]->{"date"}     = $2;
            }
        }
        else
        {
            $origtext =~ s/\s{2,}//g;
            $origtext =~ s/\[endline\]/\n/g if !$self->{insideSynopsis} && !$self->{insideCast};

            if ($self->{insideName})
            {
                $self->{curInfo}->{title} = $self->capWord($origtext);
                $self->{insideName} = 0;
            }
            elsif ($self->{insideDate})
            {
                if ($origtext =~ /\(([0-9]{4})\)/)
                {
                    $self->{curInfo}->{date} = $1;
                    $self->{insideCast} = 1;
                }
                $self->{insideDate} = 0;
            }
            elsif ($self->{insideInfos})
            {
                if (($origtext =~ /Genre\s*\:\s*(.*)/) || ($origtext =~ /Catégorie\s*\:\s*(.*)/))
                {
                    $self->{curInfo}->{genre} .= $self->{curInfo}->{genre} ? "," . $1 : $1;
                    $self->{curInfo}->{genre} =~ s/, /,/g;
                }
                elsif ($origtext =~ /Durée\s*\:\s*(.*)/)
                {
                    $self->{curInfo}->{time} = $1;
                }
                elsif ($origtext =~ /Pays\s*\:\s*(.*)/)
                {
                    $self->{curInfo}->{country} = $1;
                }
                elsif ($origtext =~ /Public\s*\:\s*(.*)/)
                {
                    if ($1 eq 'Tous publics')
                    {
                        $self->{curInfo}->{age} = 2;
                    }
                    else
                    {
                        $self->{curInfo}->{age} = $1;
                        $self->{curInfo}->{age} =~ s/.*?([0-9]+).*/$1/;
                    }
                }
                $self->{insideInfos} = 0;
            }
            elsif ($self->{insideSynopsis})
            {
                $origtext =~ s/\[endline\]/\n/g;
                $self->{curInfo}->{synopsis} = $origtext if !$self->{curInfo}->{synopsis};
                $self->{insideSynopsis} = 0;
            }
            elsif ($self->{insideCast})
            {
                $origtext =~ s/\[endline\]//g;
                $origtext =~ s/|
//g;
                if ($origtext =~ /de(.*)avec(.*)/)
                {
                    $self->{curInfo}->{director} = $1;
                    $self->{curInfo}->{actors}   = $2;
                }
                $self->{insideCast} = 0;
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
            date     => 0,
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

        $html =~ s{</?b>}{}g;
        $html =~ s/<br>/\[endline\]/gi;
        $html =~ s{<span style="text-transform\:uppercase;">([^<]*)</span>}
                  {$1}g;
        $html =~ s{<div style="float\:left;width\:100px">([^<]*)</div>[^<]*<div style="float\:left;">([^<]*)</div>}
                  {<div class="movie_infos">$1 \: $2</div>}g;
        $html =~ s{<a href="http\://cinema\.tiscali\.fr/recherche\.aspx\?file=http&amp;keys=[^"]*">([^<]*)</a>}
                  {$1}g;

        return $html;
    }

    sub getSearchUrl
    {
        my ($self, $word) = @_;

        return "http://cinema.tiscali.fr/recherche.aspx?file=http&keys=$word";
    }

    sub getItemUrl
    {
        my ($self, $url) = @_;

        return $url unless $url eq '';
        return "http://cinema.tiscali.fr/";
    }

    sub getName
    {
        return "MonsieurCinema.com";
    }

    sub getAuthor
    {
        return 'MeV';
    }

    sub getLang
    {
        return 'FR';
    }

    sub getCharset
    {
        return "utf8";
    }

}

1;
