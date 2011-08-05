{
    package GCLang::NL::GCModels::GCwines;

    use utf8;

#  Auteursrecht 2007 Yves Martin
    
    use strict;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => 'Collectie wijn',
        Items => {0 => 'Wijn',
                  1 => 'Wijn',
                  X => 'Wijn'},
        NewItem => 'Nieuwe wijn',
    
        Name => 'Naam',
        Designation => 'Benoeming',
        Vintage => 'Wijnoogst',
        Vineyard => 'Wijngaard',
        Type => 'Type',
        Grapes => 'Druiven',
        Soil => 'Bodem',
        Producer => 'Producent',
        Country => 'Land',
        Volume => 'Inhoud (ml)',
        Alcohol => 'Alcohol (%)',
        Medal => 'Medaille',

        Storage => 'Opslag',
        Location => 'Locatie',
        ShelfIndex => 'Index',
        Quantity => 'Hoeveelheid',
        Acquisition => 'Verwerving',
        PurchaseDate => 'Aankoopdatum',
        PurchasePrice => 'Aankoopprijs',
        Gift => 'Geschenk',
        BottleLabel => 'Label van de fles',
        Website => 'Referentie op het web',

        Tasted => 'Geproefd',
        Comments => 'Opmerkingen',
        Serving => 'Serveren',
        TastingField => 'Nota\'s van het proeven',

        General => 'Algemeen',
        Details => 'Details',
        Tasting => 'Proeven',

        TastedNo => 'Niet geproefd',
        TastedYes => 'Geproefd',

        FilterRange => 'Range',
        FilterTastedNo => '_Nog niet geproefd',
        FilterTastedYes => 'Al geproefd',
        FilterRatingSelect => 'Minimum waardering...'

     );
}

1;
