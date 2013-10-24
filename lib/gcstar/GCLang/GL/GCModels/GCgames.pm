{
    package GCLang::GL::GCModels::GCgames;

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
    
        CollectionDescription => 'Colección de Videoxogos',
        Items => {0 => 'Xogo',
                  1 => 'Xogo',
                  X => 'Xogos'},
        NewItem => 'Novo Xogo',
    
        Id => 'Id',
        Ean => 'EAN',
        Name => 'Nome',
        Platform => 'Plataforma',
        Players => 'Numero de xogadores',
        Released => 'Data de lanzamento',
        Editor => 'Editora',
        Developer => 'Desenvolvemento',
        Genre => 'Xénero',
        Box => 'Imaxe da caixa',
        Case => 'Caso',
        Manual => 'Manual de instruccións',
        Completion => 'Completo (%)',
        Executable => 'Executable',
        Description => 'Descrición',
        Codes => 'Códigos',
        Code => 'Código',
        Effect => 'Efecto',
        Secrets => 'Segredos',
        Screenshots => 'Capturas de pantalla',
        Screenshot1 => 'Primeira captura',
        Screenshot2 => 'Segunda captura',
        Comments => 'Comentarios',
        Url => 'Páxina web',
        Unlockables => 'Non bloqueables',
        Unlockable => 'Non bloqueable',
        Howto => 'Como desbloquear',
        Exclusive => 'Exclusive',
        Resolutions => 'Display resolutions',
        InstallationSize => 'Size',
        Region => 'Region',
        SerialNumber => 'Serial Number',        

        General => 'Xeral',
        Details => 'Detalles',
        Tips => 'Consello',
        Information => 'Información',

        FilterRatingSelect => 'Puntuado polo menos...',
     );
}

1;
