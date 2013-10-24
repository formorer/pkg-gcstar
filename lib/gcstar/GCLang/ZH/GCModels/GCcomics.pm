{
    package GCLang::ZH::GCModels::GCcomics;

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
    
        CollectionDescription => '漫畫收藏集',
        Items => {0 => '本漫畫',
                  1 => '本漫畫',
                  X => '本漫畫'},
        NewItem => '新漫畫',
    
    
        Id => 'Id',
        Name => '名稱',
        Series => '書名',
        Volume => '卷號',
        Title => '標題',
        Writer => '腳本作者',
        Illustrator => '繪師',
        Colourist => '著色師',
        Publisher => '出版商',
        Synopsis => '故事提要',
        Collection => '收藏',
        PublishDate => '出版日期',
        PrintingDate => '印刷日期',
        ISBN => 'ISBN',
        Type => '印刷版本',
		Category => '分類',
        Format => '格式',
        NumberBoards => '印刷批號',
		Signing => '簽名',
        Cost => '售價',
        Rating => '評價',
        Comment => '意見',
        Url => '網頁',

        FilterRatingSelect => '評價至少到(_L)...',

        Main => '主項目',
        General => '一般資訊',
        Details => '細節',
     );
}

1;
