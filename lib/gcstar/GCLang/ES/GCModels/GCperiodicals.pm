{
    package GCLang::ES::GCModels::GCperiodicals;

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
    
        CollectionDescription => 'Periodicals collection',
        Items => {0 => 'Revista',
                  1 => 'Revista',
                  lowercase1 => 'revista',
                  X => 'Revistas',
                  lowercaseX => 'revistas',
                  P1 => 'La Revista',
                  lowercaseP1 => 'la revista',
                  U1 => 'Una Revista',
                  lowercaseU1 => 'una revista',
                  AP1 => 'A la Revista',
                  lowercaseAP1 => 'a la revista',
                  DP1 => 'De la Revista',
                  lowercaseDP1 => 'de la revista',
                  PX => 'Las Revistas',
                  lowercasePX => 'las revistas',
                  E1 => 'Esta Revista',
                  lowercaseE1 => 'esta revista',
                  EX => 'Estas Revistas',
                  lowercaseEX => 'estas revistas'             
                  },                  
                  
        NewItem => 'Nueva revista',
    
        Title => 'Title',
        Cover => 'Cover',
        Periodical => 'Periodical',
        Number => 'Number',
        Date => 'Date',
        Subject => 'Subject',
        Articles => 'Articles',

        General => 'General',
     );
}

1;
