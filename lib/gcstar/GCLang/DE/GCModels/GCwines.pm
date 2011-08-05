{
    package GCLang::DE::GCModels::GCwines;

    use utf8;

    use strict;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => 'Weinsammlung',
        Items => {0 => 'Wein',
          1 => 'Wein',
          X => 'Weine',
          },

        NewItem => 'Neuer Wein',

        Name => 'Name',
        Designation => 'Kennzeichnung',
        Vintage => 'Jahrgang',
        Vineyard => 'Weingut',
        Type => 'Art',
        Grapes => 'Rebsorte',
        Soil => 'Erde',
        Producer => 'Abfüller',
        Country => 'Land',
        Volume => 'Inhalt (ml)',
        Alcohol => 'Alkohol (%)',
        Medal => 'Auszeichnungen',

        Storage => 'Aufbewahrung',
        Location => 'Ortsangabe',
        ShelfIndex => 'Ablageindex',
        Quantity => 'Anzahl',
        Acquisition => 'Erwerb',
        PurchaseDate => 'Kaufdatum',
        PurchasePrice => 'Kaufpreis',
        Gift => 'Geschenk',
        BottleLabel => 'Etikett',
        Website => 'Website',

        Tasted => 'verkostet',
        Comments => 'Kommentar',
        Serving => 'Portion',
        TastingField => 'Bemerkungen',

        General => 'Allgemein',
        Details => 'Einzelheiten',
        Tasting => 'Geschmack',

        TastedNo => 'nicht gekostet',
        TastedYes => 'gekostet',

        FilterRange => 'Filter',
        FilterTastedNo => '_Noch nicht gekostet',
        FilterTastedYes => 'Bereits _gekostet',
        FilterRatingSelect => 'Bewertung _mindestens...'

     );
}

1;
