{
    package GCLang::ID::GCModels::GCstamps;

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
    
        CollectionDescription => 'Stamp collection',
        Items => {0 => 'Stamps',
                  1 => 'Stamp',
                  X => 'Stamps'},
        NewItem => 'New stamp',

        General => 'General',
        Detail => 'Detail',
        Value => 'Value',
        Notes => 'Notes',
        Views => 'Views',
        
        Name => 'Name',
        Country => 'Country',
        Year => 'Year',
        Catalog => 'Catalog',
        Number => 'Number',
        Topic => 'Topic',
        Serie => 'Serie',
        Designer => 'Designer',
        Engraver => 'Engraver',
        Type => 'Type',
        Format => 'Format',
        Description => 'Description',
        Color => 'Color',
        Gum => 'Gum',
        Paper => 'Paper',
        Perforation => 'Perforation',
        PerforationSize => 'Perforation size',
        CancellationType => 'Cancellation type',
        Comments => 'Comments',
        PrintingVariety => 'Printing variety',
        IssueDate => 'Issue date',
        EndOfIssue => 'End of issue',
        Issue => 'Issue',
        Grade => 'Grade',
        Status => 'Status',
        Adjusted => 'Adjusted',
        Cancellation => 'Cancellation',
        CancellationCondition => 'Cancellation condition',
        GumCondition => 'Gum condition',
        PerforationCondition => 'Perforation condition',
        ConditionNotes => 'Condition notes',
        Error => 'Error',
        ErrorNotes => 'Error notes',
        FaceValue => 'Face value',
        MintValue => 'Mint value',
        UsedValue => 'Used value',
        PurchasedDate => 'Purchased date',
        Quantity => 'Quantity',
        History => 'History',
        Picture1 => 'Picture 1',
        Picture2 => 'Picture 2',
        Picture3 => 'Picture 3',

        AirMail => 'Air mail',
        MilitaryStamp => 'Military stamp',
        Official => 'Official',
        PostageDue => 'Postage due',
        Regular => 'Regular',
        Revenue => 'Revenue',
        SpecialDelivery => 'Special delivery',
        StrikeStamp => 'Strike stamp',
        TelegraphStamp => 'Telegraph stamp',
        WarStamp => 'War stamp',
        WarTaxStamp => 'War tax stamp',

        Booklet => 'Booklet',
        BookletPane => 'Booklet Pane',
        Card => 'Card',
        Coil => 'Coil',
        Envelope => 'Envelope',
        FirstDayCover => 'First Day Cover',
        Sheet => 'Sheet',
        Single => 'Single',

        Heliogravure => 'Heliogravure',
        Lithography => 'Lithography',
        Offset => 'Offset',
        Photogravure => 'Photogravure',
        RecessPrinting => 'Recess printing',
        Typography => 'Typography',
        
        OriginalGum => 'Original gum',
        Ungummed => 'Ungummed',
        Regummed => 'Regummed',

        Chalky => 'Chalky',
        ChinaPaper => 'China paper',
        Coarsed => 'Coarsed',
        Glossy => 'Glossy',
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
        FancyCancellation => 'Fancy cancellation',
        FirstDayCancellation => 'First Day cancellation',
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
        Poor => 'Poor',

        Owned => 'Owned',
        Ordered => 'Ordered',
        Sold => 'Sold',
        ToSell => 'To sell',
        Wanted => 'Wanted',

        LightCancellation => 'Light cancellation',
        HeavyCancellation => 'Heavy cancellation',
        ModerateCancellation => 'Moderate cancellation',

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
