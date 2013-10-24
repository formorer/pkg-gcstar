{
    package GCLang::GL::GCModels::GCbooks;

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
                  X => 'Libros'},
        NewItem => 'Novo libro',
    
        Isbn => 'ISBN',
        Title => 'Título',
        Cover => 'Cuberta',
        Authors => 'Autores',
        Publisher => 'Editorial',
        Publication => 'Data de publicación',
        Language => 'Lingua',
        Genre => 'Xénero',
        Serie => 'Serie',
        Rank => 'Puntuación',
        Bookdescription => 'Descripción',
        Pages => 'Páxinas',
        Read => 'Lido',
        Acquisition => 'Data de adquisición',
        Edition => 'Edición',
        Format => 'Formato',
        Comments => 'Comentarios',
        Url => 'Páxina web',
        Translator => 'Traductor/a',
        Artist => 'Artista',
        DigitalFile => 'Digital version',

        General => 'Xeral',
        Details => 'Detalles',

        ReadNo => 'Non lido',
        ReadYes => 'Lido',
     );
}

1;
