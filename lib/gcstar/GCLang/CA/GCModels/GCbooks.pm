{
    package GCLang::CA::GCModels::GCbooks;

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
    
        CollectionDescription => 'Col·lecció de llibres',
        Items => 'Llibres',
        NewItem => 'Nou llibre',
    
        Isbn => 'ISBN',
        Title => 'Títol',
        Cover => 'Coberta',
        Authors => 'Autors',
        Publisher => 'Editorial',
        Publication => 'Data de publicació',
        Language => 'Idioma',
        Genre => 'Gènere',
        Serie => 'Sèrie',
        Rank => 'Capítol',
        Bookdescription => 'Descripció',
        Pages => 'Pàgines',
        Read => 'Llegit',
        Acquisition => 'Data d\'adquisició',
        Edition => 'Edició',
        Format => 'Format',
        Comments => 'Comentaris',
        Url => 'Pàgina Web',
        Translator => 'Translator',
        Artist => 'Artist',
        DigitalFile => 'Digital version',

        General => 'General',
        Details => 'Detalls',

        ReadNo => 'Sense llegir',
        ReadYes => 'Llegit',
     );
}

1;
