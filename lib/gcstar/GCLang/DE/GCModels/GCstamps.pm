{
    package GCLang::DE::GCModels::GCstamps;

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
    
        CollectionDescription => 'Briefmarkensammlung',
        Items => {0 => 'Briefmarke',
                  1 => 'Briefmarke',
                  X => 'Briefmarken'},
        NewItem => 'Neue Briefmarke',

        General => 'Allgemein',
        Detail => 'Detail',
        Value => 'Wert',
        Notes => 'Bemerkungen',
        Views => 'Fotos',

        Name => 'Name',
        Country => 'Land',
        Year => 'Jahr',
        Catalog => 'Katalog',
        Number => 'Nummer',
        Topic => 'Motiv',
        Serie => 'Serie',
        Designer => 'Designer',
        Engraver => 'Graveur',
        Type => 'Typ',
        Format => 'Art',
        Description => 'Beschreibung',
        Color => 'Farbe',
        Gum => 'Gummierung',
        Paper => 'Papier',
        Perforation => 'Perforation',
        PerforationSize => 'Perforationsgröße',
        CancellationType => 'Stempel',
        Comments => 'Bemerkungen',
        PrintingVariety => 'Druck',
        IssueDate => 'Erstausgabedatum',
        EndOfIssue => 'gültig bis',
        Issue => 'Auflage',
        Grade => 'Erhaltung',
        Status => 'Status',
        Adjusted => 'Adjusted',
        Cancellation => 'Entwertung',
        CancellationCondition => 'Stempelqualität',
        GumCondition => 'Zustand der Gummierung',
        PerforationCondition => 'Zustand der Perforation',
        ConditionNotes => 'Bemerkungen zum Zustand',
        Error => 'Fehldruck',
        ErrorNotes => 'Bemerkungen zum Druck',
        FaceValue => 'Nennwert',
        MintValue => 'Wert postfrisch',
        UsedValue => 'Wert gestempelt',
        PurchasedDate => 'Kaufdatum',
        Quantity => 'Anzahl',
        History => 'Geschichte',
        Picture1 => 'Bild 1',
        Picture2 => 'Bild 2',
        Picture3 => 'Bild 3',

        AirMail => 'Luftpost',
        MilitaryStamp => 'Feldpost',
        Official => 'offiziell',
        PostageDue => 'Nachgebühr',
        Regular => 'Regulär',
        Revenue => 'Erlös',
        SpecialDelivery => 'Sondermarke',
        StrikeStamp => 'Streikmarke',
        TelegraphStamp => 'Telegrafenmarke',
        WarStamp => 'Feldpostmarke',
        WarTaxStamp => 'Kriegssteuermarke',

        Booklet => 'Markenheftchen',
        BookletPane => 'Heftchenblatt',
        Card => 'Postkarte',
        Coil => 'Rolle',
        Envelope => 'Umschlag',
        FirstDayCover => 'Ersttagsbrief',
        Sheet => 'Bogen',
        Single => 'Einzelexemplar',

        Heliogravure => 'Heliogravüre',
        Lithography => 'Lithographie',
        Offset => 'Offset',
        Photogravure => 'Rastertiefdruck',
        RecessPrinting => 'Stichtiefdruck',
        Typography => 'Schriftsatz',

        OriginalGum => 'Originalgummierung',
        Ungummed => 'ungummiert',
        Regummed => 'nachgummiert',

        Chalky => 'gestrichenes Papier',
        ChinaPaper => 'Chinapapier',
        Coarsed => 'Rauh',
        Glossy => 'Glänzend',
        Granite => 'Granite',
        Laid => 'Gestreift',
        Manila => 'Manila',
        Native => 'Native',
        Pelure => 'Zigarettenpapier',
        Quadrille => 'Gegittert',
        Ribbed => 'Riffelung',
        Rice => 'Reis',
        Silk => 'Seide',
        Smoothed => 'Geglättet',
        Thick => 'Dick',
        Thin => 'Dünn',
        Wove => 'Gewebt',

        CoarsedPerforation => 'Rauhe Perforation',
        CombPerforation => 'Gekämmte Perforation',
        CompoundPerforation => 'Gemischte Perforation',
        DamagedPerforation => 'Beschädigte Perforation',
        DoublePerforation => 'Doppelte Oerforation',
        HarrowPerforation => 'Eckige Perforation',
        LinePerforation => 'Gerade Perforation',
        NoPerforation => 'Keine Perforation',

        CancellationToOrder => 'Gefälligkeitsstempel',
        FancyCancellation => 'Sonderstempel',
        FirstDayCancellation => 'Ersttagsstempel',
        NumeralCancellation => 'Nummernstempel',
        PenMarked => 'Federzugentwertung',
        RailroadCancellation => 'Eisenbahnentwertung',
        SpecialCancellation => 'Spezielle Entwertung',

        Superb => 'Luxuserhaltung',
        ExtraFine => 'Kabinetterhaltung',
        VeryFine => 'Prachterhaltung',
        FineVeryFine => 'Feinsterhaltung',
        Fine => 'Feinerhaltung',
        Average => 'Durchschnittserhaltung',
        Poor => 'Knochenerhaltung',

        Owned => 'im Besitz',
        Ordered => 'bestellt',
        Sold => 'verkauft',
        ToSell => 'zu verkaufen',
        Wanted => 'gesucht',

        LightCancellation => 'schwacher Stempel',
        HeavyCancellation => 'starker Stempel',
        ModerateCancellation => 'normaler Stempel',

        MintNeverHinged => 'Prägung niemals gefaltet',
        MintLightHinged => 'Prägung leicht gefaltet',
        HingedRemnant => 'Faltung sichtbar',
        HeavilyHinged => 'Stark gefaltet',
        LargePartOriginalGum => 'Große Teile der originalen Gummierung',
        SmallPartOriginalGum => 'Kleine Teile der originalen Gummierung',
        NoGum => 'Keine Gummierung',

        Perfect => 'Perfekt',
        VeryNice => 'Sehr gut',
        Nice => 'Gut',
        Incomplete => 'Unvollständig',
     );
}

1;
