{
    package GCLang::DE::GCModels::GCgames;

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
    
        CollectionDescription => 'Computerspiele Sammlung',
        Items => {0 => 'Spiel',
                  1 => 'Spiel',
                  X => 'Spiele'},
        NewItem => 'Neues Spiel',
    
        Id => 'Id',
        Ean => 'EAN',
        Name => 'Name',
        Platform => 'Plattform',
        Players => 'Anzahl der Spieler',
        Released => 'Erscheinungsdatum',
        Editor => 'Herausgeber',
        Developer => 'Entwickler',
        Genre => 'Genre',
        Box => 'Bild der Verpackung',
        Case => 'Originalverpackung',
        Manual => 'Bedienungsanleitung',
        Completion => 'Durchgespielt (%)',
        Executable => 'Startdatei',
        Description => 'Beschreibung',
        Codes => 'Cheats',
        Code => 'Cheatcode',
        Effect => 'Effekt',
        Secrets => 'Geheimnisse',
        Screenshots => 'Bildschirm Foto',
        Screenshot1 => 'Erstes Bildschirm Foto',
        Screenshot2 => 'Zweites Bildschirm Foto',
        Comments => 'Kommentar',
        Url => 'Internetseite',
        Unlockables => 'Lösungen',
        Unlockable => 'Ziel',
        Howto => 'Lösungsweg',
        Exclusive => 'Exclusive',
        Resolutions => 'Bildschirmauflösungen',
        InstallationSize => 'Größe',
        Region => 'Region',
        SerialNumber => 'Seriennummer',

        General => 'Allgemein',
        Details => 'Details',
        Tips => 'Tipps',
        Information => 'Information',

        FilterRatingSelect => 'Bewertung _mindestens...',
     );
}

1;
