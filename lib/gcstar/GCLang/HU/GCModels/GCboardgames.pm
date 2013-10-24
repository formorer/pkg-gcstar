{
    package GCLang::HU::GCModels::GCboardgames;

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
    
        CollectionDescription => 'Táblajáték gyűjtemény',
        Items => {0 => 'Játék',
                  1 => 'Játék',
                  X => 'Játékok'},
        NewItem => 'Új játék',
    
        Id => 'Azonosító',
        Name => 'Név',
        Original => 'Eredeti név',
        Box => 'Borító kép',
        DesignedBy => 'Tervezte',
        PublishedBy => 'Kiadta',
        Players => 'Játékosok száma',
        PlayingTime => 'Játékidő',
        SuggestedAge => 'Ajánlott kor',
        Released => 'Kiadás',
        Description => 'Leírás',
        Category => 'Kategória',
        Mechanics => 'Mechanizmusok',
        ExpandedBy => 'Fejlesztő',
        ExpansionFor => 'Fejlesztés',
        GameFamily => 'Játékcsalád',
        IllustratedBy => 'Illusztráló',
        Url => 'Weboldal',
        TimesPlayed => 'Játékok száma',
        CompleteContents => 'Teljes részek',
        Copies => 'Másolatok száma',
        Condition => 'Állapot',
        Photos => 'Fényképek',
        Photo1 => 'Első kép',
        Photo2 => 'Második kép',
        Photo3 => 'Harmadik kép',
        Photo4 => 'Negyedik kép',
        Comments => 'Megjegyzések',

        Perfect => 'Kiváló',
        Good => 'Jó',
        Average => 'Átlagos',
        Poor => 'Szegényes',

        CompleteYes => 'Teljes részek',
        CompleteNo => 'Hiányzó részek',

        General => 'Általános',
        Details => 'Részletek',
        Personal => 'Személyes',
        Information => 'Információ',

        FilterRatingSelect => 'Értékelés _legalább...',
     );
}

1;
