{
    package GCLang::SV::GCModels::GCgames;

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
    
        CollectionDescription => 'Videospelsamling',
        Items => 'Spel',
        NewItem => 'Nytt spel',
    
        Id => 'Id',
        Ean => 'EAN',
        Name => 'Namn',
        Platform => 'Plattform',
        Players => 'Antal spelare',
        Released => 'Releasedatum',
        Editor => 'Utgivare',
        Developer => 'Utvecklare',
        Genre => 'Genre',
        Box => 'Omslagsbild',
        Case => 'Fodral',
        Manual => 'Instruktionsmanual',
        Completion => 'Fullständighet (%)',
        Executable => 'Startfil',
        Description => 'Beskrivning',
        Codes => 'Koder',
        Code => 'Kod',
        Effect => 'Effekt',
        Secrets => 'Hemligheter',
        Screenshots => 'Bilder',
        Screenshot1 => 'Första bild',
        Screenshot2 => 'Andra screenshot',
        Comments => 'Kommentarer',
        Url => 'Hemsida',
        Unlockables => 'Upplåsningar',
        Unlockable => 'Upplåsningsbar',
        Howto => 'Hur låsa upp',
        Exclusive => 'Exclusive',
        Resolutions => 'Display resolutions',
        InstallationSize => 'Size',
        Region => 'Region',
        SerialNumber => 'Serial Number',        

        General => 'Allmänt',
        Details => 'Detaljer',
        Tips => 'Tips',
        Information => 'Information',

        FilterRatingSelect => 'Betyg _Åtminstone...',
     );
}

1;
