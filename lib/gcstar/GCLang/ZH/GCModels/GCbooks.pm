{
    package GCLang::ZH::GCModels::GCbooks;

    use utf8;
###################################################
#
#  Copyright 2005-2010 Tian
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
    
        CollectionDescription => '書本收藏集',
        Items => {0 => '本書',
                  1 => '本書',
                  X => '本書'},
        NewItem => '新書',
    
        Isbn => 'ISBN',
        Title => '標題',
        Cover => '封皮',
        Authors => '作者',
        Publisher => '出版商',
        Publication => '出版日期',
        Language => '語言',
        Genre => '類型',
        Serie => '系列',
        Rank => '等級',
        Bookdescription => '書籍描述',
        Pages => '頁數',
        Read => '已讀',
        Acquisition => '取得日期',
        Edition => '版本',
        Format => '格式',
        Comments => '評論',
        Url => '網頁',
        Translator => '譯者',
        Artist => '插畫家',
        DigitalFile => 'Digital version',

        General => '一般',
        Details => '書籍細節',

        ReadNo => '未讀',
        ReadYes => '已讀',
     );
}

1;
