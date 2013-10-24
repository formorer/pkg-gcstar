{
    package GCLang::PL::GCModels::GCsoftware;

    use utf8;
###################################################
#
#  Copyright 2005-2009 Tian
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
    
        CollectionDescription => 'Kolekcja oprogramowania',
        Items => sub {
          my $number = shift;
          return 'Aplikacja' if $number eq '1';
          return 'Aplikacje' if $number =~ /(?<!1)[2-4]$/;
          return 'Aplikacji';
        },
        NewItem => 'Nowa aplikacja',
    
        Id => 'Id',
        Ean => 'EAN',
        Name => 'Nazwa',
        Platform => 'Platforma',
        Released => 'Data wydania',
        Homepage => 'Strona domowa',		
        Editor => 'Wydawca',
        Developer => 'Autor',
        Category => 'Rodzaj',
        Box => 'Zdjęcie pudełka',
		NumberOfCopies => 'Liczba kopii',
		Price => 'Cena',		
        Case => 'Opakowanie',
        Manual => 'Podręcznik',
        Executable => 'Plik wykonywalny',
        Description => 'Opis',
        License => 'Typ licencji',
		Commercial => 'Komercyjna',
		FreewareNoncommercial => 'Freeware (do użytku niekomercyjnego)',		
		OtherOpenSource => 'Inna Open Source',
		PublicDomain => 'Public Domain',
		OtherLicense => 'Inna',		
		Registration => 'Rejestracja',		
		RegistrationInfo => 'Dane rejestracyjne',		
		RegInfo => 'Dane rejestracyjne',
		RegistrationName => 'Nazwa użytkownika',
		RegistrationNumber => 'Numer rejestracyjny',	
		RegistrationComments => 'Dodatkowe informacje/komentarz',
		PanelRegistration => 'Dane rejestracyjne',		
        Screenshots => 'Galeria',
        Screenshot1 => 'Pierwszy zrzut',
        Screenshot2 => 'Drugi zrzut',
        Comments => 'Opinie',
        Url => 'Strona internetowa',

        General => 'Ogólne',
        Details => 'Szczegóły',
        Information => 'Informacje',

        FilterRatingSelect => 'Ocena co najmniej...',
     );
}

1;
