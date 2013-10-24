{
    package GCLang::CA::GCImport::GCImportFolder;

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
        'Name' => 'Carpeta',
        'Recursive' => 'Navega per sub-carpetes',
        'Suffixes' => 'Sufixes o extensions dels fitxers',
        'SuffixesTooltip' => 'Una llista separada per comes de sufixes o extensions de fitxters a considerar',
        'Remove' => 'Per ser borrats dels noms',
        'RemoveTooltip' => 'Una llista separada per comes de paraules que haurien de ser borrades dels noms de fitxers per a crear els noms que es desen',
        'Ask'=> 'Pregunta',
        'AskEnd'=> 'Pregunta al final',
        'AddWithoutInfo'=> 'Afegeix sense informació',
        'DontAdd'=> 'No afegeixis',
        'TakeFirst' => 'Selecciona primer',
        'MultipleResult'=> 'Ignora quan hi ha més d\'un resultat',
        'MultipleResultTooltip'=> 'El fitxer s\'afegirà sense recollir la informació si hi ha més d\'un resutat',
        'RemoveWholeWord' => 'Elimina només paraules senceres',
        'NoResult'=> 'Sense resultats',
        'NoResultTooltip'=> 'Què feim quan no es retorna un resultat',
        'RemoveTooltipWholeWord' => 'Les paraules s\'eliminaran només si apareixen com paraules senceres',
        'RemoveRegularExpr' => 'Expressió regular',
        'RemoveTooltipRegularExpr' => 'Es considera que \'Esser eliminat dels noms\' és una expressió regular',
        'SkipFileAlreadyInCollection' => 'Només afegeix fitxers nous',
        'SkipFileAlreadyInCollectionTooltip' => 'Només afegeix fitxers que encara no estiguin en la col·lecció',
        'SkipFileNo' => 'No',
        'SkipFileFullPath' => 'basat en el camí cencer',
        'SkipFileFileName' => 'basat en el nom del fitxer',
        'SkipFileFileNameAndUpdate' => 'basat en el nom del fitxer (però actualitza el camí a la col·lecció)',
        'InfoFromFileNameRegExp' => 'Analitza el nom de fitxer amb aquesta expressió regular',
        'InfoFromFileNameRegExpTooltip' => 'Utilitza aquest per treure informació del nom de fitxer (després d\'eliminar l\'extensió). Deixa-ho buid si no fa falta. Camps coneguts: $T:Títol, $A:Títol alfabetitzat, $Y:Data de sortida, $S:Temporada, $E:Episodi, $N:Nom alfabetitzat de la sèrie , $x:Número de part, $y: Número total de parts',

     );

    # As this plugin shares some values with ImportList, it adds them from it
    importTranslation('List');
}

1;
