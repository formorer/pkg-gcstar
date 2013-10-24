{
    package GCLang::CA::GCModels::GCsmartcards;

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
    
        CollectionDescription => 'Col·lecció de targetes intel·ligents',
        Items => {0 => 'Targeta intel·ligent',
                  1 => 'Targeta intel·ligent',
                  X => 'Targetes intel·ligents'},
        NewItem => 'Nova targeta intel·ligent',
        Currency => 'Moneda',

	  Help => 'Ajuda pels camps',
	  Help1 => 'Ajuda',

# Traduction des Champs "Main"

        Main => 'La targenta intel·ligent',

        Cover => 'Imatge',

        Name => 'Nom',
        Exchange => 'Per a canviar o vendre',
        Wanted => 'La vull',
        Rating1 => 'Classificació global',
        TheSmartCard => 'La targeta intel·ligent, devant, derrera',

        Country => 'País',
        Color => 'Color',
        Type1 => 'Tipus de targeta',
        Type2 => 'Tipus de xip',
        Dimension => 'Llarg / Ample / Gruix',

        Box => 'Capça',
        Chip => 'Xip',
        Year1 => 'Any edició',
        Year2 => 'Any de validesa',
        Condition => 'Condició',
        Charge => 'Targeta recarregable',
        Variety => 'Varietat',

        Edition => 'Nombre d\'exemplars',
        Serial => 'Número de sèrie',
        Theme => 'Tema',

        Acquisition => 'Adquirida en',

        Catalog0 => 'Catàleg',
        Catalog1 => 'Phonecote / Infopuce (YT)',
        Catalog2 => 'La Cote en Poche',

        Reference0 => 'Referència',
        Reference1 => 'Referència Phonecote / Infopuce (YT)',
        Reference2 => 'Referència La Cote en Poche',
        Reference3 => 'Altra referència',

        Quotationnew00 => 'Quota per a la nova targeta',
        Quotationnew10 => 'Quota Phonecote / Infopuce (YT)',
        Quotationnew20 => 'Quota La Cote en Poche',
        Quotationnew30 => 'Quota altra',
        Quotationold00 => 'Quota per a la targeta usada',
        Quotationold10 => 'Quota Phonecote / Infopuce (YT)',
        Quotationold20 => 'Quota La Cote en Poche',
        Quotationold30 => 'Altra quota',

        Title1 => 'Títol',

        Unit => 'Unitats / nombre de minuts',

        Pressed => 'Tipus d\'impressió',
        Location => 'Lloc d\'impressió',

        Comments1 => 'Comentaris',

        Others => 'Altres',
        Weight => 'Pes',
     );
}

1;
