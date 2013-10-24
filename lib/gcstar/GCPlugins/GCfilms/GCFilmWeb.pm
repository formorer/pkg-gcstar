package GCPlugins::GCfilms::GCFilmWeb;

###################################################
#
#  Copyright 2005-2010 Tian, Michael Mayer
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

    package GCPlugins::GCfilms::GCPluginFilmWeb;

    use LWP::Simple qw($ua);

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;

        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
            if ($self->{parsingEnded})
            {
                if (   ($tagname eq 'input')
                    && ($attr->{name} eq 'id'))
                {
                    $self->{itemIdx} = 0;
                    $self->{itemsList}[0]->{title} = '';
                    $self->{itemsList}[0]->{url} =
                      'http://www.filmweb.pl/Film?id=' . $attr->{value};
                }
            }

            if ($tagname eq 'a')
            {
                if ($attr->{class} eq 'searchResultTitle')
                {
                    $self->{isMovie} = 1;
                    $self->{itemIdx}++;
                    $self->{itemsList}[ $self->{itemIdx} ]->{url} = $attr->{href};
                }
                elsif ($attr->{href} =~ m|/search/film\?countryIds=|)
                {
                    $self->{isCountry} = 1;
                }
            }
            elsif ($tagname eq 'span')
            {
                if ($attr->{class} eq 'searchResultDetails')
                {
                    $self->{isYear} = 1;
                }
            }
        }
        else
        {
            return if ($self->{parsingEnded});

            if ($tagname eq 'strong')
            {
                if ($attr->{class} eq "rating")
                {
                    $self->{isRating} = 1;
                }
            }
            elsif ($tagname eq 'div')
            {
                if ($attr->{class} eq "time")
                {
                    $self->{isTime} = 1;
                }
                elsif ($attr->{class} eq "posterLightbox")
                {
                    $self->{isImage} = 1;
                }
                elsif ($attr->{class} =~ /castListWrapper/)
                {
                    $self->{isCast} = 1;
                }
                elsif ($attr->{class} =~ /additional-info/)
                {
                    $self->{parsingEnded} = 1;
                }
            }
            elsif ($tagname eq 'span')
            {
                if ($attr->{class} eq 'filmDescrBg')
                {
                    $self->{isSynopsis} = 1;
                }
            }
            elsif (($tagname eq 'a') && $self->{isImage})
            {
                # big image
                $self->{curInfo}->{image} = $attr->{href};
            }
            elsif (($tagname eq 'img') && $self->{isImage})
            {
                # small image
                $self->{curInfo}->{image} = $attr->{src}
                  if (!$self->{bigPics});
                $self->{isImage} = 0;
            }
        }
    }

    sub end
    {
        my ($self, $tagname) = @_;

        $self->{inside}->{$tagname}--;

        if ($tagname eq "tr")
        {
                $self->{key} = "";
        }
        
    }

    sub text
    {
        my ($self, $origtext) = @_;

        $origtext =~ s/^\s*//m;
        $origtext =~ s/\s*$//m;

        return if !$origtext;
        return if ($self->{parsingEnded});

        if ($self->{parsingList})
        {

            if ($self->{isMovie})
            {
                if ($self->{inside}->{a})
                {
                    my $title;
                    my $original;
                    ($title, $original) = split (/\s*\/\s*/, $origtext, 2);
                    return if !$title;

                    $self->{itemsList}[ $self->{itemIdx} ]->{title} = $title;
                    $self->{itemsList}[ $self->{itemIdx} ]->{original} = $original;
                    $self->{isMovie} = 0;
                }
            }
            elsif ($self->{isYear})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{date} = $1
                  if $origtext =~ /([0-9]{4})/;
                $self->{isYear} = 0;
            }
            elsif ($self->{isCountry})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{country} .=
                  $self->{itemsList}[ $self->{itemIdx} ]->{country} ? 
                  ", " . $origtext 
                  : $origtext;
                $self->{isCountry} = 0;
            }
        }
        else
        {

            if ($self->{inside}->{title})
            {
                # content of title field is formatted like this:
                # Obcy - 8. pasażer "Nostromo" / Alien (1979) - Filmweb
                # or (if polish title and original title are identical):
                # Batman (1989)  - Filmweb
                $origtext =~ m|(.*)\s+\((\d{4})\)\s+-\s+Filmweb|;
                $self->{curInfo}->{date}     = $2;
                ($self->{curInfo}->{original},
                 $self->{curInfo}->{title})  = split (/\s+\/\s+/, $1, 2);
                if (!$self->{curInfo}->{title})
                {
                    $self->{curInfo}->{title} = $self->{curInfo}->{original};
                }
            }
            elsif ($self->{isRating})
            {
                $origtext =~ s/,/\./;
                $self->{curInfo}->{ratingpress} = int ($origtext + 0.5);
                $self->{isRating} = 0;
            }
            elsif ($self->{isSynopsis})
            {
                $self->{curInfo}->{synopsis} = $origtext;
                $self->{isSynopsis} = 0;
            }
            elsif ($self->{inside}->{th})
            {
                $self->{key} = $origtext;
            }
            elsif ($self->{inside}->{td} && $self->{inside}->{a})
            {
                if ($self->{key} eq "reżyseria:")
                {
                    $self->{curInfo}->{director} .=
                      $self->{curInfo}->{director} ? ", " . $origtext : $origtext;
                }
                if ($self->{key} eq "produkcja:")
                {
                    $self->{curInfo}->{country} .=
                      $self->{curInfo}->{country} ? ", " . $origtext : $origtext;
                }
                if ($self->{key} eq "gatunek:")
                {
                    $self->{curInfo}->{genre} .=
                      $self->{curInfo}->{genre} ? ", " . $origtext : $origtext;
                }
            }
            elsif ($self->{isCast})
            {
                if ($self->{inside}->{h3})
                {
                    push @{$self->{curInfo}->{actors}}, [$origtext]
                      if ($self->{actorsCounter} <
                        $GCPlugins::GCfilms::GCfilmsCommon::MAX_ACTORS);
                    $self->{actorsCounter}++;
                    $self->{isRole} = 1;
                }
                else
                {
                    if ($self->{isRole}
                        && ($self->{actorsCounter} <=
                           $GCPlugins::GCfilms::GCfilmsCommon::MAX_ACTORS))
                    {
                        # As we incremented it above, we have one more
                        # chance here to add a role Without <= we would skip
                        # the role for last actor
                        push @{$self->{curInfo}->{actors}->[ $self->{actorsCounter}-1 ]}, $origtext
                    }
                    $self->{isRole} = 0;
                }
            }
            elsif ($self->{isTime})
            {
                $self->{curInfo}->{time} = $origtext;
                $self->{isTime}          = 0;
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
            country  => 1,
        };

        $self->{isMovie}   = 0;
        $self->{isYear}    = 0;
        $self->{isCountry} = 0;
        $self->{curName}   = undef;	# why?
        $self->{curUrl}    = undef;	# why?

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        $self->{parsingEnded}  = 0;
        $self->{insideResults} = 0;

        if ($self->{parsingList})
        {
            $html =~ s|</?b>||gms;
        }

        return $html;
    }

    sub getSearchUrl
    {
        my ($self, $word) = @_;

        # Grab the home page first to receive a fresh, valid cookie
        my $response = $ua->get('http://www.filmweb.pl/');

        return "http://www.filmweb.pl/search?q=$word&alias=film";
    }

    sub getItemUrl
    {
        my ($self, $url) = @_;

        return $url if $url =~ /^http:/;
        return "http://www.filmweb.pl" . $url;
    }

    sub changeUrl
    {
        my ($self, $url) = @_;

        return $url;
    }

    sub getName
    {
        return 'FilmWeb';
    }

    sub getExtra
    {
        return '';
    }


    sub getCharset
    {
        my $self = shift;

        return 'ISO-8859-2';
    }

    sub getAuthor
    {
        return 'Tian';
    }

    sub getLang
    {
        return 'PL';
    }

    sub getDefaultPictureSuffix
    {
        return '.jpg';
    }
}

1;
