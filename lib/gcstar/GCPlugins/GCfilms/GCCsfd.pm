# Replace SiteTemplate with your plugin name.
# The package name must exactly match the file name (.pm)
package GCPlugins::GCfilms::GCCsfd;

###################################################
#
#  Copyright 2005-2009 Tian
#  Copyright 2007,2011 Petr Gajdůšek <gajdusek.petr@centrum.cz>
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
#use warnings;
use utf8;

use GCPlugins::GCfilms::GCfilmsCommon;

{

    # Replace SiteTemplate with your exporter name
    # It must be the same name as the one used for file and main package name
    package GCPlugins::GCfilms::GCPluginCsfd;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    # getSearchCharset
    # Charset of search term
    sub getSearchCharset
    {
        return 'UTF-8';
    }

    # getSearchUrl
    # Used to get the URL that to be used to perform searches.
    # $word is the query
    # Returns the full URL.
    sub getSearchUrl
    {
        my ($self, $word) = @_;
        return "http://www.csfd.cz/hledat/?q=$word";
    }

    # getItemUrl
    # Used to get the full URL of a movie page.
    # Useful when url on results pages are relative.
    # $url is the URL as found with a search.
    # Returns the absolute URL.
    sub getItemUrl
    {
        my ($self, $url) = @_;

        $url = "http://www.csfd.cz" . $url if ($url !~ /^http:/);
        return $url;
    }

    # getCharset
    # Used to convert charset in web pages.
    # Returns the charset as specified in pages.
    #sub getCharset {
    #	my $self = shift;
    #
    #	return "UTF-8";
    #}

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
        return 'Petr Gajdůšek';
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
        return 1;
    }

    # hasSearchActors
    # Used to hide actors column in search results
    # Return 0 to hide column, 1 to show it.
    sub hasSearchActors
    {
        return 1;
    }

    # getExtra
    # Used if the plugin wants an extra column to be displayed in search results
    # Return the column title or empty string to hide the column.
    sub getExtra
    {

        return 'Žánr';
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

	# preProcess
	# Called before each page is processed. You can use it to do some substitutions.
	# $html is the page content.
	# Returns modified version of page content.
    sub preProcess
    {
        my ($self, $html) = @_;
        $self->{parsingEnded} = 0;
        if ($self->{parsingList})
        {
            # Search results

	        # Initial values for search results parsing
	        # There are two movies list:
	        # First with detailed info (title, genre, origin country, year, directors, actors)
	        # Second with brief list of other movies (title, year)

            # We are in brief list containing other movies without details
            $self->{insideOtherMovies} = 0;
            # Movie link; movie's details follow if not in brief list
            $self->{isMovie} = 0;

            ## Details:

            # Movie's details will follow: Genre, origin, actors, directors, year
            $self->{insideDetails} = 0;
            # In movie's details after paragraph with Genre, origin and date
            $self->{wasDetailsInfo} = 0;
            # In movie's details: directors and actors
            $self->{directors}        = ();
            $self->{directorsCounter} = 0;
            $self->{actors}           = ();
            $self->{actorsCounter}    = 0;
            $self->{insideDirectors}  = 0;
            $self->{insideActors}     = 0;

            # Movie year
            $self->{isYear} = 0;

            ## Preprocess

            # directors and actors
            $html =~ s/\n\s*Režie:\s([^\n]*)/<div class="directors">$1<\/div>/g;
            $html =~ s/\n\s*Hrají:\s([^\n].*)/<div class="actors">$1<\/div>/g;
            # year
            $html =~ s/<span class="film-year">\(([0-9]+)\)<\/span>/<span class="film-year">$1<\/span>/g;
        }
        else
        {
            # Movie page

            # Initial values for search results parsing

            # array containg other movie titles (not exported to GCStar)
            $self->{titles} = ();
            # in list containing other movie titles
            $self->{isTitles} = 0;
            # in the original title (title for same country as movie's origin)
            $self->{isOrigTitle} = 0;
            # original title (if not set during parsing it will be set to main title at the end)
            $self->{origTitle}     = undef;
            $self->{titlesCounter} = 0;

            $self->{insideGenre} = 0;

            $self->{awaitingSynopsis} = 0;
            $self->{insideSynopsis}   = 0;

            # inside details with country, date (year) and time (length)
            $self->{insideInfo} = 0;

            $self->{insideRating} = 0;

            # User comments
            # Each comment consists of commenter (user) and his comment

            $self->{insideCommentAuthor} = 0;
            $self->{awaitingComment}     = 0;
            $self->{insideComment}       = 0;

            # In directors and actors
            $self->{insideDirectors}  = 0;
            $self->{insideActors}     = 0;
            $self->{directors}        = ();
            $self->{directorsCounter} = 0;
            $self->{actors}           = ();
            $self->{actorsCounter}    = 0;

            ## Preprocess

            # removee <br /> and <br>
            $html =~ s/<br( \/)?>/\n/g;
            ## Synopsis
            # remove list bullet
            $html =~ s/<img src="http:\/\/img.csfd.cz\/sites\/web\/images\/common\/li.gif"[^>]*>//g;
            # remove hyperlink to user profile
            $html =~ s/(&nbsp;<span class="source[^\(]*\()<a[^>]*>([^<]*)<\/a>/$1uživatel $2/g;
            # remove <span></span> around synopsis source
            $html =~ s/&nbsp;<span class="source[^\(]*\(([^\)]*)\)<\/span>/\n-- $1/g;
            $html =~ s/<div data-truncate="570">([^<]*)<\/div>/$1/g;
        }
        return $html;
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


        if ($self->{parsingEnded})
        {
            return;
        }

        if ($self->{parsingList})
        {

            # in brief list of other movies (without details)
            if ($tagname eq "ul" and $attr->{class} eq "films others")
            {
                $self->{insideOtherMovies} = 1;
            }

            # in link to movie page
            if ($tagname eq "a" and $attr->{href} =~ m/\/film\/[0-9]+-.*/)
            {
                $self->{isMovie} = 1;
                $self->{itemIdx}++;
                $self->{itemsList}[ $self->{itemIdx} ]->{url} = $attr->{href};
                $self->{insideDetails} = 1 if ($self->{insideOtherMovies} != 1);
                $self->{wasDetailsInfo} = 0;
            }

            # directors and actors
            if ($tagname eq "div")
            {
                $self->{insideDirectors} = 1 if ($attr->{class} eq "directors");
                $self->{insideActors}    = 1 if ($attr->{class} eq "actors");
            }

            # year
            if ($tagname eq "span")
            {
                $self->{isYear} = 1 if ($attr->{class} eq "film-year");
            }
        }
        else
        {

            # Synopsis
            if (    $tagname eq "div"
                and $attr->{class} eq "content"
                and $self->{awaitingSynopsis})
            {
                $self->{insideSynopsis}   = 1;
                $self->{awaitingSynopsis} = 0;
            }

            # Poster
            if (    $tagname eq "img"
                and $attr->{src} =~ /^http:\/\/img\.csfd\.cz\/posters\//)
            {
                $self->{curInfo}->{image} = $attr->{src};
            }

            # Original name and other names
            if ($tagname eq "ul" and $attr->{class} eq "names")
            {
                $self->{isTitles} = 1;
            }

            if ($tagname eq "img" and $self->{isTitles})
            {
                $self->{isOrigTitle} = 1 if ($attr->{alt} !~ /název$/);
                $self->{isSKTitle}   = 1 if ($attr->{alt} =~ /SK název$/);
            }

            # Genre
            if ($tagname eq "p" and $attr->{class} eq "genre")
            {
                $self->{insideGenre} = 1;
            }

            # Info (country ,date, time = duration)
            if ($tagname eq "p" and $attr->{class} eq "origin")
            {
                $self->{insideInfo} = 1;
            }

            # Rating
            if ($tagname eq "h2" and $attr->{class} eq "average")
            {
                $self->{insideRating} = 1;
            }

            # Comments
            if ($tagname eq "h5" and $attr->{class} eq "author")
            {
                $self->{insideCommentAuthor} = 1;
            }
            if ($self->{awaitingComment} and $tagname eq "p" and $attr->{class} eq "post")
            {
                $self->{awaitingComment} = 0;
                $self->{insideComment}   = 1;
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

            # movie details
            $self->{insideDetails} = 0
              if ($tagname eq "div")
              and $self->{insideDetails};

            # directors and actors
            if ($tagname eq "div")
            {
                if ($self->{insideDirectors})
                {
                    $self->{insideDirectors} = 0;
                    $self->{itemsList}[ $self->{itemIdx} ]->{director} =
                      join(', ', @{$self->{directors}});
		            $self->{directors}        = ();
		            $self->{directorsCounter} = 0;
                }
                if ($self->{insideActors})
                {
                    $self->{insideActors} = 0;
                    $self->{itemsList}[ $self->{itemIdx} ]->{actors} =
                      join(', ', @{$self->{actors}});
                    $self->{actors}           = ();
                    $self->{actorsCounter}    = 0;
                }
            }
        }
        else
        {

            # Synopsis
            $self->{insideSynopsis} = 0 if ($tagname eq "div");

            # Titles
            if ($tagname eq "ul" and $self->{isTitles})
            {
                $self->{isTitles} = 0;
            }

            if ( $tagname eq "body" )
            {
            	$self->{curInfo}->{original} ||= $self->{curInfo}->{title};
            } 

            # Actors
            if ($tagname eq "div" and $self->{insideActors})
            {
                $self->{curInfo}->{actors} = join(', ', @{$self->{actors}});
                $self->{insideActors} = 0;
            }

            # Directors
            if ($tagname eq "div" and $self->{insideDirectors})
            {
                $self->{curInfo}->{director} = join(', ', @{$self->{directors}});
                $self->{insideDirectors} = 0;
            }

            # Comment

            $self->{insideCommentAuthor} = 0
              if ($tagname eq "h5" and $self->{insideCommentAuthor});

            if ($tagname eq "li" and $self->{isComment})
            {
                $self->{curInfo}->{comment} .= "\n";
                $self->{isComment} = 0;
            }

            # Debug
            if ($tagname eq "body" and $self->{debug})
            {
                use Data::Dumper;
                print Dumper $self->{curInfo};
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
        $origtext =~ s/^\s+|\s+$//g;

        return if ($self->{parsingEnded});
        
        if ($self->{parsingList})
        {
            if ($self->{inside}->{h1} && $origtext !~ m/Vyhledávání/i)
            {
                $self->{parsingEnded} = 1;
                $self->{itemIdx} = 0;
                $self->{itemsList}[0]->{url} = $self->{loadedUrl};
            }

            # Movie title
            if ($self->{isMovie})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{"title"} = $origtext;
                $self->{isMovie} = 0;
                return;
            }

            # Date (year)
            elsif ($self->{isYear})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{"date"} = $origtext;
                $self->{isYear} = 0;
            }

            # Extra movie info: genre, origin, date
            elsif ( $self->{inside}->{p}
                and $self->{insideDetails}
                and $self->{wasDetailsInfo} == 0)
            {
                my @tmp = split(', ', $origtext);
                my $pos = $#tmp;
                my ($year, $country, $genre) = (undef, undef, undef);
                $year = $tmp[$pos] if ($tmp[$pos] =~ /^\d+$/);
                $pos--;
                $country = $tmp[$pos] if ($pos >= 0);
                $pos--;
                $genre = $tmp[$pos] if ($pos >= 0);

                $self->{itemsList}[ $self->{itemIdx} ]->{date} = $year if (defined $year);
                $self->{itemsList}[ $self->{itemIdx} ]->{country} = $country
                  if (defined $country);
                $self->{itemsList}[ $self->{itemIdx} ]->{extra} = $genre
                  if (defined $genre);
                $self->{wasDetailsInfo} = 1;
            }

            # Directors
            elsif ($self->{inside}->{a} and $self->{insideDirectors})
            {
                push @{$self->{directors}}, $origtext;
                $self->{directorsCounter}++;
            }

            # Actors
            elsif ($self->{inside}->{a} and $self->{insideActors})
            {
                push @{$self->{actors}}, $origtext;
                $self->{actorsCounter}++;
            }
        }
        else
        {

            # Movie titles
            if ($self->{inside}->{h1})
            {
                $self->{curInfo}->{title} = $origtext
                  if !$self->{curInfo}->{title};
            }
            if ($self->{inside}->{h3} and $self->{isTitles})
            {
                $self->{titlesCounter}++;
                $self->{titles}[ $self->{titlesCounter} ] = $origtext;
                if ($self->{isOrigTitle})
                {
                	$self->{curInfo}->{original} ||= $origtext; 
                    $self->{isOrigTitle} = 0;
                }
                if ($self->{isSKTitle} and $self->{lang} eq "SK")
                {
                    $self->{curInfo}->{title} = $origtext;
                    $self->{isSKTitle} = 0;
                }                
            }

            # Genre
            if ($self->{insideGenre})
            {
                $origtext =~ s/ \/ /,/g;
                $self->{curInfo}->{genre} = $origtext;
                $self->{insideGenre} = 0;
            }

            # Extra movie info: country, date (year), time
            if ($self->{insideInfo})
            {
                my ($country, $year, $time) = split(', ', $origtext);
                $country =~ s/ \/ /,/g;

                $self->{curInfo}->{country} = $country;
                $self->{curInfo}->{date}    = $year;
                $self->{curInfo}->{time}    = $time;

                $self->{insideInfo} = 0;
            }

            # Directors and Actors
            if ($self->{inside}->{h4})
            {
                $self->{insideDirectors} = 1 if ($origtext =~ /^Režie:/);
                $self->{insideActors}    = 1 if ($origtext =~ /^Hrají:/);
            }

            if ($self->{inside}->{a} and $self->{insideDirectors})
            {
                push @{$self->{directors}}, $origtext;
                $self->{directorsCounter}++;
            }
            if ($self->{inside}->{a} and $self->{insideActors})
            {
                #push @{$self->{curInfo}->{actors}}, [$origtext]
                #  if ($self->{actorsCounter} <
                #    $GCPlugins::GCfilms::GCfilmsCommon::MAX_ACTORS);
                #$self->{actorsCounter}++;
                push @{$self->{actors}}, $origtext;
                $self->{actorsCounter}++;
            }

            # Synopsis
            if ($self->{inside}->{h3})
            {
                $self->{awaitingSynopsis} = 1 if ($origtext eq "Obsah");
            }
            if ($self->{inside}->{li} and $self->{insideSynopsis})
            {
                $self->{curInfo}->{synopsis} .= $origtext . "\n\n\n";
            }

            # Rating
            if ($self->{insideRating})
            {
                $origtext =~ s/([0-9]+)%/$1/;
                $self->{curInfo}->{ratingpress} = int($origtext / 10 + .5)
                  if ($origtext ne "");
                $self->{insideRating} = 0;
            }

            # Comments
            if ($self->{inside}->{a} and $self->{insideCommentAuthor})
            {
                $self->{curInfo}->{comment} .= $origtext . " napsal(a):\n";
                $self->{awaitingComment} = 1;
            }
            if ($self->{insideComment})
            {
                $self->{curInfo}->{comment} .= $origtext . "\n\n";
                $self->{insideComment} = 0;
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
            director => 1,
            actors   => 1,
            country  => 1
        };
        
        $self->{lang} = "CS";

        $self->{curName} = undef;
        $self->{curUrl}  = undef;
        
        $self->{debug} = ($ENV{GCS_DEBUG_PLUGIN_PHASE} > 0);        

        return $self;
    }

}

1;
