{
    package GCLang::EL::GCModels::GCgames;

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
    
        CollectionDescription => 'Συλλογή παιχνιδιών Video ',
        Items => {0 => 'Παιχνίδι',
                  1 => 'Παιχνίδι',
                  X => 'Παιχνίδια'},
        NewItem => 'Νέο παιχνίδι',
    
        Id => 'Id',
        Ean => 'EAN',
        Name => 'Όνομα',
        Platform => 'Πλατφόρμα',
        Players => 'Αριθμός παικτών',
        Released => 'Ημερομηνία έκδοσης',
        Editor => 'Εκδότης',
        Developer => 'Δημιουργός',
        Genre => 'Είδος',
        Box => 'Εικόνα συσκευασίας',
        Case => 'Συσκευασία',
        Manual => 'Οδηγίες χρήσης',
        Completion => 'Ολοκλήρωση (%)',
        Executable => 'Εκτελέσιμο',
        Description => 'Περιγραφή',
        Codes => 'Κωδικοί',
        Code => 'Κώδικας',
        Effect => 'Effect',
        Secrets => 'Secrets',
        Screenshots => 'Στιγμιότυπα',
        Screenshot1 => 'Πρώτο στιγμιότυπο',
        Screenshot2 => 'Δεύτερο στιγμιότυπο',
        Comments => 'Σχόλια',
        Url => 'Ιστοσελίδα',
        Unlockables => 'Μπορούν να ξεκλειδωθουν',
        Unlockable => 'Μπορεί να ξεκλειδωθεί',
        Howto => 'Τρόπος ξεκλειδώματος',
        Exclusive => 'Exclusive',
        Resolutions => 'Display resolutions',
        InstallationSize => 'Size',
        Region => 'Περιοχή',
        SerialNumber => 'Σειριακός αριθμός',

        General => 'Γενικά',
        Details => 'Λεπτομέρειες',
        Tips => 'Tips',
        Information => 'Πληροφορίες',

        FilterRatingSelect => '_Βαθμολογία τουλάχιστο...',
     );
}

1;
