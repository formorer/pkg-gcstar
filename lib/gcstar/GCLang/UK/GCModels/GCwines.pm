{
    package GCLang::UK::GCModels::GCwines;

    use utf8;
    
    use strict;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => 'Колекція вин',
        Items => {0 => 'Вин',
                  1 => 'Вино',
                  X => 'Вин'},
        NewItem => 'Нове вино',
    
        Name => 'Назва',
        Designation => 'Позначка',
        Vintage => 'Модель',
        Vineyard => 'Виноградник',
        Type => 'Тип',
        Grapes => 'Виноград',
        Soil => 'Грунт',
        Producer => 'Виробник',
        Country => 'Країна',
        Volume => 'Об\'єм (мл)',
        Alcohol => 'Спирт (%)',
        Medal => 'Медаль/Вшанування',

        Storage => 'Зберігання',
        Location => 'Місце',
        ShelfIndex => 'Покажчик',
        Quantity => 'Розмір',
        Acquisition => 'Придбано',
        PurchaseDate => 'Дата покупки',
        PurchasePrice => 'Вартість покупки',
        Gift => 'Подарунок',
        BottleLabel => 'Етикетка пляшки',
        Website => 'Посилання на тенета',

        Tasted => 'Дегустоване',
        Comments => 'Коментарі',
        Serving => 'Порції',
        TastingField => 'Помітки дегустації',

        General => 'Загальна',
        Details => 'Подробиці',
        Tasting => 'Дегустація',

        TastedNo => 'Не дегустоване',
        TastedYes => 'Дегустоване',

        FilterRange => 'Діапазон',
        FilterTastedNo => '_Ще не дегустоване',
        FilterTastedYes => 'Уже _дегустоване',
        FilterRatingSelect => 'Оцінка _принаймні...'

     );
}

1;
