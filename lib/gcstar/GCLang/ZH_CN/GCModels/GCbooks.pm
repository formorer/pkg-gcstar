{
    package GCLang::ZH_CN::GCModels::GCbooks;

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
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
###################################################
    
    use strict;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => '书本收藏',
        Items => {0 => '本书',
                  1 => '本书',
                  X => '书'},
        NewItem => '新书',
    
        Isbn => 'ISBN',
        Title => '標題',
        Cover => '封皮',
        Authors => '作者',
        Publisher => '出版商',
        Publication => '出版日期',
        Language => '语言',
        Genre => '类型',
        Serie => '系列',
        Rank => '等級',
        Bookdescription => '书籍描述',
        Pages => '页數',
        Read => '已读',
        Acquisition => '取得日期',
        Edition => '版本',
        Format => '格式',
        Comments => '评论',
        Url => '网页',
        Translator => '译者',
        Artist => '插画家',
        DigitalFile => '电子版',

        General => '一般',
        Details => '详细',

        ReadNo => '未读',
        ReadYes => '已读',
     );
}

1;
