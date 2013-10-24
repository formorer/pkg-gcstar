{
    package GCLang::ES::GCModels::GCbooks;

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
    
        CollectionDescription => 'Colección de libros',
        Items => {0 => 'Libro',
                  1 => 'Libro',
                  lowercase1 => 'libro',
                  X => 'Libros',
                  lowercaseX => 'libros',
                  P1 => 'El Libro',
                  lowercaseP1 => 'el libro',
                  U1 => 'Un Libro',
                  lowercaseU1 => 'un libro',
                  AP1 => 'Al Libro',
                  lowercaseAP1 => 'al libro',
                  DP1 => 'Del Libro',
                  lowercaseDP1 => 'del libro',
                  PX => 'Los Libros',
                  lowercasePX => 'los libros',
                  E1 => 'Este Libro',
                  lowercaseE1 => 'este libro',
                  EX => 'Estos Libros',
                  lowercaseEX => 'estos libros'             
                  },        

        NewItem => 'Nuevo libro',
    
        Isbn => 'ISBN',
        Title => 'Título',
        Cover => 'Portada',
        Authors => 'Autores',
        Publisher => 'Editor',
        Publication => 'Fecha de edición',
        Language => 'Idioma',
        Genre => 'Género',
        Serie => 'Serie',
        Rank => 'Capítulo',
        Bookdescription => 'Descripción',
        Pages => 'Páginas',
        Read => 'Leído',
        Acquisition => 'Fecha de adquisición',
        Edition => 'Edición',
        Format => 'Formato',
        Comments => 'Comentarios',
        Url => 'Página web',
        Translator => 'Traductor',
        Artist => 'Artista',
        DigitalFile => 'Digital version',

        General => 'General',
        Details => 'Detalles',

        ReadNo => 'No leído',
        ReadYes => 'Leído',
     );
}

1;
