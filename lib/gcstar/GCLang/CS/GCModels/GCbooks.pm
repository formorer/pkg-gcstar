{
    package GCLang::CS::GCModels::GCbooks;

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
    
        CollectionDescription => 'Sbírka knih',
        Items => sub {
          my $number = shift;
          return 'Kniha' if $number eq '1';
          return 'Knihy' if $number =~ /(?<!1)[2-4]$/;
          return 'Knih';
        },
        NewItem => 'Nová kniha',
    
        Isbn => 'ISBN',
        Title => 'Název',
        Cover => 'Obal',
        Authors => 'Autoři',
        Publisher => 'Vydavatel',
        Publication => 'Datum vydání',
        Language => 'Jazyk',
        Genre => 'Žánr',
        Serie => 'Sbírka',
        Rank => 'Pořadí',
        Bookdescription => 'Popis',
        Pages => 'Počet stran',
        Read => 'Přečteno',
        Acquisition => 'Datum pořízení',
        Edition => 'Náklad',
        Format => 'Rozměr',
        Comments => 'Poznámky',
        Url => 'Web',
        Translator => 'Překladatel',
        Artist => 'Ilustrace',
        DigitalFile => 'Digital version',

        General => 'Hlavní',
        Details => 'Detaily',

        ReadNo => 'Nepřečteno',
        ReadYes => 'Přečteno',
     );
}

1;
