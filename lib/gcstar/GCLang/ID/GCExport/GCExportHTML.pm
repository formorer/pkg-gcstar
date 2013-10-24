{
    package GCLang::ID::GCExport::GCExportHTML;

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
        'ModelNotFound' => 'File Template keliru',
        'UseFile' => 'Gunakan file yang seperti dibawah',
        'TemplateExternalFile' => 'File template',
        'WithJS' => 'Gunakan Javascript',
       	'FileTemplate' => 'Template:',
        'Preview' => 'Pratayang',
        'NoPreview' => 'Tidak ada pratayang',
        'Title' => 'Judul halaman',
        'InfoFile' => 'Daftar film ada di file: ',
        'InfoDir' => 'Gambar ada di: ',
        'HeightImg' => 'Panjang (dalam pixel) dari gambar yang akan di ekspor: ',
        'OpenFileInBrowser' => 'Buka file di penjelajah web',
        'Note' => 'Daftar dibuat oleh <a href="http://www.gcstar.org/">GCstar</a>',
        'InputTitle' => 'Masukkan teks pencarian',
        'SearchType1' => 'Hanya judul',
        'SearchType2' => 'Informasi lengkap',
        'SearchButton' => 'Cari',    
        'SearchTitle' => 'Tampilkan semua film yang cocok dengan kriteria sebelumnya',
        'AllButton' => 'Semua',
        'AllTitle' => 'Tampilkan semua film',
        'Expand' => 'Expand all',
        'ExpandTitle' => 'Tampilkan semua informasi film',
        'Collapse' => 'Collapse all',
        'CollapseTitle' => 'Collapse all movies information',
        'Borrowed' => 'Dipinjam oleh: ',
        'NotBorrowed' => 'Tersedia',
        'Top' => 'Kembali ke atas',
        'Bottom' => 'Bawah',
     );
}

1;
