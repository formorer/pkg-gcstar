{
    package GCLang::ZH_CN::GCModels::GCperiodicals;

    use utf8;
###################################################
#
#  Copyright 2005-2010 Christian Jodar
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
    
        CollectionDescription => '期刊收藏',
        Items => {0 => '期刊',
                  1 => '本期刊',
                  X => '期刊',
                  lowercase1 => '本期刊',
                  lowercaseX => '期刊'
                  },
        NewItem => '新期刊',
    
        Title => '名称',
        Cover => '封面',
        Periodical => '周期',
        Number => '数',
        Date => '日期',
        Subject => '主题',
        Articles => '文章',

        General => '一般',
     );
}

1;
