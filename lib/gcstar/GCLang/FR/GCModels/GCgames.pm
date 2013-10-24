{
    package GCLang::FR::GCModels::GCgames;

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
    
        CollectionDescription => 'Collection de jeux vidéo',
        #Items => 'Jeux',
        Items => {0 => 'Jeu',
                  1 => 'Jeu',
                  X => 'Jeux',
                  I1 => 'Un jeu',
                  D1 => 'Le jeu',
                  DX => 'Les jeux',
                  DD1 => 'Du jeu',
                  M1 => 'Ce jeu',
                  C1 => ' jeu',
                  DA1 => 'e jeu',
                  DAX => 'e jeux'},
        NewItem => 'Nouveau jeu',
    
        Id => 'Identifiant',
        Ean => 'EAN',
        Name => 'Nom',
        Platform => 'Plate-forme',
        Players => 'Nombre de joueurs',
        Released => 'Date de sortie',
        Editor => 'Editeur',
        Developer => 'Développeur',
        Genre => 'Genre',
        Box => 'Boîtier',
        BoxBack => 'Arrière',
        Case => 'Boîte',
        Manual => 'Notice',
        Completion => 'Avancement (%)',
        Executable => 'Exécutable',
        Description => 'Description',
        Codes => 'Codes',
        Code => 'Code',
        Effect => 'Effet',
        Secrets => 'Secrets',
        Screenshots => 'Captures',
        Screenshot1 => '1ère capture',
        Screenshot2 => '2ème capture',
        Comments => 'Commentaires',
        Url => 'Page Web',
        Unlockables => 'Déblocables',
        Unlockable => 'Déblocable',
        Howto => 'Comment débloquer',
        Exclusive => 'Exclusivité',
        Resolutions => 'Résolutions',
        InstallationSize => 'Taille',
        Region => 'Région',
        SerialNumber => 'Numéro de série',        

        General => 'Général',
        Details => 'Détails',
        Tips => 'Astuces',
        Information => 'Informations',

        FilterRatingSelect => 'Notes au moins égales à...',
     );
}

1;
