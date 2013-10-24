{
    package GCLang::FR::GCExport::GCExportHTML;

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
        'ModelNotFound' => 'Ficher de modèle invalide',
        'UseFile' => 'Utiliser le fichier ci-dessous',
        'TemplateExternalFile' => 'Fichier avec le modèle',
        'WithJS' => 'Utiliser du Javascript',
       	'FileTemplate' => 'Modèle',
        'Preview' => 'Aperçu',
        'NoPreview' => 'Aucun aperçu disponible',
        'Title' => 'Titre de la page',
        'InfoFile' => 'La liste se trouve dans le fichier : ',
        'InfoDir' => 'Les images se trouvent dans : ',
        'HeightImg' => 'Hauteur en pixels des images',
        'OpenFileInBrowser' => 'Ouvrir le fichier généré dans le navigateur web',
        'Note' => 'Liste générée avec <a href="http://www.gcstar.org/">GCstar</a>',
        'InputTitle' => 'Entrez le texte à rechercher',
        'SearchType1' => 'Titre seulement',
        'SearchType2' => 'Toutes les informations',
        'SearchButton' => 'Rechercher',    
        'SearchTitle' => 'Afficher seulement les films correspondant aux critères précédents',
        'AllButton' => 'Tous',
        'AllTitle' => 'Afficher tous les films',
        'Expand' => 'Tout développer',
        'ExpandTitle' => 'Afficher les informations de tous les films',
        'Collapse' => 'Tout réduire',
        'CollapseTitle' => 'Masquer les informations de tous les films',
        'Borrowed' => 'Emprunté par : ',
        'NotBorrowed' => 'Disponible',
        'Top' => 'Haut',
        'Bottom' => 'Bas',
     );
}

1;
