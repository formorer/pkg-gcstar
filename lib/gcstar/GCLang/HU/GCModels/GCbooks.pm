{
    package GCLang::HU::GCModels::GCbooks;

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
    
        CollectionDescription => 'Könyvgyűjtemény',
        Items => {0 => 'Könyv',
                  1 => 'Könyv',
                  X => 'Könyvek'},
        NewItem => 'Új könyv',
    
        Isbn => 'ISBN',
        Title => 'Cím',
        Cover => 'Borító',
        Authors => 'Szerzők',
        Publisher => 'Kiadó',
        Publication => 'Kiadás dátuma',
        Language => 'Nyelv',
        Genre => 'Jellemzők',
        Serie => 'Sorozatok',
        Rank => 'Értékelés',
        Bookdescription => 'Leírás',
        Pages => 'Oldalak',
        Read => 'Olvasva',
        Acquisition => 'Bekerülés dátuma',
        Edition => 'Kiadás',
        Format => 'Formátum',
        Comments => 'Megjegyzések',
        Url => 'Weboldal',
        Translator => 'Fordító',
        Artist => 'Illusztrátor',
        DigitalFile => 'Digital version',

        General => 'Általános',
        Details => 'Részletek',

        ReadNo => 'Nem olvasott',
        ReadYes => 'Olvasott',
     );
}

1;
