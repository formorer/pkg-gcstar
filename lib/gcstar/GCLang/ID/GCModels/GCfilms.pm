{
    package GCLang::ID::GCModels::GCfilms;

    use utf8;
###################################################
#
#  Copyright 2005-2006 Tian
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
    
        CollectionDescription => 'Koleksi film',
        Items => 'Film',
        NewItem => 'Film Baru',
    
    
        Id => 'Id',
        Title => 'Judul',
        Date => 'Tanggal',
        Time => 'Durasi',
        Director => 'Sutradara',
        Country => 'Negara',
        MinimumAge => 'Minimum age',
        Genre => 'Genre',
        Image => 'Gambar',
        Original => 'Judul asli',
        Actors => 'Pemeran',
        Actor => 'Aktor',
        Role => 'Peran',
        Comment => 'Komentar',
        Synopsis => 'Sinopsis',
        Seen => 'Sudah dilihat',
        Number => '# of Media',
        Format => 'Media',
        Region => 'Region',
        Identifier => 'Identifier',
        Url => 'Halaman web',
        Place => 'Lokasi',
        Audio => 'Audio',
        Video => 'Format video',
        Trailer => 'File video',
        Serie => 'Seri',
        Rank => 'Ranking',
        Subtitles => 'Subtitles',
        Added => 'Add date',

        SeenYes => 'Sudah dilihat',
        SeenNo => 'Belum dilihat',

        AgeUnrated => 'Unrated',
        AgeAll => 'Semua Umur',
        AgeParent => 'Bimbingan Orangtua',

        Main => 'Main items',
        General => 'General',
        Details => 'Detail',

        Information => 'Informasi',
        Languages => 'Bahasa',
        Encoding => 'Encoding',

        FilterAudienceAge => 'Umur penonton',
        FilterSeenNo => '_Not Yet Viewed',
        FilterSeenYes => '_Already Viewed',
        FilterRatingSelect => 'Rating At _Least...',

        ExtractSize => 'Ukuran',
     );
}

1;
