{
    package GCLang::PL::GCModels::GCbooks;

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
    
        CollectionDescription => 'Księgozbiór',
        Items => sub {
          my $number = shift;
          return 'Książka' if $number eq '1';
          return 'Książki' if $number =~ /(?<!1)[2-4]$/;
          return 'Książek';
        },
        NewItem => 'Nowa książka',
    
        Isbn => 'ISBN',
        Title => 'Tytuł',
        Cover => 'Okładka',
        Authors => 'Autor',
        Publisher => 'Wydawca',
        Publication => 'Data wydania',
        Language => 'Język',
        Genre => 'Gatunek',
        Serie => 'Seria',
        Rank => 'Ranga',
        Bookdescription => 'Opis',
        Pages => 'Stron',
        Read => 'Przeczytana',
        Acquisition => 'Data pozyskania',
        Edition => 'Wydanie',
        Format => 'Oprawa',
        Comments => 'Komentarze',
        Url => 'Strona internetowa',
        Translator => 'Tłumaczenie',
        Artist => 'Ilustrator',
        DigitalFile => 'Digital version',

        General => 'Ogólne',
        Details => 'Szczegóły',

        ReadNo => 'Nieczytana',
        ReadYes => 'Czytana',
     );
}

1;
