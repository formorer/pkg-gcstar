# Replace Template with your importer name.
# The package name must exactly match the file name (.pm)
package GCImport::GCImportTemplate;

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

use GCImport::GCImportBase;

{
    # Replace Template with your importer name
    # It must be the same name as the one used for file and main package name
    package GCImport::GCImporterTemplate;

    use base qw(GCImport::GCImportBaseClass);

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

    # wantsFieldsSelection
    # This function lets a plugin decide if it wants the user to specify fields to be used
    # Returns a true value when fields selection is needed.
    sub wantsFieldsSelection
    {
        return 0;
    }

    # wantsFileSelection
    # Some plugins doens't need a file (they can get their information
    # from a database as an example. This function specify if a file
    # is needed or not.
    # Returns true if a file is needed.
    sub wantsFileSelection
    {
        return 1;
    }
    

    # getName
    # Used to create Import menu.
    # If you need  a string that depends on language, do NOT define
    # this method and provide a member called Name in languages files
    # Returns a string containing the name.
    sub getName
    {
        my $self = shift;
        
        # Should return the importer name as it will be displayed in Import menu.
        
        return "Template";
    }
    
    # getFilePatterns
    # Used to add filters in file selection dialog box.
    # A *.* filter is always added also.
    # Returns the file as a list of array references.
    sub getFilePatterns
    {
       return (['Description 1', '*.ext1'], ['Description 2', '*.ext2']);
    }
    
    # getOptions
    # Used to create import dialog window.
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
                label => 'ImportHTMLWithJS',
                default => '1'
            },
            
            {
                name => 'title',
                type => 'shortText',
                label => 'ImportHTMLTitle',
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
    #  - $self->{options}->{movies} A reference to the array containing the information.
    #  - $self->{options}->{lang} A reference to the hash containing current language translations.
    
    # getMoviesArray
    # Called to generate the movies array.
    # Each item of this array have to be an associative array with these fields:
    #
    #  - $movie->{title}
    #  - $movie->{date}
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
    #  - $movie->{subt}
    #  - $movie->{borrower}
    #  - $movie->{lendDate}
    #  - $movie->{history}
    #
    # Returns the movies array.
    sub getMoviesArray
    {
        my ($self, $file) = @_;
        my @result;
        
        # Your code here
        # Add movies to results;

        return \@result;
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