{
    package GCLang::EL::GCImport::GCImportFolder;

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
    use GCLang::GCLangUtils;

    our @EXPORT = qw(%lang);

    our %lang = (
          'Name' => 'Φάκελος',
          'Recursive' => 'Εξερεύνηση υπό-καταλόγων',
          'Suffixes' => 'Suffixes ή η επέκταση των αρχείων',
          'SuffixesTooltip' => 'Να ληφθεί υπ\'όψη η λίστα με διαχωρισμό με κόμμα  των suffixes ή με τις επεκτάσεις των αρχείων',
          'Remove' => 'Να διαγραφεί από τα ονόματα',
          'RemoveTooltip' => 'Η λίστα των λέξεων διαχωρισμένες με κόμμα που θα πρέπει να διαγραφεί από τα ονόματα αρχείων για την δημιουργία ονόματος αναζήτησης',
        'Ask'=> 'Ερώτηση',
        'AskEnd'=> 'ερώτηση όλων στο τέλο',
        'AddWithoutInfo'=> 'Προσθήκη χωρίς πληροφορίες',
        'DontAdd'=> 'Να μην προστεθεί',
        'TakeFirst' => 'Επιλογή πρώτου',
        'MultipleResult'=> 'Αγνόησε όταν υπάρχουν περισσότερο από 1 απαντήσεις',
 		'MultipleResultTooltip'=> 'Το αρχείο θα προστεθεί χωρίς αναζήτηση πληροφοριών αν υπάρχουν περισσότερο από 1 απαντήσεις',
 		'RemoveWholeWord' => 'Αφαίρεση μόνο ολόκληρων λέξεων',
 		'RemoveTooltipWholeWord' => 'Οι λέξεις θα αφαιρούνται μόνο αν εμφανίζονται σαν ολόκληρη λέξη',
 		'RemoveRegularExpr' => 'Κανονική έκφραση',
 		'RemoveTooltipRegularExpr' => 'Υπολογίστε ότι \'Για να αφαιρεθεί από τα ονόματα\' είναι μια κανονική έκφραση perl',
 		'SkipFileAlreadyInCollection' => 'Προσθήκη μόνο νέων αρχείων',
 		'SkipFileAlreadyInCollectionTooltip' => 'Προσθήκη μόνο των αρχείων που δεν υπάρχουν στη συλλογή',
 		'SkipFileNo' => 'Όχι',
 		'SkipFileFullPath' => 'βασισμένο σε ολόκληρη τη διαδρομή',
 		'SkipFileFileName' => 'βασισμένο στο όνομα αρχείου',
 		'SkipFileFileNameAndUpdate' => 'βασισμένο στο όνομα αρχείου (αλλά με ενημέρωση διαδρομής στη συλλογή)',  
        'NoResult'=> 'Κανένα αποτέλεσμα',
        'NoResultTooltip'=> 'Τι θα γίνεται αν δεν βρεθούν αποτελέσματα αναζήτησης από το πρόσθετο',
        'InfoFromFileNameRegExp' => 'Ανάλυση ονόματος αρχείου με αυτη την κανονική έκφραση',
        'InfoFromFileNameRegExpTooltip' => 'Χρήση αυτού για ανάκτηση πληροφοριών από το όνομα αρχείου (εφαρμόζεται μετά την αφαίρεση της επέκτασης). Αφήστε κενό αν δεν χρησιμοποιείται. Γνωστά πεδία: $T:Τίτλος, $A:Τίτλος αλφαβητικά, $Y:Ημερομηνία έκδοσης, $S:Σεζόν, $E:Επισόδειο, $N:Όνομα σειράς αλφαβητικά, $x:Αριθμός μέρους, $y: Σύνολο αριθμού μερών',
     );

    # As this plugin shares some values with ImportList, it adds them from it
    importTranslation('List');
}

1;
