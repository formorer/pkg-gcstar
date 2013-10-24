{
    package GCLang::FR::GCModels::GCsoftware;

    use utf8;
###################################################
#
#  Copyright 2005-2009 Tian
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
    
        CollectionDescription => 'Collection de logiciels',
        Items => {0 => 'Application',
                  1 => 'Application',
                  X => 'Applications',
                  lowercase1 => 'application',
                  lowercaseX => 'applications'},
        NewItem => 'Nouvelle application',
    
        Id => 'Identifian',
        Ean => 'EAN',
        Name => 'Nom',
        Platform => 'Plate-forme',
        Released => 'Date de sortie',
        Homepage => 'Site web',
        Editor => 'Editeur',
        Developer => 'Développeur',
        Category => 'Catégorie',
		NumberOfCopies => 'Copies',
		Price => 'Prix',
        Box => 'Photo de la boîte',
        Case => 'Boîtier',
        Manual => 'Notice',
        Executable => 'Exécutable',
        Description => 'Description',
        License => 'Licence',
        Commercial => 'Commercial',
		FreewareNoncommercial => 'Freeware (en usage non-commercial)',		
		OtherOpenSource => 'Autre licence Open Source',
		PublicDomain => 'Domaine public',
		OtherLicense => 'Autre',
		Registration => 'Enregistrement',				
		RegistrationInfo => 'Informations d\'enregistrement',		
		RegInfo => 'Informations',
		RegistrationName => 'Nom d\'utilisateur',
		RegistrationNumber => 'Numéro d\'enregistrement',		
		PanelRegistration => 'Informations d\'enregistrement',	
		RegistrationComments => 'Informations supplémentaires',
        Screenshots => 'Captures d\'écran',
        Screenshot1 => '1ère capture',
        Screenshot2 => '2ème capture',
        Comments => 'Commentaires',
        Url => 'Page web',
        General => 'Général',
        Details => 'Détails',
        Information => 'Informations',

        FilterRatingSelect => 'Notes au moins égales à...',
     );
}

1;
