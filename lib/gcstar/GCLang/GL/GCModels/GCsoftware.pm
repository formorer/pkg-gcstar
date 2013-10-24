{
    package GCLang::GL::GCModels::GCsoftware;

    use utf8;
###################################################
#
#  Copyright 2005-2009 Tian
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
    
        CollectionDescription => 'Computer software collection',
        Items => {0 => 'Application',
                  1 => 'Application',
                  X => 'Applications',
                  lowercase1 => 'application',
                  lowercaseX => 'applications'},
        NewItem => 'New application',
    
        Id => 'Id',
        Ean => 'EAN',
        Name => 'Name',
        Platform => 'Platform',
        Released => 'Release date',
        Homepage => 'Homepage',		
        Editor => 'Editor',
        Developer => 'Developer',
        Category => 'Category',
		NumberOfCopies => 'Copies',
		Price => 'Price',
        Box => 'Box picture',
        Case => 'Case',
        Manual => 'Instruction manual',
        Executable => 'Executable',
        Description => 'Description',
        License => 'License',
        Commercial => 'Commercial',
		FreewareNoncommercial => 'Freeware (non-commercial use)',		
		OtherOpenSource => 'Other Open Source',
		PublicDomain => 'Public Domain',
		OtherLicense => 'Other',
		Registration => 'Registration',				
		RegistrationInfo => 'Registration Info',		
		RegInfo => 'Registration Info',
		RegistrationName => 'Username',
		RegistrationNumber => 'Registration Number',		
		PanelRegistration => 'Registration Info',	
		RegistrationComments => 'Additional info or comments',
        Screenshots => 'Screenshots',
        Screenshot1 => 'First screenshot',
        Screenshot2 => 'Second screenshot',
        Comments => 'Comments',
        Url => 'Web page',
        General => 'General',
        Details => 'Details',
        Information => 'Information',

        FilterRatingSelect => 'Rating At _Least...',
     );
}

1;
