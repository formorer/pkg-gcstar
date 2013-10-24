{
    package GCLang::TR::GCExport::GCExportHTML;

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
        'WithJS' => 'Javascript kullan',
       	'FileTemplate' => 'Biçem :',
        'Preview' => 'Önizleme',
        'NoPreview' => 'Önizleme yok',
        'Title' => 'Sayfa başlığı',
        'InfoFile' => 'Film listesinin bulunduğu dosya: ',
        'InfoDir' => 'Kapak dosyası: ',
        'HeightImg' => 'Kapak resmi yüksekliği (piksel olarak): ',
        'OpenFileInBrowser' => 'Oluşturulan dosyayı tarayıcıda aç',
        'Note' => 'Bu liste <a href="http://www.gcstar.org/">GCstar</a> yazılımıyla oluşturulmuştur.',
        'InputTitle' => 'Arama için başlık giriniz',
        'SearchType1' => 'Sadece film adı',
        'SearchType2' => 'Tüm bilgiler',
        'SearchButton' => 'Ara',    
        'SearchTitle' => 'Sadece bir önceki kritere uyanları göster',
        'AllButton' => 'Tümü',
        'AllTitle' => 'Tüm filmleri göster',
        'Expand' => 'Genişlet',
        'ExpandTitle' => 'Tüm filmlerin bilgilerini göster',
        'Collapse' => 'Hepsini kapat',
        'CollapseTitle' => 'Tüm film bilgilerini kapat',
        'Borrowed' => 'Ödünç alan: ',
        'NotBorrowed' => 'Arşivde',
        'Top' => 'Başa dön',
        'Bottom' => 'Bottom',
     );
}

1;
