{
    package GCLang::EL::GCModels::GCboardgames;

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
    
        CollectionDescription => 'Συλλογή επιτραπέζιων παιχνιδιών',
        Items => {0 => 'Παιχνίδι',
                  1 => 'Παιχνίδι',
                  X => 'Παιχνίδια'},
        NewItem => 'Νέο παιχνίδι',
    
        Id => 'Id',
        Name => 'Όνομα',
        Original => 'Αυθεντικό όνομα',
        Box => 'Εικόνα συσκευασίας',
        DesignedBy => 'Δημιουργός',
        PublishedBy => 'Εκδότης',
        Players => 'Αριθμός παικτών',
        PlayingTime => 'Χρόνος παρτίδας',
        SuggestedAge => 'Προτεινόμενη ηλικία',
        Released => 'Ημερομηνία έκδοσης',
        Description => 'Περιγραφή',
        Category => 'Κατηγορία',
        Mechanics => 'Μηχανισμοί',
        ExpandedBy => 'Υπάρχουσα επέκταση',
        ExpansionFor => 'Επέκταση για',
        GameFamily => 'Κατηγορία παιχνιδιού',
        IllustratedBy => 'Εικονογράφηση από',
        Url => 'Ιστοσελίδα',
        TimesPlayed => 'Αριθμός παρτίδων που έχουν παιχτεί',
        CompleteContents => 'Πλήρες περιεχόμενο',
        Copies => 'Αριθμός αντιγράφων',
        Condition => 'Κατάσταση',
        Photos => 'Εικόνες',
        Photo1 => 'Πρώτη εικόνα',
        Photo2 => 'Δεύτερη εικόνα',
        Photo3 => 'Τρίτη εικόνα',
        Photo4 => 'Τέταρτη εικόνα',
        Comments => 'Σχόλια',

        Perfect => 'Εξαίρετο',
        Good => 'Καλό',
        Average => 'Μέτριο',
        Poor => 'Κακό',

        CompleteYes => 'Πλήρες περιεχόμενο',
        CompleteNo => 'Ελλειπή στοιχεία',

        General => 'Γενικά',
        Details => 'Λεπτομέρειες',
        Personal => 'Προσωπικά',
        Information => 'Πληροφορίες',

        FilterRatingSelect => '_Βαθμολογία τουλάχιστο...',
     );
}

1;
