{
    package GCLang::PT::GCModels::GCgames;

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
    
        CollectionDescription => 'Coleção de jogos',
        Items => 'Jogos',
        NewItem => 'Novo jogo',
    
        Id => 'Id',
        Ean => 'EAN',
        Name => 'Nome',
        Platform => 'Plataforma',
        Players => 'Número de jogadores',
        Released => 'Data de lançamento',
        Editor => 'Editor',
        Developer => 'Desenvolvedor',
        Genre => 'Gênero',
        Box => 'Imagem da capa',
        Case => 'Capa',
        Manual => 'Manual de instruções',
        Completion => 'Completado (%)',
        Executable => 'Executable',
        Description => 'Descrição',
        Codes => 'Códigos',
        Code => 'Código',
        Effect => 'Efeito',
        Secrets => 'Segredos',
        Screenshots => 'Screenshots',
        Screenshot1 => 'Primeiro screenshot',
        Screenshot2 => 'Segundo screenshot',
        Comments => 'Comentários',
        Url => 'Página da web',
        Unlockables => 'Desbloqueados',
        Unlockable => 'Desbloqueado',
        Howto => 'Como desbloquear',
        Exclusive => 'Exclusive',
        Resolutions => 'Display resolutions',
        InstallationSize => 'Size',
        Region => 'Region',
        SerialNumber => 'Serial Number',        

        General => 'Geral',
        Details => 'Detalhes',
        Tips => 'Tipos',
        Information => 'Informação',

        FilterRatingSelect => 'Nota _mínima...',
     );
}

1;
