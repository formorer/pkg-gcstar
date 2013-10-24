{
    package GCLang::ZH::GCModels::GCgames;

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
    
        CollectionDescription => '電子遊戲收藏集',
        Items => {0 => '個遊戲',
                  1 => '個遊戲',
                  X => '個遊戲'},
        NewItem => '新遊戲',
    
        Id => 'Id',
        Ean => 'EAN',
        Name => '名稱',
        Platform => '平台',
        Players => '遊戲人數',
        Released => '釋出日期',
        Editor => '編輯者',
        Developer => '開發者',
        Genre => '類型',
        Box => '遊戲盒圖片',
        Case => '遊戲盒',
        Manual => '說明手冊',
        Completion => '完成度(%)',
        Executable => '可執行檔',
        Description => '說明',
        Codes => '秘技',
        Code => '秘技',
        Effect => '效果',
        Secrets => '遊戲中的秘密',
        Screenshots => '畫面截圖',
        Screenshot1 => '第一張截圖',
        Screenshot2 => '第二張截圖',
        Comments => '評論',
        Url => '網頁',
        Unlockables => '可被解鎖的隱藏項目',
        Unlockable => '項目',
        Howto => '作法',
        Exclusive => 'Exclusive',
        Resolutions => 'Display resolutions',
        InstallationSize => 'Size',
        Region => 'Region',
        SerialNumber => 'Serial Number',        

        General => '一般',
        Details => '遊戲細節',
        Tips => '小技巧',
        Information => '訊息',

        FilterRatingSelect => '評價至少到(_L)...',
     );
}

1;
