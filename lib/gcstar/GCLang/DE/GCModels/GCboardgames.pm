{
    package GCLang::DE::GCModels::GCboardgames;

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
    
        CollectionDescription => 'Brettspielsammlung',
        Items => {0 => 'Spiel',
                  1 => 'Spiel',
                  X => 'Spiele'},
        NewItem => 'Neues Spiel',
    
        Id => 'Id',
        Name => 'Name',
        Original => 'Originalname',
        Box => 'Verpackungsbild',
        DesignedBy => 'Entwickelt von',
        PublishedBy => 'Erschienen bei',
        Players => 'Anzahl der Spieler',
        PlayingTime => 'Spielzeit',
        SuggestedAge => 'Empfohlenes Alter',
        Released => 'Erscheinungsdatum',
        Description => 'Beschreibung',
        Category => 'Kategorie',
        Mechanics => 'Spielaktionen',
        ExpandedBy => 'Erweitert durch',
        ExpansionFor => 'Erweiterung für',
        GameFamily => 'Spieltyp',
        IllustratedBy => 'Illustriert von',
        Url => 'Webseite',
        TimesPlayed => 'Wie oft gespielt',
        CompleteContents => 'Inhalt vollständig',
        Copies => 'Anzahl der Spiele',
        Condition => 'Konditionen',
        Photos => 'Fotos',
        Photo1 => 'Erstes Bild',
        Photo2 => 'Zweites Bild',
        Photo3 => 'Drittes Bild',
        Photo4 => 'Viertes Bild',
        Comments => 'Kommentare',

        Perfect => 'Perfekt',
        Good => 'Gut',
        Average => 'Durchschnitt',
        Poor => 'Schlecht',

        CompleteYes => 'Inhalt vollständig',
        CompleteNo => 'Fehlende Teile',

        General => 'Allgemein',
        Details => 'Details',
        Personal => 'Persönlich',
        Information => 'Information',

        FilterRatingSelect => 'Bewertung _mindestens...',
     );
}

1;

