package GCPlugins::GCfilms::GCAniDB;

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
    package GCPlugins::GCfilms::GCPluginAniDB;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

        if ($self->{parsingEnded})
        {
            if ($tagname eq 'a')
            {
                if ($attr->{href} =~ m/animedb\.pl\?show=animeatt&aid=([0-9]*)/)
                {
                    $self->{itemIdx} = 0;
                    $self->{itemsList}[0]->{url} = "animedb\.pl\?show=anime&aid=" . $1;
                }
            }
            return;
        }

        if ($self->{parsingList})
        {
            if ($tagname eq 'a')
            {
                if ($attr->{href} =~ m/animedb\.pl\?show=anime&aid=[0-9]*/)
                {
                    $self->{isMovie} = 1;
                    $self->{isInfo} = 1;
                    $self->{itemIdx}++ if ($self->{itemIdx} < 0) || ($attr->{href} ne $self->{itemsList}[$self->{itemIdx}]->{url});
                    $self->{itemsList}[$self->{itemIdx}]->{url} = $attr->{href};
                }
            }
            elsif ($tagname eq 'td')
            {
                $self->{isYear} = 1 if ($attr->{class} eq 'date year');
            }
            elsif ($tagname eq 'h1')
            {
                $self->{insideHeadline} = 1;
            }
        }
        else
        {
            if ($tagname eq 'img')
            {
                if ($attr->{src} =~ m/http\:\/\/img[0-9]\.anidb\.info\/pics\/anime\/[0-9]*\.jpg/)
                {
                    $self->{curInfo}->{image} = $attr->{src} if !$self->{curInfo}->{image};
                }
            }
            elsif ($tagname eq 'p')
            {
                if ($attr->{class} eq 'desc')
                {
                    $self->{insideSynopsis} = 1;
                }
            }
            elsif ($tagname eq 'th')
            {
                $self->{isField} = 1 if $attr->{class} eq 'field';
            }
        }
    }

    sub end
    {
		my ($self, $tagname) = @_;

        $self->{inside}->{$tagname}--;
        $self->{insideSynopsis} = 0 if $tagname eq 'p';
    }

    sub text
    {
        my ($self, $origtext) = @_;

        return if ($self->{parsingEnded});
           
        if ($self->{parsingList})
        {
            if ($self->{insideHeadline})
            {
                $self->{parsingEnded} = 1 if $origtext !~ m/Anime List - Search for:/;
                $self->{insideHeadline} = 0;
            }

            if ($self->{isMovie})
            {
                $self->{itemsList}[$self->{itemIdx}]->{title} = $origtext
                    if ! $self->{itemsList}[$self->{itemIdx}]->{title};
                $self->{isMovie} = 0;
                $self->{isInfo} = 1;
                return;
            }
            elsif ($self->{isYear})
            {
                $self->{itemsList}[$self->{itemIdx}]->{date} = $origtext;# if $origtext =~ m/^ [0-9]{4}(-[0-9]{4})? $/;
                $self->{isYear} = 0;
            }
        }
        else
        {
            if ($self->{insideSynopsis})
            {
                $origtext =~ s/\s{2,}/ /g;
                $self->{curInfo}->{synopsis} .= $origtext;
                #$self->{curInfo}->{synopsis} =~ s|GCBRGC|<br>|g;
                #$self->{curInfo}->{synopsis} =~ s/^\s*//;
                $self->{insideSynopsis} = 0;
            }
#            elsif ($self->{inside}->{div})
#            {
#                $self->{curInfo}->{title} = $1 if $origtext =~ m/Title: (.*) /;
#                if ($origtext =~ m/(?:Jap. Kanji|English): (.*) /)
#                {
#                    $self->{curInfo}->{original} = $1;
#                }
#                $self->{curInfo}->{date} = $1 if $origtext =~ m/Year: (.*)/;
#                $self->{curInfo}->{director} = $1 if $origtext =~ m/Companies: (.*) /;
#                if ($origtext =~ m/Genre: (.*)/)
#                {
#                    $self->{curInfo}->{genre} = $1;
#                    $self->{curInfo}->{genre} =~ s/ - //;
#                }
#            }
            elsif ($self->{isField})
            {
                $self->{isTitle} = 1 if $origtext eq 'Title';
                $self->{isOrig} = 1 if $origtext =~ /kanji/i;
                $self->{isYear} = 1 if $origtext eq 'Year';
                $self->{isGenre} = 1 if $origtext eq 'Genre';
                $self->{isField} = 0;
            }
            elsif ($self->{inside}->{td})
            {
                if ($self->{isTitle})
                {
                    $self->{curInfo}->{title} = $origtext;
                    $self->{isTitle} = 0;
                }
                elsif ($self->{isOrig})
                {
                    $self->{curInfo}->{original} = $origtext;
                    $self->{isOrig} = 0;
                }
                elsif ($self->{isYear})
                {
                    $self->{curInfo}->{date} = $origtext;
                    $self->{isYear} = 0;
                }
                elsif ($self->{isGenre})
                {
                    ($self->{curInfo}->{genre} = $origtext) =~ s/\s//g;
                    $self->{curInfo}->{genre} =~ s/-$//;
                    $self->{isGenre} = 0;
                }
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
        $self->{isField} = 0;
        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        $self->{parsingEnded} = 0;

        $html =~ s/<a href="animedb\.pl\?show=producer&prid=[0-9]*" title="[^"]*">([^<]*)<\/a>/$1/g;
        $html =~ s/<a href="animedb\.pl\?show=genre" target="_blank">(Genre:)<\/a>/$1/g;
        $html =~ s/<a href="animedb\.pl\?show=animelist&amp;genid=[^"]*" title="[^"]*">([^<]*)<\/a>/$1/g;
        $html =~ s/ - <a href="animedb\.pl\?show=search&do\.search=1(&search\.anime.genre.[0-9]*=on){1,}" title="search for other animes with all of these genres">\[similar\]<\/a> //;
        #$html =~ s/<td> ([^:]*): <\/td>\s*<td> ([^<]*) ?<\/td>/<div>$1: $2<\/div>/g;
        $html =~ s/<br \/>/\n/g;
        $html =~ s/<b>Awards:<\/b><br><a href="[^"]*" target="_blank"><img src="[^"]*" border=0 alt="[^"]*" title="[^"]*"><\/a> <hr>//g;

        #Removed italic strings (useful for synopsis source)
        $html =~ s|<i>(.*?)</i>|$1|g;
        #Extract synopsis
        #$html =~ s|<td>([^<]*?)</td>\s*?</tr>\s*?</table>\s*?<hr>|<div class="synopsis">$1</div>|ms;
        
        #Remove Headline tag
        $html =~ s/>\W*?<!-- headline -->/>/;
        
        return $html;
    }
    
    sub getSearchUrl
    {
		my ($self, $word) = @_;
	
        return "http://anidb.info/perl-bin/animedb.pl?show=animelist&adb.search=$word";
    }
    
    sub getItemUrl
    {
		my ($self, $url) = @_;
		
        return 'http://anidb.info/perl-bin/' . $url;
    }

    sub getName
    {
        return 'AniDB';
    }
    
    sub getAuthor
    {
        return 'MeV';
    }
    
    sub getLang
    {
        return 'EN';
    }

    sub getCharset
    {
        my $self = shift;
    
        return "UTF-8";
    }

}

1;
