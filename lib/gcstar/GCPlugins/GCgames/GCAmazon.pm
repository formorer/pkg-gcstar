package GCPlugins::GCgames::GCAmazon;

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
use utf8;

use GCPlugins::GCgames::GCgamesAmazonCommon;

{
    package GCPlugins::GCgames::GCPluginAmazon;

    use base 'GCPlugins::GCgames::GCgamesAmazonPluginsBase';

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);

        $self->{suffix} = 'com';

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        if ($self->{parsingList})
        {
        }
        else
        {
            $html =~ s/>Product Description</><tpfdescription><\/tpfdescription></;
            # Le descriptif pouvant contenir des balises html je le repere maintenant
            my $found = index($html,"<tpfdescription>");
            if ( $found >= 0 )
            {
               my $html2 = substr($html, $found,length($html)- $found);

               $html2 =~ s|</li>||gi;
               $html2 =~ s|<p>|\n\n|gi;
               $html2 =~ s|</p>||gi;
               $html2 =~ s|<ul>|\n|gi;
               $html2 =~ s|</ul>|\n\n|gi;
               $html2 =~ s|<strong>||gi;
               $html2 =~ s|</strong>||gi;
               $html2 =~ s|<em>||gi;
               $html2 =~ s|</em>||gi;

               $html = substr($html, 0, $found) . $html2 ;
            }

            $html =~ s/Release Date&nbsp;:</<tpfdateparution></gi;
            $html =~ s/Release Date:</<tpfdateparution></gi;
            $html =~ s/<b>Platform:<\/b> &nbsp;</<tpfplateforme><\/tpfplateforme></gi;
            $html =~ s/<b>Platform:<\/b>/<tpfplateforme><\/tpfplateforme>/gi;
            $html =~ s/registerImage\("original_image",/<\/script><tpfcouverture src=/gi;
            $html =~ s/registerImage\("alt_image_1",/<\/script><tpfscreenshot1 src=/gi;
            $html =~ s/registerImage\("alt_image_2",/<\/script><tpfscreenshot2 src=/gi;
            $html =~ s|<b>||gi;
            $html =~ s|</b>||gi;
            $html =~ s|<i>||gi;
            $html =~ s|</i>||gi;
            $html =~ s|<li>|\n*|gi;
            $html =~ s|<br>|\n|gi;
            $html =~ s|<br />|\n|gi;
            $html =~ s|\x{92}|'|gi;
            $html =~ s|&#146;|'|gi;
            $html =~ s|&#149;|*|gi;
            $html =~ s|&#156;|oe|gi;
            $html =~ s|&#133;|...|gi;
            $html =~ s|\x{85}|...|gi;
            $html =~ s|\x{8C}|OE|gi;
            $html =~ s|\x{9C}|oe|gi;

        }
        return $html;
    }

    sub getName
    {
        return 'Amazon (US)';
    }
    
    sub getLang
    {
        return 'EN';
    }

}

1;
