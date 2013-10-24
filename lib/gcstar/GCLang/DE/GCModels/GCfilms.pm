{
    package GCLang::DE::GCModels::GCfilms;

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
    
        CollectionDescription => 'Filmsammlung',
        Items => {0 => 'Film',
                  1 => 'Film',
                  X => 'Filme',
                  },

        NewItem => 'Neuer Film',

        Id => 'Kennung',
        Title => 'Titel',
        Date => 'Datum',
        Time => 'Länge',
        Director => 'Regisseur',
        Country => 'Land',
        MinimumAge => 'Altersfreigabe',
        Genre => 'Genre',
        Image => 'Bild',
        Original => 'Originaltitel',
        Actors => 'Besetzung',
        Actor => 'Schauspieler/in',
        Role => 'Rolle',
        Comment => 'Kommentar',
        Synopsis => 'Beschreibung',
        Seen => 'gesehen',
        Number => '# der Medien',
        Format => 'Format',
        Region => 'Region',
        Identifier => 'Identifier',
        Url => 'Internetseite',
        Audio => 'Audio',
        Video => 'Videoformat',
        Trailer => 'Videodatei',
        Serie => 'Serie',
        Rank => 'Teil/Folge',
        Subtitles => 'Untertitel',

        SeenYes => 'Film bereits gesehen',
        SeenNo => 'Film noch nicht gesehen',

        AgeUnrated => 'Unbewertet',
        AgeAll => 'Ohne Altersbeschränkung',
        AgeParent => '6',

        Main => 'Wichtigste Felder',
        General => 'Allgemein',
        Details => 'Details',

        Information => 'Informationen',
        Languages => 'Sprachen',
        Encoding => 'Kodierung',

        FilterAudienceAge => 'Altersfreigabe',
        FilterSeenNo => 'Noch _nicht gesehen',
        FilterSeenYes => 'Bereits _gesehen',
        FilterRatingSelect => 'Bewertung _mindestens...',

        ExtractSize => 'Größe',
     );
}

1;
