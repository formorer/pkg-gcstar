{
    package GCLang::PL::GCModels::GCboardgames;

    use utf8;
###################################################
#
#  Copyright 2005-2010 Christian Jodar, WG
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

        CollectionDescription => 'Kolekcja gier planszowych',
        Items => sub {
          my $number = shift;
          return 'Gra' if $number eq '1';
          return 'Gry' if $number =~ /(?<!1)[2-4]$/;
          return 'Gier';
        },
        NewItem => 'Nowa gra',

        Id => 'Id',
        Name => 'Nazwa',
        Original => 'Nazwa oryginału',
        Box => 'Zdjęcie pudełka',
        DesignedBy => 'Autor',
        PublishedBy => 'Wydawca',
        Players => 'Ilość graczy',
        PlayingTime => 'Czas gry',
        SuggestedAge => 'Zalecany wiek graczy',
        Released => 'Data wydania',
        Description => 'Opis',
        Category => 'Kategoria',
        Mechanics => 'Mechanika gry',
        ExpandedBy => 'Dodatki',
        ExpansionFor => 'Dodatek do',
        GameFamily => 'Rodzina gier',
        IllustratedBy => 'Opracowanie graficzne',
        Url => 'Strona internetowa',
        TimesPlayed => 'Czas spędzony na grze',
        CompleteContents => 'Kompletna',
        Copies => 'Ilość egzemplarzy',
        Condition => 'Stan',
        Photos => 'Zdjęcia',
        Photo1 => 'Zdjęcie pierwsze',
        Photo2 => 'Zdjęcie drugie',
        Photo3 => 'Zdjęcie trzecie',
        Photo4 => 'Zdjęcie czwarte',
        Comments => 'Opinie',

        Perfect => 'Doskonały',
        Good => 'Dobry',
        Average => 'Znośny',
        Poor => 'Zły',

        CompleteYes => 'Zawartość kompletna',
        CompleteNo => 'Brakuje elementów',

        General => 'Ogólne',
        Details => 'Szczegóły',
        Personal => 'Osobiste',
        Information => 'Informacje',

        FilterRatingSelect => 'Ocena co najmniej...',
     );
}

1;
