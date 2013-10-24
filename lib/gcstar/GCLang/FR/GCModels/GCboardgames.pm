{
    package GCLang::FR::GCModels::GCboardgames;

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
    
        CollectionDescription => 'Collection de jeux de société',
        Items => {0 => 'Jeu',
                  1 => 'Jeu',
                  X => 'Jeux',
                  I1 => 'Un jeu',
                  D1 => 'Le jeu',
                  DX => 'Les jeux',
                  DD1 => 'Du jeu',
                  M1 => 'Ce jeu',
                  C1 => ' jeu',
                  DA1 => 'e jeu',
                  DAX => 'e jeux'},
        NewItem => 'Nouveau jeu',
    
        Id => 'Id',
        Name => 'Nom',
        Original => 'Nom original',
        Box => 'Image de la boîte',
        DesignedBy => 'Auteur(s)',
        PublishedBy => 'Éditeur',
        Players => 'Nombre de joueurs',
        PlayingTime => 'Durée d\'une partie',
        SuggestedAge => 'Age suggéré',
        Released => 'Date de sortie',
        Description => 'Description',
        Category => 'Thème(s)',
        Mechanics => 'Mécanisme(s)',
        ExpandedBy => 'Extension(s) existante(s)',
        ExpansionFor => 'Extension de',
        GameFamily => 'Famille du jeu',
		IllustratedBy => 'Illustrateur(s)',
        Url => 'Page web',
        TimesPlayed => 'Nombre de parties jouées',
        CompleteContents => 'Contenu complet',
        Copies => 'Nombre d\'exemplaire(s)',        
        Condition => 'État',
        Photos => 'Images',
        Photo1 => 'Première image',
        Photo2 => 'Deuxième image',
        Photo3 => 'Troisième image',
        Photo4 => 'Quatrième image',
        Comments => 'Commentaires',

        Perfect => 'Parfait',
        Good => 'Bon',
        Average => 'Moyen',
        Poor => 'Mauvais',

        CompleteYes => 'Contenu complet',
        CompleteNo => 'Pièces manquantes',

        General => 'Général',
        Details => 'Détails',
        Personal => 'Personnel',
        Information => 'Informations',

        FilterRatingSelect => '_Notes au moins égales à...',
     );
}

1;
