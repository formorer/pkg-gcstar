{
    package GCLang::PL::GCImport::GCImportFolder;

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
    use GCLang::GCLangUtils;

    our @EXPORT = qw(%lang);

    our %lang = (
        'Name' => 'Katalog',
        'Recursive' => 'Przeglądaj podkatalogi',
        'Suffixes' => 'Sufiksy lub rozszerzenia nazw plików',
        'SuffixesTooltip' => 'Lista sufiksów lub rozszerzeń nzaw plików rozdzielonych przecinkami',
        'Remove' => 'Do usunięcia z nazw',
        'RemoveTooltip' => 'Lista słów rozdzielonych przecinkami, które mają być usunięte z nazw plików w trakcie pobierania',
        'Ask'=> 'Ask',
        'AskEnd'=> 'Ask all at end',
        'AddWithoutInfo'=> 'Add without infos',
        'DontAdd'=> 'Do not add',
        'TakeFirst' => 'Select first',
        'MultipleResult'=> 'Multiple results',
        'MultipleResultTooltip'=> 'What do we do when more than 1 result is return by the plugin',
        'RemoveWholeWord' => 'Usuń tylko całe słowa',
        'NoResult'=> 'No results',
        'NoResultTooltip'=> 'What do we do when no search results is return by the plugin',
        'RemoveTooltipWholeWord' => 'Słowa będą usuwane tylko jeśli wystąpią w całości',
        'RemoveRegularExpr' => 'Wyrażenie regularne',
        'RemoveTooltipRegularExpr' => 'Pamiętaj, że \'Do usunięcia z nazw\' jest wyrażeniem regularnym Perla',
        'SkipFileAlreadyInCollection' => 'Dodaj tylko nowe pliki',
        'SkipFileAlreadyInCollectionTooltip' => 'Dodaje tylko te pliki, których jeszcze nie ma w Zbiorze',
        'SkipFileNo' => 'Nie',
        'SkipFileFullPath' => 'na podstawie pełnej ścieżki',
        'SkipFileFileName' => 'na podstawie nazwy pliku',
        'SkipFileFileNameAndUpdate' => 'na podstawie nazwy pliku (ale zmienia ścieżkę w Zbiorze)',
        'InfoFromFileNameRegExp' => 'Parse file name with this regular expression',
        'InfoFromFileNameRegExpTooltip' => 'Use this to retrieve infos from filename (applied after removing extension).\nLeave empty if not needed.\nKnown fields : \n$T:Title, $A:Alphabetised title, $Y:Release date, $S:Season, $E:Episode, $N:Alphabetised serie name, $x:Part number, $y: Total part number',

     );

    # As this plugin shares some values with ImportList, it adds them from it
    importTranslation('List');
}

1;
