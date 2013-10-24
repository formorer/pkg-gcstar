package GCPlugins::GCfilms::GCFilmUP;

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
#use utf8;

use GCPlugins::GCfilms::GCfilmsCommon;

{

    package GCPlugins::GCfilms::GCPluginFilmUP;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    sub getSearchUrl
    {
        my ($self, $word) = @_;
        my $url;

        $url =
            "http://filmup.leonardo.it/cgi-bin/search.cgi?"
          . "ps=10&fmt=long&q=$word"
          . "&ul=%25%2Fsc_%25&x=52&y=7&m=all&wf=2221&wm=wrd&sy=0";

        return $url;
    }

    sub getItemUrl
    {
        my ($self, $url) = @_;

        return $url unless $url eq '';
        return 'http://filmup.leonardo.it/';
    }

    sub getName
    {
        return "FilmUP";
    }

    sub getAuthor
    {
        return 'Tian';
    }

    sub getLang
    {
        return 'IT';
    }

    sub changeUrl
    {
        my ($self, $url) = @_;

        return $url;
    }

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
            if ($tagname eq 'a')
            {
                if ($self->{insideInfos})
                {
                    $self->{itemsList}[ $self->{itemIdx} ]->{url} = $self->{lasUrl};
                    $self->{insideInfos} = 0;
                }

                $self->{lasUrl} = $attr->{href};
            }
        }
        else
        {
            if ($tagname eq 'img')
            {
                $self->{curInfo}->{image} = $self->getItemUrl . $attr->{src}
                  if $attr->{src} =~ /^locand\// && ($attr->{src} ne 'locand/no.gif');
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
            if ($self->{inside}->{dt} && $self->{inside}->{a})
            {
                if ($origtext =~ m/FilmUP - Scheda: (.*)/)
                {
                    $self->{itemIdx}++;
                    $self->{itemsList}[ $self->{itemIdx} ]->{title} = $1;
                    $self->{insideInfos} = 1;
                }
            }
            if (   $self->{inside}->{small}
                && $self->{inside}->{table}
                && $self->{insideInfos})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{date} = $1
                  if $origtext =~ /Anno: ([0-9]+)/;
                $self->{itemsList}[ $self->{itemIdx} ]->{director} = $1
                  if $origtext =~ /Regia: (.*?)((Sito)|$)/;
                $self->{itemsList}[ $self->{itemIdx} ]->{actors} = $1
                  if $origtext =~ /Cast: (.*?)$/;
            }
        }
        else
        {
            if ($self->{inside}->{h1})
            {
                $self->{curInfo}->{title} = $origtext;
            }
            elsif ($self->{inside}->{td} && ($origtext !~ /^[\r\n]+$/))
            {
                $self->{insideTime} = 0 if $origtext =~ /Regia:/;
                if ($self->{insideOriginal})
                {
                    $self->{curInfo}->{original} = $origtext;
                    $self->{insideOriginal} = 0;
                }
                elsif ($self->{insideNat})
                {
                    $self->{curInfo}->{country} = $origtext;
                    $self->{insideNat} = 0;
                }
                elsif ($self->{insideDate})
                {
                    $self->{curInfo}->{date} = $origtext;
                    $self->{insideDate} = 0;
                }
                elsif ($self->{insideGenre})
                {
                    if (!$self->{curInfo}->{genre})
                    {
                        $origtext =~ s|/|,|;
                        $self->{curInfo}->{genre} = $origtext;
                    }
                    $self->{insideGenre} = 0;
                }
                elsif ($self->{insideTime})
                {
                    $self->{curInfo}->{time} = $origtext;
                    $self->{insideTime} = 0;
                }
                elsif ($self->{insideDirector})
                {
                    $self->{curInfo}->{director} = $origtext;
                    $self->{insideDirector} = 0;
                }
                elsif ($self->{insideActors})
                {
                    $self->{curInfo}->{actors} = $origtext;
                    $self->{insideActors} = 0;
                }

                $self->{insideOriginal} = 1 if $origtext =~ /Titolo originale:/;
                $self->{insideNat}      = 1 if $origtext =~ /Nazione:/;
                $self->{insideDate}     = 1 if $origtext =~ /Anno:/;
                $self->{insideGenre}    = 1 if $origtext =~ /Genere:/;
                $self->{insideTime}     = 1 if $origtext =~ /Durata:/;
                $self->{insideDirector} = 1 if $origtext =~ /Regia:/;
                $self->{insideActors}   = 1 if $origtext =~ /Cast:/;
            }
            if ($self->{inside}->{synopsis})
            {
                $self->{curInfo}->{synopsis} = $origtext;
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

        bless($self, $class);
        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        $html =~ s/\222/'/g;

        $html =~ s{<font face="arial, helvetica" size="3">(.*?)</font>}
                  {<h1>$1</h1>}g;
        $html =~ s{</table>.<br>.<font face="arial, helvetica" size="2">(.*?)</font>}
                  {</table><synopsis>$1</synopsis>}ms;
        $html =~ s{<font face="arial, helvetica" size="2">Trama:(.*?)</font>}
                  {<synopsis>$1</synopsis>};
        $html =~ s{Trama:<br>}{};
        $html =~ s{<span .*?>|</span>} {}g;
        $html =~ s{<a .*?href="\/?personaggi.*?>(.+?)</a>} {$1}g;

        $html =~ s{<font .*?>|</font>} {}g;
        $html =~ s{</?b>} {}g;

        return $html;
    }

    sub getCharset
    {
        my $self = shift;

        return "Windows-1252";
    }

}

1;
