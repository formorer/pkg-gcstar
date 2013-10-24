{
    package GCLang::BG::GCModels::GCmusics;

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
    
        CollectionDescription => 'Music collection',
        Items => 'Albums',
        NewItem => 'New album',
    
        Unique => 'ISRC/EAN',
        Title => 'Title',
        Cover => 'Cover',
        Artist => 'Artist',
        Format => 'Format',
        Running => 'Running time',
        Release => 'Release date',
        Genre => 'Genre',
        Origin => 'Origin',

#For tracks list
        Tracks => 'Tracks list',
        Number => 'Number',
        Track => 'Title',
        Time => 'Time',

        Composer => 'Composer',
        Producer => 'Producer',
        Playlist => 'Playlist',
        Comments => 'Comments',
        Label => 'Label',
        Url => 'Web page',

        General => 'General',
        Details => 'Details',
     );
}

1;
