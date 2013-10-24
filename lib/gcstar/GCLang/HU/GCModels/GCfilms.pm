{
    package GCLang::HU::GCModels::GCfilms;

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
    
        CollectionDescription => 'Filmgyűjtemény',
        Items => {0 => 'Film',
                  1 => 'Film',
                  X => 'Filmek'},
        NewItem => 'Új film',
    
    
        Id => 'Azonosító',
        Title => 'Cím',
        Date => 'Dátum',
        Time => 'Hossz',
        Director => 'Rendező',
        Country => 'Ország',
        MinimumAge => 'Ajánlott kor',
        Genre => 'Jellemzők',
        Image => 'Kép',
        Original => 'Eredeti cím',
        Actors => 'Szereposztás',
        Actor => 'Színész',
        Role => 'Szerep',
        Comment => 'Megjegyzések',
        Synopsis => 'Összegzés',
        Seen => 'Megnézve',
        Number => '# Média',
        Format => 'Média',
        Region => 'Régió',
        Identifier => 'Azonosító',
        Url => 'Weboldal',
        Audio => 'Hang',
        Video => 'Videó formátum',
        Trailer => 'Videó fájl',
        Serie => 'Sorozatok',
        Rank => 'Értékelés',
        Subtitles => 'Alcímek',

        SeenYes => 'Megnézve',
        SeenNo => 'Nincs megnézve',

        AgeUnrated => 'Nem értékelt',
        AgeAll => 'Korhatár nélkül',
        AgeParent => 'Szülői felügyelettel',

        Main => 'Fő elemek',
        General => 'Általános',
        Details => 'Részletek',

        Information => 'Információ',
        Languages => 'Nyelvek',
        Encoding => 'Kódolás',

        FilterAudienceAge => 'Néző életkora',
        FilterSeenNo => '_Még nem látott',
        FilterSeenYes => '_Már látott',
        FilterRatingSelect => 'Értékelés _legalább...',

        ExtractSize => 'Méret',
     );
}

1;
