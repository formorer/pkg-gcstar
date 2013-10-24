{
    package GCLang::TR::GCModels::GCgames;

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

        CollectionDescription => 'Oyun Koleksiyonu',
        Items => 'Oyunlar',
        NewItem => 'Yeni Oyun',
        
        Id => 'No',
        Ean => 'EAN',
        Name => 'Ad',
        Platform => 'Platform',
        Players => 'Oyuncu Sayısı',
        Released => 'Yayınlanma Tarihi',
        Editor => 'Editör',
        Developer => 'Developer',
        Genre => 'Kategori',
        Box => 'Kapak Resmi',
        Case => 'Case',
        Manual => 'Instructions manual',
        Completion => 'Tamamlanma (%)',
        Executable => 'Executable',
        Description => 'Bilgi',
        Codes => 'Kodlar',
        Code => 'Kod',
        Effect => 'Etki',
        Secrets => 'Sırlar',
        Screenshots => 'Ekran Görüntüleri',
        Screenshot1 => '1. Ekran Görüntüsü',
        Screenshot2 => '2. Ekran Görüntüsü',
        Comments => 'Comments',
        Url => 'Web Sayfası',
        Unlockables => 'Kilitlenmiş Özellikler',
        Unlockable => 'Kilitlenen',
        Howto => 'Nasıl çözülür?',
        Exclusive => 'Exclusive',
        Resolutions => 'Display resolutions',
        InstallationSize => 'Size',
        Region => 'Region',
        SerialNumber => 'Serial Number',        
        
        General => 'Genel',
        Details => 'Detay',
        Tips => 'İpucu',
        Information => 'Bilgi',
        
        FilterRatingSelect => 'En _Az Puanı...',
     );
}

1;
