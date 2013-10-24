{
    package GCLang::ES::GCModels::GCTVepisodes;

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
    
        CollectionDescription => 'Colección de series de televisión (episodios)',
        Items => {0 => 'Episodio',
                  1 => 'Episodio',
                  lowercase1 => 'episodio',
                  X => 'Episodios',
                  lowercaseX => 'episodios',
                  P1 => 'El Episodio',
                  lowercaseP1 => 'el episodio',
                  U1 => 'Un Episodio',
                  lowercaseU1 => 'un episodio',
                  AP1 => 'Al Episodio',
                  lowercaseAP1 => 'al episodio',
                  DP1 => 'Del Episodio',
                  lowercaseDP1 => 'del episodio',
                  PX => 'Los Episodios',
                  lowercasePX => 'los episodios',
                  E1 => 'Este Episodio',
                  lowercaseE1 => 'este episodio',
                  EX => 'Estos Episodios',
                  lowercaseEX => 'estos episodios'             
                  },
        NewItem => 'Episodio nuevo',
        NewSeries => 'Nueva serie',
        Episode => 'Episodio',
    );
    # Both of them are required as importTranslation doesn't recurse
    importTranslation('films');
    importTranslation('TVseries');
}

1;
