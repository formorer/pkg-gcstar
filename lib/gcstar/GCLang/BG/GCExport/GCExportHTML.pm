{
    package GCLang::BG::GCExport::GCExportHTML;

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
        'WithJS' => 'Използване Javascript',
       	'FileTemplate' => 'Шаблон :',
        'Preview' => 'Предварителен изглед',
        'NoPreview' => 'Няма наличен предварителен изглед',
        'Title' => 'Заглание на страница',
        'InfoFile' => 'Списъкът на филми е във файл: ',
        'InfoDir' => 'Изображенията са в: ',
        'HeightImg' => 'Височина в (пиксели) на изображения за експортиране: ',
        'OpenFileInBrowser' => 'Отваряне на генерирания файл в уеб-четец',
        'Note' => 'Списък, генериран от <a href="http://www.gcstar.org/">GCstar</a>',
        'InputTitle' => 'Въведете текст за търсене',
        'SearchType1' => 'Само заглавие',
        'SearchType2' => 'Пълна информация',
        'SearchButton' => 'Търсене',    
        'SearchTitle' => 'Показване само на филми, отговарящи на предишните критерии',
        'AllButton' => 'Вскички',
        'AllTitle' => 'Показване на всички филми',
        'Expand' => 'Разшири всички',
        'ExpandTitle' => 'Показване на цялата информация за филми',
        'Collapse' => 'Сгъване на всички',
        'CollapseTitle' => 'Сгъване на цялата информация за филми',
        'Borrowed' => 'Взет от: ',
        'NotBorrowed' => 'Наличен',
        'Top' => 'Горна част',
        'Bottom' => 'Bottom',
     );
}

1;
