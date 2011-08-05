{
    package GCLang::RO::GCModels::GCwines;

    use utf8;

#  Copyright 2007 Yves Martin
    
    use strict;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => 'Colecţie de vinuri',
        Items => 'Vinuri',
        NewItem => 'Vin nou',
    
        Name => 'Nume',
        Designation => 'Destinaţie',
        Vintage => 'Recoltă',
        Vineyard => 'Podgorie',
        Type => 'Tip',
        Grapes => 'Struguri',
        Soil => 'Sol',
        Producer => 'Producător',
        Country => 'Ţară',
        Volume => 'Volum (ml)',
        Alcohol => 'Alcool (%)',
        Medal => 'Medalii/Premii',

        Storage => 'Depozitare',
        Location => 'Locaţie',
        ShelfIndex => 'Index',
        Quantity => 'Cantitate',
        Acquisition => 'Achiziţie',
        PurchaseDate => 'Dată cumpărare',
        PurchasePrice => 'Preţ cumpărare',
        Gift => 'Cadou',
        BottleLabel => 'Etichetă sticlă',
        Website => 'Referinţe pe web',

        Tasted => 'Degustat',
        Comments => 'Comentarii',
        Serving => 'Porţie',
        TastingField => 'Note testare',

        General => 'General',
        Details => 'Detalii',
        Tasting => 'Degustare',

        TastedNo => 'Nu a fost degustat',
        TastedYes => 'Degustat',

        FilterRange => 'Limite',
        FilterTastedNo => '_Nu a fost încă degustat',
        FilterTastedYes => 'Deja _degustat',
        FilterRatingSelect => 'Evaluat la cel _puţin...'

     );
}

1;
