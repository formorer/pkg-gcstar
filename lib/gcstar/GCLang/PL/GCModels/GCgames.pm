{
    package GCLang::PL::GCModels::GCgames;

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
    
        CollectionDescription => 'Kolekcja gier',
        Items => sub {
          my $number = shift;
          return 'Gra' if $number eq '1';
          return 'Gry' if $number =~ /(?<!1)[2-4]$/;
          return 'Gier';
        },
        NewItem => 'Nowa gra',
    
        Id => 'Id',
        Ean => 'EAN',
        Name => 'Nazwa',
        Platform => 'Platforma',
        Players => 'Ilość graczy',
        Released => 'Data wydania',
        Editor => 'Wydawca',
        Developer => 'Twórca',
        Genre => 'Gatunek',
        Box => 'Zdjęcie pudełka',
        Case => 'Opakowanie',
        Manual => 'Podręcznik',
        Completion => 'Zaawansowanie (%)',
        Executable => 'Executable',
        Description => 'Opis',
        Codes => 'Kody',
        Code => 'Kod',
        Effect => 'Efekt',
        Secrets => 'Podpowiedzi',
        Screenshots => 'Galeria',
        Screenshot1 => 'Pierwsza zrzutka',
        Screenshot2 => 'Druga zrzutka',
        Comments => 'Opinie',
        Url => 'Strona internetowa',
        Unlockables => 'Da się odblokować...',
        Unlockable => 'Do odblokowania',
        Howto => 'Jak to zrobić',
        Exclusive => 'Exclusive',
        Resolutions => 'Display resolutions',
        InstallationSize => 'Size',
        Region => 'Region',
        SerialNumber => 'Serial Number',        

        General => 'Ogólne',
        Details => 'Szczegóły',
        Tips => 'Tipsy',
        Information => 'Informacje',

        FilterRatingSelect => 'Ocena co najmniej...',
     );
}

1;
