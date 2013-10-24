{
    package GCLang::DE::GCModels::GCminicars;

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
    
        CollectionDescription => 'Miniaturfahrzeugsammlung',
        Items => {0 => 'Fahrzeug',
                  1 => 'Fahrzeug',
                  X => 'Fahrzeuge'},
        NewItem => 'Neues Fahrzeug',
        Currency => 'Währung',

# Main fields

        Main => 'Hauptinformation',

        Name => 'Name',
        Exchange => 'Zu verkaufen oder zu tauschen',
        Wanted => 'gesucht',
        Rating1 => 'Hauptbewertung',
        Picture1 => 'Hauptbild',
        Scale => 'Maßstab',
        Manufacturer => 'Hersteller',
        Constructor => 'Konstrukteur',
        Type1 => 'Typ',
        Modele => 'Modell',
        Version => 'Version',
        Color => 'Farbe des Modells',
        Pub => 'Werbung',
        Year => 'Jahr',
        Reference => 'Verweise',
        Kit => 'Als Bausatz',
        Transformation => 'Persönliche Informationen',
        Comments1 => 'Bemerkungen',

# Details fields

        Details => 'Details',

        MiscCharacteristics => 'verschiedene Eigenschaften',
        Material => 'Material',
        Molding => 'Guss',
        Condition => 'Zustand',
        Edition => 'Ausgabe',
        Collectiontype => 'Sammlungsname',
        Serial => 'Serie',
        Serialnumber => 'Seriennummer',
        Designed => 'Entwurfsdatum',
        Madein => 'Herstellungsland',
        Box1 => 'Art der Verpackung',
        Box2 => 'Verpackungsbeschreibung',
        Containbox => 'Verpackungsinhalt',
        Rating2 => 'Realitätsnähe',
        Rating3 => 'Ausführung',
        Acquisition => 'Kaufdatum',
        Location => 'wo gekauft',
        Buyprice => 'Kaufpreis',
        Estimate => 'Schätzwert',
        Comments2 => 'Bemerkungen',
        Decorationset => 'Dekorationsausführung',
        Characters => 'Figuren',
        CarFromFilm => 'Filmauto',
        Filmcar => 'Film mit diesem Auto',
        Filmpart => 'Serienfolge',
        Parts => 'Anzahl der Teile',
        VehiculeDetails => 'technische Daten',
        Detailsparts => 'besondere Einzelheiten',
        Detailsdecorations => 'Art der Dekoration',
        Decorations => 'Anzahl der Dokorationen',
        Lwh => 'Länge / Breite / Höhe',
        Weight => 'Gewicht',
        Framecar => 'Fahrgestell',
        Bodycar => 'Karosserie',
        Colormirror => 'Farbe des Modells',
        Interior => 'Innenausstattung',
        Wheels => 'Räder',
        Registrationnumber1 => 'Nummernschild vorne',
        Registrationnumber2 => 'Nummernschild hinten',
        RacingCar => 'Rennwagen',
        Course => 'Rennen',
        Courselocation => 'Rennplatzierung',
        Courseyear => 'Renndatum',
        Team => 'Team',
        Pilots => 'Fahrer(innen)',
        Copilots => 'Beifahrer(innen)',
        Carnumber => 'Fahrzeugnummer',
        Pub2 => 'Werbepartner',
        Finishline => 'Platzierung',
        Steeringwheel => 'Position des Lenkrades',


# Catalogs fields

        Catalogs => 'Katalog',

        OfficialPicture => 'Herstellerfoto',
        Barcode => 'Strichcode',
        Referencemirror => 'Verweise',
        Year3 => 'Verfügbarkeitsdatum',
        CatalogCoverPicture => 'Katalogcover',
        CatalogPagePicture => 'Katalogseite',
        Catalogyear => 'Katalogsjahr',
        Catalogedition => 'Katalogsausgabe',
        Catalogpage => 'Katalogseite',
        Catalogprice => 'Katalogpreis',
        Personalref => 'Persönlicher Bezug',
        Websitem => 'Website vom Herstellers des Miniaturfahrzeuges',
        Websitec => 'Website vom Hersteller des Originalfahrzeuges',
        Websiteo => 'Nützlicher Link',
        Comments3 => 'Kommentare',

# Pictures fields

        Pictures => 'Bilder',

        OthersComments => 'Generelle Anmerkungen',
        OthersDetails => 'andere Details',
        Top1 => 'oben',
        Back1 => 'unten',
        AVG => 'vorne links',
        AV => 'vorne',
        AVD => 'vorne rechts',
        G => 'links',
        BOX => 'Verpackung',
        D => 'rechts',
        ARG => 'hinten links',
        AR => 'hinten',
        ARD => 'hinten rechts',
        Others => 'andere',

# PanelLending fields

        LendingExplanation => 'Leihgaben für Ausstellungen',
        PanelLending => 'Ausleihen',
        Comments4 => 'Kommentare',

# Realmodel fields

        Realmodel => 'Modell',

        Difference => 'Unterschiede zwischen Modell und Original',
        Front2 => 'vorne',
        Back2 => 'hinten',
        Comments5 => 'Kommentare',

        References => 'Verweise',

     );
}

1;
