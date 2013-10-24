{
    package GCLang::EL::GCModels::GCsoftware;

    use utf8;
###################################################
#
#  Copyright 2005-2009 Tian
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
    
        CollectionDescription => 'Συλλογή προγραμμάτων υπολογιστών',
        Items => {0 => 'Εφαρμογή',
                  1 => 'Εφαρμογή',
                  X => 'Εφαρμογές',
                  lowercase1 => 'εφαρμογή',
                  lowercaseX => 'εφαρμογες'},
        NewItem => 'Νέα εφαρμογή',
    
        Id => 'Id',
        Ean => 'EAN',
        Name => 'Όνομα',
        Platform => 'Πλατφόρμα',
        Released => 'Ημερομηνία κυκλοφορίας',
        Homepage => 'Ιστοσελίδα',		
        Editor => 'Εκδότης',
        Developer => 'Προγραμματιστής',
        Category => 'Κατηγορία',
		NumberOfCopies => 'Αντίγραφα',
		Price => 'Τιμή',
        Box => 'Εικόνα κουτιού',
        Case => 'Θήκη',
        Manual => 'Εγχειρίδιο χρήσης',
        Executable => 'Εκτελέσιμο',
        Description => 'Περιγραφή',
        License => 'Άδεια χρήσης',
        Commercial => 'Εμπορικό',
		FreewareNoncommercial => 'Freeware (μη εμπορική χρήση)',		
		OtherOpenSource => 'Άλλο ανοιχτού λογισμικού',
		PublicDomain => 'Δημόσιος τομέας',
		OtherLicense => 'Άλλο',
		Registration => 'Εγγραφή',				
		RegistrationInfo => 'Πληροφορίες εγγραφής',		
		RegInfo => 'Πληροφορίες εγγραφής',
		RegistrationName => 'Όνομα χρήστη',
		RegistrationNumber => 'Αριθμός εγγραφής',		
		PanelRegistration => 'Πληροφορίες εγγραφής',	
		RegistrationComments => 'Πρόσθετες πληροφορίες ή σχόλια',
        Screenshots => 'Στιγμιότυπα',
        Screenshot1 => 'Πρώτο στιγμιότυπο',
        Screenshot2 => 'Δεύτερο στιγμιότυπο',
        Comments => 'Σχόλια',
        Url => 'Ιστοσελίδα',
        General => 'Γενικά',
        Details => 'Λεπτομέρειες',
        Information => 'Πληροφορίες',

        FilterRatingSelect => 'Αξιολόγηση τουλάχιστο...',
     );
}

1;
