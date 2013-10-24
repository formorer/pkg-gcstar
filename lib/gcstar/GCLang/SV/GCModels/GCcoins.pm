{
    package GCLang::SV::GCModels::GCcoins;

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
    
        CollectionDescription => 'Myntsamling',
        Items => 'Mynt',
        NewItem => 'Nytt mynt',

        Name => 'Namn',
        Country => 'Land',
        Year => 'År',
        Currency => 'Valuta',
        Value => 'Värde',
        Picture => 'Huvudbild',
        Diameter => 'Diameter',
        Metal => 'Metall',
        Edge => 'Kant',
        Edge1 => 'Kant 1',
        Edge2 => 'Kant 2',
        Edge3 => 'Kant 3',
        Edge4 => 'Kant 4',
        Head => 'Huvud',
        Tail => 'Baksida',
        Comments => 'Kommentarer',
        History => 'Historik',
        Website => 'Hemsida',
        Estimate => 'Bedömning',
        References => 'Referenser',
        Type => 'Typ',
        Coin => 'Mynt',
        Banknote => 'Banknotering',

        Main => 'Huvud',
        Description => 'Beskrivning',
        Other => 'Övrig information',
        Pictures => 'Bilder',
        
        Condition => 'Tillstånd (PCGS)',
        Grade1  => 'BS-1',
        Grade2  => 'FR-2',
        Grade3  => 'AG-3',
        Grade4  => 'G-4',
        Grade6  => 'G-6',
        Grade8  => 'VG-8',
        Grade10 => 'VG-10',
        Grade12 => 'F-12',
        Grade15 => 'F-15',
        Grade20 => 'VF-20',
        Grade25 => 'VF-25',
        Grade30 => 'VF-30',
        Grade35 => 'VF-35',
        Grade40 => 'XF-40',
        Grade45 => 'XF-45',
        Grade50 => 'AU-50',
        Grade53 => 'AU-53',
        Grade55 => 'AU-55',
        Grade58 => 'AU-58',
        Grade60 => 'MS-60',
        Grade61 => 'MS-61',
        Grade62 => 'MS-62',
        Grade63 => 'MS-63',
        Grade64 => 'MS-64',
        Grade65 => 'MS-65',
        Grade66 => 'MS-66',
        Grade67 => 'MS-67',
        Grade68 => 'MS-68',
        Grade69 => 'MS-69',
        Grade70 => 'MS-70',
    
     );
}

1;
