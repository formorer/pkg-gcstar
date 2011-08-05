package GCPlugins::GCfilms::GCImdb;

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
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
###################################################

use strict;

use GCPlugins::GCfilms::GCfilmsCommon;

{

    package GCPlugins::GCfilms::GCPluginImdb;

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
                if (
                    ($url =~ /^\/title\//)
                    #&& (!$attr->{onclick})
                    && (!$self->{alreadyListed}->{$url})
                  )
                {
                    $self->{isMovie} = 1;
                    $self->{isInfo}  = 1;
                    $self->{itemIdx}++;
                    $self->{itemsList}[ $self->{itemIdx} ]->{url} = $url;
                    $self->{alreadyListed}->{$url} = 1;
                }
            }
        }
        else
        {
            if ($tagname eq "img")
            {
#<<<  do not let perltidy touch this
                if ((
                     ($self->{inside}->{a}) && 
                     (($self->{currentHref} =~ m/photogallery/) || ($self->{currentHref} =~ m/posters/)) &&
                     ($attr->{src} !~ /f\d{2}\.gif/) && ($attr->{src} !~ /icon_photos_faded\.gif/)
                   ) ||
                   (
                      (
                        ($self->{curInfo}->{title}) &&
                        (($attr->{alt} eq $self->{curInfo}->{title}) || ($attr->{title} eq $self->{curInfo}->{title}))
                      ) ||
                      (
                        ($self->{curInfo}->{original}) &&
                        ($attr->{alt} eq $self->{curInfo}->{original})
                      )
                   ))
#>>>
                {
                    if (!$self->{curInfo}->{image})
                    {
                        $self->{curInfo}->{image} = $attr->{src};
                        $self->{curInfo}->{image} =~ s/SX[0-9]*_SY[0-9]*/SX1000_SY1000/
                          if ($self->{bigPics});
                    }
                }
            }
            elsif ($tagname eq "a")
            {
                $self->{currentHref} = $attr->{href};
                if ($attr->{href} =~ m/fullcredits/)
                {
                    $self->{insideActors} = 0;
                    $self->{insideRoles}  = 0;
                }
                elsif ($attr->{href} =~ m/certificates=USA:(.+?)&/)
                {
                    $self->{curInfo}->{age} = 1 if ($1 eq 'Unrated') || ($1 eq 'Open');
                    $self->{curInfo}->{age} = 2 if ($1 eq 'G') || ($1 eq 'Approved');
                    $self->{curInfo}->{age} = 5
                      if ($1 eq 'PG') || ($1 eq 'M') || ($1 eq 'GP');
                    $self->{curInfo}->{age} = 13 if $1 eq 'PG-13';
                    $self->{curInfo}->{age} = 17 if $1 eq 'R';
                    $self->{curInfo}->{age} = 18 if ($1 eq 'NC-17') || ($1 eq 'X');
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
                if ($attr->{class} eq 'nm')
                {
                    $self->{insideActors}   = 1;
                    $self->{insideSynopsis} = 0;
                }
                elsif ($attr->{class} eq 'char')
                {
                    $self->{insideRoles} = 1;
                }
            }
        }
    }

    sub end
    {
        my ($self, $tagname) = @_;

        $self->{inside}->{$tagname}--;
        if ($self->{parsingList})
        {
            if ($self->{isMovie} && ($tagname eq 'a'))
            {
                $self->{isMovie} = 0;
                my $url = $self->{itemsList}[ $self->{itemIdx} ]->{url};
                if (!$self->{itemsList}[ $self->{itemIdx} ]->{title})
                {
                    $self->{alreadyListed}->{$url} = 0;
                    $self->{itemIdx}--;
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

        return if ($self->{parsingEnded});

        if ($self->{parsingList})
        {
            if (($self->{inside}->{h1}) && ($origtext !~ m/IMDb\s*Title\s*Search/i))
            {
                $self->{parsingEnded}        = 1;
                $self->{itemIdx}             = 0;
                $self->{itemsList}[0]->{url} = $self->{loadedUrl};
            }
            if ($self->{isMovie})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{title} = $origtext;
                $self->{isMovie}                                = 0;
                $self->{isInfo}                                 = 1;
                return;
            }
            if ($self->{isInfo})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{date} = $1
                  if ($origtext =~ m|\(([0-9]*)(/I+)?\)|);
                $self->{isInfo} = 0;
            }
        }
        else
        {
            $self->{insideNat}         = 0 if ($origtext =~ m/Language:|Color:/);
            $self->{insideOtherTitles} = 0 if ($origtext =~ m/Runtime:|MPAA:/);
            $self->{insideSynopsis}    = 0
              if ($origtext =~ m/(User Comments:)|(User Rating:)|(Plot Keywords:)/);

            if ($self->{inside}->{rating})
            {
                $self->{curInfo}->{ratingpress} = int($origtext + 0.5);
            }

            if ($self->{insideGenre})
            {
                $origtext =~ s/\s*$//;
                $self->{curInfo}->{genre} .= $self->capWord($origtext) . ',';
                $self->{curInfo}->{genre} =~ s|\s*/\s*|,|g;
                $self->{insideGenre} = 0;
            }
            elsif ($self->{insideDirector})
            {
                $origtext =~ s/^\s*//;
                if ($origtext)
                {
                    $self->{curInfo}->{director} = $origtext;
                    $self->{insideDirector} = 0;
                }
            }
            elsif ($self->{insideSynopsis})
            {
                ($self->{curInfo}->{synopsis} .= $origtext) =~ s/^\s*//;
            }
            elsif ($self->{insideNat})
            {
                $self->{curInfo}->{country} .= $origtext;
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
            elsif ($self->{insideOtherTitles})
            {
                if ($origtext =~ m/(.*?) \(International.*/)
                {
                    $self->{curInfo}->{title} = $1;
                    $self->{insideOtherTitles} = 0;
                }
            }
            else
            {
                if ($origtext =~ m{User\s+Rating:\s+(\d+\.\d+)/10\s+})
                {
                    $self->{curInfo}->{ratingpress} = int($1 + 0.5);
                }
            }

            if (($self->{inside}->{title}) || ($self->{inside}->{h1}))
            {
                $self->{curInfo}->{date} = $1 if $origtext =~ m/([0-9]+)/;
                $self->{curInfo}->{date} = $1 if $origtext =~ m/\[(TV-Series.*)\]/;
                if (!$self->{curInfo}->{title})
                {
                    if ($origtext =~ m%^(.*)\s*\([0-9]+(/I+)?\)\s*(\((T?V|mini)\))?$%)
                    {
                        $self->{curInfo}->{title} = $1;
                    }
                    else
                    {
                        $self->{curInfo}->{title} = $origtext;
                    }
                    $self->{curInfo}->{title} =~ s/\s*$//;
                }
            }
            elsif ($self->{inside}->{h5})
            {
                $self->{insideDirector} = 1
                  if ($origtext =~ m/(Directed by|Director)/)
                  && !$self->{curInfo}->{director};
                $self->{insideSynopsis} = 1
                  if ($origtext =~ m/Synopsis:|Plot Summary:|Plot Outline:|Plot:/);
                $self->{insideOtherTitles} = 1 if ($origtext =~ m/Also Known As:/);
                $self->{insideTime} = 1 if $origtext =~ m/Runtime:/;
                $self->{insideNat}  = 1 if $origtext =~ m/Country:/;
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

        $self->{parsingEnded} = 0;

        $html =~ s/"&#34;/'"/g;
        $html =~ s/&#34;"/"'/g;
        $html =~ s|</a></b><br>|</a><br>|;
        $html =~ s{<b>([.0-9]+)/10</b>}{<rating>$1</rating>}gi;
        $html =~ s{</?(?:b|small)>}{}gi;

        if ($self->{parsingList})
        {
            $self->{alreadyListed} = {};
        }
        else
        {
            $html =~ s|<a href="synopsis">[^<]*</a>||gi;
            $html =~ s|<a href="/name/.*?"[^>]*>([^<]*)</a>|$1|gi;
            $html =~ s|<a href="/character/ch[0-9]*/">([^<]*)</a>|$1|gi;
            #$html =~ s|<a href="/Sections/.*?">([^<]*)</a>|$1|gi;

            # Commented out this line, causes bug #14420 when importing from named lists
            #$self->{curInfo}->{actors} = [];
        }

        return $html;
    }

    sub getSearchUrl
    {
        my ($self, $word) = @_;

        return "http://www.imdb.com/find?q=$word;tt=on;mx=20";
    }

    sub getItemUrl
    {
        my ($self, $url) = @_;

        return $url if $url =~ /^http:/;
        return "http://www.imdb.com" . $url;
    }

    sub getName
    {
        return "IMDb";
    }

    sub getAuthor
    {
        return 'Tian';
    }

    sub getLang
    {
        return 'EN';
    }
}

1;
