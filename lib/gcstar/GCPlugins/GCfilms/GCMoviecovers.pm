package GCPlugins::GCfilms::GCMoviecovers;

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

    package GCPlugins::GCfilms::GCPluginMoviecovers;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;

        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
            if ($tagname eq "a")
            {
                if (($attr->{href} =~ /^\/film\/titre_/) && ($self->{inside}->{li}))
                {
                    my $url = $attr->{href};
                    $self->{isMovie} = 1;
                    $self->{isInfo}  = 0;
                    $self->{itemIdx}++;
                    $self->{itemsList}[ $self->{itemIdx} ]->{url} = $url;
                }
            }
        }
        else
        {
            if ($tagname eq "img")
            {
                my $src = $attr->{src};
                my $alt = $attr->{alt};
                if (!$self->{curInfo}->{image})
                {
                    if ($alt =~ /^Recto/)
                    {
                        $src =~ s/http\:\/\/www\.moviecovers\.com\/DATA\/thumbs\/films\-[A-Za-z0-9-]+\/(.*)/$1/;
                        $self->{curInfo}->{image} =
                          "http://data.moviecovers.com/DATA/zipcache/" . $src;
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
            if ($self->{isMovie})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{"title"} = $origtext;
                $self->{isMovie}                                  = 0;
                $self->{isInfo}                                   = 1;
                return;
            }

            if ($self->{inside}->{li})
            {
                my $element = undef;
                if ($origtext =~ /^ \([0-9]{4}\)/)
                {
                    $origtext =~ s/ \(([0-9]{4})\)/$1/;
                    $element = "date";
                    $self->{isInfo} = 0;
                }
                $self->{itemsList}[ $self->{itemIdx} ]->{$element} = $origtext
                  if $element;
            }

        }
        else
        {

            if ($self->{inside}->{title})
            {
                $self->{curInfo}->{title} = $origtext if length($origtext) > 2;
            }

            if ($self->{inside}->{td})
            {
                if ($self->{insideOriginal})
                {
                    $origtext =~ s/^\s+//;
                    $origtext =~ s/\s+$//;
                    $self->{curInfo}->{original} = $origtext;
                    $self->{insideOriginal} = 0;
                }
                elsif (($self->{insideGenre}) && ($self->{inside}->{a}))
                {
                    $self->{curInfo}->{genre} = $origtext;
                    $self->{insideGenre} = 0;
                }
                elsif (($self->{insideDirector}) && ($self->{inside}->{a}))
                {
                    $self->{curInfo}->{director} = $origtext;
                    $self->{insideDirector} = 0;
                }
                elsif (($self->{insideNat}) && ($self->{inside}->{a}))
                {
                    $self->{curInfo}->{country} = $origtext;
                    $self->{insideNat} = 0;
                }
                elsif ($self->{insideTime})
                {
                    $origtext =~ s/^\s+//;
                    $origtext =~ s/\s+$//;
                    $self->{curInfo}->{time} = $origtext;
                    $self->{insideTime} = 0;
                }
                elsif ($self->{insideDate} && ($self->{inside}->{a}))
                {
                    $self->{curInfo}->{date} = $origtext;
                    $self->{insideDate} = 0;
                }
                elsif (($self->{insideActors}) && ($self->{inside}->{a}))
                {
                    $self->{curInfo}->{actors} .= $origtext . ', '
                      if ($self->{actorsCounter} <
                        $GCPlugins::GCfilms::GCfilmsCommon::MAX_ACTORS);
                    $self->{actorsCounter}++;
                }
                elsif ($self->{insideSynopsis})
                {
                    ($self->{curInfo}->{synopsis} .= $origtext) =~ s/^\s*//;
                }
            }
            if ($self->{inside}->{th})
            {
                $self->{insideDirector} = 1 if $origtext =~ m/Réalisateur/;
                $self->{insideActors}   = 1 if $origtext =~ m/Acteurs principaux/;
                $self->{insideGenre}    = 1 if $origtext =~ m/Genre/;
                $self->{insideTime}     = 1 if $origtext =~ m/Durée/;
                $self->{insideNat}      = 1 if $origtext =~ m/Nationalité/;
                $self->{insideDate}     = 1 if $origtext =~ m/Année/;
#		$self->{insideSynopsis} = 1 if $origtext =~ m/Résumé/;
                $self->{insideOriginal} = 1 if $origtext =~ m/Titre original/;
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

        $self->{isInfo}  = 0;
        $self->{isMovie} = 0;
        $self->{curName} = undef;
        $self->{curUrl}  = undef;

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

        return "http://www.moviecovers.com/multicrit.html?titre=$word";
    }

    sub getItemUrl
    {
        my ($self, $url) = @_;

        return "http://www.moviecovers.com" . $url;
    }

    sub getName
    {
        return "MovieCovers.com";
    }

    sub getAuthor
    {
        return 'Patrick Fratczak';
    }

    sub getLang
    {
        return 'FR';
    }

    sub getCharset
    {
        return "ISO-8859-1";
    }
}

1;
