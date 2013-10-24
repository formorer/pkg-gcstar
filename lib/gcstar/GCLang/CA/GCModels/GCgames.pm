{
    package GCLang::CA::GCModels::GCgames;

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
    
        CollectionDescription => 'Col·lecció de Vídeo jocs',
        Items => {0 => 'Joc',
            1 => 'Joc',
            X => 'Jocs'
        },
        NewItem => 'Joc nou',
    
        Id => 'Id',
        Ean => 'EAN',
        Name => 'Nom',
        Platform => 'Plataforma',
        Players => 'Nombre de jugadors',
        Released => 'Data de publicació',
        Editor => 'Editorial',
        Developer => 'Desenvolupador',
        Genre => 'Gènere',
        Box => 'Caràtula',
        Case => 'Capça',
        Manual => 'Manual d\'instruccions',
        Completion => 'Completat (%)',
        Executable => 'Executable',
        Description => 'Descripció',
        Codes => 'Codis',
        Code => 'Codi',
        Effect => 'Efecte',
        Secrets => 'Secrets',
        Screenshots => 'Captures de pantalla',
        Screenshot1 => 'Primera captura de pantalla',
        Screenshot2 => 'Segona captura de pantalla',
        Comments => 'Comentaris',
        Url => 'Pàgina Web',
        Unlockables => 'Desbloquejables',
        Unlockable => 'Desbloquejable',
        Howto => 'Com desbloquejar',
        Exclusive => 'Exclusive',
        Resolutions => 'Display resolutions',
        InstallationSize => 'Size',
        Region => 'Regió',
        SerialNumber => 'Número de sèrie',        

        General => 'General',
        Details => 'Detalls',
        Tips => 'Consells',
        Information => 'Informació',

        FilterRatingSelect => 'Valoració al _menys...',
     );
}

1;
