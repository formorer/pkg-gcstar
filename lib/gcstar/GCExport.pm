package GCExport;

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

use File::Basename;
use GCUtils 'glob';

use base 'Exporter';
our @EXPORT = qw(@exportersArray);

our @exportersArray;

sub loadExporters
{
    foreach (glob $ENV{GCS_LIB_DIR}.'/GCExport/*.pm')
    {
        my $export = basename($_, '.pm')."\n";
        next if $export =~ /GCExportBase/;
        eval "use GCExport::$export";
        (my $exporter = $export) =~ s/^GCExport/GCExporter/;
        my $obj;
        eval "\$obj = new GCExport::$exporter";
        die "Fatal error with exporter $export\n$@" if $@;
        push @exportersArray, $obj if ! $obj->{errors};
    }
}

use Gtk2;
use GCExportImport;

{
    package GCExportDialog;
    
    use Glib::Object::Subclass
                Gtk2::Dialog::
    ;
    
    @GCExportDialog::ISA = ('GCExportImportDialog');

    sub addOptions
    {
        my ($self, $options) = @_;
        my $filter = ($self->{filter}->get_active) ? 1 : 0;
        $options->{items} = $self->{parent}->{items}->getItemsListFiltered($filter);
        $options->{collection} = $self->{parent}->{options}->file;
        $options->{defaultImage} = $self->{parent}->{defaultImage};
        $options->{sorter} = $self->{sorter}->getValue;
        $options->{order} = $self->{order}->getValue;
    }

    sub setModel
    {
        my $self = shift;
        $self->{fieldsDialog} = new GCFieldsSelectionDialog($self, $self->{parent}->{lang}->{ExportFieldsTitle});
    }

    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent, $parent->{lang}->{ExportTitle}, 'export');
        bless ($self, $class);

        $self->{fieldsButtonLabel} = $parent->{lang}->{ExportFieldsTitle};
        $self->{fieldsTip} = $parent->{lang}->{ExportFieldsTip};
        $self->{filter} = new Gtk2::CheckButton($parent->{lang}->{ExportFilter});
        $self->{sortLabel} = GCLabel->new($parent->{lang}->{ExportSortBy});
        $self->{sorter} = new GCFieldSelector(0, undef, 0);
        $self->{orderLabel} = GCLabel->new($parent->{lang}->{ExportOrder});
        my $ascStock = Gtk2::Stock->lookup('gtk-sort-ascending');
        (my $ascStockLabel = $ascStock->{label}) =~ s/_//;
        my $descStock = Gtk2::Stock->lookup('gtk-sort-descending');
        (my $descStockLabel = $descStock->{label}) =~ s/_//;
        $self->{order} = new GCMenuList([
            {value => 'asc', displayed => $ascStockLabel},
            {value => 'desc', displayed => $descStockLabel},
        ]);
        $self->{dataTable}->resize(4, 2);
        $self->{dataTable}->attach($self->{filter}, 0, 2, 0, 1, 'fill', 'fill', 0, 0);
        $self->{dataTable}->attach($self->{sortLabel}, 0, 1, 1, 2, 'fill', 'fill', 0, 0);
        $self->{dataTable}->attach($self->{sorter}, 1, 2, 1, 2, 'fill', 'fill', 0, 0);
        $self->{dataTable}->attach($self->{orderLabel}, 0, 1, 2, 3, 'fill', 'fill', 0, 0);
        $self->{dataTable}->attach($self->{order}, 1, 2, 2, 3, 'fill', 'fill', 0, 0);
        $self->{dataTable}->attach($self->{labelFile}, 0, 1, 3, 4, 'fill', 'fill', 0, 0);
        $self->{dataTable}->attach($self->{file}, 1, 2, 3, 4, ['fill', 'expand'], 'fill', 0, 0);

#        $self->vbox->pack_start(new Gtk2::HSeparator, 0, 0, 5);
#        $self->vbox->pack_start($self->{filter},0,0,0);

        return $self;
    }
    
}


1;
