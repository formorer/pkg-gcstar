package GCPlugins::GCfilms::GCAllocine;

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
use utf8;

use GCPlugins::GCfilms::GCfilmsCommon;

{

    package GCPlugins::GCfilms::GCPluginAllocine;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
            if ($self->{insideResults} eq 1)
            {
                if (   ($tagname eq "a")
                    && ($attr->{href} =~ /^\/film\/fichefilm_gen_cfilm=/)
                    && ($self->{isMovie} eq 0))
                {
                    my $url = $attr->{href};
                    $self->{isMovie} = 1;
                    $self->{isInfo}  = 0;
                    $self->{itemIdx}++;
                    $self->{itemsList}[ $self->{itemIdx} ]->{url} = $url;
                }
                elsif (($tagname eq "td") && ($self->{isMovie} eq 1))
                {
                    $self->{isMovie} = 2;
                }
                elsif (($tagname eq "a") && ($self->{isMovie} eq 2))
                {
                    $self->{isMovie} = 3;
                }
                elsif (($tagname eq "br") && ($self->{isMovie} eq 3))
                {
                    $self->{itemsList}[ $self->{itemIdx} ]->{title} =~ s/^\s*//;
                    $self->{itemsList}[ $self->{itemIdx} ]->{title} =~ s/\s*$//;
                    $self->{itemsList}[ $self->{itemIdx} ]->{title} =~ s/\s+/ /g;
                    $self->{isMovie} = 4;
                }
                elsif (($tagname eq "span")
                    && ($attr->{class}   eq "fs11")
                    && ($self->{isMovie} eq 4))
                {
                    $self->{isInfo}  = 1;
                    $self->{isMovie} = 0;
                }
                elsif (($tagname eq "br") && ($self->{isInfo} eq 1))
                {
                    $self->{isInfo} = 2;
                }
                elsif (($tagname eq "br") && ($self->{isInfo} eq 2))
                {
                    $self->{isInfo} = 3;
                }
            }
        }
        else
        {
            if (($tagname eq "span") && ($self->{insideDate} eq 1))
            {
                $self->{insideDate} = 2;
            }
            elsif (($tagname eq "a") && ($self->{insideDirector} eq 1))
            {
                $self->{insideDirector} = 2;
            }
            elsif (($tagname eq "a") && ($self->{insideDate} eq 1))
            {
                $self->{insideDate} = 2;
            }
            elsif (($tagname eq "a") && ($self->{insideGenre} eq 1))
            {
                $self->{insideGenre} = 2;
            }
            elsif (($tagname eq "em") && ($self->{insideOriginal} eq 1))
            {
                $self->{insideOriginal} = 2;
            }
            elsif (($tagname eq "a") && ($self->{insideCountry} eq 1))
            {
                $self->{insideCountry} = 2;
            }
            elsif (($tagname eq "div") && ($attr->{class} eq "poster"))
            {
                $self->{insidePicture} = 1;
            }
            elsif (($tagname eq "img") && ($self->{insidePicture} == 1))
            {
                my $src = $attr->{src};
                if (!$self->{curInfo}->{image})
                {
                    # http://www.allocine.fr/film/fichefilm_gen_cfilm=17811.html
                    if (($src =~ /r_160_214/) && !($src =~ /AffichetteAllocine\.gif/i))
                    {
                        ($src =~ s/r_160_214/r_760_x/g)
                            if $self->{bigPics};
                        $self->{curInfo}->{image} = $src;
                    }
                    else
                    {
                        $self->{curInfo}->{image} = "empty";
                    }
                }
            }
            elsif ($tagname eq "actors")
            {
                $self->{insideActors} = 1;
                $self->{insideCast}   = 0;
                $self->{insideActor}  = 0;
                $self->{insideRole}   = 0;
            }
            elsif (($tagname eq "h2") && ($self->{insideActors}))
            {
                $self->{insideCast} = 1;
            }
            elsif (($tagname eq "h3") && ($self->{insideCast} == 1))
            {
                $self->{insideActor} = 1;
            }
            elsif (($tagname eq "p") && ($self->{insideCast} == 1))
            {
                $self->{insideRole} = 1;
            }
            elsif (($tagname eq "table")
                && ($attr->{class} =~ /castingdata/)
                && ($self->{insideActors}))
            {
                # Alternate way the page lists cast
                $self->{insideCast} = 2;
            }
            elsif (($tagname eq "td") && ($self->{insideCast} == 2))
            {
                $self->{insideRole} = 2;
            }
            elsif (($tagname eq "a") && ($self->{insideCast} == 3))
            {
                $self->{insideActor} = 2;
            }
            elsif (($tagname eq "br") && ($self->{insideSynopsis} == 2))
            {
                $self->{curInfo}->{synopsis} .= "\n";
            }

        }
    }

    sub end
    {
        my ($self, $tagname) = @_;
        $self->{inside}->{$tagname}--;

        if (($tagname eq "span") && ($self->{insideSynopsis} eq 1))
        {
            $self->{insideSynopsis} = 2;
        }
        elsif ($tagname eq "span")
        {
            $self->{insideDirector} = 0;
        }
        elsif (($tagname eq "div") && ($self->{insidePressRating} eq 1))
        {
            # http://www.allocine.fr/film/fichefilm_gen_cfilm=5947.html
            $self->{insidePressRating} = 0;
            # http://www.allocine.fr/film/fichefilm_gen_cfilm=112274.html :
            # Director become Gregory HoblitconnectClothilde-Mathilde
            # Because of "Dans les blogs" containing "Réalisé par"
            $self->{insideInfo} = 0;
        }
        elsif ($tagname eq "div")
        {
            $self->{insidePicture} = 0;
        }
        elsif ($tagname eq "table")
        {
            $self->{insideResults} = 0;
        }

        elsif ($tagname eq "actors")
        {
            $self->{insideActors} = 0;
            $self->{insideCast}   = 0;
            $self->{insideActor}  = 0;
            $self->{insideRole}   = 0;
        }
        elsif ((($tagname eq "div") || ($tagname eq "table")) && ($self->{insideCast}))
        {
            $self->{insideCast} = 0;
        }
        elsif (($tagname eq "tr") && ($self->{insideCast} > 1))
        {
            $self->{insideActor} = 0;
            $self->{insideRole}  = 0;
        }
        elsif (($tagname eq "a") && ($self->{insideActor}))
        {
            $self->{insideActor} = 0;
        }
        elsif ($tagname eq "p")
        {
            if ($self->{insideRole})
            {
                $self->{insideRole} = 0;
            }
            elsif ($self->{insideSynopsis})
            {
                $self->{insideSynopsis} = 0;
            }
        }
    }

    sub text
    {
        my ($self, $origtext) = @_;

        if ($self->{parsingList})
        {
            if (($origtext =~ m/(\d+) r..?sultats? trouv..?s? dans les titres de films/) && ($1 > 0))
            {
                $self->{insideResults} = 1;
            }
            if ($self->{isMovie} eq 3)
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{title} .= $origtext;
            }
            if ($self->{isInfo} eq 1)
            {
                if ($origtext =~ /\s*([0-9]{4})/)
                {
                    $self->{itemsList}[ $self->{itemIdx} ]->{date} = $1;
                }
            }
            elsif ($self->{isInfo} eq 2)
            {
                if ($origtext =~ /^\s*de (.*)/)
                {
                    $self->{itemsList}[ $self->{itemIdx} ]->{director} = $1;
                }
            }
            elsif ($self->{isInfo} eq 3)
            {
                if (   ($origtext =~ m/^\s*avec (.*)/)
                    && (!$self->{itemsList}[ $self->{itemIdx} ]->{actors}))
                {
                    $self->{itemsList}[ $self->{itemIdx} ]->{actors} = $1;
                }
                $self->{isInfo} = 0;
            }
        }
        else
        {
            $origtext =~ s/[\r\n]//g;
            $origtext =~ s/^\s*//;
            $origtext =~ s/\s*$//;
            if (length($origtext) < 1)
            {
                $self->{insideGenre} = 0;
            }
            elsif (($self->{inside}->{h1}) && !($self->{inside}->{script}))
            {
                $self->{curInfo}->{title} = $origtext;
                $self->{insideInfo} = 1;
            }
            elsif ($self->{insideInfo} eq 1) {
                if (($self->{insideDate} eq 2) && (length($origtext) > 1))
                {
                    # http://www.allocine.fr/film/fichefilm_gen_cfilm=140683.html
                    $self->{curInfo}->{date} = $origtext
                      if !($origtext =~ /inconnu/);
                    $self->{insideDate} = 0;
                }
                elsif (($origtext =~ /^Date de sortie/)
                    && (!$self->{curInfo}->{date}))
                {
                    $self->{insideDate} = 1;
                }
                elsif (($origtext =~ /^Date de reprise/)
                    && (!$self->{curInfo}->{date}))
                {
                    $self->{insideDate} = 1;
                }
                elsif ($self->{insideDirector} eq 2)
                {
                    $origtext = ", " if $origtext =~ m/^,/;
                    $self->{curInfo}->{director} .= $origtext;
                }
                elsif ($origtext =~ /^R..?alis..? par/)
                {
                    $self->{insideDirector} = 1;
                }
                elsif ($self->{insideOriginal} eq 2)
                {
                    $self->{curInfo}->{original} = $origtext;
                    $self->{insideOriginal} = 0;
                }
                elsif ($origtext =~ /^Titre original/)
                {
                    $self->{insideOriginal} = 1;
                }
                # http://www.allocine.fr/film/fichefilm_gen_cfilm=46940.html
                elsif ($origtext =~ /^Interdit aux moins de (\d+) ans/)
                {
                    $self->{curInfo}->{age} = $1;
                }
                elsif ($origtext =~ m/^[\s\n]*Dur..?e[\s\n]*:[\s\n]*(\S+)(.*)Ann/)
                {
                    $self->{insideGenre} = 0;
                    my $time = $1;
                    $time =~ /(?:(\d+)h)?(\d+)min/;
                    $self->{curInfo}->{time} = $1 * 60 + $2 . " ($time)";
                    
                    # http://www.allocine.fr/film/fichefilm_gen_cfilm=140683.html
                    # A bit different, 2 info in the same tag
                    if (!$self->{curInfo}->{date} && ($origtext =~ /Ann..?e de production/)) {
                        $self->{insideDate} = 1;
                    }
                }
                elsif ($self->{insideGenre} eq 2)
                {
                    $origtext = ";" if $origtext =~ m/^,/;
                    $self->{curInfo}->{genre} .= $origtext;
                }
                elsif ($origtext =~ /^[\s\n]*Genre/)
                {
                    $self->{insideCountry} = 0;
                    $self->{insideGenre}   = 1;
                }
                elsif ($self->{insideCountry} eq 2)
                {
                    if ($origtext ne '.')
                    {
                        $origtext = ", " if $origtext =~ m/^,/;
                        $self->{curInfo}->{country} .= $origtext;
                    }
                }
                # http://www.allocine.fr/film/fichefilm_gen_cfilm=140683.html
                elsif ($origtext =~ /(Court|Long)-m..?trage/)
                {
                    $self->{insideCountry} = 1;
                }
                elsif ($self->{insideSynopsis} eq 2)
                {
                    $self->{curInfo}->{synopsis} .= $origtext;
                }
                elsif (($origtext =~ /^Synopsis ./) && !($self->{curInfo}->{synopsis}))
                {
                    $self->{insideSynopsis} = 1;
                }
                elsif ($origtext =~ /^Presse$/)
                {
                    $self->{insidePressRating} = 1;
                }
                elsif (($origtext =~ /^\((.*)\)/) && ($self->{insidePressRating} == 1))
                {
                    my $rating = $1;
                    $rating =~ s/,/\./g;
                    $self->{curInfo}->{ratingpress} = $rating * 2;
                }
            }
            elsif ($self->{insideActor} == 1)
            {
                # Actors from casting page
                $self->{curInfo}->{actors}->[ $self->{actorsCounter} ]->[0] = $origtext
                  if ($self->{actorsCounter} <= $GCPlugins::GCfilms::GCfilmsCommon::MAX_ACTORS);
                $self->{actorsCounter}++;
            }
            elsif ($self->{insideRole} == 1)
            {
                my $role = "";
                # Roles from casting page
                if ($origtext =~ m/R..?le : (.*)/)
                {
                    $role = $1;
                }
                # http://www.allocine.fr/film/casting_gen_cfilm=140683.html
                # Useless ?
                elsif ($origtext =~ m/R..?le/)
                {
                    # Unknown / empty role
                    $role = "";
                }
                # As we incremented it above, we have one more chance here to add a role
                # Without <= we would skip the role for last actor
                push @{$self->{curInfo}->{actors}->[ $self->{actorsCounter} - 1 ]}, $role
                  if ($self->{actorsCounter} <= $GCPlugins::GCfilms::GCfilmsCommon::MAX_ACTORS);
            }
            elsif ($self->{insideRole} == 2)
            {
                # Role from casting page
                $self->{role}       = $origtext;
                $self->{insideCast} = 3;
                $self->{insideRole} = 0;
            }
            elsif ($self->{insideActor} == 2)
            {
                # Actor from casting page
                push @{$self->{curInfo}->{actors}}, [ $origtext, $self->{role} ]
                  if ($self->{actorsCounter} <= $GCPlugins::GCfilms::GCfilmsCommon::MAX_ACTORS);
                $self->{actorsCounter}++;
                $self->{insideActor} = 0;
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

        $self->{isInfo}        = 0;
        $self->{isMovie}       = 0;
        $self->{insideResults} = 0;
        $self->{curName}       = undef;
        $self->{curUrl}        = undef;
        $self->{actorsCounter} = 0;

        bless($self, $class);
        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;
        $html =~ s/&nbsp;/ /gi;
        $html =~ s/<b>|<strong>|<\/b>|<\/strong>|<i>|<\/i>//gi;

        if (!$self->{parsingList})
        {
            # Get cast page list
            my $pageUrl = $self->{loadedUrl};
            $pageUrl =~ s/fichefilm_/casting_/;

            my $page = $self->loadPage($pageUrl, 0, 1);
            # Grab the actors section, place it in the fetched html. Not the nicest way of grabbing
            # this section, since we end up with mismatched tags, but it works
            # http://www.allocine.fr/film/casting_gen_cfilm=17811.html 2 sections
            # http://www.allocine.fr/film/casting_gen_cfilm=147034.html 1 section
            if ($page =~
                #m/<a class=.anchor. id=.actors.>(.*?)<a class=.anchor. id=.\S+.><\/a>/s)
                #m/<a class=.anchor. id=.actors.>(.*)<div class=.nav_secondary.>/s)
                m/<a class=.anchor. id=.actors.>(.*)<!-- \/rubric !-->/s)
            {
                my $src = "<actors>$1</actors></body>";
                $html =~ s/<\/body>/$src/;
            }
        }

        return $html;
    }

    sub getSearchUrl
    {
        my ($self, $word) = @_;

        # f=3 ?
        # return "http://www.allocine.fr/recherche/?q=$word&f=3&rub=1";
        return "http://www.allocine.fr/recherche/1/?q=$word";
    }

    sub getSearchCharset
    {
        my $self = shift;

        # Need urls to be double character encoded
        return "utf8";
    }

    sub getItemUrl
    {
        my ($self, $url) = @_;

        return "http://www.allocine.fr" . $url;
    }

    sub getName
    {
        return "Allocine.fr";
    }

    sub getAuthor
    {
        return 'Tian';
    }

    sub getLang
    {
        return 'FR';
    }
    
    sub getCharset
    {
        # return "UTF-8"; # For 1.5.0 Win32
        return "ISO-8859-1"; # For 1.5.0 Win32 with /lib/gcstar/GCPlugins/ ver.1.5.9svn
    }
}

1;
