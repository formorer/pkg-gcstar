{
    package GCLang::ES::GCModels::GCcomics;

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
    
        CollectionDescription => 'Colección de cómics',
        Items => {0 => 'Cómics',
                  1 => 'Cómic',
                  lowercase1 => 'cómic',
                  X => 'Cómics',
                  lowercaseX => 'cómics',
                  P1 => 'El Cómic',
                  lowercaseP1 => 'el cómics',
                  U1 => 'Un Cómic',
                  lowercaseU1 => 'un cómic',
                  AP1 => 'Al Cómic',
                  lowercaseAP1 => 'al cómic',
                  DP1 => 'Del Cómic',
                  lowercaseDP1 => 'del cómic',
                  PX => 'Los Cómics',
                  lowercasePX => 'los cómics',
                  E1 => 'Este Cómic',
                  lowercaseE1 => 'este cómic',
                  EX => 'Estos Cómics',
                  lowercaseEX => 'estos cómics'
                  },
        NewItem => 'Cómic nuevo',
    
    
        Id => 'Id',
        Name => 'Nombre',
        Series => 'Serie',
        Volume => 'Volumen',
        Title => 'Título',
        Writer => 'Escritor',
        Illustrator => 'Ilustrador',
        Colourist => 'Colorista',
        Publisher => 'Publicado por',
        Synopsis => 'Sinopsis',
        Collection => 'Colección',
        PublishDate => 'Fecha de publicación',
        PrintingDate => 'Fecha de impresión',
        ISBN => 'ISBN',
        Type => 'Tipo',
		Category => 'Categoría',
        Format => 'Formato',
        NumberBoards => 'Número de páginas',
		Signing => 'Dedicado',
        Cost => 'Coste',
        Rating => 'Puntuación',
        Comment => 'Comentarios',
        Url => 'Página web',

        FilterRatingSelect => 'Puntuación al _menos...',

        Main => 'Elementos principales',
        General => 'General',
        Details => 'Detalles',
     );
}

1;
