{
    package GCLang::ZH_CN::GCExport::GCExportHTML;

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
        'ModelNotFound' => '无效模板',
        'UseFile' => '使用文件',
        'WithJS' => '使用Javascript',
       	'FileTemplate' => '模板',
        'Preview' => '预览',
        'NoPreview' => '没有预览',
        'TemplateExternalFile' => '模板文件',
        'Title' => '页面标题',
        'InfoFile' => '列表所在文件：',
        'InfoDir' => '图片目录',
        'HeightImg' => '导出图片的高度（像素）',
        'OpenFileInBrowser' => '在浏览器中打开生成的文件',
        'Note' => '本列表由<a href="http://www.gcstar.org/">GCstar</a>生成',
        'InputTitle' => '输入搜索文字',
        'SearchType1' => '只有标题',
        'SearchType2' => '全部信息',
        'SearchButton' => '搜索',    
        'SearchTitle' => '只显示匹配条件的电影',
        'AllButton' => '全部',
        'AllTitle' => '显示全部电影',
        'Expand' => '展开全部',
        'ExpandTitle' => '显示所有电影信息',
        'Collapse' => '折叠全部',
        'CollapseTitle' => '折叠全部电影信息',
        'Borrowed' => '被谁借走：',
        'NotBorrowed' => '可用',
        'Top' => '顶部',
        'Bottom' => '底部',
     );
}

1;
