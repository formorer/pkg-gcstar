{
    package GCLang::ZH::GCModels::GCsmartcards;

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

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => 'Smart card collection',
        Items => {0 => 'Smart card',
                  1 => 'Smart card',
                  X => 'Smart cards'},
        NewItem => 'New smart card',
        Currency => 'Currency',

	  Help => 'Help for fields',
	  Help1 => 'Help',

# Traduction des Champs "Main"

        Main => 'The smart card',

        Cover => 'Picture',

        Name => 'Name',
        Exchange => 'To be exchanged or sold',
        Wanted => 'Wanted',
        Rating1 => 'Global rating',
        TheSmartCard => 'The smart card, front/back',

        Country => 'Country',
        Color => 'Color',
        Type1 => 'Card type',
        Type2 => 'Chip type',
        Dimension => 'Length / Width / Thickness',

        Box => 'Box',
        Chip => 'Chip',
        Year1 => 'Edition year',
        Year2 => 'Validity year',
        Condition => 'Condition',
        Charge => 'Rechargeable card',
        Variety => 'Variety',

        Edition => 'Number of exemplars',
        Serial => 'Serial number',
        Theme => 'Theme',

        Acquisition => 'Acquired on',

        Catalog0 => 'Catalog',
        Catalog1 => 'Phonecote / Infopuce (YT)',
        Catalog2 => 'La Cote en Poche',

        Reference0 => 'Reference',
        Reference1 => 'Reference Phonecote / Infopuce (YT)',
        Reference2 => 'Reference La Cote en Poche',
        Reference3 => 'Other reference',

        Quotationnew00 => 'Quotation for new card',
        Quotationnew10 => 'Quotation Phonecote / Infopuce (YT)',
        Quotationnew20 => 'Quotation La Cote en Poche',
        Quotationnew30 => 'Cotation Autre',
        Quotationold00 => 'Quotation for used card',
        Quotationold10 => 'Quotation Phonecote / Infopuce (YT)',
        Quotationold20 => 'Quotation La Cote en Poche',
        Quotationold30 => 'Other quotation',

        Title1 => 'Title',

        Unit => 'Units / Minutes number',

        Pressed => 'Impression type',
        Location => 'Impression place',

        Comments1 => 'Comments',

        Others => 'Misc.',
        Weight => 'Weight',
     );
}

1;
