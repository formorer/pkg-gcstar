package GCPlugins::GCfilms::GCCinemaClock;

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

use GCPlugins::GCfilms::GCfilmsCommon;

{

    package GCPlugins::GCfilms::GCPluginCinemaClock;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;

        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
            if ($tagname eq "a")
            {
                if ($attr->{href} =~
/http\:\/\/www\.CinemaClock\.com\/aw\/crva\.aw\/p\.clock\/r\.que\/m\.Montreal\/j\.f\/i\./
                  )
                {
                    my $url = $attr->{href};
                    $url =~ s/http\:\/\/www\.CinemaClock\.com(.*)/$1/;
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
                if ($self->{curInfo}->{image} !~ /^\/images\/dvd\//)
                {
                    if ($attr->{src} =~ /^\/images\/dvd\/med\/(.*)\.gif/)
                    {
                        $self->{curInfo}->{image} =
                          "http://www.cinemaclock.com/images/dvd/" . $1 . ".jpg";
                    }
                    elsif ($attr->{src} =~ /^\/images\/dvd\//)
                    {
                        $self->{curInfo}->{image} =
                          "http://www.cinemaclock.com" . $attr->{src};
                    }
                    elsif ($attr->{src} =~ /^\/images\/posters\//)
                    {
                        $self->{curInfo}->{image} =
                          "http://www.cinemaclock.com" . $attr->{src};
                    }
                    elsif ($attr->{src} =~ /^\/images\//)
                    {
                        $self->{curInfo}->{image} =
                          "http://www.cinemaclock.com" . $attr->{src}
                          if !$self->{curInfo}->{image};
                    }
                }
            }
            elsif ($tagname eq "div")
            {
                $self->{insideInfos} = 1 if $attr->{class} eq "informations";
                $self->{insideName}  = 1 if $attr->{class} eq "movietitle";
            }
            elsif ($tagname eq "p")
            {
                $self->{insideSynopsis} = 1 if $attr->{style} eq "text-align: justify";
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
                $self->{itemsList}[ $self->{itemIdx} ]->{"title"} =
                  $self->capWord($origtext);
                $self->{isMovie} = 0;
                $self->{isInfo}  = 1;
                return;
            }
            elsif ($origtext =~ /\(([0-9]{4})\)/)
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{date} = $1;
            }
        }
        else
        {
            $origtext =~ s/\s{2,}//g;

            if ($self->{insideInfos})
            {
                if ($origtext =~ /Ann.e\:.(.*)/)
                {
                    $self->{curInfo}->{date} = $1;
                }
                elsif ($origtext =~ /Pays\:.(.*)/)
                {
                    $self->{curInfo}->{country} = $1;
                }
                elsif ($origtext =~ /Genre\:.(.*)/)
                {
                    $self->{curInfo}->{genre} = $self->capWord($1);
                    $self->{curInfo}->{genre} =~ s/, /,/g;
                }
                elsif ($origtext =~ /Dur.e\:.(.*)/)
                {
                    $self->{curInfo}->{time} = $1;
                }
                elsif ($origtext =~ /R.alis..par\:.(.*)/)
                {
                    $self->{curInfo}->{director} = $1;
                }
                elsif ($origtext =~ /En.vedette\:.(.*)/)
                {
                    $self->{curInfo}->{actors} = $1;
                }
                elsif ($origtext =~ /Classement\:.(.*)/)
                {
                    $self->{curInfo}->{age} = 2  if $origtext =~ /G/;
                    $self->{curInfo}->{age} = $1 if $origtext =~ /([0-9]+)/;
                }
                elsif ($origtext =~ /Guide.parental\:.(.*)/)
                {
                    $self->{curInfo}->{age} = 5 if $self->{curInfo}->{age} == 2;
                }
                $self->{insideInfos} = 0;
            }
            elsif ($self->{insideName})
            {
                $origtext =~ s/"//g;
                $self->{curInfo}->{title} = $origtext;
                $self->{insideName} = 0;
            }
            elsif ($self->{insideSynopsis})
            {
                $self->{curInfo}->{synopsis} = $origtext;
                $self->{insideSynopsis} = 0;
            }
            elsif ($origtext =~ /Version fran.aise de(.*)/)
            {
                $self->{curInfo}->{original} = $1;
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

        #<<< keep perltidy away
        $html =~ s{<b>|</b>}{}g;
        $html =~ s{<a href="/aw/cpea\.aw/p\.clock/r\.que/m\.Montreal/j\.f/i\.[0-9]*/a\.[^"]*">([^<]*)</a>}
                  {$1}g;
        $html =~ s{<span class=arialb2>([^<]*)</span></td>[^<]*<td><span class=arial2>([^<]*)</span>}
                  {/<div class="informations">$1$2</div>}g;
        $html =~ s{<span class=movietitle>([^<]*)</span>}
                  {<div class="movietitle">$1</div>};
        $html =~ s{<font color=[^>]*>|</font>|<span class=[^>]*>|</span>}
                  {}g;
        #>>>

#        $html =~ s/<a href="\/aw\/cpea\.aw\/p\.clock\/r\.que\/m\.Montreal\/j\.f\/i\.[0-9]*\/a\.[^"]*">([^<]*)<\/a>/$1/g;
#        $html =~ s/<span class=arialb2>([^<]*)<\/span><\/td>[^<]*<td><span class=arial2>([^<]*)<\/span>/<div class="informations">$1$2<\/div>/g;
#        $html =~ s/<span class=movietitle>([^<]*)<\/span>/<div class="movietitle">$1<\/div>/;
#        $html =~ s/<font color=[^>]*>|<\/font>|<span class=[^>]*>|<\/span>//g;

        return $html;
    }

    sub getSearchUrl
    {
        my ($self, $word) = @_;

        return "http://www.cinemaclock.com/aw/csra.aw?"
          . "p=clock&r=que&m=Montreal&j=f&key=$word";
    }

    sub getItemUrl
    {
        my ($self, $url) = @_;

        return "http://www.cinemaclock.com" . $url;
    }

    sub getName
    {
        return "CinemaClock.com";
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
