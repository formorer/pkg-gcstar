package GCPlugins::GCfilms::GCIbs;
###################################################
#
#  Copyright 2008 t-storm
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

use GCPlugins::GCfilms::GCfilmsCommon;

{

    package GCPlugins::GCfilms::GCPluginIbs;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;

        $self->{inside}->{$tagname}++;

        if ($self->{parsingEnded})
        {
            return;
            if ($tagname eq "a")
            {
                if ($attr->{href} =~ m/mymovies\/list\?pending\&add=([0-9]*)/)
                {
                    $self->{itemIdx} = 0;
                    $self->{itemsList}[0]->{url} = '/title/tt' . $1 . '/';
                }
            }
            return;
        }

        if ($self->{parsingList})
        {
            if ($tagname eq "a")
            {
                my $url = $attr->{href};
                if (   ($url =~ /^http:\/\/www.ibs.it\/dvd\/[0-9]+\//)
                    && (!$self->{alreadyListed}->{$url}))
                {
                    $self->{isMovie} = 1;
                    $self->{isInfo}  = 1;
                    $self->{itemIdx}++;
                    $self->{itemsList}[ $self->{itemIdx} ]->{url} = $url;
                    $self->{alreadyListed}->{$url} = 1;
                }
            }
            elsif ($tagname eq 'td')
            {
                if ($attr->{class} eq 'ttitolettobianco')
                {
                    $self->{isYear}  = 1;
                    $self->{isMovie} = 0;
                }
            }
        }
        else
        {
            if ($tagname eq "a")
            {
                $self->{currentHref} = $attr->{href};

                if ($attr->{href} =~
m/javascript:Jackopen\('http:\/\/giotto.internetbookshop.it\/cop\/copdjc.asp\?e=([0-9]+)'\)/
                  )
                {
                    $self->{curInfo}->{image} =
                      "http://giotto.internetbookshop.it/cop/copdjc.asp?e=$1";
                }
                if ($attr->{href} =~ m/^\/film\/regista\//)
                {
                    $self->{insideDirector} = 1;
                }
                elsif ($attr->{href} =~ m/^\/film\/attore\//)
                {
                    $self->{insideActors}   = 1;
                    $self->{insideRoles}    = 0;
                    $self->{insideDirector} = 0;
                }
                else
                {
                    $self->{insideSynopsis} = 0 if ($attr->{href} =~ m/plotsummary/);
                    $self->{insideGenre} = 1
                      if ($attr->{href} =~ m|/Sections/Genres/|)
                      && !($self->{curInfo}->{synopsis}
                        || $self->{curInfo}->{country}
                        || $self->{curInfo}->{time});
                }
            }
            elsif ($tagname eq 'td')
            {
                if ($attr->{class} eq 'lbarrasup')
                {
                    $self->{isMovie}        = 1;
                    $self->{insideSynopsis} = 0;
                }
            }
            elsif ($tagname eq "SPAN")
            {
                if ($self->{inside}->{langue})
                {
                    $self->{inside}->{langueLANG}  = 1;
                    $self->{inside}->{langueCODEC} = 0;
                }
            }
        }
    }

    sub end
    {
        my ($self, $tagname) = @_;
        if ($tagname eq "SPAN")
        {
            if ($self->{inside}->{langue})
            {
                $self->{inside}->{langueLANG}  = 0;
                $self->{inside}->{langueCODEC} = 1;
            }
        }

        $self->{inside}->{$tagname}--;

    }

    sub text
    {
        my ($self, $origtext) = @_;

        return if length($origtext) < 2;

        $origtext =~ s/&#34;/"/g;
        $origtext =~ s/&#179;/3/g;
        $origtext =~ s/&#[0-9]*;//g;
        $origtext =~ s/\n//g;

        return if ($self->{parsingEnded});

        if ($self->{parsingList})
        {
            if ($self->{isMovie})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{title} = $origtext;
                $self->{itemsList}[ $self->{itemIdx} ]->{date}  = $self->{listDate};
                $self->{isMovie}                                = 0;
                $self->{isInfo}                                 = 1;
                return;
            }
            if ($self->{isYear})
            {
                $origtext =~ /([0-9]+)/;
                $self->{listDate} = $1;
                $self->{isYear}   = 0;
            }
            if ($self->{isDirector})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{director} = $origtext;
                $self->{isMovie}                                   = 0;
                $self->{isInfo}                                    = 0;
                $self->{isDirector}                                = 0;
                return;
            }
            $self->{isDirector} = 1 if $origtext =~ m/Regia di /;
        }
        else
        {
            $self->{inside}->{langue} = 0 if $origtext =~ m/Lingua sottotitoli/;
            if ($self->{insideGenre})
            {
                $origtext =~ s/\s*$//;
                $self->{curInfo}->{genre} .= $self->capWord($origtext) . ',';
                $self->{curInfo}->{genre} =~ s|\s*/\s*|,|g;
                $self->{insideGenre} = 0;
            }
            elsif ($self->{insideDirector})
            {
                $self->{curInfo}->{director} = $origtext;
                $self->{insideDirector} = 0;
            }
            elsif ($self->{insideSynopsis})
            {
                ($self->{curInfo}->{synopsis} .= $origtext) =~ s/^\s*//;
                $self->{insideSynopsis} = 0;
            }
            elsif ($self->{isCountry})
            {
                $origtext =~ /(.+), (.+)/;
                $self->{curInfo}->{country} .= $1;
                $self->{curInfo}->{date} = $2;
                $self->{isCountry} = 0;
            }
            elsif ($self->{insideTime})
            {
                $self->{curInfo}->{time} = $origtext;
                $self->{curInfo}->{time} =~ s/.*?://;
                $self->{insideTime} = 0;
            }
            elsif ($self->{insideActors})
            {
                push @{$self->{curInfo}->{actors}}, [$origtext]
                  if ($self->{actorsCounter} <
                    $GCPlugins::GCfilms::GCfilmsCommon::MAX_ACTORS);
                $self->{actorsCounter}++;
                $self->{insideActors} = 0;
            }
            elsif ($self->{insideRoles})
            {
                # As we incremented it above, we have one more chance here to add a role
                # Without <= we would skip the role for last actor
                push @{$self->{curInfo}->{actors}->[ $self->{actorsCounter} - 1 ]},
                  $origtext
                  if ($self->{actorsCounter} <=
                    $GCPlugins::GCfilms::GCfilmsCommon::MAX_ACTORS);
                $self->{insideRoles} = 0;
            }
            elsif ($self->{inside}->{langue})
            {
                if ($self->{inside}->{span})
                {
                    $self->{curInfo}->{language} = $origtext;
                }
                else
                {
                    $origtext =~ s/^, //;
                    $origtext =~ s/ - $//;
                    push @{$self->{curInfo}->{audio}},
                      [ $self->{curInfo}->{language}, $origtext ];
                }
            }
            elsif ($self->{inside}->{soustitre})
            {
                my @sottotitoli = split(' - ', $origtext);
                my $subss;
                foreach $subss (@sottotitoli)
                {
                    push @{$self->{curInfo}->{subt}}, [$subss];
                }

                $self->{inside}->{soustitre} = 0;
            }
            elsif ($self->{isMovie})
            {

                if ($self->{isMovie1})
                {
                    $self->{curInfo}->{title} = $origtext;
                    $self->{isMovie1} = 0;
                }
                elsif ($self->{isMovie2})
                {
                    $self->{curInfo}->{original} = $origtext;
                    $self->{isMovie}             = 0;
                    $self->{isMovie2}            = 0;
                }
            }
            else
            {
                if ($origtext =~ m{User\s+Rating:\s+(\d+\.\d+)/10\s+})
                {
                    $self->{curInfo}->{ratingpress} = int($1 + 0.5);
                }
                ;    # if
            }
            ;        # if

            if ($origtext eq "Titolo")
            {
                $self->{isMovie1} = 1;
                $self->{isMovie2} = 0;
            }
            elsif ($origtext eq "Titolo originale")
            {
                $self->{isMovie1} = 0;
                $self->{isMovie2} = 1;
            }
            elsif ($origtext eq "Paese, Anno")
            {
                $self->{isCountry} = 1;
            }
            elsif ($origtext eq "Dati tecnici")
            {
                $self->{insideTime} = 1;
            }
            elsif ($origtext eq "Genere")
            {
                $self->{insideGenre} = 1;
            }
            elsif ($origtext eq "Descrizione")
            {
                $self->{insideSynopsis} = 1;
            }
            elsif ($origtext =~ m/Vietato ai minori di ([0-9]+) anni/)
            {
                $self->{curInfo}->{age} = $1;
            }
            elsif ($origtext eq "Lingua audio")
            {
                $self->{inside}->{langue} = 1;
            }
            elsif ($origtext eq "Lingua sottotitoli")
            {
                $self->{inside}->{langue}    = 0;
                $self->{inside}->{soustitre} = 1;
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

        $self->{parsingEnded} = 0;

        $html =~ s/"&#34;/'"/g;
        $html =~ s/&#34;"/"'/g;
        $html =~ s|</a></b><br>|</a><br>|;
        $html =~ s{</?(?:b|small)>}{}gi;

        if ($self->{parsingList})
        {
            $self->{alreadyListed} = {};
        }
        else
        {
            $html =~ s|<a href="synopsis">[^<]*</a>||gi;
            $html =~ s|<a href="/name/.*?">([^<]*)</a>|$1|gi;
            $html =~ s|<a href="/character/ch[0-9]*/">([^<]*)</a>|$1|gi;
            #$html =~ s|<a href="/Sections/.*?">([^<]*)</a>|$1|gi;
            $self->{curInfo}->{actors} = [];
        }

        return $html;
    }

    sub getSearchUrl
    {
        my ($self, $word) = @_;

        return "http://www.ibs.it/dvd/ser/serpge.asp?ty=kw&dh=100&SEQ=Q&T=$word";
    }

    sub getItemUrl
    {
        my ($self, $url) = @_;

        return $url if $url =~ /^http:/;
        return "http://www.ibs.it" . $url;
    }

    sub getName
    {
        return "Internet Bookshop";
    }

    sub getAuthor
    {
        return 't-storm';
    }

    sub getLang
    {
        return 'IT';
    }

}

1;
