{
    package GCLang::ES::GCModels::GCgeneric;

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
    
        Items => {0 => 'Artículo',
                  1 => 'Artículo',
                  lowercase1 => 'artículo',
                  X => 'Artículos',
                  lowercaseX => 'artículos',
                  P1 => 'el artículo',
                  lowercaseP1 => 'el artículo',
                  U1 => 'Un Artículo',
                  lowercaseU1 => 'un artículo',
                  AP1 => 'Al Artículo',
                  lowercaseAP1 => 'al artículo',
                  DP1 => 'Del Artículo',
                  lowercaseDP1 => 'del artículo',
                  PX => 'Los Artículos',
                  lowercasePX => 'los artículos',
                  E1 => 'Este Artículos',
                  lowercaseE1 => 'este artículo',
                  EX => 'Estos Artículos',
                  lowercaseEX => 'estos artículos'             
                  },        
        
        NewItem => 'Nuevo artículo',
     );
}

1;
