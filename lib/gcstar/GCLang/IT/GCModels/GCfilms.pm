{
    package GCLang::IT::GCModels::GCfilms;

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
#######################################################
#
#  v1.0.2 - Italian localization by Andreas Troschka
#
#  for GCstar v1.1.1
#
#######################################################
#
    
    use strict;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => 'Filmoteca',
        Items => {0 => 'Film',
                  1 => 'Film',
                  X => 'Film'},
        NewItem => 'Nuovo film',
    
        Id => 'Id',
        Title => 'Titolo',
        Date => 'Data',
        Time => 'Durata',
        Director => 'Regista',
        Country => 'Nazione',
        MinimumAge => 'Eta\' minima',
        Genre => 'Genere',
        Image => 'Immagine',
        Original => 'Titolo originale',
        Actors => 'Cast',
        Actor => 'Actor',
        Role => 'Role',
        Comment => 'Commento',
        Synopsis => 'Trama',
        Seen => 'Gia\' visto',
        Number => 'Numero',
        Format => 'Tipo',
        Region => 'Region',
        Identifier => 'Identifier',
        Url => 'URL',
        Audio => 'Audio',
        Video => 'Video',
        Trailer => 'Trailer',
        Serie => 'Serie',
        Rank => 'Rank',
        Subtitles => 'Sottotitoli',

        SeenYes => 'Gia\' visto',
        SeenNo => 'Non visto',

        AgeUnrated => 'Sconosciuta',
        AgeAll => 'Nessuna',
        AgeParent => 'V.m.',

        Main => 'Oggetti principali',
        General => 'Informazioni film',
        Details => 'Dettagli',

        Information => 'Informazioni',
        Languages => 'Lingua',
        Encoding => 'Codifica',

        FilterAudienceAge => 'Eta\' pubblico',
        FilterSeenNo => '_Non visto',
        FilterSeenYes => '_Gia\' visto',
        FilterRatingSelect => 'Valutazione maggiore di...',

        ExtractSize => 'Dimensione',
     );
}

1;
