{
    package GCLang::RU::GCModels::GCgames;

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
    
        CollectionDescription => 'Коллекция видео-игр',
        Items => 'Игры',
        NewItem => 'Новая игра',
    
        Id => 'Идентификатор',
        Ean => 'EAN',
        Name => 'Имя',
        Platform => 'Платформа',
        Players => 'Количество игроков',
        Released => 'Дата выпуска',
        Editor => 'Редактор',
        Developer => 'Developer',
        Genre => 'Жанр',
        Box => 'Изображения коробки',
        Case => 'Case',
        Manual => 'Instructions manual',
        Completion => 'Пройдено (%)',
        Executable => 'Executable',
        Description => 'Описание',
        Codes => 'Коды',
        Code => 'Код',
        Effect => 'Эффект',
        Secrets => 'Секреты',
        Screenshots => 'Снимки экраны',
        Screenshot1 => 'Первый снимок',
        Screenshot2 => 'Второй снимок',
        Comments => 'Comments',
        Url => 'ВЭБ страница',
        Unlockables => 'Бонусы',
        Unlockable => 'Бонусы',
        Howto => 'Как разблокировать',
        Exclusive => 'Exclusive',
        Resolutions => 'Display resolutions',
        InstallationSize => 'Size',
        Region => 'Region',
        SerialNumber => 'Serial Number',        

        General => 'Общее',
        Details => 'Детали',
        Tips => 'Подсказки',
        Information => 'Информация',

        FilterRatingSelect => 'По Крайней мере...',
     );
}

1;
