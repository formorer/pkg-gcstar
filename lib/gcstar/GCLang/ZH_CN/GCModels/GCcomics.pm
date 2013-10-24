{
    package GCLang::ZH_CN::GCModels::GCcomics;

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
    
        CollectionDescription => '漫画收藏',
        Items => {0 => '本漫画',
                  1 => '本漫画',
                  X => '漫画'},
        NewItem => '新漫画',
    
    
        Id => 'Id',
        Name => '名称',
        Series => '书名',
        Volume => '卷号',
        Title => '标题',
        Writer => '脚本作者',
        Illustrator => '绘师',
        Colourist => '著色师',
        Publisher => '出版商',
        Synopsis => '故事提要',
        Collection => '收藏',
        PublishDate => '出版日期',
        PrintingDate => '印刷日期',
        ISBN => 'ISBN',
        Type => '印刷版本',
		Category => '分类',
        Format => '格式',
        NumberBoards => '印刷批号',
		Signing => '签名',
        Cost => '售价',
        Rating => '评价',
        Comment => '意见',
        Url => '网页',

        FilterRatingSelect => '评价至少到(_L)...',

        Main => '主项目',
        General => '一般信息',
        Details => '详细',
     );
}

1;
