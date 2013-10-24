{
    package GCLang::ZH_CN::GCModels::GCboardgames;

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
    
        CollectionDescription => '桌面游戏收藏',
        Items => {0 => '份游戏',
                  1 => '份游戏',
                  X => '游戏'},
        NewItem => '新遊戏',
    
        Id => 'Id',
        Name => '名称',
        Original => '原名',
        Box => '遊戏盒图片',
        DesignedBy => '设计者',
        PublishedBy => '出版商',
        Players => '玩家人数',
        PlayingTime => '遊戏时间',
        SuggestedAge => '建议年龄',
        Released => '发布',
        Description => '描述',
        Category => '分类',
        Mechanics => '遊戏机制',
        ExpandedBy => '有哪些扩充',
        ExpansionFor => '扩充对象',
        GameFamily => '遊戏家族',
        IllustratedBy => '美工',
        Url => '网页',
        TimesPlayed => '所玩次数',
        CompleteContents => '內容完整',
        Copies => '序列号',
        Condition => '保存状态',
        Photos => '照片',
        Photo1 => '第一張图片',
        Photo2 => '第二張图片',
        Photo3 => '第三張图片',
        Photo4 => '第四張图片',
        Comments => '评论',

        Perfect => '完美',
        Good => '良好',
        Average => '普通',
        Poor => '糟糕',

        CompleteYes => '內容完整',
        CompleteNo => '丢失一部份',

        General => '一般',
        Details => '项目细节',
        Personal => '个人',
        Information => '信息',

        FilterRatingSelect => '评价至少到(_L)...',
     );
}

1;
