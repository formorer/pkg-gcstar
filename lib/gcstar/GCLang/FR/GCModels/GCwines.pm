{
    package GCLang::FR::GCModels::GCwines;

    use utf8;

#  Copyright 2007 Yves Martin
    
    use strict;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => 'Collection de vins',
        Items => {0 => 'Vin',
                  1 => 'Vin',
                  X => 'Vins',
                  I1 => 'Un vin',
                  D1 => 'Le vin',
                  DX => 'Les vins',
                  DD1 => 'Du vin',
                  M1 => 'Ce vin',
                  C1 => ' vin',
                  DA1 => 'e vin',
                  DAX => 'e vins'},
        NewItem => 'Nouvelle bouteille',
    
        Name => 'Nom',
        Designation => 'Appellation',
        Vintage => 'Millésime',
        Vineyard => 'Nom du cru',
        Type => 'Catégorie',
        Grapes => 'Cépages',
        Soil => 'Terroir',
        Producer => 'Producteur',
        Country => 'Pays',
        Volume => 'Volume (ml)',
        Alcohol => 'Alcool (%)',
        Medal => 'Distinction',

        Storage => 'Entreposage',
        Location => 'Lieu',
        ShelfIndex => 'Position',
        Quantity => 'Quantité',
        Acquisition => 'Acquisition',
        PurchaseDate => 'Date d\'acquisition',
        PurchasePrice => 'Prix d\'achat',
        Gift => 'Offert',
        BottleLabel => 'Etiquette de la bouteille',
        Website => 'Référence sur internet',

        Tasted => 'Testé',
        Comments => 'Appréciation',
        Serving => 'Service',
        TastingField => 'Caractère',

        General => 'Fiche',
        Details => 'Détails',
        Tasting => 'Dégustation',

        TastedNo => 'Non testé',
        TastedYes => 'Testé',

        FilterRange => 'Intervalle',
        FilterTastedNo => '_Non testés',
        FilterTastedYes => '_Déjà testés',
        FilterRatingSelect => 'Notes au _moins égales à...'
     );
}

1;
