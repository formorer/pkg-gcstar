{
    package GCLang::EL::GCModels::GCstamps;

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
    
        CollectionDescription => 'Συλλογή γραμματοσήμων',
        Items => {0 => 'Γραμματόσημα',
                  1 => 'Γραμματόσημο',
                  X => 'Γραμματόσημα'},
        NewItem => 'Νέο γραμματόσημο',

        General => 'Γενικά',
        Detail => 'Λεπτομέρεια',
        Value => 'Αξία',
        Notes => 'Σημειώσεις',
        Views => 'Όψεις',
        
        Name => 'Όνομα',
        Country => 'Χώρα',
        Year => 'Έτος',
        Catalog => 'Κατάλογος',
        Number => 'Αριθμός',
        Topic => 'Θέμα',
        Serie => 'Σειρά',
        Designer => 'Σχεδιαστής',
        Engraver => 'Χαράκτης',
        Type => 'Τύπος',
        Format => 'Μορφή',
        Description => 'Περιγραφή',
        Color => 'Χρώμα',
        Gum => 'Κόλλα',
        Paper => 'Χαρτί',
        Perforation => 'Οδόντωση',
        PerforationSize => 'Μέγεθος οδόντωσης',
        CancellationType => 'Τύπος σφράγισης',
        Comments => 'Σχόλια',
        PrintingVariety => 'Ποικιλία εκτύπωσης',
        IssueDate => 'Ημερομηνία έκδοσης',
        EndOfIssue => 'Τέλος έκδοσης',
        Issue => 'Έκδοση',
        Grade => 'Ποιότητα',
        Status => 'Θέση',
        Adjusted => 'Προσαρμοσμένο',
        Cancellation => 'Σφράγιση',
        CancellationCondition => 'Κατάσταση σφραγίδας',
        GumCondition => 'Κατάσταση κόλλας',
        PerforationCondition => 'Κατάσταση οδόντωσης',
        ConditionNotes => 'Σημειώσεις για την κατάσταση',
        Error => 'Λάθος',
        ErrorNotes => 'Σημειώσεις Λάθους',
        FaceValue => 'Αξία όψης',
        MintValue => 'Αξία καινούργιου',
        UsedValue => 'Αξία σφραγισμένου',
        PurchasedDate => 'Ημερομηνία αγοράς',
        Quantity => 'Ποσότητα',
        History => 'Ιστορικό',
        Picture1 => 'Εικόνα 1',
        Picture2 => 'Εικόνα 2',
        Picture3 => 'Εικόνα 3',

        AirMail => 'Ταχυδρομημένο αεροπορικώς',
        MilitaryStamp => 'Στρατιωτική σφραγίδα',
        Official => 'Σφραγίδα υπηρεσίας',
        PostageDue => 'Φόρος γραμματοσήμου',
        Regular => 'Κανονικό γραμματόσημο',
        Revenue => 'Χαρτόσημο',
        SpecialDelivery => 'Ταχεία αποστολή',
        StrikeStamp => 'Γραμματόσημο απεργίας',
        TelegraphStamp => 'Γραμματόσημο τηλέγραφου',
        WarStamp => 'Γραμματόσημο πολέμου',
        WarTaxStamp => 'Χαρτόσημο πολέμου',

        Booklet => 'Κλασέρ',
        BookletPane => 'Ποσεττα',
        Card => 'Κάρτα',
        Coil => 'Γραμματόσημο τροχίσου',
        Envelope => 'Φάκελος',
        FirstDayCover => 'Φάκελος πρώτης ημέρας κυκλοφορίας',
        Sheet => 'Φεγιέ',
        Single => 'Μεμονωμένο',

        Heliogravure => 'Φωτοχαραξη',
        Lithography => 'Λιθογραφία',
        Offset => 'Offset',
        Photogravure => 'Φωτοτσιγκογραφία',
        RecessPrinting => 'Χαλκογραφική',
        Typography => 'Τυπογραφία',
        
        OriginalGum => 'Αυθεντική κόλλα',
        Ungummed => 'Ξεκολλημένο',
        Regummed => 'Επανακολλημενο',

        Chalky => 'Ασβεστολιθικό χαρτί',
        ChinaPaper => 'Χαρτί Κίνας',
        Coarsed => 'Τραχύ χαρτί',
        Glossy => 'Γυαλιστερό',
        Granite => 'Γρανίτης',
        Laid => 'Στρωτό',
        Manila => 'Χαρτί με φυσαλίδες',
        Native => 'Φυσικό',
        Pelure => 'Φλοιώδες',
        Quadrille => 'Χαρτί καντριλέ',
        Ribbed => 'Ραβδωτό',
        Rice => 'Ρυζόχαρτο',
        Silk => 'Μεταξωτό',
        Smoothed => 'Λείο',
        Thick => 'Παχύ',
        Thin => 'Λεπτό',
        Wove => 'Κυματιστό',

        CoarsedPerforation => 'Χονδροειδή οδόντωση',
        CombPerforation => 'Οδόντωση χτένα',
        CompoundPerforation => 'Ανάμικτη οδόντωση',
        DamagedPerforation => 'Αλλοιωμένη οδόντωση',
        DoublePerforation => 'Διπλή διάτρηση',
        HarrowPerforation => 'Σκισμένη οδόντωση',
        LinePerforation => 'Γραμμική οδόντωση',
        NoPerforation => 'Χωρίς οδόντωση',

        CancellationToOrder => 'Σφράγιση παραγγελίας',
        FancyCancellation => 'Εντυπωσιακή σφράγιση',
        FirstDayCancellation => 'Σφράγιση φακέλου πρώτης ημέρας',
        NumeralCancellation => 'Ψηφιακή σφράγιση',
        PenMarked => 'Σημειωμένο με πένα',
        RailroadCancellation => 'Σφράγιση σιδηρόδρομου',
        SpecialCancellation => 'Ειδική σφράγιση',

        Superb => 'Εξαίσιο',
        ExtraFine => 'Πάρα πολυ ωραίο',
        VeryFine => 'Πολυ ωραίο',
        FineVeryFine => 'Ωραίο/Πολύ ωραίο',
        Fine => 'Ωραίο',
        Average => 'Μέτριο',
        Poor => 'Κακό',

        Owned => 'Κατεχόμενο',
        Ordered => 'Σε παραγγελία',
        Sold => 'Πουλημένο',
        ToSell => 'Προς πώληση',
        Wanted => 'Ζητούμενο',

        LightCancellation => 'Ελαφριά σφράγιση',
        HeavyCancellation => 'Έντονη σφράγιση',
        ModerateCancellation => 'Μέτρια σφράγιση',

        MintNeverHinged => 'Ανέπαφο',
        MintLightHinged => 'Ελαφριά τσάκιση',
        HingedRemnant => 'Τσάκιση',
        HeavilyHinged => 'Μεγάλη τσάκιση',
        LargePartOriginalGum => 'Γνήσια κόλλα σε μεγάλη επιφάνεια',
        SmallPartOriginalGum => 'Γνήσια κόλλα σε μικρή επιφάνεια',
        NoGum => 'Χωρίς κόλλα',

        Perfect => 'Τέλειο',
        VeryNice => 'Πολύ όμορφο',
        Nice => 'Όμορφο',
        Incomplete => 'Ατελείωτο',
     );
}

1;
