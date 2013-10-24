{
    package GCLang::CA::GCExport::GCExportHTML;

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
        'ModelNotFound' => 'Fitxer de plantilla invàlid',
        'UseFile' => 'Utilitza el fitxer especificat abaix',
        'TemplateExternalFile' => 'Fitxer de plantilla',
        'WithJS' => 'Utilitza Javascript',
       	'FileTemplate' => 'Plantilla:',
        'Preview' => 'Vista prèvia',
        'NoPreview' => 'Vista prèvia no disponible',
        'Title' => 'Títol de la pàgina',
        'InfoFile' => 'El llistat de les pel·lícules es troba a l\'arxiu: ',
        'InfoDir' => 'Les imatges es troben a: ',
        'HeightImg' => 'Alçada en píxels de les imatges a exportar: ',
        'OpenFileInBrowser' => 'Obri el fitxer generat en el navegador web',
        'Note' => 'Llistat generat amb <a href="http://www.gcstar.org/">GCstar</a>',
        'InputTitle' => 'Introduíeu el text a cercar',
        'SearchType1' => 'Només el Títol',
        'SearchType2' => 'Tota la informació',
        'SearchButton' => 'Cerca',    
        'SearchTitle' => 'Mostra només les pel·lícules coincidents amb els criteris anteriors',
        'AllButton' => 'Totes',
        'AllTitle' => 'Mostra totes les pel·lícules',
        'Expand' => 'Tots desplegats',
        'ExpandTitle' => 'Mostrar la informació de totes les pel·lícules',
        'Collapse' => 'Tots plegats',
        'CollapseTitle' => 'Oculta la informació de totes les pel·lícules',
        'Borrowed' => 'Prestatari: ',
        'NotBorrowed' => 'Disponible',
        'Top' => 'Amunt',
        'Bottom' => 'Devall',
     );
}

1;
