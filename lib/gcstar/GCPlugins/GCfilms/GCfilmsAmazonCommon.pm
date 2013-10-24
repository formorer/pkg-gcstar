package GCPlugins::GCfilms::GCfilmsAmazonCommon;

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

use GCPlugins::GCfilms::GCfilmsCommon;
use GCPlugins::GCstar::GCAmazonCommon;

{
    package GCPlugins::GCfilms::GCfilmsAmazonPluginsBase;

    use base ('GCPlugins::GCfilms::GCfilmsPluginsBase', 'GCPlugins::GCstar::GCPluginAmazonCommon');
    
    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);
        
        $self->{codeField} = '';
        $self->{searchType} = 'dvd';

        return $self;
    }
        
    sub getSearchFieldsArray
    {
        return ['title'];
    }

    sub getEanField
    {
        return 'title';
    }
}

1;
