package GCPlugins::GCfilms::GCBeyazPerde;

###################################################
#
#  Copyright 2007-2009 Zuencap
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

    package GCPlugins::GCfilms::GCPluginBeyazPerde;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;

        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
            if ($tagname eq "a")
            {
                if ($attr->{href} =~ /\/film\// && $attr->{class} eq "turuncucizgisiz_11_px")
                {
                    my $url = $attr->{href};
                    $self->{isMovie} = 1;
                    $self->{itemIdx}++;
                    $self->{itemsList}[ $self->{itemIdx} ]->{url} = $url;
                }
            }
        }
        else
        {
            if ($tagname eq "img")
            {
                if ($attr->{src} =~ /^\/images\/film\//)
                {
                    $self->{curInfo}->{image} = "http://beyazperde.mynet.com" . $attr->{src}
                      if !$self->{curInfo}->{image};
                }
            }
            elsif ($tagname eq "td")
            {
                if ($self->{insideSynopsis} == 1)
                {
                    $self->{insideSynopsis} = 2;
                }
            }
            elsif ($tagname eq "h1")
            {
                if ($attr->{class} eq "baslik_filmadi31")
                {
                    $self->{insideTitle} = 1;
                }
            }
            elsif ($tagname eq "h2")
            {
                if ($attr->{class} eq "baslik_filmadi32")
                {
                    $self->{insideTitle} = 2;
                }
            }
        }
    }

    sub end
    {
        my ($self, $tagname) = @_;

        $self->{inside}->{$tagname}--;

        if (!$self->{parsingList})
        {
            if ($tagname eq "table")
            {
                if ($self->{insideActors})
                {
                    $self->{insideActors}   = 0;
                    $self->{insideSynopsis} = 1;
                }
                $self->{insideTime} = 0;
            }
            elsif ($tagname eq "td")
            {
                if ($self->{insideSynopsis} == 2)
                {
                    $self->{insideSynopsis} = 0;
                }
            }
        }
    }

    sub text
    {
        my ($self, $origtext) = @_;

        return if length($origtext) < 2;

        $origtext =~ s/&#34;/"/g;
        $origtext =~ s/&#179;/3/g;
        $origtext =~ s/&#[0-9]*;//g;
        $origtext =~ s/\n//g;

        if ($self->{parsingList})
        {
            if ($self->{isMovie} == 0)
            {
                return;
            }
            elsif ($self->{isMovie} == 1)
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{title} = $origtext;
            }
            elsif ($self->{isMovie} == 2)
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{date} = $1 if $origtext =~ m/\(([0-9]*)\)/;
            }
            elsif ($self->{isMovie} == 5)
            {
                if ($origtext eq "Y:")
                {
                    $self->{isMovie}++;
                }
            }
            elsif ($self->{isMovie} == 7)
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{director} = $origtext;
            }
            elsif ($self->{isMovie} == 9)
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{actors} = $origtext;
                $self->{isMovie} = -1;
            }

            $self->{isMovie}++;
            return;
        }
        else
        {
            if ($self->{insideGenre} && ($self->{inside}->{a}))
            {
                $self->{curInfo}->{genre} = $self->capWord($origtext);
                $self->{insideGenre} = 0;
            }
            elsif ($self->{insideDirector} && ($self->{inside}->{a}))
            {
                $self->{curInfo}->{director} = $origtext;
                $self->{insideDirector} = 0;
            }
            elsif ($self->{insideSynopsis} == 2)
            {
                ($self->{curInfo}->{synopsis} .= $origtext) =~ s/^\s*//;
            }
            elsif ($self->{insideTime})
            {
                if ($self->{insideTime} == 1)
                {
                    if ($self->{inside}->{a})
                    {
                        $self->{curInfo}->{date} = $origtext;
                        $self->{insideTime}++;
                    }
                }
                elsif ($self->{insideTime} == 2)
                {
                    if ($self->{inside}->{a})
                    {
                        $self->{curInfo}->{country} = $origtext;
                        $self->{insideTime}++;
                    }
                }
                elsif ($origtext =~ / dk\./)
                {
                    $origtext =~ s/.*, (.*) dk\./$1 dk\./;
                    $self->{curInfo}->{time} = $origtext;
                    $self->{insideTime} = 0;
                }
            }
            elsif ($self->{insideActors})
            {
                if ($self->{inside}->{a})
                {
                    push @{$self->{curInfo}->{actors}}, [$origtext]
                      if ($self->{actorsCounter} <
                        $GCPlugins::GCfilms::GCfilmsCommon::MAX_ACTORS);
                    $self->{actorsCounter}++;
                }
                elsif ($self->{inside}->{font} && ($origtext =~ m/\((.*)\)/))
                {
                    # As we incremented it above, we have one more chance here to add a role
                    # Without <= we would skip the role for last actor
                    push @{$self->{curInfo}->{actors}->[$self->{actorsCounter}-1]}, $1
                      if ($self->{actorsCounter} <=
                        $GCPlugins::GCfilms::GCfilmsCommon::MAX_ACTORS);
                }
            }
            elsif ($self->{insideOtherTitles})
            {
                if ($origtext =~ m/(.*?) \(International.*/)
                {
                    $self->{curInfo}->{title} = $1;
                    $self->{insideOtherTitles} = 0;
                }
            }
            elsif ($self->{insideTitle} == 1)
            {
                $self->{curInfo}->{title} = $origtext;
                $self->{insideTitle} = 0;
            }
            elsif ($self->{insideTitle} == 2)
            {
                $self->{curInfo}->{original} = $origtext;
                $self->{insideTitle} = 0;
            }

            if ($self->{inside}->{span})
            {
                $self->{insideDirector} = 1 if $origtext =~ m/Y\xf6netmen : /;
                $self->{insideGenre} = 1 if $origtext eq "T\xfcr : ";
                $self->{insideTime} = 1 if $origtext =~ m/Yapım/;
                $self->{insideActors} = 1
                  if $origtext =~ m/Oyuncular/ || $origtext =~ m/Seslendirenler/;
                if ($origtext =~ m{SinePuan:\s+(\d+\,\d+)\s+})
                {
                    my $rating = $1;
                    $rating =~ s/,/./;
                    $self->{curInfo}->{ratingpress} = int($rating + 0.5);
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

        $self->{isMovie} = 0;
        $self->{curName} = undef;
        $self->{curUrl}  = undef;

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        #Fix for character-encoding:
        $html =~ s/\x85/\.\.\./g;
        $html =~ s/\x92/'/g;
        $html =~ s/\x93/“/g;
        $html =~ s/\x94/”/g;

        $html =~ s/"&#34;/'"/g;
        $html =~ s/&#34;"/"'/g;
        $html =~ s/&nbsp;/ /g;
        $html =~ s|</a></b><br>|</a><br>|;

        return $html;
    }

    sub getSearchUrl
    {
        my ($self, $word) = @_;
        return "http://beyazperde.mynet.com/arama.asp?kat=film&keyword=$word";
    }

    sub getItemUrl
    {
        my ($self, $url) = @_;

        return $url if $url;
        return 'http://beyazperde.mynet.com/';
    }

    sub convertCharset
    {
        my ($self, $value) = @_;
        return $value;
    }

    sub getName
    {
        return "Beyaz Perde";
    }

    sub getAuthor
    {
        return 'Zuencap';
    }

    sub getLang
    {
        return 'TR';
    }

    sub getCharset
    {
        my $self = shift;

        return "utf-8";
    }

}

1;
