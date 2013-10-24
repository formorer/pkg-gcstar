{
    package GCLang::DE::GCModels::GCsoftware;

    use utf8;
###################################################
#
#  Copyright 2005-2009 Tian
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
    
        CollectionDescription => 'Softwaresammlung',
        Items => {0 => 'Programm',
                  1 => 'Programm',
                  X => 'Programme'},
        NewItem => 'Neues Programm',
    
        Id => 'Id',
        Ean => 'EAN',
        Name => 'Name',
        Platform => 'Platform',
        Released => 'Erscheinungsdatum',
        Homepage => 'Homepage',		
        Editor => 'Editor',
        Developer => 'Entwickler',
        Category => 'Kategorie',
        NumberOfCopies => '# Exemplare',
        Price => 'Preis',
        Box => 'Verpackungsbild',
        Case => 'Verpackung',
        Manual => 'Handbuch',
        Executable => 'Datei',
        Description => 'Beschreibung',
        License => 'Lizenz',
        Commercial => 'kommerziell',
        FreewareNoncommercial => 'Freeware (für nicht-kommerziellen Einsatz)',
        OtherOpenSource => 'sonstige Open Source',
        PublicDomain => 'Public Domain',
        OtherLicense => 'sonstige',
        Registration => 'Registrierung',	
        RegistrationInfo => 'Registrierungsdaten',
        RegInfo => 'Registrierungsdaten',
        RegistrationName => 'Username',
        RegistrationNumber => 'Registierungsnumber',
        PanelRegistration => 'Registrierungsdaten',
        RegistrationComments => 'Bemerkungen',
        Screenshots => 'Screenshots',
        Screenshot1 => 'erster Screenshot',
        Screenshot2 => 'zweiter Screenshot',
        Comments => 'Bemerkungen',
        Url => 'Webseite',
        General => 'Allgemein',
        Details => 'Details',
        Information => 'Information',

        FilterRatingSelect => 'Bewertung _mindestens...',
     );
}

1;
