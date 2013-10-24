{
    package GCLang::FR::GCImport::GCImportScanner;

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
        'Name' => 'Lecteur de codes barres',
        'Type' => 'Type de lecteur',
        'Local' => 'Local (reconnu comme un clavier)',
        'Network' => 'Réseau (ex : GCstar Scanner sur Android)',
        'Port' => 'Port à écouter',
        'Plugin' => 'Site à utiliser',
        'UseFirst' => 'Choisir le 1er si plusieurs résultats',
        'Waiting' => 'En attente de code barre',
        'EAN' => 'Code barre',
        'ScanPrompt' => 'Scannez un article ou pressez sur Terminer',
        'ScanOtherPrompt' => 'Scannez un autre article ou pressez sur Terminer',
        'Previous' => '"%s" va être ajouté',
        'NothingFound' => 'Rien n\'a été trouvé pour "%s". Un élément vide va être ajouté.',
        'Terminate' => 'Terminer',
     );
}

1;
