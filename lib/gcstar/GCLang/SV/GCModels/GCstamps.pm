{
    package GCLang::SV::GCModels::GCstamps;

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
    
        CollectionDescription => 'Frimärkssamling',
        Items => {0 => 'Frimärken',
                  1 => 'Frimärke',
                  X => 'Frimärken'},
        NewItem => 'Nytt frimärke',

        General => 'Allmänt',
        Detail => 'Detaljerat',
        Value => 'Värde',
        Notes => 'Noteringar',
        Views => 'Vyer',
        
        Name => 'Namn',
        Country => 'Land',
        Year => 'År',
        Catalog => 'Katalog',
        Number => 'Nummer',
        Topic => 'Ämne',
        Serie => 'Serie',
        Designer => 'Designer',
        Engraver => 'Graverad av',
        Type => 'Typ',
        Format => 'Format',
        Description => 'Beskrivning',
        Color => 'Färg',
        Gum => 'Klister',
        Paper => 'Papper',
        Perforation => 'Tandning',
        PerforationSize => 'Tandningens storlek',
        CancellationType => 'Typ av stämpel',
        Comments => 'Kommentarer',
        PrintingVariety => 'Form av tryck',
        IssueDate => 'Datum för utfärdande',
        EndOfIssue => 'Slut för utfärdande',
        Issue => 'Utfärdande',
        Grade => 'Sortering',
        Status => 'Status',
        Adjusted => 'Anpassad',
        Cancellation => 'Stämpel',
        CancellationCondition => 'Stämpelns skick',
        GumCondition => 'Klistrets skick',
        PerforationCondition => 'Tandningens skick',
        ConditionNotes => 'Notering av skick',
        Error => 'Fel',
        ErrorNotes => 'Notering av fel',
        FaceValue => 'Ansiktsvärde',
        MintValue => 'Myntvärde',
        UsedValue => 'Begagnatvärde',
        PurchasedDate => 'Införskaffad datum',
        Quantity => 'Kvantitet',
        History => 'Historia',
        Picture1 => 'Bild 1',
        Picture2 => 'Bild 2',
        Picture3 => 'Bild 3',

        AirMail => 'Flygpost',
        MilitaryStamp => 'Militärt frimärke',
        Official => 'Officiell',
        PostageDue => 'Postat den',
        Regular => 'Vanlig',
        Revenue => 'Intäkt',
        SpecialDelivery => 'Special leverans',
        StrikeStamp => 'Strejk frimärke',
        TelegraphStamp => 'Telegraf frimärke',
        WarStamp => 'Krigsfrimärke',
        WarTaxStamp => 'Krigsskattefrimärke',

        Booklet => 'Häfte',
        BookletPane => 'Panel för häfte',
        Card => 'Kort',
        Coil => 'Rulle',
        Envelope => 'Kuvert',
        FirstDayCover => 'Första omslag',
        Sheet => 'Blad',
        Single => 'Singel',

        Heliogravure => 'Heliogravyr',
        Lithography => 'Litografi',
        Offset => 'Utjämning',
        Photogravure => 'Fotogravyr',
        RecessPrinting => 'Fördjupningstryck',
        Typography => 'Typografi',
        
        OriginalGum => 'Originalklister',
        Ungummed => 'Oklistrad',
        Regummed => 'Omklistrad',

        Chalky => 'Kritad',
        ChinaPaper => 'Kinapapper',
        Coarsed => 'Ojämn',
        Glossy => 'Blank',
        Granite => 'Granit',
        Laid => 'Dämpad',
        Manila => 'Manillapapper',
        Native => 'Naturlig',
        Pelure => 'Pelure',
        Quadrille => 'Quadrille',
        Ribbed => 'Randig',
        Rice => 'Ris',
        Silk => 'Silke',
        Smoothed => 'Jämn',
        Thick => 'Tjock',
        Thin => 'Tunn',
        Wove => 'Vågig',

        CoarsedPerforation => 'Ojämn tandning',
        CombPerforation => 'Bruten tandning',
        CompoundPerforation => 'Sammansatt tandning',
        DamagedPerforation => 'Skadad tandning',
        DoublePerforation => 'Dubbeltandning',
        HarrowPerforation => 'Harvig tandning',
        LinePerforation => 'Linjerad tandning',
        NoPerforation => 'Ingen tandning',

        CancellationToOrder => 'Stämpel att beställa',
        FancyCancellation => 'Dekorerad stämpel',
        FirstDayCancellation => 'Första stämpeln',
        NumeralCancellation => 'Numerisk stämpel',
        PenMarked => 'Pennmarkerad',
        RailroadCancellation => 'Tågstämpel',
        SpecialCancellation => 'Specialstämpel',

        Superb => 'Super',
        ExtraFine => 'Extra Fin',
        VeryFine => 'Väldigt fin',
        FineVeryFine => 'Fin/Väldigt fin',
        Fine => 'Fin',
        Average => 'Medel',
        Poor => 'Dålig',

        Owned => 'Ägd',
        Ordered => 'Beställd',
        Sold => 'Såld',
        ToSell => 'Att sälja',
        Wanted => 'Vill ha',

        LightCancellation => 'Lätt stämplad',
        HeavyCancellation => 'Hårt stämplad',
        ModerateCancellation => 'Medelstämplad',

        MintNeverHinged => 'Mynt aldrig fäst',
        MintLightHinged => 'Mynt lätt fäst',
        HingedRemnant => 'Lämpligt fäst',
        HeavilyHinged => 'Väldigt fäst',
        LargePartOriginalGum => 'Stor del original klister',
        SmallPartOriginalGum => 'Liten del original klister',
        NoGum => 'Inget klister',

        Perfect => 'Perfekt',
        VeryNice => 'Väldigt bra',
        Nice => 'Bra',
        Incomplete => 'Ej komplett',
     );
}

1;
