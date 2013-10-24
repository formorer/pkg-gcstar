{
    package GCLang::PL::GCModels::GCfilms;

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
    
        CollectionDescription => 'Filmoteka',
        Items => sub {
          my $number = shift;
          return 'Film' if $number eq '1';
          return 'Filmy' if $number =~ /(?<!1)[2-4]$/;
          return 'Filmów';
        },
        NewItem => 'Nowy film',
    
    
        Id => 'Id',
        Title => 'Tytuł',
        Date => 'Data',
        Time => 'Czas trwania',
        Director => 'Reżyser',
        Country => 'Kraj',
        MinimumAge => 'Minimalny wiek',
        Genre => 'Gatunek',
        Image => 'Obraz',
        Original => 'Oryginalny tytuł',
        Actors => 'Obsada',
        Actor => 'Aktor',
        Role => 'Rola',
        Comment => 'Komentarz',
        Synopsis => 'Opis',
        Seen => 'Oglądany',
        Number => 'Płyt',
        Format => 'Media',
        Region => 'Region',
        Identifier => 'Identyfikator',
        Url => 'Strona internetowa',
        Audio => 'Dźwięk',
        Video => 'Format obrazu',
        Trailer => 'Plik wideo',
        Serie => 'Kolekcja',
        Rank => 'Ranga',
        Subtitles => 'Napisy',

        SeenYes => 'Przeglądane',
        SeenNo => 'Nie przeglądane',

        AgeUnrated => 'Bez ograniczeń wiekowych',
        AgeAll => 'Bez ograniczeń',
        AgeParent => 'Ochrona rodzicielska',

        Main => 'Główne pozycje',
        General => 'Główny',
        Details => 'Szczegóły',

        Information => 'Informacja',
        Languages => 'Języki',
        Encoding => 'Dekodowanie',

        FilterAudienceAge => 'Widownia',
        FilterSeenNo => 'Nie oglądane',
        FilterSeenYes => 'Oglądane',
        FilterRatingSelect => 'Notowanie Większe od...',

        ExtractSize => 'Rozmiar',
     );
}

1;
