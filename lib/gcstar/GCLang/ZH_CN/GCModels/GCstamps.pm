{
    package GCLang::ZH_CN::GCModels::GCstamps;

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
    
        CollectionDescription => '邮票收藏',
        Items => {0 => '邮票',
                  1 => '张邮票',
                  X => '邮票',
                  lowercase1 => '张邮票',
                  lowercaseX => '邮票'
                  },
        NewItem => '新邮票',

        General => '一般',
        Detail => '详细',
        Value => '价值',
        Notes => '笔记',
        Views => '观察',
        
        Name => '名称',
        Country => '国家',
        Year => '年份',
        Catalog => '类型',
        Number => '数目',
        Topic => '主题',
        Serie => '系列',
        Designer => '设计者',
        Engraver => '雕刻师',
        Type => '类型',
        Format => '形式',
        Description => '描述',
        Color => '颜色',
        Gum => '背胶',
        Paper => '纸张',
        Perforation => '穿孔',
        PerforationSize => '穿孔大小',
        CancellationType => '注销戳类型',
        Comments => '注释',
        PrintingVariety => '印刷变种',
        IssueDate => '发行日期',
        EndOfIssue => '结束发行',
        Issue => '发行',
        Grade => '分级',
        Status => '状态',
        Adjusted => '调整',
        Cancellation => '注销戳',
        CancellationCondition => '注销戳情况',
        GumCondition => '背胶情况',
        PerforationCondition => '穿孔情况',
        ConditionNotes => '状态笔记',
        Error => '错误',
        ErrorNotes => '错误记录',
        FaceValue => '面值',
        MintValue => '制造值',
        UsedValue => '使用值',
        PurchasedDate => '购买日期',
        Quantity => '数量',
        History => '历史',
        Picture1 => '图片1',
        Picture2 => '图片2',
        Picture3 => '图片3',

        AirMail => '航空邮件',
        MilitaryStamp => '军邮',
        Official => '公务邮件',
        PostageDue => '应付邮资类',
        Regular => '常规',
        Revenue => '税收',
        SpecialDelivery => '特别投递',
        StrikeStamp => '罢工邮票',
        TelegraphStamp => '电报邮票',
        WarStamp => '战争邮票',
        WarTaxStamp => '战争税邮票',

        Booklet => '小型张',
        BookletPane => '单张小型张',
        Card => '明信片',
        Coil => '卷状',
        Envelope => '信封',
        FirstDayCover => '首日封',
        Sheet => '联张',
        Single => '单张',

        Heliogravure => '凹版照相',
        Lithography => '平版',
        Offset => '胶印',
        Photogravure => '凹版印刷',
        RecessPrinting => '凹口印刷',
        Typography => '凸版印刷',
        
        OriginalGum => '原始背胶',
        Ungummed => '无胶',
        Regummed => '后加背胶',

        Chalky => '粉笔状',
        ChinaPaper => '瓷器般的',
        Coarsed => '粗糙',
        Glossy => '有光泽的',
        Granite => '花岗岩状',
        Laid => 'Laid纸',
        Manila => '马尼拉纸',
        Native => '本地纸',
        Pelure => 'Pelure纸',
        Quadrille => 'Quadrille纸',
        Ribbed => '棱纹纸',
        Rice => '宣纸',
        Silk => '丝纸',
        Smoothed => '光滑的',
        Thick => '厚',
        Thin => '薄',
        Wove => '布纹纸',

        CoarsedPerforation => '粗糙穿孔',
        CombPerforation => '梳状穿孔',
        CompoundPerforation => '混合穿孔',
        DamagedPerforation => '破坏了的穿孔',
        DoublePerforation => '双孔',
        HarrowPerforation => '耙状孔',
        LinePerforation => '线孔',
        NoPerforation => '无孔',

        CancellationToOrder => '整理注销戳',
        FancyCancellation => '精致注销戳',
        FirstDayCancellation => '首日戳',
        NumeralCancellation => '数字戳',
        PenMarked => '笔戳',
        RailroadCancellation => '铁路戳',
        SpecialCancellation => '特殊戳',

        Superb => '华丽',
        ExtraFine => '极精致',
        VeryFine => '非常精致',
        FineVeryFine => '精致/很精致',
        Fine => '精致',
        Average => '一般',
        Poor => '差',

        Owned => '持有者',
        Ordered => '已排序',
        Sold => '已售',
        ToSell => '待售',
        Wanted => '需要',

        LightCancellation => '轻戳',
        HeavyCancellation => '重戳',
        ModerateCancellation => '中等戳',

        MintNeverHinged => '未铰',
        MintLightHinged => '轻铰',
        HingedRemnant => '残余铰',
        HeavilyHinged => '重铰',
        LargePartOriginalGum => '大面积原始胶',
        SmallPartOriginalGum => '小面积原始胶',
        NoGum => '无胶',

        Perfect => '完美',
        VeryNice => '非常好',
        Nice => '好',
        Incomplete => '不完整',
     );
}

1;
