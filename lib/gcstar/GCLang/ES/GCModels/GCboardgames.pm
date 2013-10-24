{
    package GCLang::ES::GCModels::GCboardgames;

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
    
        CollectionDescription => 'Colección de juegos de mesa',
        Items => {0 => 'Juego',
                  1 => 'Juego',
                  lowercase1 => 'juego',
                  X => 'Juegos',
                  lowercaseX => 'juegos',
                  P1 => 'El Juego',
                  lowercaseP1 => 'el juego',
                  U1 => 'Un Juego',
                  lowercaseU1 => 'un juego',
                  AP1 => 'Al Juego',
                  lowercaseAP1 => 'al juego',
                  DP1 => 'Del Juego',
                  lowercaseDP1 => 'del juego',
                  PX => 'Los Juegos',
                  lowercasePX => 'los juegos',
                  E1 => 'Este Juego',
                  lowercaseE1 => 'este juego',
                  EX => 'Estos Juegos',
                  lowercaseEX => 'estos juegos'             
                  },
        NewItem => 'Nuevo juego',
    
        Id => 'Id',
        Name => 'Nombre',
        Original => 'Nombre original',
        Box => 'Foto de la caja',
        DesignedBy => 'Diseñado por',
        PublishedBy => 'Publicado por',
        Players => 'Número de jugadores',
        PlayingTime => 'Duración del juego',
        SuggestedAge => 'Edades sugeridas',
        Released => 'Fecha de publicación',
        Description => 'Descripción',
        Category => 'Categoría',
        Mechanics => 'Mecánica',
        ExpandedBy => 'Expandido por',
        ExpansionFor => 'Expansión para',
        GameFamily => 'Familia del juego',
        IllustratedBy => 'Ilustrado por',
        Url => 'Página web',
        TimesPlayed => 'Veces jugado',
        CompleteContents => 'Contenido completo',
        Copies => 'Número de copias',
        Condition => 'Condición',
        Photos => 'Fotos',
        Photo1 => 'Primera foto',
        Photo2 => 'Segunda foto',
        Photo3 => 'Tercera foto',
        Photo4 => 'Cuarta foto',
        Comments => 'Comentarios',

        Perfect => 'Perfecto',
        Good => 'Bien',
        Average => 'Normal',
        Poor => 'Mal',

        CompleteYes => 'Contenido completo',
        CompleteNo => 'Faltan piezas',

        General => 'General',
        Details => 'Detalles',
        Personal => 'Personal',
        Information => 'Información',

        FilterRatingSelect => 'Puntuación al _menos...',
     );
}

1;
