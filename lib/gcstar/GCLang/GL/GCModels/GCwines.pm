{
    package GCLang::GL::GCModels::GCwines;

    use utf8;

#  Copyright 2007 Yves Martin
    
    use strict;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => 'Colección de viños',
        Items => {0 => 'Viño',
                  1 => 'Viño',
                  X => 'Viños'},
        NewItem => 'Novo Viño',
    
        Name => 'Nome',
        Designation => 'Denominación',
        Vintage => 'Colleita',
        Vineyard => 'Viñedo',
        Type => 'Tipo',
        Grapes => 'Uva',
        Soil => 'Terra',
        Producer => 'Producción',
        Country => 'País',
        Volume => 'Volume (ml)',
        Alcohol => 'Alcol (%)',
        Medal => 'Medalla',

        Storage => 'Almacenamento',
        Location => 'Localización',
        ShelfIndex => 'Índice',
        Quantity => 'Cantidade',
        Acquisition => 'Adquisición',
        PurchaseDate => 'Data de compra',
        PurchasePrice => 'Prezo de compra',
        Gift => 'Regalo',
        BottleLabel => 'Etiqueta da botella',
        Website => 'Referencias na web',

        Tasted => 'Catado',
        Comments => 'Comentarios',
        Serving => 'Dose',
        TastingField => 'Notas da cata',

        General => 'Xeral',
        Details => 'Detalles',
        Tasting => 'Cata',

        TastedNo => 'Sen catar',
        TastedYes => 'Catado',

        FilterRange => 'Rango',
        FilterTastedNo => '_Non foi catado',
        FilterTastedYes => 'Xa foi catado',
        FilterRatingSelect => 'Puntuado polo menos...'

     );
}

1;
