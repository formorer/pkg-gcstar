{
    package GCLang::ZH::GCModels::GCcoins;

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
    
        CollectionDescription => '錢幣收藏集',
        Items => {0 => '份錢幣',
                  1 => '份錢幣',
                  X => '份錢幣'},
        NewItem => '新錢幣',

        Name => '名稱',
        Country => '國家',
        Year => '年份',
        Currency => '貨幣',
        Value => '價值',
        Picture => '主要圖片',
        Diameter => '直徑',
        Metal => '金屬',
        Edge => '邊緣',
        Edge1 => '邊緣 1',
        Edge2 => '邊緣 2',
        Edge3 => '邊緣 3',
        Edge4 => '邊緣 4',
        Head => '正面（人頭）',
        Tail => '反面',
        Comments => '評論',
        History => '歷史',
        Website => '網站',
        Estimate => '估價',
        References => '參考資料',
        Type => '類型',
        Coin => '硬幣',
        Banknote => '鈔票',

        Main => '主要',
        Description => '描述',
        Other => '其他訊息',
        Pictures => '圖片',
        
        Condition => 'PCGS狀態分級',
        Grade1  => 'BS-1',
        Grade2  => 'FR-2',
        Grade3  => 'AG-3',
        Grade4  => 'G-4',
        Grade6  => 'G-6',
        Grade8  => 'VG-8',
        Grade10 => 'VG-10',
        Grade12 => 'F-12',
        Grade15 => 'F-15',
        Grade20 => 'VF-20',
        Grade25 => 'VF-25',
        Grade30 => 'VF-30',
        Grade35 => 'VF-35',
        Grade40 => 'XF-40',
        Grade45 => 'XF-45',
        Grade50 => 'AU-50',
        Grade53 => 'AU-53',
        Grade55 => 'AU-55',
        Grade58 => 'AU-58',
        Grade60 => 'MS-60',
        Grade61 => 'MS-61',
        Grade62 => 'MS-62',
        Grade63 => 'MS-63',
        Grade64 => 'MS-64',
        Grade65 => 'MS-65',
        Grade66 => 'MS-66',
        Grade67 => 'MS-67',
        Grade68 => 'MS-68',
        Grade69 => 'MS-69',
        Grade70 => 'MS-70',
    
     );
}

1;
