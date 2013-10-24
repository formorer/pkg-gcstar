{
    package GCLang::CA::GCModels::GCfilms;

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
    
        CollectionDescription => 'Col·lecció de pel·lícules',
        Items => 'Pel·lícules',
        NewItem => 'Nova pel·lícula',
    
    
        Id => 'Id',
        Title => 'Títol',
        Date => 'Data de sortida',
        Time => 'Durada',
        Director => 'Director',
        Country => 'Nacionalitat',
        MinimumAge => 'Edat mínima',
        Genre => 'Gèneres',
        Image => 'Imatge',
        Original => 'Títol original',
        Actors => 'Actors',
        Actor => 'Actor',
        Role => 'Paper',
        Comment => 'Comentaris',
        Synopsis => 'Sinopsi',
        Seen => 'Vista',
        Number => 'Número de suport',
        Format => 'Suport',
        Region => 'Regió',
        Identifier => 'Identificador',
        Url => 'Pàgina web',
        Audio => 'Audio',
        Video => 'Format de vídeo',
        Trailer => 'Fitxer de vídeo',
        Serie => 'Sèrie',
        Rank => 'Capítol',
        Subtitles => 'Subtítols',
        Added => 'Afegida el (data)',

        SeenYes => 'Vista',
        SeenNo => 'Sense veure',

        AgeUnrated => 'Desconeguda',
        AgeAll => 'Cap',
        AgeParent => 'Control patern',

        Main => 'Elements principals',
        General => 'General',
        Details => 'Detalls',
        Lending => 'Préstec',

        Information => 'Informació',
        Languages => 'Idiomes',
        Encoding => 'Codificació',

        FilterAudienceAge => 'Edat mínima',
        FilterSeenNo => '_No vistes',
        FilterSeenYes => '_Vistes',
        FilterRatingSelect => 'Valoració al _menys igual a...',

        ExtractSize => 'Mida',
     );
}

1;
