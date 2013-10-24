{
    package GCLang::ZH_CN::GCModels::GCmusics;

    use utf8;
###################################################
#
#  Copyright 2005-2007 Tian
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
    
        CollectionDescription => '音乐收藏',
        Items => {0 => '张专辑',
                  1 => '张专辑',
                  X => '专辑'},
        NewItem => '新专辑',
    
        Unique => 'ISRC/EAN',
        Title => '标题',
        Cover => '封面',
        Artist => '艺术家',
        Format => '格式',
        Running => '播放时间',
        Release => '发布日期',
        Genre => '类型',
        Origin => '原始作品',

#For tracks list
        Tracks => '曲目列表',
        Number => '编号',
        Track => '标题',
        Time => '时间',

        Composer => '作曲家',
        Producer => '制作人',
        Playlist => '播放列表',
        Comments => '评论',
        Label => '标签',
        Url => '网页',

        General => '一般',
        Details => '专辑细节',
     );
}

1;
