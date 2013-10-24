{
    package GCLang::GCLangUtils;


###################################################
#
#  Copyright 2005-2008 Tian
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

use utf8;
use strict;
use Exporter;
use base 'Exporter';
our @EXPORT = qw(importTranslation);

sub importTranslation
{
    my ($replace) = @_;
    my ($pack) = caller(0);
    my (undef, undef, undef, $subroutine) = caller(2);
    # Avoid recursion as it could lead to some problems
    return if $subroutine =~ /importTranslation/;
    #Create the new package name. It supposes the module are in the same subfolders
    (my $newPack = $pack) =~ s/(GC(Import|Export)?)(\w*)$/$1$replace/;
    (my $newModule = $newPack) =~ s|::|/|g;
    require "$newModule.pm";
    my %tmpLang;
    eval "%tmpLang = %".$newPack."::lang";
    foreach my $translation(keys %tmpLang)
    {
        # Add it only if it was not defined previously
        eval '$'.$pack.'::lang{'.$translation."} = \$tmpLang{$translation} if ! exists \$".$pack.'::lang{'.$translation.'}';
    }
    
}

}

1;
