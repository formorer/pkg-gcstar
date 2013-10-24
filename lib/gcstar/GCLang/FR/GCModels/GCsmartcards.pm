{
    package GCLang::FR::GCModels::GCsmartcards;

    use utf8;
###################################################
#
#  Copyright 2005-2010 Tian
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
    
        CollectionDescription => 'Collection de Cartes à Puce',
        Items => {0 => 'Carte',
                  1 => 'Carte',
                  X => 'Cartes'},
        NewItem => 'Nouvelle Carte à Puce',
        Currency => 'Devise',

	  Help => 'Aide sur les Champs à Remplir',
	  Help1 => 'Aide',

# Traduction des Champs "Main"

        Main => 'La Carte à Puce en Bref ',

        Cover => 'Image',

        Name => 'Nom de la Carte à Puce',
        Exchange => 'Carte à Échanger ou à Vendre',
        Wanted => 'Carte Recherchée',
        Rating1 => 'Qualité Globale',
        TheSmartCard => 'La Carte à Puce    Recto / Verso',

        Country => 'Pays',
        Color => 'Couleur de la Carte',
        Type1 => 'Type de Carte',
        Type2 => 'Type de Puce',
        Dimension => 'Longueur / Largeur / Épaisseur (cm)',

        Box => 'Emballage',
        Chip => 'Puce',
        Year1 => 'Date d\'Edition',
        Year2 => 'Date de Validité',
        Condition => 'Carte Neuve',
        Charge => 'Carte Rechargeable',
        Variety => 'Variété',

        Edition => 'Tirage (Exemplaires)',
        Serial => 'Numéro de Série',
        Theme => 'Thème',

        Acquisition => 'Carte Acquise le',

        Catalog0 => 'Catalogue',
        Catalog1 => 'Phonecote / Infopuce (YT)',
        Catalog2 => 'La Cote en Poche',

        Reference0 => 'Référence',
        Reference1 => 'Référence Phonecote / Infopuce (YT)',
        Reference2 => 'Référence La Cote en Poche',
        Reference3 => 'Référence Autre',

        Quotationnew00 => 'Cotation Carte Neuve (en €)',
        Quotationnew10 => 'Cotation Phonecote / Infopuce (YT)',
        Quotationnew20 => 'Cotation La Cote en Poche',
        Quotationnew30 => 'Cotation Autre',
        Quotationold00 => 'Cotation Carte Utilisée (en €)',
        Quotationold10 => 'Cotation Phonecote / Infopuce (YT)',
        Quotationold20 => 'Cotation La Cote en Poche',
        Quotationold30 => 'Cotation Autre',

        Title1 => 'Titre',

        Unit => 'Nombre d\'Unités / Minutes',

        Pressed => 'Type d\'Impression',
        Location => 'Lieu d\'Impression',

        Comments1 => 'Observations',

        Others => 'Divers',
        Weight => 'Poids',
     );
}

1;
