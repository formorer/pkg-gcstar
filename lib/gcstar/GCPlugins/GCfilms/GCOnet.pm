#
# More information here: http://wiki.gcstar.org/en/websites_plugins
#
# GCcollection should be replaced with the kind of collection your
# plugin deals with. e.g. GCfilms, GCgames, GCbooks,...

# Replace SiteTemplate with your plugin name.
# The package name must exactly match the file name (.pm)
package GCPlugins::GCcollection::GCOnet;

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

use GCPlugins::GCfilms::GCfilmsCommon;

{
    # Replace SiteTemplate with your exporter name
    # It must be the same name as the one used for file and main package name
    package GCPlugins::GCfilms::GCPluginOnet;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    # getSearchUrl
    # Used to get the URL that to be used to perform searches.
    # $word is the query
    # Returns the full URL.
    sub getSearchUrl
    {
        my ($self, $word) = @_;

        # Your code here

        return "http://film.onet.pl/filmoteka.html?S=$word";
    }

    # getItemUrl
    # Used to get the full URL of an item page.
    # Useful when url on results pages are relative.
    # $url is the URL as found with a search.
    # Returns the absolute URL.
    sub getItemUrl
    {
        my ($self, $url) = @_;

        # Your code here

        return "http://film.onet.pl/" . $url;
    }

    # getCharset
    # Used to convert charset in web pages.
    # Returns the charset as specified in pages.
    sub getCharset
    {
        my $self = shift;

        return "ISO-8859-2";
    }

    # getName
    # Used to display plugin name in GUI.
    # Returns the plugin name.
    sub getName
    {
        return "Onet";
    }

    # getAuthor
    # Used to display the plugin author in GUI.
    # Returns the plugin author name.
    sub getAuthor
    {
        return 'Marek Cendrowicz';
    }

    # getLang
    # Used to fill in plugin list with user language plugins
    # Return the language used for this site (2 letters code).
    sub getLang
    {
        return 'PL';
    }
    # getExtra
    # Used if the plugin wants an extra column to be displayed in search results
    # Return the column title or empty string to hide the column.
    sub getExtra
    {
        return "";
    }

    # changeUrl
    # Can be used to change URL if item URL and the one used to
    # extract information are different.
    # Return the modified URL.
    sub changeUrl
    {
        my ($self, $url) = @_;

        return $url;
    }

    # In processing functions below, self->{parsingList} can be used.
    # If true, we are processing a search results page
    # If false, we are processing a item information page.

    # $self->{inside}->{tagname} (with correct value for tagname) can be used to test
    # if we are in the corresponding tag.

    # You have a counter $self->{itemIdx} that have to be used when processing search results.
    # It is your responsability to increment it!

    # When processing search results, you have to fill the available fields for results
    #
    #  $self->{itemsList}[$self->{movieIdx}]->{field_name}
    #
    # When processing a movie page, you need to fill the fields (if available)
    # in $self->{curInfo}.
    #
    #  $self->{curInfo}->{field_name}

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
            if ($self->{inside}->{list_title} && $tagname eq 'a')
            {
                $self->{itemIdx}++;
                $self->{itemsList}[ $self->{itemIdx} ]->{url} = $attr->{href};
                $self->{listTitle} = 1;
            }
        }
        else
        {
            if ($attr->{class} eq 'tyw')
            {
                $self->{itemTitle} = 1;
            }
            elsif ($tagname eq 'div' && $attr->{class} eq 'a2')
            {
                $self->{itemDescription} = 1;
            }
            elsif ($attr->{class} eq 'item_actor')
            {
                $self->{itemActor} = 1;
            }
            elsif ($tagname eq 'img'
                && $attr->{class} eq 'pic'
                && ($attr->{alt} eq 'Galeria' || $attr->{alt} eq 'Plakat'))
            {
                $self->{curInfo}->{image} = "http://film.onet.pl/" . $attr->{src};
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
    }

    # text
    # Called each time some plain text (between tags) is processed.
    # $origtext is the read text.
    sub text
    {
        my ($self, $origtext) = @_;

        if ($self->{parsingList})
        {
            if ($self->{listTitle})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{title} = $origtext;
                $self->{listTitle} = 0;
            }
            elsif ($self->{inside}->{list_date})
            {
                ($self->{itemsList}[ $self->{itemIdx} ]->{date}) = ($origtext =~ m/,\s+(\d+)$/);
            }
        }
        else
        {
            if ($self->{itemTitle})
            {
                $self->{curInfo}->{title} = $origtext;
                $self->{itemTitle} = 0;
            }
            elsif ($self->{inside}->{item_country})
            {
                ($self->{curInfo}->{original}) = ($origtext =~ m/(.*)\s+\(/);
                ($self->{curInfo}->{country}, $self->{curInfo}->{date}) =
                  ($origtext =~ m/(\w+),\s+(\d+)\)/);
                $origtext =~ s|/|, |g;
                ($self->{curInfo}->{genre}) = ($origtext =~ m/\)(.*)/);
            }
            elsif ($self->{inside}->{item_time})
            {
                ($self->{curInfo}->{time}, $self->{curInfo}->{age}) =
                  ($origtext =~ m/czas\s+(\d+).*\s+od\s+(\d+)/);
            }
            elsif ($self->{inside}->{item_director})
            {
                $self->{curInfo}->{director} .= $origtext;
            }
            elsif ($self->{itemDescription})
            {
                $self->{curInfo}->{synopsis} = $origtext;
                $self->{itemDescription} = 0;
            }
            elsif ($self->{itemActor})
            {
                $self->{curInfo}->{actors} .=
                  $self->{curInfo}->{actors} ? ", " . $origtext : $origtext;
                $self->{itemActor} = 0;
            }
            elsif ($self->{inside}->{item_rating})
            {
                ($self->{curInfo}->{ratingpress}) = int($origtext * 2 + 0.5);
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

        # This member should be initialized as a reference
        # to a hash. Each keys is a field that could be
        # in results with value 1 or 0 if it is returned
        # or not. For the list of keys, check the model file
        # (.gcm) and search for tags <field> in
        # /collection/options/fields/results
        $self->{hasField} = {
            title    => 1,
            date     => 1,
            director => 0,
            actors   => 0,
        };

        $self->{itemIdx}               = 0;
        $self->{itemsList}[0]->{title} = '';
        $self->{itemsList}[0]->{url}   = '';

        # Do your init stuff here
        bless($self, $class);
        return $self;
    }

    # preProcess
    # Called before each page is processed. You can use it to do some substitutions.
    # $html is the page content.
    # Returns modified version of page content.
    sub preProcess
    {
        my ($self, $html) = @_;

        $html =~ s{<B>(.*?)</B>}{$1}gms;

        if ($self->{parsingList})
        {

            $html =~ s{<TD class=a2 width="100%">(.*?)</TD>}
                      {<list_title>$1</list_title>}gms;
            $html =~ s{<FONT class=a0 color="#993300">(.*?)</FONT>}
                      {<list_date>$1</list_date>}gms;
        }
        else
        {
            $html =~ s{<BR>}{}g;
            $html =~ s{<TD class=a2 valign=top width="100%">(.*?)<}
                      {<item_country>$1</item_country><}gms;
            $html =~ s{<SPAN class=a1>(.*?)</SPAN>}
                      {<item_time>$1</item_time>}gms;
            $html =~ s{Re.yseria:&nbsp;&nbsp;(.*?)Scenariusz}
                      {<item_director>$1</item_director>}gms;
            $html =~ s{Re.yseria:&nbsp;&nbsp;(.*?)wi.cej}
                      {<item_director>$1</item_director>}gms;
            $html =~ s{a2><A class=u}
                      {a2><A class=item_actor}gms;
            $html =~ s{Ocena filmu.*([0-9]\.[0-9]+)/5}
                      {<item_rating>$1</item_rating>}gms;
        }
        return $html;
    }

}

1;
