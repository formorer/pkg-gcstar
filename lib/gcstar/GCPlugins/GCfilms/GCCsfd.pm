# Replace SiteTemplate with your plugin name.
# The package name must exactly match the file name (.pm)
package GCPlugins::GCfilms::GCCsfd;

###################################################
#
#  Copyright 2005-2010 Christian Jodar
#  Copyright 2007 Petr Gajdusek (Pajdus) <gajdusek.petr@centrum.cz>
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

# I like the plugin fetch movie rating and user comments from
# website too but these fields are not imported by gcstar (you need
# to alter GCfilms.gcm.  Is it ok for plugin to set this fields
# ($self->{curInfo}->{comment} and $self->{curInfo}->{rating}), that are
# ingored by gcstar by default, or should i avoid this?

use strict;
use utf8;

use GCPlugins::GCfilms::GCfilmsCommon;

{
    # Replace SiteTemplate with your exporter name
    # It must be the same name as the one used for file and main package name
    package GCPlugins::GCfilms::GCPluginCsfd;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    # getSearchUrl
    # Used to get the URL that to be used to perform searches.
    # $word is the query
    # Returns the full URL.
    sub getSearchUrl
    {
        my ($self, $word) = @_;
        my $url;

        # Your code here
        $url = return "http://www.csfd.cz/search_pg.php?search=$word";

        return $url;
    }

    # getItemUrl
    # Used to get the full URL of a movie page.
    # Useful when url on results pages are relative.
    # $url is the URL as found with a search.
    # Returns the absolute URL.
    sub getItemUrl
    {
        my ($self, $url) = @_;
        my $absUrl = "http://www.csfd.cz" . $url;

        # Your code here

        return $absUrl;
    }

    # getCharset
    # Used to convert charset in web pages.
    # Returns the charset as specified in pages.
    sub getCharset
    {
        my $self = shift;

        return "WINDOWS-1250";
    }

    # getName
    # Used to display plugin name in GUI.
    # Returns the plugin name.
    sub getName
    {
        return "CSFD.cz";
    }

    # getAuthor
    # Used to display the plugin author in GUI.
    # Returns the plugin author name.
    sub getAuthor
    {
        return 'Pajdus';
    }

    # getLang
    # Used to fill in plugin list with user language plugins
    # Return the language used for this site (2 letters code).
    sub getLang
    {
        return 'CS';
    }

    # hasSearchYear
    # Used to hide year column in search results
    # Return 0 to hide column, 1 to show it.
    sub hasSearchYear
    {
        return 1;
    }

    # hasSearchDirector
    # Used to hide director column in search results
    # Return 0 to hide column, 1 to show it.
    sub hasSearchDirector
    {
        return 0;
    }

    # hasSearchActors
    # Used to hide actors column in search results
    # Return 0 to hide column, 1 to show it.
    sub hasSearchActors
    {
        return 0;
    }

    # getExtra
    # Used if the plugin wants an extra column to be displayed in search results
    # Return the column title or empty string to hide the column.
    sub getExtra
    {

        return '';
    }

    # changeUrl
    # Can be used to change URL if movie URL and the one used to
    # extract information are different.
    # Return the modified URL.
    sub changeUrl
    {
        my ($self, $url) = @_;

        return $url;
    }

    # In processing functions below, self->{parsingList} can be used.
    # If true, we are processing a search results page
    # If false, we are processing a movie information page.

    # $self->{inside}->{tagname} (with correct value for tagname) can be used to test
    # if we are in the corresponding tag.

# You have a counter $self->{movieIdx} that have to be used when processing search results.
# It is your responsability to increment it!

    # When processing search results, you have to fill (if available) following fields:
    #
    #  $self->{movieList}[$self->{movieIdx}]->{title}
    #  $self->{movieList}[$self->{movieIdx}]->{url}
    #  $self->{movieList}[$self->{movieIdx}]->{actors}
    #  $self->{movieList}[$self->{movieIdx}]->{director}
    #  $self->{movieList}[$self->{movieIdx}]->{date}
    #  $self->{movieList}[$self->{movieIdx}]->{extra}

# When processing a movie page, you need to fill the fields (if available) in $self->{curInfo}. They are:
#
#  $self->{curInfo}->{title}
#  $self->{curInfo}->{director}
#  $self->{curInfo}->{original}        (Original title)
#  $self->{curInfo}->{actors}
#  $self->{curInfo}->{genre}        (Comma separated list of movie type)
#  $self->{curInfo}->{country}        (Movie Nationality or country)
#  $self->{curInfo}->{date}
#  $self->{curInfo}->{time}
#  $self->{curInfo}->{synopsis}
#  $self->{curInfo}->{image}
#  $self->{curInfo}->{audio}
#  $self->{curInfo}->{subt}
#  $self->{curInfo}->{age}          0     : No information
#                                   1     : Unrated
#                                   2     : All audience
#                                   5     : Parental Guidance
#                                   >= 10 : Minimum age value

    # start
    # Called each time a new HTML tag begins.
    # $tagname is the tag name.
    # $attr is reference to an associative array of tag attributes.
    # $attrseq is an array reference containing all the attributes name.
    # $origtext is the tag text as found in source file
    # Returns nothing
    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
            # Your code for processing search results here
            if ($tagname eq "a")
            {
                if ($attr->{href} =~ m/\/film\/[0-9]+-.*/)
                {
                    $self->{isMovie} = 1;
                    $self->{isInfo}  = 1;
                    $self->{itemIdx}++;
                    $self->{itemsList}[ $self->{itemIdx} ]->{url} = $attr->{href};
                }
            }
            elsif ($tagname eq "div")
            {
                if ($attr->{class} eq "year")
                {
                    $self->{isYear} = 1;
                }
            }
        }
        else
        {
            # Your code for processing movie information here
            if ($tagname eq "span")
            {
                if ($attr->{class} eq "komentar_font")
                {
                    $self->{insideSynopsis} = 1;
                }
            }
            elsif ($tagname eq "h1")
            {
#				if ($attr->{style} eq "font-size: 18px; font-weight: bold; color: rgb(0, 0, 0); font-family: Tahoma;")
                if ($attr->{style} =~ m/Tahoma/)
                {
                    $self->{insideName} = 1;
                }
            }
            elsif ($tagname eq "table")
            {
                if ($attr->{background} =~ m/http:\/\/img\.csfd\.cz\/posters\//)
                {
                    $self->{curInfo}->{image} = $attr->{background};
                }
            }
            elsif ($tagname eq "div")
            {
                if ($attr->{class} eq "title")
                {
                    $self->{insideTitle} = 1;
                }
                if ($attr->{class} eq "genre")
                {

                    # we are after all language movie names, find the
                    # original one, which is always second
                    if ($self->{title_nm} < 1)
                    {
                        $self->{curInfo}->{original} = $self->{curInfo}->{title};
                    }
                    elsif ($self->{title_nm} < 2)
                    {
                        $self->{curInfo}->{original} = $self->{titles}[1];
                    }
                    else
                    {
                        $self->{curInfo}->{original} = $self->{titles}[2];
                    }
                    # genres
                    $self->{insideGenre} = 1;
                }

                $self->{insideInfo}     = 1 if ($attr->{class} eq "info");
                $self->{insideDirector} = 1 if ($attr->{class} eq "director");
                $self->{insideActor}    = 1 if ($attr->{class} eq "actor");
            }
            # optional
            if ($tagname eq "td")
            {
                if ($attr->{style} =~ m/font-size:36px/)
                {
                    $self->{insideRating} = 1;
                }
            }
            elsif ($tagname eq "div")
            {
                if ($attr->{class} eq "commenter")
                {
                    $self->{insideCommenter} = 1;
                }
                if ($attr->{class} eq "komentar_font")
                {
                    $self->{insideComment} = 1;
                }
            }
        }
    }

    # end
    # Called each time a HTML tag ends.
    # $tagname is the tag name.
    sub end
    {
        my ($self, $tagname) = @_;
        $self->{inside}->{$tagname}--;

        if ($self->{parsingList})
        {
            # Your code for processing search results here
        }
        else
        {
            # Your code for processing movie information here
            if ($tagname eq "div")
            {
                if ($self->{insideDirector})
                {
                    $self->{curInfo}->{director} =~ s/&nbsp;/ /g;
                    $self->{insideDirector} = 0;
                }
                if ($self->{insideActor})
                {
                    $self->{curInfo}->{actors} =~ s/&nbsp;/ /g;
                    $self->{insideActor} = 0;
                }
            }
            elsif ($tagname eq "span")
            {
                if ($self->{insideSynopsis})
                {
                    $self->{curInfo}->{synopsis} =~ s/[ \n\t]*(.*)/$1/g;
                    $self->{insideSynopsis} = 0;
                }
            }
            # optional
            if ($tagname eq "div")
            {
                if ($self->{insideComment})
                {
                    $self->{curInfo}->{comment} .= "\n\n";
                    $self->{insideComment} = 0;
                }
            }
        }
    }

    # text
    # Called each time some plain text (between tags) is processed.
    # $origtext is the read text.
    sub text
    {
        my ($self, $origtext) = @_;

        return if length($origtext) < 2;

        if ($self->{parsingList})
        {
            # Your code for processing search results here
            if ($self->{isMovie})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{"title"} = $origtext;
                $self->{isMovie}                                  = 0;
                $self->{isInfo}                                   = 1;
                return;
            }
            elsif ($self->{isYear})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{"date"} = $origtext;
                $self->{isYear} = 0;
            }

        }
        else
        {
            # Your code for processing movie information here
            if ($self->{insideName})
            {
                $origtext =~ s/\n[ ]*(.*)/$1/;
                $self->{curInfo}->{title} = $origtext if !$self->{curInfo}->{title};
                $self->{insideName} = 0;
            }
            elsif ($self->{insideTitle})
            {
                $self->{title_nm}++;
                $self->{titles}[ $self->{title_nm} ] = $origtext;
                $self->{insideTitle} = 0;
            }
            elsif ($self->{insideGenre})
            {
                $origtext =~ s/ \/ /,/g;
                $origtext =~ s/&nbsp;/ /g;
                $origtext =~ s/[ ]*(.*)[ ]*/$1/;
                $self->{curInfo}->{genre} = $origtext;
                $self->{insideGenre} = 0;
            }
            elsif ($self->{insideInfo})
            {
                ($self->{curInfo}->{country} = $origtext) =~ s/([^,]*).*/$1/;
                ($self->{curInfo}->{date}    = $origtext) =~ s/[^,]*, ([0-9]+).*/$1/;
                ($self->{curInfo}->{time}    = $origtext) =~ s/[^,]*,[^,]*, (.*)/$1/;
                $self->{insideInfo} = 0;
            }
            elsif ($self->{insideDirector})
            {
                $self->{curInfo}->{director} .= $origtext;
            }
            elsif ($self->{insideActor})
            {
                $self->{curInfo}->{actors} .= $origtext;
            }
            elsif ($self->{insideSynopsis})
            {
                $self->{curInfo}->{synopsis} .= $origtext;
            }
            # optional
            elsif ($self->{insideRating})
            {
                $origtext =~ s/[ ]*([0-9]+)%[ ]*/$1/;
                $self->{curInfo}->{ratingpress} = int($origtext / 10 + .5);
                $self->{insideRating} = 0;
            }
            elsif ($self->{insideComment})
            {
                $self->{curInfo}->{comment} .= $origtext;
            }
            elsif ($self->{insideCommenter})
            {
                $self->{curInfo}->{comment} .= $origtext . "\n";
                $self->{insideCommenter} = 0;
            }
        }
    }

    # new
    # Constructor.
    # Returns object reference.
    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();

        # Do your init stuff here

        bless($self, $class);

        $self->{hasField} = {
            title    => 1,
            date     => 1,
            director => 0,
            actors   => 0,
        };

        $self->{isInfo}   = 0;
        $self->{isMovie}  = 0;
        $self->{curName}  = undef;
        $self->{curUrl}   = undef;
        $self->{title_nm} = 0;

        return $self;
    }

    # preProcess
    # Called before each page is processed. You can use it to do some substitutions.
    # $html is the page content.
    # Returns modified version of page content.
    sub preProcess
    {
        my ($self, $html) = @_;

        # Your code to modify $html here.
        # search results
        #<<< keep perltidy out of here
        $html =~
          s{(<a href="\/film\/[0-9]+-[^ ]*") style="font-size:12px">([^<]*)<\/a> \(([0-9]{4})\)<br>}
           {$1>$2<\/a><div class="year">$3<\/div><br>\n}g;

        ## information
        # titles
        $html =~
          s{<table[^>]*>(?:<tbody>)?<tr><td[^>]*><img src=(?:"|')http:\/\/img\.csfd\.cz\/images\/flag_[0-9]+\.gif(?:"|')[^>]*><\/td><td>([^<]*)<\/td><\/tr>(?:<\/tbody>)?<\/table>}
           {<div class="title">$1<\/div>\n}g;

        # genre, info, directors, actors
        # kvuli chybe v designu stranek je pposledni </div> jiz obsazen na strance
        $html =~
          s{[ ]*<(?:br|BR)>[ ]*<b>([^<]*)<[b|B][r|R]>([^<]*)<\/b><[b|B][r|R]><[b|B][r|R]><b>[^<]*<\/b>[ ]*(.*?)<[B|b][r|R]><b>[^<]*<\/b>[ ]*(.*?)<br>&nbsp;<br><\/td>[ ]*}
           {<div class="genre">$1<\/div>\n<div class="info">$2<\/div>\n<div class="director">$3<\/div>\n<div class="actor">$4\n}g;

        ## optional
        ## comment author
        # convert graphic stars to text stars
        $html =~
          s{(<img src="http:\/\/img.csfd.cz\/images\/new\/film\/star_red_white\.gif" alt="\*">)}
           {\*}g;

        $html =~
          s{>&nbsp;<b>([^<]+)<\/b>&nbsp;&nbsp;([\*]*)}
           {><div class="commenter">$1 $2<\/div>}g;

        #>>>
        return $html;
    }

}

1;
