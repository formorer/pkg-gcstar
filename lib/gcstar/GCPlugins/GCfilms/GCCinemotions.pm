package GCPlugins::GCfilms::GCCinemotions;

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
    package GCPlugins::GCfilms::GCPluginCinemotions;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
            if ($tagname eq 'a')
            {
                if (($attr->{href} =~ /^\/modules\/Films\/fiche\//)
								 && ($attr->{class} eq "link4"))
                {
                    my $url = $attr->{href};
                    $self->{isMovie} = 1;
                    $self->{isInfo} = 1;
                    $self->{itemIdx}++;
                    $self->{itemsList}[$self->{itemIdx}]->{url} = $url;
                }
            }
            elsif (($tagname eq 'img') && (($attr->{src} =~ /^\/data\/films\//)
                    || ($attr->{src} =~ /^\/modules\/Films\/img\/webpasdaffiche\.jpg/)))
            {
                $self->{isMovie} = 0;
                $self->{itemIdx}--;
            }
            elsif ($tagname eq 'font')
            {
                if ($attr->{class} eq 'link4dtext')
                {
                    $self->{isInfo}=1;
                }
            }
        }
        else
        {
            if ($tagname eq 'img')
            {
                if (($attr->{src} =~ m|/data/films/|)
                 && ($attr->{src} !~ m|/data/films/[^_]*_[0-9]{4}_[0-9]*\.jpg|)
                 && ($attr->{width} == 150))
                {
                    $self->{curInfo}->{image} = $attr->{src};
                    if ($self->{bigPics})
                    {
                        $self->{curInfo}->{image} =~ s/\/h200\//\//;
                    }
                }
            }
            elsif ($tagname eq 'font')
            {
                $self->{insideOrig} = 1 if $attr->{class} eq 'titrevo_film';
                $self->{insideInfos} = 1 if ($attr->{face} eq 'arial')
                    && ($attr->{size} eq '2');
                $self->{insideArtists} = 1 if ($attr->{face} eq 'verdana,geneva,arial')
                    && ($attr->{size} eq '2');
                $self->{insideSynopsis} = 1 if ($attr->{class} eq 'link6')
                                            && ($self->{inside}->{fieldset})
                                            && (!$self->{curInfo}->{synopsis});
            }
            elsif ($tagname eq 'h2')
            {
                $self->{insideOrig} = 1 if $attr->{style}  eq 'color: #333333; font-size:13px';
            }
            elsif ($tagname eq 'br')
            {
                if ($self->{insideSynopsis})
                {
                    $self->{curInfo}->{synopsis} .= "\n";
                }
            }
        }
    }

    sub end
    {
        my ($self, $tagname) = @_;
		
        $self->{inside}->{$tagname}--;
        $self->{insideSynopsis} = 0 if $tagname eq 'font';

    }

    sub text
    {
        my ($self, $origtext) = @_;

        return if length($origtext) < 2;
        $origtext =~ s/\s{2,}//g;
        $origtext =~ s/\n*//g if !$self->{insideSynopsis};

        if ($self->{parsingList})
        {
            if ($self->{isMovie})
            {
                if (($self->{inside}->{h1}) || ($self->{inside}->{h2}))
                {
                    $self->{itemsList}[$self->{itemIdx}]->{title} = $origtext;
                    $self->{isMovie} = 0;
                    $self->{isInfo} = 1;
                    return;
                }
            }
            elsif ($self->{isInfo})
            {
                if (($origtext =~ /([0-9]{4}) - [0-9]*h[0-9]*/)
                 || ($origtext =~ /([0-9]{4}) - [0-9]* mn/))
                {
                    $self->{itemsList}[$self->{itemIdx}]->{date} = $1;
                }
                elsif ($origtext =~ /^\s*R.alisation : (.*)/)
                {
                    $self->{itemsList}[$self->{itemIdx}]->{director} =$1;
                }
                elsif ($origtext =~ /^\s*avec (.*)/)
                {
                    $self->{itemsList}[$self->{itemIdx}]->{actors} = $1;
                    $self->{isInfo} = 0;        #$html =~ s|<br\s*/>|\n|g;

                }
            }
        }
        else
        {
            if ($self->{inside}->{h1}
            && !$self->{curInfo}->{title})
            {
                $self->{curInfo}->{title} = $origtext;
            }
            elsif ($self->{insideOrig})
            {
                $self->{curInfo}->{original} = $origtext
                    if !$self->{curInfo}->{original};
                $self->{insideOrig} = 0;
            }
            if ($self->{insideInfos})
            {
                if ($origtext =~ /([0-9]{4})- (.*?)- ([^-]*)(?:- (.*))?/)
                {
                    my $date = $1, my $nat = $2, my $type = $3, my $time = $4;
                    $nat =~ s|/|, |g;
                    $type =~ s|/|,|g;
                    
                    $self->{curInfo}->{date} = $date;
                    $self->{curInfo}->{country} = $nat;
                    $self->{curInfo}->{genre} = $type;
                    $self->{curInfo}->{time} = $time;
                }
                $self->{insideInfos} = 0;
            }
            elsif ($self->{insideArtists})
            {
                if ($origtext =~ /R.alisation\s*:\s*(.*)/)
                {
                    $self->{curInfo}->{director} = $1 if !$self->{curInfo}->{director};
                }
                elsif ($origtext =~ /avec\s*:?\s*(.*)/i)
                {
                    if (!$self->{curInfo}->{actors})
                    {
                        $self->{curInfo}->{actors} = $1;
                        $self->{curInfo}->{actors} =~ s/\s*\(([^\)]*)\)\s*/;$1/g;
                    }
                }
                $self->{insideArtists} = 0;
            }
            elsif ($self->{insideSynopsis})
            {
                $self->{curInfo}->{synopsis} .= $origtext;
            }
        }
    } 

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);

        $self->{hasField} = {
            title => 1,
            date => 1,
            director => 1,
            actors => 1,
        };

        $self->{isInfo} = 0;
        $self->{isMovie} = 0;
        $self->{curName} = undef;
        $self->{curUrl} = undef;

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;
        $html =~ s/<!--[^-]*-->//g;
        $html =~ s/<b>|<\/b>//g;
        $html =~ s/&nbsp;/ /g;
        $html =~ s/\\'//g;
        $html =~ s|<A HREF="/modules/Artistes/fiche/[0-9]*[^>]*>(.*?)</A>|$1|gi;
        $html =~ s/<font class=link_news_2>([^<]*)<\/font>/$1/gi;
        $html =~ s/<font class=link4dtext>([^<]*)<br>([^<]*)<\/TD>/<font class=link4dtext>$1 $2<\/font><\/TD>/gi;
        $html =~ s|<h1>Oops\!</h1>||gi;

        $html =~ s|\x{92}|'|gi;
        $html =~ s|&#146;|'|gi;
        $html =~ s|&#149;|*|gi;
        $html =~ s|&#156;|oe|gi;
        $html =~ s|&#133;|...|gi;
        $html =~ s|\x{85}|...|gi;
        $html =~ s|\x{8C}|OE|gi;
        $html =~ s|\x{9C}|oe|gi;

        return $html;
    }
    
    sub getSearchUrl
    {
		my ($self, $word) = @_;
	
		return "http://www.cinemotions.com/recherche/$word.html"
    }
    
    sub getItemUrl
    {
		my ($self, $url) = @_;
		
			return 'http://www.cinemotions.com' . $url;
    }

    sub getName
    {
        return 'Cinemotions.com';
    }
    
    sub getAuthor
    {
        return 'MeV';
    }
    
    sub getLang
    {
        return 'FR';
    }

}

1;
