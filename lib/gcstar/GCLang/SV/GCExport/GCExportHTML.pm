{
    package GCLang::SV::GCExport::GCExportHTML;

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
        'ModelNotFound' => 'Ogiltig mall-fil',
        'UseFile' => 'Använd nedanstående specificerade fil',
        'TemplateExternalFile' => 'Mall-fil',
        'WithJS' => 'Använd Javascript',
       	'FileTemplate' => 'Mall:',
        'Preview' => 'Förhandsgranskning',
        'NoPreview' => 'Ingen förhandsgranskning tillgänglig',
        'Title' => 'Sidans titel',
        'InfoFile' => 'Filmlistan är i filen: ',
        'InfoDir' => 'Bilder är i: ',
        'HeightImg' => 'Höjd (i pixlar) på bilderna som kommer exporteras: ',
        'OpenFileInBrowser' => 'Öppna genererad fil i webbläsaren',
        'Note' => 'Lista genererad med <a href="http://www.gcstar.org/">GCstar</a>',
        'InputTitle' => 'Ange söktext',
        'SearchType1' => 'Endast titel',
        'SearchType2' => 'Full information',
        'SearchButton' => 'Sök',    
        'SearchTitle' => 'Visa endast filmer som matchar föregående kriterium',
        'AllButton' => 'Alla',
        'AllTitle' => 'Visa alla filmer',
        'Expand' => 'Expandera alla',
        'ExpandTitle' => 'Visa information om alla filmer',
        'Collapse' => 'Fäll ihop alla',
        'CollapseTitle' => 'Fäll ihop information om alla filmer',
        'Borrowed' => 'Lånad av: ',
        'NotBorrowed' => 'Tillgänglig',
        'Top' => 'Topp',
        'Bottom' => 'Botten',
     );
}

1;
