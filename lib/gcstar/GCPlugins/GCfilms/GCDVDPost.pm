package GCPlugins::GCfilms::GCDVDPost;

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
#                                 #
#      Plugin soumis par MeV      #
#                                 #
###################################

use strict;
use utf8;

use GCPlugins::GCfilms::GCfilmsCommon;

{

    package GCPlugins::GCfilms::GCPluginDVDPost;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;

        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
            if ($tagname eq "a")
            {
                if (($attr->{href} =~ /^product_info\.php\?products_id=/))
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
                if ($attr->{src} =~ /http:\/\/images\.dvdpost\.be\/\/dvd/)
                {
                    $self->{curInfo}->{image} = $attr->{src};
                }
                elsif ($self->{insideAge})
                {
                    (my $fileName = $attr->{src}) =~ s|.+/([^/]+)$|$1|;
                    $self->{curInfo}->{age} = 2  if $fileName eq 'all.gif';
                    $self->{curInfo}->{age} = 12 if $fileName eq '-12.gif';
                    $self->{curInfo}->{age} = 16 if $fileName eq '-16.gif';
                    $self->{insideAge}      = 0;
                }
            }
            elsif ($tagname eq "table")
            {
                if (   ($attr->{cellpadding} eq "0")
                    && ($attr->{cellspacing} eq "0")
                    && ($attr->{width}       eq "100%")
                    && ($attr->{border} ne "0"))
                {
                    $self->{insideSynopsisFather} = 1;
                }
            }
            elsif ($tagname eq "td")
            {
                if ($attr->{style} eq "text-align:right;font-size:9px;color:gray")
                {
                    $self->{insideGenre} = 1;
                }
                elsif (($attr->{class} eq "boxText") && $attr->{align} eq "left")
                {
                    if ($self->{insideSynopsisFather} == 1)
                    {
                        $self->{insideSynopsis}       = 1;
                        $self->{insideSynopsisFather} = 0;
                    }
                    else
                    {
                        $self->{insideSynopsis} = 0;
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
        }
        else
        {
            $origtext =~ s/\n*//g if !$self->{insideSynopsis};
            $origtext =~ s/\s{2,}//g;

            if ($self->{insideDate})
            {
                $self->{curInfo}->{date} = $origtext;
                $self->{insideDate} = 0;
            }
            elsif ($self->{insideDirector})
            {
                $origtext =~ s/ ,/, /g;
                $origtext =~ s/^(.*), /$1/;
                $self->{curInfo}->{director} = $origtext if !$self->{curInfo}->{director};
                $self->{insideDirector} = 0;
            }
            elsif ($self->{insideSynopsis})
            {
                $self->{curInfo}->{synopsis} = $origtext;
                $self->{insideSynopsis} = 0;
            }
            elsif ($self->{insideNat})
            {
                $self->{curInfo}->{country} = $origtext;
                $self->{insideNat} = 0;
            }
            elsif ($self->{insideTime})
            {
                $self->{curInfo}->{time} = $origtext . " min";
                $self->{insideTime} = 0;
            }
            elsif ($self->{insideActors})
            {
                $origtext =~ s/ ,/, /g;
                $origtext =~ s/^(.*), /$1/;
                $self->{curInfo}->{actors} = $origtext if !$self->{curInfo}->{actors};
                $self->{insideActors} = 0;
            }
            elsif ($self->{insideOrig})
            {
                $self->{curInfo}->{original} = $origtext if !$self->{curInfo}->{original};
                $self->{insideOrig} = 0;
            }
            elsif ($self->{inside}->{b})
            {
                $self->{insideDirector} = 1 if $origtext =~ m/R.alisateur/;
                $self->{insideTime}     = 1 if $origtext =~ m/Dur.e/;
                $self->{insideActors}   = 1 if $origtext =~ m/Acteurs/;
                $self->{insideAge}      = 1 if $origtext =~ m/Public/;
            }
            elsif ($self->{inside}->{table})
            {
                if ($origtext =~ /(.*) \( ([0-9]{4}) \)/)
                {
                    $self->{curInfo}->{title} = $1 if !$self->{curInfo}->{title};
                    $self->{curInfo}->{date}  = $2 if !$self->{curInfo}->{date};
                }
                elsif ($self->{insideGenre})
                {
                    $origtext =~ s/\|/,/g;
                    $self->{curInfo}->{genre} = $origtext;
                    $self->{insideGenre} = 0;
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

        $html =~ s/&nbsp;/ /g;
        $html =~ s/<u>|<\/u>//g;
        $html =~ s/<a href="directors\.php\?directors\_id=[0-9]*">([^<]*)<\/a>/$1/gi;
        $html =~ s/<a href="actors\.php\?actors\_id=[0-9]*">([^<]*)<\/a>/$1/gi;

        return $html;
    }

    sub getSearchUrl
    {
        my ($self, $word) = @_;

        return "http://www.dvdpost.be/advanced_search_result2.php?language=fr&keywords=$word";
    }

    sub getItemUrl
    {
        my ($self, $url) = @_;

        return "http://www.dvdpost.be/" . $url . "&language=fr" unless $url eq '';
        return "http://www.dvdpost.be/";
    }

    sub getName
    {
        return "DVDPost.be";
    }

    sub getAuthor
    {
        return 'MeV';
    }

    sub getLang
    {
        return 'FR';
    }

}

1;
