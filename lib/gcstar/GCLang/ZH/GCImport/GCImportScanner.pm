{
    package GCLang::ZH::GCImport::GCImportScanner;

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
        'Name' => 'Barcode scanner',
        'Type' => 'Scanner type',
        'Local' => 'Local (used as a keyboard)',
        'Network' => 'Network (eg: GCstar Scanner for Android)',
        'Port' => 'Port to listen on',
        'Plugin' => 'Site to be used',
        'UseFirst' => 'Select first one if many results',
        'Waiting' => 'Waiting for barcode',
        'EAN' => 'Barcode',
        'ScanPrompt' => 'Scan an item or press on Done',
        'ScanOtherPrompt' => 'Scan another item or press on Done',
        'Previous' => '"%s" will be added.',
        'NothingFound' => 'Nothing was found for "%s". An empty item will be added.',
        'Terminate' => 'Done',
     );
}

1;
