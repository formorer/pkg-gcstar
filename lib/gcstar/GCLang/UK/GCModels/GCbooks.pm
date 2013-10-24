{
    package GCLang::UK::GCModels::GCbooks;

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
    
        CollectionDescription => 'Колекція книг',
        Items => 'Книги',
        NewItem => 'Нова книга',
    
        Isbn => 'ISBN',
        Title => 'Заголовок',
        Cover => 'Обкладинка',
        Authors => 'Автори',
        Publisher => 'Видавець',
        Publication => 'Дата видання',
        Language => 'Мова',
        Genre => 'Жанр',
        Serie => 'Серія',
        Rank => 'Розряд',
        Bookdescription => 'Опис',
        Pages => 'Сторінок',
        Read => 'Прочитана',
        Rating => 'Оцінка',
        Acquisition => 'Дата придбання',
        Edition => 'Видання',
        Format => 'Формат',
        Comments => 'Коментарі',
        Url => 'Сторінка тенет',
        Translator => 'Перекладач',
        Artist => 'Художник',
        DigitalFile => 'Digital version',

        General => 'Загальна',
        Details => 'Подробиці',

        ReadNo => 'Не прочитана',
        ReadYes => 'Прочитана',
     );
}

1;
