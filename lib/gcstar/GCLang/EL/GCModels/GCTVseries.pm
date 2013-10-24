{
    package GCLang::EL::GCModels::GCTVseries;

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
    use GCLang::GCLangUtils;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => 'Συλλογή τηλεοπτικών σειρών',
        Items => {  0 => 'Σειρά',
                    1 => 'Σειρά',
                    X => 'Σειρές',
                    lowercase1 => 'σειρά',
                    lowercaseX => 'σειρές'
                    },
        NewItem => 'Νέα σειρά',
        Name => 'Όνομα',
        Season => 'Σεζόν',
        Part => 'Μέρος',
        Episodes => 'Επισόδεια',
        FirstAired => 'Πρώτη προβολή',
        Time => 'Διάρκεια',
        Producer => 'Παραγωγός',
        Music => 'Μουσική',
     );
     importTranslation('ταινίες');
}

1;
