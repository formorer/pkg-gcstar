{
    package GCLang::RU::GCExport::GCExportHTML;

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
        'ModelNotFound' => 'Invalid template file',
        'UseFile' => 'Use file specified below',
        'TemplateExternalFile' => 'Template file',
        'WithJS' => 'Использовать Javascript',
       	'FileTemplate' => 'Шаблон:',
        'Preview' => 'Предварительный просмотр',
        'NoPreview' => 'Предварительный просмотр недоступен',
        'Title' => 'Заголовок страницы',
        'InfoFile' => 'Список фильмов в файле: ',
        'InfoDir' => 'Изображения в: ',
        'HeightImg' => 'Высота (в пикселах) изображения для экспорта: ',
        'OpenFileInBrowser' => 'Открыть созданый файл в вэб-браузере',
        'Note' => 'Список сгенерирован <a href="http://www.gcstar.org/">GCstar</a>',
        'InputTitle' => 'Введите текст для поиска',
        'SearchType1' => 'Только заголовок',
        'SearchType2' => 'полная информация',
        'SearchButton' => 'Искать',    
        'SearchTitle' => 'Отобразить только фильмы удовлетворяющие предыдущему критерию',
        'AllButton' => 'Все',
        'AllTitle' => 'Отобразить все фильмы',
        'Expand' => 'Раскрыть все',
        'ExpandTitle' => 'Показать информацию всех фильмов',
        'Collapse' => 'Свернуть все',
        'CollapseTitle' => 'Свернуть информацию всех фильмоы',
        'Borrowed' => 'Взял : ',
        'NotBorrowed' => 'Доступен',
        'Top' => 'Наверх',
        'Bottom' => 'Bottom',
     );
}

1;
