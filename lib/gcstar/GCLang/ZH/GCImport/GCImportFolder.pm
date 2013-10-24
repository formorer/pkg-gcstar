{
    package GCLang::ZH::GCImport::GCImportFolder;

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
#  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
#
###################################################
    
    use strict;
    use base 'Exporter';
    use GCLang::GCLangUtils;

    our @EXPORT = qw(%lang);

    our %lang = (
        'Name' => '資料夾',
        'Recursive' => '遞迴掃描子目錄',
        'Suffixes' => '後綴或副檔名',
        'SuffixesTooltip' => '用逗點分隔打算處理的後綴或副檔名列表',
        'Remove' => 'To be removed from names',
        'RemoveTooltip' => 'A comma-seperated list of words that should be removed from file names to create the fetched names',
        'Ask'=> 'Ask',
        'AskEnd'=> 'Ask all at end',
        'AddWithoutInfo'=> 'Add without infos',
        'DontAdd'=> 'Do not add',
        'TakeFirst' => 'Select first',
        'MultipleResult'=> 'Multiple results',
        'MultipleResultTooltip'=> 'What do we do when more than 1 result is return by the plugin',
        'RemoveWholeWord' => 'Remove only whole words',
        'NoResult'=> 'No results',
        'NoResultTooltip'=> 'What do we do when no search results is return by the plugin',
        'RemoveTooltipWholeWord' => 'Words will be removed only if they appear as an entire word',
        'RemoveRegularExpr' => 'Regular expression',
        'RemoveTooltipRegularExpr' => 'Consider that \'To be removed from names\' is a perl regular expression',
        'SkipFileAlreadyInCollection' => 'Add new files only',
        'SkipFileAlreadyInCollectionTooltip' => 'Add only files not already in the collection',
        'SkipFileNo' => 'No',
        'SkipFileFullPath' => 'based on full path',
        'SkipFileFileName' => 'based on file name',
        'SkipFileFileNameAndUpdate' => 'based on file name (but update path in collection)',
        'InfoFromFileNameRegExp' => 'Parse file name with this regular expression',
        'InfoFromFileNameRegExpTooltip' => 'Use this to retrieve infos from filename (applied after removing extension).\nLeave empty if not needed.\nKnown fields : \n$T:Title, $A:Alphabetised title, $Y:Release date, $S:Season, $E:Episode, $N:Alphabetised serie name, $x:Part number, $y: Total part number',

        'InfoFromFileNameRegExp' => 'Parse file name with this regular expression',
        'InfoFromFileNameRegExpTooltip' => 'Use this to retrieve infos from filename (applied before removing anything).\nLeave empty if not needed.\nKnown fields : $T:Title, $A:Article, $Y:Year, $S:Season, $E:Episode, $N:Serie Name'
     );

    # As this plugin shares some values with ImportList, it adds them from it
    importTranslation('List');
}

1;
