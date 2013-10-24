{
    package GCLang::HU::GCModels::GCmusics;

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
    
        CollectionDescription => 'Zenegyűjtemény',
        Items => {0 => 'Album',
                  1 => 'Album',
                  X => 'Albumok'},
        NewItem => 'Új album',
    
        Unique => 'ISRC/EAN',
        Title => 'Cím',
        Cover => 'Borító',
        Artist => 'Előadók',
        Format => 'Formátum',
        Running => 'Hossz',
        Release => 'Kiadás dátuma',
        Genre => 'Jellemzők',
        Origin => 'Origin',

#For tracks list
        Tracks => 'Track lista',
        Number => 'Szám',
        Track => 'Cím',
        Time => 'Idő',

        Composer => 'Zeneszerző',
        Producer => 'Gyártásvezető',
        Playlist => 'Lejátszólista',
        Comments => 'Megjegyzések',
        Label => 'Cimke',
        Url => 'Weboldal',

        General => 'Általános',
        Details => 'Összetevők',
     );
}

1;
