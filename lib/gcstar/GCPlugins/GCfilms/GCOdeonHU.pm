package GCPlugins::GCfilms::GCOdeonHU;

#  GCstar is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.

use strict;

use GCPlugins::GCfilms::GCfilmsCommon;

{

    package GCPlugins::GCfilms::GCPluginOdeonHU;

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
                if ($attr->{href} =~ m:(kat.phtml\?id=.*):)
                {    #?
                    my $url = '/' . $1;
                    $self->{isMovie} = 1;
                    $self->{isInfo}  = 1;
                    $self->{itemIdx}++;
                    $self->{itemsList}[ $self->{itemIdx} ]->{url} = $url;
                }
            }
        }
        else
        {
            if ($tagname eq "span")
            {
                $self->{insideTitle} = ($attr->{class} eq "ver11 modB colDD0008");
            }
            elsif ($tagname eq "td")
            {
                $self->{insideFieldName}  = ($attr->{class} eq "ver9 col102643");
                $self->{insideFieldValue} = ($attr->{class} eq "ver11 colblack");
                $self->{insidePersonType} = ($attr->{class} eq "ver9 col1D5263 pad5");
                $self->{insideSynopsis}   = ($attr->{class} eq "ver11 col102643 pad2");
                $self->{insideRating}     = ($attr->{class} eq "text_cat_score");

                if ($self->{insideSynopsis}
                    && (length($self->{curInfo}->{synopsis}) > 20))
                {
                    $self->{insideSynopsis} = 0;
                }
            }
            elsif ($tagname eq "img")
            {
                #if (! $self->{curInfo}->{image}) {
                if ($attr->{src} =~ m:img/album/.*\.jpg$:)
                {
                    my $img = 'http://odeon.hu/';
                    $img .= $attr->{src};
                    $self->{curInfo}->{image} = $img;
                }
            }
        }
    }

    sub end
    {
        my ($self, $tagname) = @_;

        $self->{inside}->{$tagname}--;

        if ($tagname eq "a")
        {
            $self->{isMovie} = 0;
        }
        if ($tagname eq "td")
        {
            $self->{insideFieldName}  = 0;
            $self->{insideFieldValue} = 0;
            $self->{insidePersonType} = 0;
            $self->{insideSynopsis}   = 0;
            $self->{insideRating}     = 0;
        }
    }

    sub text
    {
        my ($self, $origtext) = @_;

        #return if length($origtext) < 2;

        $origtext =~ s/&#34;/"/g;
        $origtext =~ s/&#179;/3/g;
        $origtext =~ s/&#[0-9]*;//g;
        $origtext =~ s/\n//g;

        return if ($self->{parsingEnded});

        if ($self->{parsingList})
        {
            if ($self->{isMovie})
            {
                if ($self->{inside}->{b})
                {
                    $self->{itemsList}[ $self->{itemIdx} ]->{title} .= $origtext;
                    return;
                }
                else
                {
                    if ($origtext =~ m/\[(.*),\s+([0-9]+)\]/)
                    {
                        $self->{itemsList}[ $self->{itemIdx} ]->{date}     = $2;
                        $self->{itemsList}[ $self->{itemIdx} ]->{original} = $1;
                        $self->{isMovie}                                   = 0;
                    }
                }
            }
        }
        else
        {
            if ($self->{insideTitle})
            {
                $self->{curInfo}->{title} = $origtext;
                $self->{insideTitle} = 0;
                return;
            }

            if ($self->{insideFieldName})
            {
                $self->{FieldName} = "original" if $origtext =~ m/^eredeti/;
                $self->{FieldName} = "date"     if $origtext =~ m/^..?v:/;
                $self->{FieldName} = "country"  if $origtext =~ m/^nemzet:/;
                $self->{FieldName} = "time"     if $origtext =~ m/^hossz:/;
                $self->{FieldName} = "todo"     if $origtext =~ m/^k..?p:/;
                $self->{FieldName} = "todo"     if $origtext =~ m/^kiad/;
                $self->{FieldName} = "todo"     if $origtext =~ m/^dial..?gus:/;
                $self->{FieldName} = "genre"    if $origtext =~ m/^m..?faj:/;

                $self->{insideFieldName} = 0;
                return;
            }

            if ($self->{insideFieldValue})
            {
                my $txt  = $origtext;
                my $name = $self->{FieldName};
                $txt =~ s/^\s*//;
                $txt =~ s/\s*$//;
                $txt =~ s/\s+/ /g;
                $txt =~ s/\s*perc$// if $name eq "time";
                return
                  if $txt =~ m/^\s*$/;

                if ($self->{curInfo}->{$name} !~ m/^\s*$/)
                {
                    $self->{curInfo}->{$name} .= "," . $txt;
                }
                else
                {
                    $self->{curInfo}->{$name} = $txt;
                }

                return;
            }

            if ($self->{insidePersonType})
            {
                if ($self->{inside}->{b})
                {
                    my $name = 0;
                    $name = "director" if $origtext =~ m/^Rendez/;
                    $name = "actors"   if $origtext =~ m/^Szerepl/;
                    if ($name)
                    {
                        $self->{PersonType} = $name;
                    }
                    else
                    {
                        $self->{insidePersonType} = 0;
                    }
                    return;
                }
                elsif ($self->{inside}->{a})
                {
                    my $name = $self->{PersonType};
                    if ($self->{curInfo}->{$name} !~ m/^\s*$/)
                    {
                        $self->{curInfo}->{$name} .= "," . $origtext;
                    }
                    else
                    {
                        $self->{curInfo}->{$name} = $origtext;
                    }
                    #$self->{curInfo}->{actors} .= $origtext.', '
                    #if ($self->{actorsCounter} < $GCPlugins::GCfilms::GCfilmsCommon::MAX_ACTORS);
                    #$self->{actorsCounter}++;
                }

                return;
            }

            if ($self->{insideSynopsis})
            {
                my $txt = $origtext;
                $txt =~ s/\r/\n/g;
                $txt =~ s/^\s+//g;
                $txt =~ s/\s+$//g;
                $self->{curInfo}->{synopsis} .= $txt;
            }
            if ($self->{insideRating})
            {
                $self->{curInfo}->{ratingpress} = int($origtext + 0.5)
                  if $origtext =~ /^[0-9.]+$/;
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

        $self->{isMovie}           = 0;
        $self->{insideDescription} = 0;
        $self->{insideSynopsis}    = 0;
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

        if ($self->{parsingList})
        {
            $html =~ s{</?span[^>]*>}{}gi;	# remove all <span> tags
        }

        $self->{insideDescription} = 0;
        $self->{insideSynopsis}    = 0;

        return $html;
    }

    sub getSearchUrl
    {
        my ($self, $word) = @_;

        return "http://odeon.hu/kat.phtml?".
          "search=$word&scat=5&btn_hirlev.x=13&btn_hirlev.y=5";
    }

    sub getItemUrl
    {
        my ($self, $url) = @_;

        return "http://www.odeon.hu$url";
    }

    sub getName
    {
        return "odeon.hu";
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
