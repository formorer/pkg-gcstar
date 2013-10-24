{
    package GCLang::CS::GCModels::GCgames;

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
    
        CollectionDescription => 'Sbírka her',
        Items => sub {
          my $number = shift;
          return 'Hra' if $number eq '1';
          return 'Hry' if $number =~ /(?<!1)[2-4]$/;
          return 'Her';
        },
        NewItem => 'Nová hra',
    
        Id => 'Id',
        Ean => 'EAN',
        Name => 'Název',
        Platform => 'Platforma',
        Players => 'Počet hráčů',
        Released => 'Datum vydání',
        Editor => 'Vydavatel',
        Developer => 'Vývojář',
        Genre => 'Žánr',
        Box => 'Obrázek obalu',
        Case => 'Obal',
        Manual => 'Manuál',
        Completion => 'Dokončeno (%)',
        Executable => 'Spustitelný soubor',
        Description => 'Popis',
        Codes => 'Cheaty',
        Code => 'Cheat',
        Effect => 'Účel',
        Secrets => 'Tajemství',
        Screenshots => 'Snímek ze hry',
        Screenshot1 => 'První snímek ze hry',
        Screenshot2 => 'Druhý snímek ze hry',
        Comments => 'Komentář',
        Url => 'Web',
        Unlockables => 'Možnosti odemčení',
        Unlockable => 'Odemčení',
        Howto => 'Jak odemknout',
        Exclusive => 'Exclusive',
        Resolutions => 'Display resolutions',
        InstallationSize => 'Size',
        Region => 'Region',
        SerialNumber => 'Serial Number',        

        General => 'Hlavní',
        Details => 'Detaily',
        Tips => 'Tipy',
        Information => 'Informace',

        FilterRatingSelect => 'Hodnocení _minimálně...',
     );
}

1;
