{
    package GCLang::EL::GCModels::GCsmartcards;

    use utf8;
###################################################
#
#  Copyright 2005-2010 Tian
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
    
        CollectionDescription => 'Συλλογή τηλεκαρτών',
        Items => {0 => 'Τηλεκάρτα',
                  1 => 'Τηλεκάρτα',
                  X => 'Τηλεκάρτες'},
        NewItem => 'Νέα τηλεκάρτα',
        Currency => 'Νόμισμα',

	  Help => 'Βοήθεια για τα πεδία',
	  Help1 => 'Βοήθεια',

# Traduction des Champs "Main"

        Main => 'Η τηλεκάρτα',

        Cover => 'Εικόνα',

        Name => 'Όνομα',
        Exchange => 'Προς πώληση ή ανταλλαγή',
        Wanted => 'Ζήτηση',
        Rating1 => 'Γενική αξιολόγηση',
        TheSmartCard => 'Η τηλεκάρτα, εμπρός/πίσω',

        Country => 'Χώρα',
        Color => 'Χρώμα',
        Type1 => 'Τύπος κάρτας',
        Type2 => 'Τύπος τσιπ',
        Dimension => 'Μήκος / Πλάτος / Πάχος',

        Box => 'Κουτί',
        Chip => 'Τσίπ',
        Year1 => 'Έτος έκδοσης',
        Year2 => 'Ετος εγκυρότητας',
        Condition => 'Κατάσταση',
        Charge => 'Φορτιζόμερνη κάρτα',
        Variety => 'Είδος',

        Edition => 'Αριθμός δειγμάτων',
        Serial => 'Σειριακός αριθμός',
        Theme => 'Θέμα',

        Acquisition => 'Αγοραστηκε στο',

        Catalog0 => 'Κατάλογος',
        Catalog1 => 'OTE',
        Catalog2 => 'Κινητής τηλεφωνίας',

        Reference0 => 'Κωδικός',
        Reference1 => 'Κωδικός ΟΤΕ',
        Reference2 => 'Κωδικός κινητής τηλεφωνίας',
        Reference3 => 'Άλλος κωδικός',

        Quotationnew00 => 'Αξία νέας κάρτας',
        Quotationnew10 => 'Αξία κάρτας ΟΤΕ',
        Quotationnew20 => 'Αξία κάρτας κινητής',
        Quotationnew30 => 'Άλλη αξία',
        Quotationold00 => 'Αξία μεταχειρισμένης κάρτας',
        Quotationold10 => 'Αξία κάρτας ΟΤΕ',
        Quotationold20 => 'Αξία κάρτας κινητής',
        Quotationold30 => 'Άλλη αξία',

        Title1 => 'Τίτλος',

        Unit => 'Μονάδες / Αριθμός λεπτών',

        Pressed => 'Τύπος εκτύπωσης',
        Location => 'Τόπος εκτύπωσης',

        Comments1 => 'Σχόλια',

        Others => 'Διάφορα.',
        Weight => 'Βάρος',
     );
}

1;
