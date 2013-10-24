{
    package GCLang::ID::GCModels::GCcoins;

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
    
        CollectionDescription => 'Numismatic collection',
        Items => {0 => 'Coin',
                  1 => 'Coin',
                  X => 'Coins'},
        NewItem => 'New coin',

        Name => 'Name',
        Country => 'Country',
        Year => 'Year',
        Currency => 'Currency',
        Value => 'Value',
        Picture => 'Main picture',
        Diameter => 'Diameter',
        Metal => 'Metal',
        Edge => 'Edge',
        Edge1 => 'Edge 1',
        Edge2 => 'Edge 2',
        Edge3 => 'Edge 3',
        Edge4 => 'Edge 4',
        Head => 'Head',
        Tail => 'Tail',
        Comments => 'Comments',
        History => 'History',
        Website => 'Website',
        Estimate => 'Estimate',
        References => 'References',
        Type => 'Type',
        Coin => 'Coin',
        Banknote => 'Bank note',

        Main => 'Main',
        Description => 'Description',
        Other => 'Other information',
        Pictures => 'Pictures',
        
        Condition => 'Condition (PCGS)',
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
