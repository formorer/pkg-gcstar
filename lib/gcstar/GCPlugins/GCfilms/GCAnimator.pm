package GCPlugins::GCfilms::GCAnimator;

###################################################
#
#  Copyright 2005-2009 zserghei
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
use Encode qw(encode);

use GCPlugins::GCfilms::GCfilmsCommon;

{

    package GCPlugins::GCfilms::GCPluginAnimator;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
        $self->{inside}->{$tagname}++;
        if ($self->{parsingList})
        {
            if ($tagname eq "a")
            {
                my $url = $attr->{href};
                if ($url =~ m/\/db\/\?p\=show\_film/)
                {
                    $self->{isMovie} = 1;
                    $self->{itemIdx}++;
                    $self->{itemsList}[ $self->{itemIdx} ]->{url} = $url;
                }
            }
        }
        else
        {
            if ($tagname eq "td" && $attr->{class} eq "FilmName")
            {
                $self->{insideTitle} = 1;
            }
            elsif ($tagname eq "td" && $attr->{class} eq "FilmType")
            {
                $self->{insideTime} = 1;
                $self->{insideDate} = 1;
            }
            elsif ($tagname eq "td" && $attr->{class} eq "FilmComments")
            {
                $self->{insideSynopsis} = 1;
            }
            elsif ($tagname eq "img")
            {
                $self->{curInfo}->{image} = $attr->{src}
                  if !$self->{curInfo}->{image}
                      && ($attr->{id} eq "SlideShow" || $attr->{width} =~ m/3\d{2}/);
                $self->{curInfo}->{image} = "http://www.animator.ru/" . $self->{curInfo}->{image}
                  if $self->{curInfo}->{image} =~ m/^\//;
                $self->{curInfo}->{image} = "http://www.animator.ru/db/" . $self->{curInfo}->{image}
                  if $self->{curInfo}->{image} =~ m/^\.\.\//;
                $self->{insideImage} = 0;
            }
        }
    }

    sub text
    {
        my ($self, $origtext) = @_;
        if ($self->{parsingList})
        {
            if ($self->{isMovie})
            {
                my ($title, $date);
                if ($origtext =~ m/«(.*)»\s\(([0-9]*)\s.+\)/)
                {
                    ($title, $date) = ($1, $2);
                    $self->{itemsList}[ $self->{itemIdx} ]->{title} = $title;
                    $self->{itemsList}[ $self->{itemIdx} ]->{date}  = $date;
                }
                else
                {
                    $self->{itemsList}[ $self->{itemIdx} ]->{title} = $origtext;
                }
                $self->{isMovie} = 0;
                return;
            }
        }
        else
        {
            utf8::decode($origtext);
            $origtext =~ s/^\s+//;
            $origtext =~ s/\s+$//;
            if ($self->{insideTitle})
            {
                $origtext =~ s/^\W//;
                $origtext =~ s/\W$//;
                $origtext                 = ucfirst(lc($origtext));
                $self->{curInfo}->{title} = $origtext;
                $self->{curInfo}->{genre} = "Мультфильм";
                $self->{curInfo}->{audio} = "русский";
                $self->{insideTitle}      = 0;
            }
            elsif ($self->{insideDate})
            {
                if ($origtext =~ m/([0-9]+)\sг/)
                {
                    $self->{curInfo}->{date} = $1;
                    if ($self->{curInfo}->{date} < 1992)
                    {
                        $self->{curInfo}->{country} = "СССР";
                    }
                    else
                    {
                        $self->{curInfo}->{country} = "Россия";
                    }
                    $self->{insideDate} = 0;
                }
            }
            elsif ($self->{insideDirector})
            {
                $self->{curInfo}->{director} = $origtext;
                $self->{insideDirector} = 0;
            }
            elsif ($self->{insideSynopsis})
            {
                $self->{curInfo}->{synopsis} .=
                  $self->{curInfo}->{synopsis} ? "\n" . $origtext : $origtext;
                $self->{insideSynopsis} = 0;
            }
            if ($self->{insideTime})
            {
                if ($origtext =~ m/,\s+([0-9]+)\s+мин/)
                {
                    $self->{curInfo}->{time} = $1;
                    $self->{insideTime} = 0;
                }
            }
            if ($self->{inside}->{td})
            {
                $self->{insideDirector} = 1 if $origtext =~ m/режиссер/;
            }
        }
    }

    sub end
    {
        my ($self, $tagname) = @_;
        $self->{inside}->{$tagname}--;
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

    sub getName
    {
        return "Animator";
    }

    sub getAuthor
    {
        return 'zserghei';
    }

    sub getLang
    {
        return 'RU';
    }

    sub getCharset
    {
        my $self = shift;
        return "KOI8-R";
#        return "Windows-1251";
    }

    sub getSearchUrl
    {
        my ($self, $word) = @_;
        return "http://www.animator.ru/db/?p=search&text=$word";
    }

    sub getItemUrl
    {
        my ($self, $url) = @_;
        return "http://www.animator.ru/" . $url;
    }

    sub preProcess
    {
        my ($self, $html) = @_;
        $self->{parsingEnded} = 0;
        $html =~ tr
            {АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюя}
            {юабцдефгхийклмнопярстужвьызшэщчъЮАБЦДЕФГХИЙКЛМНОПЯРСТУЖВЬЫЗШЭЩЧЪ};
        return $html;
    }

}

1;
