{
    package GCLang::ES::GCModels::GCwines;

    use utf8;

#  Copyright 2007 Yves Martin
    
    use strict;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => 'Colección de vinos',
        Items => {0 => 'Vino',
                  1 => 'Vino',
                  lowercase1 => 'vino',
                  X => 'Vinos',
                  lowercaseX => 'vinos',
                  P1 => 'El Vino',
                  lowercaseP1 => 'el vino',
                  U1 => 'Un Vino',
                  lowercaseU1 => 'un vino',
                  AP1 => 'Al Vino',
                  lowercaseAP1 => 'al vino',
                  DP1 => 'Del Vino',
                  lowercaseDP1 => 'del vino',
                  PX => 'Los Vinos',
                  lowercasePX => 'los vinos',
                  E1 => 'Este Vino',
                  lowercaseE1 => 'este vino',
                  EX => 'Estos Vinos',
                  lowercaseEX => 'estos vinos'             
                  },
        NewItem => 'Nuevo vino',
    
        Name => 'Nombre',
        Designation => 'Designación',
        Vintage => 'Cosecha',
        Vineyard => 'Viñedo',
        Type => 'Tipo',
        Grapes => 'Uvas',
        Soil => 'Suelo',
        Producer => 'Productor',
        Country => 'País',
        Volume => 'Volumen (ml)',
        Alcohol => 'Alcohol (%)',
        Medal => 'Medalla/Honores',

        Storage => 'Almacenamiento',
        Location => 'Localización',
        ShelfIndex => 'Índice',
        Quantity => 'Cantidad',
        Acquisition => 'Adquisición',
        PurchaseDate => 'Fecha de compra',
        PurchasePrice => 'Precio de compra',
        Gift => 'Regalo',
        BottleLabel => 'Etiqueta de la botella',
        Website => 'Referencias en la Web',

        Tasted => 'Catado',
        Comments => 'Comentarios',
        Serving => 'Servir',
        TastingField => 'Notas para cata',

        General => 'General',
        Details => 'Detalles',
        Tasting => 'Cata',

        TastedNo => 'No catado',
        TastedYes => 'Catado',

        FilterRange => 'Rango',
        FilterTastedNo => '_No catado',
        FilterTastedYes => 'Ya _catado',
        FilterRatingSelect => 'Puntuación al _menos...'

     );
}

1;
