{
    package GCLang::EL::GCModels::GCminicars;

    use utf8;
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
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => 'Συλλογή μινιατούρων αυτοκινήτων',
        Items => {0 => 'Όχημα',
                  1 => 'Όχημα',
                  X => 'Οχήματα',
                  lowercase1 => 'όχημα',
                  lowercaseX => 'οχήματα'
                  },
        NewItem => 'Νέο όχημα',
        Currency => 'Νόμισμα',

# Main fields

        Main => 'Κύριες πληροφορίες',

        Name => 'Όνομα',
        Exchange => 'Προς πώληση ή ανταλλαγή',
        Wanted => 'Ζήτηση',
        Rating1 => 'Κύρια αξιολόγηση',
        Picture1 => 'Κύρια εικόνα',
        Scale => 'Κλίμακα',
        Manufacturer => 'Εργοστάσιο',
        Constructor => 'Κατασκευαστής',
        Type1 => 'Τύπος',
        Modele => 'Μοντέλο',
        Version => 'Έκδοση',
        Color => 'Χρώμα μοντέλου',
        Pub => 'Διαφήμιση',
        Year => 'Έτος',
        Reference => 'Κωδικός',
        Kit => 'Σε κιτ',
        Transformation => 'Προσωπική τροποποίηση',
        Comments1 => 'Σχόλια',

# Details fields

        Details => 'Λεπτομέρειες',

        MiscCharacteristics => 'Διάφορα χαρακτηριστικά',
        Material => 'Υλικό',
        Molding => 'Καλούπι',
        Condition => 'Κατάσταση',
        Edition => 'Έκδοση',
        Collectiontype => 'Όνομα συλλογής',
        Serial => 'Σειρά',
        Serialnumber => 'Σειριακός αριθμός',
        Designed => 'Ημερομηνία σχεδιασμού',
        Madein => 'Ημερομηνία κατασκευής',
        Box1 => 'Τύπος κουτιού',
        Box2 => 'Περιγραφή κουτιού',
        Containbox => 'Περιεχόμενο κουτιού',
        Rating2 => 'Ρεαλιστικό',
        Rating3 => 'Φινίρισμα',
        Acquisition => 'Ημερομηνία αγοράς',
        Location => 'Τόπος αγοράς',
        Buyprice => 'Τιμή αγοράς',
        Estimate => 'Εκτίμηση',
        Comments2 => 'Σχόλια',
        Decorationset => 'Σετ διακόσμησης',
        Characters => 'Χαρακτήρες',
        CarFromFilm => 'Αυτοκίνητο από ταινία',
        Filmcar => 'Ταινία σχετική με το όχημα',
        Filmpart => 'Μέρος/επισόδειο ταινίας',
        Parts => 'Αριθμός μερών',
        VehiculeDetails => 'Λεπτομέρειες αυτοκινήτου',
        Detailsparts => 'Αναλυτικά στοιχεία',
        Detailsdecorations => 'Τύπος διακοσμήσεων',
        Decorations => 'Αριθμός διακοσμήσεων',
        Lwh => 'Μήκος / Πλάτος / Ύψος',
        Weight => 'Βάρος',
        Framecar => 'Σασί',
        Bodycar => 'Αμάξωμα',
        Colormirror => 'Χρώμα μοντέλου',
        Interior => 'Εσωτερικό',
        Wheels => 'Τροχοί',
        Registrationnumber1 => 'Εμπρόσθιος αριθμός καταχώρησης',
        Registrationnumber2 => 'Οπίσθιος αριθμός καταχώρησης',
        RacingCar => 'Αγωνιστικό αυτοκίνητο',
        Course => 'Αγώνας',
        Courselocation => 'Τοποθεσία αγώνα',
        Courseyear => 'Ημερομηνία αγώνα',
        Team => 'Ομάδα',
        Pilots => 'Οδηγός(οι)',
        Copilots => 'Συνοδηγός(οι)',
        Carnumber => 'Αριθμός οχήματος',
        Pub2 => 'Διαφημιστές',
        Finishline => 'Τελική κατάταξη',
        Steeringwheel => 'Θέση τιμονιού',


# Catalogs fields

        Catalogs => 'Κατάλογοι',

        OfficialPicture => 'Επίσημη εικόνα',
        Barcode => 'Barcode',
        Referencemirror => 'Κωδικός',
        Year3 => 'Ημερομηνία διαθεσιμότητας',
        CatalogCoverPicture => 'Εξώφυλλο',
        CatalogPagePicture => 'Σελίδα',
        Catalogyear => 'Έτος καταλόγου',
        Catalogedition => 'Έκδοση καταλόγου',
        Catalogpage => 'Σελίδα καταλόγου',
        Catalogprice => 'Τιμή καταλόγου',
        Personalref => 'Προσωπικός κωδικός',
        Websitem => 'Ιστοσελίδα κατασκευαστή μινιατούρας',
        Websitec => 'Ιστοσελίδα κατασκευαστή του πραγματικού οχήματος',
        Websiteo => 'Χρήσιμοι σύνδεσμοι',
        Comments3 => 'Σχόλια',

# Pictures fields

        Pictures => 'Εικόνες',

        OthersComments => 'Γενικές παρατηρήσεις',
        OthersDetails => 'Άλλες λεπτομέρειες',
        Top1 => 'Επάνω',
        Back1 => 'Κάτω',
        AVG => 'Επάνω αριστερά',
        AV => 'Επάνω',
        AVD => 'Επάνω δεξιά',
        G => 'Αριστερά',
        BOX => 'Κουτί',
        D => 'Δεξιά',
        ARG => 'Πίσω αριστερά',
        AR => 'Πίσω',
        ARD => 'Πίσω δεξιά',
        Others => 'Διάφορα',

# PanelLending fields

        LendingExplanation => 'Χρήσιμες ανταλλαγές κατα την διαρκεια περιοδικών εκθέσεων',
        PanelLending => 'Χορηγήσεις (για εκθέσεις)',
        Comments4 => 'Σχόλια',

# Realmodel fields

        Realmodel => 'Πραγματικό αυτοκίνητο',

        Difference => 'Διαφορές με την μινιατούρα',
        Front2 => 'Εμπρός',
        Back2 => 'Πίσω',
        Comments5 => 'Σχόλια',

        References => 'Αναφορές',

     );
}

1;
