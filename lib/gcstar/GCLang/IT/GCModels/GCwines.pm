{
    package GCLang::IT::GCModels::GCwines;

    use utf8;

#  Copyright 2007 Yves Martin

#######################################################
#
#  v2.0.12 - Italian localization by Andreas Troschka
#
#  for GCstar v1.1.1
#
#######################################################
    
    use strict;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => 'Enoteca',
        Items => {0 => 'Vini',
                  1 => 'Vini',
                  X => 'Vini'},
        NewItem => 'Nuovo vino',
    
        Name => 'Nome',
        Designation => 'Designazione',
        Vintage => 'Annata',
        Vineyard => 'Vigna',
        Type => 'Tipo',
        Grapes => 'Uve',
        Soil => 'Suolo',
        Producer => 'Produttore',
        Country => 'Nazione',
        Volume => 'Capacita\' (ml)',
        Alcohol => 'Gradazione alc. (%)',
        Medal => 'Premi',

        Storage => 'Conservazione',
        Location => 'Localizzazione',
        ShelfIndex => 'Indice',
        Quantity => 'Quantita\'',
        Acquisition => 'Acquisizione',
        PurchaseDate => 'Data acquisto',
        PurchasePrice => 'Prezzo',
        Gift => 'Omaggio',
        BottleLabel => 'Etichetta',
        Website => 'Riferimento sul web',

        Tasted => 'Assaggiato',
        Comments => 'Commenti',
        Serving => 'Da servire',
        TastingField => 'Note',

        General => 'Generali',
        Details => 'Detttagli',
        Tasting => 'Assaggio',

        TastedNo => 'Non assaggiato',
        TastedYes => 'Assaggiato',

        FilterRange => 'Campo',
        FilterTastedNo => '_Non ancora assaggiato',
        FilterTastedYes => 'Gia\' assaggia_to',
        FilterRatingSelect => 'Valutato a_lmeno...'

     );
}

1;
