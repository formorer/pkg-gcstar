{
    package GCLang::FR::GCModels::GCminicars;

    use utf8;
###################################################
#
#  Copyright 2005-2007 Tian
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
    
        CollectionDescription => 'Collection de Véhicules Miniatures',
        Items => {0 => 'Miniature',
                  1 => 'Miniature',
                  X => 'Miniatures',
                  I1 => 'Une miniature',
                  D1 => 'La miniature',
                  DX => 'Les miniatures',
                  DD1 => 'De la miniature',
                  M1 => 'Cette miniature',
                  C1 => 'e miniature',
                  DA1 => 'e miniature',
                  DAX => 'e miniatures'},
        NewItem => 'Nouvelle Miniature',
        Currency => 'Devise',

	  Help => 'Aide sur les Champs à Remplir',
	  Help1 => 'Aide',

# Traduction des Champs "Main"

        Main => 'La Miniature en Bref ',

        Name => 'Nom de la Miniature',
        Exchange => 'Miniature à Échanger ou à Vendre',
        Wanted => 'Miniature Recherchée',
        Rating1 => 'Note Globale',
        Picture1 => 'Image Principale',
        Scale => 'Échelle',
        Manufacturer => 'Fabricant',
        Constructor => 'Constructeur',
        Type1 => 'Type',
        Modele => 'Modèle',
        Version => 'Version',
        Color => 'Couleur du Modèle',
        Pub => 'Publicité',
        Year => 'Année',
        Reference => 'Référence',
        Kit => 'Miniature en Kit',
        Transformation => 'Transformation Personnelle',
        Comments1 => 'Commentaire',

# Traduction des Champs "Details"

        Details => 'La Miniature en Détails ',
        MiscCharacteristics => 'Caractéristiques Diverses de la Miniature',
        Material => 'Matériaux',
        Molding => 'Type du Moule',
        Condition => 'État du Modèle',
        Edition => 'Édition',
        Collectiontype => 'Nom de la Collection',
        Serial => 'Série',
        Serialnumber => 'Numéro de Série',
        Designed => 'Conçu en',
        Madein => 'Fabriqué en',
        Box1 => 'Type de Boîte',
        Box2 => 'Descriptif de la Boîte',
        Containbox => 'Contenu de la Boîte (ou Coffret)',
        Rating2 => 'Réalisme',
        Rating3 => 'Qualité de Finition',
        Acquisition => 'Date d\'Acquisition',
        Location => 'Lieu d\'Acquisition',
        Buyprice => 'Prix d\'Acquisition (€)',
        Estimate => 'Estimation (€)',
        Comments2 => 'Commentaire',
        Decorationset => 'Diorama',
        Characters => 'Personnages',
        CarFromFilm => 'Véhicule de film',
        Filmcar => 'Film Associé à la Voiture',
        Filmpart => 'Épisode du Film / Titre',
        Parts => 'Nombre de Pièces',
        VehiculeDetails => 'Détails du Véhicule',
        Detailsparts => 'Pièces de Détaillages',
        Detailsdecorations => 'Types de Décorations',
        Decorations => 'Nombre de Décorations',
        Lwh => 'Longueur / Largeur / Hauteur (cm)',
        Weight => 'Poids (g)',
        Framecar => 'Châssis',
        Bodycar => 'Carrosserie',
        Colormirror => 'Couleur du Modèle',
        Interior => 'Intérieur du Modèle',
        Wheels => 'Roues / Jantes / Essieux',
        Registrationnumber1 => 'Plaque d\'Immatriculation Avant',
        Registrationnumber2 => 'Plaque d\'Immatriculation Arrière',
        RacingCar => 'Véhicules de Course (Rallye,F1,DTM..)',
        Course => 'Course',
        Courselocation => 'Lieu de la Course',
        Courseyear => 'Date de la Course',
        Team => 'Équipe (Écurie)',
        Pilots => 'Pilote(s)',
        Copilots => 'Co Pilote(s)',
        Carnumber => 'Numéro de la Voiture',
        Pub2 => 'Publicitaires',
        Finishline => 'Place à l\'Arrivée',
        Steeringwheel => 'Position du volant',


# Traduction des Champs "Catalogs"

        Catalogs => 'La Miniature Cataloguée ',

        OfficialPicture => 'Photo Officielle de la Miniature',
        Barcode => 'Code à Barres',
        Referencemirror => 'Référence',
        Year3 => 'Date de Sortie',
        CatalogCoverPicture => 'Couverture',
        CatalogPagePicture => 'Page',
        Catalogyear => 'Année du Catalogue / Fascicule',
        Catalogedition => 'Édition du Catalogue',
        Catalogpage => 'Page du Catalogue',
        Catalogprice => 'Prix Catalogue / Librairie (€)',
        Personalref => 'Référence Personnelle',
        Websitem => 'Site Web Fabricant',
        Websitec => 'Site Web Constructeur',
        Websiteo => 'Lien Utile',
        Comments3 => 'Commentaire',

# Traduction des Champs "Pictures"

        Pictures => 'La Miniature en Photos ',

        OthersComments => 'Remarques Diverses',
        OthersDetails => 'Autres Détails',
        Top1 => 'Dessus',
        Back1 => 'Dessous',
	  AVG => 'Avant Gauche',
	  AV => 'Face Avant',
	  AVD => 'Avant Droit',
	  G => 'Profil Gauche',
	  BOX => 'Boîte',
	  D => 'Profil Droit',
	  ARG => 'Arrière Gauche',
	  AR => 'Face Arrière',
	  ARD => 'Arrière Droit',


        Others => 'Divers',

# Traduction des Champs "PanelLending"

        LendingExplanation => 'Permet de faire des échanges pour les expositions temporaires',
        PanelLending => 'Emprunts (Pour Expositions) ',
        Comments4 => 'Commentaire',

# Traduction des Champs "Realmodel"

        Realmodel => 'Le Modèle Réel ',

        Difference => 'Différences avec la Miniature',
        Front2 => 'Avant',
        Back2 => 'Arrière',
        Comments5 => 'Commentaire',

        References => 'Références',
     );
}

1;
