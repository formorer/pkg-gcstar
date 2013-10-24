{
    package GCLang::ZH::GCExport::GCExportHTML;

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
#  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
#
###################################################
    
    use strict;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
        'ModelNotFound' => '無效的模板檔',
        'UseFile' => '使用下方指定的檔案',
        'WithJS' => '使用Javascript',
       	'FileTemplate' => '模板',
        'Preview' => '預覽',
        'NoPreview' => '沒有預覽可用',
        'TemplateExternalFile' => '模板檔案',
        'Title' => '頁面標題',
        'InfoFile' => '檔案中的電影列表：',
        'InfoDir' => '圖片在：',
        'HeightImg' => '匯出圖片的高度（像素）',
        'OpenFileInBrowser' => '在瀏覽器打開產生的檔案',
        'Note' => '本列表由<a href="http://www.gcstar.org/">GCstar</a>產生',
        'InputTitle' => '輸入搜尋字串',
        'SearchType1' => '只有標題',
        'SearchType2' => '全部資訊',
        'SearchButton' => '搜尋',    
        'SearchTitle' => '只顯示匹配條件的電影',
        'AllButton' => '全部',
        'AllTitle' => '顯示全部電影',
        'Expand' => '展開全部',
        'ExpandTitle' => '顯示所有電影訊息',
        'Collapse' => '褶疊全部',
        'CollapseTitle' => '褶疊全部電影資訊',
        'Borrowed' => '被誰借走：',
        'NotBorrowed' => '可用',
        'Top' => '頂端',
        'Bottom' => '底部',
     );
}

1;
