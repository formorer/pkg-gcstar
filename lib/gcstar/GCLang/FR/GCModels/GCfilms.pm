{
    package GCLang::FR::GCModels::GCfilms;

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
    
        CollectionDescription => 'Collection de films',
        Items => {0 => 'Film',
                  1 => 'Film',
                  X => 'Films',
                  I1 => 'Un film',
                  D1 => 'Le film',
                  DX => 'Les films',
                  DD1 => 'Du film',
                  M1 => 'Ce film',
                  C1 => ' film',
                  DA1 => 'e film',
                  DAX => 'e films'},
        NewItem => 'Nouveau film',
    
    
        Id => 'Id',
        Title => 'Titre',
        Date => 'Date de sortie',
        Time => 'Durée',
        Director => 'Réalisateur',
        Country => 'Nationalité',
        MinimumAge => 'Age minimum',
        Genre => 'Genres',
        Image => 'Image',
        Original => 'Titre original',
        Actors => 'Acteurs',
        Actor => 'Acteur',
        Role => 'Rôle',
        Comment => 'Commentaires',
        Synopsis => 'Synopsis',
        Seen => 'Film déjà vu',
        Number => 'Nombre',
        Format => 'Format',
        Region => 'Région',
        Identifier => 'Identifiant',
        Url => 'Page web',
        Audio => 'Audio',
        Video => 'Format vidéo',
        Trailer => 'Fichier vidéo',
        Serie => 'Série',
        Rank => 'Rang',
        Subtitles => 'Sous-titres',

        SeenYes => 'Vu',
        SeenNo => 'Non vu',

        AgeUnrated => 'Inconnu',
        AgeAll => 'Aucune restriction',
        AgeParent => 'Accord parental',

        Main => 'Principaux éléments',
        General => 'Fiche du film',
        Details => 'Détails',

        Information => 'Informations',
        Languages => 'Langues',
        Encoding => 'Encodage',

        FilterAudienceAge => 'Age du public',
        FilterSeenNo => 'Films _non vus',
        FilterSeenYes => 'Films _déjà vus',
        FilterRatingSelect => 'Notes au moins égales à...',

        ExtractSize => 'Dimensions',
     );
}

1;
