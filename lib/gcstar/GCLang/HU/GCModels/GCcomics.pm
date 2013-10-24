{
    package GCLang::HU::GCModels::GCcomics;

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
    
        CollectionDescription => 'Képregénygyűjtemény',
        Items => {0 => 'Képregények',
                  1 => 'Képregény',
                  X => 'Képregények'},
        NewItem => 'Új képregény',
    
    
        Id => 'Id',
        Name => 'Név',
        Series => 'Sorozatok',
        Volume => 'Kötet',
        Title => 'Cím',
        Writer => 'Író',
        Illustrator => 'Illusztátor',
        Colourist => 'Szinező',
        Publisher => 'Kiadó',
        Synopsis => 'Összegzés',
        Collection => 'Gyűjtemény',
        PublishDate => 'Kiadás dátuma',
        PrintingDate => 'Nyomtatás dátuma',
        ISBN => 'ISBN',
        Type => 'Típus',
		Category => 'Kategória',
        Format => 'Formátum',
        NumberBoards => 'Táblák száma',
		Signing => 'Jelölés',
        Cost => 'Ár',
        Rating => 'Értékelés',
        Comment => 'Megjegyzések',
        Url => 'Weboldal',

        FilterRatingSelect => 'Értékelés _legalább...',

        Main => 'Fő elemek',
        General => 'Általános',
        Details => 'Részletek',
     );
}

1;
