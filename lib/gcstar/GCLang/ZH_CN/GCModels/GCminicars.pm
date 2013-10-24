{
    package GCLang::ZH_CN::GCModels::GCminicars;

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
    
        CollectionDescription => '小车收藏',
        Items => {0 => '辆汽车',
                  1 => '辆汽车',
                  X => '汽车',
                  lowercase1 => '辆汽车',
                  lowercaseX => '汽车'
                  },
        NewItem => '新汽车',
        Currency => '通用性',

# Main fields

        Main => '主要信息',

        Name => '名称',
        Exchange => '待售或待换',
        Wanted => '需要',
        Rating1 => '主评价',
        Picture1 => '主图片',
        Scale => '尺寸',
        Manufacturer => '制造商',
        Constructor => '设计师',
        Type1 => '类型',
        Modele => '型号',
        Version => '版本',
        Color => '型号颜色',
        Pub => '广告',
        Year => '年份',
        Reference => '参考',
        Kit => '工具列表',
        Transformation => '个性变化',
        Comments1 => '注释',

# Details fields

        Details => '详细',

        MiscCharacteristics => '多方面特性',
        Material => '材料',
        Molding => '模制',
        Condition => '状态',
        Edition => '版本',
        Collectiontype => '收集名称',
        Serial => '系列',
        Serialnumber => '序列号',
        Designed => '设计日期',
        Madein => '制造日期',
        Box1 => 'Box种类',
        Box2 => 'Box描述',
        Containbox => 'Box内容',
        Rating2 => '实用',
        Rating3 => '完美',
        Acquisition => '获得日期',
        Location => '获得地点',
        Buyprice => '获得价格',
        Estimate => '估价',
        Comments2 => '评论',
        Decorationset => '装饰',
        Characters => '性质',
        CarFromFilm => '电影汽车',
        Filmcar => '与汽车相关电影',
        Filmpart => '电影部/集',
        Parts => '数目',
        VehiculeDetails => '详细',
        Detailsparts => '细节部分',
        Detailsdecorations => '装饰种类',
        Decorations => '装饰数量',
        Lwh => '长/宽/高',
        Weight => '重量',
        Framecar => '底盘',
        Bodycar => '车身',
        Colormirror => '型号颜色',
        Interior => '内部',
        Wheels => '车轮',
        Registrationnumber1 => '前方注册号',
        Registrationnumber2 => '后部注册号',
        RacingCar => '赛车',
        Course => '比赛',
        Courselocation => '比赛地点',
        Courseyear => '比赛日期',
        Team => '团队',
        Pilots => '赛车手',
        Copilots => '副驾',
        Carnumber => '车号',
        Pub2 => '广告商',
        Finishline => '完美等级',
        Steeringwheel => '方向盘位置',


# Catalogs fields

        Catalogs => '目录',

        OfficialPicture => '官方图片',
        Barcode => '条形码',
        Referencemirror => '参考',
        Year3 => '可得日期',
        CatalogCoverPicture => '封面',
        CatalogPagePicture => '页数',
        Catalogyear => '目录年份',
        Catalogedition => '目录版本',
        Catalogpage => '目录页数',
        Catalogprice => '目录价格',
        Personalref => '个人参考',
        Websitem => '汽车制造商网站',
        Websitec => '实际制造商网站',
        Websiteo => '有用链接',
        Comments3 => '注释',

# Pictures fields

        Pictures => '图片',

        OthersComments => '总评分',
        OthersDetails => '其它细节',
        Top1 => '上',
        Back1 => '下',
        AVG => '左前',
        AV => '前',
        AVD => '右前',
        G => '左',
        BOX => 'Box',
        D => '右',
        ARG => '左后',
        AR => '后',
        ARD => '右后',
        Others => '杂项',

# PanelLending fields

        LendingExplanation => '临时展览中的有用交换',
        PanelLending => '租借(展览用)',
        Comments4 => '注释',

# Realmodel fields

        Realmodel => '真实汽车',

        Difference => '与小图的不同',
        Front2 => '前',
        Back2 => '后',
        Comments5 => '注释',

        References => '参考',

     );
}

1;
