{
    package GCLang::CS::GCModels::GCfilms;

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
    
        CollectionDescription => 'Sbírka filmů',
        Items => sub {
          my $number = shift;
          return 'Film' if $number eq '1';
          return 'Filmy' if $number =~ /(?<!1)[2-4]$/;
          return 'Filmů';
        },
        NewItem => 'Nový film',
    
    
        Id => 'Id',
        Title => 'Název',
        Date => 'Datum',
        Time => 'Délka',
        Director => 'Režie',
        Country => 'Země',
        MinimumAge => 'Věk',
        Genre => 'Žánr',
        Image => 'Obrázek',
        Original => 'Původní název',
        Actors => 'Obsazení',
        Actor => 'Actor',
        Role => 'Role',
        Comment => 'Komentář',
        Synopsis => 'Anotace',
        Seen => 'Shlédnuto',
        Number => 'Počet médií',
        Format => 'Medium',
        Region => 'Region',
        Identifier => 'Identifikátor',
        Url => 'Web',
        Audio => 'Zvuk',
        Video => 'Video formát',
        Trailer => 'Soubor s filmem',
        Serie => 'Sbírka',
        Rank => 'Pořadí',
        Subtitles => 'Titulky',

        SeenYes => 'Shlédnuto',
        SeenNo => 'Neshlédnuto',

        AgeUnrated => 'Nestanoven',
        AgeAll => 'Pro všechny',
        AgeParent => 'Pod dozorem rodičů',

        Main => 'Hlavní položky',
        General => 'Hlavní',
        Details => 'Detaily',

        Information => 'Informace',
        Languages => 'Jazyky',
        Encoding => 'Kódování',

        FilterAudienceAge => 'Věk diváka',
        FilterSeenNo => '_Neshlédnuté filmy',
        FilterSeenYes => '_Shlédnuté filmy',
        FilterRatingSelect => '_Hodnocení minimálně...',

        ExtractSize => 'Velikost',
     );
}

1;
