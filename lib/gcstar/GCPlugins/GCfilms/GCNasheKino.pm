package GCPlugins::GCfilms::GCNasheKino;

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

    package GCPlugins::GCfilms::GCPluginNasheKino;

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
                if ($attr->{class} eq "ab10" && $url =~ m/\/data.movies\?id/)
                {
                    $self->{isMovie} = 1;
                    $self->{isDate}  = 2;
                    $self->{itemIdx}++;
                    $self->{itemsList}[ $self->{itemIdx} ]->{url} = $url;
                }
            }
            if (   $tagname eq "a"
                && $attr->{class} eq "ab10"
                && $self->{isDate} == 2)
            {
                $self->{isDate} = 1;
            }
        }
        else
        {
            if (   $tagname eq "a"
                && $attr->{class} eq "ab10"
                && $self->{inside}->{h1})
            {
                $self->{insideDate} = 1;
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
                $self->{itemsList}[ $self->{itemIdx} ]->{title} = $origtext;
                $self->{isMovie} = 0;
                return;
            }
            elsif ($self->{isDate} == 1)
            {
                if ($origtext =~ m/([0-9]+)\sг/)
                {
                    $self->{itemsList}[ $self->{itemIdx} ]->{date} = $1;
                    $self->{isDate} = 0;
                }
            }
        }
        else
        {
            utf8::decode($origtext);
            $origtext =~ s/^\s+//;
            $origtext =~ s/\s+$//;
            if ($self->{inside}->{h1})
            {
                $self->{curInfo}->{title} = $origtext
                  if !$self->{curInfo}->{title};
            }
            if ($self->{insideDate})
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
                    $self->{curInfo}->{audio} = "русский";
                    $self->{insideDate} = 0;
                }
            }
            if ($self->{insideDirector})
            {
                $self->{curInfo}->{director} = $origtext;
                $self->{insideDirector} = 0;
            }
            elsif ($self->{insideSynopsis})
            {
                if ($origtext =~ m/\S+/)
                {
                    $self->{curInfo}->{synopsis} = $origtext;
                    $self->{insideSynopsis} = 0;
                }
            }
            elsif ($self->{insideActors})
            {
                $self->{insideActors} = 0 if $origtext =~ m/Сценарий:/;
                if (   $origtext !~ m/^,/
                    && $self->{actorsCounter} < $GCPlugins::GCfilms::GCfilmsCommon::MAX_ACTORS)
                {
                    $self->{curInfo}->{actors} .= (
                        $self->{curInfo}->{actors}
                        ? ", " . $origtext
                        : $origtext
                    );
                    $self->{actorsCounter}++;
                }
            }
            $self->{insideDirector} = 1 if $origtext =~ m/Режиссер\(ы\):/;
            $self->{insideActors}   = 1 if $origtext =~ m/Актер\(ы\):/;
            $self->{insideSynopsis} = 1 if $origtext =~ m/О\sфильме:/;
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
        return "NasheKino";
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
        return "Windows-1251";
    }

    sub getSearchUrl
    {
        my ($self, $word) = @_;
        return "http://www.nashekino.ru/data.find?t=0&yr=&sval=$word";
    }

    sub getItemUrl
    {
        my ($self, $url) = @_;
        return "http://www.nashekino.ru/" . $url;
    }

    sub preProcess
    {
        my ($self, $html) = @_;
        $self->{parsingEnded} = 0;
        return $html;
    }

}

1;
