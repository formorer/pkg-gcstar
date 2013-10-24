{
    package GCLang::GL::GCModels::GCcomics;

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
    
        CollectionDescription => 'Colección de Comics',
        Items => {0 => 'Comics',
                  1 => 'Comic',
                  X => 'Comics'},
        NewItem => 'Novo comic',
    
    
        Id => 'Id',
        Name => 'Nome',
        Series => 'Serie',
        Volume => 'Volume',
        Title => 'Título',
        Writer => 'Guión',
        Illustrator => 'Ilustracións',
        Colourist => 'Cor',
        Publisher => 'Editorial',
        Synopsis => 'Resumo',
        Collection => 'Colección',
        PublishDate => 'Data de publicación',
        PrintingDate => 'Data de impresión',
        ISBN => 'ISBN',
        Type => 'Tipo',
		Category => 'Category',
        Format => 'Formato',
        NumberBoards => 'Número de planchas',
		Signing => 'Signing',
        Cost => 'Prezo',
        Rating => 'Puntuación',
        Comment => 'Comentarios',
        Url => 'Sitio web',

        FilterRatingSelect => 'Puntuado polo menos...',

        Main => 'Elementos principais',
        General => 'Xeral',
        Details => 'Detalles',
     );
}

1;
