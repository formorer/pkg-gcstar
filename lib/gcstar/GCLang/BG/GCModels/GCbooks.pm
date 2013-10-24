{
    package GCLang::BG::GCModels::GCbooks;

    use utf8;
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
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => 'Books collection',
        Items => 'Books',
        NewItem => 'New book',
    
        Isbn => 'ISBN',
        Title => 'Title',
        Cover => 'Cover',
        Authors => 'Authors',
        Publisher => 'Publisher',
        Publication => 'Publication date',
        Language => 'Language',
        Genre => 'Genre',
        Serie => 'Колекция',
        Rank => 'Ранг',
        Bookdescription => 'Description',
        Pages => 'Pages',
        Read => 'Read',
        Acquisition => 'Acquisition date',
        Edition => 'Edition',
        Format => 'Format',
        Comments => 'Comments',
        Url => 'Web page',
        Translator => 'Translator',
        Artist => 'Artist',
        DigitalFile => 'Digital version',

        General => 'General',
        Details => 'Details',

        ReadNo => 'Not read',
        ReadYes => 'Read',
     );
}

1;
