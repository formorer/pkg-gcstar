{
    package GCLang::AR::GCExport::GCExportHTML;

    use utf8;
###################################################	
#
#	This file translated by :
#		Muhammad Bashir Al-Noimi
#	Contact me:
#		webmaster@hali-sy.com
#		bashir.storm@gmail.com
#		hali83@cec.sy
#	MY Blog:
#		http://www.hali-sy.com/blog
#	
###################################################
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
#  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
#
###################################################
    
    use strict;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
        'ModelNotFound' => 'قالب غير صالح',
        'UseFile' => 'قم بإستعمال الملف أدناه',
        'TemplateExternalFile' => 'القالب',
        'WithJS' => 'إستعمل Javascript',
       	'FileTemplate' => 'قالب:',
        'Preview' => 'معاينة',
        'NoPreview' => 'المعاينة غير متاحة',
        'Title' => 'عنوان الصفحة',
        'InfoFile' => 'قائمة الأفلام في الملف: ',
        'InfoDir' => 'الصور في المجلد: ',
        'HeightImg' => 'إرتفاع الصور التي سيتم تصديرها (بالبكسل): ',
        'OpenFileInBrowser' => 'فتح الملف المنشئ بواسطة متصفح الإنترنت',
        'Note' => 'تم إنشاء القائمة بواسطة <a href="http://www.gcstar.org/">GCstar</a>',
        'InputTitle' => 'أدخل نص البحث',
        'SearchType1' => 'عنوان فقط',
        'SearchType2' => 'معلومات كاملة',
        'SearchButton' => 'بحث',    
        'SearchTitle' => 'عرض الأفلام الماطيقة للمعيار السابق فقط',
        'AllButton' => 'الكل',
        'AllTitle' => 'عرض كل الأفلام',
        'Expand' => 'توسيع الكل',
        'ExpandTitle' => 'عرض معلومات كل الأفلام',
        'Collapse' => 'طي الكل',
        'CollapseTitle' => 'طي كل معلومات الأفلام',
        'Borrowed' => 'تمت إستعارته من قبل: ',
        'NotBorrowed' => 'متاح',
        'Top' => 'للأعلى',
        'Bottom' => 'للأسفل',
     );
}

1;
