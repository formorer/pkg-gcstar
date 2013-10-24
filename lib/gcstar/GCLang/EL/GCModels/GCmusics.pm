{
    package GCLang::EL::GCModels::GCmusics;

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
    
        CollectionDescription => 'Συλλογή μουσικής',
        Items => {0 => 'Δίσκος',
                  1 => 'Δίσκος',
                  X => 'Δίσκοι'},
        NewItem => 'Νέος δίσκος',
    
        Unique => 'ISRC/EAN',
        Title => 'Τίτλος',
        Cover => 'Εξώφυλλο',
        Artist => 'Καλλιτέχνης',
        Format => 'Format',
        Running => 'Διάρκεια',
        Release => 'Ημερομηνία έκδοσης',
        Genre => 'Είδος',
        Origin => 'Προέλευση',

#For tracks list
        Tracks => 'Λίστα τραγουδιών',
        Number => 'Νούμερο',
        Track => 'Τίτλος',
        Time => 'Διάρκεια',

        Composer => 'Συνθέτης',
        Producer => 'Παραγωγός',
        Playlist => 'Λίστα αναπαραγωγής',
        Comments => 'Σχόλια',
        Label => 'Δισκογραφική εταιρεία',
        Url => 'Ιστοσελίδα',

        General => 'Γενικά',
        Details => 'Λεπτομέρειες',
     );
}

1;
