{
    package GCLang::PT::GCModels::GCboardgames;

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
    
        CollectionDescription => 'Board games collection',
        Items => {0 => 'Game',
                  1 => 'Game',
                  X => 'Games'},
        NewItem => 'New game',
    
        Id => 'Id',
        Name => 'Name',
        Original => 'Original name',
        Box => 'Box picture',
        DesignedBy => 'Designed by',
        PublishedBy => 'Published by',
        Players => 'Number of players',
        PlayingTime => 'Playing time',
        SuggestedAge => 'Suggested age',
        Released => 'Released',
        Description => 'Description',
        Category => 'Category',
        Mechanics => 'Mechanics',
        ExpandedBy => 'Expanded by',
        ExpansionFor => 'Expansion for',
        GameFamily => 'Game family',
        IllustratedBy => 'Illustrated by',
        Url => 'Web page',
        TimesPlayed => 'Times played',
        CompleteContents => 'Complete contents',
        Copies => 'No. of copies',
        Condition => 'Condition',
        Photos => 'Photos',
        Photo1 => 'First picture',
        Photo2 => 'Second picture',
        Photo3 => 'Third picture',
        Photo4 => 'Fourth picture',
        Comments => 'Comments',

        Perfect => 'Perfect',
        Good => 'Good',
        Average => 'Average',
        Poor => 'Poor',

        CompleteYes => 'Complete contents',
        CompleteNo => 'Missing pieces',

        General => 'General',
        Details => 'Details',
        Personal => 'Personal',
        Information => 'Information',

        FilterRatingSelect => 'Rating At _Least...',
     );
}

1;
