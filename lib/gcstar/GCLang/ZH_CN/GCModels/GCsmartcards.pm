{
    package GCLang::ZH_CN::GCModels::GCsmartcards;

    use utf8;
###################################################
#
#  Copyright 2005-2010 Tian
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
    
        CollectionDescription => '智能卡收藏',
        Items => {0 => '张智能卡',
                  1 => '张智能卡',
                  X => '智能卡'},
        NewItem => '新智能卡',
        Currency => '通用',

	  Help => '字段帮助',
	  Help1 => '帮助',

# Traduction des Champs "Main"

        Main => '智能卡',

        Cover => '图片',

        Name => '名称',
        Exchange => '将卖出或交换',
        Wanted => '需要',
        Rating1 => '总体需求',
        TheSmartCard => '智能卡,前/后',

        Country => '国家',
        Color => '颜色',
        Type1 => '卡类型',
        Type2 => '芯片类型',
        Dimension => '长/宽/厚',

        Box => '盒',
        Chip => '芯片',
        Year1 => '版本年份',
        Year2 => '有效年份',
        Condition => '状态',
        Charge => '可充电卡',
        Variety => '变种',

        Edition => '样品数目',
        Serial => '序列号',
        Theme => '主题',

        Acquisition => '获得',

        Catalog0 => '目录',
        Catalog1 => 'Phonecote / Infopuce (YT)',
        Catalog2 => 'La Cote en Poche',

        Reference0 => '参考',
        Reference1 => 'Phonecote / Infopuce (YT)参考',
        Reference2 => 'La Cote en Poche参考',
        Reference3 => '其它参考',

        Quotationnew00 => '新卡报价',
        Quotationnew10 => 'Phonecote / Infopuce (YT)报价',
        Quotationnew20 => 'La Cote en Poche报价',
        Quotationnew30 => 'Cotation Autre',
        Quotationold00 => '二手卡报价',
        Quotationold10 => 'Phonecote / Infopuce (YT)报价',
        Quotationold20 => 'La Cote en Poche报价',
        Quotationold30 => '其它报价',

        Title1 => '名称',

        Unit => '单元/微粒数',

        Pressed => '压模类型',
        Location => '压模地点',

        Comments1 => '注释',

        Others => '杂项',
        Weight => '重量',
     );
}

1;
