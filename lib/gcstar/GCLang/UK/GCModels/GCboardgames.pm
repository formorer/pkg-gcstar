{
    package GCLang::UK::GCModels::GCboardgames;

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
    
        CollectionDescription => 'Колекція настільних ігор',
        Items => {0 => 'Ігор',
                  1 => 'Гра',
                  X => 'Ігор'},
        NewItem => 'Нова гра',
    
        Id => 'Id',
        Name => 'Назва',
        Original => 'Оригінальна назва',
        Box => 'Зображення коробки',
        DesignedBy => 'Розроблена',
        PublishedBy => 'Видана',
        Players => 'Число гравців',
        PlayingTime => 'Час гри',
        SuggestedAge => 'Рекомендований вік',
        Released => 'Випущено',
        Description => 'Опис',
        Category => 'Категорія',
        Mechanics => 'Механіка',
        ExpandedBy => 'Розширення',
        ExpansionFor => 'Розширення для',
        GameFamily => 'Сім\'я ігор',
        IllustratedBy => 'Ілюстрації',
        Url => 'Сторінка тенет',
        TimesPlayed => 'Грали разів',
        CompleteContents => 'Наявність вмісту',
        Copies => 'Число копій',
        Condition => 'Стан',
        Photos => 'Фотографії',
        Photo1 => 'Перше зображення',
        Photo2 => 'Друге зображення',
        Photo3 => 'Третє зображення',
        Photo4 => 'Четверте зображення',
        Comments => 'Коментарі',

        Perfect => 'Чудово',
        Good => 'Добре',
        Average => 'Посередньо',
        Poor => 'Погано',

        CompleteYes => 'Наявний повністю',
        CompleteNo => 'Частково втрачений',

        General => 'Загальна',
        Details => 'Подробиці',
        Personal => 'Особиста',
        Information => 'Інформація',

        FilterRatingSelect => '_Оцінка принаймні...',
     );
}

1;
