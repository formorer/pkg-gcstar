package GCPlugins::GCfilms::GCPortHU;

#  GCstar is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.

use strict;

use GCPlugins::GCfilms::GCfilmsCommon;

{

    package GCPlugins::GCfilms::GCPluginPortHU;

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
            if ($tagname eq "a")
            {
                if ($attr->{href} =~ m:(/pls/fi/films.film_page.*):)
                {
                    if ($self->{insideBoldText})
                    {
                        my $url = $1;
                        $self->{isMovie} = 1;
                        $self->{isInfo}  = 1;
                        $self->{itemIdx}++;
                        $self->{itemsList}[ $self->{itemIdx} ]->{url} = $url;
                    }
                    else
                    {
                        $self->{isMovie} = 0;
                        $self->{isInfo}  = 0;
                    }
                }
            }
            elsif ($tagname eq "span")
            {
                if ($attr->{class} eq "txt")
                {
                    $self->{isInfo}++
                      if $self->{isInfo};
                }
                $self->{insideBoldText} = ($attr->{class} eq "btxt");
            }
        }
        else
        {
            if ($tagname eq "img")
            {
                if (   ($attr->{class} eq "object_picture")
                    && (!$self->{curInfo}->{image}))
                {
                    $self->{curInfo}->{image}  = $attr->{src};
                    $self->{insideOtherTitles} = 0;
                    $self->{insideDescription} = 1;
                }
            }
            elsif ($tagname eq "div")
            {
                if (($attr->{class} eq "separator")
                    && $self->{insideActors})
                {
                    $self->{insideActors}   = 0;
                    $self->{insideSynopsis} = 1;
                }
                elsif (($attr->{class} eq "object_picture")
                    && (!$self->{curInfo}->{image}))
                {
                    $attr->{style} =~ m/url\(([^\)]*)\)/;
                    $self->{curInfo}->{image}  = $1;
                    $self->{insideOtherTitles} = 0;
                    $self->{insideDescription} = 1;
                }
            }
            elsif ($tagname eq "span")
            {
                if ($attr->{class} eq "blackbigtitle")
                {
                    $self->{insideTitle} = 1;
                }
                elsif ($attr->{class} eq "btxt")
                {
                    $self->{insideBoldText} = 1;
                }
                else
                {
                    $self->{insideBoldText} = 0;
                }
                $self->{insideNormalText} = ($attr->{class} eq "txt");
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
                $self->{isMovie}                                = 0;
                $self->{isInfo}                                 = 1;
                return;
            }
            if ($self->{isInfo} == 1)
            {
                if ($origtext =~ m/\((.*)\)/)
                {
                    $self->{itemsList}[ $self->{itemIdx} ]->{original} = $1;
                }
                $self->{isInfo} = 0
                  if $origtext =~ m/^&nbsp;&nbsp;$/;
            }
            if ($self->{isInfo} == 2)
            {
                if ($origtext =~ m/([0-9]+)\)/)
                {
                    $self->{itemsList}[ $self->{itemIdx} ]->{date} = $1;
                }
                if ($origtext =~ m/([0-9]+)\sperc/)
                {
                    $self->{itemsList}[ $self->{itemIdx} ]->{time} = $1;
                }
                $self->{isInfo} = 0;
            }
        }
        else
        {
            if ($self->{insideTitle})
            {
                $self->{curInfo}->{title}  = $origtext;
                $self->{insideTitle}       = 0;
                $self->{insideOtherTitles} = 1;
                $self->{insideDescription} = 1;
                return;
            }
            if (   $self->{insideOtherTitles}
                && $self->{insideNormalText})
            {
                if ($origtext =~ m/\((.*)\)/)
                {
                    $self->{curInfo}->{original} = $1;
                }
                $self->{insideOtherTitles} = 0;
                return;
            }
            if (   $self->{insideDescription}
                && $self->{insideBoldText})
            {
                if ($origtext =~ m/([0-9]+)\s+perc/)
                {
                    $self->{curInfo}->{time} = $1;
                }
                if ($origtext =~ m/([0-9]+)$/)
                {
                    $self->{curInfo}->{date} = $1;
                }
                if ($origtext =~ m/^([0-9]+)\s+�v/)
                {
                    $self->{curInfo}->{age} = $1;
                }
            }

            if ($origtext =~ m/^rendez/)
            {
                $self->{insideDirector}    = 1;
                $self->{insideOtherTitles} = 0;
                $self->{insideDescription} = 0;
                return;
            }
            if ($self->{insideDirector})
            {
                $self->{curInfo}->{director} = $origtext;
                $self->{insideDirector} = 0;
                return;
            }

            if ($origtext =~ m/^szerepl/)
            {
                $self->{insideActors} = 1;
                return;
            }
            if ($self->{insideActors})
            {     
                if ($self->{inside}->{a})
                {
                    push @{$self->{curInfo}->{actors}}, [$origtext]
                      if ($self->{actorsCounter} <
                        $GCPlugins::GCfilms::GCfilmsCommon::MAX_ACTORS);
                    $self->{actorsCounter}++;
                    return;
                }
                elsif ($origtext =~ m/\((.*)\)/)
                {
                    # As we incremented it above, we have one more chance here to add a role
                    # Without <= we would skip the role for last actor
                    push @{$self->{curInfo}->{actors}->[ $self->{actorsCounter} - 1 ]},
                      $1
                      if ($self->{actorsCounter} <=
                      $GCPlugins::GCfilms::GCfilmsCommon::MAX_ACTORS);
                }
            }

            if (   $origtext =~ m/^(Linkek|Bemutat|Aj�nl�k)/
                && $self->{insideBoldText})
            {
                $self->{parsingEnded}   = 1;
                $self->{insideSynopsis} = 0;
                return;
            }

            if (   $self->{insideSynopsis}
                && $self->{insideNormalText}
                && $self->{inside}->{span}
                && !$self->{inside}->{a})
            {
                ($self->{curInfo}->{synopsis} .= $origtext) =~ s/^\s*//;
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
        };

        $self->{isInfo}            = 0;
        $self->{isMovie}           = 0;
        $self->{insideDescription} = 0;
        $self->{insideSynopsis}    = 0;
        $self->{insideActors}      = 0;
        $self->{curName}           = undef;
        $self->{curUrl}            = undef;

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        $self->{parsingEnded} = 0;

        $html =~ s/"&#34;/'"/g;
        $html =~ s/&#34;"/"'/g;
        $html =~ s|</a></b><br>|</a><br>|;

        $self->{insideDescription} = 0;
        $self->{insideSynopsis}    = 0;
        $self->{insideActors}      = 0;

        return $html;
    }

    sub getSearchUrl
    {
        my ($self, $word) = @_;

        my $base_url = 'http://www.port.hu/pls/ci/cinema.film_creator';
        return "$base_url?i_text=$word&i_film_creator=1";
    }

    sub getItemUrl
    {
        my ($self, $url) = @_;

        return "http://www.port.hu$url";
    }

    sub getCharset
    {
        my $self = shift;

        return "UTF-8";
    }

    sub convertCharset
    {
        my ($self, $value) = @_;
        return $value;
    }

    sub getName
    {
        return "port.hu";
    }

    sub getAuthor
    {
        return 'Anonymous';
    }

    sub getLang
    {
        return 'HU';
    }

}

1;
