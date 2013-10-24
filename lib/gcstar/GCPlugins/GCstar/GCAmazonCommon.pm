package GCPlugins::GCstar::GCAmazonCommon;

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

use GCPlugins::GCPluginsBase;

{
    package GCPlugins::GCstar::GCPluginAmazonCommon;

    sub text
    {
        my ($self, $origtext) = @_;
        return 0 if ($self->{parsingEnded});

        if ($self->{parsingList})
        {
            if (
                (($self->{inside}->{b})
                || ($self->{inside}->{span})
                || ($self->{inside}->{label}))
               )
            {
                my $suffix = $self->{suffix};
                if ((($suffix =~ /^co/) && ($origtext =~ /Sort by/))
                 || (($suffix eq 'fr' ) && ($origtext =~ /Trier par/))
                 || (($suffix eq 'de' ) && ($origtext =~ /Sortieren nach/)))
                {
                    $self->{beginParsing} = 1;
                    return 1;
                }
            }
        }
        
        return 0;
    }

    sub extractImage
    {
        my ($self, $attr) = @_;
        my $url = $attr->{src};
        return 'http://images.amazon.com/images/'.$1.'/'.$2.$3.'MZZZZZZZ.'.$5
            if ($url =~ m%^http://.*?images[.-]amazon\.com/images/(P)/([A-Z0-9]*)(\.[0-9]+\.)?[-A-Za-z0-9_.,]*?ZZZZZZZ(.*?)\.(jpg|gif)%);
        return 'http://images.amazon.com/images/'.$1.'/'.$2.'.'.$3
            if ($url =~ m%^http://.*?images[.-]amazon\.com/images/(I|G)/([-\%A-Z0-9a-z+]*)\._.*?_\.(jpg|gif)%);
        if ($attr->{id} eq 'prodImage')
        {
            $url =~ s/_AA[0-9]*_//;
            return $url;
        }
        return '';
    }

    sub isEAN
    {
        my ($self, $value) = @_;
        
        my $l = length($value);
        return 1
            if ($l == 8)
            || ($l == 13)
            || ($l == 15)
            || ($l == 18);
        return 0;
    }

    sub isItemUrl
    {
        my ($self, $url) = @_;
        return $1
            if (($url =~ m|/dp/[A-Z0-9]*/sr=([0-3]-[0-9]*)/qid=[0-9]*|)
             || ($url =~ m|/dp/[A-Z0-9]*/ref=(?:sr\|pd)_([a-z0-9_]*)/[0-9]*|)
             || ($url =~ m|/dp/[A-Z0-9]*/ref=(?:sr\|pd)_([a-z0-9_]*)/[0-9]*|));
        return undef;
    }

    sub getSearchUrl
    {
        my ($self, $word) = @_;
        return "http://www.amazon.".$self->{suffix}."/gp/search/?redirect=true&search-alias=".$self->{searchType}."&keywords=$word";
    }
    
    sub getItemUrl
    {
        my ($self, $url) = @_;
        return $url if $url;
        return 'http://www.amazon.'.$self->{suffix};
    }

    sub getAuthor
    {
        return 'Tian';
    }

    sub preProcess
    {
        my ($self, $html) = @_;
        if ($self->{parsingList})
        {
            $html =~ s|<span\s+class="srTitle">([^<]*)</span>|<srTitle>$1</srTitle>|gim;
            $html =~ s|<td class="otherEditions">.*?</td>||gim;
        }
        else
        {
            $html =~ s|<a\s*href="/exec/obidos/ASIN/[0-9/\${}]*">([^<]*)</a>|$1|gim;
        }
        return $html;
    }
}

1;
