{
    package GCLang::CS::GCExport::GCExportHTML;

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
        'WithJS' => 'Použít Javascript',
       	'FileTemplate' => 'Šablona:',
        'Preview' => 'Náhled',
        'NoPreview' => 'Náhled není k dispozici',
        'Title' => 'Název HTML stránky: ',
        'InfoFile' => 'Seznam filmů je v souboru: ',
        'InfoDir' => 'Obrázky jsou v: ',
        'HeightImg' => 'Výška obrázků (v pixelech): ',
        'OpenFileInBrowser' => 'Generovaný soubor otevřít ve webovém prohlížeči',
        'Note' => 'Seznam generován aplikací <a href="http://www.gcstar.org/">GCstar</a>',
        'InputTitle' => 'Zadejte text k vyhledání',
        'SearchType1' => 'Pouze název',
        'SearchType2' => 'Všechny informace',
        'SearchButton' => 'Hledání',
        'SearchTitle' => 'Vyhledá filmy, které vyhovují zadaným kritériím',
        'AllButton' => 'Vše',
        'AllTitle' => 'Zobrazí všechny filmy',
        'Expand' => 'Zobrazit vše',
        'ExpandTitle' => 'Zobrazí všechny informace o filmu',
        'Collapse' => 'Skrýt vše',
        'CollapseTitle' => 'Skryje všechny informace o filmu',
        'Borrowed' => 'Má půjčeno: ',
        'NotBorrowed' => 'Nepůjčen',
        'Top' => 'Nahoře',
        'Bottom' => 'Bottom',
     );
}

1;
