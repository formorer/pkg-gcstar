{
    package GCLang::GL::GCModels::GCminicars;

    use utf8;
###################################################
#
#  Copyright 2005-2007 Tian
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
    
        CollectionDescription => 'Mini vehicles collection',
        Items => {0 => 'Vehicle',
                  1 => 'Vehicle',
                  X => 'Vehicles',
                  lowercase1 => 'vehicle',
                  lowercaseX => 'vehicles'
                  },
        NewItem => 'New vehicle',
        Currency => 'Currency',

# Main fields

        Main => 'Main information',

        Name => 'Name',
        Exchange => 'To be sold or exchanged',
        Wanted => 'Wanted',
        Rating1 => 'Main rating',
        Picture1 => 'Main picture',
        Scale => 'Scale',
        Manufacturer => 'Manufacturer',
        Constructor => 'Constructor',
        Type1 => 'Type',
        Modele => 'Model',
        Version => 'Version',
        Color => 'Model color',
        Pub => 'Advertisement',
        Year => 'Year',
        Reference => 'Reference',
        Kit => 'In kit form',
        Transformation => 'Personal transformation',
        Comments1 => 'Comments',

# Details fields

        Details => 'Details',

        MiscCharacteristics => 'Miscellaneous characteristics',
        Material => 'Material',
        Molding => 'Molding',
        Condition => 'Condition',
        Edition => 'Edition',
        Collectiontype => 'Collection name',
        Serial => 'Series',
        Serialnumber => 'Serial number',
        Designed => 'Design date',
        Madein => 'Manufacture date',
        Box1 => 'Kind of box',
        Box2 => 'Box description',
        Containbox => 'Box contet',
        Rating2 => 'Realism',
        Rating3 => 'Finish',
        Acquisition => 'Acquisition date',
        Location => 'Acquisition place',
        Buyprice => 'Acquisition price',
        Estimate => 'Estimation',
        Comments2 => 'Comments',
        Decorationset => 'Decoration set',
        Characters => 'Characters',
        CarFromFilm => 'Movie car',
        Filmcar => 'Movie related to the vehicle',
        Filmpart => 'Movie part/episode',
        Parts => 'Number of parts',
        VehiculeDetails => 'Vehicule details',
        Detailsparts => 'Details parts',
        Detailsdecorations => 'Kind of decorations',
        Decorations => 'Number of decorations',
        Lwh => 'Length / Width / Height',
        Weight => 'Weight',
        Framecar => 'Chassis',
        Bodycar => 'Bodywork',
        Colormirror => 'Model color',
        Interior => 'Interior',
        Wheels => 'Wheels',
        Registrationnumber1 => 'Front registration number',
        Registrationnumber2 => 'Back registration number',
        RacingCar => 'Racing car',
        Course => 'Race',
        Courselocation => 'Race place',
        Courseyear => 'Race date',
        Team => 'Team',
        Pilots => 'Pilot(s)',
        Copilots => 'Copilot(s)',
        Carnumber => 'Vehicle number',
        Pub2 => 'Advertisers',
        Finishline => 'Finish ranking',
        Steeringwheel => 'Position of steering wheel',


# Catalogs fields

        Catalogs => 'Catalogs',

        OfficialPicture => 'Official picture',
        Barcode => 'Barcode',
        Referencemirror => 'Reference',
        Year3 => 'Availability date',
        CatalogCoverPicture => 'Cover',
        CatalogPagePicture => 'Page',
        Catalogyear => 'Catalog year',
        Catalogedition => 'Catalog edition',
        Catalogpage => 'Catalog page',
        Catalogprice => 'Catalog price',
        Personalref => 'Personal reference',
        Websitem => 'Mini vehicle\'s manufacturer website',
        Websitec => 'Actual vehicle\'s manufacturer website',
        Websiteo => 'Useful link',
        Comments3 => 'Comments',

# Pictures fields

        Pictures => 'Pictures',

        OthersComments => 'General remarks',
        OthersDetails => 'Other details',
        Top1 => 'Above',
        Back1 => 'Below',
        AVG => 'Front Left',
        AV => 'Front',
        AVD => 'Front Right',
        G => 'Left',
        BOX => 'Box',
        D => 'Right',
        ARG => 'Back Left',
        AR => 'Back',
        ARD => 'Back Right',
        Others => 'Misc',

# PanelLending fields

        LendingExplanation => 'Useful exchanges during temporary exhibitions',
        PanelLending => 'Lendings (for exhibitions)',
        Comments4 => 'Comments',

# Realmodel fields

        Realmodel => 'Actual vehicle',

        Difference => 'Differences with miniature',
        Front2 => 'Front',
        Back2 => 'Back',
        Comments5 => 'Comments',

        References => 'References',

     );
}

1;
