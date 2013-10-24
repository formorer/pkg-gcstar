{
    package GCLang::ZH_CN::GCModels::GCwines;

    use utf8;

#  Copyright 2007 Yves Martin
    
    use strict;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => '葡萄酒收藏',
        Items => {0 => '瓶葡萄酒',
                  1 => '瓶葡萄酒',
                  X => '葡萄酒'},
        NewItem => '新的葡萄酒',
    
        Name => '名称',
        Designation => '称呼',
        Vintage => '制造年份',
        Vineyard => '酿造地',
        Type => '种类',
        Grapes => '葡萄品种',
        Soil => '土壤类型',
        Producer => '制造者',
        Country => '国家',
        Volume => '容量(毫升)',
        Alcohol => '酒精浓度(%)',
        Medal => '奖章',

        Storage => '储存',
        Location => '位置',
        ShelfIndex => '架上索引',
        Quantity => '数量',
        Acquisition => '获得',
        PurchaseDate => '进货日期',
        PurchasePrice => '进货价格',
        Gift => '赠品',
        BottleLabel => '瓶上的标签',
        Website => '网路上的参考资料',

        Tasted => '已品尝',
        Comments => '评论',
        Serving => '服务',
        TastingField => '赏味笔记',

        General => '一般',
        Details => '细节',
        Tasting => '赏味',

        TastedNo => '未品尝过',
        TastedYes => '已品尝',

        FilterRange => '范围',
        FilterTastedNo => '还没品尝(_N)',
        FilterTastedYes => '已经品尝过了（_t）',
        FilterRatingSelect => '评价至少到(_l)...'

     );
}

1;
