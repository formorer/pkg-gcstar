{
    package GCLang::DE::GCModels::GCsmartcards;

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
    
        CollectionDescription => 'Telefonkartensammlung',
        Items => {0 => 'Karte',
                  1 => 'Karte',
                  X => 'Karten'},
        NewItem => 'Neue Karte',
        Currency => 'Währung',

	  Help => 'Hinweise zu den Eingabefeldern',
	  Help1 => 'Hilfe',

# Traduction des Champs "Main"

        Main => 'Kartendaten',

        Cover => 'Abbildung',

        Name => 'Name',
        Exchange => 'tauschen oder verkaufen',
        Wanted => 'gesucht',
        Rating1 => 'Gesamtbewertung',
        TheSmartCard => 'Vorder-/Rückseite',

        Country => 'Land',
        Color => 'Farbe',
        Type1 => 'Kartentyp',
        Type2 => 'Modultyp',
        Dimension => 'Länge/Breite/Dicke',

        Box => 'Box',
        Chip => 'Modul',
        Year1 => 'Ausgabedatum',
        Year2 => 'Gültigkeitsdatum',
        Condition => 'Zustand',
        Charge => 'aufladbar',
        Variety => 'Variante',

        Edition => 'Gesamtauflage',
        Serial => 'Seriennummer',
        Theme => 'Theme',

        Acquisition => 'Kaufdatum',

        Catalog0 => 'Katalog',
        Catalog1 => 'Michel',
        Catalog2 => 'Sherlock',

        Reference0 => 'Katalognummer',
        Reference1 => 'Michelnummer',
        Reference2 => 'Katalognummer Sherlock',
        Reference3 => 'andere Katalognummer',

        Quotationnew00 => 'Wert ungebraucht',
        Quotationnew10 => 'Wert Michel',
        Quotationnew20 => 'Wert Sherlock',
        Quotationnew30 => 'andere Bewertung',
        Quotationold00 => 'Wert gebraucht',
        Quotationold10 => 'Wert Michael',
        Quotationold20 => 'Wert Sherlock',
        Quotationold30 => 'andere Bewertung',

        Title1 => 'Titel',

        Unit => 'Einheiten/Minuten',

        Pressed => 'Hersteller',
        Location => 'Ort',

        Comments1 => 'Bemerkung',

        Others => 'Sonstiges',
        Weight => 'Gewicht',
     );
}

1;
