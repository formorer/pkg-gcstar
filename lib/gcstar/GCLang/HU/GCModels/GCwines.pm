{
    package GCLang::HU::GCModels::GCwines;

    use utf8;

#  Copyright 2007 Yves Martin
    
    use strict;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => 'Borgyűjtemény',
        Items => {0 => 'Bor',
                  1 => 'Bor',
                  X => 'Borok'},
        NewItem => 'Új bor',
    
        Name => 'Név',
        Designation => 'Megnevezés',
        Vintage => 'Évjárat',
        Vineyard => 'Pincészet',
        Type => 'Típus',
        Grapes => 'Szőlők',
        Soil => 'Talaj',
        Producer => 'Termelő',
        Country => 'Ország',
        Volume => 'Űrtartalom (ml)',
        Alcohol => 'Alkohol (%)',
        Medal => 'Díjak és elismerések',

        Storage => 'Tárolás',
        Location => 'Hely',
        ShelfIndex => 'Mutató',
        Quantity => 'Mennyiség',
        Acquisition => 'Beszerzés',
        PurchaseDate => 'Beszerzés dátuma',
        PurchasePrice => 'Beszerzési ár',
        Gift => 'Ajándék',
        BottleLabel => 'Palack címke',
        Website => 'Referenciák a weben',

        Tasted => 'Megízlelve',
        Comments => 'Megjegyzések',
        Serving => 'Kínálás',
        TastingField => 'Bírálati megjegyzések',

        General => 'Általános',
        Details => 'Összetevők',
        Tasting => 'Ízlelés',

        TastedNo => 'Nincs megízlelve',
        TastedYes => 'Megízlelve',

        FilterRange => 'Érték',
        FilterTastedNo => '_Még nem ízlelt',
        FilterTastedYes => 'Már _ízlelt',
        FilterRatingSelect => 'Értékelés _legalább...'

     );
}

1;
