{
    package GCLang::HU::GCExport::GCExportHTML;

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
        'ModelNotFound' => 'Érvénytelen sablonfájl',
        'UseFile' => 'Alább megadott fájl használata',
        'WithJS' => 'Javascript használata',
       	'FileTemplate' => 'Sablon',
        'Preview' => 'Előnézet',
        'NoPreview' => 'Előnézet nem elérhető',
        'TemplateExternalFile' => 'Sablonfájl',
        'Title' => 'Oldal címe',
        'InfoFile' => 'Filmlista ebben a fájlban: ',
        'InfoDir' => 'Képek itt: ',
        'HeightImg' => 'Az exportálandó képek magassága (pixelekben)',
        'OpenFileInBrowser' => 'A létrehozott fájl megnyitása webböngészőben',
        'Note' => 'A lista létrehozva a következővel <a href="http://www.gcstar.org/">GCstar</a>',
        'InputTitle' => 'Szöveg keresése',
        'SearchType1' => 'Csak cím',
        'SearchType2' => 'Teljes információ',
        'SearchButton' => 'Keresés',    
        'SearchTitle' => 'Csak a kritériumoknak megfelelő filmek mutatása',
        'AllButton' => 'Mind',
        'AllTitle' => 'Minden film mutatása',
        'Expand' => 'Több',
        'ExpandTitle' => 'Bővített filminformációk mutatása',
        'Collapse' => 'Kevesebb',
        'CollapseTitle' => 'Összevont filminformációk mutatása',
        'Borrowed' => 'Kölcsönvéve: ',
        'NotBorrowed' => 'Elérhető',
        'Top' => 'Fennt',
        'Bottom' => 'Lennt',
     );
}

1;
