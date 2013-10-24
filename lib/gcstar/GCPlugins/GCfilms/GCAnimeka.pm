package GCPlugins::GCfilms::GCAnimeka;

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
    package GCPlugins::GCfilms::GCPluginAnimeka;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

        if ($self->{parsingEnded})
        {
            if (($tagname eq 'form')
             && ($attr->{name} eq 'form_note_serie')
             && (! $self->{itemsList}[0]->{url}))
            {
                $self->{itemIdx} = 0;
                $self->{itemsList}[0]->{url} = $attr->{action};
            }
            return;
        }

        if ($self->{parsingList})
        {
            if (($tagname eq "img")
             && ($attr->{class} eq "rechercheindeximg")
             && ($attr->{alt} eq "Animesindex"))
            {
                $self->{parsingEnded} = 1 if $attr->{src} !~ /rechercheindex\.gif/;
            }

            if ($tagname eq "a")
            {
                if (($attr->{href} =~ /^\/animes\/detail\//))
                {
                    my $url = $attr->{href};
                    $self->{isMovie} = 1;
                    $self->{isInfo} = 1;
                    $self->{itemIdx}++;
                    $self->{itemsList}[$self->{itemIdx}]->{url} = $url;
                }
            }
        }
        else
        {
            if ($tagname eq "img")
            {
                if ($attr->{class} eq "picture")
                {
                    $self->{curInfo}->{image} = "http://animeka.com" . $attr->{src};
                }
                elsif (($attr->{class} eq "animeslegendimg")
                    && ($attr->{src} =~ /^\/_distiller\/show_flag\.php\?id=/))
                {
                    if (!$self->{curInfo}->{country})
                    {
                        $self->{curInfo}->{country} = $attr->{alt};
                    }
                    elsif ($self->{curInfo}->{country} !~ $attr->{alt})
                    {
                        $self->{curInfo}->{country} .= ", " . $attr->{alt};
                    }
                }
            }
            elsif ($tagname eq "td")
            {
                $self->{insideInfos} = 1 if $attr->{class} eq "animestxt";
								$self->{insideName} = 1 if $attr->{class} eq "animestitle";
         	  }
            elsif ($tagname eq "div")
            {
                $self->{insideSynopsis} = 1 if $attr->{class} eq "synopsis";
                $self->{insideAlternate} = 1 if $attr->{class} eq "alternate";
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

        return if ($self->{parsingEnded});

        return if length($origtext) < 2;
           
        if ($self->{parsingList})
        {
            if ($self->{inside}->{script})
            {
                if ($origtext =~ /document\.location\.href="(.*?)"/)
                {
                    $self->{itemIdx} = 0;
                    $self->{itemsList}[0]->{url} = $1;
                }
                return;
            }
            
            if ($self->{isMovie})
            {
                $self->{itemsList}[$self->{itemIdx}]->{"title"} = $origtext;
                $self->{isMovie} = 0;
                $self->{isInfo} = 1;
                return;
            }
			elsif ($self->{isYear})
			{
                $origtext =~ s/ : ([0-9]{4}) - [0-9]*\s*[A-Z]*/$1/;
                $self->{itemsList}[ $self->{itemIdx} ]->{date} = $origtext;
                $self->{isYear} = 0;
			}
			elsif ($self->{inside}->{u})
			{
                $self->{isYear} = 1 if $origtext =~ /Ann.e \/ nombre et format/;
			}
        }
       	else
        {
            $origtext =~ s/\s{2,}//g;
            
            if ($self->{insideInfos})
            {
                $origtext =~ s/(.*), $/$1/;
                if ($origtext =~ /TITRE ORIGINAL : (.*)/)
                {
                    $self->{curInfo}->{original} = $1;
                }
                elsif ($origtext =~ /AUTEUR(?:S)? : (.*)/)
                {
                    $self->{curInfo}->{director} = $self->capWord($1);
                }
                elsif (($origtext =~ /VOLUMES, TYPE . DUR.E : (.*)/)
                    || ($origtext =~ /TYPE . DUR.E : (.*)/))
                {
                    $self->{curInfo}->{time} = $self->capWord($1);
                }
                elsif ($origtext =~ /ANN.E DE PRODUCTION : (.*)/)
                {
                    $self->{curInfo}->{date} = $self->capWord($1);
                }
                elsif ($origtext =~ /GENRE(?:S)? :/)
                {
                    $origtext =~ s/(?:, )|(?: & )/,/g;
                    $origtext =~ /GENRE(?:S)? : (.*)/;
                    $self->{curInfo}->{genre} = $self->capWord($1);
                }
                $self->{insideInfos} = 0;
            }
            elsif ($self->{insideName})
            {
                if ($origtext =~ /(.*?)( \(([0-9]{4})\))?$/)
                {
                    $self->{curInfo}->{title} = $1;
                    $self->{curInfo}->{date} = $3;
                }
                $self->{insideName} = 0;
            }
            elsif ($self->{insideSynopsis})
            {
                $origtext =~ s/\[br\]/\n/g;
                $origtext =~ s/\[endline\]//g;
                $self->{curInfo}->{synopsis} = $origtext;
                $self->{insideSynopsis} = 0;
            }
            elsif ($self->{insideAlternate})
            {
                $origtext =~ s/\[br\]/\n/g;
                $origtext =~ s/\[endline\]//g;
                $self->{curInfo}->{original} = $origtext if ! $self->{curInfo}->{original};
                $self->{insideAlternate} = 0;
            }
        }
    } 

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);

        $self->{hasField} = {
            title => 1,
            date => 1,
            director => 0,
            actors => 0,
        };

        $self->{isInfo} = 0;
        $self->{isMovie} = 0;
        $self->{curName} = undef;
        $self->{curUrl} = undef;

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        $self->{parsingEnded} = 0;

        $html =~ s/&nbsp;/ /g;
        $html =~ s/&amp;/&/g;
        $html =~ s/<b>|<\/b>//g;
        $html =~ s/<i>|<\/i>//g;
        $html =~ s/<br \/>/\[br\]/g;
        $html =~ s/\n/\[endline\]/g;
        $html =~ s/<span style="background:#CBD1DD;">([^<]*)<\/span>/$1/g;
        $html =~ s/\[<a href="\/animes\/(?:studios|genres|pers)\/.*?\.html">([^<]*)<\/a>\] /$1, /g;
        $html =~ s/<a href="\/avis\/index.html"[^>]*>([^<]*)<\/a>/$1/g;
        $html =~ s/<td [^>]*>Synopsis<\/td><\/tr><tr><td [^>]*><table [^>]*><tr><td [^>]*>(.*?)<\/td><\/tr><\/table><\/td>/<div class="synopsis">$1<\/div>/;
        $html =~ s/<td [^>]*>Titre alternatif<\/td><\/tr><tr><td [^>]*><table [^>]*><tr><td [^>]*>(.*?)<\/td><\/tr><\/table><\/td>/<div class="alternate">$1<\/div>/;

        return $html;
    }
    
    sub getSearchUrl
    {
		my ($self, $word) = @_;
	
        return "http://www.animeka.com/search/index.html?req=$word&zone_series=1&go_search=1&cat=search";
    }
    
    sub getItemUrl
    {
		my ($self, $url) = @_;
		
        return "http://www.animeka.com" . $url;
    }

    sub getName
    {
        return "Animeka.com";
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
        return "ISO-8859-1";
    }

}

1;
