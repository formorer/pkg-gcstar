package GCExtract;

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
use Gtk2;

{
    package GCExtractDialog;

    use base qw 'Gtk2::Dialog';

    sub show
    {
        my $self = shift;
        return if $self->{cancelled};
        $self->show_all;
        my $code = $self->run;
        if ($code eq 'ok')
        {
            foreach (@{$self->{extractedArray}})
            {
                $self->{info}->{$_} = ''
                    if (! $self->{$_.'Cb'}->get_active);
                $self->{panel}->$_($self->{info}->{$_}->{value})
                    if $self->{info}->{$_} && $self->{info}->{$_}->{value};
            }
        }
        $self->hide;
    }

    sub setInfo
    {
        my ($self, $infoExtractor, $panel) = @_;
        my $info = $infoExtractor->getInfo;
        if (!defined $info)
        {
            $self->{cancelled} = 1;
            return;
        }
        $self->{cancelled} = 0;
        ($self->{info}, $self->{panel}) = ($info, $panel);
        foreach (@{$self->{extractedArray}})
        {
            next if ! $self->{$_};
            if ($info->{$_})
            {
                $self->{$_}->set_text($info->{$_}->{displayed});
                $self->{$_}->set_selectable(1);
            }
            else
            {
                $self->{$_}->set_text('-');
                $self->{$_}->set_selectable(0);
            }
        }
    }
    
    sub new
    {
        my ($proto, $parent, $model, $infoExtractor) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent->{lang}->{ExtractTitle},
                              $parent,
                              [qw/modal destroy-with-parent/],
                              'gtk-cancel' => 'cancel'
                              );
        bless($self, $class);

        $self->{extractedArray} = $infoExtractor->getFields;
        #['length', 'size', 'type', 'audioEncoding'];

        my $table = new Gtk2::Table(4,2);
        $table->set_col_spacings(10);
        $table->set_row_spacings(10);
        $table->set_border_width(10);
        
        my $i = 0;
        foreach (@{$self->{extractedArray}})
        {
            (my $capsField = $_) =~ s/^(.)/\U$1\E/;
            $self->{$_.'Cb'} = new Gtk2::CheckButton($model->getDisplayedLabel($_).$parent->{lang}->{Separator});
            $self->{$_.'Cb'}->set_active(1);
            $self->{$_} = new Gtk2::Label;
            $table->attach($self->{$_.'Cb'}, 0, 1, $i, $i+1, 'fill', 'fill', 0, 0);
            $table->attach($self->{$_}, 1, 2, $i, $i+1, 'fill', 'fill', 0, 0);
            $i++;
        }

        $self->vbox->pack_start($table,1,1,0);

        $self->{importButton} = new Gtk2::Button($parent->{lang}->{ExtractImport});
        $self->add_action_widget($self->{importButton}, 'ok');

        $self->{parent} = $parent;
        return $self;
    }
}

use GCExportImport;

{
    package GCItemExtracter;
    use base 'GCExportImportBase';
    
    sub getInfo
    {
    }

    sub new
    {
        my ($proto, $parent, $fileName, $panel, $model) = @_;
        my $class = ref($proto) || $proto;
        
        my $fileSize = -s $fileName;

        my $self = {fileName => $fileName,
                    fileSize => $fileSize,
                    parent => $parent,
                    panel => $panel,
                    model => $model};
        
        bless($self, $class);
        
        return $self;
    }
}


1;
