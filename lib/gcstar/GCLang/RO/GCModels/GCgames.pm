{
    package GCLang::RO::GCModels::GCgames;

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
    
        CollectionDescription => 'Colecţie de jocuri video',
        Items => 'Jocuri',
        NewItem => 'Joc nou',
    
        Id => 'Id',
        Ean => 'EAN',
        Name => 'Nume',
        Platform => 'Platformă',
        Players => 'Număr de jucători',
        Released => 'Dată lansare',
        Editor => 'Editor',
        Developer => 'Dezvoltator',
        Genre => 'Gen',
        Box => 'Imagine cutie',
        Case => 'Carcasă',
        Manual => 'Manual de instrucţiuni',
        Completion => 'Completat (%)',
        Executable => 'Executabil',
        Description => 'Descriere',
        Codes => 'Coduri',
        Code => 'Cod',
        Effect => 'Efecte',
        Secrets => 'Secrete',
        Screenshots => 'Capturi ecran',
        Screenshot1 => 'Prima captura de ecran',
        Screenshot2 => 'A doua captură de ecran',
        Comments => 'Comentarii',
        Url => 'Pagină web',
        Unlockables => 'Deblocări',
        Unlockable => 'Nu poate fi deblocat',
        Howto => 'Cum se deblochează',
        Exclusive => 'Exclusive',
        Resolutions => 'Display resolutions',
        InstallationSize => 'Size',
        Region => 'Region',
        SerialNumber => 'Serial Number',        

        General => 'General',
        Details => 'Detalii',
        Tips => 'Ponturi',
        Information => 'Informaţii',

        FilterRatingSelect => 'Evaluat la cel _puţin...',
     );
}

1;
