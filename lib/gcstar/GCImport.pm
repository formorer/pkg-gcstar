package GCImport;

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

use File::Basename;
use GCUtils 'glob';

use base 'Exporter';
our @EXPORT = qw(@importersArray);

our @importersArray;

sub loadImporters
{
    foreach (glob $ENV{GCS_LIB_DIR}.'/GCImport/*.pm')
    {
        my $import = basename($_, '.pm')."\n";
        next if $import =~ /GCImportBase/;
        eval "use GCImport::$import";
        (my $importer = $import) =~ s/^GCImport/GCImporter/;
        my $obj;
        eval "\$obj = new GCImport::$importer";
        die "Fatal error with importer $import\n$@" if $@;
        push @importersArray, $obj if ! $obj->{errors};
    }
}

use Gtk2;
use GCExportImport;


{
    package GCImportDialog;
    use Glib::Object::Subclass
                Gtk2::Dialog::
    ;
    
    @GCImportDialog::ISA = ('GCExportImportDialog');

    sub addOptions
    {
        my ($self, $options) = @_;
        $options->{newList} = ($self->{newList}->get_active) ? 1 : 0;
        $options->{parent} = $self->{parent};
    }

    sub setModule
    {
        my ($self, $module) = @_;
        
        $self->SUPER::setModule($module);
        $self->{currentList}->set_sensitive(scalar @{$module->getModels} == 0);
        $self->{newList}->set_active(1);
        if ($self->{parent}->{model})
        {
            foreach (@{$module->getModels})
            {
                if ($self->{parent}->{model}->getName eq $_)
                {
                    $self->{currentList}->set_sensitive(1);
                    last;
                }
            }
        }
        if ($self->{fieldsDialog})
        {
            if ($module->wantsIgnoreField)
            {
                $self->{fieldsDialog}->addIgnoreField($self->{parent}->{ignoreString});
            }
            else
            {
                $self->{fieldsDialog}->removeIgnoreField;
            }
        }
    }
    
    sub setModel
    {
        my $self = shift;
        $self->{fieldsDialog} = new GCFieldsSelectionDialog($self,
                                                            $self->{parent}->{lang}->{ImportFieldsTitle});
    }

    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent, $parent->{lang}->{ImportListTitle}, 'import');
        bless ($self, $class);

        my $vboxInsert = new Gtk2::VBox(0,0);
        $vboxInsert->set_border_width(0);
        
        $self->{newList} = new Gtk2::RadioButton(undef, $parent->{lang}->{ImportNewList});
        $self->{currentList} = new Gtk2::RadioButton($self->{newList}->get_group, $parent->{lang}->{ImportCurrentList});
                
#        $vboxInsert->pack_start($self->{newList},1,1,0);
#        $vboxInsert->pack_start($self->{currentList},1,1,0);
#        
#        $self->vbox->pack_start(new Gtk2::HSeparator, 1, 1, 5);
#        $self->vbox->pack_start($vboxInsert,0,0,0);

        $self->{dataTable}->resize(4, 2);
        $self->{dataTable}->attach($self->{newList}, 0, 2, 0, 1, 'fill', 'fill', 0, 0);
        $self->{dataTable}->attach($self->{currentList}, 0, 2, 1, 2, 'fill', 'fill', 0, 0);
        $self->{dataTable}->attach($self->{labelFile}, 0, 1, 3, 4, 'fill', 'fill', 0, 0);
        $self->{dataTable}->attach($self->{file}, 1, 2, 3, 4, ['fill', 'expand'], 'fill', 0, 0);

        $self->{fieldsButtonLabel} = $parent->{lang}->{ImportFieldsTitle};
        $self->{fieldsTip} = $parent->{lang}->{ImportFieldsTip};

        return $self;
    }
    
}


1;
