package GCPlugins::GCTVepisodes::GCTvdb;

###################################################
#
#  Copyright 2005-2007 Tian
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

use GCPlugins::GCTVepisodes::GCTVepisodesCommon;


{
    package GCPlugins::GCTVepisodes::GCPluginTvdb;

    use base qw(GCPlugins::GCTVepisodes::GCTVepisodesPluginsBase);
    use XML::Simple;
    use Encode;
    use LWP::Simple qw($ua);

    sub parse
    {
        my ($self, $page) = @_;
        return if $page =~ /^<!DOCTYPE html/;
        my $xml;
        my $xs = XML::Simple->new;

        if ($self->{pass} eq 1)
        {
            # Searching on series name
            $xml = $xs->XMLin(
                $page, 
                ForceArray => ['Series'],
                KeyAttr    => []
            );
                
            foreach my $series ( @{$xml->{Series}})
            {
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{nextUrl} = "http://www.thetvdb.com/api/A8CC4AF70D0385F3/series/".$series->{id}."/all/".$self->siteLanguage().".xml";
                $self->{itemsList}[$self->{itemIdx}]->{name} = $series->{SeriesName};
                $self->{itemsList}[$self->{itemIdx}]->{firstaired} = $series->{FirstAired};
            }
        }
        else
        {        
            if ($self->{parsingList})
            {
                # Searching on episodes
                $xml = $xs->XMLin(
                    $page,
                    ForceArray => ['Episode'],
                    KeyAttr    => [],
     
                );

                foreach my $episode (@{$xml->{Episode}})
                {
                    $self->{itemIdx}++;
                    $self->{itemsList}[$self->{itemIdx}]->{name} = $episode->{EpisodeName}
                        if (!ref($episode->{EpisodeName}));
                    $self->{itemsList}[$self->{itemIdx}]->{season} = $episode->{SeasonNumber};
                    $self->{itemsList}[$self->{itemIdx}]->{episode} = $episode->{EpisodeNumber};
                    $self->{itemsList}[$self->{itemIdx}]->{director} = $episode->{Director}
                        if (!ref($episode->{Director}));
                    $self->{itemsList}[$self->{itemIdx}]->{writer} = $episode->{Writer}
                        if (!ref($episode->{Writer}));
                    $self->{itemsList}[$self->{itemIdx}]->{overview} = $episode->{Overview}
                        if (!ref($episode->{Overview}));
                    $self->{itemsList}[$self->{itemIdx}]->{image} = "http://thetvdb.com/banners/".$episode->{filename}
                        if (!ref($episode->{filename}));
                    $self->{itemsList}[$self->{itemIdx}]->{series} = $xml->{Series}->{SeriesName}
                        if (!ref($xml->{Series}->{SeriesName}));   
                    $self->{itemsList}[$self->{itemIdx}]->{firstaired} = $xml->{Series}->{FirstAired}
                        if (!ref($xml->{Series}->{FirstAired}));      
                    $self->{itemsList}[$self->{itemIdx}]->{actors} = $xml->{Series}->{Actors}
                        if (!ref($xml->{Series}->{Actors}));   
                    $self->{itemsList}[$self->{itemIdx}]->{genre} = $xml->{Series}->{Genre}
                        if (!ref($xml->{Series}->{Genre}));  
                    $self->{itemsList}[$self->{itemIdx}]->{runtime} = $xml->{Series}->{Runtime}
                        if (!ref($xml->{Series}->{Runtime})); 
                    $self->{itemsList}[$self->{itemIdx}]->{url}  = "http://www.thetvdb.com/?tab=episode&seriesid=".$episode->{seriesid}."&seasonid=".$episode->{seasonid}."&id=".$episode->{id}."&lid=".$self->siteLanguageCode();                                                               
                }
            }
            elsif ($self->{pass} != 2)
            {
                # Process a given url
                $xml = $xs->XMLin(
                    $page,
                    ForceArray => ['Episode'],
                    KeyAttr    => [],
                );
                
                # Need to grab the generic series info too
                my $response = $ua->get('http://www.thetvdb.com/api/A8CC4AF70D0385F3/series/'.$xml->{Episode}[0]->{seriesid}.'/'.$self->siteLanguage().'.xml');
                my $result;
                eval {
                    $result = $response->decoded_content;
                };
                my $seriesxml = $xs->XMLin(
                    $result,
                    ForceArray => ['Series'],
                    KeyAttr    => [],
                );
                $self->{curInfo}->{season} = $xml->{Episode}[0]->{SeasonNumber};
                $self->{curInfo}->{episode} = $xml->{Episode}[0]->{EpisodeNumber};
                $self->{curInfo}->{name} = $xml->{Episode}[0]->{EpisodeName};
                $self->{curInfo}->{series} = $seriesxml->{Series}[0]->{SeriesName};
                $self->{curInfo}->{director} = $xml->{Episode}[0]->{Director}
                    if (!ref($xml->{Episode}[0]->{Director}));
                $self->{curInfo}->{director} =~ s/^\|//;
                $self->{curInfo}->{director} =~ s/\|$//;
                $self->{curInfo}->{firstaired} = $xml->{Episode}[0]->{FirstAired}
                    if (!ref($xml->{Episode}[0]->{FirstAired}));
                $self->{curInfo}->{writer} = $xml->{Episode}[0]->{Writer}
                    if (!ref($xml->{Episode}[0]->{Writer}));
                $self->{curInfo}->{writer} =~ s/^\|//;
                $self->{curInfo}->{writer} =~ s/\|$//;
                
                if (!ref($seriesxml->{Series}[0]->{Actors}))
                {
                    my $actorString = $seriesxml->{Series}[0]->{Actors};
                    $actorString =~ s/^\|//;
                    $actorString =~ s/\|$//;
                    for my $actor (split(/\|/, $actorString))
                    {
                        push @{$self->{curInfo}->{actors}}, [$actor];
                    }                   
                }
                
                if (!ref($seriesxml->{Series}[0]->{Genre}))
                {
                    my $genreString = $seriesxml->{Series}[0]->{Genre};
                    $genreString =~ s/^\|//;
                    $genreString =~ s/\|$//;
                    for my $genre (split(/\|/, $genreString))
                    {
                        push @{$self->{curInfo}->{genre}}, [$genre];
                    }
                }    
                
                $self->{curInfo}->{time} =  $seriesxml->{Series}[0]->{Runtime};
                $self->{curInfo}->{image} = "http://thetvdb.com/banners/".$xml->{Episode}[0]->{filename}
                        if (!ref($xml->{Episode}[0]->{filename}));
                $self->{curInfo}->{synopsis} = $xml->{Episode}[0]->{Overview}
                    if (!ref($xml->{Episode}[0]->{Overview}));
                $self->{curInfo}->{webPage}  = "http://www.thetvdb.com/?tab=episode&seriesid=".$xml->{Episode}[0]->{seriesid}."&seasonid=".$xml->{Episode}[0]->{seasonid}."&id=".$xml->{Episode}[0]->{id}."&lid=".$self->siteLanguageCode();       
            }
            else
            {
                $self->{curInfo}->{season} = $self->{itemsList}[$self->{wantedIdx}]->{season};
                $self->{curInfo}->{episode} = $self->{itemsList}[$self->{wantedIdx}]->{episode};
                $self->{curInfo}->{name} = $self->{itemsList}[$self->{wantedIdx}]->{name};
                $self->{curInfo}->{series} = $self->{itemsList}[$self->{wantedIdx}]->{series};
                $self->{curInfo}->{director} = $self->{itemsList}[$self->{wantedIdx}]->{director};
                $self->{curInfo}->{director} =~ s/^\|//;
                $self->{curInfo}->{director} =~ s/\|$//;
                $self->{curInfo}->{firstaired} = $self->{itemsList}[$self->{wantedIdx}]->{firstaired};
                $self->{curInfo}->{writer} = $self->{itemsList}[$self->{wantedIdx}]->{writer};
                $self->{curInfo}->{writer} =~ s/^\|//;
                $self->{curInfo}->{writer} =~ s/\|$//;
                
                my $actorString = $self->{itemsList}[$self->{wantedIdx}]->{actors};
                $actorString =~ s/^\|//;
                $actorString =~ s/\|$//;
                for my $actor (split(/\|/, $actorString))
                {
                    push @{$self->{curInfo}->{actors}}, [$actor];
                }                
                
                my $genreString = $self->{itemsList}[$self->{wantedIdx}]->{genre};
                $genreString =~ s/^\|//;
                $genreString =~ s/\|$//;
                for my $genre (split(/\|/, $genreString))
                {
                    push @{$self->{curInfo}->{genre}}, [$genre];
                }                
                $self->{curInfo}->{time} = $self->{itemsList}[$self->{wantedIdx}]->{runtime};
                $self->{curInfo}->{image} = $self->{itemsList}[$self->{wantedIdx}]->{image};
                $self->{curInfo}->{synopsis} = $self->{itemsList}[$self->{wantedIdx}]->{overview};
                $self->{curInfo}->{webPage} = $self->{itemsList}[$self->{wantedIdx}]->{url};
            }
            
        }
    }

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);

        $self->{curName} = undef;
        $self->{curUrl} = undef;

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        return $html;
    }

    sub getSearchUrl
    {
	my ($self, $word) = @_;
        return "http://www.thetvdb.com/api/GetSeries.php?seriesname=$word&language=".$self->siteLanguage();
    }
    
    sub getItemUrl
    {
        my ($self, $url) = @_;
        if (!$url)
        {
            # If we're not passed a url, return a hint so that gcstar knows what type
            # of addresses this plugin handles
            $url = "http://www.thetvdb.com";
        }
        elsif (index($url, "api") < 0)
        {
            # Url isn't for the tvdb api, so we need to find the episode id
            # and return a url corresponding to the api page for this movie
            
            $url =~ /[\?&]id=([0-9]+)*/;
            my $id = $1;
            $url = "http://www.thetvdb.com/api/A8CC4AF70D0385F3/episodes/$id/".$self->siteLanguage().".xml";
        }
        return $url;
    }	
    
    sub changeUrl
    {
        my ($self, $url) = @_;
        # Make sure the url is for the api, not the main movie page
        return $self->getItemUrl($url);
    }

    sub getNumberPasses
    {
        return 2;
    }

    sub getName
    {
        return "Tvdb";
    }
    
    sub needsLanguageTest
    {
        return 1;
    }
    
    sub testURL
    {
        my ($self, $url) = @_;    
        $url =~ /[\?&]lid=([0-9]+)*/;
        my $id = $1;
        return ($id == $self->siteLanguageCode());
    }

    sub getReturnedFields
    {
        my $self = shift;

        if ($self->{pass} == 1)
        {
            $self->{hasField} = {
                name => 1,
                firstaired => 1,
            };
        }
        else
        {
            $self->{hasField} = {
                name => 1,
                season => 1,
                episode => 1,
            };
        }
    }
    
    sub getAuthor
    {
        return 'Zombiepig';
    }
    
    sub getLang
    {
        return 'EN';
    }
    
    sub isPreferred
    {
        return 1;
    }
    
    sub getSearchCharset
    {
        my $self = shift;
        
        # Need urls to be double character encoded
        return "utf8";
    }

    sub getCharset
    {
        my $self = shift;
    
        return "UTF-8";
    }

    sub decodeEntitiesWanted
    {
        return 0;
    } 
    
    sub siteLanguage
    {
        my $self = shift;
        
        return 'en';
    }
    
    sub convertCharset
    {
        my ($self, $value) = @_;
        return $value;
    }

    
    sub siteLanguageCode
    {
        my $self = shift;
        
        return 7;
    }

}

1;
