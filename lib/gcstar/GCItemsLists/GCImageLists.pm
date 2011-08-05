package GCImageLists;

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
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
###################################################

use strict;
use locale;

# Number of ms to wait before enhancing the next picture
my $timeOutBetweenEnhancements = 50;

{
    package GCBaseImageList;
    
    use File::Basename;
    use GCUtils;
    use GCStyle;
    use base "Gtk2::VBox";
    use File::Temp qw/ tempfile /;
    
    sub new
    {
        my ($proto, $container, $columns) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new(0,0);
        bless ($self, $class);
        
        my $parent = $container->{parent};
        
        $self->{preferences} = $parent->{model}->{preferences};
        $self->{imagesDir} = $parent->getImagesDir();
        $self->{coverField} = $parent->{model}->{commonFields}->{cover};
        $self->{titleField} = $parent->{model}->{commonFields}->{title};
        $self->{borrowerField} = $parent->{model}->{commonFields}->{borrower}->{name};
        $self->{selectedIndexes} = {};
        $self->{previousSelectedDisplayed} = 0;
        $self->{displayedToItemsArray} = {};
        $self->{container} = $container;
        $self->{scroll} = $container->{scroll};
        $self->{searchEntry} = $container->{searchEntry};
        

        $self->{preferences}->sortOrder(1)
            if ! $self->{preferences}->exists('sortOrder');
        
        $self->{parent} = $container->{parent};
        
        $self->{tooltips} = Gtk2::Tooltips->new();
        
        $self->{columns} = $columns;
        $self->{dynamicSize} = ($columns == 0);
        $self->clearCache;


        $self->set_border_width(0);

        $self->signal_connect('button_press_event' => sub {
            my ($widget, $event) = @_;
            if ($event->button eq 3)
            {
                $self->{parent}->{context}->popup(undef, undef, undef, undef, $event->button, $event->time)
            }
        });

        $self->can_focus(1);
        
        return $self;
    }

    sub couldExpandAll
    {
        my $self = shift;
        
        return 0;
    }

    sub getCurrentIdx
    {
        my $self = shift;
        return $self->{displayedToIdx}->{$self->{current}};
    }

    sub getCurrentItems
    {
        my $self = shift;
        my @indexes = keys %{$self->{selectedIndexes}};
        return \@indexes;
    }

    sub isSelected
    {
        my ($self, $idx) = @_;
        foreach (keys %{$self->{selectedIndexes}})
        {
            return 1 if $_ == $idx;
        }
        return 0;
    }

    sub DESTROY
    {
        my $self = shift;
        
        #unlink $self->{style}->{tmpBgPixmap};
        $self->SUPER::DESTROY;
    }

    sub isUsingDate
    {
        my ($self) = @_;
        return 0;
    }

    sub setSortOrder
    {
        my ($self, $order) = @_;
        $order = 0 if !defined $order;
        $self->{currentOrder} = ($order == -1) ? (1 - $self->{currentOrder})
                                               : $self->{preferences}->sortOrder;

        if ($self->{itemsArray})
        {
            if ($order == -1)
            {
                @{$self->{itemsArray}} = reverse @{$self->{itemsArray}};
            }
            else
            {
                sub compare
                {
                    return (
                            GCUtils::gccmp ($a->{title}, $b->{title})
                           );
                }
                if ($self->{currentOrder} == 1)
                {
                    @{$self->{itemsArray}} = sort compare @{$self->{itemsArray}};
                }
                else
                {
                    @{$self->{itemsArray}} = reverse sort compare @{$self->{itemsArray}};
                }
            }
        }
        $self->refresh if ! $self->{initializing};
        $self->{initializing} = 0;
    }

    sub setFilter
    {
        my ($self, $filter, $items, $refresh, $splash) = @_;
        $self->{displayedNumber} = 0;
        $self->{filter} = $filter;
        $self->{displayedToItemsArray} = {};
        my $current = $self->{current};
        $self->restorePrevious;
        my $i = 0;
        foreach (@{$self->{itemsArray}})
        {
            $_->{displayed} = $filter->test($items->[$_->{idx}]);
            if ($_->{displayed})
            {
                $self->{displayedToItemsArray}->{$self->{displayedNumber}} = $i;
                $self->{displayedNumber}++;
            }
            $self->{container}->setDisplayed($_->{idx}, $_->{displayed});
            $i++;
        }
        my $newIdx = $self->getFirstVisibleIdx($current);
        my $conversionNeeded = 0;
        $conversionNeeded = 1 if ! exists $self->{boxes}->[$current];
        
        if ($refresh)
        {
            $self->refresh(1, $splash);
            $self->show_all;
        }
        
        $self->{initializing} = 0;
        return $self->displayedToItemsArrayIdx($newIdx)
            if $conversionNeeded;
        return $newIdx;
    }

    sub getFirstVisibleIdx
    {
        my ($self, $displayed) = @_;
        return $displayed if ! exists $self->{boxes}->[$displayed];
        my $currentIdx = $self->{boxes}->[$displayed]->{info}->{idx};
        my $info =  $self->{boxes}->[$displayed]->{info};

        return $currentIdx if (! exists $self->{boxes}->[$displayed])
                           || ($self->{boxes}->[$displayed]->{info}->{displayed});
        my $previous = -1;
        my $after = 0;
        foreach my $item(@{$self->{itemsArray}})
        {
            $after = 1 if $item->{idx} == $currentIdx;
            if ($after)
            {
                return $item->{idx} if $item->{displayed};
            }
            else
            {
                $previous = $item->{idx} if $item->{displayed};
            }
        }
        return $previous;
    }

    sub refresh
    {
        my ($self, $forceClear, $splash) = @_;
        return if $self->{columns} == 0;

        # Store current item index
        my $currentIdx = $self->{displayedToIdx}->{$self->{current}};
        $self->{boxes} = [];
        $self->{displayedToIdx} = {};
        $self->{idxToDisplayed} = {};

        $self->clearView if (! $self->{initializing}) || $forceClear;
        $self->{number} = 0;
        my $idx = 0;
        $self->{collectionDir} = dirname($self->{parent}->{options}->file);
        foreach (@{$self->{itemsArray}})
        {
            $splash->setProgressForItemsSort($idx++) if $splash;
            next if ! $_->{displayed};
            $self->addDisplayedItem($_);
        }
        delete $self->{collectionDir};
        # Determine new current displayed
        $self->{current} = $self->{idxToDisplayed}->{$currentIdx};
        if ($self->{toBeSelectedLater})
        {
            $self->{parent}->display($self->select(-1));
            $self->{toBeSelectedLater} = 0;
        }
        #$self->show_all;
    }

    sub getNbItems
    {
        my $self = shift;
        return $self->{displayedNumber};
    }

    sub clearCache
    {
        my $self = shift;
        
        if ($self->{cache})
        {
            foreach (@{$self->{cache}})
            {
                $_->{eventBox}->destroy
                    if $_->{eventBox};
            }
        }
        $self->{cache} = [];
    }

    sub reset
    {
        my $self = shift;
        #Restore current picture if modified
        $self->restorePrevious;
        
        $self->{itemsArray} = [];
        $self->{boxes} = [];
        $self->{number} = 0;
        $self->{count} = 0;
        $self->{displayedNumber} = 0;
        $self->{current} = 0;
        $self->{previous} = 0;
        $self->clearView;
    }

    sub clearView
    {
        my $self = shift;

        # TODO : This will be different with many lists
        #my $parent = $self->parent;
        #$self->parent->remove($self)
        #    if $parent;

        my @children = $self->get_children;
        foreach (@children)
        {
            my @children2 = $_->get_children;
            foreach my $child(@children2)
            {
                $_->remove($child);
            }
            $self->remove($_);
            $_->destroy;
        }
        $self->{rowContainers} = [];
        $self->{enhanceInformation} = [];
        
        # TODO : This will be different with many lists
        #$self->{scroll}->add_with_viewport($self)
        #    if $parent;

        $self->{initializing} = 1;
    }

    sub done
    {
        my ($self, $splash, $refresh) = @_;
        if ($refresh)
        {
            $self->refresh(0, $splash);
        }
        $self->{initializing} = 0;
    }
    
    sub setColumnsNumber
    {
        my ($self, $columns, $refresh) = @_;
        $self->{columns} = $columns;
        my $init = $self->{initializing};
        $self->{initializing} = 1;
        $self->refresh($refresh);
        $self->show_all;
        $self->{initializing} = $init;
    }
    
    # Resizes artwork to required sizes and saves copies of the images, for fast loading
    sub createImageCache
    {
        my ($self, $srcImage, $useOverlays) = @_;

        # Load in the original source image
        my $origPixbuf = Gtk2::Gdk::Pixbuf->new_from_file($srcImage);
        
        # Make sure destination directory exists
        if ( ! -e $self->{imagesDir})
        {
            mkdir($self->{imagesDir});
        }

        # Get original picture format
        my ($picFormat, $picWidth, $picHeight) = Gtk2::Gdk::Pixbuf->get_file_info($srcImage);

        # Loop through possible sizes
        for (my $size = 0; $size < 5; $size++) {
            my $imgWidth;
            my $imgHeight;
            my $overlay;
            
            my $cacheFilename = $self->{imagesDir}.basename($srcImage).".cache.".$size;
            $cacheFilename .= ".overlay"
                if $useOverlays;

            # Get size for cached image
            ($imgWidth, $imgHeight, $overlay) = $self->getDestinationImgSize($useOverlays, $size,
                                                                            $picWidth,
                                                                            $picHeight);                    
            
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
        my ($self, $useOverlays, $size, $origWidth, $origHeight) = @_;
        
        my $imgWidth;
        my $imgHeight;
        my $overlay;
        
        # No overlays
        $imgWidth = (exists $self->{parent}->{model}->{collection}->{options}->{defaults}->{listImageWidth})
              ? $self->{parent}->{model}->{collection}->{options}->{defaults}->{listImageWidth}
              : 120;
        $imgHeight = (exists $self->{parent}->{model}->{collection}->{options}->{defaults}->{listImageHeight})
                           ? $self->{parent}->{model}->{collection}->{options}->{defaults}->{listImageHeight}
                           : 160;
                               
        if ($useOverlays)
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
    
    sub createPixbuf
    {
        my ($self, $displayedImage, $borrower, $favourite, $forceEnhancement) = @_;
        my $pixbuf = undef;
        
        # Item has a picture assigned
        if ($displayedImage)
        {
            my $cacheFilename =$self->{imagesDir}.basename($displayedImage).".cache.".$self->{parent}->{options}->listImgSize;
            $cacheFilename .= ".overlay"
                if $self->{style}->{useOverlays};
          
            # Does cached image file exist? 
            if (!(-e $cacheFilename))
            {
                # Need to generate the cached images, if original picture exists
                $self->createImageCache($displayedImage, $self->{style}->{useOverlays})
                    if (-e $displayedImage);
            }
            
            # Grab cached image
            eval {
                $pixbuf = Gtk2::Gdk::Pixbuf->new_from_file($cacheFilename);
            };
        }

        # No picture assigned or using assigned picture failed, so use collection default
        if ($@ || !$pixbuf)
        {
            my $cacheFilename = $self->{imagesDir}.basename($self->{parent}->{defaultImage}).".cache.".$self->{parent}->{options}->listImgSize;
                        $cacheFilename .= ".overlay"
                if $self->{style}->{useOverlays};

            # Does cached image file exist? 
            if (!(-e $cacheFilename))
            {
                # Need to generate the cached images
                $self->createImageCache($self->{parent}->{defaultImage}, $self->{style}->{useOverlays})
                    if (-e $self->{parent}->{defaultImage});
            }            
            $pixbuf = Gtk2::Gdk::Pixbuf->new_from_file($cacheFilename);
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
            ($imgWidth, $imgHeight, $overlay) = $self->getDestinationImgSize(1, 2,
                                                                    $pixbuf->get_width,
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
                my $offsetX = 5 * $self->{style}->{factor} + (($boxWidth - ($width + $overlay->{paddingLeft} + $overlay->{paddingRight})) / 2);
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

            my $offsetX = 5 * $self->{style}->{factor} + (($boxWidth - $width) / 2);
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
    
    sub createEventBox
    {
        my ($self, $info) = @_;
        my $eventBox = new Gtk2::EventBox;
        $eventBox->can_focus(1);
        # We store the index of the displayed data
        my $image = new Gtk2::Image;
        my $displayedImage = GCUtils::getDisplayedImage($info->{picture},
                                                        undef,
                                                        $self->{parent}->{options}->file,
                                                        $self->{collectionDir});

        my $pixbuf = $self->createPixbuf($displayedImage, $info->{borrower}, $info->{favourite});

        #$self->{tooltips}->set_tip($eventBox, $info->{title}, '');

        if (! $self->{style}->{withImage})
        {
            $eventBox->modify_bg('normal', $self->{style}->{inactiveBg});
        }

        $image->set_from_pixbuf($pixbuf);
        # ONLY FOR DEBUG
        $eventBox->{picture} = $displayedImage;
        $eventBox->add($image);
        $eventBox->set_size_request($self->{style}->{vboxWidth}, $self->{style}->{vboxHeight});
        if ($self->{initializing})
        {
            push @{$self->{enhanceInformation}}, [$self, $eventBox, $displayedImage, $info->{borrower}, $info->{favourite}, $info->{title}];
        }
        else
        {
            $eventBox->show_all;
        }
        
        return $eventBox;
    }

    sub getFromCache
    {
        my ($self, $info) = @_;
        if (! $self->{cache}->[$info->{idx}])
        {
            my $item = {};
            $item->{eventBox} = $self->createEventBox($info);
            $item->{keyHandler} = 0;
            $item->{mouseHandler} = 0;
            $self->{cache}->[$info->{idx}] = $item;
        }
        return $self->{cache}->[$info->{idx}];
    }
    
    sub findPlace
    {
        my ($self, $item, $title) = @_;
        my $refTitle = $title || $item->{title};
        $refTitle = uc($refTitle);
        # First search where it should be inserted
        my $place = 0;
        my $itemsIdx = 0;
        if ($self->{currentOrder} == 1)
        {
            foreach my $followingItem(@{$self->{itemsArray}})
            {
                my $testTitle = uc($followingItem->{title});
                my $cmp = ($testTitle gt $refTitle);
                $itemsIdx++ if ! $cmp;
                
                next if !$followingItem->{displayed};
                last if $cmp;
                $place++;
            }
        }
        else
        {
            foreach my $followingItem(@{$self->{itemsArray}})
            {
                my $cmp = (uc($followingItem->{title})
                           lt
                           $refTitle);
                $itemsIdx++ if ! $cmp;
                next if !$followingItem->{displayed};
                last if $cmp;
                $place++;
            }
        }
        return ($place, $itemsIdx) if wantarray;
        return $place;
    }

    sub addItem
    {
        my ($self, $info, $immediate, $idx, $keepConversionTables) = @_;
        my $item = {
                     idx => $idx,
                     title => $self->{parent}->transformTitle($info->{$self->{titleField}}),
                     picture => $info->{$self->{coverField}},
                     borrower => $info->{$self->{borrowerField}},
                     favourite => $info->{favourite},
                     displayed => 1,
                   };

        if ($immediate)
        {
            # When the flag is set, that means we modified an item and that it had
            # to be added to that group. In this case, we don't want to de-select
            # the current one.
            if (!$keepConversionTables)
            {
                $self->restorePrevious;
                # To force the selection
                $self->{current} = -1;
            }
            # First search where it should be inserted
            my ($place, $itemsArrayIdx) = $self->findPlace($item);
            # Prepare the conversions displayed <-> index
            if (!$keepConversionTables)
            {
                $self->{displayedToIdx}->{$place} = $idx;
                $self->{idxToDisplayed}->{$idx} = $place;
            }
            # Then we insert it at correct position
            $self->addDisplayedItem($item, $place);
            splice @{$self->{itemsArray}}, $itemsArrayIdx, 0, $item;
        }
        else
        {
            # Here we know it will be sorted after
            push @{$self->{itemsArray}}, $item;
        }
        
        $self->{count}++;
        $self->{displayedNumber}++;
        $self->{header}->show_all if $self->{header} && $self->{displayedNumber} > 0;
    }

    # Params:
    #         $info:  Information already formated for this class
    #         $place: Optional value to indicate where it should be inserted
    sub addDisplayedItem
    {
        # info is an iternal info generated 
        my ($self, $info, $place) = @_;
        return if ! $self->{columns};
        my $item = $self->getFromCache($info);
        my $eventBox = $item->{eventBox};
        my $i = $info->{idx};
        if (!defined $place)
        {
            $self->{displayedToIdx}->{$self->{number}} = $i;
            $self->{idxToDisplayed}->{$i} = $self->{number};
        }
        # We store it here to be sure we have the correct one
        $eventBox->{idx} = $i;
        $eventBox->{info} = $info;
        
        $eventBox->signal_handler_disconnect($item->{mouseHandler})
            if $item->{mouseHandler};
        $item->{mouseHandler} = $eventBox->signal_connect('button_press_event' => sub {
            my ($widget, $event) = @_;

            if (($event->type ne '2button-press') && !(($event->button eq 3) && ($widget->{selected})))
            {
                my $state = $event->get_state;
                my $keepPrevious = 0;
                if ($state =~ /control-mask/)
                {
                    $self->select($widget->{idx}, 0, 1);
                }
                elsif ($state =~ /shift-mask/)
                {
                    $self->restorePrevious;
                    my ($min, $max);
                    if ($self->{previousSelectedDisplayed} > $self->{idxToDisplayed}->{$widget->{idx}})
                    {
                        $min = $self->{idxToDisplayed}->{$widget->{idx}};
                        $max = $self->{previousSelectedDisplayed};
                    }
                    else
                    {
                        $min = $self->{previousSelectedDisplayed};
                        $max = $self->{idxToDisplayed}->{$widget->{idx}};
                    }
                    foreach my $displayed($min..$max)
                    {
                        $self->select($self->{displayedToIdx}->{$displayed}, 0, 1);
                    }
                }
                else
                {
                    $self->select($widget->{idx});
                }
                $self->{previousSelectedDisplayed} = $self->{idxToDisplayed}->{$widget->{idx}};
        
                #$self->{parent}->display($widget->{idx}) unless $event->type eq '2button-press';
                $self->{parent}->display(keys %{$self->{selectedIndexes}});
            }
            
            $self->{parent}->displayInWindow if $event->type eq '2button-press';
            $self->{parent}->{context}->popup(undef, undef, undef, undef, $event->button, $event->time) if ($event->button eq 3);
            $widget->grab_focus;
            $self->{container}->setCurrentList($self);
        });

        $eventBox->signal_handler_disconnect($item->{keyHandler})
            if $item->{keyHandler};

        $item->{keyHandler} = $eventBox->signal_connect('key-press-event' => sub {
            my ($widget, $event) = @_;
            my $displayed = $self->{idxToDisplayed}->{$widget->{idx}};
            my $key = Gtk2::Gdk->keyval_name($event->keyval);
            if ($key eq 'Delete')
            {
                $self->{parent}->deleteCurrentItem;
                return 1;
            }
            if (($key eq 'Return') || ($key eq 'space'))
            {
                $self->{parent}->displayInWindow;
                return 1;
            }
            my $unicode = Gtk2::Gdk->keyval_to_unicode($event->keyval);
            if ($unicode)
            {
                $self->showSearch(pack('U',$unicode));
                $self->{searchTimeOut} = Glib::Timeout->add(4000, sub {
                    $self->hideSearch;
                    $self->{searchTimeOut} = 0;
                    return 0;
                });
            }
            else
            {
                ($key eq 'Right')      ? $displayed++ :
                ($key eq 'Left')       ? $displayed-- :
                ($key eq 'Down')       ? $displayed += $self->{columns} : 
                ($key eq 'Up')         ? $displayed -= $self->{columns} :
                ($key eq 'Page_Down')  ? $displayed += ($self->{style}->{pageCount} * $self->{columns}):
                ($key eq 'Page_Up')    ? $displayed -= ($self->{style}->{pageCount} * $self->{columns}):
                ($key eq 'Home')       ? $displayed = 0 :
                ($key eq 'End')        ? $displayed = $self->{displayedNumber} - 1 :
                                         return 1;

                return 1 if ($displayed < 0) || ($displayed >= scalar @{$self->{boxes}});
                my $column = $displayed % $self->{columns};                
                my $valueIdx = $self->{displayedToIdx}->{$displayed};
#                my $keepPrevious = 0;
                my $state = $event->get_state;
                if ($state =~ /control-mask/)
                {
                    $self->select($valueIdx, 0, 1);
                    delete $self->{previousSelectedDisplayed};
                }
                elsif ($state =~ /shift-mask/)
                {
                    $self->{previousSelectedDisplayed} = $self->{idxToDisplayed}->{$widget->{idx}}
                        if !exists $self->{previousSelectedDisplayed};
                    $self->restorePrevious;
                    my ($min, $max);
                    if ($self->{previousSelectedDisplayed} > $displayed)
                    {
                        $min = $displayed;
                        $max = $self->{previousSelectedDisplayed};
                    }
                    else
                    {
                        $min = $self->{previousSelectedDisplayed};
                        $max = $displayed;
                    }
                    foreach my $disp($min..$max)
                    {
                        $self->select($self->{displayedToIdx}->{$disp}, 0, 1);
                    }
                }
                else
                {
                    $self->select($valueIdx);
                    delete $self->{previousSelectedDisplayed};
                }
                
                $self->{parent}->display($valueIdx);
                $self->{container}->setCurrentList($self);
                $self->{boxes}->[$displayed]->grab_focus;
                $self->showCurrent unless (($key eq 'Left')  && ($column != ($self->{columns} - 1)))
                                       || (($key eq 'Right') && ($column != 0));
            }
            return 1;
            
        });

        if (($self->{number} % $self->{columns}) == 0)
        {
            #New row begin
            $self->{currentRow} = new Gtk2::HBox(0,0);
            push @{$self->{rowContainers}}, $self->{currentRow};
            $self->pack_start($self->{currentRow},0,0,0);
            $self->{currentRow}->show_all if ! $self->{initializing};
        }
        
        if (defined($place))
        {
            # Get the row and col where it should be inserted
            my $itemLine = int $place / $self->{columns};
            my $itemCol = $place % $self->{columns};
            # Insert it at correct place
            $self->{rowContainers}->[$itemLine]->pack_start($eventBox,0,0,0);
            $self->{rowContainers}->[$itemLine]->reorder_child($eventBox, $itemCol);
            $eventBox->show_all;
            $self->shiftItems($place, 1, 0, scalar @{$self->{boxes}});
            splice @{$self->{boxes}}, $place, 0, $eventBox;
            $self->initConversionTables;            
        }
        else
        {
            $self->{currentRow}->pack_start($eventBox,0,0,0);
            $self->{idxToDisplayed}->{$i} = $self->{number};
            push @{$self->{boxes}}, $eventBox;
        }

        $self->{number}++;
    }
    
    sub grab_focus
    {
        my $self = shift;
        $self->SUPER::grab_focus;
        $self->{boxes}->[$self->{current}]->grab_focus;
    }

    sub displayedToItemsArrayIdx
    {
        my ($self, $displayed) = @_;
        return 0 if ! exists $self->{boxes}->[$displayed];
        # If we have nothing, that means we have no filter. So displayed and idx are the same
        return $displayed if ! exists $self->{displayedToItemsArray}->{$displayed};
        return $self->{displayedToItemsArray}->{$displayed};
    }

    sub shiftItems
    {
        my ($self, $place, $direction, $justFromView, $maxPlace) = @_;
        my $idx = $self->{displayedToIdx}->{$place};
        my $itemLine = int $place / $self->{columns};
        my $itemCol = $place % $self->{columns};
        # Did we already remove or add the item ?
        my $alreadyChanged = ($direction < 0) || (defined $maxPlace);
        # Useful to always have the same comparison a few lines below
        # Should be >= for $direction == 1
        # This difference is because we didn't added it yet while it has
        # already been removed in the other direction
        #$itemCol-- if ! (defined $maxPlace);
        $itemCol++ if ($direction < 0);
        # Same here
        $idx-- if $alreadyChanged;
        my $newDisplayed = 0;
        my $currentLine = 0;
        my $currentCol;
        my $shifting = 0;
        # Limit indicates which value for column should make use take action
        # For backward, it's the 1st one. For forward, the last one
        my $limit = 0;
        $limit = ($self->{columns} - 1) if $direction > 0;
        foreach my $item(@{$self->{itemsArray}})
        {
            if (!$item->{displayed})
            {
                $item->{idx} += $direction if ((!defined $maxPlace) && ($item->{idx} > $idx));
                next;
            }
            $currentLine = int $newDisplayed / $self->{columns};
            $currentCol = $newDisplayed % $self->{columns};
            $shifting = $direction if (!$shifting)
                                   && (
                                       ($currentLine >  $itemLine)
                                    || (($currentLine == $itemLine)
                                     && ($currentCol  >=  $itemCol))
                                   );
            $shifting = 0 if (defined $maxPlace) && ($newDisplayed > $maxPlace);
            # When using maxPlace, we are only moving in view
            if ((!defined $maxPlace) && ($item->{idx} > $idx))
            {
                $item->{idx} += $direction;
                $self->{cache}->[$item->{idx}]->{eventBox}->{idx} = $item->{idx}
                    if ($item->{idx} > 0) && $self->{cache}->[$item->{idx}];
            }
            if ($shifting)
            {
                # Is this the first/last one in the line?
                if ($currentCol == $limit)
                {
                    $self->{rowContainers}->[$currentLine]->remove(
                        $self->{cache}->[$item->{idx}]->{eventBox}
                    );
                    $self->{rowContainers}->[$currentLine + $direction]->pack_start(
                        $self->{cache}->[$item->{idx}]->{eventBox},
                        0,0,0
                    );
                    # We can't directly insert on the beginning.
                    # So we need a little adjustement here
                    if ($direction > 0)
                    {
                        $self->{rowContainers}->[$currentLine + $direction]->reorder_child(
                            $self->{cache}->[$item->{idx}]->{eventBox},
                            0
                        );
                    }
                }
            }
            $newDisplayed++;
        }
    }

    sub shiftIndexes
    {
        my ($self, $indexes) = @_;
        my $nbIndexes = scalar @$indexes;
        my $nbLower;
        my $currentIdx;
        my @cache;
        foreach my $box(@{$self->{boxes}})
        {
            # Find how many are lowers in our indexes
            # We suppose they are sorted
            $nbLower = 0;
            $currentIdx = $box->{info}->{idx};
            foreach (@$indexes)
            {
                last if $_ > $currentIdx;
                $nbLower++;
            }
            $box->{info}->{idx} -= $nbLower;
            $cache[$box->{info}->{idx}] = $self->{cache}->[$box->{info}->{idx} + $nbLower];
        }
        $self->{cache} = \@cache;
    }

    sub initConversionTables
    {
        my $self = shift;
        my $displayed = 0;
        $self->{displayedToIdx} = {};
        $self->{idxToDisplayed} = {};
        foreach (@{$self->{boxes}})
        {
            $self->{displayedToIdx}->{$displayed} = $_->{info}->{idx};
            $self->{idxToDisplayed}->{$_->{info}->{idx}} = $displayed;
            $_->{idx} = $_->{info}->{idx};
            $displayed++;
        }
    }

    sub removeItem
    {
        my ($self, $idx, $justFromView) = @_;
        $self->{count}--;
        $self->{displayedNumber}--;
        $self->{header}->hide if $self->{displayedNumber} <= 0;
        my $displayed = $self->{idxToDisplayed}->{$idx};
        my $itemLine = int $displayed / $self->{columns};
        #my $itemCol = $displayed % $self->{columns};
        $self->{rowContainers}->[$itemLine]->remove(
            $self->{cache}->[$idx]->{eventBox}
        );

        # Remove event box from cache
        my $itemsArrayIdx = $self->displayedToItemsArrayIdx($displayed);

        $self->{cache}->[$idx]->{eventBox}->destroy;
        $self->{cache}->[$idx]->{eventBox} = 0;

        splice @{$self->{cache}}, $idx, 1 if !$justFromView;
        splice @{$self->{boxes}}, $self->{idxToDisplayed}->{$idx}, 1;

        if ($justFromView)
        {
            $self->shiftItems($displayed, -1, 0, scalar @{$self->{boxes}});
        }
        else
        {
            $self->shiftItems($displayed, -1);
        }
        $self->initConversionTables;

        splice @{$self->{itemsArray}}, $itemsArrayIdx, 1;
        my $next = $self->{displayedToIdx}->{$displayed};
        if ($displayed >= (scalar(@{$self->{boxes}})))
        {
            $next = $self->{displayedToIdx}->{--$displayed}
        }
        $self->{current} = $displayed;
        #$self->select($next, 1);
        
        my $last = scalar @{$self->{itemsArray}};
        #delete $self->{idxToDisplayed}->{$self->{displayedToIdx}->{$last}};
        delete $self->{displayedToIdx}->{$last};
        # To be sure we still have consistent data, we re-initialize the other hash by swapping keys and values.
        $self->{idxToDisplayed} = {};
        my ($k,$v);
        $self->{idxToDisplayed}->{$v} = $k while (($k,$v) = each %{$self->{displayedToIdx}});

        $self->{number}--;
        return $next;
    }

    sub removeCurrentItems
    {
        my ($self) = @_;
        my @indexes = sort {$a <=> $b} keys %{$self->{selectedIndexes}};
        my $nbRemoved = 0;
        $self->restorePrevious;
        my $next;
        foreach my $idx(@indexes)
        {
            $next = $self->removeItem($idx - $nbRemoved);
            $nbRemoved++;
        }
        $self->{selectedIndexes} = {};
        $self->select($next, 1);

        return $next;
    }

    sub restoreItem
    {
        my ($self, $idx) = @_;
        my $previous = $self->{idxToDisplayed}->{$idx};
        return if ($previous == -1) || (!defined $previous);
        $self->{boxes}->[$previous]->modify_bg('normal', $self->{style}->{inactiveBg})
            if (! $self->{style}->{withImage}) && $self->{boxes}->[$previous];
        $self->{boxes}->[$previous]->child->set_from_pixbuf($self->{previousPixbufs}->{$idx})
            if $self->{previousPixbufs}->{$idx} && $self->{boxes}->[$previous] && $self->{boxes}->[$previous]->child;
        $self->{boxes}->[$previous]->{selected} = 0;
        delete $self->{selectedIndexes}->{$idx};
        
    }

    sub restorePrevious
    {
        my ($self, $fromContainer) = @_;
        foreach my $idx(keys %{$self->{selectedIndexes}})
        {
            $self->restoreItem($idx);
        }
        $self->clearPrevious;
        $self->{container}->clearSelected($self) if !$fromContainer;
    }

    sub clearPrevious
    {
        my $self = shift;
        return if ! $self->{previousPixbufs};
        #$self->{previousPixbuf}->destroy;
        $self->{previousPixbufs} = {};
    }

    sub selectAll
    {
        my $self = shift;

        $self->restorePrevious;
        $self->select($self->{displayedToIdx}->{0}, 1, 0);
        foreach my $displayed(1..scalar(@{$self->{boxes}}) - 1)
        {
            $self->select($self->{displayedToIdx}->{$displayed}, 0, 1);
        }
        $self->{parent}->display(keys %{$self->{selectedIndexes}});
    }

    sub select
    {
        my ($self, $idx, $init, $keepPrevious) = @_;
        $idx = $self->{displayedToIdx}->{0} if $idx == -1;
        my $displayed = $self->{idxToDisplayed}->{$idx};
        if (! $self->{columns})
        {
            $self->{toBeSelectedLater} = 1;
            return $idx;
        }
        my @boxes = @{$self->{boxes}};
        return $idx if ! scalar(@boxes);
        my $alreadySelected = 0;
        $alreadySelected = $boxes[$displayed]->{selected}
            if exists $boxes[$displayed];
        my $nbSelected = scalar keys %{$self->{selectedIndexes}};

        return $idx if $alreadySelected && ($nbSelected < 2) && (!$init);
        if ($keepPrevious)
        {
            if (($alreadySelected) && ($nbSelected > 1))
            {

                $self->restoreItem($idx);
                # Special case where user has deselect items, so now only one item is left selected
                # and menus need to be updated to reflect that
                $self->updateMenus(1)
                    if $nbSelected <= 2;                
                return $idx;
            }
            $self->{selectedIndexes}->{$idx} = 1;
        }
        else
        {
            $self->restorePrevious;
            $self->{selectedIndexes} = {$idx => 1};
        }
                   
        $self->{current} = $displayed;
        if (! $self->{style}->{withImage})
        {
            $boxes[$displayed]->modify_bg('normal', $self->{style}->{activeBg});
        
        }
        my $pixbuf = $boxes[$displayed]->child->get_pixbuf
            if exists $boxes[$displayed];
        $self->clearPrevious unless $keepPrevious;
        $self->{previousPixbufs}->{$idx} = $pixbuf->copy;
        $pixbuf->saturate_and_pixelate($pixbuf, 1.8, 0);
        $pixbuf = $pixbuf->composite_color_simple ($pixbuf->get_width, $pixbuf->get_height, 'nearest',220, 128, $self->{style}->{activeBgValue}, $self->{style}->{activeBgValue});
        $boxes[$displayed]->child->set_from_pixbuf($pixbuf);
        $boxes[$displayed]->{selected} = 1;
        $self->grab_focus;
        $self->{container}->setCurrentList($self)
            if $self->{container};
        
        # Update menu items to reflect number of items selected
        $self->updateMenus(scalar keys %{$self->{selectedIndexes}});
        return $idx;        
    }

    sub updateMenus
    {    
        # Update menu items to reflect number of items selected
        my ($self, $nbSelected) = @_;
        foreach (
                 # Menu labels
                 [$self->{parent}->{menubar}, 'duplicateItem', 'MenuDuplicate'],
                 [$self->{parent}->{menubar}, 'deleteCurrentItem', 'MenuEditDeleteCurrent'],
                 # Context menu labels
                 [$self->{parent}, 'contextNewWindow', 'MenuNewWindow'],
                 [$self->{parent}, 'contextDuplicateItem', 'MenuDuplicate'],
                 [$self->{parent}, 'contextItemDelete', 'MenuEditDeleteCurrent'],
                )
        {
            $self->{parent}->{menubar}->updateItem(
                $_->[0]->{$_->[1]},
                $_->[2].(($nbSelected > 1) ? 'Plural' : ''));
        }
    }

    sub setHeader
    {
        my ($self, $header) = @_;
        $self->{header} = $header;
    }

    sub showCurrent
    {
        my $self = shift;
        return if ! $self->{columns};
        if ($self->{initializing})
        {
            Glib::Timeout->add(100 ,\&showCurrent, $self);
            return;
        }
 
        my $adj = $self->{scroll}->get_vadjustment;
        my $totalRows = int $self->{number} / $self->{columns};
        my $row = (int $self->{current} / $self->{columns});

        my $ypos = 0;
        if ($self->{header})
        {
            $ypos = $self->{header}->allocation->y;
            # We scroll also the size of the header.
            # But we don't do that for the 1st row to have it displayed then.
            $ypos += $self->{header}->allocation->height
                if $row;
        }
        # Add the items before
        $ypos += (($row - 1) * $self->{style}->{vboxHeight});
        
        $adj->set_value($ypos);
        return 0;
    }

    sub changeItem
    {
        my ($self, $idx, $previous, $new, $withSelect) = @_;
        return $self->changeCurrent($previous, $new, $idx, 0);
    }

    sub changeCurrent
    {
        my ($self, $previous, $new, $idx, $wantSelect) = @_;
        my $forceSelect = 0;
        #To ease comparison, do some modifications.
        #empty borrower is equivalent to 'none'.
        $previous->{$self->{borrowerField}} = 'none' if $previous->{$self->{borrowerField}} eq '';
        $new->{$self->{borrowerField}} = 'none' if $new->{$self->{borrowerField}} eq '';
        my $previousDisplayed = $self->{idxToDisplayed}->{$idx};
        my $newDisplayed = $previousDisplayed;
        if ($new->{$self->{titleField}} ne $previous->{$self->{titleField}})
        {
            # Adjust title
            my $newTitle = $self->{parent}->transformTitle($new->{$self->{titleField}});
            $self->{boxes}->[$previousDisplayed]->{info}->{title} = $newTitle;
            $self->{tooltips}->set_tip($self->{boxes}->[$previousDisplayed], $newTitle, '');
            my $newItemsArrayIdx;
            ($newDisplayed, $newItemsArrayIdx) = $self->findPlace(undef, $newTitle);
            # We adjust the index as we'll remove an item
            $newDisplayed-- if $newDisplayed > $previousDisplayed;
            if ($previousDisplayed != $newDisplayed)
            {
                #$self->restorePrevious;
                my $itemPreviousLine = int $previousDisplayed / $self->{columns};
                my $itemNewLine = int $newDisplayed / $self->{columns};
                my $itemNewCol = $newDisplayed % $self->{columns};
                my ($direction, $origin, $limit);
                if ($previousDisplayed > $newDisplayed)
                {
                    $direction = 1;
                    $origin = $newDisplayed;
                    $limit = $previousDisplayed - 1;
                }
                else
                {
                    $direction = -1;
                    $origin = $previousDisplayed;
                    $limit = $newDisplayed;
                    $itemNewCol++ if ($itemNewLine > $itemPreviousLine) && ($itemNewCol != 0)
                }
                my $box = $self->{cache}->[$idx]->{eventBox};
                my $previousItemsArrayIdx = $self->displayedToItemsArrayIdx($previousDisplayed);
                #my $newItemsArrayIdx = $self->displayedToItemsArrayIdx($newDisplayed);
                $self->{rowContainers}->[$itemPreviousLine]->remove($box);
                splice @{$self->{boxes}}, $previousDisplayed, 1;
                $self->{rowContainers}->[$itemNewLine]->pack_start($box,0,0,0);
                $self->{rowContainers}->[$itemNewLine]->reorder_child($box, $itemNewCol);

                $self->shiftItems($origin, $direction, 0, $limit);
                my $item = splice @{$self->{itemsArray}}, $previousItemsArrayIdx, 1;
                $newItemsArrayIdx-- if $previousItemsArrayIdx < $newItemsArrayIdx;
                splice @{$self->{itemsArray}}, $newItemsArrayIdx, 0, $item;
                splice @{$self->{boxes}}, $newDisplayed, 0, $box;
                $self->initConversionTables;
            }
        }

        if (($previous->{$self->{coverField}} ne $new->{$self->{coverField}})
         || ($previous->{$self->{borrowerField}} ne $new->{$self->{borrowerField}})
         || ($previous->{favourite} ne $new->{favourite}))
        {
            my ($image, $borrower, $favourite) = ($new->{$self->{coverField}}, $new->{$self->{borrowerField}}, $new->{favourite});
            my @boxes = @{$self->{boxes}};
            my $displayedImage = GCUtils::getDisplayedImage($image,
                                                            undef,
                                                            $self->{parent}->{options}->file);

            my $pixbuf = $self->createPixbuf($displayedImage, $borrower, $favourite);
            $self->{previousPixbufs}->{$idx} = $pixbuf->copy;
            $boxes[$newDisplayed]->child->set_from_pixbuf($pixbuf);
            $forceSelect = 1;
            $wantSelect = 1 if $wantSelect ne '';
        }
        if ($self->{filter})
        {
            # Test visibility
            my $visible = $self->{filter}->test($new);
            if (! $visible)
            {
                $self->{displayedNumber}--;
                $self->restorePrevious if $wantSelect;
                my $itemLine = int $newDisplayed / $self->{columns};
                $self->{rowContainers}->[$itemLine]->remove(
                                                            $self->{cache}->[$idx]->{eventBox}
                                                            );
                my $info = $self->{boxes}->[$newDisplayed]->{info};
                splice @{$self->{boxes}}, $newDisplayed, 1;
                $self->shiftItems($newDisplayed, -1, 0, scalar @{$self->{boxes}});
                $self->initConversionTables;
                $info->{displayed} = $visible;
                $idx = $self->getFirstVisibleIdx($newDisplayed);
                $wantSelect = 0 if ! scalar @{$self->{boxes}}
            }
        }
        $self->select($idx, $forceSelect) if $wantSelect;
        return $idx;
    }

    sub showSearch
    {
        my ($self, $char) = @_;
        $self->{searchEntry}->set_text($char);
        $self->{searchEntry}->show_all;
        $self->activateSearch;
    }

    sub activateSearch
    {
        my ($self) = @_;
        $self->{searchEntry}->grab_focus;
        $self->{searchEntry}->select_region(length($self->{searchEntry}->get_text), -1);
    }

    sub hideSearch
    {
        my $self = shift;        
        $self->{searchEntry}->set_text('');
        $self->{searchEntry}->hide;
        $self->grab_focus;
        $self->{previousSearch} = '';
    }

    sub internalSearch
    {
        my $self = shift;
        
        my $query = $self->{searchEntry}->get_text;
        return if !$query;
        my $newDisplayed = -1;

        my $current = 0;
        my $length = length($query);
        if ($self->{currentOrder})
        {
            if (($length > 1) && ($length > length($self->{previousSearch})))
            {
                $current = $self->{idxToDisplayed}->{$self->{itemsArray}->[$self->{current}]->{idx}};            
            }
            foreach(@{$self->{itemsArray}}[$current..$self->{count} - 1])
            {
                next if !$_->{displayed};
                if ($_->{title} ge $query)
                {
                    $newDisplayed = $self->{idxToDisplayed}->{$_->{idx}};
                    last;
                }
            }
        }
        else
        {
#            if (length($query) > 1)
#            {
#                $current = $self->{idxToDisplayed}->{$self->{itemsArray}->[$self->{current}]->{idx}};            
#            }
            foreach(@{$self->{itemsArray}}[$current..$self->{count} - 1])
            {
                next if !$_->{displayed};
                if (($_->{title} =~ m/^\Q$query\E/i) || ($_->{title} lt $query))
                {
                    $newDisplayed = $self->{idxToDisplayed}->{$_->{idx}};
                    last;
                }
            }
        }

        if ($newDisplayed != -1)
        {
            my $valueIdx = $self->{displayedToIdx}->{$newDisplayed};
            $self->select($valueIdx);
            $self->{parent}->display($valueIdx);
            $self->{boxes}->[$newDisplayed]->grab_focus;
            $self->showCurrent;
            $self->activateSearch;
        }
        $self->{previousSearch} = $query;
    }

}

{
    package GCImageList;
    
    use base "Gtk2::VBox";
    use File::Temp qw/ tempfile /;

    my $defaultGroup = 'GCMAINDEFAULTGROUP';

    sub new
    {
        my ($proto, $parent, $columns) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new(0,0);
        bless ($self, $class);

        $self->{preferences} = $parent->{model}->{preferences};
        $self->{parent} = $parent;
        $self->{columns} = $columns;

        $self->{borrowerField} = $parent->{model}->{commonFields}->{borrower}->{name};

        $self->{scroll} = new Gtk2::ScrolledWindow;
        $self->{scroll}->set_policy ('automatic', 'automatic');
        $self->{scroll}->set_shadow_type('none');

        $self->{searchEntry} = new Gtk2::Entry;
        #$self->{list} = new GCBaseImageList($self, $columns);
        
        $self->{orderSet} = 0;
        $self->{sortButton} = Gtk2::Button->new;
        $self->setSortButton($self->{preferences}->sortOrder);
        $self->{searchEntry}->signal_connect('changed' => sub {
            return if ! $self->{searchEntry}->get_text;
            $self->internalSearch;
        });
        $self->{searchEntry}->signal_connect('key-press-event' => sub {
            my ($widget, $event) = @_;
            Glib::Source->remove($self->{searchTimeOut})
                if $self->{searchTimeOut};
            return if ! $self->{searchEntry}->get_text;
            my $key = Gtk2::Gdk->keyval_name($event->keyval);
            if ($key eq 'Escape')
            {
                $self->hideSearch;
                return 1;
            }
            $self->{searchTimeOut} = Glib::Timeout->add(4000, sub {
                $self->hideSearch;
                $self->{searchTimeOut} = 0;
                return 0;
            });

            return 0;
        });

        #$self->{scroll}->add_with_viewport($self->{list});
        $self->{mainList} = new Gtk2::VBox(0,0);
        $self->{scroll}->add_with_viewport($self->{mainList});
        #$self->{list}->initPixmaps;

        $self->pack_start($self->{sortButton},0,0,0);
        $self->pack_start($self->{scroll},1,1,0);
        $self->pack_start($self->{searchEntry},0,0,0);

        $self->{sortButton}->signal_connect('clicked' => sub {
            $self->setSortOrder(-1);
            $self->setSortButton;
        });
        
        $self->initStyle;
        $self->setGroupingInformation;
        $self->{empty} = 1;
        $self->{orderedLists} = [];
        $self->{displayed} = {};
        return $self;
    }
    
    sub setSortButton
    {
        my ($self, $order) = @_;
        $order = $self->{currentOrder}
            if !defined $order;
        my $image = Gtk2::Image->new_from_stock($order
                                                  ? 'gtk-sort-descending'
                                                  : 'gtk-sort-ascending',
                                                'button');
        my $stockItem = Gtk2::Stock->lookup($order
                                                  ? 'gtk-sort-ascending'
                                                  : 'gtk-sort-descending');
        $stockItem->{label} =~ s/_//g;
        $self->{sortButton}->set_label($stockItem->{label});
        $self->{sortButton}->set_image($image);
        
    }
    
    sub show_all
    {
        my $self = shift;
        $self->SUPER::show_all;
        $self->{mainList}->show_all;
        $self->{searchEntry}->hide;
    }

    sub done
    {
        my $self = shift;
        foreach (values %{$self->{lists}})
        {
            $_->done;
#            $self->{style}->{vboxWidth} = $_->{style}->{vboxWidth}
#                if !exists $self->{style}->{vboxWidth};
        }
        # We set a number of ms to wait before enhancing the pictures
        my $offset = 0;
        foreach (@{$self->{orderedLists}})
        {
            $self->{lists}->{$_}->{offset} = $offset;
            $offset += $timeOutBetweenEnhancements * ($self->{lists}->{$_}->{displayedNumber} + 1);
        }
        if ($self->{columns} == 0)
        {
            $self->signal_connect('size-allocate' => sub {
                $self->computeAllocation;
            });
            $self->computeAllocation;
        }
        else
        {
            foreach (values %{$self->{lists}})
            {
                $_->setColumnsNumber($self->{columns}, 0);
            }
        }
    }

    sub computeAllocation
    {
        my $self = shift;
        return if !$self->{style}->{vboxWidth};
        my $width = $self->{scroll}->child->allocation->width - 15;
        return if $width < 0;
        if (($self->{scroll}->get_hscrollbar->visible)
         || ($width > (($self->{columns} + 1) * $self->{style}->{vboxWidth})))
        {
            my $columns = int ($width / $self->{style}->{vboxWidth});
            if ($columns)
            {
                return if $columns == $self->{columns};
                $self->{columns} = $columns;
                foreach (values %{$self->{lists}})
                {
                    $_->setColumnsNumber($columns, 1);
                }
                # TODO : We should maybe select an item here
                #$self->{parent}->display($self->select(-1, 1))
                #    if !$self->{current};
            }
            else
            {
                $self->{columns} = 1;
            }
        }
        
    }

    sub initStyle
    {
        my $self = shift;
        my $parent = $self->{parent};

        my $size = $parent->{options}->listImgSize;
        $self->{style}->{withImage} = $parent->{options}->listBgPicture;
        $self->{style}->{useOverlays} = ($parent->{options}->useOverlays) && ($parent->{model}->{collection}->{options}->{overlay}->{image});        
        $parent->{options}->listImgSkin($GCStyle::defaultList) if ! $parent->{options}->exists('listImgSkin');
        $self->{style}->{skin} = $parent->{options}->listImgSkin;
        # Reflect setting can be enabled using "withReflect=1" in the listbg style file
        $self->{style}->{withReflect} = 0;
        $parent->{options}->listImgSize(2) if ! $parent->{options}->exists('listImgSize');
        
        my $bgdir;
        # Load in extra settings from the style file
        if ($self->{style}->{withImage})
        {
            $bgdir = $ENV{GCS_SHARE_DIR}.'/list_bg/'.$self->{style}->{skin};
            if (open STYLE, $bgdir.'/style')
            {
                while (<STYLE>)
                {
                    chomp;
                    next if !$_;
                    m/^(.*?)\s*=\s*(.*)$/;
                    my $item = $1;
                    (my $value = $2) =~ s/^"(.*?)"$/$1/;
                    $self->{style}->{$item} = $value;
                }                
                close STYLE;
            }
        }
        
        # Sets image width/height (for size = 2), getting value from the collection model or setting to
        # default values of 120, 160 if not specified in model file
        $self->{style}->{imgWidth} = (exists $parent->{model}->{collection}->{options}->{defaults}->{listImageWidth})
                          ? $parent->{model}->{collection}->{options}->{defaults}->{listImageWidth}
                          : 120;
        $self->{style}->{imgHeight} = (exists $parent->{model}->{collection}->{options}->{defaults}->{listImageHeight})
                           ? $parent->{model}->{collection}->{options}->{defaults}->{listImageHeight}
                           : 160;

        $self->{style}->{vboxWidth} = $self->{style}->{imgWidth} + 10;
        $self->{style}->{vboxHeight} = $self->{style}->{imgHeight} + 10;
        $self->{style}->{vboxHeight} += 20 if $self->{style}->{withImage};

        $self->{style}->{factor} = ($size == 0) ? 0.5
                        : ($size == 1) ? 0.8
                        : ($size == 3) ? 1.5
                        : ($size == 4) ? 2
                        :                        1;                        
        $self->{style}->{imgWidth} *= $self->{style}->{factor};
        $self->{style}->{imgHeight} *= $self->{style}->{factor};
        $self->{style}->{vboxWidth} = $self->{style}->{imgWidth} + (10 * $self->{style}->{factor});
        $self->{style}->{vboxHeight} = $self->{style}->{imgHeight} + (10 * $self->{style}->{factor});
        $self->{style}->{vboxHeight} += (20 * $self->{style}->{factor}) if $self->{style}->{withImage};
        $self->{style}->{vboxHeight} += (30 * $self->{style}->{factor}) if $self->{style}->{withReflect};
        $self->{style}->{pageCount} = int 5 / $self->{style}->{factor};

        # Pixbuf for lending icon
        my $lendImageFile = $ENV{GCS_SHARE_DIR}.'/overlays/lend_';
        $lendImageFile .= ($size < 1) ? 'verysmall'
                        : ($size < 2) ? 'small'
                        : ($size < 3) ? 'med'
                        : ($size < 4) ? 'large'
                        :                       'xlarge';  
        $self->{style}->{lendPixbuf} = Gtk2::Gdk::Pixbuf->new_from_file($lendImageFile.'.png');

        # Pixbuf for favourite icon
        my $favImageFile = $ENV{GCS_SHARE_DIR}.'/overlays/favourite_';
        $favImageFile .= ($size < 1) ? 'verysmall'
                       : ($size < 2) ? 'small'
                       : ($size < 3) ? 'med'
                       : ($size < 4) ? 'large'
                       :                       'xlarge';  
        $self->{style}->{favPixbuf} = Gtk2::Gdk::Pixbuf->new_from_file($favImageFile.'.png');

        if ($self->{style}->{useOverlays})
        {
            $self->{style}->{overlayImage} = $ENV{GCS_SHARE_DIR}.'/overlays/'.$parent->{model}->{collection}->{options}->{overlay}->{image};
            $self->{style}->{overlayPixbuf} = Gtk2::Gdk::Pixbuf->new_from_file($self->{style}->{overlayImage});

            $self->{style}->{overlayPaddingLeft} = $parent->{model}->{collection}->{options}->{overlay}->{paddingLeft};
            $self->{style}->{overlayPaddingRight} = $parent->{model}->{collection}->{options}->{overlay}->{paddingRight};
            $self->{style}->{overlayPaddingTop} = $parent->{model}->{collection}->{options}->{overlay}->{paddingTop};
            $self->{style}->{overlayPaddingBottom} = $parent->{model}->{collection}->{options}->{overlay}->{paddingBottom}; 
        }

        # Default value for align
        $self->{style}->{groupAlign} = 'center';

        if ($self->{style}->{withImage})
        {
            $self->{style}->{bgPixmap} = $bgdir.'/list_bg.png';

            my $tmpPixbuf = Gtk2::Gdk::Pixbuf->new_from_file($self->{style}->{bgPixmap});
            $tmpPixbuf = GCUtils::scaleMaxPixbuf($tmpPixbuf,
                                                 $self->{style}->{vboxWidth},
                                                 $self->{style}->{vboxHeight},
                                                 1);
            (my $fh, $self->{style}->{tmpBgPixmap}) = tempfile(UNLINK => 1);
            close $fh;
            if ($^O =~ /win32/i)
            {
                # It looks like Win32 version only supports JPEG pictures for background
                $tmpPixbuf->save($self->{style}->{tmpBgPixmap}, 'jpeg', quality => '100');
            }
            else
            {
                $tmpPixbuf->save($self->{style}->{tmpBgPixmap}, 'png');
            }
            GCUtils::setWidgetPixmap($self->{mainList}->parent, $self->{style}->{tmpBgPixmap});
            
            $self->{style}->{backgroundPixbuf} = Gtk2::Gdk::Pixbuf->new_from_file($self->{style}->{bgPixmap});
            $self->{style}->{backgroundPixbuf} = GCUtils::scaleMaxPixbuf($self->{style}->{backgroundPixbuf},
                                                                $self->{style}->{vboxWidth},
                                                                $self->{style}->{vboxHeight},
                                                                1);
            my @colors = split m/,/, $self->{parent}->{options}->listFgColor;
            ($colors[0], $colors[1], $colors[2]) = (65535, 65535, 65535) if !@colors;
            my $red   = int($colors[0] / 257);
            my $green = int($colors[1] / 257);
            my $blue   = int($colors[2] / 257);
            $self->{style}->{activeBgValue} = ($red << 16) + ($green << 8) + $blue;

            if ($self->{style}->{withReflect}) 
            {
                $self->{style}->{foregroundPixbuf} = Gtk2::Gdk::Pixbuf->new_from_file($bgdir.'/list_fg.png');
                $self->{style}->{foregroundPixbuf} = GCUtils::scaleMaxPixbuf($self->{style}->{foregroundPixbuf},
                                                                    $self->{style}->{vboxWidth},
                                                                    $self->{style}->{vboxHeight},
                                                                    1);
            }
            
            $self->{groupBgFile} = $bgdir.'/group.png';
        }
        else
        {
            my @colors = split m/,/, $self->{parent}->{options}->listBgColor;
            ($colors[0], $colors[1], $colors[2]) = (65535, 65535, 65535) if !@colors;
            $self->{style}->{inactiveBg} = new Gtk2::Gdk::Color($colors[0], $colors[1], $colors[2]);
            @colors = split m/,/, $self->{parent}->{options}->listFgColor;
            ($colors[0], $colors[1], $colors[2]) = (0, 0, 0) if !@colors;
            $self->{style}->{activeBg} = new Gtk2::Gdk::Color($colors[0], $colors[1], $colors[2]);
            $self->{mainList}->parent->modify_bg('normal', $self->{style}->{inactiveBg});
            $self->{mainList}->parent->modify_bg('active', $self->{style}->{inactiveBg});
            $self->{mainList}->parent->modify_bg('prelight', $self->{style}->{inactiveBg});
            $self->{mainList}->parent->modify_bg('selected', $self->{style}->{inactiveBg});
            $self->{mainList}->parent->modify_bg('insensitive', $self->{style}->{inactiveBg});
        }
    }

    sub initListStyle
    {
        my ($self, $list) = @_;
        $list->{style} = $self->{style};
        if ($self->{style}->{withImage})
        {
            GCUtils::setWidgetPixmap($list->parent, $self->{style}->{tmpBgPixmap});
        }
        else
        {
            $self->set_border_width(5);
            $list->parent->modify_bg('normal', $self->{style}->{inactiveBg});
            $list->parent->modify_bg('active', $self->{style}->{inactiveBg});
            $list->parent->modify_bg('prelight', $self->{style}->{inactiveBg});
            $list->parent->modify_bg('selected', $self->{style}->{inactiveBg});
            $list->parent->modify_bg('insensitive', $self->{style}->{inactiveBg});
        }
    }

    sub setCurrentList
    {
        my ($self, $list) = @_;
        $self->{currentList} = $list;
    }

    sub setGroupingInformation
    {
        my $self = shift;

        $self->{collectionField} = $self->{preferences}->groupBy;
        $self->{groupItems} = ($self->{collectionField} ne '');
        if (!$self->{groupItems})
        {
            $self->addGroup($defaultGroup, uc $defaultGroup, 1)
                if !$self->{currentList};
        }
    }

    sub getGroups
    {
        my ($self, $info) = @_;

        my $field = $self->{collectionField};
        my $value = $info->{$field};
        my $type = '';
        $type = $self->{parent}->{model}->{fieldsInfo}->{$field}->{type}
            if defined $self->{parent}->{model}->{fieldsInfo}->{$field}->{type};
        
        $value = $self->{parent}->transformValue($value, $field, 1);

        if (ref($value) eq 'ARRAY')
        {
            if (!scalar (@$value))
            {
                $value = [$defaultGroup];
            }
        }
        else
        {
            $value = $defaultGroup
                if ($type =~ /text$/) && ($value eq '');
            my @array = ($value);
            $value = \@array;
        }
        
        
        return $value;
    }

    sub sortAndFind
    {
        my ($self, $group) = @_;

        # We insert it in the list
        my @tmpList = @{$self->{orderedLists}};
        #push @tmpList, $group;
        # We sort it
        if ($self->{currentOrder} == 0)
        {
            @tmpList = reverse sort @tmpList;
        }
        else
        {
            @tmpList = sort @tmpList;
        }
        
        # And now we find back its position
        $self->{orderedLists} = \@tmpList;
        return GCUtils::inArray($group, @tmpList);
    }

    sub getNbItems
    {
        my $self = shift;
        
        # We count the number of items in displayed hash where value is 1
        return scalar grep {$_ == 1} values %{$self->{displayed}};
    }

    sub createHeader
    {
        my ($self, $title) = @_;
        my $label;
        my $fixedTitle = $title;
        $fixedTitle =~ s/&/&amp;/;
        $fixedTitle =~ s/</&lt;/;
        $fixedTitle =~ s/>/&gt;/;        
        
        if ($self->{style}->{withImage})
        {
            $label = new GCColorLabel(Gtk2::Gdk::Color->parse('#000000'));
            $label->set_markup('<span '.$self->{style}->{groupStyle}.">$fixedTitle</span>");
            GCUtils::setWidgetPixmap($label, $self->{groupBgFile});
        }
        else
        {
            $label = new GCColorLabel($self->{style}->{activeBg});
            $label->set_markup('<span weight="bold" color="'.$self->{style}->{inactiveBg}->to_string."\">$fixedTitle</span>");
        }
        $label->set_justify($self->{style}->{groupAlign});
        $label->set_padding($GCUtils::halfMargin, $GCUtils::halfMargin);
        return $label;
        return new Gtk2::Label($title);
    }

    sub addGroup
    {
        my ($self, $group, $refGroup, $immediate) = @_;
        
        my $listBox = new Gtk2::VBox(0,0);
        my $list = new GCBaseImageList($self, $self->{columns});
        if ($self->{groupItems})
        {
            my $label;
            if ($refGroup eq $defaultGroup)
            {
                $label = $self->createHeader('');
            }
            else
            {
                $label = $self->createHeader($group);
            }
            $listBox->pack_start($label, 0, 0, 0);
            $list->setHeader($label);
            $list->{refGroup} = $refGroup;
            $label->show_all;
        }
        my $eventBox = new Gtk2::EventBox;
        $eventBox->add($list);
        $listBox->pack_start($eventBox, 0, 0, 0);
        $self->{mainList}->pack_start($listBox, 0, 0, 0);

        push @{$self->{orderedLists}}, $refGroup
            if ($refGroup ne $defaultGroup);
            
        if ($immediate && $self->{groupItems})
        {
            my $place = $self->sortAndFind($refGroup);
            $self->{mainList}->reorder_child($listBox, $place);
        }
            
        $listBox->show_all;
        $self->initListStyle($list);
        $self->{lists}->{$refGroup} = $list;
        $self->{listBoxes}->{$refGroup} = $listBox;
        $self->{currentList} = $list if ! $self->{currentList};
        $list->done(undef, 1) if $immediate;
        return $list;
    }

    sub addItem
    {
        my ($self, $info, $immediate) = @_;
        my $groups = [];
        if ($self->{groupItems})
        {
            $groups = $self->getGroups($info);
        }
        else
        {
            $groups = [$defaultGroup];
        }
        foreach my $group(@$groups)
        {
            my $refGroup = uc($group);
            if (! exists $self->{lists}->{$refGroup})
            {
                $self->addGroup($group, $refGroup, $immediate);
            }
            $self->{currentList} = $self->{lists}->{$refGroup} if $immediate;
            $self->{lists}->{$refGroup}->addItem($info, $immediate, $self->{count}, 0);
            # Storing conversion from index to the actual list
            $self->{idxToList}->{$self->{count}} = $self->{lists}->{$refGroup};
        }
        # Default is to display it. It will maybe be filtered later
        $self->{displayed}->{$self->{count}} = 1;
        $self->{count}++;
    }

    sub couldExpandAll
    {
        my $self = shift;
        
        return $self->{groupItems};
    }

    sub showCurrent
    {
        my $self = shift;
        # TODO:
        $self->{currentList}->showCurrent
            if $self->{currentList};
    }

    sub clearSelected
    {
        my ($self, $current) = @_;
        foreach (values %{$self->{lists}})
        {
            next if $_ == $current;
            $_->restorePrevious(1);
        }
        
    }

    sub reset
    {
        my $self = shift;
        foreach (values %{$self->{lists}})
        {
            $_->reset;
        }
        $self->{count} = 0;
        $self->{idxToList} = {};
    }

    sub clearCache
    {
        my ($self) = @_;
        foreach (values %{$self->{lists}})
        {
            $_->clearCache;
        }
        #$self->{vboxWidth} = 1;
    }

    sub setSortOrder
    {
        my ($self, $order) = @_;
        $self->{orderSet} = 1;

        if ($self->{groupItems})
        {
            my $first = 1;
            foreach (values %{$self->{lists}})
            {
                $_->setSortOrder($order);
                # We get it computed by the first internal list
                $self->{currentOrder} = $_->{currentOrder}
                    if $first;
                $first = 0;
            }
            # Now the internal lists are ordered, we need to order them
            my @tmpList = @{$self->{orderedLists}};
            # We sort the list
            if ($self->{currentOrder} == 0)
            {
                @tmpList = reverse sort @{$self->{orderedLists}};
            }
            else
            {
                @tmpList = sort @{$self->{orderedLists}};
            }
            
            # Clear the current view
            my @children = $self->{mainList}->get_children;
            foreach my $child(@children)
            {
                $self->{mainList}->remove($child);
            }
            # And fill it again with the current order
            foreach my $refGroup(@tmpList, $defaultGroup)
            {
                next if !$self->{listBoxes}->{$refGroup};
                $self->{mainList}->pack_start($self->{listBoxes}->{$refGroup}, 0, 0, 0);
                $self->{listBoxes}->{$refGroup}->show_all;
            }
    
            # Save the new order
            $self->{orderedLists} = \@tmpList;
        }
        else
        {
            $self->{currentList}->setSortOrder($order);
            $self->{currentList}->show_all;
            # We get it computed by the first internal list
            $self->{currentOrder} = $self->{currentList}->{currentOrder};
        }
    }

    sub setFilter
    {
        my ($self, $filter, $items, $refresh, $splash) = @_;
        shift;
        my $current;
        my $result = -1;
        my $list;
        $self->{displayed} = {};
        foreach (keys %{$self->{lists}})
        {
            $list = $self->{lists}->{$_};
            $current = $list->setFilter(@_);
            $result = $current if $list == $self->{currentList};
            if ($list->{displayedNumber})
            {
                $self->{listBoxes}->{$_}->show_all;
            }
            else
            {
                $self->{listBoxes}->{$_}->hide;
            }
        }
        $result = -1 if !defined $result;
        return $result;
    }        

    sub setDisplayed
    {
        my ($self, $idx, $displayed) = @_;
        $self->{displayed}->{$idx} = $displayed;
    }

    sub select
    {
        my ($self, $idx, $init, $keepPrevious) = @_;
        my $list;
        if ($self->{groupItems})
        {
            if (($idx == -1) || (!defined $idx))
            {
                if (defined $self->{orderedLists}->[0])
                {
                    $list = $self->{lists}->{$self->{orderedLists}->[0]};
                }
                else
                {
                    $list = $self->{lists}->{$defaultGroup};
                }
            }
            else
            {
                $list = $self->{idxToList}->{$idx};
            }
        }
        else
        {
            $list = $self->{currentList};
        }
        $list->select($idx, $init, $keepPrevious)
            if $list;
    }

    sub savePreferences
    {
        my ($self, $preferences) = @_;
        return if !$self->{orderSet};
        $preferences->sortField($self->{titleField});
        $preferences->sortOrder($self->{currentOrder});
    }

    sub getCurrentIdx
    {
        my $self = shift;
        return 0 if !$self->{currentList};
        return $self->{currentList}->getCurrentIdx;
    }

    sub removeCurrentItems
    {
        my $self = shift;
        # TODO : This doesn't work if there are items selected in many lists

        my @indexes = sort @{$self->getCurrentItems};
        my $selected;
        my @listWhereAlreadyRemoved;
        # Find other lists where they were
        foreach my $list(values %{$self->{lists}})
        {
            next if $list == $self->{currentList};
            foreach my $idx(@indexes)
            {
                my $nbRemoved = 0;
                if (exists $list->{idxToDisplayed}->{$idx - $nbRemoved})
                {
                    $list->removeItem($idx - $nbRemoved);
                    push @listWhereAlreadyRemoved,  0 + $list;
                    $nbRemoved++;
                }
                #splice @{$list->{cache}}, $idx - $nbRemoved, 1;
                delete $self->{displayed}->{$idx};
            }
        }
        # Adjust the total number of items according to what we removed
        $self->{count} -= scalar @indexes;

        $selected = $self->{currentList}->removeCurrentItems;
        push @listWhereAlreadyRemoved, $self->{currentList};

        # Now we have to adjust all of the indexes in other lists
        foreach my $list(values %{$self->{lists}})
        {
            # We don't perform the switch if we already removed the item
            my $found = 0;
            foreach my $listRm(@listWhereAlreadyRemoved)
            {
                if ($listRm == $list)
                {
                    # Found a list where we removed it
                    $found = 1;
                    last;
                }
            }
            next if $found;
            $list->shiftIndexes(\@indexes);
            $list->initConversionTables;
        }
        
        # If we removed all the items in the current group, we are looking for the 1st one
        # of the next group (fallback on previous if last one)
        if (!defined $selected)
        {
            my $nextList;
            foreach my $i(0 .. $#{$self->{orderedLists}})
            {
                if ($self->{orderedLists}->[$i] eq $self->{currentList}->{refGroup})
                {
                    if ($i < $#{$self->{orderedLists}})
                    {
                        $nextList = $self->{orderedLists}->[$i+1];
                        last;
                    }
                    else
                    {
                        $nextList = $self->{orderedLists}->[$i-1]
                            if $i > 0;
                        last;
                    }
                }
            }
            if ($nextList)
            {
                my $currentList = $self->{lists}->{$nextList};
                $selected = $currentList->{displayedToIdx}->{0};
                $currentList->select($selected);
                $self->{currentList} = $currentList;
            }
        }
        return $selected;
    }

    sub getCurrentItems
    {
        my $self = shift;
        # TODO : This doesn't work if there are items selected in many lists
        return $self->{currentList}->getCurrentItems;
    }

    sub changeCurrent
    {
        my ($self, $previous, $new, $idx, $wantSelect) = @_;

        if ($self->{groupItems})
        {
            # Will be set to a true value if the 1st added item should be selected
            my $shouldBeSelected = 0;
            # Get the list where it was
            my @prevGroups = sort @{$self->getGroups($previous)};
            
            # And the one where it should be
            my @newGroups = sort @{$self->getGroups($new)};

            my ($found, $place);
            # First look for previous ones
            foreach my $pg(@prevGroups)
            {
                my $pg = uc $pg;
                ($found, $place) = (0, 0);
                # Try to find it in the new groups
                foreach my $ng (@newGroups)
                {
                    my $refGroup = uc($ng);
                    $found = 1 if $refGroup eq $pg;
                    # As it is sorted, we can stop when we find a greater one
                    last if $refGroup ge $pg;
                    $place++;
                }
                # If found, we just change it
                if ($found)
                {
                    $self->{lists}->{$pg}->changeCurrent($previous, $new, $idx, 0);
                    # And we remove it from the list
                    splice @newGroups, $place, 1;
                }
                # Otherwise, it means it was removed from this group
                else
                {
                    $shouldBeSelected = 1
                        if $self->{lists}->{$pg}->isSelected($idx);
                    $self->{lists}->{$pg}->removeItem($idx,1);
                }
            }
            # Now we should have a list whith just the new groups
            foreach my $ng(@newGroups)
            {
                my $refGroup = uc $ng;
                # We should create the list if it doesn't exist
                if (! exists $self->{lists}->{$refGroup})
                {
                    my $list = $self->addGroup($ng, $refGroup, 1);
                }
                
                # 2nd parameter means it should be added immediately
                # 4th one is that we should not change the conversion tables because it's not
                # a new item
                $self->{lists}->{$refGroup}->addItem($new, 1, $idx, 1);
                if ($shouldBeSelected)
                {
                    $self->{lists}->{$refGroup}->select($idx, 0, 1);
                    $shouldBeSelected = 0;
                }
            }
            # TODO It should return something else if filtered
            return $idx;
        }
        else
        {
            return $self->{currentList}->changeCurrent($previous, $new, $idx, $wantSelect);
        }
    }

    sub AUTOLOAD
    {
        return if our $AUTOLOAD =~ /::DESTROY$/;
        (my $name = $AUTOLOAD) =~ s/.*?::(.*)/$1/;
        my $self = shift;
        #GCUtils::printStack(6);
        #print "CALLING $name\n";
        return $self->{currentList}->$name(@_);
    }
}

1;
