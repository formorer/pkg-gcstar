{
    package GCLang::TR::GCModels::GCfilms;

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
    
        CollectionDescription => 'Film Koleksiyonu',
        Items => 'Filmler',
        NewItem => 'Film Ekle',
    
    
        Id => 'No',
        Title => 'Film Adı',
        Date => 'Yıl',
        Time => 'Süre',
        Director => 'Yönetmen',
        Country => 'Ülke',
        MinimumAge => 'Yaş Grubu',
        Genre => 'Türü',
        Image => 'Kapak',
        Original => 'Özgün Adı',
        Actors => 'Oyuncular',
        Actor => 'Actor',
        Role => 'Role',
        Comment => 'Yorumlar, Ödüller ve Diğer Bilgiler',
        Synopsis => 'Konu',
        Seen => 'İzlendi',
        Number => 'Sayısı',
        Format => 'Medya',
        Region => 'Region',
        Identifier => 'Identifier',
        Url => 'Web',
        Audio => 'Ses',
        Video => 'Video formatı',
        Trailer => 'Video dosyası',
        Serie => 'Koleksiyon',
        Rank => 'Sıralama',
        Subtitles => 'Altyazı(lar)',

        SeenYes => 'İzlendi',
        SeenNo => 'İzlenmedi',

        AgeUnrated => 'Değerlendirilmemiş',
        AgeAll => 'Herkes',
        AgeParent => 'Ebeveyn Kontrollü',

        Main => 'Genel Bilgiler',
        General => 'Genel',
        Details => 'Detay',

        Information => 'Bilgi',
        Languages => 'Dil(ler)',
        Encoding => 'Encoding',

        FilterAudienceAge => 'İzleyici grubu',
        FilterSeenNo => 'İzlen_medi',
        FilterSeenYes => 'İ_zlendi',
        FilterRatingSelect => '_Puanı En Az...',

        ExtractSize => 'Boyut',
     );
}

1;
