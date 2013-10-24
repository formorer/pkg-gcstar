{
    package GCLang::EL::GCModels::GCfilms;

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
    
        CollectionDescription => 'Συλλογή ταινιών',
        Items => {0 => 'Ταινία',
                  1 => 'Ταινία',
                  X => 'Ταινίες'},
        NewItem => 'Νέα ταινία',
    
    
        Id => 'Id',
        Title => 'Τίτλος',
        Date => 'Ημερομηνία',
        Time => 'Διάρκεια',
        Director => 'Σκηνοθέτης',
        Country => 'Χώρα',
        MinimumAge => 'Όριο ηλικίας',
        Genre => 'Είδος',
        Image => 'Εικόνα',
        Original => 'Αυθεντικός τίτλος',
        Actors => 'Ηθοποιοί',
        Actor => 'Ηθοποιός',
        Role => 'Ρόλος',
        Comment => 'Σχόλια',
        Synopsis => 'Περίληψη',
        Seen => 'Το \'χω δει',
        Number => 'Αριθμός',
        Format => 'Τύπος μέσου',
        Region => 'Χώρα',
        Identifier => 'Αναγνωριστικό',
        Url => 'Ιστοσελίδα',
        Audio => 'Ήχος',
        Video => 'Video format',
        Trailer => 'Αρχείο video',
        Serie => 'Σειρά',
        Rank => 'Rank',
        Subtitles => 'Υπότιτλοι',

        SeenYes => 'Το \'χω δει',
        SeenNo => 'Δεν το \'χω δει',

        AgeUnrated => 'Άγνωστο',
        AgeAll => 'Για όλη την οικογένεια',
        AgeParent => 'Με γονική συναίνεση',

        Main => 'Βασικά στοιχεία',
        General => 'Γενικά',
        Details => 'Λεπτομέρειες',

        Information => 'Πληροφορίες',
        Languages => 'Γλώσσες',
        Encoding => 'Κωδικοποίηση',

        FilterAudienceAge => 'Ηλικία θεατή',
        FilterSeenNo => '_Δεν το \'χω δει',
        FilterSeenYes => '_Το \'χω δει',
        FilterRatingSelect => '_Βαθμολογία τουλάχιστο...',

        ExtractSize => 'Μέγεθος',
     );
}

1;
