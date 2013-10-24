{
    package GCLang::PT::GCModels::GCfilms;

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
    
        CollectionDescription => 'Coleção de filmes',
        Items => 'Filmes',
        NewItem => 'Novo filme',
    
    
        Id => 'Id',
        Title => 'Título',
        Date => 'Data',
        Time => 'Duração',
        Director => 'Diretor',
        Country => 'País',
        MinimumAge => 'Censura',
        Genre => 'Gênero',
        Image => 'Imagem',
        Original => 'Título original',
        Actors => 'Elenco',
        Actor => 'Actor',
        Role => 'Role',
        Comment => 'Comentários',
        Synopsis => 'Sinopse',
        Seen => 'Visto',
        Number => 'N° da mídia',
        Format => 'Formato',
        Region => 'Region',
        Identifier => 'Identifier',
        Url => 'Página da Web',
        Audio => 'Áudio',
        Video => 'Formato do vídeo',
        Trailer => 'Arquivo de vídeo',
        Serie => 'Série',
        Rank => 'Ranking',
        Subtitles => 'Lengendas',

        SeenYes => 'Visto',
        SeenNo => 'Não visto',

        AgeUnrated => 'Desconhecida',
        AgeAll => 'Livre',
        AgeParent => 'Controle dos pais',

        Main => 'Itens principais',
        General => 'Geral',
        Details => 'Detalhes',
        Lending => 'Empréstimo',

        Information => 'Informação',
        Languages => 'Línguas',
        Encoding => 'Codificação',

        FilterAudienceAge => 'Idade mínima',
        FilterSeenNo => '_Não visto ainda',
        FilterSeenYes => '_Já visto',
        FilterRatingSelect => 'Nota _mínima...',

        ExtractSize => 'Tamanho',
     );
}

1;
