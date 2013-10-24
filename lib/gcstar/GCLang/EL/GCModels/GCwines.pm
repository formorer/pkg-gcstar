{
    package GCLang::EL::GCModels::GCwines;

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
    
        CollectionDescription => 'Συλλογή κρασιών',
        Items => {0 => 'Κρασί',
                  1 => 'Κρασί',
                  X => 'Κρασιά'},
        NewItem => 'Νέο κρασί',
    
        Name => 'Όνομα',
        Designation => 'Ονομασία',
        Vintage => 'Χρονιά παραγωγής',
        Vineyard => 'Αμπελώνας',
        Type => 'Κατηγορία',
        Grapes => 'Σταφύλι',
        Soil => 'Έδαφος',
        Producer => 'Παραγωγός',
        Country => 'Χώρα',
        Volume => 'Ποσότητα (ml)',
        Alcohol => 'Αλκοόλ (%)',
        Medal => 'Διακρίσεις',

        Storage => 'Αποθήκευση',
        Location => 'Τοποθεσία',
        ShelfIndex => 'Θέση',
        Quantity => 'Ποσότητα',
        Acquisition => 'Απόκτηση',
        PurchaseDate => 'Ημερομηνία απόκτησης',
        PurchasePrice => 'Τιμή απόκτησης',
        Gift => 'Δώρο',
        BottleLabel => 'Ετικέτα φιάλης',
        Website => 'Παραπομπή στο Internet',

        Tasted => 'Δοκιμασμένο',
        Comments => 'Παρατηρήσεις',
        Serving => 'Σερβίρισμα',
        TastingField => 'Χαρακτήρας',

        General => 'Γενικά',
        Details => 'Λεπτομέρειες',
        Tasting => 'Γεύση',

        TastedNo => 'Δεν είναι δοκιμασμένο',
        TastedYes => 'Δοκιμασμένο',

        FilterRange => 'Εύρος',
        FilterTastedNo => '_Δεν έχει δοκιμαστεί ακόμα',
        FilterTastedYes => 'Δοκιμασμένο',
        FilterRatingSelect => '_Βαθμολογία τουλάχιστο...'

     );
}

1;
