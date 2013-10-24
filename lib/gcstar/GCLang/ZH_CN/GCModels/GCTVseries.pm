{
    package GCLang::ZH_CN::GCModels::GCTVseries;

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
    use GCLang::GCLangUtils;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => '电视剧(系列)收藏',
        Items => '个系列',
        NewItem => '新系列',
        Name => '系列名称',
        Season => '季',
        Part => '部',
        Episodes => '集',
        FirstAired => '首播',
        Time => '每集长度',
        Producer => '制片商',
        Music => '音乐',
     );
     importTranslation('Films');
}

1;
