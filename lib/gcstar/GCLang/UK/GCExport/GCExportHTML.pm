{
    package GCLang::UK::GCExport::GCExportHTML;

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
        'ModelNotFound' => 'Неприпустимий файл зразка',
        'UseFile' => 'Вживати файл, вказаний нижче',
        'TemplateExternalFile' => 'Файл зразка',
        'WithJS' => 'Використовувати Javascript',
       	'FileTemplate' => 'Зразок:',
        'Preview' => 'Попередній перегляд',
        'NoPreview' => 'Перегляд недоступний',
        'Title' => 'Заголовок сторінки',
        'InfoFile' => 'Список фільмів у файлі: ',
        'InfoDir' => 'Зображення у: ',
        'HeightImg' => 'Висота (у пікселях) експортованих зображень: ',
        'OpenFileInBrowser' => 'Відкрити створений файл у переглядачі тенет',
        'Note' => 'Список створений програмою <a href="http://www.gcstar.org/">GCstar</a>',
        'InputTitle' => 'Введіть текст для пошуку',
        'SearchType1' => 'Лише заголовки',
        'SearchType2' => 'Повна інформація',
        'SearchButton' => 'Пошук',    
        'SearchTitle' => 'Показувати лише фільми, що відповідають попереднім критеріям',
        'AllButton' => 'Всі',
        'AllTitle' => 'Показувати всі фільми',
        'Expand' => 'Розгорнути всі',
        'ExpandTitle' => 'Показати всю інформацію про фільми',
        'Collapse' => 'Згорнути всі',
        'CollapseTitle' => 'Згорнути всю інформацію про фільми',
        'Borrowed' => 'Позичений: ',
        'NotBorrowed' => 'Доступний',
        'Top' => 'Вгору',
        'Bottom' => 'Вниз',
     );
}

1;
