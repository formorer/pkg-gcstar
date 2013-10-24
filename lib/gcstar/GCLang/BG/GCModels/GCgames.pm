{
    package GCLang::BG::GCModels::GCgames;

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
    
        CollectionDescription => 'Video games collection',
        Items => 'Games',
        NewItem => 'New game',
    
        Id => 'Id',
        Ean => 'EAN',
        Name => 'Name',
        Platform => 'Platform',
        Players => 'Number of players',
        Released => 'Release Date',
        Editor => 'Editor',
        Developer => 'Developer',
        Genre => 'Genre',
        Box => 'Box picture',
        Case => 'Case',
        Manual => 'Instructions manual',
        Completion => 'Completion (%)',
        Executable => 'Executable',
        Description => 'Description',
        Codes => 'Codes',
        Code => 'Code',
        Effect => 'Effect',
        Secrets => 'Secrets',
        Screenshots => 'Screenshots',
        Screenshot1 => 'First screenshot',
        Screenshot2 => 'Second screenshot',
        Comments => 'Comments',
        Url => 'Web page',
        Unlockables => 'Unlockables',
        Unlockable => 'Unlockable',
        Howto => 'How to unlock',
        Exclusive => 'Exclusive',
        Resolutions => 'Display resolutions',
        InstallationSize => 'Size',
        Region => 'Region',
        SerialNumber => 'Serial Number',        

        General => 'General',
        Details => 'Details',
        Tips => 'Tips',
        Information => 'Information',

        FilterRatingSelect => 'Rating At _Least...',
     );
}

1;
