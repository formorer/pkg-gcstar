{
    package GCLang::ZH_CN::GCModels::GCsoftware;

    use utf8;
###################################################
#
#  Copyright 2005-2009 Tian
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
    
        CollectionDescription => '计算机软件收藏',
        Items => {0 => '个软件',
                  1 => '个软件',
                  X => '软件',
                  lowercase1 => '个软件',
                  lowercaseX => '软件'},
        NewItem => '新软件',
    
        Id => 'Id',
        Ean => 'EAN',
        Name => '名称',
        Platform => '平台',
        Released => '发布日期',
        Homepage => '主页',		
        Editor => '编辑',
        Developer => '开发人员',
        Category => '类型',
		NumberOfCopies => '个数',
		Price => '价格',
        Box => '盒装图片',
        Case => '例子',
        Manual => '操作指南',
        Executable => '可执行',
        Description => '描述',
        License => '版权',
        Commercial => '商业软件',
		FreewareNoncommercial => '免费软件',		
		OtherOpenSource => '其它开源软件',
		PublicDomain => '公共软件',
		OtherLicense => '其它',
		Registration => '注册',				
		RegistrationInfo => '注册信息',		
		RegInfo => '注册信息',
		RegistrationName => '用户名',
		RegistrationNumber => '注册号',		
		PanelRegistration => '注册信息',	
		RegistrationComments => '添加信息或注释',
        Screenshots => '截图',
        Screenshot1 => '截图1',
        Screenshot2 => '截图2',
        Comments => '注释',
        Url => '网页',
        General => '一般',
        Details => '详细',
        Information => '信息',

        FilterRatingSelect => '评价至少(_L)...',
     );
}

1;
