package GCWidgets;

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

use utf8;
use strict;

{
    package GCRatingWidget;
    use Gtk2;
    use POSIX;
    use Gtk2::Gdk::Keysyms;


    use Glib::Object::Subclass
        Gtk2::DrawingArea::,
        signals => {
            changed => {
                        method      => 'do_rating_changed',
                        flags       => [qw/run-first/],
                        return_type => undef, # void return
                        param_types => [], # instance and data are automatic
            },
            button_press_event => \&on_click,
            button_release_event => \&on_release,
            motion_notify_event => \&on_move,
            leave_notify_event => \&on_leave,
            size_request => \&do_size_request,
            expose_event => \&on_expose,
            focus_in_event => \&on_focus,
            key_press_event => \&on_keypress
        },
        properties => [
            Glib::ParamSpec->int (
                'maxStars', # name
                'Max Stars', # nickname
                'Maximum number of stars to show', #blurb
                0, # min
                100, # max
                10, # default
                [qw/readable writable/] #flags
            ),
            Glib::ParamSpec->int (
                'rating', # name
                'Rating', # nickname
                'Current rating', #blurb
                0, # min
                100, # max
                0, # default
                [qw/readable writable/] #flags
            ),
            Glib::ParamSpec->string (
                'direction', # name
                'Direction', # nickname
                'Direction of stars', #blurb
                'LTR', # default
                [qw/readable writable/] #flags
            ),
        ];

    use constant {
        BORDER_WIDTH => 0,
    };


    sub INIT_INSTANCE {
        my $self = shift;
        $self->{maxStars} = 10;
        $self->{rating} = 0;
        $self->{direction} = 'LTR';

        # Load into some pixbufs the graphics for the stars
        $self->{pixbuf} = Gtk2::Gdk::Pixbuf->new_from_file($ENV{GCS_SHARE_DIR}.'/icons/star.png');
        $self->{pixbufDark} = Gtk2::Gdk::Pixbuf->new_from_file($ENV{GCS_SHARE_DIR}.'/icons/stardark.png');
        $self->{pixbufHover} = Gtk2::Gdk::Pixbuf->new_from_file($ENV{GCS_SHARE_DIR}.'/icons/star_hover.png');
        $self->{pixbufDarkHover} = Gtk2::Gdk::Pixbuf->new_from_file($ENV{GCS_SHARE_DIR}.'/icons/stardark_hover.png');

        # Grab width and height of pixbuf
        $self->{pixbufWidth} = $self->{pixbuf}->get_width;
        $self->{pixbufHeight} = $self->{pixbuf}->get_height; 

        # Allow focus
        $self->can_focus(1);

        $self->{tooltips} = Gtk2::Tooltips->new();

        $self->add_events(['exposure-mask',
                           'visibility-notify-mask',
                           'button-press-mask',
                           'button-motion-mask',
                           'button-release-mask',
                           'pointer-motion-mask',
                           'leave-notify-mask',
                           'key-press-mask',
                           'enter-notify-mask']);
    }

    sub GET_PROPERTY
    {
        my ($self, $pspec) = @_;

        if ($pspec->get_name eq 'rating')
        {
            return $self->{rating};
        }
    }

    sub do_size_request
    {
        # Let gtk know how large we want the control to be
        my ($self, $requisition) = @_;

        $requisition->width(($self->{pixbufWidth} * $self->{maxStars}) + (BORDER_WIDTH * 2));
        $requisition->height($self->{pixbufHeight});

        # chain up to the parent class.
        shift->signal_chain_from_overridden(@_);
    }

    sub convert_color_to_string
    {
        # Convert a gdk::color to an rrggbbaa hex 
        my ($color, $alpha) = @_;
        my $color_string;

        $color_string = sprintf("%.2X", floor($color->red  /256))
                      . sprintf("%.2X", floor($color->green/256))
                      . sprintf("%.2X", floor($color->blue /256))
                      . sprintf("%.2X", $alpha);

        return $color_string;
    }

    sub draw_stars
    {
        # Draw the stars on the control 
        my ($self, $coloredStars, $glowingStars) = @_;

        # Make sure we don't try to draw the control before the background has been saved
        if ( $self->{blankPixbuf} )
        {

            my $targetPixbuf = $self->{blankPixbuf}->copy;
            my $starPixbuf;

            # For each star, determine which pixbuf to use

            for(my $count = 0; $count < $self->{maxStars}; $count++)
            {
                if ($count < $glowingStars)
                {
                    $starPixbuf = ($count < $coloredStars) ? $self->{pixbufHover}
                                :                            $self->{pixbufDarkHover};
                }
                else
                {
                    $starPixbuf = ($count < $coloredStars) ? $self->{pixbuf}
                                :                            $self->{pixbufDark};
                }

                # Put the star in the proper place
                if ($self->{direction} eq 'LTR')
                {
                    # Left to Right
                    $starPixbuf->composite($targetPixbuf,
                                                  (($count * $self->{pixbufWidth}) + BORDER_WIDTH), 0,
                                                  $self->{pixbufWidth} , $self->{pixbufHeight},
                                                  (($count * $self->{pixbufWidth}) + BORDER_WIDTH), 0, 
                                                  1, 1, 
                                                  'nearest', 255);
                }
                else
                {
                   # Right to Left
                   $starPixbuf->composite($targetPixbuf,
                                                  $self->allocation->width - ((($count + 1) * $self->{pixbufWidth}) + BORDER_WIDTH), 0,
                                                  $self->{pixbufWidth} , $self->{pixbufHeight},
                                                  $self->allocation->width - ((($count + 1) * $self->{pixbufWidth}) + BORDER_WIDTH), 0, 
                                                  1, 1, 
                                                  'nearest', 255);
                }
            }

            # Fill the drawable with our generated pixbuf of the stars
            $self->realize;
            my $windowgc = Gtk2::Gdk::GC->new($self->window); 
            $targetPixbuf->render_to_drawable($self->window,
                                              $windowgc,
                                              0, 0, 0, 0,
                                              $self->allocation->width,
                                              $self->allocation->height,
                                              'normal', 0,0);
        }
    }

    sub coordToNumberStars
    {
        # Translate an x-coordinate to how many stars it represents
        my ($self, $x) = @_;

        if ($self->{direction} ne 'LTR')
        {
            # Right to Left, easiest just to flip to coordinate over
            $x = $self->allocation->width - $x;
        }

        if ($x < ($self->{pixbufWidth} / 3))
        {
            # We reserve the first 1/3 of a star to mean "no stars selected"
            return 0;
        }
        else
        {
            my $value = ceil($x / $self->{pixbufWidth});
            return ($value <= $self->{maxStars}) ? $value : $self->{maxStars};
        }
    }

    sub on_expose
    {   
        # Called when control is first drawn
        my ($self, $event) = @_; 

        # Make a small (1x1) pixbuf of the empty control
        $self->{blankPixbuf} = Gtk2::Gdk::Pixbuf->new('rgb', 1, 8,
                                                      1,
                                                      1);

        # Now, grab the first tiny section of the empty region. We can't grab the whole
        # thing, because it might not be visible, and it would get filled with random data
        $self->{blankPixbuf}->get_from_drawable($self->window, $self->get_colormap(),
                                                0, 0, 0, 0,
                                                1,
                                                1);
                                                
        # Now, resize this pixbuf to the full size of the control
        $self->{blankPixbuf} = $self->{blankPixbuf}->scale_simple($self->allocation->width,
                                                                  $self->allocation->height,
                                                                  'nearest');                                         
        
        # Draw the initial control
        if ($self->has_focus)
        {
            # If control is initially focused, make sure we highlight selected stars
            my $starsSelected;
            $starsSelected = ($self->{rating} eq 0) ? 1
                           :                          $self->{rating};
            $self->draw_stars($self->{rating}, $starsSelected);
        }
        else
        {
            $self->draw_stars($self->{rating}, 0);
        }

        return 0;
    }

    sub on_leave
    {
        # Called when mouse leaves the control, remove all highlighting
        my ($self, $event) = @_;

        if ($self->has_focus)
        {
            # If control is still focused, leave highlight on selected stars
            my $starsSelected;
            $starsSelected = ($self->{rating} eq 0) ? 1
                           :                          $self->{rating};
            $self->draw_stars($self->{rating}, $starsSelected );
        }
        elsif ($event->mode() eq "normal")
        {
            # React to mouse leaving the control when control not focused, clear all highlights
            $self->{starsGlowing} = 0;
            $self->draw_stars($self->{rating}, 0);
        }
    }

    sub on_click
    {
        # Called when mouse button pressed down, set rating
        my ($self, $event) = @_;

        my $starsSelected = $self->coordToNumberStars($event->x);

        if ($starsSelected ne $self->{rating})
        {
            $self->{rating} = $starsSelected;
            $self->{starsGlowing} = $starsSelected;
            $self->draw_stars($self->{rating}, $self->{starsGlowing});
            $self->signal_emit ("changed");
        }

        $self->grab_focus;
    }

    sub on_release
    {
        # Called when mouse button released, set rating
        my ($self, $event) = @_;

        my $starsSelected = $self->coordToNumberStars($event->x);

        if ($starsSelected ne $self->{rating})
        {
            $self->{rating} = $starsSelected;
            $self->{starsGlowing} = $starsSelected;
            $self->draw_stars($self->{rating}, $self->{starsGlowing});
            $self->signal_emit ("changed");
        }
    }

    sub on_move
    {
        # Called when mouse moves on control, change star highlighting if needed
        my ($self, $event) = @_;

        my $starsSelected = $self->coordToNumberStars($event->x);

        if ($starsSelected ne $self->{starsGlowing})
        {
            $self->{starsGlowing} = $starsSelected;
            $self->draw_stars($self->{rating}, $self->{starsGlowing});
            $self->createTooltip($self->{starsGlowing});
        }
    }

    sub createTooltip
    {
        my ($self, $tipValue) = @_;

        if ($self->{direction} eq 'LTR')
        {
            $self->{tooltips}->set_tip($self, $tipValue."/".$self->{maxStars});
        }
        else
        {
            # Hmmm - not sure if a / is the right symbol to use for rtl languages, perhaps it should be a \ ?
            $self->{tooltips}->set_tip($self, $self->{maxStars}."/".$tipValue);
        }
    }

    sub on_focus
    {
        # Called when control focused, change star highlighting
        my ($self, $event) = @_;

        if ($self->{rating} > 0)             
        {
            $self->draw_stars($self->{rating}, $self->{rating});
        }
        else
        {
            # If no stars are filled in, we'll just highlight the first star to show control is focused 
            $self->draw_stars($self->{rating}, 1);              
        }

    }

    sub on_keypress
    {
        # Called when key pressed
        my ($self, $event) = @_;

        if ( ($event->keyval eq $Gtk2::Gdk::Keysyms{Right}) && ($self->{direction} eq 'LTR') ||
             ($event->keyval eq $Gtk2::Gdk::Keysyms{Left}) && ($self->{direction} ne 'LTR') )
        {
            # Increase rating
            $self->{rating}++ if $self->{rating} < $self->{maxStars}; 
            $self->draw_stars($self->{rating}, $self->{rating});
            $self->signal_emit ("changed");
           
            # Cancel key propagation
            return 1;
        }
        elsif ( ($event->keyval eq $Gtk2::Gdk::Keysyms{Left}) && ($self->{direction} eq 'LTR') ||
                ($event->keyval eq $Gtk2::Gdk::Keysyms{Right}) && ($self->{direction} ne 'LTR') )
        {
            # Decrease rating
            $self->{rating}-- if $self->{rating} > 0; 
            if ($self->{rating} > 0)             
            {
                # If no stars are filled in, we'll just highlight the first star to show control is focused
                $self->draw_stars($self->{rating}, $self->{rating});
            }
            else
            {                 
                $self->draw_stars($self->{rating}, 1); 
            }
            $self->signal_emit ("changed");

            # Cancel propagation
            return 1;
       }
    }

    sub set_rating
    {
        # Manual way of setting rating
        my ($self, $rating) = @_;

        $self->{rating} = $rating;
        $self->draw_stars($self->{rating}, 0);
        $self->signal_emit ('changed');
    }
}

1;

