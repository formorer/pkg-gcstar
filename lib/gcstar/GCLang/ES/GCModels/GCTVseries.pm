{
    package GCLang::ES::GCModels::GCTVseries;

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
    
        CollectionDescription => 'Colección de series de television (series)',
        Items => {0 => 'Serie',
                  1 => 'Serie',
                  lowercase1 => 'serie',
                  X => 'Series',
                  lowercaseX => 'series',
                  P1 => 'La Serie',
                  lowercaseP1 => 'la serie',
                  U1 => 'Una Serie',
                  lowercaseU1 => 'una serie',
                  AP1 => 'A La Serie',
                  lowercaseAP1 => 'a la serie',
                  DP1 => 'De la Serie',
                  lowercaseDP1 => 'de la serie',
                  PX => 'Las Series',
                  lowercasePX => 'las series',
                  E1 => 'Esta Serie',
                  lowercaseE1 => 'esta serie',
                  EX => 'Estas Series',
                  lowercaseEX => 'estas series'             
                  },
        NewItem => 'Nueva serie',
        Name => 'Nombre',
        Season => 'Temporada',
        Part => 'Parte',
        Episodes => 'Episodios',
        FirstAired => 'Inicio de emisión',
        Time => 'Duración de episidio',
        Producer => 'Productor',
        Music => 'Música',
     );
     importTranslation('Films');
}

1;
