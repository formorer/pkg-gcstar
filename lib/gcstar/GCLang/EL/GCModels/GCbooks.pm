{
    package GCLang::EL::GCModels::GCbooks;

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
    
        CollectionDescription => 'Συλλογή βιβλίων',
        Items => {0 => 'Βιβλίο',
                  1 => 'Βιβλίο',
                  X => 'Βιβλία'},
        NewItem => 'Νέο βιβλίο',
    
        Isbn => 'ISBN',
        Title => 'Τίτλος',
        Cover => 'Εξώφυλλο',
        Authors => 'Συγγραφέας',
        Publisher => 'Εκδότης',
        Publication => 'Ημερομηνία έκδοσης',
        Language => 'Γλώσσα',
        Genre => 'Κατηγορία',
        Serie => 'Σειρά',
        Rank => 'Rank',
        Bookdescription => 'Περιγραφή',
        Pages => 'Σελίδες',
        Read => 'Διαβασμένο',
        Acquisition => 'Ημερομηνία απόκτησης',
        Edition => 'Έκδοση',
        Format => 'Μορφή',
        Comments => 'Σχόλια',
        Url => 'Ιστοσελίδα',
        Translator => 'Μετάφραση:',
        Artist => 'Επιμέλεια:',
        DigitalFile => 'Digital version',

        General => 'Γενικά',
        Details => 'Λεπτομέρειες',

        ReadNo => 'Not read',
        ReadYes => 'Read',
     );
}

1;
