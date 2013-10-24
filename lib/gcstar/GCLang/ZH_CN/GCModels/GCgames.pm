{
    package GCLang::ZH_CN::GCModels::GCgames;

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
    
        CollectionDescription => '电子游戏收藏',
        Items => {0 => '个游戏',
                  1 => '个游戏',
                  X => '游戏'},
        NewItem => '新游戏',
    
        Id => 'Id',
        Ean => 'EAN',
        Name => '名称',
        Platform => '平台',
        Players => '游戏人数',
        Released => '释出日期',
        Editor => '编辑者',
        Developer => '开发者',
        Genre => '类型',
        Box => '游戏盒图片',
        Case => '游戏盒',
        Manual => '说明手册',
        Completion => '完成度(%)',
        Executable => '可可执行文件',
        Description => '说明',
        Codes => '秘技',
        Code => '秘技',
        Effect => '效果',
        Secrets => '游戏中的秘密',
        Screenshots => '画面截图',
        Screenshot1 => '第一张截图',
        Screenshot2 => '第二张截图',
        Comments => '评论',
        Url => '网页',
        Unlockables => '可解锁的隐藏项目',
        Unlockable => '可解锁',
        Howto => '操作方法',
		Exclusive => '精选',
		Resolutions => '显示分辨率',
        InstallationSize => '大小',
        Region => '地区',
        SerialNumber => '序列号',        

        General => '概况',
        Details => '游戏细节',
        Tips => '小技巧',
        Information => '信息',

        FilterRatingSelect => '评价至少到(_L)...',
     );
}

1;
