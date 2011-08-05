{
    package GCLang::ZH::GCModels::GCwines;

    use utf8;

#  Copyright 2007 Yves Martin
    
    use strict;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => '葡萄酒收藏',
        Items => {0 => '葡萄酒',
                  1 => '葡萄酒',
                  X => '葡萄酒'},
        NewItem => '新的葡萄酒',
    
        Name => '名稱',
        Designation => '稱呼',
        Vintage => '製造年份',
        Vineyard => '釀造地',
        Type => '種類',
        Grapes => '葡萄品種',
        Soil => '土壤類型',
        Producer => '製造者',
        Country => '國家',
        Volume => '容量(毫升)',
        Alcohol => '酒精濃度(%)',
        Medal => '獎章',

        Storage => '儲存',
        Location => '位置',
        ShelfIndex => '架上索引',
        Quantity => '數量',
        Acquisition => 'Acquisition',
        PurchaseDate => '進貨日期',
        PurchasePrice => '進貨價格',
        Gift => '贈品',
        BottleLabel => '瓶上的標籤',
        Website => '網路上的參考資料',

        Tasted => '已品嘗',
        Comments => '評論',
        Serving => '服務',
        TastingField => '賞味筆記',

        General => '一般',
        Details => '細節',
        Tasting => '賞味',

        TastedNo => '未品嘗過',
        TastedYes => '已品嘗',

        FilterRange => '範圍',
        FilterTastedNo => '還沒品嘗(_N)',
        FilterTastedYes => '已經品嘗過了（_t）',
        FilterRatingSelect => '評價至少到(_l)...'

     );
}

1;
