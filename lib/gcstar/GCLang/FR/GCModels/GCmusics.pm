{
    package GCLang::FR::GCModels::GCmusics;

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
    
        CollectionDescription => 'Collection musicale',
        Items => {0 => 'Album',
                  1 => 'Album',
                  X => 'Albums',
                  I1 => 'Un album',
                  D1 => 'L\'album',
                  DX => 'Les albums',
                  DD1 => 'De l\'album',
                  M1 => 'Cet album',
                  C1 => ' album',
                  DA1 => '\'album',
                  DAX => '\'albums'},
        NewItem => 'Nouvel album',
    
        Unique => 'ISRC/EAN',
        Title => 'Titre',
        Cover => 'Pochette',
        Artist => 'Artiste',
        Format => 'Format',
        Running => 'Durée',
        Release => 'Date de sortie',
        Genre => 'Genre',
        Origin => 'Origine',

#For tracks list
        Tracks => 'Pistes',
        Number => 'Numéro',
        Track => 'Titre',
        Time => 'Durée',

        Composer => 'Compositeur',
        Producer => 'Producteur',
        Playlist => 'Liste de lecture',
        Comments => 'Commentaires',
        Label => 'Label',
        Url => 'Page web',

        General => 'Géneral',
        Details => 'Détails',
     );
}

1;
