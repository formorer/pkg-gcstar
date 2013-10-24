{
    package GCLang::ES::GCExport::GCExportHTML;

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
        'ModelNotFound' => 'Fichero de plantilla inválido',
        'UseFile' => 'Usar el fichero especificado abajo',
        'TemplateExternalFile' => 'Fichero de plantilla',
        'WithJS' => 'Utilizar Javascript',
       	'FileTemplate' => 'Plantilla :',
        'Preview' => 'Vista previa',
        'NoPreview' => 'Vista previa no disponible',
        'Title' => 'Título de la página',
        'InfoFile' => 'El listado se encuentra en el archivo : ',
        'InfoDir' => 'Las imágenes se encuentran en : ',
        'HeightImg' => 'Altura en pixels de las imágenes a exportar : ',
        'OpenFileInBrowser' => 'Abrir el fichero generado en el navegador web',
        'Note' => 'Listado generado con <a href="http://www.gcstar.org/">GCstar</a>',
        'InputTitle' => 'Introduzca el texto a buscar',
        'SearchType1' => 'Sólo el Título',
        'SearchType2' => 'Toda la información',
        'SearchButton' => 'Buscar',    
        'SearchTitle' => 'Mostrar sólo las películas coincidentes con los criterios anteriores',
        'AllButton' => 'Todas',
        'AllTitle' => 'Mostrar todas las películas',
        'Expand' => 'Todos desplegados',
        'ExpandTitle' => 'Mostrar la información de todas las películas',
        'Collapse' => 'Todos plegados',
        'CollapseTitle' => 'Ocultar la información de todas las películas',
        'Borrowed' => 'Prestatario : ',
        'NotBorrowed' => 'Disponible',
        'Top' => 'Arriba',
        'Bottom' => 'Abajo',
     );
}

1;
