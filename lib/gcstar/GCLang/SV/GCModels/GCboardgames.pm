{
    package GCLang::SV::GCModels::GCboardgames;

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
    
        CollectionDescription => 'Brädspelssamling',
        Items => {0 => 'Spel',
                  1 => 'Spel',
                  X => 'Spel'},
        NewItem => 'Nytt spel',
    
        Id => 'Id',
        Name => 'Namn',
        Original => 'Original namn',
        Box => 'Omslagsbild',
        DesignedBy => 'Designad av',
        PublishedBy => 'Utgiven av',
        Players => 'Antal spelare',
        PlayingTime => 'Speltid',
        SuggestedAge => 'Rekommenderad ålder',
        Released => 'Utgiven',
        Description => 'Beskrivning',
        Category => 'Kategori',
        Mechanics => 'Mekanik',
        ExpandedBy => 'Expanderad av',
        ExpansionFor => 'Expansion för',
        GameFamily => 'Spelfamilj',
        IllustratedBy => 'Illustrerad av',
        Url => 'Hemsida',
        TimesPlayed => 'Antal spelade sessioner',
        CompleteContents => 'Komplett innehåll',
        Copies => 'Antal exemplar',
        Condition => 'Skick',
        Photos => 'Bilder',
        Photo1 => 'Första bild',
        Photo2 => 'Andra bild',
        Photo3 => 'Tredje bild',
        Photo4 => 'Fjärde bild',
        Comments => 'Kommentarer',

        Perfect => 'Perfekt',
        Good => 'Bra',
        Average => 'Medel',
        Poor => 'Undermålig',

        CompleteYes => 'Komplett innehåll',
        CompleteNo => 'Saknade delar',

        General => 'Allmänt',
        Details => 'Detaljer',
        Personal => 'Personligt',
        Information => 'Information',

        FilterRatingSelect => 'Betyg _Åtminstone...',
     );
}

1;
