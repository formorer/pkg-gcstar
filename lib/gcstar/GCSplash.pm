package GCSplash;

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
    package GCSplashWindow;
    use GCUtils;
    use base "Gtk2::Window";
    
    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);

        $self->{parent} = shift;
        $self->{version} = shift;

        $self->{splashImage} = $self->{parent}->{logosDir}.'splash.png';

        $self->set_decorated(0);
        $self->set_resizable(0);
        $self->set_transient_for($self->{parent});
        $self->set_destroy_with_parent(1);
        $self->set_modal(1);
        $self->set_skip_taskbar_hint(1);

        #$self->set_position('center-always');
        $self->set_keep_above(1);
        
        $self->{title} = new Gtk2::Label;
        $self->{title}->set_markup('<span size="xx-large" weight="bold" color="#1c86ee">GCstar</span>');
        $self->{label} = new Gtk2::Label('test');

        $self->{vbox} = new Gtk2::VBox(0,0);        
		
        $self->{progress} = new Gtk2::ProgressBar;
        $self->{progress}->set_size_request(240,-1);

        my $color_fg = Gtk2::Gdk::Color->parse('#1c86ee');
        my $color_progress_bg = Gtk2::Gdk::Color->parse('#ffffff');
        my $color_progress_fg = Gtk2::Gdk::Color->parse('#1c86ee');
        my $color_progress_text = Gtk2::Gdk::Color->parse('#cdad00');

        $self->{label}->modify_fg('normal', $color_fg);
        $self->{progress}->modify_bg('normal', $color_progress_bg);
        $self->{progress}->modify_bg('active', $color_progress_fg);
        $self->{progress}->modify_bg('prelight', $color_progress_fg);

        my $eventbox = Gtk2::EventBox->new();
        my $img = Gtk2::Image->new_from_pixmap (undef, undef);
        my $inbox = new Gtk2::Fixed;
        $eventbox->add($inbox);
        $inbox->put($img,0,0);
        $inbox->put($self->{title},0,110);
        $inbox->put($self->{label},0,145);
        $inbox->put($self->{progress},30,170);
        $self->{vbox}->pack_start($eventbox,0,0,0);
	    
        $self->add($self->{vbox});
        my $drawing_area = Gtk2::DrawingArea->new;
        $self->{vbox}->pack_start($drawing_area,0,0,0);
        $drawing_area->realize;
		
        my ($pango_w, $pango_h) = (300,200);
        my $pixmap = Gtk2::Gdk::Pixmap->new ($drawing_area->window,
                $pango_w,
                $pango_h,
                -1);

        my $pixbuf = Gtk2::Gdk::Pixbuf->new_from_file($self->{splashImage});
        my ($pm, $m) = $pixbuf->render_pixmap_and_mask(255);
    	$img->set_from_pixmap($pm, $m);
    	$self->shape_combine_mask ($m, 0, 0) if $m;
        $self->set_position('center');
        $self->{vbox}->show_all;
        $self->show;
        $self->{title}->set_size_request(300,-1);
        $self->{label}->set_size_request(300,-1);
        
        return $self;
    }

    sub init
    {
        my $self = shift;

        if ($self->{phase} == 0)
        {
            $self->setLabel($self->{parent}->{lang}->{SplashInit});
            $self->{phase} = 1;
        }
        elsif ($self->{phase} == 1)
        {
            $self->setProgress(0.0);
            $self->{parent}->init($self);
            $self->setProgress(0.1);
            $self->{phase} = 2;
            $self->setLabel($self->{parent}->{lang}->{SplashLoad});
        }
        elsif ($self->{phase} == 2)
        {
            $self->{parent}->loadPrevious($self);
            $self->setProgress(0.7);
#            $self->{parent}->setSensitive(1);
            $self->{phase} = 3;
            $self->setLabel($self->{parent}->{lang}->{SplashSort});
        }
        elsif ($self->{phase} == 3)
        {
            $self->{parent}->initEnd;
            $self->setProgress(1.0);
            $self->{parent}->setSensitive(1);
            $self->{phase} = 4;
            $self->setLabel($self->{parent}->{lang}->{SplashDone});
        }
        else
        {
            $self->hide;
            $self->{parent}->{initializing} = 0;
            Glib::Timeout->add(700 ,\&destroyMe, $self);
            return 0;
        }
        Glib::Timeout->add(100 ,\&init, $self);           

        return 0;
    }

    sub setLabel
    {
        my ($self, $text) = @_;
        #$text =~ s|^(.)|<span size="x-large" color="#cdad00">$1</span>|;
        $self->{label}->set_markup('<b>'.$text.'</b>');    
    }

    sub setItemsTotal
    {
        my ($self, $total) = @_;
        $self->{step} = GCUtils::round($total / 7);
        $self->{step} = 1 if $self->{step} < 1;
        $self->{total} = $total;
    }

    sub setProgressForItemsLoad
    {
        my ($self, $current) = @_;
        if (! $self->{total})
        {
            $self->{progress}->set_fraction(0.2);
        }
        else
        {
            return if ($current % $self->{step});
            $self->setLabel($self->{parent}->{lang}->{SplashLoad}." <span color='#cdad00'>($current/".$self->{total}.')</span>');
            $self->{progress}->set_fraction(0.1 + (($current / $self->{total}) * 0.3));
        }
        GCUtils::updateUI;
    }

    sub setProgressForItemsDisplay
    {
        my ($self, $current) = @_;
        if (! $self->{total})
        {
            $self->{progress}->set_fraction(0.6);
        }
        else
        {
            return if ($current % $self->{step});
            $self->setLabel($self->{parent}->{lang}->{SplashDisplay}." <span color='#cdad00'>($current/".$self->{total}.')</span>');
            $self->{progress}->set_fraction(0.4 + (($current / $self->{total}) * 0.3));
        }
        GCUtils::updateUI;
    }

    sub setProgressForItemsSort
    {
        my ($self, $current) = @_;
        if (! $self->{total})
        {
            $self->{progress}->set_fraction(0.8);
        }
        else
        {
            return if ($current % $self->{step});
            $self->setLabel($self->{parent}->{lang}->{SplashSort}." <span color='#cdad00'>($current/".$self->{total}.')</span>');
            $self->{progress}->set_fraction(0.7 + (($current / $self->{total}) * 0.2));
        }
        GCUtils::updateUI;
    }

    sub setProgress
    {
        my ($self, $current) = @_;
        $self->{progress}->set_fraction($current);
        GCUtils::updateUI;
    }

    sub destroyMe
    {
        my $self = shift;
        
        $self->destroy;
        return 0;
    }

    sub show
    {
        my $self = shift;

        $self->SUPER::show_all;
        $self->{phase} = 0;
        Glib::Timeout->add(10 ,\&init, $self);
    }
}

1;
