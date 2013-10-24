{
    package GCLang::AR::GCModels::GCfilms;

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
    
        CollectionDescription => 'مجموعة الأفلام',
        Items => 'أفلام',
        NewItem => 'فيلم جديد',
    
    
        Id => 'الرقم المعرّف',
        Title => 'العنوان',
        Date => 'التاريخ',
        Time => 'المدّة الزمنية',
        Director => 'المخرج',
        Country => 'البلد',
        MinimumAge => 'أقل عمر',
        Genre => 'النوع',
        Image => 'صورة',
        Original => 'العنوان الأصلي',
        Actors => 'الممثلون',
        Actor => 'Actor',
        Role => 'Role',
        Comment => 'تعليقات',
        Synopsis => 'الخلاصة',
        Seen => 'متى عُرض',
        Number => '# مرة',
        Format => 'الصيغة',
        Region => 'Region',
        Identifier => 'Identifier',
        Url => 'صفحة الإنترنت',
        Audio => 'الصوت',
        Video => 'صيغة الفيديو',
        Trailer => 'ملف الفيديو',
        Serie => 'سلسلة',
        Rank => 'الرتبة',
        Subtitles => 'الترجمة الثانوية',
        Added => 'تاريخ الإضافة',

        SeenYes => 'عًرض',
        SeenNo => 'لم يًعرض',

        AgeUnrated => 'لم يتم تقييمه',
        AgeAll => 'كل الأعمال',
        AgeParent => 'التوجيه الأبوي',

        Main => 'عناصر رئيسية',
        General => 'عام',
        Details => 'تفاصيل',

        Information => 'معلومات',
        Languages => 'لغات',
        Encoding => 'ترميز',

        FilterAudienceAge => 'عمر الجمهور',
        FilterSeenNo => 'لم يتم عرضه حتى الآن',
        FilterSeenYes => 'تم عرضه',
        FilterRatingSelect => 'تم تقييمه على الأقل...',

        ExtractSize => 'قياس',
     );
}

1;
