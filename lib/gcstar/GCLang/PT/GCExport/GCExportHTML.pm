{
    package GCLang::PT::GCExport::GCExportHTML;

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
        'WithJS' => 'Usar Javascript',
       	'FileTemplate' => 'Modelo:',
        'Preview' => 'Prévia',
        'NoPreview' => 'Nenhuma prévia disponível',
        'Title' => 'Título da página',
        'InfoFile' => 'Arquivo de lista de filmes: ',
        'InfoDir' => 'Pasta de imagens: ',
        'HeightImg' => 'Altura (em pixels) da imagem exportada: ',
        'OpenFileInBrowser' => 'Abrir arquivo gerado no navegador',
        'Note' => 'Lista generada por <a href="http://www.gcstar.org/">GCstar</a>',
        'InputTitle' => 'Introduza texto de busca',
        'SearchType1' => 'Apenas título',
        'SearchType2' => 'Toda informação',
        'SearchButton' => 'Procurar',    
        'SearchTitle' => 'Mostrar apenas filmes coincidentes com o critérios anteriores',
        'AllButton' => 'Todos',
        'AllTitle' => 'Mostrar todos os filmes',
        'Expand' => 'Expandir tudo',
        'ExpandTitle' => 'Motrar informação de todos os filmes',
        'Collapse' => 'Contrair tudo',
        'CollapseTitle' => 'Ocultar a informação de todos os filmes',
        'Borrowed' => 'Emprestado por: ',
        'NotBorrowed' => 'Disponível',
        'Top' => 'Topo',
        'Bottom' => 'Bottom',
     );
}

1;
