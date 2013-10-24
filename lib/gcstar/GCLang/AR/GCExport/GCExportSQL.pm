
{
    package GCLang::AR::GCExport::GCExportSQL;

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
        'WithDrop' => 'تضمين تعليمة DROP',
        'WithCreate' => 'تضمين تعليمة CREATE',
        'TableName' => 'إسم الجدول',
        'InfoFile' => 'ملف SQL: ',
     );
}

1;
