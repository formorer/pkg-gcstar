{
    package GCLang::ES::GCModels::GCmusics;

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
        Items => {0 => 'Álbum',
                  1 => 'Álbum',
                  lowercase1 => 'Álbum',
                  X => 'Álbumes',
                  lowercaseX => 'álbumes',
                  P1 => 'El Álbum',
                  lowercaseP1 => 'el álbum',
                  U1 => 'Un Álbum',
                  lowercaseU1 => 'un álbum',
                  AP1 => 'Al Álbum',
                  lowercaseAP1 => 'al álbum',
                  DP1 => 'Del Álbum',
                  lowercaseDP1 => 'del álbum',
                  PX => 'Los Álbumes',
                  lowercasePX => 'los álbumes',
                  E1 => 'Este Álbum',
                  lowercaseE1 => 'este álbum ',
                  EX => 'Estos Álbumes',
                  lowercaseEX => 'estos álbumes'             
                  },
        NewItem => 'Álbum nuevo',
    
        Unique => 'ISRC/EAN',
        Title => 'Título',
        Cover => 'Portada',
        Artist => 'Artista',
        Format => 'Formato',
        Running => 'Duración',
        Release => 'Fecha de publicación',
        Genre => 'Género',
        Origin => 'Origen',

#For tracks list
        Tracks => 'Lista de canciones',
        Number => 'Número',
        Track => 'Título',
        Time => 'Duración',

        Composer => 'Compositor',
        Producer => 'Productor',
        Playlist => 'Lista de reproducción',
        Comments => 'Comentarios',
        Label => 'Discográfica',
        Url => 'Página web',

        General => 'General',
        Details => 'Detalles',
     );
}

1;
