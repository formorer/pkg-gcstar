#
# More information here: http://wiki.gcstar.org/en/websites_plugins
#
# GCcollection should be replaced with the kind of collection your
# plugin deals with. e.g. GCfilms, GCgames, GCbooks,...

# Replace SiteTemplate with your plugin name.
# The package name must exactly match the file name (.pm)
package GCPlugins::GCcollection::GCSiteTemplate;

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
use utf8;

use GCPlugins::GCcollection::GCcollectionCommon;

{
    # Replace SiteTemplate with your exporter name
    # It must be the same name as the one used for file and main package name
    package GCPlugins::GCcollection::GCPluginSiteTemplate;

    use base 'GCPlugins::GCcollection::GCcollectionPluginsBase';
 
    # getSearchUrl
    # Used to get the URL that to be used to perform searches.
    # $word is the query
    # Returns the full URL.
    sub getSearchUrl
    {
		my ($self, $word) = @_;
        my $url;
        
        # Your code here
        
		return $url;
    }
    
    # getItemUrl
    # Used to get the full URL of an item page.
    # Useful when url on results pages are relative.
    # $url is the URL as found with a search.
    # Returns the absolute URL.
    sub getItemUrl
    {
		my ($self, $url) = @_;
		my $absUrl;
        
        # Your code here

        return $absUrl;
    }
    
    # getCharset
    # Used to convert charset in web pages.
    # Returns the charset as specified in pages.
    sub getCharset
    {
        my $self = shift;
    
        return "ISO-8859-1";
    }

    # getName
    # Used to display plugin name in GUI.
    # Returns the plugin name.
    sub getName
    {
        return "SiteTemplate";
    }

    # getAuthor
    # Used to display the plugin author in GUI.
    # Returns the plugin author name.
    sub getAuthor
    {
        return 'Tian';
    }
    
    # getLang
    # Used to fill in plugin list with user language plugins
    # Return the language used for this site (2 letters code).
    sub getLang
    {
        return 'EN';
    }
    # getExtra
    # Used if the plugin wants an extra column to be displayed in search results
    # Return the column title or empty string to hide the column.
    sub getExtra
    {
        return 'Extra';
    }

    # getNumberPasses
    # Used to set the number of search "passes" the plugin requires. This defaults to
    # a single pass, but for some sites 2 or more searches are required. See the GCTvdb
    # plugin for an example of such a site
    sub getNumberPasses
    {
        return 1;
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
            # Your code for processing search results here
        }
        else
        {
            # Your code for processing movie information here
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
        }
    }

    # text
    # Called each time some plain text (between tags) is processed.
    # $origtext is the read text.
    sub text
    {
        my ($self, $origtext) = @_;

       if ($self->{parsingList})
        {
            # Your code for processing search results here
        }
        else
        {
            # Your code for processing movie information here
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
            key1 => 1,
            key2 => 0,
        };

        # Do your init stuff here
        
        bless ($self, $class);
        return $self;
    }

    # getFields
    # Called on each pass, by plugins with getNumberPasses > 1
    # to get the columns return by the plugin during that pass
    sub getReturnedFields
    {
        my $self = shift;

        # This member should be initialized as a reference
        # to a hash. Each keys is a field that could be
        # in results with value 1 or 0 if it is returned
        # or not. For the list of keys, check the model file
        # (.gcm) and search for tags <field> in
        # /collection/options/fields/results
        $self->{hasField} = {
            key1 => 1,
            key2 => 0,
        };
    }

    # preProcess
    # Called before each page is processed. You can use it to do some substitutions.
    # $html is the page content.
    # Returns modified version of page content.
    sub preProcess
    {
        my ($self, $html) = @_;

        # Your code to modify $html here.
        
        return $html;
    }
    
}

1;
