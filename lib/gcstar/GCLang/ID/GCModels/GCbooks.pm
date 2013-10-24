{
    package GCLang::ID::GCModels::GCbooks;

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
    
        CollectionDescription => 'Koleksi buku',
        Items => 'Buku',
        NewItem => 'Buku baru',
    
        Isbn => 'ISBN',
        Title => 'Judul',
        Cover => 'Sampul',
        Authors => 'Pengarang',
        Publisher => 'Penerbit',
        Publication => 'Tanggal diterbitkan',
        Language => 'Bahasa',
        Genre => 'Genre',
        Serie => 'Seri',
        Rank => 'Ranking',
        Bookdescription => 'Deskripsi',
        Pages => 'Halaman',
        Read => 'Baca',
        Acquisition => 'Acquisition date',
        Location => 'Lokasi',
        Edition => 'Edisi',
        Format => 'Format',
        Comments => 'Komentar',
        Url => 'Halaman web',
        Translator => 'Translator',
        Artist => 'Artist',
        DigitalFile => 'Digital version',

        General => 'General',
        Details => 'Detail',

        ReadNo => 'Belum dibaca',
        ReadYes => 'Sudah dibaca',
     );
}

1;
