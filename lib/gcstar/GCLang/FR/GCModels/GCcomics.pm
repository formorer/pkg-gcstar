{
    package GCLang::FR::GCModels::GCcomics;

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

        CollectionDescription => 'Collection de Bandes Dessinées',
        Items => {0 => 'Bandes Dessinées',
                  1 => 'Bande Dessinée',
                  X => 'Bandes Dessinées',
                  I1 => 'Une bande dessinée',
                  D1 => 'La bande dessinée',
                  DX => 'Les bandes dessinées',
                  DD1 => 'De la bande dessinée',
                  M1 => 'Cette bande dessinée',
                  C1 => 'e bande dessinée',
                  DA1 => 'e bande dessinée',
                  DAX => 'e bandes dessinées'},
        NewItem => 'Nouvelle BD',


        Id => 'Id',
        Name => 'Nom',
        Series => 'Série',
        Volume => 'Tome',
        Title => 'Titre',
        Writer => 'Scénariste',
        Illustrator => 'Dessinateur',
        Colourist => 'Coloriste',
        Publisher => 'Editeur',
        Synopsis => 'Résumé',
        Collection => 'Collection',
        PublishDate => 'Dépot Légal',
        PrintingDate => 'Date d\'impression',
        ISBN => 'ISBN',
        Type => 'Type',
		Category => 'Catégorie',
        Format => 'Format',
        NumberBoards => 'Nombre de planches',
		Signing => 'Dédicace',
        Cost => 'Cote',
        Rating => 'Note',
        Comment => 'Commentaires',
        Url => 'Page Web',

        FilterRatingSelect => 'Notes au _moins egales à...',

        Main => 'Principaux éléments',
        General => 'Général',
        Details => 'Détails',
     );
}

1;
