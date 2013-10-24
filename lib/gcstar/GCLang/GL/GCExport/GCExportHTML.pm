{
    package GCLang::GL::GCExport::GCExportHTML;

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
        'ModelNotFound' => 'O ficheiro de modelo non é válido',
        'UseFile' => 'Usar o ficheiro seguinte',
        'WithJS' => 'Usar Javascript',
       	'FileTemplate' => 'Modelo',
        'Preview' => 'Previsualización',
        'NoPreview' => 'Non hai unha previsualización dispoñible',
        'TemplateExternalFile' => 'Ficheiro de modelo',
        'Title' => 'Título da páxina',
        'InfoFile' => 'A listaxe de Filmes está neste ficheiro: ',
        'InfoDir' => 'As imaxes están en: ',
        'HeightImg' => 'Altura (en pixels) da imaxe a exportar',
        'OpenFileInBrowser' => 'Abrir o ficheiro xerado no navegador',
        'Note' => 'Listaxe xerada por <a href="http://www.gcstar.org/">GCstar</a>',
        'InputTitle' => 'Introduza o texto da busca',
        'SearchType1' => 'Só o título',
        'SearchType2' => 'Información completa',
        'SearchButton' => 'Procura',    
        'SearchTitle' => 'Amosar só os filmes que cumpren os criterior previos',
        'AllButton' => 'Todos',
        'AllTitle' => 'Amosar todos os filmes',
        'Expand' => 'Expandir todo',
        'ExpandTitle' => 'Amosar información de todos os filmes',
        'Collapse' => 'Contraer todo',
        'CollapseTitle' => 'Contraer a información de todas os filmes',
        'Borrowed' => 'Prestado por: ',
        'NotBorrowed' => 'Dispoñible',
        'Top' => 'Arriba',
        'Bottom' => 'Bottom',
     );
}

1;
