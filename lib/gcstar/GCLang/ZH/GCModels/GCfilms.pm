{
    package GCLang::ZH::GCModels::GCfilms;

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
    
        CollectionDescription => '電影收藏集',
        Items => {0 => '部電影',
                  1 => '部電影',
                  X => '部電影'},
        NewItem => '新電影',
    
    
        Id => 'Id',
        Title => '名稱',
        Date => '日期',
        Time => '片長',
        Director => '導演',
        Country => '國家',
        MinimumAge => '最小年齡限制',
        Genre => '類型',
        Image => '圖片',
        Original => '原名',
        Actors => '演員',
        Actor => '演員',
        Role => '角色',
        Comment => '評論',
        Synopsis => '故事概覽',
        Seen => '已觀賞',
        Number => '媒體數量',
        Format => '媒體格式',
        Region => '地區',
        Identifier => 'Identifier',
        Url => '網頁',
        Audio => '聲音',
        Video => '影片格式',
        Trailer => '預告片',
        Serie => '系列',
        Rank => '等級',
        Subtitles => '字幕',

        SeenYes => '已觀賞',
        SeenNo => '還沒看',

        AgeUnrated => '未評級',
        AgeAll => '全年齡',
        AgeParent => '需要家長陪同',

        Main => '主項目',
        General => '一般',
        Details => '細節',

        Information => '資訊',
        Languages => '語言',
        Encoding => '編碼',

        FilterAudienceAge => '觀眾年齡',
        FilterSeenNo => '還沒看過(_N)',
        FilterSeenYes => '已觀賞(_A)',
        FilterRatingSelect => '評價至少到(_L)...',

        ExtractSize => '尺寸',
     );
}

1;
