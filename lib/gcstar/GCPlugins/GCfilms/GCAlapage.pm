package GCPlugins::GCfilms::GCAlapage;

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

    package GCPlugins::GCfilms::GCPluginAlapage;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;

        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
            if ($tagname eq "a")
            {
                if ($attr->{class} eq "tx12noirbold")
                {
                    my $url = $attr->{href};
                    $self->{isMovie} = 1;
                    $self->{isInfo}  = 1;
                    $self->{itemIdx}++;
                    $self->{itemsList}[ $self->{itemIdx} ]->{url} = $url;
                }
            }
            elsif ($tagname eq "div")
            {
                if ($attr->{class} eq "acteurs")
                {
                    $self->{isActors} = 1;
                }
                elsif ($attr->{class} eq "realisateur")
                {
                    $self->{isDirector} = 1;
                }
            }
        }
        else
        {
            if ($tagname eq "img")
            {
                if ($attr->{src} =~ /^\/resize\.php\?ref=([0-9]*)/)
                {
                    $self->{curInfo}->{image} =
                      "http://imgdata.echo.fr/disque_l?v$1r.jpg";
                }
            }
            elsif ($tagname eq "span")
            {
                $self->{insideName}   = 1 if $attr->{style} eq "color:#414B55;";
                $self->{insideActors} = 1 if $attr->{class} eq "tx11gris";
            }
            elsif ($tagname eq "div")
            {
                $self->{insideSynopsis} = 1 if $attr->{align} eq "justify";
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
            elsif ($self->{isActors})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{"actors"} .=
                  $self->{itemsList}[ $self->{itemIdx} ]->{"actors"}
                  ? ', ' . $self->capWord($origtext)
                  : $self->capWord($origtext);
                $self->{isActors} = 0;
            }
            elsif ($self->{isDirector})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{"director"} =
                  $self->capWord($origtext);
                $self->{isDirector} = 0;
            }

        }
        else
        {
            $origtext =~ s/\s{2,}//g;

            if ($self->{insideName})
            {
                $self->{curInfo}->{title} = $self->capWord($origtext);
                $self->{insideName} = 0;
            }
            elsif ($self->{insideActors})
            {
                $origtext =~ s/avec : (.*) - (?:[^-]* )?DVD/$1/;
                $origtext =~ s/ - /, /g;
                $self->{curInfo}->{actors} = $self->capWord($origtext)
                  if !$self->{curInfo}->{actors};
                $self->{insideActors} = 0;
            }
            elsif ($self->{insideSynopsis})
            {
                $origtext =~ s/\[br\]/\n/g;
                $self->{curInfo}->{synopsis} .= $origtext;
                $self->{insideSynopsis} = 0;
            }
            elsif ($origtext =~ m/R.*alisateur :/)
            {
                $origtext =~ s/R.*alisateur(?: :)?(.*)/$1/;
                $origtext =~ s/ - /, /g;
                $self->{curInfo}->{director} = $self->capWord($origtext)
                  if !$self->{curInfo}->{director};
            }
            elsif ($origtext =~ m/Genre :/)
            {
                $origtext =~ s/Genre :(.*)/$1/;
                $origtext = $self->capWord($origtext);
                $origtext =~ s/ \/ /,/g;
                $origtext =~ s/,Video//g;
                $self->{curInfo}->{genre} = $origtext if !$self->{curInfo}->{genre};
            }
            elsif ($origtext =~ m/Année du film :/)
            {
                $origtext =~ s/Année du film :(.*)/$1/;
                $self->{curInfo}->{date} = $origtext if !$self->{curInfo}->{date};
            }
            elsif ($origtext =~ m/Durée du film/)
            {
                $origtext =~ s/Durée du film(.*)/$1/;
                $self->{curInfo}->{time} = $origtext if !$self->{curInfo}->{time};
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

        #Fix for character-encoding:
        $html =~ s//'/g;
        $html =~ s//\.\.\./g;
        #'

#<<< keep perltidy away from these lines
        $html =~ s/<br>/\[br\]/gi;
        $html =~ s/&nbsp;/ /g;
        $html =~ s/<u>|<\/u>|<b>|<\/b>|<i>|<\/i>//gi;
        $html =~ s/<SPAN class="(?:tx12gris6|tx12noir)">([^<]*)<\/SPAN>/$1/gi;
        $html =~ s|<A href="/-/Liste/DVD/mot_real_nomprenom=.*?\?id=[0-9]*&donnee_appel=ALAPAGE" class="roll">([^<]*)</A>|<div class="realisateur">$1</div>|gi;
        $html =~ s|<A href="/-/Liste/DVD/mot_art_nomprenom=.*?\?id=[0-9]*&donnee_appel=ALAPAGE" class="roll">([^<]*)</A>|<div class="acteurs">$1</div>|gi;
        $html =~ s/<A href="http\:\/\/www\.alapage\.com\/-\/Liste\/DVD\/mot_(?:art_nomprenom|real_nomprenom|gen_libelle)=[^\/]*\/\?id=[0-9]*&donnee_appel=ALAPAGE[^"]*?" class="roll">([^<]*)<\/A>/$1/gi;
        $html =~ s|<A .*?mot_gen_libelle=.*?>(.*?)</A>|$1|gi;
        $html =~ s/<TD valign="top" class="tx12noir[^"]*">([^<]*)<\/TD>[^<]*<TD>([^<]*)<\/TD>/<td>$1 $2<\/td>/gi;
        $html =~ s/<td class="tx12grisbold" align="center" bgcolor="\#E6E6E8">([^<]*)<\/td>[^<]*<TD width="2"><IMG src="\/turbo\/templates\/img\/pix\.gif" width="2" height="25" border="0" alt=""><\/TD>[^<]*<td class="tx10noir" align="center" bgcolor="\#F4F4F6" colspan="3">([0-9]* mn)<\/td>/<td>$1 $2<\/td>/gi;
#>>>
        return $html;
    }

    sub getSearchUrl
    {
        my ($self, $word) = @_;

        return "http://alapage.com/mx/?type=41&tp=L&fulltext=" . $word;
    }

    sub getItemUrl
    {
        my ($self, $url) = @_;

        return "http://alapage.com" . $url;
    }

    sub getName
    {
        return "Alapage.com";
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
        my $self = shift;

        return "ISO-8859-1";
    }

    sub getDefaultPictureSuffix
    {
        return '.jpg';
    }
}

1;
