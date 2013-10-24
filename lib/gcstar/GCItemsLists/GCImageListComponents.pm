package GCImageListComponents;

###################################################
#
#  Copyright 2005-2011 Christian Jodar
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

{
    package GCImageListItem;
    
    use GCUtils;
    use GCStyle;
    use base "Gtk2::EventBox";
    use File::Temp qw/ tempfile /;
    
    @GCImageListItem::ISA = ('Gtk2::EventBox');
    
    sub new
    {
        my ($proto, $container, $info) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new;
        bless ($self, $class);
        
        # Some information that we'll need later
        $self->{info} = $info;
        $self->{container} = $container;
        $self->{style} = $container->{style};
        $self->{tooltips} = $container->{tooltips};
        $self->{file} = $container->{parent}->{options}->file;
        $self->{collectionDir} = $container->{collectionDir};
        $self->{model} = $container->{parent}->{model};
        $self->{imageCache} = $container->{imageCache};
        $self->{dataManager} = $container->{parent}->{items};
        
        $self->can_focus(1);
        my $image = new Gtk2::Image;
        $self->add($image);
        $self->refreshInfo($info);
        $self->set_size_request($container->{style}->{vboxWidth}, $container->{style}->{vboxHeight});
        $self->show_all;
        
        return $self;
    }
    
    sub setInfo
    {
        my ($self, $info) = @_;

        $self->{info} = $info;
    }
    
    sub refreshInfo
    {
        my ($self, $info, $cacheRefresh) = @_;

        $self->setInfo($info);

        $self->refreshPopup;

        delete $self->{zoomedPixbufCache};

        {
            my $pixbuf = $self->createPixbuf($info, $cacheRefresh);
            if (! $self->{style}->{withImage})
            {
                $self->modify_bg('normal', $self->{style}->{inactiveBg});
            }
            $self->{previousPixbuf} = $pixbuf->copy;
            $self->child->set_from_pixbuf($pixbuf);
        }        
        if ($self->{selected})
        {
            $self->{selected} = 0;
            $self->highlight;
            $self->{selected} = 1;
        }
    }
    
    sub refreshPopup
    {
        my $self = shift;
        # Old versions of Gtk2 don't support set_tooltip_markup
        eval {
            $self->set_tooltip_markup($self->{dataManager}->getSummary($self->{info}->{idx}));
        };
        if ($@)
        {
            print "$@\n";
            # So we do it the old way for them
            $self->{tooltips}->set_tip($self, $self->{info}->{title}, '');
        }
    }
    
    sub savePicture
    {
        my $self = shift;
        $self->{previousPixbuf} = $self->child->get_pixbuf->copy
           if $self->child;
    }
    
    sub restorePicture
    {
        my $self = shift;
        $self->child->set_from_pixbuf($self->{previousPixbuf})
            if $self->{previousPixbuf} && $self->child;
    }
    
    sub startZoomAnimation
    {
        my $self = shift;
        $self->{currentZoom} = 1.01;
        my $pixbuf = $self->createPixbuf($self->{info}, 0, 1.01);
        $self->child->set_from_pixbuf($pixbuf);
        $self->{zoomTimeout} = Glib::Timeout->add(20 , sub {
            my $widget = shift;
            $widget->{currentZoom} += 0.02;
            if ($widget->{currentZoom} > 1.06)
            {
                $widget->{zoomTimeout} = undef;
                return 0;
            }
            my $pixbuf = $widget->createPixbuf($self->{info}, 0, $widget->{currentZoom});
            $widget->child->set_from_pixbuf($pixbuf)
                if $widget->child;
            return 1;
        }, $self);        
    }
    
    sub stopZoomAnimation
    {
        my $self = shift;
        Glib::Source->remove($self->{zoomTimeout})
            if $self->{zoomTimeout};
    }
    
    # This method sets all the event callbacks
    sub prepareHandlers
    {
        my ($self, $idx, $info) = @_;
        $self->{idx} = $idx;
        $self->{info} = $info;
        
        $self->signal_handler_disconnect($self->{mouseHandler})
            if $self->{mouseHandler};
        $self->{mouseHandler} = $self->signal_connect('button_press_event' => sub {
            my ($widget, $event) = @_;

            if (($event->type ne '2button-press') && !(($event->button eq 3) && ($widget->{selected})))
            {
                my $state = $event->get_state;
                my $keepPrevious = 0;
                if ($state =~ /control-mask/)
                {
                    $widget->{container}->select($widget->{idx}, 0, 1);
                }
                elsif ($state =~ /shift-mask/)
                {
                    $widget->{container}->restorePrevious;
                    $widget->{container}->selectMany($widget->{idx});
                }
                else
                {
                    $widget->{container}->select($widget->{idx});
                }
                $widget->{container}->setPreviousSelectedDisplayed($widget->{idx});
        
                #$self->{parent}->display($widget->{idx}) unless $event->type eq '2button-press';
                $widget->{container}->displayDetails(0, keys %{$widget->{container}->{selectedIndexes}});
            }
            
            $widget->{container}->displayDetails(1, $widget->{idx}) if $event->type eq '2button-press';
            $widget->{container}->showPopupMenu($event->button, $event->time) if ($event->button eq 3);
            $widget->grab_focus;
        });

        if ($self->{style}->{withAnimation})
        {
            $self->signal_handler_disconnect($self->{enterHandler})
                if $self->{enterHandler};
            $self->{enterHandler} = $self->signal_connect('enter_notify_event' => sub {
                my ($widget, $event) = @_;
                if (!$widget->{selected})
                {
                    $widget->startZoomAnimation;
                }
            });
            
            $self->signal_handler_disconnect($self->{leaveHandler})
                if $self->{leaveHandler};
            $self->{leaveHandler} = $self->signal_connect('leave_notify_event' => sub {
                my ($widget, $event) = @_;
                if (!$widget->{selected})
                {
                    $widget->stopZoomAnimation;
                    $widget->restorePicture;
                }
            });
        }
        

        $self->signal_handler_disconnect($self->{keyHandler})
            if $self->{keyHandler};

        $self->{keyHandler} = $self->signal_connect('key-press-event' => sub {
            my ($widget, $event) = @_;
            my $displayed = $self->{container}->convertIdxToDisplayed($widget->{idx});
            my $key = Gtk2::Gdk->keyval_name($event->keyval);
            if ($key eq 'Delete')
            {
                $widget->{container}->{parent}->deleteCurrentItem;
                return 1;
            }
            if (($key eq 'Return') || ($key eq 'space'))
            {
                $widget->{container}->displayDetails(1, $widget->{idx});
                return 1;
            }
            my $unicode = Gtk2::Gdk->keyval_to_unicode($event->keyval);
            if ($unicode)
            {
                $self->{container}->showSearch(pack('U',$unicode));
            }
            else
            {
                my $columns = $widget->{container}->getColumnsNumber;
                
                ($key eq 'Right')      ? $displayed++ :
                ($key eq 'Left')       ? $displayed-- :
                ($key eq 'Down')       ? $displayed += $columns : 
                ($key eq 'Up')         ? $displayed -= $columns :
                ($key eq 'Page_Down')  ? $displayed += ($widget->{style}->{pageCount} * $columns):
                ($key eq 'Page_Up')    ? $displayed -= ($widget->{style}->{pageCount} * $columns):
                ($key eq 'Home')       ? $displayed = 0 :
                ($key eq 'End')        ? $displayed = $widget->{container}->getNbItems - 1 :
                                         return 1;

                return 1 if ($displayed < 0) || ($displayed >= $widget->{container}->getNbItems);
                my $column = $displayed % $columns;                
                my $valueIdx = $widget->{container}->convertDisplayedToIdx($displayed);
#                my $keepPrevious = 0;
                my $state = $event->get_state;
                if ($state =~ /control-mask/)
                {
                    $widget->{container}->select($valueIdx, 0, 1);
                    $widget->{container}->unsetPreviousSelectedDisplayed;
                }
                elsif ($state =~ /shift-mask/)
                {
                    $widget->{container}->setPreviousSelectedDisplayed($widget->{idx});
                    $widget->{container}->restorePrevious;
                    $widget->{container}->selectMany($valueIdx);
                }
                else
                {
                    $widget->{container}->select($valueIdx);
                    $widget->{container}->unsetPreviousSelectedDisplayed;
                }
                $widget->{container}->displayDetails(0, $valueIdx);
                $widget->{container}->grab_focus;
                $widget->{container}->showCurrent unless (($key eq 'Left')  && ($column != ($columns - 1)))
                                       || (($key eq 'Right') && ($column != 0));
            }
            return 1;
            
        });
        
    }
    
    sub highlight
    {
        my ($self, $keepPrevious) = @_;
        return if $self->{selected};
        $self->{selected} = 1;
        if (! $self->{style}->{withImage})
        {
            $self->modify_bg('normal', $self->{style}->{activeBg});
        }
#        $self->savePicture
#            unless $keepPrevious;
        
        my $pixbuf = $self->createPixbuf($self->{info}, 0, 1.1);
        
        $pixbuf->saturate_and_pixelate($pixbuf, 1.5, 0);
        $pixbuf = $pixbuf->composite_color_simple ($pixbuf->get_width, $pixbuf->get_height, 'nearest',220, 128, $self->{style}->{activeBgValue}, $self->{style}->{activeBgValue});
        $self->child->set_from_pixbuf($pixbuf);
    }
    
    sub unhighlight
    {
        my ($self) = @_;

        $self->modify_bg('normal', $self->{style}->{inactiveBg})
            if (! $self->{style}->{withImage});
        $self->restorePicture;
        $self->{selected} = 0;
    }
    
    sub createPixbuf
    {
        my ($self, $info, $cacheRefresh, $zoom) = @_;
        
        my $displayedImage = $info->{picture};
        my $pixbuf = undef;
        
        my $borrower = $info->{borrower};
        my $favourite = $info->{favourite};
        
        # Item has a picture assigned
        if ($cacheRefresh)
        {
            $self->{imageCache}->forceCacheUpdateForNextUse;
        }
        
        if ($zoom)
        {
            if (! exists $self->{zoomedPixbufCache}->{$zoom})
            {
                $self->{zoomedPixbufCache}->{$zoom} = $self->{imageCache}->getPixbuf($info, $zoom);
            }
            $pixbuf = $self->{zoomedPixbufCache}->{$zoom};
        }
        else
        {
            $pixbuf = $self->{imageCache}->getPixbuf($info, $zoom);
        }

        my $width;
        my $height;
        my $boxWidth = $self->{style}->{imgWidth};
        my $boxHeight = $self->{style}->{imgHeight};

        my $overlay;
        my $imgWidth;
        my $imgHeight;
        my $targetOverlayHeight;
        my $targetOverlayWidth;
        my $pixbufTempHeight;
        my $pixbufTempWidth;
        my $alpha = 1;
        if ($self->{style}->{useOverlays})
        {
            # Need to call this to get the overlay padding        
            ($imgWidth, $imgHeight, $overlay) = $self->{imageCache}->getDestinationImgSize($pixbuf->get_width,
                                                                                      $pixbuf->get_height);                    
        }
        $width = $pixbuf->get_width;
        $height = $pixbuf->get_height;
        
        # Do the composition

        if ($self->{style}->{useOverlays})
        {
            if ($self->{style}->{withImage})
            {
                # Using background, so center accordingly
                my $offsetX = (($self->{style}->{offsetX} / 2) * $self->{style}->{factor}) + (($boxWidth - ($width + $overlay->{paddingLeft} + $overlay->{paddingRight})) / 2);
                my $offsetY = 15 * $self->{style}->{factor} + ($boxHeight - ($height + $overlay->{paddingTop} + $overlay->{paddingBottom}));

                # Make an empty pixbuf to work within
                my $tempPixbuf =Gtk2::Gdk::Pixbuf->new('rgb', 1, 8,
                                                $self->{style}->{backgroundPixbuf}->get_width,
                                                $self->{style}->{backgroundPixbuf}->get_height);
                $tempPixbuf->fill(0x00000000);

                # Place cover in pixbuf
                $pixbuf->composite($tempPixbuf,
                                      $offsetX + $overlay->{paddingLeft}, $offsetY + $overlay->{paddingTop}, 
                                      $width , $height,
                                      $offsetX + $overlay->{paddingLeft}, $offsetY + $overlay->{paddingTop}, 
                                      1, 1, 
                                      'nearest', 255);
                $pixbuf = $tempPixbuf;
 
                # Composite overlay picture
                $self->{style}->{overlayPixbuf}->composite($pixbuf,
                                                  $offsetX, $offsetY,
                                                  $width + $overlay->{paddingLeft} + $overlay->{paddingRight},
                                                  $height + $overlay->{paddingTop} + $overlay->{paddingBottom},
                                                  $offsetX, $offsetY,
                                                  ($width + $overlay->{paddingLeft} + $overlay->{paddingRight}) / $self->{style}->{overlayPixbuf}->get_width,
                                                  ($height + $overlay->{paddingTop} + $overlay->{paddingBottom}) / $self->{style}->{overlayPixbuf}->get_height, 
                                                  'nearest', 255);

                # Overlay borrower image if required
                if ($borrower && ($borrower ne 'none'))
                {
                   # De-saturate borrowed items
                   $pixbuf->saturate_and_pixelate($pixbuf, .1, 0);
                   $self->{style}->{lendPixbuf}->composite($pixbuf,
                                                  $pixbuf->get_width - $self->{style}->{lendPixbuf}->get_width - $offsetX,
                                                  $offsetY + $height + $overlay->{paddingTop} + $overlay->{paddingBottom} - $self->{style}->{lendPixbuf}->get_height,
                                                  $self->{style}->{lendPixbuf}->get_width, $self->{style}->{lendPixbuf}->get_height,
                                                  $pixbuf->get_width - $self->{style}->{lendPixbuf}->get_width - $offsetX,
                                                  $offsetY + $height + $overlay->{paddingTop} + $overlay->{paddingBottom} - $self->{style}->{lendPixbuf}->get_height,
                                                  1, 1, 
                                                  'nearest', 255);
                }

                # Overlay favourite image if required
                if ($favourite)
                {
                   $self->{style}->{favPixbuf}->composite($pixbuf,
                                                  $pixbuf->get_width - $self->{style}->{favPixbuf}->get_width - $offsetX,
                                                  $offsetY,
                                                  $self->{style}->{favPixbuf}->get_width, $self->{style}->{favPixbuf}->get_height,
                                                  $pixbuf->get_width - $self->{style}->{favPixbuf}->get_width - $offsetX,
                                                  $offsetY,
                                                  1, 1, 
                                                  'nearest', 255);
                }

                # Create and apply reflection if required
                if ($self->{style}->{withReflect})
                {
                    my $reflect;
                    $reflect = $pixbuf->flip(0);
                    $reflect->composite(
                        $pixbuf,
                        0, 2 * ($offsetY + $height + $overlay->{paddingTop} + $overlay->{paddingBottom}) - $pixbuf->get_height,
                        $pixbuf->get_width,
                        2 * ($pixbuf->get_height - $height - $offsetY - $overlay->{paddingTop} - $overlay->{paddingBottom}) - (10 * $self->{style}->{factor}),
                        0, 2 * ($offsetY + $height + $overlay->{paddingTop} + $overlay->{paddingBottom}) - $pixbuf->get_height,
                        1, 1,
                        'nearest', 100
                    );

                    # Apply foreground fading
                    $self->{style}->{foregroundPixbuf}->composite(
                        $pixbuf,
                        0, 0,
                        $pixbuf->get_width, $pixbuf->get_height,
                        0, 0,
                        1, 1,
                        'nearest', 255
                    );
                }

                # Heft created pixbuf onto background
                my $bgPixbuf = $self->{style}->{backgroundPixbuf}->copy;
                $pixbuf->composite($bgPixbuf,
                                      0,0,
                                      $pixbuf->get_width , $pixbuf->get_height,
                                      0,0,
                                      1, 1, 
                                      'nearest', 255);
                $pixbuf = $bgPixbuf;

            }
            else
            {
                # Not using background, so we need to make an empty pixbuf which is right size for overlay first
                my $tempPixbuf =Gtk2::Gdk::Pixbuf->new('rgb', 1, 8,
                                                $width + $overlay->{paddingLeft} + $overlay->{paddingRight},
                                                $height + $overlay->{paddingTop} + $overlay->{paddingBottom});
                $tempPixbuf->fill(0x00000000);
                            
                # Now, place list image inside empty pixbuf
                $pixbuf->composite($tempPixbuf,
                                      $overlay->{paddingLeft}, $overlay->{paddingTop}, 
                                      $width , $height,
                                      $overlay->{paddingLeft}, $overlay->{paddingTop}, 
                                      1, 1, 
                                      'nearest', 255 * $alpha);
                $pixbuf = $tempPixbuf;

                # Place overlay on top of pixbuf
                $self->{style}->{overlayPixbuf}->composite($pixbuf,
                                                  0, 0,
                                                  $width + $overlay->{paddingLeft} + $overlay->{paddingRight},
                                                  $height + $overlay->{paddingTop} + $overlay->{paddingBottom},
                                                  0, 0,
                                                  ($width + $overlay->{paddingLeft} + $overlay->{paddingRight}) / $self->{style}->{overlayPixbuf}->get_width,
                                                  ($height + $overlay->{paddingTop} + $overlay->{paddingBottom}) / $self->{style}->{overlayPixbuf}->get_height, 
                                                  'nearest', 255 * $alpha);

                # Overlay borrower image if required
                if ($borrower && ($borrower ne 'none'))
                {
                   # De-saturate borrowed items
                   $pixbuf->saturate_and_pixelate($pixbuf, .1, 0);

                   $self->{style}->{lendPixbuf}->composite($pixbuf,
                                                  $pixbuf->get_width - $self->{style}->{lendPixbuf}->get_width,
                                                  $pixbuf->get_height - $self->{style}->{lendPixbuf}->get_height,
                                                  $self->{style}->{lendPixbuf}->get_width, $self->{style}->{lendPixbuf}->get_height,
                                                  $pixbuf->get_width - $self->{style}->{lendPixbuf}->get_width,
                                                  $pixbuf->get_height - $self->{style}->{lendPixbuf}->get_height,
                                                  1, 1, 
                                                  'nearest', 255);
                }

                # Overlay favourite image if required
                if ($favourite)
                {
                   $self->{style}->{favPixbuf}->composite($pixbuf,
                                                  $pixbuf->get_width - $self->{style}->{favPixbuf}->get_width,
                                                  0,
                                                  $self->{style}->{favPixbuf}->get_width, $self->{style}->{favPixbuf}->get_height,
                                                  $pixbuf->get_width - $self->{style}->{favPixbuf}->get_width,
                                                  0,
                                                  1, 1, 
                                                  'nearest', 255);
                }

            }
        }
        else
        {
            # No overlays, nice and simple

            # Overlay borrower image if required
            if ($borrower && ($borrower ne 'none'))
            {
               # De-saturate borrowed items
               $pixbuf->saturate_and_pixelate($pixbuf, .1, 0);
               $self->{style}->{lendPixbuf}->composite($pixbuf,
                                              $width - $self->{style}->{lendPixbuf}->get_width - $self->{style}->{factor},
                                              $height - $self->{style}->{lendPixbuf}->get_height - $self->{style}->{factor},
                                              $self->{style}->{lendPixbuf}->get_width, $self->{style}->{lendPixbuf}->get_height,
                                              $width - $self->{style}->{lendPixbuf}->get_width - $self->{style}->{factor},
                                              $height - $self->{style}->{lendPixbuf}->get_height - $self->{style}->{factor},
                                              1, 1, 
                                              'nearest', 255);
            }

            # Overlay favourite image if required
            if ($favourite)
            {
               $self->{style}->{favPixbuf}->composite($pixbuf,
                                              $width - $self->{style}->{favPixbuf}->get_width - $self->{style}->{factor},
                                              $self->{style}->{factor},
                                              $self->{style}->{favPixbuf}->get_width, $self->{style}->{favPixbuf}->get_height,
                                              $width - $self->{style}->{favPixbuf}->get_width - $self->{style}->{factor},
                                              $self->{style}->{factor},
                                              1, 1, 
                                              'nearest', 255);
            }

            my $reflect;
            $reflect = $pixbuf->flip(0)
                if $self->{style}->{withReflect};

            my $offsetX = (($self->{style}->{offsetX} / 2) * $self->{style}->{factor}) + (($boxWidth - $width) / 2);
            my $offsetY = 15 * $self->{style}->{factor} + ($boxHeight - $height);
            if ($self->{style}->{withImage})
            {
                my $bgPixbuf = $self->{style}->{backgroundPixbuf}->copy;
                $pixbuf->composite($bgPixbuf,
                                   $offsetX, $offsetY, 
                                   $width, $height,
                                   $offsetX, $offsetY,
                                   1, 1, 
                                   'nearest', 255);
                $pixbuf = $bgPixbuf;
            }

            if ($self->{style}->{withReflect})
            {
                $reflect->composite(
                    $pixbuf,
                    $offsetX, $height + $offsetY,
                    $width, $pixbuf->get_height - $height - $offsetY - (10 * $self->{style}->{factor}),
                    $offsetX, $height + $offsetY,
                    1, 1,
                    'nearest', 100
                );

                # Apply foreground fading
                $self->{style}->{foregroundPixbuf}->composite(
                    $pixbuf,
                    0, 0,
                    $pixbuf->get_width, $pixbuf->get_height,
                    0, 0,
                    1, 1,
                    'nearest', 255
                );
            }
        }
        return $pixbuf;
    }
    

    
}

{
    package GCImageCache;
    
    use File::Path;
    use File::Copy;
    use List::Util qw/min/;
    
    sub new
    {
        my ($proto, $imagesDir, $imageSize, $style, $defaultImage) = @_;
        my $class = ref($proto) || $proto;
        my $self  = {
            imagesDir => $imagesDir,
            imageSize => $imageSize,
            style => $style,
            cacheDir => $imagesDir.'/.cache/',
            oldCacheDir => $imagesDir,
            defaultImage => $defaultImage,
            forceUpdate => 0,
        };
        # Make sure destination directory exists
        if ( ! -d $self->{cacheDir})
        {
            mkpath $self->{cacheDir};
        }
        bless ($self, $class);
        
        $self->clearOldCache;
        
        return $self;
    }
    
    # This method removes images cached by previous versions
    sub clearOldCache
    {
        my $self = shift;
        my $trashDir = $self->{imagesDir}.'.trash';
        mkpath $trashDir;
        foreach (glob $self->{oldCacheDir}.'/*')
        {
            if (/\.cache\.[0-4](\.|$)/)
            {
                move $_, $trashDir;
            }
        }
    }
    
    sub forceCacheUpdateForNextUse
    {
        my ($self) = @_;
        $self->{forceUpdate} = 1;
    }
    
    sub getPixbuf
    {
        my ($self, $info, $zoom) = @_;
        my $fileName;
        my $pixbuf = undef;
        if (!$zoom)
        {
            $fileName = $self->getCachedFileName($info);
            if ($self->{forceUpdate} || (! -e $fileName))
            {
                $self->createImageCache($info);
            }
            $self->{forceUpdate} = 0;
            eval {
                $pixbuf = Gtk2::Gdk::Pixbuf->new_from_file($fileName);
            };
        }
        else
        {
            # When a zoom is requested, we have to generate the picture
            $fileName = $self->getCachedFileName($info);
            # Get picture size from cached file to avoid re-computing everything
            my ($picFormat, $picWidth, $picHeight) = Gtk2::Gdk::Pixbuf->get_file_info($fileName);
            # Then open the original file
            my $origFileName = $info->{picture};
            if (! -f $origFileName)
            {
                $origFileName = $self->{defaultImage};
            }
            if (!$self->{style}->{useOverlays})
            {
                $zoom -= 0.01;
            }
            
            eval {
                $pixbuf = Gtk2::Gdk::Pixbuf->new_from_file($origFileName);
                my $newWidth = int($picWidth * $zoom);
                my $newHeight = int($picHeight * $zoom);
                $pixbuf = GCUtils::scaleMaxPixbuf($pixbuf, $newWidth, $newHeight, 1, 0);            
            };
        }
            
        return $pixbuf;
    }
    
    sub getCachedFileName
    {
        my ($self, $info, $size) = @_;
        
        my $gcsautoid = $info->{autoid};
        my $title = $info->{title};
        
        $title =~ s/[^a-zA-Z0-9]*//g;
        my $cacheFilename = $self->{cacheDir};
        if ($info->{picture})
        {
            $cacheFilename .= $gcsautoid
                             ."."
                             .$title;
        }
        else
        {
            $cacheFilename .= 'GCSDefaultImage';
        }
        $cacheFilename .= (defined $size ? $size : $self->{imageSize});
        $cacheFilename .= ".overlay"
            if $self->{style}->{useOverlays};

        return $cacheFilename;
    }
    
    # Resizes artwork to required sizes and saves copies of the images, for fast loading
    sub createImageCache
    {
        my ($self, $info) = @_;

        my $srcImage = $info->{picture};
        if (! -f $srcImage)
        {
            $srcImage = $self->{defaultImage};
            $info->{picture} = "";
        }

        # Load in the original source image
        my $origPixbuf = Gtk2::Gdk::Pixbuf->new_from_file($srcImage);
        
        my $gcsautoid = $info->{autoid};
        my $title = $info->{title};
        $title =~ s/[^a-zA-Z0-9]*//g;
        # Get original picture format
        my ($picFormat, $picWidth, $picHeight) = Gtk2::Gdk::Pixbuf->get_file_info($srcImage);

        # Loop through possible sizes
        for (my $size = 0; $size < 5; $size++) {
            my $imgWidth;
            my $imgHeight;
            my $overlay;
            
            my $cacheFilename = $self->getCachedFileName($info, $size);

            # Get size for cached image
            ($imgWidth, $imgHeight, $overlay) = $self->getDestinationImgSize($picWidth,
                                                                             $picHeight,
                                                                             $size);
            
            # Scale pixbuf and save
            my $scaledPixbuf = GCUtils::scaleMaxPixbuf($origPixbuf, $imgWidth, $imgHeight, 0, 0);
            if ($picFormat->{name} eq 'jpeg')
            {
                $scaledPixbuf->save ($cacheFilename, 'jpeg', quality => '99');        
            }
            else
            {
                $scaledPixbuf->save ($cacheFilename, 'png');                    
            }
        }
    }

    # Calculates height and width of list image
    sub getDestinationImgSize
    {
        my ($self, $origWidth, $origHeight, $size) = @_;
        
        $size = $self->{imageSize}
            if (!defined $size);
        
        my $imgWidth;
        my $imgHeight;
        my $overlay;
        
        # No overlays
        $imgWidth = $self->{style}->{imgWidth} / $self->{style}->{factor};
        $imgHeight = $self->{style}->{imgHeight} / $self->{style}->{factor};
                               
        if ($self->{style}->{useOverlays})
        {
            # Overlays
            
            # Calculate size of list image with proportional size of overlay padding added
            my $pixbufTempHeight = (($self->{style}->{overlayPaddingTop} + $self->{style}->{overlayPaddingBottom})/$self->{style}->{overlayPixbuf}->get_height + 1) * $origHeight;
            my $pixbufTempWidth = (($self->{style}->{overlayPaddingLeft} + $self->{style}->{overlayPaddingRight})/$self->{style}->{overlayPixbuf}->get_width + 1) * $origWidth;

            # Find out target size of overlay, keeping the same ratio as the size calculated above (ie, list image + relative padding)
            my $ratio = $pixbufTempHeight / $pixbufTempWidth;
            my $targetOverlayHeight;
            my $targetOverlayWidth;
            if (($pixbufTempWidth > $imgWidth) || ($pixbufTempHeight > $imgHeight))
            {
                if (($pixbufTempWidth * $imgHeight/$pixbufTempHeight) < $imgHeight )
                {
                    $targetOverlayHeight = $imgHeight;
                    $targetOverlayWidth = int($imgHeight / $ratio);
                }
                else
                {
                    $targetOverlayHeight = int( $imgWidth * $ratio);
                    $targetOverlayWidth =  $imgWidth;
                }
            }
            else
            {
                # Special case when image is small enough and doesn't need to be resized
                $targetOverlayHeight = $pixbufTempHeight;
                $targetOverlayWidth = $pixbufTempWidth;
            }

            # Calculate final offset amounts for target size of overlay
            $overlay->{paddingLeft} = int($self->{style}->{overlayPaddingLeft} * $targetOverlayWidth / $self->{style}->{overlayPixbuf}->get_width);
            $overlay->{paddingRight} = int($self->{style}->{overlayPaddingRight} * $targetOverlayWidth / $self->{style}->{overlayPixbuf}->get_width);
            $overlay->{paddingTop} = int($self->{style}->{overlayPaddingTop} * $targetOverlayHeight / $self->{style}->{overlayPixbuf}->get_height);
            $overlay->{paddingBottom} = int($self->{style}->{overlayPaddingBottom} * $targetOverlayHeight / $self->{style}->{overlayPixbuf}->get_height);

            $imgWidth = $imgWidth - $overlay->{paddingLeft} - $overlay->{paddingRight};
            $imgHeight = $imgHeight - $overlay->{paddingTop} - $overlay->{paddingBottom};
        }

        my $factor = ($size == 0) ? 0.5
                        : ($size == 1) ? 0.8
                        : ($size == 3) ? 1.5
                        : ($size == 4) ? 2
                        : 1;                        
        $imgWidth *= $factor;
        $imgHeight *= $factor;
        
        return ($imgWidth, $imgHeight, $overlay);
    }
    
}

1;
