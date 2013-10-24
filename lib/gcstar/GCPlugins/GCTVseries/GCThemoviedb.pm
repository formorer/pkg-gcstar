package GCPlugins::GCTVseries::GCthemoviedb;

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

use GCPlugins::GCTVseries::GCTVseriesCommon;

{

    package GCPlugins::GCTVseries::GCPluginThemoviedb;

    use base 'GCPlugins::GCTVseries::GCTVseriesPluginsBase';
    use XML::Simple;

    sub parse
    {
        my ($self, $page) = @_;
        return if $page =~ /^<!DOCTYPE html/;
        my $xml;
        my $xs = XML::Simple->new;

        if ($self->{parsingList})
        {
            if ($page !~ m/>Nothing found.<\/movie/)
            {
                $xml = $xs->XMLin(
                    $page,
                    ForceArray => [ 'movie', 'alternative_name' ],
                    KeyAttr    => ['id']
                );
                my $movie;
                foreach $movie (keys(%{$xml->{'movies'}->{'movie'}}))
                {
                    # We only want movies, not series and everything else the api returns
                    if ($xml->{'movies'}->{'movie'}->{$movie}->{'type'} eq "movie")
                    {
                        $self->{itemIdx}++;
                        my $url = "http://api.themoviedb.org/2.1/Movie.getInfo/en/xml/9fc8c3894a459cac8c75e3284b712dfc/" . $movie;
                        # If the release date is missing, it will be returned as an array, so only save the release if
                        # it's not an array
                        my $released = "";
                        if (!ref($xml->{'movies'}->{'movie'}->{$movie}->{'released'}))
                        {
                            $released = $xml->{'movies'}->{'movie'}->{$movie}->{'released'};
                        }
                        $self->{itemsList}[ $self->{itemIdx} ]->{firstaired} = $released;
                        $self->{itemsList}[ $self->{itemIdx} ]->{url}  = $url;
                        $self->{itemsList}[ $self->{itemIdx} ]->{title} =
                          $xml->{'movies'}->{'movie'}->{$movie}->{'name'};
                        # Now, check if there's any alternative names, and if so, add them in as
                        # additional search results.
                        for my $alternateName (
                            @{$xml->{'movies'}->{'movie'}->{$movie}->{alternative_name}})
                        {
                            if (!ref($alternateName))
                            {
                                $self->{itemIdx}++;
                                $self->{itemsList}[ $self->{itemIdx} ]->{firstaired}  = $released;
                                $self->{itemsList}[ $self->{itemIdx} ]->{url}   = $url;
                                $self->{itemsList}[ $self->{itemIdx} ]->{title} = $alternateName;
                            }
                        }

                    }
                }
            }
        }
        else
        {
            $xml = $xs->XMLin(
                $page,
                ForceArray => [ 'country', 'person', 'category', 'size', 'alternative_name' ],
                KeyAttr    => ['']
            );

            if (
                (
                    $xml->{movies}->{movie}->{name} ne
                    $self->{itemsList}[ $self->{wantedIdx} ]->{title}
                )
                && ($self->{itemsList}[ $self->{wantedIdx} ]->{title})
              )
            {
               # Name returned by tmdb is different to the one the user selected
               # this means they choose an translated name, so use the name they choose
               # as the default
                $self->{curInfo}->{title}    = $self->{itemsList}[ $self->{wantedIdx} ]->{title};
            }
            else
            {
                $self->{curInfo}->{title} = $xml->{movies}->{movie}->{name};
            }
            
            # Try and guess the series name
            $xml->{movies}->{movie}->{name} =~ /^(.*):/;
            if ($1 ne '')
            {
                $self->{curInfo}->{series} = $1;
            }
            else
            {
                $self->{curInfo}->{series} = $xml->{movies}->{movie}->{name};
            }
            
            # Set season to 0 and set special flag
            $self->{curInfo}->{season} = 0;
            $self->{curInfo}->{specialep} = 1;

            $self->{curInfo}->{webPage} = $xml->{movies}->{movie}->{url};

            # The following fields could be missing from the xml, so we need to check if they're blank
            # (in which case they'll be a array)
            $self->{curInfo}->{synopsis} = $xml->{movies}->{movie}->{overview}
              if (!ref($xml->{movies}->{movie}->{overview}));
            $self->{curInfo}->{ratingpress} = $xml->{movies}->{movie}->{rating}
              if (!ref($xml->{movies}->{movie}->{rating}));
            $self->{curInfo}->{firstaired} = $xml->{movies}->{movie}->{released}
              if (!ref($xml->{movies}->{movie}->{released}));
            $self->{curInfo}->{time} = $xml->{movies}->{movie}->{runtime} . " mins"
              if (!ref($xml->{movies}->{movie}->{runtime}));

            if (!ref($xml->{movies}->{movie}->{certification}))
            {
                my $certification;
                $certification = $xml->{movies}->{movie}->{certification};
                $self->{curInfo}->{age} = 1
                  if ($certification eq 'Unrated') || ($certification eq 'Open');
                $self->{curInfo}->{age} = 2
                  if ($certification eq 'G') || ($certification eq 'Approved');
                $self->{curInfo}->{age} = 5
                  if ($certification eq 'PG')
                  || ($certification eq 'M')
                  || ($certification eq 'GP');
                $self->{curInfo}->{age} = 13 if $certification eq 'PG-13';
                $self->{curInfo}->{age} = 17 if $certification eq 'R';
                $self->{curInfo}->{age} = 18
                  if ($certification eq 'NC-17') || ($certification eq 'X');
            }

            for my $country (@{$xml->{movies}->{movie}->{countries}->{country}})
            {
                $self->{curInfo}->{country} .= $country->{name} . ', ';
            }
            $self->{curInfo}->{country} =~ s/, $//;
            for my $person (@{$xml->{movies}->{movie}->{cast}->{person}})
            {
                my $name = $person->{name};
                # Strip any blank spaces from start and end of name
                $name =~ s/\s*$//;
                $name =~ s/^\s*//;                                       
                if ($person->{job} eq "Director")
                {
                    $self->{curInfo}->{director} .= $name . ', ';
                }
                if ($person->{job} eq "Producer")
                {
                    $self->{curInfo}->{producer} .= $name . ', ';
                }
                if ($person->{job} eq "Music")
                {
                    $self->{curInfo}->{music} .= $name . ', ';
                }
                elsif ($person->{job} eq "Actor")
                {
                    if ($self->{actorsCounter} < $GCPlugins::GCTVseries::GCTVseriesCommon::MAX_ACTORS)
                    {

                        push @{$self->{curInfo}->{actors}}, [$name];
                        my $role = $person->{character};
                        $role =~ s/\s*$//;
                        $role =~ s/^\s*//;
                        push @{$self->{curInfo}->{actors}->[ $self->{actorsCounter} ]}, $role;
                        $self->{actorsCounter}++;
                    }
                }
            }
            $self->{curInfo}->{director} =~ s/, $//;
            $self->{curInfo}->{producer} =~ s/, $//;
            $self->{curInfo}->{music} =~ s/, $//;    
            for my $category (@{$xml->{movies}->{movie}->{categories}->{category}})
            {
                push @{$self->{curInfo}->{genre}}, [ $category->{name} ]
                  if ($category->{type} eq 'genre');
            }
            for my $image (@{$xml->{movies}->{movie}->{images}->{image}})
            {
                if ($image->{type} eq "poster")
                {
                    # Fetch either the big original pic, or just the small thumbnail pic
                    if (   (($self->{bigPics}) && ($image->{size} eq "original"))
                        || (!($self->{bigPics}) && ($image->{size} eq "thumb")))
                    {
                        if (!$self->{curInfo}->{image})
                        {
                            $self->{curInfo}->{image} = $image->{url};
                        }
                    }
                }
            }
            
            # We have to return something as the name, even though this field will get automatically
            # calculated for tv series collections.
            $self->{curInfo}->{name} = "temp";
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
            firstaired     => 1
        };

        return $self;
    }

    sub getItemUrl
    {
        my ($self, $url) = @_;

        if (!$url)
        {
            # If we're not passed a url, return a hint so that gcstar knows what type
            # of addresses this plugin handles
            $url = "http://www.themoviedb.org";
        }
        elsif (index($url, "api") < 0)
        {
            # Url isn't for the movie db api, so we need to find the movie id
            # and return a url corresponding to the api page for this movie
            my $found = index(reverse($url), "/");
            if ($found >= 0)
            {
                my $id = substr(reverse($url), 0, $found);
                $url =
"http://api.themoviedb.org/2.1/Movie.getInfo/en/xml/9fc8c3894a459cac8c75e3284b712dfc/"
                  . reverse($id);
            }
        }
        return $url;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        return $html;
    }

    sub decodeEntitiesWanted
    {
        return 0;
    }

    sub getSearchUrl
    {
        my ($self, $word) = @_;
        return
"http://api.themoviedb.org/2.1/Movie.search/en/xml/9fc8c3894a459cac8c75e3284b712dfc/$word";
    }

    sub changeUrl
    {
        my ($self, $url) = @_;
        # Make sure the url is for the api, not the main movie page
        return $self->getItemUrl($url);
    }

    sub getName
    {
        return "The Movie DB";
    }

    sub getAuthor
    {
        return 'Zombiepig';
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

    sub getSearchCharset
    {
        my $self = shift;

        # Need urls to be double character encoded
        return "utf8";
    }

    sub convertCharset
    {
        my ($self, $value) = @_;
        return $value;
    }

    sub getNotConverted
    {
        my $self = shift;
        return [];
    }

}

1;
