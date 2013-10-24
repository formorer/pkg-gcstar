{
    package GCLang::IT::GCExport::GCExportHTML;

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
#######################################################
#
#  v1.0.2 - Italian localization by Andreas Troschka
#
#  for GCstar v1.1.1
#
#######################################################

    
    use strict;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
        'ModelNotFound' => 'Invalid template file',
        'UseFile' => 'Use file specified below',
        'TemplateExternalFile' => 'Template file',
        'WithJS' => 'Usa Javascript',
       	'FileTemplate' => 'Modello:',
        'Preview' => 'Anteprima',
        'NoPreview' => 'Anteprima non disponibilee',
        'Title' => 'Titolo pagina',
        'InfoFile' => 'La lista dei film è nel file : ',
        'InfoDir' => 'Immagini sono in : ',
        'HeightImg' => 'Altezza in pixel dell\'immagine da esportare :',
        'OpenFileInBrowser' => 'Apri il file generato nel web browser',
        'Note' => 'Lista generata con <a href="http://www.gcstar.org/">GCstar</a>',
        'InputTitle' => 'Immetti testo da cercare',
        'SearchType1' => 'Solo il titolo',
        'SearchType2' => 'Informazioni complete',
        'SearchButton' => 'Cerca',    
        'SearchTitle' => 'Visualizza solo i film trovati con il criterio precedente',
        'AllButton' => 'Tutto',
        'AllTitle' => 'Visualizza tutti i film',
        'Expand' => 'Espandi tutto',
        'ExpandTitle' => 'Visualizza tutte le informazioni dei film',
        'Collapse' => 'Comprimi tutto',
        'CollapseTitle' => 'Comprimi tutte le informazioni dei film',
        'Borrowed' => 'Preso in prestito da: ',
        'NotBorrowed' => 'Disponibile',
        'Top' => 'In alto',
        'Bottom' => 'Bottom',
     );
}

1;
