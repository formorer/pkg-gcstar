{
    package GCLang::EN::GCModels::GCwines;

    use utf8;

#  Copyright 2007 Yves Martin
    
    use strict;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => 'Wines collection',
        Items => {  0 => 'Wines',
                    1 => 'Wine',
                    X => 'Wines',
                    lowercase1 => 'wine',
                    lowercaseX => 'wines'
                    },
        NewItem => 'New wine',
    
        Name => 'Name',
        Designation => 'Designation',
        Vintage => 'Vintage',
        Vineyard => 'Vineyard',
        Type => 'Type',
        Grapes => 'Grapes',
        Soil => 'Soil',
        Producer => 'Producer',
        Country => 'Country',
        Volume => 'Volume (ml)',
        Alcohol => 'Alcohol (%)',
        Medal => 'Medal/Honour',

        Storage => 'Storage',
        Location => 'Location',
        ShelfIndex => 'Index',
        Quantity => 'Quantity',
        Acquisition => 'Acquisition',
        PurchaseDate => 'Purchase date',
        PurchasePrice => 'Purchase price',
        Gift => 'Gift',
        BottleLabel => 'Bottle label',
        Website => 'Reference on the web',

        Tasted => 'Tasted',
        Comments => 'Comments',
        Serving => 'Serving',
        TastingField => 'Testing notes',

        General => 'General',
        Details => 'Details',
        Tasting => 'Tasting',

        TastedNo => 'Non tasted',
        TastedYes => 'Tasted',

        FilterRange => 'Range',
        FilterTastedNo => '_Not yet tasted',
        FilterTastedYes => 'Already _tasted',
        FilterRatingSelect => 'Rating at _least...'

     );
}

1;
