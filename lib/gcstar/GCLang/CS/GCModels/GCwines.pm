{
    package GCLang::CS::GCModels::GCwines;

    use utf8;

#  Copyright 2007 Yves Martin
    
    use strict;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => 'Sbírka vín',
        Items => sub {
          my $number = shift;
          return 'Víno' if $number eq '1';
          return 'Vína' if $number =~ /(?<!1)[2-4]$/;
          return 'Vín';
        },
        NewItem => 'Nové víno',
    
        Name => 'Název',
        Designation => 'Zatřídění',
        Vintage => 'Ročník',
        Vineyard => 'Vinice',
        Type => 'Typ',
        Grapes => 'Hrozny',
        Soil => 'Půda',
        Producer => 'Výrobce',
        Country => 'Původ',
        Volume => 'Obsah (ml)',
        Alcohol => 'Alkohol (%)',
        Medal => 'Ocenění/Vyznamenání',

        Storage => 'Uskladnění',
        Location => 'Umístění',
        ShelfIndex => 'Index',
        Quantity => 'Množství',
        Acquisition => 'Přírůstek',		#Acquisition
        PurchaseDate => 'Datum nákupu',
        PurchasePrice => 'Nákupní cena',
        Gift => 'Dar',
        BottleLabel => 'Viněta',
        Website => 'Zmínka na webu',

        Tasted => 'Ochutnáno',
        Comments => 'Poznámky',
        Serving => 'Servírování',		#Serving
        TastingField => 'Poznámky k jakkosti',	#Testing notes

        General => 'Hlavní',
        Details => 'Detaily',
        Tasting => 'Ochutnávka',

        TastedNo => 'Neochutnáno',
        TastedYes => 'Ochutnáno',

        FilterRange => '_Rozmezí',
        FilterTastedNo => '_Neochutnáno',
        FilterTastedYes => '_Ochutnáno',
        FilterRatingSelect => '_Hodnocení minimálně...'

     );
}

1;
