{
    package GCLang::PL::GCModels::GCwines;

    use utf8;
###################################################
#
#  Copyright 2007 Yves Martin, WG
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

        CollectionDescription => 'Kolekcja win',
        Items => sub {
          my $number = shift;
          return 'Wino' if $number eq '1';
          return 'Wina' if $number =~ /(?<!1)[2-4]$/;
          return 'Win';
        },
        NewItem => 'Nowe wino',

        Name => 'Nazwa',
        Designation => 'Apelacja',
        Vintage => 'Rocznik',
        Vineyard => 'Winnica',
        Type => 'Typ',
        Grapes => 'Grona',
        Soil => 'Gleba',
        Producer => 'Producent',
        Country => 'Kraj',
        Volume => 'Pojemność (ml)',
        Alcohol => 'Alkohol (%)',
        Medal => 'Medale/Wyróżnienia',

        Storage => 'Przechowywanie',
        Location => 'Miejsce',
        ShelfIndex => 'Identyfikator',
        Quantity => 'Ilość',
        Acquisition => 'Pozyskanie',
        PurchaseDate => 'Data zakupu',
        PurchasePrice => 'Cena zakupu',
        Gift => 'Prezent',
        BottleLabel => 'Etykieta',
        Website => 'Strona internetowa',

        Tasted => 'Degustowane',
        Comments => 'Opinie',
        Serving => 'Podawanie',
        TastingField => 'Opis smakowy',

        General => 'Ogólne',
        Details => 'Szczegóły',
        Tasting => 'Degustacja',

        TastedNo => 'Nie degustowane',
        TastedYes => 'Degustowane',

        FilterRange => 'Wybór',
        FilterTastedNo => 'Jeszcze nie degustowane',
        FilterTastedYes => 'Już degustowane',
        FilterRatingSelect => 'Ocena co najmniej...'

     );
}

1;
