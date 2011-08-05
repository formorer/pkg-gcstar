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
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
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
        Issue => 'Issue',
        Grade => 'Erhaltung',
        Status => 'Status',
        Adjusted => 'Adjusted',
        Cancellation => 'Cancellation',
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
        PostageDue => 'Postage due',
        Regular => 'Regular',
        Revenue => 'Revenue',
        SpecialDelivery => 'Sondermarke',
        StrikeStamp => 'Strike stamp',
        TelegraphStamp => 'Telegraph stamp',
        WarStamp => 'War stamp',
        WarTaxStamp => 'War tax stamp',

        Booklet => 'Booklet',
        BookletPane => 'Booklet Pane',
        Card => 'Postkarte',
        Coil => 'Rolle',
        Envelope => 'Umschlag',
        FirstDayCover => 'Ersttagsbrief',
        Sheet => 'Bogen',
        Single => 'Einzelexemplar',

        Heliogravure => 'Heliogravure',
        Lithography => 'Lithography',
        Offset => 'Offset',
        Photogravure => 'Photogravure',
        RecessPrinting => 'Tiefdruck',
        Typography => 'Typography',

        OriginalGum => 'Originalgummierung',
        Ungummed => 'ungummiert',
        Regummed => 'nachgummiert',

        Chalky => 'Chalky',
        ChinaPaper => 'China paper',
        Coarsed => 'Coarsed',
        Glossy => 'glänzend',
        Granite => 'Granite',
        Laid => 'Laid',
        Manila => 'Manila',
        Native => 'Native',
        Pelure => 'Pelure',
        Quadrille => 'Quadrille',
        Ribbed => 'Ribbed',
        Rice => 'Rice',
        Silk => 'Silk',
        Smoothed => 'Smoothed',
        Thick => 'Thick',
        Thin => 'Thin',
        Wove => 'Wove',

        CoarsedPerforation => 'Coarsed perforation',
        CombPerforation => 'Comb perforation',
        CompoundPerforation => 'Compound perforation',
        DamagedPerforation => 'Damaged perforation',
        DoublePerforation => 'Double perforation',
        HarrowPerforation => 'Harrow perforation',
        LinePerforation => 'Line perforation',
        NoPerforation => 'No perforation',

        CancellationToOrder => 'Cancellation To Order',
        FancyCancellation => 'Sonderstempel',
        FirstDayCancellation => 'Ersttagsstempel',
        NumeralCancellation => 'Numeral cancellation',
        PenMarked => 'Pen-Marked',
        RailroadCancellation => 'Railroad cancellation',
        SpecialCancellation => 'Special cancellation',

        Superb => 'Superb',
        ExtraFine => 'Extra-Fine',
        VeryFine => 'Very fine',
        FineVeryFine => 'Fine/Very fine',
        Fine => 'Fine',
        Average => 'Average',
        Poor => 'Schlecht',

        Owned => 'im Besitz',
        Ordered => 'bestellt',
        Sold => 'verkauft',
        ToSell => 'zu verkaufen',
        Wanted => 'gesucht',

        LightCancellation => 'schwacher Stempel',
        HeavyCancellation => 'starker Stempel',
        ModerateCancellation => 'normaler Stempel',

        MintNeverHinged => 'Mint never hinged',
        MintLightHinged => 'Mint light hinged',
        HingedRemnant => 'Hinged remnant',
        HeavilyHinged => 'Heavily hinged',
        LargePartOriginalGum => 'Large part original gum',
        SmallPartOriginalGum => 'Small part original gum',
        NoGum => 'No gum',

        Perfect => 'Perfect',
        VeryNice => 'Very nice',
        Nice => 'Nice',
        Incomplete => 'Incomplete',
     );
}

1;
