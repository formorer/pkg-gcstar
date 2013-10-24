# Replace Template with your exporter name.
# The package name must exactly match the file name (.pm)
package GCExport::GCExportTemplate;

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

use GCExport::GCExportBase;

{
    # Replace Template with your exporter name
    # It must be the same name as the one used for file and main package name
    package GCExport::GCExporterTemplate;

    use base qw(GCExport::GCExportBaseClass);

    # Add your needed use clauses here
    
    # new
    # Constructor
    # Returns reference to current object.
    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        
        # Do your initialization stuff here

        bless ($self, $class);
        return $self;
    }

    # getName
    # Used to create Export menu.
    # If you need  a string that depends on language, do NOT define
    # this method and provide a member called Name in languages files
    # Returns a string containing the name.
    sub getName
    {
        my $self = shift;
        
        # Should return the exporter name as it will be displayed in Export menu.
        
        return "Template";
    }
    
    # getOptions
    # Used to create export dialog window.
    # Returns an array with needed options.
    sub getOptions
    {
        my $self = shift;
        
        # Should return an array of associative arrays.
        # Here is an example.
        
        return [
            {
                name => 'withJs',
                type => 'checkBox',
                label => 'ExportHTMLWithJS',
                default => '1'
            },
            
            {
                name => 'title',
                type => 'shortText',
                label => 'ExportHTMLTitle',
                default => 'Movies list'
            },
                         
        ]
        
        # For each entry, you have to specify:
        #
        #  - name: A unique name that will be used to retrieve the option value
        #  - type: One out of checkBox, shortText, longText, number, list, fileSelection, colorSelection
        #  - label: a member of lang files (lib/gcstar/GCLang/*.pm) that will be used to display an informative label
        #  - default: Default value (for the first time exporter is used in a session).
        #
        # There are other values that are only valid for some types.
        #
        #  - min: Minimum value allowed (for number only).
        #  - max: Maximum value (for number only).
        #  - height: Height of the widget displayed in pixels (for longText only).
        #  - valuesList: A comma separated list of values to be used (for list only).
        #  - buttonLabel: Label for a button that will be displayed next to the option
        #                 (only for shortText, longText, number, list)
        #  - buttonCallback: Callback to be called when clicking on the button. It will
        #                     get button as first parameter while the second one will
        #                     a reference to an array containing dialog and option handles.
        #                     (only used if buttonLabel is specified).
        
        # In all processing functions below, values entered by user are accessible through:
        #
        #    $self->{options}->{name}
        #
        # Where name should be replaced with specified name above.
        
        
    }
      
    # In there processing functions, you can use options fields specified through getOptions
    # But there is also some predifined values:
    #
    #  - $self->{options}->{file} File name used to export data.
    #  - $self->{options}->{collection} File name of the one containing movies list.
    #  - $self->{options}->{collectionDirectory} Directory where movies list file is.
    #  - $self->{options}->{movies} A reference to the array containing the information.
    #  - $self->{options}->{lang} A reference to the hash containing current language translations.
    #  - $self->{options}->{fields} A reference to an array containing fields user choosed
    #       (wantsFieldsSelection must return a true value for this to be used).
    
    # wantsFieldsSelection
    # This function lets a plugin decide if it wants the user to specify fields to be used
    # Returns a true value when fields selection is needed.
    sub wantsFieldsSelection
    {
        return 0;
    }
    
    # needsUTF8
    # With this method, a plugin may ask the output file to be in UTF-8 mode
    # Returns a true value when UTF-8 is needed.
    sub needsUTF8
    {
        return 0;
    }
    
    # preProcess
    # Use this function if you need to do special stuff before movies list processing.
    # Returns nothing    
    sub preProcess
    {
        my $self =  shift;
        
        # Your code here
    }

    # getHeader
    # Should create the beginning of the exported file.
    # $number is the total movies number.
    # Returns a string containing what have to be included on the top of the file.
    sub getHeader
    {
        my ($self, $number) = @_;
        my $result;
        
        # Your code here
        # Append data to $result;
        
        return $result;
    }

    # getItem
    # Called for each movie.
    # $movie is an associative array containing the movie information. They are:
    #
    #  - $movie->{title}
    #  - $movie->{date}
    #  - $movie->{year}
    #  - $movie->{time}
    #  - $movie->{director}
    #  - $movie->{country}
    #  - $movie->{age}
    #  - $movie->{type}
    #  - $movie->{image}
    #  - $movie->{original}
    #  - $movie->{actors}
    #  - $movie->{comment}
    #  - $movie->{synopsis}
    #  - $movie->{seen}
    #  - $movie->{number}
    #  - $movie->{rating}
    #  - $movie->{format}
    #  - $movie->{url}
    #  - $movie->{place}
    #  - $movie->{video}
    #  - $movie->{audio}
    #  - $movie->{audioEncoding}
    #  - $movie->{subt}
    #  - $movie->{borrower}
    #  - $movie->{lendDate}
    #  - $movie->{history}
    #
    # $number is the movie index
    # Returns the item string.
    sub getItem
    {
        my ($self, $movie, $number) = @_;
        my $result;
        
        # Your code here
        # Append data to $result;

        return $result;
    }
    
    # getFooter
    # Should create the end of the exported file.
    # Returns a string containing what have to be included on the end of the file.
    sub getFooter
    {
        my $self = shift;
        my $result;
        
        # Your code here
        # Append data to $result;
        
        return $result;
    }

    # postProcess
    # Called after all processing. Use it if you need to perform extra stuff on the header.
    # $header is a reference to the header string.
    # $body is a reference to the content string.
    sub postProcess
    {
        my ($self, $header, $body) = @_;

        # Your code here
        # As header is a reference, it can be modified on place with $$header
        # The same for $$body
    }

    # getEndInfo
    # Used to display some information to user when export is ended.
    # To localize your message, use $self->{options}->{lang}.
    # Returns a string that will be displayed in a message box.
    sub getEndInfo
    {
        my $self = shift;
        my $message;
        
        # Your code here
        # Don't do put anything in message if you don't want information to be displayed.
        
        return $message;
    }
}

1;