{
    package GCLang::SR::GCModels::GCfilms;

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
    
        CollectionDescription => 'Movies collection',
        Items => 'Filmovi',
        NewItem => 'Novi film',
    
    
        Id => 'Redni broj',
        Title => 'Naslov',
        Date => 'Datum',
        Time => 'Trajanje',
        Director => 'Režiser',
        Country => 'Zemlja',
        MinimumAge => 'Ne za mlađe od',
        Genre => 'Žanr',
        Image => 'Slika',
        Original => 'Naslov originala',
        Actors => 'Uloge',
        Actor => 'Actor',
        Role => 'Role',
        Comment => 'Komentari',
        Synopsis => 'Radnja',
        Seen => 'Pogledan',
        Number => '# medija',
        Format => 'Medij',
        Region => 'Region',
        Identifier => 'Identifier',
        Url => 'Internet',
        Audio => 'Zvuk',
        Video => 'Video format',
        Trailer => 'Video fajl',
        Serie => 'Kolekcija',
        Rank => 'Ocena',
        Subtitles => 'Prevod',

        SeenYes => 'Gledao',
        SeenNo => 'Neodgledan',

        AgeUnrated => 'Neocenjen',
        AgeAll => 'Svi Uzrasti',
        AgeParent => 'Roditeljska Pratnja',

        Main => 'Main items',
        General => 'Opšte',
        Details => 'Detalji',

        Information => 'Informacije',
        Languages => 'Jezici',
        Encoding => 'Kodna strana',

        FilterAudienceAge => 'Uzrast publike',
        FilterSeenNo => '_Negledani',
        FilterSeenYes => '_Already Viewed',
        FilterRatingSelect => 'Ocena _Najmanje...',

        ExtractSize => 'Veličina',
     );
}

1;
