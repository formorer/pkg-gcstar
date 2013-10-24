{
    package GCLang::DE::GCImport::GCImportScanner;

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
        'Name' => 'Barcodescanner',
        'Type' => 'Art des Scanners',
        'Local' => 'Lokal (Tastaturersatz)',
        'Network' => 'Netzwerk (z.B.: GCstar Scanner for Android)',
        'Port' => 'zu nutzender Port',
        'Plugin' => 'zu nutzende Website',
        'UseFirst' => 'Verwende erstes von mehreren Ergebnissen',
        'Waiting' => 'Warte auf Barcode',
        'EAN' => 'Barcode',
        'ScanPrompt' => 'Element scannen oder Vorgang beenden',
        'ScanOtherPrompt' => 'Ein anderes Element scannen oder Vorgang beenden',
        'Previous' => '"%s" wird hinzugefügt.',
        'NothingFound' => 'Für "%s" wurde nichts gefunden. Ein leeres Element wird hinzugefügt.',
        'Terminate' => 'Vorgang beenden',
     );
}

1;
