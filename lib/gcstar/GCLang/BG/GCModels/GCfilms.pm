{
    package GCLang::BG::GCModels::GCfilms;

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
    
        CollectionDescription => 'Movies collection',
        Items => 'Филми',
        NewItem => 'Нов филм',
    
    
        Id => 'Id',
        Title => 'Заглавие',
        Date => 'Дата',
        Time => 'Продължителност',
        Director => 'Режисьор',
        Country => 'Държава',
        MinimumAge => 'Минимална възраст',
        Genre => 'Жанр',
        Image => 'Изображение',
        Original => 'Оригинално заглавие',
        Actors => 'Участват',
        Actor => 'Actor',
        Role => 'Role',
        Comment => 'Коментари',
        Synopsis => 'Резюме',
        Seen => 'Гледан',
        Number => '# на медии',
        Format => 'Тип медия',
        Region => 'Region',
        Identifier => 'Identifier',
        Url => 'Уеб',
        Audio => 'Аудио',
        Video => 'Видео формат',
        Trailer => 'Видео файл',
        Serie => 'Колекция',
        Rank => 'Ранг',
        Subtitles => 'Субтитри',

        SeenYes => 'Показани',
        SeenNo => 'Непоказани',

        AgeUnrated => 'Без рейтинг',
        AgeAll => 'Всички възрасти',
        AgeParent => 'Ръководство на родителя',

        Main => 'Основни',
        General => 'Общи',
        Details => 'Детайли',

        Information => 'Информация',
        Languages => 'Езици',
        Encoding => 'Кодиране',

        FilterAudienceAge => 'Зрителска възраст',
        FilterSeenNo => '_Още не показани',
        FilterSeenYes => '_Already Viewed',
        FilterRatingSelect => 'Рейтинг най-малко...',

        ExtractSize => 'Размер',
     );
}

1;
