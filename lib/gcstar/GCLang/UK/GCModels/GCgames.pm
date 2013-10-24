{
    package GCLang::UK::GCModels::GCgames;

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
    
        CollectionDescription => 'Колекція відеоігор',
        Items => 'Ігри',
        NewItem => 'Нова гра',
    
        Id => 'Ідентифікатор',
        Ean => 'EAN',
        Name => 'Назва',
        Platform => 'Платформа',
        Players => 'Кількість гравців',
        Released => 'Дата випуску',
        Editor => 'Редактор',
        Developer => 'Розробник',
        Genre => 'Жанр',
        Box => 'Зображення коробки',
        Case => 'Корпус',
        Manual => 'Підручник інструкцій',
        Rating => 'Оцінка',
        Completion => 'Завершено (%)',
        Executable => 'Запускаючий файл',
        Description => 'Опис',
        Codes => 'Коди',
        Code => 'Код',
        Effect => 'Наслідок',
        Secrets => 'Секрети',
        Screenshots => 'Знімки екрану',
        Screenshot1 => 'Перший знімок',
        Screenshot2 => 'Другий знімок',
        Comments => 'Коментарі',
        Url => 'Сторінка тенет',
        Unlockables => 'Розблокування',
        Unlockable => 'Розблокування',
        Howto => 'Як розблокувати',
        Exclusive => 'Exclusive',
        Resolutions => 'Display resolutions',
        InstallationSize => 'Size',
        Region => 'Region',
        SerialNumber => 'Serial Number',        

        General => 'Загальна',
        Details => 'Подробиці',
        Tips => 'Поради',
        Information => 'Інформація',

        FilterRatingSelect => '_Оцінка принаймні...',
     );
}

1;
