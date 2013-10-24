{
    package GCLang::FR::GCModels::GCbooks;

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
    
        CollectionDescription => 'Collection de livres',
        Items => {0 => 'Livre',
                  1 => 'Livre',
                  X => 'Livres',
                  I1 => 'Un livre',
                  D1 => 'Le livre',
                  DX => 'Les livres',
                  DD1 => 'Du livre',
                  M1 => 'Ce livre',
                  C1 => ' livre',
                  DA1 => 'e livre',
                  DAX => 'e livres'},
        NewItem => 'Nouveau livre',
    
        Isbn => 'ISBN',
        Title => 'Titre',
        Cover => 'Couverture',
        Authors => 'Auteurs',
        Publisher => 'Editeur',
        Publication => 'Date de publication',
        Language => 'Langue',
        Genre => 'Genres',
        Serie => 'Série',
        Rank => 'Rang',
        Bookdescription => 'Description',
        Pages => 'Pages',
        Read => 'Lu',
        Acquisition => 'Date d\'acquisition',
        Edition => 'Edition',
        Format => 'Format',
        Comments => 'Commentaires',
        Url => 'Page web',
        Translator => 'Traducteur',
        Artist => 'Artiste',
        DigitalFile => 'Digital version',

        General => 'Fiche',
        Details => 'Détails',

        ReadNo => 'Non lu',
        ReadYes => 'Lu',
     );
}

1;
