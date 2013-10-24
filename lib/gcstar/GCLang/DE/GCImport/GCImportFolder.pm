{
    package GCLang::DE::GCImport::GCImportFolder;

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
        'Name' => 'Ordner',
        'Recursive' => 'Unterordner durchsuchen',
        'Suffixes' => 'Suffix oder Dateiendung der Dateien',
        'SuffixesTooltip' => 'Eine kommaseparierte Liste von in Frage kommenden Suffixen oder Dateiendungen',
        'Remove' => 'Von den Namen zu entfernen',
        'RemoveTooltip' => 'Eine kommaseparierte Liste on Wörtern, die aus den Dateinamen entfernt werden sollen um die Namen zu bestimmen',
        'Ask'=> 'Nachfragen',
        'AskEnd'=> 'Nachfragen nach dem Sammeln aller Informationen',
        'AddWithoutInfo'=> 'Ohne Informationen hinzufügen',
        'DontAdd'=> 'Nicht hinzufügen',
        'TakeFirst' => 'Erstes verwenden',
        'MultipleResult'=> 'Mehrere Ergebnisse',
        'MultipleResultTooltip'=> 'Vorgehensweise wenn das Plugin mehr als ein Ergebnis liefert',
        'RemoveWholeWord' => 'Nur ganze Wörter entfernen',
        'NoResult'=> 'Keine Ergebnisse',
        'NoResultTooltip'=> 'Vorgehensweise wenn das Plugin kein Ergebnis liefert',
        'RemoveTooltipWholeWord' => 'Wörter entfernen wenn sie als gesamtes Wort erscheinen',
        'RemoveRegularExpr' => 'Reguläre Ausdrücke',
        'RemoveTooltipRegularExpr' => 'Zähle \'To be removed from names\' als regulären Perl Ausdruck',
        'SkipFileAlreadyInCollection' => 'Nur unbekannte Dateien hinzufügen',
        'SkipFileAlreadyInCollectionTooltip' => 'Nur Dateien hinzufügen, die nicht Teil der Sammlung sind',
        'SkipFileNo' => 'Nein',
        'SkipFileFullPath' => 'basierend auf kompletten Pfad',
        'SkipFileFileName' => 'basierend auf komplettem Pfad',
        'SkipFileFileNameAndUpdate' => 'basierend auf komplettem Pfad (neuen Pfad für bewegte Dateien eintragen)',
        'InfoFromFileNameRegExp' => 'Verarbeite Dateinamen mit diesem regulären Ausdruck',
        'InfoFromFileNameRegExpTooltip' => 'Nachfolgende Informationen können für die Verarbeitugn verwendet werden (nach dem Entfernen der Dateiendung).\nLeer lassen, wenn nicht benötigt wird.\nBekannte Felder: \n$T:Titel, $A:Alphabetisierte Titel, $Y:Veröffentlichungsdatum, $S:Jahrgang, $E:Episode, $N:Alphabetisierter Serienname, $x:Nummer der Folge, $y: Anzahl Gesamtfolgen',

    );

    # As this plugin shares some values with ImportList, it adds them from it
    importTranslation('List');
}

1;
