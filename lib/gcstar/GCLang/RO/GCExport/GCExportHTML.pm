{
    package GCLang::RO::GCExport::GCExportHTML;

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
        'ModelNotFound' => 'Invalid template file',
        'UseFile' => 'Use file specified below',
        'TemplateExternalFile' => 'Template file',
        'WithJS' => 'Foloseşte Javascript',
       	'FileTemplate' => 'Şablon :',
        'Preview' => 'Previzualizare',
        'NoPreview' => 'Previzualizare nedisponibilă',
        'Title' => 'Titlu pagină',
        'InfoFile' => 'Lista de filme este în fişierul: ',
        'InfoDir' => 'Imaginile sunt în: ',
        'HeightImg' => 'Înălţimea (în pixeli) a imaginilor exportate: ',
        'OpenFileInBrowser' => 'Deschide fişierul generat într-un navigator web',
        'Note' => 'Listă generată de către <a href="http://www.gcstar.org/">GCstar</a>',
        'InputTitle' => 'Introduceţi textul pentru căutare',
        'SearchType1' => 'Doar titlul',
        'SearchType2' => 'Informaţii complete',
        'SearchButton' => 'Caută',    
        'SearchTitle' => 'Afişează doar filmele ce se potrivesc criteriului precedent',
        'AllButton' => 'Toate',
        'AllTitle' => 'Afişează toate filmele',
        'Expand' => 'Extinde tot',
        'ExpandTitle' => 'Afişează toate informaţiile filmelor',
        'Collapse' => 'Restrânge tot',
        'CollapseTitle' => 'Ascunde informaţiile filmelor',
        'Borrowed' => 'Împrumutat de către: ',
        'NotBorrowed' => 'Disponibil',
        'Top' => 'Sus',
        'Bottom' => 'Bottom',
     );
}

1;
