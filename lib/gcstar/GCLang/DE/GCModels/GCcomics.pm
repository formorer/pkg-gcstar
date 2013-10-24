{
    package GCLang::DE::GCModels::GCcomics;

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
    
        CollectionDescription => 'Comicheftsammlung',
        Items => {0 => 'Comicheft',
          1 => 'Comicheft',
          X => 'Comichefte'
                 },
        NewItem => 'Neues Comicheft',
    
    
        Id => 'Id',
        Name => 'Name',
        Series => 'Serie',
        Volume => 'Ausgabe',
        Title => 'Titel',
        Writer => 'Autor',
        Illustrator => 'Illustrator',
        Colourist => 'Kolorist',
        Publisher => 'Herausgeber',
        Synopsis => 'Zusammenfassung',
        Collection => 'Sammlung',
        PublishDate => 'Erscheinungsdatum',
        PrintingDate => 'Druckdatum',
        ISBN => 'ISBN',
        Type => 'Typ',
        Category => 'Kategorie',
        Format => 'Format',
        NumberBoards => 'Anzahl der Boards',
        Signing => 'signiert',
        Cost => 'Preis',
        Rating => 'Bewertung',
        Comment => 'Bemerkungen',
        Url => 'Internetseite',

        FilterRatingSelect => 'Bewertung _mindestens...',

        Main => 'Hauptelemente',
        General => 'Allgemein',
        Details => 'Details',
     );
}

1;
