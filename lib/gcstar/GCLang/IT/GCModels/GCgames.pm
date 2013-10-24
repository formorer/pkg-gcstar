{
    package GCLang::IT::GCModels::GCgames;

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
#######################################################
#
#  v1.0.2 - Italian localization by Andreas Troschka
#
#  for GCstar v1.1.1
#
#######################################################

    
    use strict;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => 'Videogiochi',
        Items => {0 => 'Giochi',
                  1 => 'Giochi',
                  X => 'Giochi'},
        NewItem => 'Nuovo gioco',
    
        Id => 'Id',
        Ean => 'EAN',
        Name => 'Titolo',
        Platform => 'Piattaforma',
        Players => 'Numero giocatori',
        Released => 'Data rilascio',
        Editor => 'Editore',
        Developer => 'Sviluppatore',
        Genre => 'Genere',
        Box => 'Scatola',
        Case => 'Contenitore',
        Manual => 'Manuale d\'istruzioni',
        Completion => 'Completato (%)',
        Executable => 'Executable',
        Description => 'Descrizione',
        Codes => 'Codici',
        Code => 'Codice',
        Effect => 'Effetto',
        Secrets => 'Segreti',
        Screenshots => 'Vista',
        Screenshot1 => 'Prima vista',
        Screenshot2 => 'Seconda vista',
        Comments => 'Commenti',
        Url => 'Pagina web',
        Unlockables => 'Non bloccabili',
        Unlockable => 'Bloccabile',
        Howto => 'Come sbloccare',
        Exclusive => 'Exclusive',
        Resolutions => 'Display resolutions',
        InstallationSize => 'Size',
        Region => 'Region',
        SerialNumber => 'Serial Number',        

        General => 'Generale',
        Details => 'Dettagli',
        Tips => 'Suggerimenti',
        Information => 'Informatzioni',

        FilterRatingSelect => 'Valutazioni, almeno...',
     );
}

1;
