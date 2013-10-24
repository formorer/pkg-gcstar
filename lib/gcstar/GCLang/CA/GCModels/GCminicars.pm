{
    package GCLang::CA::GCModels::GCminicars;

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
        NewItem => 'Nou vehicle',
        Currency => 'Moneda',

# Main fields

        Main => 'Informació principal',

        Name => 'Nom',
        Exchange => 'Per a vendre o canviar',
        Wanted => 'El vull',
        Rating1 => 'Classificació principal',
        Picture1 => 'Imatge principal',
        Scale => 'Escala',
        Manufacturer => 'Fabricant',
        Constructor => 'Constructor',
        Type1 => 'Tipus',
        Modele => 'Model',
        Version => 'Versió',
        Color => 'Color del Model',
        Pub => 'Avís',
        Year => 'Any',
        Reference => 'Referència',
        Kit => 'En forma de kit',
        Transformation => 'Transformació personal',
        Comments1 => 'Comentaris',

# Details fields

        Details => 'Detalls',

        MiscCharacteristics => 'Característiques diverses',
        Material => 'Material',
        Molding => 'Motlle',
        Condition => 'Condició',
        Edition => 'Edició',
        Collectiontype => 'Nom de la col·lecció',
        Serial => 'Sèrie',
        Serialnumber => 'Número de sèrie',
        Designed => 'Data de Disseny',
        Madein => 'Data de fabricació',
        Box1 => 'Tipus de capça',
        Box2 => 'Descripció de la capça',
        Containbox => 'Contingut de la capça',
        Rating2 => 'Realisme',
        Rating3 => 'Acabat',
        Acquisition => 'Data d\'adquisició',
        Location => 'Lloc d\'adquisició',
        Buyprice => 'Preu d\'adquisició',
        Estimate => 'Estimació',
        Comments2 => 'Comentaris',
        Decorationset => 'Conjunt de decoració',
        Characters => 'Personatges',
        CarFromFilm => 'Pel·lícula del cotxe',
        Filmcar => 'Pel·lícula relacionada al vehicle',
        Filmpart => 'Part de la pel·lícula/episodi',
        Parts => 'Nombre de parts',
        VehiculeDetails => 'Detalls del vehicle',
        Detailsparts => 'Detalls de les parts',
        Detailsdecorations => 'Tipus de decoracions',
        Decorations => 'Nombre de decoracions',
        Lwh => 'Llarg / ample / alt',
        Weight => 'Pes',
        Framecar => 'Xassís',
        Bodycar => 'Carrosseria',
        Colormirror => 'Color del model',
        Interior => 'Interior',
        Wheels => 'Rodes',
        Registrationnumber1 => 'Número de registre frontal',
        Registrationnumber2 => 'Número de registre posterior',
        RacingCar => 'Cotxe de carreres',
        Course => 'Carrera',
        Courselocation => 'Lloc de la carrera',
        Courseyear => 'Data de la carrera',
        Team => 'Equip',
        Pilots => 'Pilot(s)',
        Copilots => 'Copilot(s)',
        Carnumber => 'Nombre de vehicle',
        Pub2 => 'Publicistes',
        Finishline => 'Posició final',
        Steeringwheel => 'Posició del volant',


# Catalogs fields

        Catalogs => 'Catàlegs',

        OfficialPicture => 'Imatge oficial',
        Barcode => 'Codi de barres',
        Referencemirror => 'Referència',
        Year3 => 'Data de disponibilitat',
        CatalogCoverPicture => 'Portada',
        CatalogPagePicture => 'Pàgina',
        Catalogyear => 'Any del catàleg',
        Catalogedition => 'Edició del catàleg',
        Catalogpage => 'Pàgina del catàleg',
        Catalogprice => 'Preu del catàleg',
        Personalref => 'Referència personal',
        Websitem => 'Pàgina web del fabricant del vehicle petit',
        Websitec => 'Pàgina web del fabricant del vehicle real',
        Websiteo => 'Enllaç interesant',
        Comments3 => 'Comentaris',

# Pictures fields

        Pictures => 'Imatges',

        OthersComments => 'Observacions generals',
        OthersDetails => 'Altres detalls',
        Top1 => 'Amunt',
        Back1 => 'Avall',
        AVG => 'Frontal esquerra',
        AV => 'Davant',
        AVD => 'Frontal dreta',
        G => 'Esquerra',
        BOX => 'Capça',
        D => 'Dreta',
        ARG => 'Posterior esquerra',
        AR => 'Darrera',
        ARD => 'Posterior dreta',
        Others => 'Altres',

# PanelLending fields

        LendingExplanation => 'Canvis útils durant les temporades d\'exhibicions',
        PanelLending => 'Préstecs (per a exhibicions)',
        Comments4 => 'Comentaris',

# Realmodel fields

        Realmodel => 'Vehicle real',

        Difference => 'Diferències amb la miniatura',
        Front2 => 'Davant',
        Back2 => 'Darrera',
        Comments5 => 'Comentaris',

        References => 'Referències',

     );
}

1;
