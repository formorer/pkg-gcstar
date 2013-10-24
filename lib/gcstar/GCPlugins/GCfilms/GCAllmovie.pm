package GCPlugins::GCfilms::GCAllmovie;

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

use GCPlugins::GCfilms::GCfilmsCommon;

{

    package GCPlugins::GCfilms::GCPluginAllmovie;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;

        $self->{inside}->{$tagname}++;

        if ($self->{parsingEnded})
        {
            return;
        }

        if ($self->{parsingList})
        {
            if (($tagname eq "a") && ($self->{isFilm}))
            {
                my $url = $attr->{href};
                $self->{isMovie} = 1;
                $self->{isInfo}  = 1;
                $self->{itemIdx}++;
                $self->{itemsList}[ $self->{itemIdx} ]->{url} = $url;
                $self->{isFilm} = 0;
            }
            if ($tagname eq "td")
            {
                if ($attr->{style} =~ m/284px/)
                {
                    $self->{isFilm} = 1;
                }
                elsif ($attr->{style} =~ m/70px/)
                {
                    $self->{isYear} = 1;
                }
                elsif ($attr->{style} =~ m/190px/)
                {
                    $self->{isDirector} = 1;
                }
            }
            elsif ($tagname eq "tr")
            {
                $self->{isFound} = 1;
            }
            elsif ($tagname eq "title")
            {
                $self->{insideHTMLtitle} = 1;
            }
        }
        else
        {
            if (($tagname eq "span") && ($attr->{class} eq "title"))
            {
                $self->{insideTitle} = 1;
            }
            elsif (
                ($tagname eq "div")
                && (   ($attr->{id} eq "left-sidebar-title")
                    || ($attr->{id} eq "left-sidebar-title-small"))
              )
            {
                $self->{insideLeftSidebarTitle} = 1;
            }
            elsif ($tagname eq "a")
            {
                if ($attr->{href} =~ m/sql=B/)
                {
                    $self->{insideActors} = 1;
                }
                elsif ($self->{insideDirectorList})
                {
                    $self->{insideDirector} = 1;
                }
                elsif ($self->{insideYearRuntime})
                {
                    $self->{insideYear}        = 1;
                    $self->{insideYearRuntime} = 0;
                }
                elsif ($self->{insideCountriesRating})
                {
                    $self->{insideCountry}         = 1;
                    $self->{insideCountriesRating} = 0;
                }
                elsif ($self->{nextIsSeries})
                {
                    $self->{insideSeries} = 1;
                    $self->{nextIsSeries} = 0;
                }
            }
            elsif ($tagname eq "img")
            {
                if ($attr->{src} =~ /http\:\/\/image\.allmusic\.com/)
                {
                    $self->{curInfo}->{image} = ($attr->{src});
                }
                elsif ($self->{insideRatingStars})
                {
                    $attr->{title} =~ /([\d\.]+) Stars/;
                    $self->{curInfo}->{ratingpress} = $1 * 2;
                    $self->{insideRatingStars} = 0;
                }
            }
            elsif ($tagname eq "li")
            {
                if ($self->{insideGenreList})
                {
                    $self->{insideGenre} = 1;
                }
            }
            elsif ($tagname eq "td")
            {
                if (   ($self->{insideAKA})
                    && ($attr->{class} =~ m/formed-sub/))
                {
                    $self->{insideOtherTitles} = 1;
                }
                elsif ($self->{nextIsRating})
                {
                    $self->{insideRating} = 1;
                    $self->{nextIsRating} = 0;
                }
                elsif ($self->{nextIsRuntime})
                {
                    $self->{insideTime}    = 1;
                    $self->{nextIsRuntime} = 0;
                }
                elsif ($attr->{colspan} == 2)
                {
                    if ($attr->{class} eq "large-list-title")
                    {
                    }
                    else
                    {
                        $self->{insideSynopsis} = 1;
                    }
                }
                elsif ($attr->{class} eq "rating-stars")
                {
                    $self->{insideRatingStars} = 1;
                }
            }
        }
    }

    sub end
    {
        my ($self, $tagname) = @_;

        $self->{inside}->{$tagname}--;

        if ($tagname eq "td")
        {
            $self->{insideSynopsis} = 0;
        }
        if ($tagname eq "div")
        {
            $self->{insideLeftSidebarTitle} = 0;
        }
        if ($tagname eq "table")
        {
            $self->{insideGenreList} = 0;
            $self->{insideAKA}       = 0;
            $self->{curInfo}->{original} =~ s/(, )$//;
        }
    }

    sub text
    {
        my ($self, $origtext) = @_;
        return if ((length($origtext) == 0) || ($origtext eq " "));

        $origtext =~ s/&#34;/"/g;
        $origtext =~ s/&#179;/3/g;
        $origtext =~ s/&#[0-9]*;//g;
        $origtext =~ s/\n//g;

        return if ($self->{parsingEnded});

        if ($self->{parsingList})
        {
            if (($self->{insideHTMLtitle}))
            {
                if ($origtext !~ m/Results/)
                {
                    $self->{parsingEnded}        = 1;
                    $self->{itemIdx}             = 0;
                    $self->{itemsList}[0]->{url} = $self->{loadedUrl};
                }
                $self->{insideHTMLtitle} = 0;
            }
            if ($self->{isMovie})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{title} = $origtext;
                $self->{isMovie}                                = 0;
                $self->{isInfo}                                 = 1;
                return;
            }
            if ($self->{isYear})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{date} = $origtext
                  if $origtext =~ m/^[0-9]{4}?/;
                $self->{isYear} = 0;
            }
            if ($self->{isDirector})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{director} = $origtext;
                $self->{isDirector} = 0;
            }
            if ($self->{isInfo})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{date} = $1
                  if $origtext =~ m|\(([0-9]*)(/I+)?\)|;
                $self->{isInfo} = 0;
            }
        }
        else
        {
            if ($self->{insideLeftSidebarTitle})
            {
                if ($origtext eq "Genres")
                {
                    $self->{insideGenreList}        = 1;
                    $self->{insideLeftSidebarTitle} = 0;
                }
                elsif ($origtext eq "Director")
                {
                    $self->{insideDirectorList}     = 1;
                    $self->{insideLeftSidebarTitle} = 0;
                }
                elsif ($origtext eq "Year")
                {
                    $self->{insideYearRuntime}      = 1;
                    $self->{insideLeftSidebarTitle} = 0;
                }
                elsif ($origtext eq "Countries")
                {
                    $self->{insideCountriesRating}  = 1;
                    $self->{insideLeftSidebarTitle} = 0;
                }
                elsif ($origtext eq "AKA")
                {
                    $self->{insideAKA}              = 1;
                    $self->{insideLeftSidebarTitle} = 0;
                }
            }
            elsif ($origtext =~ /Is part of the series:$/)
            {
                $self->{nextIsSeries} = 1;
            }
            if ($self->{insideActors})
            {
                $self->{curInfo}->{actors} .= $origtext . ', '
                  if ($self->{actorsCounter} < $GCPlugins::GCfilms::GCfilmsCommon::MAX_ACTORS);
                $self->{actorsCounter}++;
                $self->{insideActors} = 0;
            }

            if ($self->{insideYear})
            {
                $self->{curInfo}->{date} = $origtext;
                $self->{insideYear}      = 0;
                $self->{nextIsRuntime}   = 1;
            }
            if ($self->{insideTitle})
            {
                $self->{curInfo}->{title} = $origtext;
                $self->{insideTitle} = 0;
            }
            elsif ($self->{insideGenre})
            {
                $self->{curInfo}->{genre} .= $self->capWord($origtext) . ',';
                $self->{insideGenre} = 0;
            }
            elsif ($self->{insideDirector})
            {
                $self->{curInfo}->{director} = $origtext;
                $self->{insideDirector}      = 0;
                $self->{insideDirectorList}  = 0;
            }
            elsif ($self->{insideSynopsis})
            {
                $self->{curInfo}->{synopsis} .= $origtext;
            }
            elsif ($self->{insideCountry})
            {
                $self->{curInfo}->{country} = $origtext;
                $self->{insideCountry}      = 0;
                $self->{nextIsRating}       = 1;
            }
            elsif ($self->{insideTime})
            {
                $self->{curInfo}->{time} = $origtext;
                $self->{curInfo}->{time} =~ s/.[0-9]*?://;
                $self->{insideTime} = 0;
            }
            elsif ($self->{insideRating})
            {
                $self->{curInfo}->{age} = 1
                  if ($origtext eq 'Unrated') || ($origtext eq 'Open');
                $self->{curInfo}->{age} = 2
                  if ($origtext eq 'G') || ($origtext eq 'Approved');
                $self->{curInfo}->{age} = 5
                  if ($origtext eq 'PG') || ($origtext eq 'M') || ($origtext eq 'GP');
                $self->{curInfo}->{age} = 13 if $origtext eq 'PG13';
                $self->{curInfo}->{age} = 17 if $origtext eq 'R';
                $self->{curInfo}->{age} = 18
                  if ($origtext eq 'NC17') || ($origtext eq 'X');
                $self->{insideRating} = 0;
            }
            elsif ($self->{insideOtherTitles})
            {
                $self->{tempOriginal} = $origtext;
                $self->{tempOriginal} =~ s/\s*$//;
                $self->{tempOriginal} =~ s/^\s*//;

                $self->{curInfo}->{original} .= $self->{tempOriginal} . ', ';
                $self->{insideOtherTitles} = 0;
            }
            elsif ($self->{insideSeries})
            {
                $self->{curInfo}->{serie} = $origtext;
                $self->{curInfo}->{serie} =~ s/( \[.*\])//;
                $self->{insideSeries} = 0;
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

        return $html;
    }

    sub getSearchUrl
    {
        my ($self, $word) = @_;

        my $wordFiltered = $word;

        # Allmovie doesn't return correct results if searching with a prefix like 'the'
        $wordFiltered =~ s/^(the|a)?[+\s]+[^ a-zA-Z0-9]*\s*//i;
#    return ('http://allmovie.com/search/all', ['q' => $wordFiltered,'submit' => 'SEARCH']);
        return ('http://allmovie.com/search/all/' . $wordFiltered);

    }

    sub getItemUrl
    {
        my ($self, $url) = @_;
        return $url if $url =~ /^http:/;
        return "http://allmovie.com" . $url;
    }

    sub getName
    {
        return "Allmovie";
    }

    sub getAuthor
    {
        return 'Zombiepig';
    }

    sub getLang
    {
        return 'EN';
    }

}

1;
