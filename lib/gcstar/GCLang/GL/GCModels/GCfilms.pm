{
    package GCLang::GL::GCModels::GCfilms;

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
    
        CollectionDescription => 'Colección de filmes',
        Items => {0 => 'Filme',
                  1 => 'Filme',
                  X => 'Filmes'},
        NewItem => 'Novo filme',
    
    
        Id => 'Id',
        Title => 'Título',
        Date => 'Data',
        Time => 'Duración',
        Director => 'Dirección',
        Country => 'País',
        MinimumAge => 'Idade mínima',
        Genre => 'Xénero',
        Image => 'Imaxe',
        Original => 'Título orixinal',
        Actors => 'Reparto',
        Actor => 'Actor/Actriz',
        Role => 'Papel',
        Comment => 'Comentarios',
        Synopsis => 'Resumo',
        Seen => 'Vista',
        Number => '# de media',
        Format => 'Medio',
        Region => 'Region',
        Identifier => 'Identificador',
        Url => 'Páxina web',
        Audio => 'Audio',
        Video => 'Formato de Video',
        Trailer => 'Ficheiro de video',
        Serie => 'Serie',
        Rank => 'Puntuación',
        Subtitles => 'Subtítulos',

        SeenYes => 'Visto',
        SeenNo => 'Non visto',

        AgeUnrated => 'Sen puntuación',
        AgeAll => 'Para todas as idades',
        AgeParent => 'Guía adulta',

        Main => 'Elementos principais',
        General => 'Xeral',
        Details => 'Detalles',

        Information => 'Información',
        Languages => 'Linguas',
        Encoding => 'Codificación',

        FilterAudienceAge => 'Idade da audiencia',
        FilterSeenNo => '_Non vista polo momento',
        FilterSeenYes => 'X_a vista',
        FilterRatingSelect => 'Puntuada polo menos...',

        ExtractSize => 'Tamaño',
     );
}

1;
