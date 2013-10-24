{
    package GCLang::SV::GCModels::GCfilms;

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
    
        CollectionDescription => 'Filmsamling',
        Items => 'Filmer',
        NewItem => 'Ny film',
    
    
        Id => 'Id',
        Title => 'Titel',
        Date => 'Datum',
        Time => 'Längd',
        Director => 'Regissör',
        Country => 'Land',
        MinimumAge => 'Åldersgräns',
        Genre => 'Genre',
        Image => 'Bild',
        Original => 'Original titel',
        Actors => 'Roller',
        Actor => 'Skådespelare',
        Role => 'Roll',
        Comment => 'Kommentarer',
        Synopsis => 'Synopsis',
        Seen => 'Visad',
        Number => '# av Media',
        Format => 'Media',
        Region => 'Region',
        Identifier => 'Identifierare',
        Url => 'Hemsida',
        Audio => 'Ljud',
        Video => 'Videoformat',
        Trailer => 'Videofil',
        Serie => 'Serie',
        Rank => 'Grad',
        Subtitles => 'Undertexter',

        SeenYes => 'Visad',
        SeenNo => 'Ej visad',

        AgeUnrated => 'Ej betygsatt',
        AgeAll => 'Alla Åldrar',
        AgeParent => 'Åldersgräns',

        Main => 'Huvudartiklar',
        General => 'Allmänt',
        Details => 'Detaljer',

        Information => 'Information',
        Languages => 'Språk',
        Encoding => 'Kodning',

        FilterAudienceAge => 'Publik ålder',
        FilterSeenNo => '_Ännu ej visad',
        FilterSeenYes => '_Redan visad',
        FilterRatingSelect => 'Betyg _Åtminstone...',

        ExtractSize => 'Storlek',
     );
}

1;
