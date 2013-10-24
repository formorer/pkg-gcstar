{
    package GCLang::ZH_CN::GCModels::GCfilms;

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
    
        CollectionDescription => '电影收藏',
        Items => {0 => '部电影',
                  1 => '部电影',
                  X => '电影'},
        NewItem => '新电影',
    
    
        Id => 'Id',
        Title => '名称',
        Date => '日期',
        Time => '片长',
        Director => '导演',
        Country => '国家',
        MinimumAge => '最小年龄限制',
        Genre => '类型',
        Image => '图片',
        Original => '原名',
        Actors => '演员',
        Actor => '演员',
        Role => '角色',
        Comment => '评论',
        Synopsis => '故事概览',
        Seen => '已观赏',
        Number => '媒体数量',
        Format => '媒体格式',
        Region => '地区',
        Identifier => 'ID',
        Url => '网页',
        Audio => '声音',
        Video => '影片格式',
        Trailer => '预告片',
        Serie => '系列',
        Rank => '等级',
        Subtitles => '字幕',

        SeenYes => '已观赏',
        SeenNo => '还没看',

        AgeUnrated => '未评级',
        AgeAll => '全年龄',
        AgeParent => '需要家长陪同',

        Main => '主项目',
        General => '一般',
        Details => '细节',

        Information => '资讯',
        Languages => '语言',
        Encoding => '编码',

        FilterAudienceAge => '观众年龄',
        FilterSeenNo => '还没看过(_N)',
        FilterSeenYes => '已观赏(_A)',
        FilterRatingSelect => '评价至少到(_L)...',

        ExtractSize => '尺寸',
     );
}

1;
