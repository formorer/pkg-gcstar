{
    package GCLang::GL::GCModels::GCmusics;

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
    
        CollectionDescription => 'Colección de música',
        Items => {0 => 'Album',
                  1 => 'Album',
                  X => 'Albumes'},
        NewItem => 'Novo album',
    
        Unique => 'ISRC/EAN',
        Title => 'Título',
        Cover => 'Cuberta',
        Artist => 'Artista',
        Format => 'Formato',
        Running => 'Duración',
        Release => 'Data de lanzamento',
        Genre => 'Xénero',
        Origin => 'Origin',

#For tracks list
        Tracks => 'Lista de pistas',
        Number => 'Número',
        Track => 'Título',
        Time => 'Tempo',

        Composer => 'Composición',
        Producer => 'Producción',
        Playlist => 'Lista de reproducción',
        Comments => 'Comentarios',
        Label => 'Etiqueta',
        Url => 'Páxina web',

        General => 'Xeral',
        Details => 'Detalles',
     );
}

1;
