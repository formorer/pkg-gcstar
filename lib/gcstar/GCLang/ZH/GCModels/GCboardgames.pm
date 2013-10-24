{
    package GCLang::ZH::GCModels::GCboardgames;

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
    
        CollectionDescription => '桌上遊戲收藏集',
        Items => {0 => '份遊戲',
                  1 => '份遊戲',
                  X => '份遊戲'},
        NewItem => '新遊戲',
    
        Id => 'Id',
        Name => '名稱',
        Original => '原名',
        Box => '遊戲盒圖片',
        DesignedBy => '設計者',
        PublishedBy => '出版商',
        Players => '遊玩者人數',
        PlayingTime => '遊戲時間',
        SuggestedAge => '建議年齡',
        Released => '釋出',
        Description => '描述',
        Category => '分類',
        Mechanics => '遊戲機制',
        ExpandedBy => '有哪些擴充',
        ExpansionFor => '擴充對象',
        GameFamily => '遊戲家族',
        IllustratedBy => '繪師',
        Url => '網頁',
        TimesPlayed => '遊玩次數',
        CompleteContents => '內容完整',
        Copies => 'No. of copies',
        Condition => '保存狀態',
        Photos => '照片',
        Photo1 => '第一張圖片',
        Photo2 => '第二張圖片',
        Photo3 => '第三張圖片',
        Photo4 => '第四張圖片',
        Comments => '評論',

        Perfect => '完美',
        Good => '良好',
        Average => '普通',
        Poor => '糟糕',

        CompleteYes => '內容完整',
        CompleteNo => '遺失一部份',

        General => '一般',
        Details => '項目細節',
        Personal => '個人',
        Information => '資訊',

        FilterRatingSelect => '評價至少到(_L)...',
     );
}

1;
