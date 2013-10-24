package GCPlugins::GCfilms::GCMediadis;

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

    package GCPlugins::GCfilms::GCPluginMediadis;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;

        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
            if ($tagname eq "a")
            {
                if (   ($attr->{href} =~ m|http://www\.mediadis\.com/video/detail\.asp|)
                    && ($attr->{class} eq 'a-blue'))
                {
                    my $url = $attr->{href};
                    $self->{isMovie} = 1;
                    $self->{isInfo}  = 1;
                    $self->{itemIdx}++;
                    $self->{itemsList}[ $self->{itemIdx} ]->{url} = $url;
                }
                elsif (($self->{couldBeCast}==1)
                  && ($attr->{href} =~ m|http://www\.mediadis\.com/products/search\.asp|))
                {
                    # yes, found the magic link. director(s) to follow.
                    $self->{couldBeCast} = 2;
                }
            }
            if (($tagname eq 'td') && ($attr->{class} eq 'search-list'))
            {
                if ($attr->{align} eq 'center')
                {
                    $self->{couldBeYear} = 1;
                }
                if (($attr->{align} eq 'left') && ($attr->{colspan} eq '5'))
                {
                    $self->{couldBeCast} = 1;
                }
            }
        }
        else
        {
            if ($tagname eq "img")
            {
                if ($attr->{src} =~ /^http:\/\/www\.(dvdzone2|mediadis)\.com\/pictures\/big\//)
                {
                    $self->{curInfo}->{image} = $attr->{src};
                }
            }
            elsif ($tagname eq "p")
            {
                $self->{insideSynopsis} = 1;
            }
            elsif ($tagname eq "span")
            {
                if (($attr->{class} eq "detail-title"))
                {
                    $self->{insideName} = 1;
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
            if ($tagname eq 'tr') {
                $self->{couldBeCast} = 0;
            }
        }
    }

    sub text
    {
        my ($self, $origtext) = @_;

        return if length($origtext) < 2;

        if ($self->{parsingList})
        {
            $origtext =~ s/^\s*(\S*)\s*$/$1/;	# remove surrouding whitespace

            if ($self->{isMovie})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{title} = $self->capWord($origtext);
                $self->{isMovie}                                  = 0;
                $self->{isInfo}                                   = 1;
                return;
            }
            elsif ($self->{couldBeYear})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{date} = $1 
                  if $origtext =~ m/([0-9]{4})/;
                $self->{couldBeYear} = 0;
            }
            elsif ($self->{couldBeCast} == 2)	# waiting for director name
            {
                if ($origtext eq "-")
                {
                    $self->{couldBeCast} = 3;	# read actors now
                }
                elsif (!$self->{itemsList}[ $self->{itemIdx} ]->{director})
                {
                    # revert the failed name transposure done my mediadis:
                    $origtext =~ s/^(.*) (\S+)$/$2 $1/;
                    # only one entry, no list.
                    $self->{itemsList}[ $self->{itemIdx} ]->{director} = $origtext;
                }
            }
            elsif ($self->{couldBeCast} == 3)	# waiting for actors names
            {
                if ($origtext)
                {
                    # revert the failed name transposure done my mediadis:
                    $origtext =~ s/^(.*) (\S+)$/$2 $1/;
                    $self->{itemsList}[ $self->{itemIdx} ]->{actors} .= $origtext;
                }
            }
        }
        else
        {
            $origtext =~ s/ : //g if !$self->{insideSynopsis};
            if ($self->{insideRating})
            {
                $origtext =~ s{(\d+),(\d+)/10}{$1.$2};
                $self->{curInfo}->{ratingpress} = int ($origtext + 0.5);
                $self->{insideRating} = 0;
            }
            elsif ($self->{insideGenre})
            {
                $origtext =~ s/ - /,/g;
                # don't scream! Convert all caps to first cap only.
                $self->{curInfo}->{genre} .= ucfirst(lc($origtext)); 
                $self->{insideGenre} = 0;
            }
            elsif ($self->{insideDate})
            {
                $self->{curInfo}->{date} = $origtext;
                $self->{insideDate} = 0;
            }
            elsif ($self->{insideDirector})
            {
                if (!$self->{curInfo}->{director})
                {
                    my @directors = split(/\s+-\s+/, $origtext);
                    for (my $i=0; $i<@directors; $i++)
                    {
                        # revert the failed name transposure done my mediadis:
                        $directors[$i] =~ s/^(.*) (\S+)$/$2 $1/;
                    }
                    $self->{curInfo}->{director} = join (', ', @directors);
                }
                $self->{insideDirector} = 0;
            }
            elsif ($self->{insideSynopsis})
            {
                $self->{curInfo}->{synopsis} .= $origtext . "\n\n";
                $self->{insideSynopsis} = 0;
            }
            elsif ($self->{insideNat})
            {
                $self->{curInfo}->{country} = $origtext;
                $self->{insideNat} = 0;
            }
            elsif ($self->{insideTime})
            {
                $self->{curInfo}->{time} = $origtext;
                $self->{insideTime} = 0;
            }
            elsif ($self->{insideActors})
            {
                foreach my $name (split(/\s+-\s+/, $origtext))
                {
                    # revert the failed name transposure done my mediadis:
                    # move the first name part back in front.
                    $name =~ s/^(.*) (\S+)$/$2 $1/;
                    # and store the actors in a proper list.
                    push @{$self->{curInfo}->{actors}}, [$name]
                      if ($self->{actorsCounter} <
                        $GCPlugins::GCfilms::GCfilmsCommon::MAX_ACTORS);
                    $self->{actorsCounter}++;
                }
                $self->{insideActors} = 0;
            }
            elsif ($self->{insideOrig})
            {
                $self->{curInfo}->{original} = $self->capWord($origtext) if !$self->{curInfo}->{original};
                $self->{insideOrig} = 0;
            }
            elsif (($self->{inside}->{span}) && ($self->{insideName}))
            {
                $self->{curInfo}->{title} = $self->capWord($origtext) if !$self->{curInfo}->{title};
            }
            elsif ($self->{inside}->{strong})
            {
                $self->{insideDate}     = 1 if $origtext =~ m/Year/;
                $self->{insideDirector} = 1 if $origtext =~ m/Director\(s\)/;
                $self->{insideGenre}    = 1 if $origtext =~ m/Genres/;
                $self->{insideOrig}     = 1 if $origtext =~ m/Original title/;
                $self->{insideTime}     = 1 if $origtext =~ m/Duration/;
                $self->{insideNat}      = 1 if $origtext =~ m/Country/;
                $self->{insideActors}   = 1 if $origtext =~ m/Actors/
                                            or $origtext =~ m/Voice of/;
            }
            if ($self->{inside}->{td})
            {
                if ($origtext =~ m/Global rating/)
                {
                    $self->{insideRating} = 1;
                }
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
            date     => 0,  # hide the date as it is wrong most of the time
            director => 1,
            actors   => 1
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

        $html =~ s|<a (class="underline" )?href="http://www\.mediadis\.com/products/search\.asp\?par=[0-9]*" title="Filmography">([^<]*)</a>|$2|g;
        $html =~ s/&nbsp;/ /g;

        return $html;
    }

    sub getSearchUrl
    {
        my ($self, $word) = @_;

        return "http://www.mediadis.com/video/search.asp?t=19&pl=all&kw=$word";
    }

    sub getItemUrl
    {
        my ($self, $url) = @_;

        return $url unless $url eq '';
        return 'http://www.mediadis.com/video/';
    }

    sub getName
    {
        return 'Mediadis';
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
