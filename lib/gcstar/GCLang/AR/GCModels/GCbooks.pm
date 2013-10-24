{
    package GCLang::AR::GCModels::GCbooks;

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
#  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
#
###################################################
    
    use strict;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => 'مجموعة الكتب',
        Items => 'الكتب',
        NewItem => 'كتاب جديد',
    
        Isbn => 'ISBN',
        Title => 'العنوان',
        Cover => 'الغلاف',
        Authors => 'المؤلفون',
        Publisher => 'الناشر',
        Publication => 'تاريخ النشر',
        Language => 'اللغة',
        Genre => 'النوع',
        Serie => 'سلسلة',
        Rank => 'الرتبة',
        Bookdescription => 'الوصف',
        Pages => 'صفحات',
        Read => 'قُرء',
        Acquisition => 'تاريخ الحصول على الكتاب',
        Edition => 'الطبعة',
        Format => 'الصيغة',
        Comments => 'تعليقات',
        Url => 'صفحة الإنترنت',
		Translator => 'المترجم',
        Artist => 'الرسّام',
        DigitalFile => 'Digital version',

        General => 'عام',
        Details => 'تفاصيل',

        ReadNo => 'لم يُقرء',
        ReadYes => 'قُرء',
     );
}

1;
