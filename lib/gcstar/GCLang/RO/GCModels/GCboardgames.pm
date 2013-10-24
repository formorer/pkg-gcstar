{
    package GCLang::RO::GCModels::GCboardgames;

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
    
        CollectionDescription => 'Colecţie de jocuri de masă',
        Items => {0 => 'Joc',
                  1 => 'Joc',
                  X => 'Jocuri'},
        NewItem => 'Joc nou',
    
        Id => 'Id',
        Name => 'Nume',
        Original => 'Nume original',
        Box => 'Imagine cutie',
        DesignedBy => 'Conceput de',
        PublishedBy => 'Publicat de',
        Players => 'Număr de jucători',
        PlayingTime => 'Durată joc',
        SuggestedAge => 'Vârstă sugerată',
        Released => 'Lansat',
        Description => 'Descriere',
        Category => 'Categorie',
        Mechanics => 'Mecanică',
        ExpandedBy => 'Extins de',
        ExpansionFor => 'Extindere la',
        GameFamily => 'Game family',
        IllustratedBy => 'Illustrated by',
        Url => 'Pagină web',
        TimesPlayed => 'Times played',
        CompleteContents => 'Conţinut complet',
        Copies => 'No. of copies',
        Condition => 'Condiţie',
        Photos => 'Imagini',
        Photo1 => 'Prima imagine',
        Photo2 => 'A doua imagine',
        Photo3 => 'A treia imagine',
        Photo4 => 'A patra imagine',
        Comments => 'Comentarii',

        Perfect => 'Perfect',
        Good => 'Bun',
        Average => 'Mediu',
        Poor => 'Slab',

        CompleteYes => 'Conţinut complet',
        CompleteNo => 'Piese lipsă',

        General => 'General',
        Details => 'Detalii',
        Personal => 'Personal',
        Information => 'Informaţii',

        FilterRatingSelect => 'Evaluat la cel _puţin...',
     );
}

1;
