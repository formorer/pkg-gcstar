{
    package GCLang::PL::GCModels::GCTVseries;

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
    use GCLang::GCLangUtils;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => 'Zbiór nagrań TV (seriale)',
        Items => sub {
           my $number = shift;
           return 'Serial' if $number eq '1';
           return 'Seriale' if $number =~ /(?<!1)[2-4]$/;
           return 'Seriali';
        },
        NewItem => 'Nowy serial',
        Name => 'Tytuł',
        Season => 'Sezon',
        Part => 'Część',
        Episodes => 'Odcinki',
        FirstAired => 'Premiera',
        Time => 'Długość odcinka',
        Producer => 'Producent',
        Music => 'Muzyka',
     );
     importTranslation('Films');
}

1;
