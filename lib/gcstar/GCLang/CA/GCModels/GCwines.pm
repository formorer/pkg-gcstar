{
    package GCLang::CA::GCModels::GCwines;

    use utf8;

#  Copyright 2007 Yves Martin
    
    use strict;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => 'Col·lecció de vins',
        Items => 'Vins',
        NewItem => 'Nou vi',
    
        Name => 'Nom',
        Designation => 'Designació',
        Vintage => 'Vermada',
        Vineyard => 'Vinya',
        Type => 'Tipus',
        Grapes => 'Reïm',
        Soil => 'Sol',
        Producer => 'Productor',
        Country => 'Païs',
        Volume => 'Volum (ml)',
        Alcohol => 'Alcohol (%)',
        Medal => 'Medalles/Premis',

        Storage => 'Celler',
        Location => 'Lloc',
        ShelfIndex => 'Index',
        Quantity => 'Quantitat',
        Acquisition => 'Adquisició',
        PurchaseDate => 'Data de compra',
        PurchasePrice => 'Preu de compra',
        Gift => 'Regal',
        BottleLabel => 'Etiqueta de la botella',
        Website => 'Referències al web',

        Tasted => 'Tastat',
        Comments => 'Comentaris',
        Serving => 'Porció',
        TastingField => 'Notes de degustació',

        General => 'General',
        Details => 'Detalls',
        Tasting => 'Degustació',

        TastedNo => 'No tastat',
        TastedYes => 'Tastat',

        FilterRange => 'Rang',
        FilterTastedNo => '_Encara no tastat',
        FilterTastedYes => 'Ja _tastat',
        FilterRatingSelect => 'Valoració al _menys...'

     );
}

1;
