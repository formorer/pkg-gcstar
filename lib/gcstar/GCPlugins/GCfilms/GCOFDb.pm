package GCPlugins::GCfilms::GCOFDb;

###################################################
#
#  Copyright 2005-2010 Tian
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

    package GCPlugins::GCfilms::GCPluginOFDb;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;

        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
            if ($tagname eq "a")
            {
                if (   ($attr->{href} =~ m/view\.php\?page=film&fid=[0-9]*/)
                    || ($attr->{href} =~ m|^film/[0-9]*|))
                {
                    $self->{isTitle}    = 1;
                    $self->{isInfo}     = 0;
                    $self->{isOriginal} = 0;
                    $self->{itemIdx}++;
                    $self->{itemsList}[ $self->{itemIdx} ]->{url} = $attr->{href};
                }
            }
            elsif ($tagname eq "font")
            {
                if ($self->{isInfo})
                {
                    $self->{isOriginal} = 1;
                }
            }
        }
        else
        {
            if ($tagname eq "font")
            {
                if ($attr->{face} eq "Arial,Helvetica,sans-serif")
                {
                    if ($attr->{size} eq "3")
                    {
                        $self->{insideName} = 1;
                    }
                    elsif ($attr->{size} eq "2")
                    {
                        $self->{insideInfosNames} = 1 if $attr->{class} eq "Normal";
                        $self->{insideInfos}      = 1 if $attr->{class} eq "Daten";
                    }
                }
            }
            elsif ($tagname eq "img")
            {
                if ($attr->{src} =~ m|img\.ofdb\.de/film/[0-9]+/[0-9]*.jpg|)
                {
                    $self->{curInfo}->{image} = $attr->{src}
                      if !$self->{curInfo}->{image};
                }
                elsif ($attr->{src} eq "images/design3/notenspalte.png")
                {
                    $self->{curInfo}->{ratingpress} = int( $attr->{alt} + 0.5 )
                        if ! $self->{curInfo}->{ratingpress};
                }
            }
            elsif ($tagname eq "a")
            {
                if ($attr->{href} =~ m/view\.php\?page=blaettern&Kat=Land&Text=(.*)/)
                {
                    $self->{insideCountry} = 1;
                }
                $self->{curInfo}->{date} = $1
                  if ($attr->{href} =~ m/view\.php\?page=blaettern&Kat=Jahr&Text=([0-9]{4})/);
            }
            elsif (($tagname eq "div") && ($attr->{class} eq "synopsis"))
            {
                $self->{insideSynopsis} = 1;
            }
        }
    }

    sub end
    {
        my ($self, $tagname) = @_;

        if ($tagname eq "tr")
        {
            $self->{insideDirector} = 0;
            $self->{insideActors}   = 0;
            $self->{insideGenre}    = 0;
            $self->{insideInfos}    = 0;
        }

        $self->{inside}->{$tagname}--;
    }

    sub text
    {
        my ($self, $origtext) = @_;

        return if length($origtext) < 2;

        if ($self->{parsingList})
        {
            if ($self->{isTitle})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{"title"} = $origtext;
                $self->{isTitle}    = 0;
                $self->{isInfo}     = 1;
                return;
            }
            elsif ($self->{isOriginal})
            {
                $origtext =~ s{^\s*/\s*}{};
                $self->{itemsList}[ $self->{itemIdx} ]->{original} = $origtext;
                $self->{isOriginal} = 0;
                return;
            }
            elsif (($self->{isInfo}) && ($origtext =~ m/\((\d{4})\)/))
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{date} = $1;
                $self->{isInfo} = 0;
            }
        }
        else
        {
            if ($self->{insideName})
            {
                $self->{curInfo}->{title} = $origtext if !$self->{curInfo}->{title};
                $self->{insideName} = 0;
            }
            elsif ($self->{insideInfosNames})
            {
                $self->{insideOrig}     = 1 if $origtext =~ m/Originaltitel:/;
                $self->{insideDirector} = 1 if $origtext =~ m/Regie:/;
                $self->{insideActors}   = 1 if $origtext =~ m/Darsteller:/;
                $self->{insideGenre}    = 1 if $origtext =~ m/Genre\(s\):/;
                $self->{insideInfosNames} = 0;
            }
            elsif ($self->{insideCountry})
            {
                $self->{curInfo}->{country} .= ', ' if $self->{curInfo}->{country};
                $self->{curInfo}->{country} .= $origtext;
                $self->{insideCountry} = 0;
            }
            elsif ($self->{insideInfos} && $self->{inside}->{font})
            {
                if ($self->{insideOrig})
                {
                    $self->{curInfo}->{original} = $origtext;
                    $self->{insideOrig}          = 0;
                    $self->{insideInfos}         = 0;
                }
                elsif ($self->{insideDirector})
                {
                    $self->{curInfo}->{director} .=
                      $self->{curInfo}->{director}
                      ? ', ' . $origtext
                      : $origtext;
                }
                elsif ($self->{insideActors})
                {
                    push @{$self->{curInfo}->{actors}}, [$origtext]
                      if $self->{actorsCounter} < $GCPlugins::GCfilms::GCfilmsCommon::MAX_ACTORS;
                    $self->{actorsCounter}++;
                }
                elsif ($self->{insideGenre})
                {
                    push @{$self->{curInfo}->{genre}}, [$origtext];
                }
            }
            elsif ($self->{insideSynopsis})
            {
                $origtext =~ m/(http.*?)(\s|$)/;
                my $page = $self->loadPage($1, 0, 1);
                $page =~ m|<font face="Arial,Helvetica,sans-serif" size="2" class="Blocksatz">.*?</a><br>[^<]*</b>(?:</b>)?<br><br>(.*?)</font>|ms;
                $self->{curInfo}->{synopsis} = $1;
                $self->{curInfo}->{synopsis} =~ s/<br \/>/\n/gi;
                $self->{insideSynopsis} = 0;
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
            original => 1,
        };

        $self->{isInfo}  = 0;
        $self->{isYear}  = 0;
        $self->{curName} = undef;
        $self->{curUrl}  = undef;

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        if ($self->{parsingList})
        {
            $html =~ s|onmouseover="[^"]*"||gms;
        }
        $html =~ s{<a href="view\.php\?page=liste&Name=[^"]*">([^<]*)</a>}
                  {$1}g;
        $html =~ s{<a href="view\.php\?page=genre&Genre=[^"]*">([^<]*)</a>}
                  {$1}g;
        $html =~ s{<font face="Arial,Helvetica,sans-serif" size="2" class="Blocksatz"><p class="Blocksatz"><b>Inhalt:<\/b>\s?([^<]*)<a href="(view\.php\?page=inhalt&fid=[0-9]*&sid=[0-9]*)">\s?<b>\[mehr\]</b></a></p></font>}
                  {<div class="synopsis">$1\nhttp://www.ofdb.de/$2</div>};
        $html =~ s{<font face="Arial,Helvetica,sans-serif" size="2" class="Blocksatz"><p\s*class="Blocksatz"><b>Inhalt:</b>\s?([^<]*)<a href="(plot/[0-9]*[^"]*)">\s?<b>\[mehr\]</b></a></p></font>}
                  {<div class="synopsis">$1\nhttp://www.ofdb.de/$2</div>}gm;
        $html =~ s{%DF}{ss};

        return $html;
    }

    sub getSearchUrl
    {
        my ($self, $word) = @_;

        # if $word looks like an EAN, do a EAN search, otherwise title search
        my $kat = ($word =~ /^[\dX]{8}[\dX]*$/) ? "EAN" : "Titel";

        return "http://www.ofdb.de/view.php?page=suchergebnis&Kat=$kat&SText=$word";
    }

    sub getItemUrl
    {
        my ($self, $url) = @_;
        utf8::decode($url);
        return 'http://www.ofdb.de/' . $url;
    }

    sub getCharset
    {
        my $self = shift;

        return "ISO-8859-1";
    }

    sub getSearchCharset
    {
        my $self = shift;

        return "UTF-8";
    }

    sub getName
    {
        return "OFDb.de";
    }

    sub getAuthor
    {
        return 'MeV';
    }

    sub getLang
    {
        return 'DE';
    }

}

1;
