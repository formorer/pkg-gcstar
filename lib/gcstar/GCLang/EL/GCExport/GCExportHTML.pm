{
    package GCLang::EL::GCExport::GCExportHTML;

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
        'ModelNotFound' => 'Άκυρο αρχείο μοντέλου',
        'UseFile' => 'Χρήση του κατωτέρω αρχείου',
        'WithJS' => 'Χρήση Javascript',
       	'FileTemplate' => 'Μοντέλο',
        'Preview' => 'Προεπισκόπηση',
        'NoPreview' => 'Δεν είναι διαθέσιμη η προεπισκόπιση',
        'TemplateExternalFile' => 'Αρχείο μοντέλου',
        'Title' => 'Τίτλος σελίδας',
        'InfoFile' => 'Η λίστα βρίσκεται μέσα στο αρχείο: ',
        'InfoDir' => 'Οι εικόνες είναι στο: ',
        'HeightImg' => 'Ύψος (in pixels) των εικόνων',
        'OpenFileInBrowser' => 'Άνοιγμα του δημιουργημένου αρχείου στον web browser',
        'Note' => 'Η λίστα δημιουργήθηκε από <a href="http://www.gcstar.org/">GCstar</a>',
        'InputTitle' => 'Εισάγετε το κείμενο για αναζήτηση',
        'SearchType1' => 'Τίτλος μόνο',
        'SearchType2' => 'Όλες οι πληροφορίες',
        'SearchButton' => 'Αναζήτηση',    
        'SearchTitle' => 'Εμφάνιση μόνο των ταινιών που αντιστοιχούν στα προηγούμενα κριτήρια',
        'AllButton' => 'Όλα',
        'AllTitle' => 'Εμφάνιση όλων των ταινιών',
        'Expand' => 'Επέκταση όλων',
        'ExpandTitle' => 'Εμφάνιση πληροφοριών όλων των ταινιών',
        'Collapse' => 'Απόκρυψη όλων',
        'CollapseTitle' => 'Απόκρυψη πληροφοριών όλων των ταινιών',
        'Borrowed' => 'Δανείστηκε από : ',
        'NotBorrowed' => 'Διαθέσιμο',
        'Top' => 'Επάνω',
        'Bottom' => 'Κάτω',
     );
}

1;
