{
    package GCLang::SV::GCImport::GCImportFolder;

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
        'Name' => 'Mapp',
        'Recursive' => 'Bläddra undermappar',
        'Suffixes' => 'Suffix eller filändelser',
        'SuffixesTooltip' => 'En komma-separerad lista av suffix eller filändelser att betrakta',
        'Remove' => 'Att ta bort från namn',
        'RemoveTooltip' => 'En komma-separerad lista av ord som bör tas bort från filnamn för att skapa de hämtade filnamnen från',
        'Ask'=> 'Fråga',
        'AskEnd'=> 'Fråga alla vid slute',
        'AddWithoutInfo'=> 'Lägg till utan info',
        'DontAdd'=> 'Lägg inte till',
        'TakeFirst' => 'Välj först',
        'MultipleResult'=> 'Multiple results',
        'MultipleResultTooltip'=> 'What do we do when more than 1 result is return by the plugin',
        'RemoveWholeWord' => 'Ta enbart bort hela ord',
        'NoResult'=> 'Inga resultat',
        'NoResultTooltip'=> 'Vad skall vi göra när inga sökresultat returneras av plugin:et',
        'RemoveTooltipWholeWord' => 'Ord kommer enbart tas bort ifall de förekommer som ett helt ord',
        'RemoveRegularExpr' => 'Reguljärt uttryck',
        'RemoveTooltipRegularExpr' => 'Tänk på att \'Ta bort från namn\' är ett reguljärt uttryck i perl',
        'SkipFileAlreadyInCollection' => 'Lägg enbart till nya filer',
        'SkipFileAlreadyInCollectionTooltip' => 'Lägg enbart till filer som inte redan finns i samlingen',
        'SkipFileNo' => 'Nej',
        'SkipFileFullPath' => 'based on full path',
        'SkipFileFileName' => 'based on file name',
        'SkipFileFileNameAndUpdate' => 'baserad på filnamnet (men uppdatera sökväg i samlingen)',
        'InfoFromFileNameRegExp' => 'Parsa filnamn med reguljärt uttryck',
        'InfoFromFileNameRegExpTooltip' => 'Använd detta för att införskaffa info från filnamn (tillämpat efter borttagning av ändelse). Lämna tomt ifall ej nödvändig. Kända fält: $T:Titel, $A:Alfabetisk titel, $Y:Releasedatum, $S:Säsong, $E:Episod, $N:Alfabetiskt serienamn, $x:Avsnittsnummer, $y:Totalt antal avsnitt',

     );

    # As this plugin shares some values with ImportList, it adds them from it
    importTranslation('List');
}

1;
