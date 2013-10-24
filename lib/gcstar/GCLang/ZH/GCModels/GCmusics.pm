{
    package GCLang::ZH::GCModels::GCmusics;

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
#  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
#
###################################################
    
    use strict;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => '音樂收藏集',
        Items => {0 => '張專輯',
                  1 => '張專輯',
                  X => '張專輯'},
        NewItem => '新專輯',
    
        Unique => 'ISRC/EAN',
        Title => '標題',
        Cover => '封面',
        Artist => '藝術家',
        Format => '格式',
        Running => '播放時間',
        Release => '釋出日期',
        Genre => '類型',
        Origin => '原始作品',

#For tracks list
        Tracks => '曲目列表',
        Number => '編號',
        Track => '標題',
        Time => '時間',

        Composer => '作曲家',
        Producer => '製片人',
        Playlist => '播放列表',
        Comments => '評論',
        Label => '標籤',
        Url => '網頁',

        General => '一般',
        Details => '專輯細節',
     );
}

1;
