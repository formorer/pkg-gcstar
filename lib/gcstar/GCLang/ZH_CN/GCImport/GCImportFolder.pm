{
    package GCLang::ZH_CN::GCImport::GCImportFolder;

    use utf8;
###################################################
#
#  Copyright 2005-2010 Tian
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
    use GCLang::GCLangUtils;

    our @EXPORT = qw(%lang);

    our %lang = (
        'Name' => '目录',
        'Recursive' => '递归搜索子目录',
        'Suffixes' => '后缀名',
        'SuffixesTooltip' => '用逗号分隔打算处理的后缀列表',
        'Remove' => '从名称中删除',
        'RemoveTooltip' => '用逗号分隔要从名称中删除的文字列表',
        'Ask'=> '询问',
        'AskEnd'=> '最后一起询问',
        'AddWithoutInfo'=> '添加，不包括信息',
        'DontAdd'=> '不添加',
        'TakeFirst' => '优先选择',
        'MultipleResult'=> '多个结果',
        'MultipleResultTooltip'=> '当插件有多个返回结果时怎么办？',
        'RemoveWholeWord' => '只有一个单词时删除',
        'NoResult'=> '没有结果',
        'NoResultTooltip'=> '当插件没有返回结果时怎么办？',
        'RemoveTooltipWholeWord' => '只有当只出现一个单词时删除单词',
        'RemoveRegularExpr' => '正则表达式',
        'RemoveTooltipRegularExpr' => '将\'从名称中删除\'作为perl正则表达式',
        'SkipFileAlreadyInCollection' => '只添加新文件',
        'SkipFileAlreadyInCollectionTooltip' => '只添加没有在收藏中的文件',
        'SkipFileNo' => '否',
        'SkipFileFullPath' => '基于完整路径',
        'SkipFileFileName' => '基于文件名',
        'SkipFileFileNameAndUpdate' => '基于文件名(但更新收藏中的路径)',
        'InfoFromFileNameRegExp' => '用正则表达式分析文件名',
        'InfoFromFileNameRegExpTooltip' => '从文件名(删除后缀名)中提取提取信息.\n如不需要留空.\n已知字段:\n$T:标题,$A:字母表示标题, $Y:发行日期,$S:季,$E:集,$N:字母表示系列名称,$x:部,$y:总部数',

        'InfoFromFileNameRegExp' => '用正则表达式分析文件名',
        'InfoFromFileNameRegExpTooltip' => '从文件名(删除后缀名)中提取提取信息.\n如不需要留空.\n已知字段:\n$T:标题,$A:文章, $Y:年份, $S:季, $E:期, $N:卷名'
     );

    # As this plugin shares some values with ImportList, it adds them from it
    importTranslation('List');
}

1;
