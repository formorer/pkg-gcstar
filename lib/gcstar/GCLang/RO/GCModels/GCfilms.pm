{
    package GCLang::RO::GCModels::GCfilms;

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
    
        CollectionDescription => 'Colecţie filme',
        Items => 'Filme',
        NewItem => 'Film nou',
    
    
        Id => 'Id',
        Title => 'Titlu',
        Date => 'Dată',
        Time => 'Durată',
        Director => 'Regizor',
        Country => 'Ţară',
        MinimumAge => 'Vârstă minimă',
        Genre => 'Gen',
        Image => 'Imagine',
        Original => 'Titlu original',
        Actors => 'Distribuţie',
        Actor => 'Actor',
        Role => 'Role',
        Comment => 'Comentarii',
        Synopsis => 'Rezumat',
        Seen => 'Vizionat',
        Number => 'Numărul',
        Format => 'Mediu',
        Region => 'Region',
        Identifier => 'Identificator',
        Url => 'Web',
        Audio => 'Audio',
        Video => 'Format video',
        Trailer => 'Fişier video',
        Serie => 'Colecţie',
        Rank => 'Poziţie',
        Subtitles => 'Subtitrări',

        SeenYes => 'Vizionat',
        SeenNo => 'Nevizionat',

        AgeUnrated => 'Neevaluat',
        AgeAll => 'Toate vârstele',
        AgeParent => 'Acord parental',

        Main => 'Elemente principale',
        General => 'General',
        Details => 'Detalii',

        Information => 'Informaţii',
        Languages => 'Limbi',
        Encoding => 'Codare',

        FilterAudienceAge => 'Vârstă public',
        FilterSeenNo => '_Nevizionat',
        FilterSeenYes => '_Deja vizionat',
        FilterRatingSelect => 'Evaluat la cel _puţin...',

        ExtractSize => 'Mărime',
     );
}

1;
