package GCPlugins::GCgames::GCgamesCommon;

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

our $MAX_ACTORS = 6;
our $MAX_DIRECTORS = 4;

use GCPlugins::GCPluginsBase;

{
    package GCPlugins::GCgames::GCgamesPluginsBase;

    use base qw(GCPluginParser);
    use HTML::Entities;
    
    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);
        return $self;
    }    
    
    sub getSearchFieldsArray
    {
        return ['name'];
    }

    sub getTipsUrl
    {
        my $self = shift;
        
        return '';
    }
    
    sub getTips
    {
        my $self = shift;
        my $url = $self->getTipsUrl;
        if ($url)
        {
            $self->{parsingTips} = 1;
            my $html = $self->loadPage($url, 0, 1);
            $html = $self->preProcess($html);
            decode_entities($html);
            $self->{inside} = undef;
            $self->parse($html);
            $self->{parsingTips} = 0;
        }
    }
    
    sub getItemInfo
    {
        my $self = shift;

        $self->SUPER::getItemInfo;
        $self->getTips;
        
        return $self->{curInfo};
    }
    
}

1;