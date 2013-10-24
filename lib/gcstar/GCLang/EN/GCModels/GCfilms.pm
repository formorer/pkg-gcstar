{
    package GCLang::EN::GCModels::GCfilms;

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
    
        CollectionDescription => 'Movies collection',
        Items => {0 => 'Movies',
                  1 => 'Movie',
                  X => 'Movies',
                  lowercase1 => 'movie',
                  lowercaseX => 'movies'
                  },
        NewItem => 'New movie',
    
    
        Id => 'Id',
        Title => 'Title',
        Date => 'Date',
        Time => 'Length',
        Director => 'Director',
        Country => 'Country',
        MinimumAge => 'Minimum age',
        Genre => 'Genre',
        Image => 'Picture',
        Original => 'Alternative titles',
        Actors => 'Cast',
        Actor => 'Actor',
        Role => 'Role',
        Comment => 'Comments',
        Synopsis => 'Synopsis',
        Seen => 'Viewed',
        Number => '# of Media',
        Format => 'Media',
        Region => 'Region',
        Identifier => 'Identifier',
        Url => 'Web page',
        Audio => 'Audio',
        Video => 'Video format',
        Trailer => 'Video file',
        Serie => 'Series',
        Rank => 'Rank',
        Subtitles => 'Subtitles',

        SeenYes => 'Viewed',
        SeenNo => 'Not viewed',

        AgeUnrated => 'Unrated',
        AgeAll => 'All Ages',
        AgeParent => 'Parental Guidance',

        Main => 'Main items',
        General => 'General',
        Details => 'Details',

        Information => 'Information',
        Languages => 'Languages',
        Encoding => 'Encoding',

        FilterAudienceAge => 'Audience age',
        FilterSeenNo => '_Not Yet Viewed',
        FilterSeenYes => '_Already Viewed',
        FilterRatingSelect => 'Rating At _Least...',

        ExtractSize => 'Size',
     );
}

1;
