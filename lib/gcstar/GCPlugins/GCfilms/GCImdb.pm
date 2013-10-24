package GCPlugins::GCfilms::GCImdb;

###################################################
#
#  Copyright 2010 groms
#
#  Features:
#  + Multiple directors separated by comma
#  + Multiple countries separated by comma
#  + Correct URL in case of redirection
#  + Fetches Original Title
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
        }
        
        if ($self->{parsingList})
        {
            if ($tagname eq "a")
            {
                my $url = $attr->{href};
                if (($url =~ /^\/title\//) && (!$self->{alreadyListed}->{$url}))
                {
                    $self->{isMovie} = 1;
                    $self->{isInfo} = 1;
                    $self->{itemIdx}++;
                    $self->{itemsList}[$self->{itemIdx}]->{url} = $url;
                    $self->{alreadyListed}->{$url} = 1;
                }
            }
        }
        else
        {
        
            if ($tagname eq "link")
            {
                if ($attr->{rel} eq "canonical")
                {
                    $self->{curInfo}->{webPage} = $attr->{href};
                }
            }
            elsif ($tagname eq "h1")
            {
                if ($attr->{class} eq "header")
                {
                    $self->{insideHeader} = 1;
                }
            }
            elsif ($tagname eq "div")
            {
                if ($attr->{class} eq "infobar")
                {
                    $self->{insideInfobar} = 1;
                }
            }
            elsif ($tagname eq "table")
            {
                if ($attr->{class} eq "cast_list")
                {
                    $self->{insideCastList} = 1;
                }
            }
            elsif ($tagname eq "span")
            {
                if ($attr->{itemprop} eq "ratingValue")
                {
                    $self->{insideRating} = 1;
                }
                elsif ($attr->{class} eq "title-extra")
                {
                    $self->{insideOriginalTitle} = 1;
                }
            }
            elsif ($tagname eq "img")
            {
                if ($self->{insidePrimaryImage})
                {
                    if (!($attr->{src} =~ m/nopicture/))
                    {
                        ($self->{curInfo}->{image} = $attr->{src}) =~ s/_V1\._.+\./_V1\._SX1000_SY1000_\./;
                    }
                }
                elsif ($self->{insideInfobar} && $attr->{src} =~ m|/certificates/us/|)
                {
                    my $cert = $attr->{title};
                    $self->{curInfo}->{age} = 1 if ($cert eq 'Unrated') || ($cert eq 'Open');
                    $self->{curInfo}->{age} = 2 if ($cert eq 'G') || ($cert eq 'Approved');
                    $self->{curInfo}->{age} = 5 if ($cert eq 'PG') || ($cert eq 'M') || ($cert eq 'GP');
                    $self->{curInfo}->{age} = 13 if $cert eq 'PG_13';
                    $self->{curInfo}->{age} = 17 if $cert eq 'R';
                    $self->{curInfo}->{age} = 18  if ($cert eq 'NC_17') || ($cert eq 'X');
                }
            }
            elsif ($tagname eq "a")
            {
                if ($self->{insideHeader} && $attr->{href} =~ m/year/)
                {
                    $self->{insideYear} = 1; 
                }
                elsif ($self->{insideInfobar} && $attr->{href} =~ m/genre/)
                {
                    $self->{insideGenre} = 1;
                }
            }
            elsif ($tagname eq 'td')
            {
                if ($self->{insideCastList})
                {
                    if ($attr->{class} eq 'name')
                    {
                        $self->{insideActor} = 1;
                    }
                    elsif ($attr->{class} eq 'character')
                    {
                        $self->{insideRole} = 1;
                    }
                }
                elsif ($attr->{id} eq "img_primary") {
                    $self->{insidePrimaryImage} = 1;
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
                my $url = $self->{itemsList}[$self->{itemIdx}]->{url};
                if (!$self->{itemsList}[$self->{itemIdx}]->{title})
                {
                    $self->{alreadyListed}->{$url} = 0;
                    $self->{itemIdx}--;
                }
            }
        } else {
            if ($tagname eq "h1")
            {
                $self->{insideHeader} = 0;
            }
            elsif ($tagname eq "a")
            {
                $self->{insideYear} = 0;
                $self->{insideGenre} = 0;
                $self->{insideActor} = 0;
                $self->{insideRole} = 0;
            }
            elsif ($tagname eq "div")
            {
                $self->{insideInfobar} = 0;
                $self->{insideNat} = 0;
                $self->{insideDirector} = 0;
                $self->{insideStoryline} = 0;
                $self->{insideReleaseDate} = 0;
            }
            elsif ($tagname eq "span")
            {
                $self->{insideRating} = 0;
                $self->{insideOriginalTitle} = 0;
            }
            elsif ($tagname eq "table")
            {
                $self->{insideCastList} = 0;
            }
            elsif ($tagname eq "td")
            {
                $self->{insidePrimaryImage} = 0;
            }
            elsif ($self->{insideCastList})
            {
                if ($self->{actor} && $self->{role})
                {
                    $self->{actor} =~ s/^\s+|\s+$//g;
                    $self->{actor} =~ s/\s{2,}/ /g;
                    push @{$self->{curInfo}->{actors}}, [$self->{actor}];
                    $self->{role} =~ s/^\s+|\s+$//g;
                    $self->{role} =~ s/\s{2,}/ /g;
                    push @{$self->{curInfo}->{actors}->[$self->{actorsCounter}]}, $self->{role};                               
                    $self->{actorsCounter}++;
                }
                $self->{actor} = "";
                $self->{role} = "";
            } 
        }
    }

    sub text
    {
        my ($self, $origtext) = @_;

        return if length($origtext) < 2;
        
        $origtext =~ s/^\s+|\s+$//g;

        return if ($self->{parsingEnded});
        
        if ($self->{parsingList})
        {
            if ($self->{inside}->{h1} && $origtext !~ m/IMDb\s*Title\s*Search/i)
            {
                $self->{parsingEnded} = 1;
                $self->{itemIdx} = 0;
                $self->{itemsList}[0]->{url} = $self->{loadedUrl};
            }
            if ($self->{isMovie})
            {
                $self->{itemsList}[$self->{itemIdx}]->{title} = $origtext;
                $self->{isMovie} = 0;
                $self->{isInfo} = 1;
                return;
            }
            if ($self->{isInfo})
            {
                $self->{itemsList}[$self->{itemIdx}]->{date} = $1 if $origtext =~ m|\(([0-9]*)(/I+)?\)|;
                $self->{isInfo} = 0;
            }
        }
        else
        {
            if ($self->{insideHeader})
            {
                if ($self->{insideYear})
                {
                    $self->{curInfo}->{date} = $origtext;
                }
                elsif (!$self->{curInfo}->{title})
                {
                    $self->{curInfo}->{title} = $origtext;
                    if (!$self->{curInfo}->{original})
                    {
                        $self->{curInfo}->{original} = $origtext;
                    }
                }
                elsif ($self->{insideOriginalTitle} && !$self->{inside}->{i})
                {
                    $self->{curInfo}->{original} = $origtext;
                }
            }
            elsif ($self->{insideInfobar})
            {
                if ($self->{insideGenre})
                {
                    if ($self->{curInfo}->{genre})
                    {
                        $self->{curInfo}->{genre} .= ",";
                    }
                    $self->{curInfo}->{genre} .= $origtext;
                }
                elsif ($origtext =~ m/([0-9]+ min)/)
                {
                    $self->{curInfo}->{time} = $1;
                }
            }
            elsif ($self->{insideRating} && $origtext =~ m/[0-9]\.[0-9]/)
            {
                $self->{curInfo}->{ratingpress} = int($origtext + 0.5);
            }
            elsif ($self->{insideSynopsis})
            {
                $self->{curInfo}->{synopsis} .= $origtext;
            }
            elsif ($self->{insideNat})
            {
                if ($origtext =~ m/[^\s].+/)
                {
                    if ($self->{curInfo}->{country} =~ m/.+/)
                    {
                        $self->{curInfo}->{country} .= ", ".$origtext;
                    }
                    else
                    {
                        $self->{curInfo}->{country} = $origtext;
                    }
                }
            }
            elsif ($self->{insideCastList})
            {
                if ($self->{insideActor})
                {
                    $self->{actor} .= $origtext;
                }
                elsif ($self->{insideRole})
                {
                    $self->{role} .= $origtext;
                }
            }
            elsif ($self->{insideStoryline} && $self->{inside}{p})
            {
                $self->{curInfo}->{synopsis} = $origtext;
                $self->{insideStoryline} = 0;
            }
            elsif ($self->{insideDirector} && $self->{inside}->{div})
            {
                    $origtext =~ s/,/, /;
                    $self->{curInfo}->{director} .= $origtext;		
            }
            elsif ($self->{insideReleaseDate} && !$self->{curInfo}->{date}) {
                if ($origtext =~ m/([0-9]{4})/)
                {
                    $self->{curInfo}->{date} = $1;
                    $self->{insideReleaseDate} = 0;
                }
            }
            
            if ($self->{inside}->{h2})
            {
                $self->{insideStoryline} = 1 if ($origtext eq "Storyline");
            }
            elsif ($self->{inside}->{h4})
            {
                $self->{insideDirector} = 1 if $origtext =~ m/Directors?:/;
                $self->{insideTime} = 1 if $origtext =~ m/Runtime:/;
                $self->{insideNat} = 1 if $origtext =~ m/Country:/;
                $self->{insideReleaseDate} = 1 if $origtext =~ m/Release Date:/;
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
            director => 0,
            actors => 0,
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

        $self->{parsingEnded} = 0;
        
        if ($self->{parsingList})
        {
            $self->{alreadyListed} = {};
        }
        else
        {
            #$html =~ s|<a href="synopsis">[^<]*</a>||gi;
            #$html =~ s|<a href="/name/.*?"[^>]*>([^<]*)</a>|$1|gi;
            #$html =~ s|<a href="/character/ch[0-9]*/">([^<]*)</a>|$1|gi;
            #$html =~ s|<a href="/Sections/.*?">([^<]*)</a>|$1|gi;

            # Commented out this line, causes bug #14420 when importing from named lists
            #$self->{curInfo}->{actors} = [];
        }
        
        
        return $html;
    }

    sub getSearchUrl
    {
		my ($self, $word) = @_;
	
		return "http://www.imdb.com/find?s=tt&q=$word";
    }
    
    sub getItemUrl
    {
		my ($self, $url) = @_;
		
    return "http://www.imdb.com" if $url eq "";
		return $url if $url =~ /^http:/;
		return "http://www.imdb.com".$url;
    }

    sub getName
    {
        return "IMDb";
    }
    
    sub getAuthor
    {
        return 'groms';
    }
    
    sub getLang
    {
        return 'EN';
    }

}

1;
