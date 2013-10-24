{
    package GCLang::HU::GCModels::GCgames;

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
    
        CollectionDescription => 'Videójáték gyűjtemény',
        Items => {0 => 'Játék',
                  1 => 'Játék',
                  X => 'Játékok'},
        NewItem => 'Új játék',
    
        Id => 'Azonosító',
        Ean => 'EAN',
        Name => 'Név',
        Platform => 'Platform',
        Players => 'Játékosok száma',
        Released => 'Kiadás dátuma',
        Editor => 'Kiadó',
        Developer => 'Fejlesztő',
        Genre => 'Jellemzők',
        Box => 'Doboz képe',
        Case => 'Eredeti tok',
        Manual => 'Kézikönyv',
        Completion => 'Befejezés (%)',
        Executable => 'Játszhatóság',
        Description => 'Leírás',
        Codes => 'Kódok',
        Code => 'Kód',
        Effect => 'Efektek',
        Secrets => 'Titkok',
        Screenshots => 'Képernyőképek',
        Screenshot1 => 'Első képernyőkép',
        Screenshot2 => 'Második képernyőkép',
        Comments => 'Megjegyzések',
        Url => 'Weboldal',
        Unlockables => 'Megoldások',
        Unlockable => 'Cél',
        Howto => 'Megoldás módja',
        Exclusive => 'Exclusive',
        Resolutions => 'Display resolutions',
        InstallationSize => 'Size',
        Region => 'Region',
        SerialNumber => 'Serial Number',        

        General => 'Általános',
        Details => 'Összetevők',
        Tips => 'Tippek',
        Information => 'Információ',

        FilterRatingSelect => 'Értékelés _Legalább...',
     );
}

1;
