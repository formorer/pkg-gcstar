{
    package GCLang::UK::GCModels::GCfilms;

    use utf8;
###################################################
#
#  Copyright 2005-2010 Christian Jodar
#
#  This file is part of GCstar.
#
#  GCstar is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  GCstar is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with GCstar; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
#
###################################################
    
    use strict;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => 'Колекція фільмів',
        Items => 'Фільми',
        NewItem => 'Новий фільм',
    
    
        Id => 'Ідентифікатор',
        Title => 'Назва',
        Date => 'Дата',
        Time => 'Тривалість',
        Director => 'Режисер',
        Country => 'Країна',
        MinimumAge => 'Мінімальний вік',
        Genre => 'Жанр',
        Image => 'Зображення',
        Original => 'Оригінальна назва',
        Actors => 'В ролях',
        Actor => 'Актор',
        Role => 'Роль',
        Comment => 'Коментарі',
        Synopsis => 'Анотація',
        Seen => 'Переглянутий',
        Number => 'Кількість носіїв',
        Rating => 'Оцінка',
        Format => 'Носій',
        Region => 'Region',
        Identifier => 'Ідентифікатор',
        Url => 'Сторінка тенет',
        Audio => 'Звук',
        Video => 'Відео формат',
        Trailer => 'Відеофайл',
        Serie => 'Колекція',
        Rank => 'Розряд',
        Subtitles => 'Субтитри',

        SeenYes => 'Переглянутий',
        SeenNo => 'Не переглянутий',

        AgeUnrated => 'Неоцінений',
        AgeAll => 'Будь-який вік',
        AgeParent => 'Під наглядом батьків',

        Main => 'Головні пункти',
        General => 'Загальна',
        Details => 'Подробиці',

        Information => 'Інформація',
        Languages => 'Мови',
        Encoding => 'Кодування',

        FilterAudienceAge => 'Вік глядачів',
        FilterSeenNo => '_Ще не переглянутий',
        FilterSeenYes => '_Вже переглянутий',
        FilterRatingSelect => '_Оцінка принаймні...',

        ExtractSize => 'Розмір',
     );
}

1;
