{
    package GCLang::DE::GCExport::GCExportHTML;

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
        'ModelNotFound' => 'Ungültige Templatedatei',
        'UseFile' => 'Nutze angegebene Datei',
        'TemplateExternalFile' => 'Templatedatei',
        'WithJS' => 'Javascript verwenden',
       	'FileTemplate' => 'Template:',
        'Preview' => 'Vorschau',
        'NoPreview' => 'Keine Vorschau verfügbar',
        'Title' => 'Seitentitel',
        'InfoFile' => 'Liste erstellt: ',
        'InfoDir' => 'Bilder gespeichert unter: ',
        'HeightImg' => 'Höhe der zu exportierenden Bilder (in Pixeln): ',
        'OpenFileInBrowser' => 'Erzeugte Datei im Webbrowser öffnen',
        'Note' => 'Liste erstellt mit <a href="http://www.gcstar.org/">GCstar</a>',
        'InputTitle' => 'Suchtext eingeben',
        'SearchType1' => 'Nur Titel',
        'SearchType2' => 'Alle Informationen',
        'SearchButton' => 'Suche',    
        'SearchTitle' => 'Nur Elemente anzeigen die diesen Kriterien entsprechen',
        'AllButton' => 'Alle',
        'AllTitle' => 'Alle Elemente anzeigen',
        'Expand' => 'Alle maximieren',
        'ExpandTitle' => 'Alle Informationen anzeigen',
        'Collapse' => 'Alle minimieren',
        'CollapseTitle' => 'Nur Titel anzeigen',
        'Borrowed' => 'Ausgeliehen von: ',
        'NotBorrowed' => 'Verfügbar',
        'Top' => 'Oben',
        'Bottom' => 'Unten',
     );
}

1;
