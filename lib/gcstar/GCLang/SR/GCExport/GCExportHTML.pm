{
    package GCLang::SR::GCExport::GCExportHTML;

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
        'WithJS' => 'Koristi Javascript',
       	'FileTemplate' => 'Šabloni :',
        'Preview' => 'Vidi kako izgleda',
        'NoPreview' => 'Za ovaj šablon ne postoji slika',
        'Title' => 'Ime strane',
        'InfoFile' => 'Lista filmova je u fajlu: ',
        'InfoDir' => 'Slike su u: ',
        'HeightImg' => 'Visina (u pikselima) na koju će slika biti smanjena: ',
        'OpenFileInBrowser' => 'Otvori nastali fajl u internet brauzeru',
        'Note' => 'Lista napravljena pomoću <a href="http://www.gcstar.org/">GCstar</a>-a',
        'InputTitle' => 'Unesite reči koje tražite',
        'SearchType1' => 'Samo po naslovu',
        'SearchType2' => 'U svim podacima',
        'SearchButton' => 'Traži',    
        'SearchTitle' => 'Prikaži samo filmove koji odgovaraju prošlom kriterijumu',
        'AllButton' => 'Svi',
        'AllTitle' => 'Pokaži sve filmove',
        'Expand' => 'Otvori sve',
        'ExpandTitle' => 'Prikaži informacije za sve filmove',
        'Collapse' => 'Zatvori sve',
        'CollapseTitle' => 'Zatvori informacije za sve filmove',
        'Borrowed' => 'Pozajmljen: ',
        'NotBorrowed' => 'Ovde',
        'Top' => 'Na vrh',
        'Bottom' => 'Bottom',
     );
}

1;
