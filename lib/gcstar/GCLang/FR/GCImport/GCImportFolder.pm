{
    package GCLang::FR::GCImport::GCImportFolder;

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
    use GCLang::GCLangUtils;

    our @EXPORT = qw(%lang);

    our %lang = (
        'Name' => 'Répertoire',
        'Recursive' => 'Parcourir les sous-répertoires',
        'Suffixes' => 'Suffixes ou extensions des fichiers',
        'SuffixesTooltip' => 'Une liste séparée par des virgules des suffixes ou extensions des fichiers à considérer',
        'Remove' => 'A supprimer des noms',
        'RemoveTooltip' => 'Une liste séparée par des virgules des mots à supprimer des noms de fichiers pour créer le nom à rechercher',
        'MultipleResult'=> 'Résultats multiples',
        'MultipleResultTooltip'=> 'Que faire si la recherche retourne plus d\'un résultat',
        'Ask'=> 'Demander',
        'AskEnd'=> 'Demander à la fin',
        'AddWithoutInfo'=> 'Ajouter sans informations',
        'DontAdd'=> 'Ne pas ajouter',
        'TakeFirst' => 'Choisir le premier',
        'NoResult'=> 'Pas de résultat',
        'NoResultTooltip'=> 'Que faire si la recherche ne retourne aucun résultat',
        'RemoveWholeWord' => 'Retirer seulement les mots entiers',
        'RemoveTooltipWholeWord' => 'Ne retire que des mots entiers du nom de fichier',
        'RemoveRegularExpr' => 'Expression regulière',
        'RemoveTooltipRegularExpr' => 'Considere \'A supprimer des noms\' comme une expression regulière perl',
        'SkipFileAlreadyInCollection' => 'N\'ajouter que les nouveaux fichiers',
        'SkipFileAlreadyInCollectionTooltip' => 'N\'ajouter que les nouveaux fichiers à collection',
        'SkipFileNo' => 'Non',
        'SkipFileFullPath' => 'd\'après le chemin complet',
        'SkipFileFileName' => 'd\'après le nom de fichier',
        'SkipFileFileNameAndUpdate' => 'd\'après le nom de fichier (et mettre à jour le chemin des présents)',
        'InfoFromFileNameRegExp' => 'Parser nom du fichier avec cette expression régulière',
        'InfoFromFileNameRegExpTooltip' => 'Recupère des informations du nom de fichier (appliqué après avoir enlevé l\'extention).\nLaisser vide si inutile.\nChamps reconnus : \n$T:Titre, $A:Titre Alphabetisé, $Y:Année de sortie, $S:Saison, $E:Episode, $N:Nom de série alphabetisé, $x:numero de partie, $y:nombre total de parties',

     );

    # As this plugin shares some values with ImportList, it adds them from it
    importTranslation('List');
}

1;
