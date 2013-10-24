{
    package GCLang::RU::GCModels::GCfilms;

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
    
        CollectionDescription => 'Коллекция фильмов',
        Items => 'Фильмы',
        NewItem => 'Новый фильм',
    
    
        Id => 'Идентификатор',
        Title => 'Название',
        Date => 'Дата',
        Time => 'Длительность',
        Director => 'Режиссёр',
        Country => 'Страна',
        MinimumAge => 'Минимальный возраст',
        Genre => 'Жанр',
        Image => 'Картинка',
        Original => 'Оригинальный заголовок',
        Actors => 'Актеры',
        Actor => 'Actor',
        Role => 'Role',
        Comment => 'Комментарии',
        Synopsis => 'Описание',
        Seen => 'Просмотрен',
        Number => '# носителей',
        Format => 'Носитель',
        Region => 'Region',
        Identifier => 'Identifier',
        Url => 'ВЭБ',
        Audio => 'Аудио',
        Video => 'Видео формат',
        Trailer => 'Видео файл',
        Serie => 'Коллеция',
        Rank => 'Ранг',
        Subtitles => 'Субтитры',

        SeenYes => 'Смотрел',
        SeenNo => 'Не смотрел',

        AgeUnrated => 'Без ограничений',
        AgeAll => 'Для _Любого возраста',
        AgeParent => 'Под присмотром родителей',

        Main => 'Основное',
        General => 'Общие',
        Details => 'Детали',
        Lending => 'На руках',

        Information => 'Информация',
        Languages => 'Языки',
        Encoding => 'Кодирование',

        FilterAudienceAge => 'Возраст аудитории:',
        FilterSeenNo => 'Нет',
        FilterSeenYes => '_Уже просмотрено',
        FilterRatingSelect => 'По Крайней мере...',

        ExtractSize => 'Размер',
     );
}

1;
