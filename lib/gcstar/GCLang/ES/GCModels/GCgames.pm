{
    package GCLang::ES::GCModels::GCgames;

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
    
        CollectionDescription => 'Colección de video juegos',
        Items => {0 => 'Juego',
                  1 => 'Juego',
                  lowercase1 => 'juego',
                  X => 'Juegos',
                  lowercaseX => 'juegos',
                  P1 => 'El Juego',
                  lowercaseP1 => 'el juego',
                  U1 => 'Un Juego',
                  lowercaseU1 => 'un juego',
                  AP1 => 'Al Juego',
                  lowercaseAP1 => 'al juego',
                  DP1 => 'Del Juego',
                  lowercaseDP1 => 'del juego',
                  PX => 'Los Juegos',
                  lowercasePX => 'los juegos',
                  E1 => 'Este Juego',
                  lowercaseE1 => 'este juego',
                  EX => 'Estos Juegos',
                  lowercaseEX => 'estos juegos'             
                  },
        NewItem => 'Nuevo juego',
    
        Id => 'Id',
        Ean => 'EAN',
        Name => 'Nombre',
        Platform => 'Plataforma',
        Players => 'Número de jugadores',
        Released => 'Fecha de publicación',
        Editor => 'Editor',
        Developer => 'Developer',
        Genre => 'Género',
        Box => 'Portada de la caja',
        Case => 'Case',
        Manual => 'Instructions manual',
        Completion => 'Completado (%)',
        Executable => 'Ejecutable',
        Description => 'Descripción',
        Codes => 'Códigos',
        Code => 'Código',
        Effect => 'Efecto',
        Secrets => 'Secretos',
        Screenshots => 'Capturas de pantallas',
        Screenshot1 => 'Primera captura',
        Screenshot2 => 'Seguna captura',
        Comments => 'Comentarios',
        Url => 'Página web',
        Unlockables => 'Desbloqueables',
        Unlockable => 'Desbloqueable',
        Howto => 'Cómo desbloquear',
        Exclusive => 'Exclusive',
        Resolutions => 'Display resolutions',
        InstallationSize => 'Size',
        Region => 'Region',
        SerialNumber => 'Serial Number',        

        General => 'General',
        Details => 'Detalles',
        Tips => 'Consejos',
        Information => 'Información',

        FilterRatingSelect => 'Puntuación al _menos...',
     );
}

1;
