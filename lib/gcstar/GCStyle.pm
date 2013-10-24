{
    package GCStyle;
    
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
	our @EXPORT = qw(%styles @lists $defaultList @readOnlyStyles);

    use File::Basename;
    use GCUtils 'glob';

    our %styles;
    our @lists;
    our $defaultList;
    our @readOnlyStyles;

    sub initStyles
    {
        foreach (glob $ENV{GCS_SHARE_DIR}.'/style/*')
        {
            my $style = basename($_);
            next if $style eq 'CVS';
            my %tmpStyle;
            $tmpStyle{dir} = $_;
            $tmpStyle{rcFile} = $tmpStyle{dir}.'/gtkrc';
            $tmpStyle{name} = $style;
            $styles{$style} = \%tmpStyle;
        }
        foreach (glob $ENV{GCS_SHARE_DIR}.'/list_bg/*')
        {
            my $bg = basename($_);
            next if $bg eq 'CVS';
            push @lists, $bg;
        }
        foreach (glob $ENV{GCS_SHARE_DIR}.'/panels/*')
        {
            my $style = basename($_);
            next if $style eq 'CVS';
            push @readOnlyStyles, $style;
        }
        $defaultList = 'Wood';
    }
}

1;
