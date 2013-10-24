{
    package GCLang::ES::GCModels::GCfilms;

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
    
        CollectionDescription => 'Colección de películas',
        Items => {0 => 'Película',
                  1 => 'Película',
                  lowercase1 => 'película',
                  X => 'Películas',
                  lowercaseX => 'películas',
                  P1 => 'La Película',
                  lowercaseP1 => 'la película',
                  U1 => 'Una Película',
                  lowercaseU1 => 'una película',
                  AP1 => 'A la Película',
                  lowercaseAP1 => 'a la película',
                  DP1 => 'De la Película',
                  lowercaseDP1 => 'de la película',
                  PX => 'Las Películas',
                  lowercasePX => 'las películas',
                  E1 => 'Esta Película',
                  lowercaseE1 => 'esta película',
                  EX => 'Estas Películas',
                  lowercaseEX => 'estas películas'             
                  },        
        
        NewItem => 'Nueva película',
    
    
        Id => 'Id',
        Title => 'Título',
        Date => 'Fecha de salida',
        Time => 'Duración',
        Director => 'Director',
        Country => 'Nacionalidad',
        MinimumAge => 'Edad mínima',
        Genre => 'Géneros',
        Image => 'Imagen',
        Original => 'Título original',
        Actors => 'Actores',
        Actor => 'Actor',
        Role => 'Papel',
        Comment => 'Comentarios',
        Synopsis => 'Sinopsis',
        Seen => 'Ya vista',
        Number => 'Número',
        Format => 'Soporte',
        Region => 'Región',
        Identifier => 'Identificador',
        Url => 'URL',
        Audio => 'Audio',
        Video => 'Formato de video',
        Trailer => 'Fichero de video',
        Serie => 'Serie',
        Rank => 'Capítulo',
        Subtitles => 'Subtítulos',

        SeenYes => 'Película ya vista',
        SeenNo => 'Película no vista',

        AgeUnrated => 'Desconocida',
        AgeAll => 'Ninguna',
        AgeParent => 'Control paterno',

        Main => 'Elementos principales',
        General => 'Ficha de la película',
        Details => 'Información personal',
        Lending => 'Préstamo',

        Information => 'Informacion',
        Languages => 'Idiomas',
        Encoding => 'Codificación',

        FilterAudienceAge => 'Edad mínima',
        FilterSeenNo => 'Películas no vistas',
        FilterSeenYes => '_Ya vista',
        FilterRatingSelect => 'Puntuación al _menos...',

        ExtractSize => 'Tamaño',
     );
}

1;
