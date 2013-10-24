{
    package GCLang::EL::GCModels::GCcomics;

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
    
        CollectionDescription => 'Συλλογή Κόμικς',
        Items => {0 => 'Κόμικς',
                  1 => 'Κόμικ',
                  X => 'Κόμικς'},
        NewItem => 'Νέο κόμικ',
    
    
        Id => 'Id',
        Name => 'Όνομα',
        Series => 'Σειρά',
        Volume => 'Τόμος',
        Title => 'Τίτλος',
        Writer => 'Συγγραφέας',
        Illustrator => 'Εικονογράφος',
        Colourist => 'Κολορίστας',
        Publisher => 'Εκδότης',
        Synopsis => 'Περίληψη',
        Collection => 'Συλλογή',
        PublishDate => 'Ημερομηνία έκδοσης',
        PrintingDate => 'Ημερομηνία εκτύπωσης',
        ISBN => 'ISBN',
        Type => 'Τύπος',
		Category => 'Κατηγορία',
        Format => 'Μορφή',
        NumberBoards => 'Αριθμός Σελίδων',
		Signing => 'Αφιέρωση',
        Cost => 'Κόστος',
        Rating => 'Βαθμολογία',
        Comment => 'Σχόλια',
        Url => 'Ιστοσελίδα',

        FilterRatingSelect => 'Βαθμός _τουλάχιστο...',

        Main => 'Κεντρικό μενού',
        General => 'Γενικά',
        Details => 'Λεπτομέρειες',
     );
}

1;
