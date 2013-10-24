{
    package GCLang::PL::GCExport::GCExportHTML;

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
        'ModelNotFound' => 'Niepoprawny plik szablonu',
        'UseFile' => 'Skorzystaj z poniższego pliku',
        'TemplateExternalFile' => 'Plik szablonu',
        'WithJS' => 'Używaj Javascript',
       	'FileTemplate' => 'Plik tymczasowy:',
        'Preview' => 'Podgląd',
        'NoPreview' => 'Podgląd niedostępny',
        'Title' => 'Tytuł strony',
        'InfoFile' => 'Lista pozycji jest w pliku: ',
        'InfoDir' => 'Obrazy są w : ',
        'HeightImg' => 'Wysokość (w pikselach) obrazu do eksportu: ',
        'OpenFileInBrowser' => 'Otwórz wygenerowany plik w przeglądarce',
        'Note' => 'Lista wygenerowana przez program <a href="http://www.gcstar.org/">GCstar</a>',
        'InputTitle' => 'Wpisz szukany ciąg znaków',
        'SearchType1' => 'Tylko tytuł',
        'SearchType2' => 'Pełna informacja',
        'SearchButton' => 'Szukaj',    
        'SearchTitle' => 'Wyświetlaj tylko filmy pasujące do kryterium szukania',
        'AllButton' => 'Wszystkie',
        'AllTitle' => 'Pokaż wszystkie',
        'Expand' => 'Rozwiń wszystkie',
        'ExpandTitle' => 'Wyświetl informacje o wszystkich filmach',
        'Collapse' => 'Ukryj wszystkie',
        'CollapseTitle' => 'Ukryj informacje o wszystkich filmach',
        'Borrowed' => 'Pożyczone przez: ',
        'NotBorrowed' => 'Dostępne',
        'Top' => 'Góra',
        'Bottom' => 'U dołu',
     );
}

1;
