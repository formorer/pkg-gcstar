package GCDialogs;

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
use Gtk2;
use utf8;

our @okCancelButtons = ('gtk-cancel'=>'cancel', 'gtk-ok'=>'ok');

my $hasAboutDialog = 1;
eval 'Gtk2::AboutDialog->set_email_hook(undef, undef)';
$hasAboutDialog = 0 if $@;

{
    package GCModalDialog;
    use base "Gtk2::Dialog";
    
    sub showMe
    {
        my $self = shift;

        $self->present;
    }

    sub activateOkButton
    {
        my ($self, $value) = @_;
        ($self->action_area->get_children)[$self->{okPosition}]->set_sensitive($value);
    }

    sub activateExtraButton
    {
        my ($self, $value) = @_;
        ($self->action_area->get_children)[$self->{extraPosition}]->set_sensitive($value);
    }

    sub setOkLabel
    {
        my ($self, $label) = @_;
        my @buttons = $self->action_area->get_children;
        my $tmpWidget = $buttons[0];
        $tmpWidget = $tmpWidget->child while ! $tmpWidget->isa('Gtk2::HBox');
        ($tmpWidget->get_children)[1]->set_label($label);        
    }
    
    sub setCancelLabel
    {
        my ($self, $label) = @_;
        my @buttons = $self->action_area->get_children;
        my $tmpWidget = $buttons[1];
        $tmpWidget = $tmpWidget->child while ! $tmpWidget->isa('Gtk2::HBox');
        ($tmpWidget->get_children)[1]->set_label($label);        
    }
    
    sub new
    {
        my ($proto, $parent, $title, $okLabel, $extraAfter, @extraButtons) = @_;
        $title =~ s/_//g;
        my $class = ref($proto) || $proto;
        my @buttons;
        if ((defined $okLabel) && ($okLabel =~ /^gtk-/))
        {
            @buttons = ('gtk-cancel'=>'cancel', $okLabel=>'ok');
            $okLabel = '';
        }
        else
        {
            @buttons = @GCDialogs::okCancelButtons;
        }
        my ($okPosition, $extraPosition) = (0, -1);
        if (@extraButtons)
        {
            if ($extraAfter)
            {
                $okPosition = 1;
                $extraPosition = 0;
                push @buttons, @extraButtons;
            }
            else
            {
                $okPosition = 0;
                $extraPosition = 2;
                unshift @buttons, @extraButtons;
            }
        }
        my $self  = $class->SUPER::new($title,
                              $parent,
                              [qw/modal destroy-with-parent/],
                              @buttons
                              );
        bless ($self, $class);

        ($self->{okPosition}, $self->{extraPosition}) = ($okPosition, $extraPosition);

        $self->setOkLabel($okLabel) if $okLabel;
        $self->set_default_response('ok');
        
        $self->{parent} = $parent;

        $self->vbox->set_border_width($GCUtils::margin);

        return $self;
    }
}

{
    package GCAboutDialog;
    if (!$hasAboutDialog)
    {
        use base "Gtk2::Dialog";
    }
    
    sub show
    {
        my $self = shift;

        if ($hasAboutDialog)
        {
            $self->{about}->set_position('center-on-parent');
            $self->{about}->run;
            $self->{about}->hide;
        }
        else
        {
            $self->SUPER::show();
            $self->show_all;
            my $code = $self->run;
            $self->hide;
        }
    }

    sub changeStyle
    {
        my $self = shift;
        $self->{vBox}->set_border_width(0);
        ($self->{vBox}->get_children)[1]->set_border_width($self->{border});
    }

    sub new
    {
        my ($proto, $parent, $version) = @_;
        my $class = ref($proto) || $proto;
        
        my $self;
        
        my $logoFile = $parent->{logosDir}.'about.png';
        
        if ($hasAboutDialog)
        {
            $self = {
                about => new Gtk2::AboutDialog,
                parent => $parent
            };
            bless ($self, $class);
            
            open LICENSE, "<".$ENV{GCS_SHARE_DIR}.'/LICENSE';
            my $license = do {local $/; <LICENSE>};
            close LICENSE;
            my @authors = split m/\n/, $parent->{lang}->{AboutWho};
            
            $self->{about}->set_transient_for($parent);
            $self->{about}->set_url_hook( sub {
                my ($widget, $url) = @_;
    	        $self->{parent}->launch($url, 'url');
            });

            if (-f $logoFile)
            {
                my $logo = Gtk2::Gdk::Pixbuf->new_from_file($logoFile);
                $self->{about}->set_logo($logo);
            }
            $self->{about}->set_name('GCstar');
            $self->{about}->set_comments($parent->{lang}->{AboutDesc});
            $self->{about}->set_version($version);
            $self->{about}->set_authors('', @authors);
            $self->{about}->set_documenters(("",'Christian Jodar (Tian)','http://wiki.gcstar.org/'));
            $self->{about}->set_artists("",$parent->{lang}->{AboutDesign}, 'http://le-spektre.org/');
            $self->{about}->set_copyright($parent->{lang}->{AboutLicense});
            $self->{about}->set_license($license);
            $self->{about}->set_translator_credits("\n".$parent->{lang}->{AboutTranslation});
            $self->{about}->set_website("http://www.gcstar.org/");
            $self->{vBox} = $self->{about}->get_children;
            $self->{border} = $self->{vBox}->get_border_width;
            if ($self->{about}->signal_query('style_set'))
            {
                $self->{about}->signal_connect('style_set' => sub {$self->changeStyle });
            }
            $self->changeStyle;
        }
        else
        {
            $self  = $class->SUPER::new($parent->{lang}->{AboutTitle},
                                           $parent,
                                           [qw/modal destroy-with-parent/],
                                           'gtk-ok' => 'ok'
                                          );
            bless ($self, $class);
    	    my $labelDesc = Gtk2::Label->new($parent->{lang}->{AboutDesc});
    	    my $labelVersion = Gtk2::Label->new($parent->{lang}->{AboutVersion}.' '.$version);
    	    #my $labelTeam = Gtk2::Label->new($parent->{lang}->{AboutTeam});
            
            my $who = new Gtk2::Label($parent->{lang}->{AboutWho});
            
            my $labelTranslation = Gtk2::Label->new($parent->{lang}->{AboutTranslation});
    	    my $labelLicense = Gtk2::Label->new($parent->{lang}->{AboutLicense});
    	    $labelLicense->set_justify('center');
    	    my $button = Gtk2::Button->new_with_mnemonic('_http://www.gcstar.org/');
    	    $button->child->set_padding(10,0);
    	    $button->signal_connect('clicked', sub {
    	        my ($widget, $parent) = @_;
    	        (my $url = $widget->get_label) =~ s/^_//;
    	        $parent->launch($url, 'url');
    	    }, $parent);
       	    my $labelDesign = Gtk2::Label->new($parent->{lang}->{AboutDesign});
    	    my $designButton = Gtk2::Button->new_with_mnemonic('http://www.le-spektre.org/');
    	    $designButton->child->set_padding(10,0);
    	    $designButton->signal_connect('clicked', sub {
    	        my ($widget, $parent) = @_;
    	        (my $url = $widget->get_label) =~ s/^_//;
    	        $parent->launch($url, 'url');
    	    }, $parent);
    
    	    $self->vbox->set_homogeneous(0);
    	    if (-f $logoFile)
            {
                my $image = Gtk2::Image->new_from_file($logoFile);
                $self->vbox->pack_start($image, 0, 0, 0);
            }
    	    $self->vbox->pack_start($labelDesc, 1, 1, 4);
    	    $self->vbox->pack_start($labelVersion, 1, 1, 4);
    	    $self->vbox->pack_start($labelLicense, 1, 1, 4);
            $self->vbox->pack_start(Gtk2::HSeparator->new, 1, 1, 4);    	    
    	    my $hbox = new Gtk2::HBox(0,0);
    	    $hbox->pack_start($button, 1, 0, 10);
    	    $self->vbox->pack_start($hbox, 0, 0, 4);
    	    my $hboxDesign = new Gtk2::HBox(0,0);
    	    $hboxDesign->pack_start($designButton, 1, 0, 10);
    	    $self->vbox->pack_start($labelDesign, 1, 1, 4);
    	    $self->vbox->pack_start($hboxDesign, 0, 0, 4);
    	
    	    my $teamButton = Gtk2::Button->new($parent->{lang}->{AboutTeam});
    	    $teamButton->signal_connect('clicked' => sub {
    	       my $dialog = Gtk2::MessageDialog->new($self,
							   [qw/modal destroy-with-parent/],
							   'info',
							   'ok',
							   $parent->{lang}->{AboutWho});
    	       $dialog->run;
    	       $dialog->destroy;
    	    });
    	    $self->action_area->pack_start($teamButton,0,0,0);
    	    $self->action_area->reorder_child($teamButton,0);
    	
    	
    	    #$self->vbox->set_size_request(400,-1);
    	    $self->set_resizable(0);
    		$self->set_position('center-always');
        }

	    return $self;
    }
}

{
    package GCImageDialog;
    use base "Gtk2::Dialog";

    sub show
    {
        my $self = shift;
        $self->SUPER::show();
        $self->show_all;
        $self->set_position('center-always');
        $self->{scrollArea}->signal_connect('size-allocate' => sub {
            return if !$self->{scrollArea};
            my ($width, $height) = $self->get_size;
            return if ($width == $self->{width}) && ($height == $self->{height});
            my $allocation = $self->{scrollArea}->allocation;
            return if $allocation->height < 10;
            $self->{image}->parent->set_size_request(-1, -1);
            $self->set_position('center');
            my $pixbuf = GCUtils::scaleMaxPixbuf($self->{originalPixbuf}, $allocation->width, $allocation->height);
            $self->{image}->set_from_pixbuf($pixbuf);
            ($self->{width}, $self->{height}) = ($width, $height);
        }) if $self->{scrollArea};
        my $code = $self->run;
        $self->hide;
        $self->{windowParent}->showMe;
    }

    sub new
    {
        my ($proto, $parent, $file, $windowParent) = @_;
        my $class = ref($proto) || $proto;
        $windowParent ||= $parent;
        my $self  = $class->SUPER::new($parent->{lang}->{ImportViewPicture},
                                       $windowParent,
                                       [qw/modal destroy-with-parent/],
                                       'gtk-ok' => 'ok'
                                      );
        bless($self, $class);

        $self->{parent} = $parent;
        $self->{windowParent} = $windowParent;

        if (-f $file)
        {
            $self->{image} = Gtk2::Image->new;
            $self->{originalPixbuf} = Gtk2::Gdk::Pixbuf->new_from_file($file);            
            $self->{image}->set_from_pixbuf($self->{originalPixbuf});
            $self->{image}->set_size_request(0,0);
            $self->{scrollArea} = new Gtk2::ScrolledWindow;
            $self->{scrollArea}->set_policy ('automatic', 'automatic');
            $self->{scrollArea}->set_shadow_type('none');
            $self->{scrollArea}->add_with_viewport($self->{image});
            $self->vbox->pack_start($self->{scrollArea},1,1,0);
            my ($screenWidth, $screenHeight) = ($self->get_screen->get_width, $self->get_screen->get_height);
            my ($pixWidth, $pixHeight) = ($self->{originalPixbuf}->get_width, $self->{originalPixbuf}->get_height);
            
            # Minimum amount of spacing we want to leave for panels, window decorations, borders, etc
            my $heightMargin = 150;
            my $widthMargin = 30;
            
            my $ratio = $pixWidth / $pixHeight;
            
            # Check if picture will fit into screen, or if we'll need to resize
            if (($pixHeight > ($screenHeight - $heightMargin)) && ($pixWidth <= ($screenWidth - $widthMargin)))
            {
                # Image is higher than vertical space we have available, but not wider
                $pixHeight = $screenHeight - $heightMargin;
                $pixWidth = $pixHeight * $ratio;
            }
            elsif (($pixHeight <= ($screenHeight - $heightMargin)) && ($pixWidth > ($screenWidth - $widthMargin)))
            {
                # Image is wider than horizontal space we have available, but not taller
                $pixWidth = $screenWidth - $widthMargin;
                $pixHeight = $pixWidth / $ratio;            
            }
            elsif (($pixHeight > ($screenHeight - $heightMargin)) && ($pixWidth > ($screenWidth - $widthMargin)))
            {
                # Image is both too high and too wide for space we have, so see which direction will be
                # affected the most
                if ($screenHeight - $heightMargin - $pixHeight < $screenWidth - $widthMargin - $pixWidth)
                {
                    # Constrained by vertical height
                    $pixHeight = $screenHeight - $heightMargin;
                    $pixWidth = $pixHeight * $ratio;               
                }
                else
                {
                    # Constrained by horizontal width
                    $pixWidth = $screenWidth - $widthMargin;
                    $pixHeight = $pixWidth / $ratio;                   
                }
            }
            $self->{image}->parent->set_size_request($pixWidth, $pixHeight);
        }
        else
        {
            my $label = new Gtk2::Label;
            $label->set_markup('<b>'.$parent->{lang}->{PanelImageNoImage}.'</b>');
            $self->vbox->pack_start($label,1,1,4 * $GCUtils::margin);
        }

        return $self;
    }
}

{
    package GCNumberEntryDialog;
    use base "Gtk2::Dialog";

    sub getUserValue
    {
        my $self = shift;
        my $value = -1;
        my $code = $self->run;
        $value = $self->{value}->get_value if ($code eq 'ok');
        $self->hide;
        return $value;
    }

    sub setValue
    {
        my ($self, $value) = @_;
        
        $self->{value}->set_value($value);
    }

    sub new
    {
        my ($proto, $parent, $title, $min, $max, $step) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($title,
                              $parent,
                              [qw/modal destroy-with-parent/],
                              @GCDialogs::okCancelButtons
                              );

        my $label = Gtk2::Label->new($parent->{lang}->{DialogEnterNumber});
        $label->set_line_wrap(1);
        $label->set_padding(5,0);
        $self->{value} = new GCNumeric(($min + $max) / 2, $min, $max, $step);

        my $hboxRating = new Gtk2::HBox(1,10);

        $self->vbox->set_homogeneous(0);
        $self->vbox->set_spacing(20);
        $self->vbox->pack_start($label, 0, 0, 5);
        $hboxRating->pack_start($self->{value}, 0, 0, 5);
        $self->vbox->pack_start($hboxRating, 0, 0, 5);
        $self->vbox->show_all;

        bless ($self, $class);
        return $self;
    }
}

{
    package GCDependenciesDialog;
    use base "Gtk2::Dialog";

    use GCUtils 'glob';

    sub show
    {
        my $self = shift;
        $self->SUPER::show();
        $self->show_all;
        my $code = $self->run;
        $self->hide;
    }

    sub checkDependencies
    {
        my $self = shift;
    
        my $pref = 'GC';
    
        my @optionals = ();
        my $optionalsModules = {};
    
        my @files = glob $ENV{GCS_LIB_DIR}.'/*.pm';
        
        for my $component('GCPlugins', 'GCExport', 'GCImport', 'GCExtract')
        {
            foreach (glob $ENV{GCS_LIB_DIR}."/$component/*")
            {
                if (-d $_)
                {
                    push @files, glob $ENV{GCS_LIB_DIR}."/$component/$_/*.pm";
                }
                else
                {
                    push @files, $_;
                }
            }
        }
        foreach my $file(@files)
        {
            open FILE, $file;
            while (<FILE>)
            {
                if (
                    ((/eval.*?[\"\']use\s*(.*?)[\"\'];/) && ($1 !~ /base|vars|locale|integer|^lib|utf8|\$opt|\$module|strict|^$pref/))
                    ||
                    (/checkModule\([\"\'](.*?)[\"\']\)/)
                   )
                #"
                {
                    next if $1 eq 'Time::HiRes';
                    push (@optionals, $1);
                    push @{$optionalsModules->{$1}}, $file;
                }
    
            }
            close FILE;
        }
    
        my %saw;
        @saw{@optionals} = ();
        @optionals = sort keys %saw;
    
        $self->{tableDepend}->resize(1 +  scalar(@optionals),2);
    
        my @missings = ();
        my @oks = ();
        foreach my $opt(sort @optionals)
        {
            my $label1 = new Gtk2::Label($opt);
            my $label2 = new Gtk2::Label;

            $@ = '';
            eval "use $opt";
            if ($@)
            {
                my $value;
                foreach my $module (@{$optionalsModules->{$opt}})
                {
                    $module =~ s/.*?GC([^\/]*?)\.pm$/$1/;
                    $value .= $module.",\n";
                }
                $value =~ s/,\n$//;
                $label2->set_markup("<span color='orange' weight='bold'>".$self->{parent}->{lang}->{InstallMissingFor}." $value</span>");
                $label2->set_line_wrap(1);
                $label2->set_justify('left');
                push @missings, [$label1, $label2];
            }
            else
            {
                $label2->set_markup("<span color='green' weight='bold'>".$self->{parent}->{lang}->{InstallOK}."</span>");
                push @oks, [$label1, $label2];
            }

        }

        my $i = 0;
        my $labelOpt = new Gtk2::Label;
        $labelOpt->set_markup('<b>'.$self->{parent}->{lang}->{InstallOptional}.'</b>');
        $self->{tableDepend}->attach($labelOpt, 0, 2, $i, $i+1, 'expand', 'fill', 0, $GCUtils::margin);
        $i++;
        
        foreach (@missings)
        {
            $self->{tableDepend}->attach($_->[0], 0, 1, $i, $i+1, 'fill', 'fill', 0, 0);
            $self->{tableDepend}->attach($_->[1], 1, 2, $i, $i+1, 'fill', 'fill', 0, 0);
        
            $i++;
        }
        foreach (@oks)
        {
            $self->{tableDepend}->attach($_->[0], 0, 1, $i, $i+1, 'fill', 'fill', 0, 0);
            $self->{tableDepend}->attach($_->[1], 1, 2, $i, $i+1, 'fill', 'fill', 0, 0);
        
            $i++;
        }
    }

    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent->{lang}->{InstallDependencies},
                              $parent,
                              [qw/modal destroy-with-parent/],
                              'gtk-ok' => 'ok'
                              );
        bless($self, $class);

        $self->{parent} = $parent;

        $self->{tableDepend} = new Gtk2::Table(1, 2, 0);
        $self->{tableDepend}->set_row_spacings(10);
        $self->{tableDepend}->set_col_spacings(20);
        $self->{tableDepend}->set_border_width(10);
        $self->{scrollDepend} = new Gtk2::ScrolledWindow;
        $self->{scrollDepend}->set_policy ('automatic', 'automatic');
        $self->{scrollDepend}->add_with_viewport($self->{tableDepend});
        $self->{scrollDepend}->set_size_request(300, 200);
        $self->vbox->pack_start($self->{scrollDepend},1,1,10);

        $self->checkDependencies;

        return $self;
    }
}

{
    package GCDateSelectionDialog;
    use base "GCModalDialog";

    sub show
    {
        my $self = shift;
        $self->SUPER::show();
 
        my $response = $self->run;
        $self->hide;
        return ($response eq 'ok');
    }

    sub date
    {
        my $self = shift;
        if (@_)
        {
            $_ = shift;
            return if ! $_;
            my ($day, $month, $year);
            ($day, $month, $year) = split m|/|;
            ($day, $month, $year) = (01, 01, $_) if ! m|/|;
            $self->{calendar}->select_month($month - 1, $year);
            $self->{calendar}->select_day($day);
        }
        else
        {
            my ($year, $month, $day) = $self->{calendar}->get_date;
            $day = ($day < 10 ? '0' : '').$day;
            $month++;
            $month = ($month < 10 ? '0' : '').$month;
            return join '/', $day, $month, $year;
        }
    }
    
    sub new
    {
        my ($proto, $parent, $title) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent,
                                       $title || $parent->{lang}->{PanelDateSelect});

        $self->{calendar} = new Gtk2::Calendar;
        $self->{calendar}->signal_connect('day-selected-double-click' => sub {
            $self->response('ok');
        });
        
        $self->vbox->pack_start($self->{calendar}, 0, 0, 5);
        $self->vbox->show_all;
        
        $self->set_default_size(1,1);

        bless ($self, $class);
        return $self;
    }
}

{
    package GCPropertiesDialog;

    use Glib::Object::Subclass
                Gtk2::Dialog::
    ;
    
    @GCPropertiesDialog::ISA = ('GCModalDialog');
    
    sub checkValues
    {
        my $self = shift;
        
        return $self->{parent}->{lang}->{OptionsPicturesWorkingDirError}
            if $self->{properties}->{images}->getValue =~ /.%WORKING_DIR%/;
        return undef;
    }

    sub show
    {
        my $self = shift;
        
        $self->SUPER::show();
        $self->show_all;
        my $response;
        while(1)
        {
            $response = $self->run;
            last if $response ne 'ok';
            my $errorMessage = $self->checkValues;
            last if !$errorMessage;
            my  $dialog = Gtk2::MessageDialog->new_with_markup($self->{parent},
                    [qw/modal destroy-with-parent/],
                    'error',
                    'ok',
                    $errorMessage);
            $dialog->run;
            $dialog->destroy;
        }
        $self->hide;
        return ($response eq 'ok');
    }

    sub setProperties
    {
        my ($self, $properties, $file, $count) = @_;

        foreach (keys %{$self->{properties}})
        {
            $self->{properties}->{$_}->setValue($properties->{$_});
        }
        $self->{info}->{file}->setValue($file);
        $self->{info}->{items}->setValue($count);
        $self->{info}->{size}->setValue(GCUtils::sizeToHuman((-s $file),
                                        $self->{parent}->{lang}->{PropertiesFileSizeSymbols}));
    }

    sub getProperties
    {
        my $self = shift;

        my %properties;
        foreach (keys %{$self->{properties}})
        {
            $properties{$_} = $self->{properties}->{$_}->getValue;
        }
        return \%properties;
    }
    
    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        my $title = Gtk2::Stock->lookup('gtk-properties')->{label};
        $title =~ s/_//g;
        my $self  = $class->SUPER::new($parent,
                                       $title);

        $self->{parent} = $parent;
                              
        my $table = new Gtk2::Table(14,4,0);
        $table->set_row_spacings($GCUtils::halfMargin);
        $table->set_col_spacings($GCUtils::halfMargin);
        $table->set_border_width($GCUtils::margin);

        my $line = 0;

        my $fileGroupLabel = new GCHeaderLabel($parent->{lang}->{PropertiesFile});
        $table->attach($fileGroupLabel, 0, 4, $line, $line + 1, 'fill', 'fill', 0, 0);
        $line++;

        my $fileLabel = new GCLabel($parent->{lang}->{PropertiesFilePath});
        $self->{info}->{file} = new GCShortText;
        $self->{info}->{file}->lock(1);
        $table->attach($fileLabel, 2, 3, $line, $line + 1, 'fill', 'fill', 0, 0);
        $table->attach($self->{info}->{file}, 3, 4, $line, $line + 1, ['expand', 'fill'], 'fill', 0, 0);
        $line++;
        
        $self->{info}->{itemsLabel} = new GCLabel($parent->{lang}->{PropertiesItemsNumber});
        $self->{info}->{items} = new GCShortText;
        $self->{info}->{items}->lock(1);
        $table->attach($self->{info}->{itemsLabel}, 2, 3, $line, $line + 1, 'fill', 'fill', 0, 0);
        $table->attach($self->{info}->{items}, 3, 4, $line, $line + 1, ['expand', 'fill'], 'fill', 0, 0);
        $line++;
        
        my $sizeLabel = new GCLabel($parent->{lang}->{PropertiesFileSize});
        $self->{info}->{size} = new GCShortText;
        $self->{info}->{size}->lock(1);
        $table->attach($sizeLabel, 2, 3, $line, $line + 1, 'fill', 'fill', 0, 0);
        $table->attach($self->{info}->{size}, 3, 4, 3, 4, ['expand', 'fill'], 'fill', 0, 0);
                
        $line += 3;

        my $collectionGroupLabel = new GCHeaderLabel($parent->{lang}->{PropertiesCollection});
        $table->attach($collectionGroupLabel, 0, 4, $line, $line + 1, 'fill', 'fill', 0, 0);
        $line++;

        my $nameLabel = new GCLabel($parent->{lang}->{PropertiesName});
        $self->{properties}->{name} = new GCShortText;
        $table->attach($nameLabel, 2, 3, $line, $line + 1, 'fill', 'fill', 0, 0);
        $table->attach($self->{properties}->{name}, 3, 4, $line, $line + 1, ['expand', 'fill'], 'fill', 0, 0);
        $line++;

        my $langLabel = new GCLabel($parent->{lang}->{PropertiesLang});
        $self->{properties}->{lang} = new GCHistoryText;
        my @langValues;
        push @langValues, "$_ (".$GCLang::langs{$_}->{LangName}.')'
            foreach (keys %GCLang::langs);
        @langValues = sort @langValues;
        $self->{properties}->{lang}->setValues(\@langValues);
        $table->attach($langLabel, 2, 3, $line, $line + 1, 'fill', 'fill', 0, 0);
        $table->attach($self->{properties}->{lang}, 3, 4, $line, $line + 1, ['expand', 'fill'], 'fill', 0, 0);
        $line++;

        my $ownerLabel = new GCLabel($parent->{lang}->{PropertiesOwner});
        $self->{properties}->{owner} = new GCShortText;
        $table->attach($ownerLabel, 2, 3, $line, $line + 1, 'fill', 'fill', 0, 0);
        $table->attach($self->{properties}->{owner}, 3, 4, $line, $line + 1, ['expand', 'fill'], 'fill', 0, 0);
        $line++;

        my $emailLabel = new GCLabel($parent->{lang}->{PropertiesEmail});
        $self->{properties}->{email} = new GCShortText;
        $table->attach($emailLabel, 2, 3, $line, $line + 1, 'fill', 'fill', 0, 0);
        $table->attach($self->{properties}->{email}, 3, 4, $line, $line + 1, ['expand', 'fill'], 'fill', 0, 0);
        $line++;

        my $descriptionLabel = new GCLabel($parent->{lang}->{PropertiesDescription});
        $self->{properties}->{description} = new GCLongText;
        $table->attach($descriptionLabel, 2, 3, $line, $line + 1, 'fill', 'fill', 0, 0);
        $table->attach($self->{properties}->{description}, 3, 4, $line, $line + 1, ['expand', 'fill'], ['expand', 'fill'], 0, 0);
        $line++;

        my $picturesDirLabel = new GCLabel($parent->{lang}->{OptionsImages});
        $self->{properties}->{images} = new GCFile($self, $parent->{lang}->{FileChooserOpenDirectory}, 'select-folder');
        $table->attach($picturesDirLabel, 2, 3, $line, $line + 1, 'fill', 'fill', 0, 0);
        $table->attach($self->{properties}->{images}, 3, 4, $line, $line + 1, ['expand', 'fill'], ['fill'], 0, 0);
        $line++;

        my $defaultImageLabel = new GCLabel($parent->{lang}->{PropertiesDefaultPicture});
        $self->{properties}->{defaultImage} = new GCFile($self, $parent->{lang}->{FileChooserOpenFile}, 'open');
        $table->attach($defaultImageLabel, 2, 3, $line, $line + 1, 'fill', 'fill', 0, 0);
        $table->attach($self->{properties}->{defaultImage}, 3, 4, $line, $line + 1, ['expand', 'fill'], ['fill'], 0, 0);

        $self->vbox->pack_start($table, 1, 1, 5);
        $self->vbox->show_all;

        bless ($self, $class);
        return $self;
    }
}

{
    package GCQueryReplaceDialog;
    use base "GCModalDialog";
    
    sub show
    {
        my $self = shift;
        
        $self->SUPER::show();
        $self->show_all;
        my $response = $self->run;
        $self->{field} = $self->{fieldsOption}->getValue;
        $self->{oldValue} = $self->{old}->getValue;
        $self->{newValue} = $self->{new}->getValue;
        $self->{caseSensitive} = $self->{useCase}->getValue;
        $self->hide;
        return ($response eq 'ok');
    }

    sub setModel
    {
        my ($self, $model) = @_;

        $self->{model} = $model;
        $self->{fieldsOption}->setModel($model);
    }
    
    sub updateFields
    {
        my $self = shift;

        $self->{layoutTable}->remove($self->{old});
        ($self->{old}, undef) = $self->{fieldsOption}->createEntryWidget($self, 'eq', $self->{old});
        $self->{old}->signal_connect('activate' => sub {$self->response('ok')} )
            if $self->{old}->isa('GCShortText');
        $self->{layoutTable}->attach($self->{old}, 1, 2, 1, 2, 'fill', 'expand', 0, 0);
        $self->{old}->show_all;

        $self->{layoutTable}->remove($self->{new});
        ($self->{new}, undef) = $self->{fieldsOption}->createEntryWidget($self, 'eq', $self->{new});
        $self->{new}->signal_connect('activate' => sub {$self->response('ok')} )
            if $self->{new}->isa('GCShortText');
        $self->{layoutTable}->attach($self->{new}, 1, 2, 2, 3, 'fill', 'expand', 0, 0);
        $self->{new}->show_all;
    }

    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        my $title = Gtk2::Stock->lookup('gtk-find-and-replace')->{label};
        $title =~ s/_//g;
        my $self  = $class->SUPER::new($parent,
                                       $title,
                                       $parent->{lang}->{QueryReplaceLaunch}
                                      );

        $self->{parent} = $parent;

        # These ones are required for createWidget        
        $self->{lang} = $parent->{lang};
        $self->{options} = $parent->{options};
                              
        $self->{layoutTable} = new Gtk2::Table(4,2,0);
        $self->{layoutTable}->set_row_spacings($GCUtils::halfMargin);
        $self->{layoutTable}->set_col_spacings($GCUtils::margin);
        $self->{layoutTable}->set_border_width($GCUtils::margin);

        my $fieldLabel = new Gtk2::Label($parent->{lang}->{QueryReplaceField});
        $fieldLabel->set_alignment(0,0.5);
        $self->{fieldsOption} = new GCFieldSelector(0, undef, 0);
        $self->{fieldsOption}->signal_connect('changed' => sub {
            $self->updateFields;
        });
        $self->{layoutTable}->attach($fieldLabel, 0, 1, 0, 1, 'fill', 'fill', 0, 0);
        $self->{layoutTable}->attach($self->{fieldsOption}, 1, 2, 0, 1, 'fill', 'expand', 0, 0);

        my $oldLabel = new Gtk2::Label($parent->{lang}->{QueryReplaceOld});
        $oldLabel->set_alignment(0,0.5);

        $self->{old} = new GCShortText;
        $self->{layoutTable}->attach($oldLabel, 0, 1, 1, 2, 'fill', 'fill', 0, 0);
        $self->{layoutTable}->attach($self->{old}, 1, 2, 1, 2, 'fill', 'expand', 0, 0);
                              
        my $newLabel = new Gtk2::Label($parent->{lang}->{QueryReplaceNew});
        $newLabel->set_alignment(0,0.5);
        $self->{new} = new GCShortText;
        $self->{layoutTable}->attach($newLabel, 0, 1, 2, 3, 'fill', 'fill', 0, 0);
        $self->{layoutTable}->attach($self->{new}, 1, 2, 2, 3, 'fill', 'expand', 0, 0);

        $self->{useCase} = new GCCheckBox($parent->{lang}->{AdvancedSearchUseCase});
        $self->{layoutTable}->attach($self->{useCase}, 0, 2, 3, 4, 'fill', 'fill', 0, 0);

        $self->vbox->pack_start($self->{layoutTable}, 1, 1, 5);
        $self->vbox->show_all;

        bless ($self, $class);
        return $self;
    }
}

{
    #Class that is used to let user select
    #item from a list and order them.
    package GCDoubleListDialog;

    use base 'GCModalDialog';
    
    sub init
    {
        my $self = shift;
        $self->setListData($self->getData) if !$self->{initialized};
        $self->{initialized} = 1;
    }
    
    sub hideExtra
    {
        my $self = shift;
    }
    
    sub show
    {
        my $self = shift;

        $self->setListData($self->getData);

        $self->SUPER::show();
        $self->show_all;
        $self->hideExtra;
        
        my $response = $self->run;

        if ($response eq 'ok')
        {
           $self->saveList(\@{$self->{usedArray}});
        }
        $self->hide;
        return $response;
    }
    
    sub compareItems
    {
        my ($self, $item1, $item2) = @_;
        if ($self->{withPixbuf} && (ref $item1 eq 'ARRAY'))
        {
            return $item1->[1] cmp $item2->[1];
        }
        else
        {
            return $item1 cmp $item2;
        }
    }

    sub moveFromTo
    {
        my ($self, $from, $to) = @_;
        my $fromId = ($self->{$from}->get_selected_indices)[0];
        my $fromItem = $self->{$from.'Array'}->[$fromId];
        my $fromString;
        if ($self->{withPixbuf})
        {
            $fromString = $fromItem->[1];
        }
        else
        {
            $fromString = $fromItem;
        }
        return if !$fromString;
        my $toId = ($self->{$to}->get_selected_indices)[0];
        my $toTotal = scalar @{$self->{$to.'Array'}};
        $toId = $toTotal if $toId eq '';
        $toId++ if $toId < $toTotal;
        $toId = 0 if ($toId < 0);

        if (($to eq 'unused') || (!$self->{permanent}->{$fromString}))
        {
            splice(@{$self->{$from}->{data}}, $fromId, 1);
            splice(@{$self->{$from.'Array'}}, $fromId, 1);
        }
        if (($to eq 'used') || (!$self->{permanent}->{$fromString}))
        {
            splice(@{$self->{$to}->{data}}, $toId, 0, $fromItem);
            splice(@{$self->{$to.'Array'}}, $toId, 0, $fromItem);
        }
        
        if ($to eq 'unused')
        {
            my @tmpSortedArray = sort 
                {$self->compareItems($a, $b)}
                @{$self->{unusedArray}};
            $self->{unusedArray} = \@tmpSortedArray;
            @{$self->{unused}->{data}} = ();
            my $i = 0;
            $toId = 0;
            foreach (@tmpSortedArray)
            {
                $toId = $i if $_ eq $fromString;
                my @item = ($self->{withPixbuf} ? $_ : [$_]);
                push @{$self->{unused}->{data}}, @item;
                $i++;
            }
        }
        $self->{$to}->select($toId);
        $self->{$from}->select($fromId);
        $self->{$from}->grab_focus;
    }
    
    sub moveDownUp
    {
        my ($self, $dir) = @_;
        my $currentId = ($self->{used}->get_selected_indices)[0];
        my $newId = $currentId + $dir;
        return if ($newId < 0) || ($newId >= scalar @{$self->{usedArray}});
        ($self->{usedArray}->[$currentId], $self->{usedArray}->[$newId])
         = ($self->{usedArray}->[$newId], $self->{usedArray}->[$currentId]);
        @{$self->{used}->{data}} = ();
        foreach (@{$self->{usedArray}})
        {
            if ($self->{withPixbuf})
            {
                push @{$self->{used}->{data}}, $_;               
            }
            else
            {
                push @{$self->{used}->{data}}, [$_];               
            }
        }
        $self->{used}->select($newId);
    }

    sub setListData
    {
        my ($self, $new) = @_;
        my $initial = $self->getInitData;
        $self->{initialized} = 1;
        my %tmpMap;
        if ($self->{withPixbuf})
        {
            $tmpMap{$_->[1]} = $_ foreach (@$initial);
        }
        else
        {
            $tmpMap{$_} = 1 foreach (@$initial);
        }
        $self->{usedArray} = $new;
        my $label;
        foreach (@$new)
        {
            my $label = ($self->{withPixbuf} ? $_->[1] : $_);
            delete $tmpMap{$label} if !$self->{permanent}->{$label};
        }
        my @tmpArray = sort {$self->compareItems($a, $b)} keys %tmpMap;
        if ($self->{withPixbuf})
        {
            my @unusedArray = map {$tmpMap{$_}} @tmpArray;
            $self->{unusedArray} = \@unusedArray;
        }
        else
        {
            $self->{unusedArray} = \@tmpArray;
        }
        @{$self->{unused}->{data}} = ();
        
        push @{$self->{unused}->{data}}, $_ foreach (@{$self->{unusedArray}});
        @{$self->{used}->{data}} = ();
        push @{$self->{used}->{data}}, $_ foreach (@{$self->{usedArray}});
    }

    sub setListFromIds
    {
        my ($self, $new) = @_;
        my $count = scalar(@$new) - 1;
        for my $i (0..$count)
        {
            $new->[$i] = $self->{fieldIdToName}->{$new->[$i]};
        }
        $self->setListData($new);
    }

    sub clearList
    {
        my $self = shift;
        
        $self->setListData(());
    }
    sub fillList
    {
        my $self = shift;
        my @array = grep !$self->{permanent}->{$_},
                         sort {$self->compareItems($a, $b)} @{$self->getInitData};
        $self->setListData(\@array);
    }

    sub addToPermanent
    {
        my ($self, $id) = @_;
        $self->{permanent}->{$id} = 1;
    }
            
    sub removeFromPermanent
    {
        my ($self, $id) = @_;
        delete $self->{permanent}->{$id};
    }
            
    sub new
    {
        my ($proto, $parent, $title, $withPixbuf) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent, $title);

        bless ($self, $class);

        $self->{options} = $parent->{options};

        $self->{initialized} = 0;
        $self->{withPixbuf} = $withPixbuf;

        my $hboxMain = new Gtk2::HBox(0,0);

        if ($withPixbuf)
        {
            $self->{unused} = new Gtk2::SimpleList(
                '' => 'pixbuf',
                $self->getUnusedLabel => 'text'
            );
            $self->{used} = new Gtk2::SimpleList(
                '' => 'pixbuf',
                $self->getUsedLabel => 'text'
            );
        }
        else
        {
            $self->{unused} = new Gtk2::SimpleList(
                $self->getUnusedLabel => "text"
            );
            $self->{used} = new Gtk2::SimpleList(
                $self->getUsedLabel => "text"
            );
        }
        $self->{scrollPanelUnused} = new Gtk2::ScrolledWindow;
        $self->{scrollPanelUnused}->set_policy ('never', 'automatic');
        $self->{scrollPanelUnused}->set_shadow_type('etched-in');
        $self->{scrollPanelUnused}->add($self->{unused});
        $self->{vboxUnused} = new Gtk2::VBox(0,0);
        $self->{vboxUnused}->pack_start($self->{scrollPanelUnused}, 1, 1, 0);

        my $vboxChange = new Gtk2::VBox(1,1);
        my $tmpVbox = new Gtk2::VBox(0,0);
        my $toRight = new Gtk2::Button('->');
        $toRight->remove($toRight->child);
        $toRight->add(Gtk2::Image->new_from_stock('gtk-go-forward', 'button'));
        $toRight->signal_connect('clicked' => sub {
            $self->moveFromTo('unused', 'used');
        });
        my $toLeft = new Gtk2::Button('<-');
        $toLeft->remove($toLeft->child);
        $toLeft->add(Gtk2::Image->new_from_stock('gtk-go-back', 'button'));
        $toLeft->signal_connect('clicked' => sub {
            $self->moveFromTo('used', 'unused');
        });
        $tmpVbox->pack_start($toRight,0,0,$GCUtils::margin);
        $tmpVbox->pack_start($toLeft,0,0,$GCUtils::margin);
        $vboxChange->pack_start($tmpVbox,1,0,0);
        
        $self->{scrollPanelUsed} = new Gtk2::ScrolledWindow;
        $self->{scrollPanelUsed}->set_policy ('never', 'automatic');
        $self->{scrollPanelUsed}->set_shadow_type('etched-in');
        $self->{scrollPanelUsed}->add($self->{used});
        $self->{vboxUsed} = new Gtk2::VBox(0,0);
        $self->{vboxUsed}->pack_start($self->{scrollPanelUsed}, 1, 1, 0);

        $self->{unused}->signal_connect ('row-activated' => sub {
            $self->moveFromTo('unused', 'used');
        });
        $self->{used}->signal_connect ('row-activated' => sub {
            $self->moveFromTo('used', 'unused');
        });
                     
        $self->{vboxRight} = new Gtk2::VBox(0,0);
        my $toUp = new Gtk2::Button('^');
        $toUp->remove($toUp->child);
        $toUp->add(Gtk2::Image->new_from_stock('gtk-go-up', 'button'));
        $toUp->signal_connect('clicked' => sub {
            $self->moveDownUp(-1);
        });
        my $toDown = new Gtk2::Button('_');
        $toDown->remove($toDown->child);
        $toDown->add(Gtk2::Image->new_from_stock('gtk-go-down', 'button'));
        $toDown->signal_connect('clicked' => sub {
            $self->moveDownUp(1);
        });
        $self->{vboxRight}->pack_start($toUp, 0, 0, $GCUtils::margin);
        $self->{vboxRight}->pack_start($toDown, 0, 0, $GCUtils::margin);
                    
        $hboxMain->pack_start(new Gtk2::HBox,0,0,$GCUtils::margin);
        $hboxMain->pack_start($self->{vboxUnused},1,1,$GCUtils::halfMargin);
        $hboxMain->pack_start($vboxChange,0,0,$GCUtils::halfMargin);
        $hboxMain->pack_start($self->{vboxUsed},1,1,$GCUtils::halfMargin);
        $hboxMain->pack_start($self->{vboxRight},0,0,$GCUtils::halfMargin);
        $hboxMain->pack_start(new Gtk2::HBox,0,0,$GCUtils::quarterMargin);
        
        $self->{marginBox} = new Gtk2::VBox;
        $self->vbox->pack_start($self->{marginBox}, 0, 0, $GCUtils::halfMargin);
        $self->vbox->pack_start($hboxMain, 1, 1, 0);
        
        # Without some default size, everything will be shrinked as there are some scrollers
        $self->set_default_size(200,400);
        $self->{scrollPanelUnused}->set_size_request(150,-1);
        $self->{scrollPanelUsed}->set_size_request(150,-1);
        
        return $self;
    }
}

{
    #Class that is used to let user select
    #fields needed in export.
    package GCFieldsSelectionDialog;
    use base qw/GCDoubleListDialog/;
    
    sub getInitData
    {
        my $self = shift;
        my @array;
        @array = keys %{$self->{fieldNameToId}};
        return \@array;
    }
    
    sub getData
    {
        my $self = shift;
        
        my @array;
        foreach (@{$self->{parent}->{fields}})
        {
            push @array, $self->{fieldIdToName}->{$_};
        }
        
        return \@array;
    }
    
    sub saveList
    {
        my ($self, $list) = @_;
        
        my @array;
        foreach (@{$list})
        {
            push @array, $self->{fieldNameToId}->{$_};
        }
        $self->{parent}->{fields} = \@array;
    }

    sub getUnusedLabel
    {
        my $self = shift;
        
        return $self->{parent}->{lang}->{ImportExportFieldsUnused};
    }
    sub getUsedLabel
    {
        my $self = shift;
        
        return $self->{parent}->{lang}->{ImportExportFieldsUsed};
    }

    sub loadFromFile
    {
        my $self = shift;
        my $fileDialog = new GCFileChooserDialog($self->{parent}->{lang}->{FieldsListOpen}, $self, 'open', 1);
        $fileDialog->set_filename($self->{filename});
        my $response = $fileDialog->run;
        if ($response eq 'ok')
        {
            $self->{filename} = $fileDialog->get_filename;
            open FILE, '<'.$self->{filename};
            my $model = <FILE>;
            chop $model;
            if ($model eq $self->{model}->getName)
            {
                $self->clearList;
                my @data;
                while (<FILE>)
                {
                    chop;
                    push @data, $self->{fieldIdToName}->{$_};
                }
                $self->setListData(\@data);
            }
            else
            {
                my $dialog = Gtk2::MessageDialog->new($self,
                                          [qw/modal destroy-with-parent/],
                                          'error',
                                          'ok',
                                          $self->{parent}->{lang}->{FieldsListError});
                $dialog->set_position('center-on-parent');
                $dialog->run();
                $dialog->destroy ;
            }
            close FILE;
        }        
        $fileDialog->destroy;
    }

    sub saveToFile
    {
        my $self = shift;
        my $fileDialog = new GCFileChooserDialog($self->{parent}->{lang}->{FieldsListSave}, $self, 'save', 1);
        $fileDialog->set_filename($self->{filename});
        my $response = $fileDialog->run;
        if ($response eq 'ok')
        {
            $self->{filename} = $fileDialog->get_filename;
            open FILE, '>'.$self->{filename};
            print FILE $self->{model}->getName, "\n" if $self->{model};
            foreach (@{$self->{usedArray}})
            {
                print FILE $self->{fieldNameToId}->{$_}, "\n";
            }
            close FILE;
        }        
        $fileDialog->destroy;
    }

    sub compareItems
    {
        my ($self, $item1, $item2) = @_;
        use locale;
        my @values1 = split $self->{separator}, $item1;
        my @values2 = split $self->{separator}, $item2;
        if ($values1[0] eq $values2[0])
        {
            return $values1[1] cmp $values2[1];
        }
        else
        {
            return $self->{groupsOrder}->{$values1[0]} <=> $self->{groupsOrder}->{$values2[0]};
        }
    }

    sub new
    {
        my ($proto, $parent, $title, $preList, $isIdList, $ignoreField) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new(
                                $parent,
                                $title
                            );

        $self->{ignoreField} = $ignoreField;
        bless ($self, $class);
        $self->{lang} = $parent->{lang};
        $self->{tooltips} = Gtk2::Tooltips->new();
        my $fillButton = new Gtk2::Button($parent->{lang}->{ImportExportFieldsFill});
        $fillButton->set_border_width($GCUtils::margin);
        $fillButton->signal_connect('clicked' => sub {
            $self->fillList;
        });
        my $clearButton = new Gtk2::Button($parent->{lang}->{ImportExportFieldsClear});
        $clearButton->set_border_width($GCUtils::margin);
        $clearButton->signal_connect('clicked' => sub {
            $self->clearList;
        });            
        
#        $self->{hboxAction}->pack_start($fillButton,1,1,4 * $GCUtils::margin);
#        $self->{hboxAction}->pack_start($clearButton,1,1,4 * $GCUtils::margin);
        $self->{vboxUnused}->pack_start($fillButton, 0, 0, 0);
        $self->{vboxUsed}->pack_start($clearButton, 0, 0, 0);
        
        my $loadButton = new Gtk2::Button('open');
        $self->{tooltips}->set_tip($loadButton,
                                   $parent->{lang}->{FieldsListOpen});
        $loadButton->remove($loadButton->child);
        $loadButton->add(Gtk2::Image->new_from_stock('gtk-open', 'button'));
        $loadButton->signal_connect('clicked' => sub {
            $self->loadFromFile;
        });
        my $saveButton = new Gtk2::Button('save');
        $self->{tooltips}->set_tip($saveButton,
                                   $parent->{lang}->{FieldsListSave});
        $saveButton->remove($saveButton->child);
        $saveButton->add(Gtk2::Image->new_from_stock('gtk-save', 'button'));
        $saveButton->signal_connect('clicked' => sub {
            $self->saveToFile;
        });            
        
        $self->{vboxRight}->pack_start($loadButton, 0, 0, $GCUtils::halfMargin);
        $self->{vboxRight}->pack_start($saveButton, 0, 0, $GCUtils::halfMargin);
        
        $self->{fieldNameToId} = {};
        $self->{groupsOrder} = {};

        my $model = $self->{parent}->{parent}->{model};
        if ($model)
        {
            my $groups = $model->getGroups;
            $self->{separator} = $model->getDisplayedText('Separator');
            while (my ($key, $value) = each %{$model->{fieldsInfo}})
            {
                next if !$value->{displayed};
                my $displayed = $groups->{$value->{group}}->{displayed}
                              . $self->{separator}
                              . $value->{displayed};
                $self->{fieldNameToId}->{$displayed} = $key;
                $self->{fieldIdToName}->{$key} = $displayed;
            }
            my $order = 0;
            foreach (@{$model->{groups}})
            {
                $self->{groupsOrder}->{$groups->{$_->{id}}->{displayed}} = $order++;
            }
            $self->{model} = $model;
        }
        $self->{scrollPanelUnused}->set_size_request(200,-1);
        $self->{scrollPanelUsed}->set_size_request(200,-1);        
        $self->fillList if ! $preList;
        
        if ($preList)
        {
            $self->setListData($preList) if !$isIdList;
            $self->setListFromIds($preList) if $isIdList;
        }
        $self->saveList(\@{$self->{usedArray}});
        return $self;
    }

    sub addIgnoreField
    {
        my ($self, $ignoreField) = @_;
        $self->{ignoreString} = $self->{parent}->{lang}->{FieldsListIgnore};
        $self->{fieldNameToId}->{$self->{ignoreString}} = $ignoreField;
        $self->{fieldIdToName}->{$ignoreField} = $self->{ignoreString};
        $self->addToPermanent($self->{ignoreString});
    }

    sub removeIgnoreField
    {
        my ($self) = @_;
        $self->removeFromPermanent($self->{ignoreString});
    }
}


{
    package GCFileChooserDialog;
    use GCGraphicComponents;
    use File::Basename;
    use File::Spec;
    use Cwd 'realpath';

    sub new
    {
        my ($proto, $title, $parent, $action, $withFilter, $autoAppend) = @_;
        my $class = ref($proto) || $proto;
        my $self  = {};
        $self->{action} = $action;
        $self->{parent} = $parent;
        $self->{ignoreFilter} = 1;
        $self->{autoAppend} = 0;
        my $dialog;
        eval { $dialog = new Gtk2::FileChooserDialog($title, $parent, $action, @GCDialogs::okCancelButtons) };
        if ($@)
        {
            $self->{dialog}  = new Gtk2::FileSelection($title);
            $self->{dialog}->main_vbox->show_all;
            my @vboxChildren = $self->{dialog}->main_vbox->get_children;
            my @buttonBoxChildren = $vboxChildren[0]->get_children;
            if ($action eq 'select-folder')
            {
                $buttonBoxChildren[1]->hide;
                $buttonBoxChildren[2]->hide;
                $self->{dialog}->selection_entry->hide;
                $self->{dialog}->file_list->parent->hide;
            }
            elsif ($action eq 'open')
            {
                $self->{dialog}->hide_fileop_buttons;
                $self->{dialog}->selection_entry->set_editable(0);
            }
            $self->{type} = 'old';
        }
        else
        {
            $self->{dialog} = $dialog;
            if ($action eq 'save')
            {
                $self->{requireOverwriteConfirmation} = 0;
                eval { $dialog->set_do_overwrite_confirmation(1) };
                $self->{requireOverwriteConfirmation} = 1 if $@;
            }
            $self->{type} = 'new';
            if ($withFilter)
            {
                $self->{autoAppend} = $autoAppend;
                my $filterAll;
                $@ = '';
                eval '$filterAll = new Gtk2::FileFilter';
                if (!$@)
                {
                    $self->{ignoreFilter} = 0;
                    $filterAll->set_name($self->{parent}->{lang}->{FileAllFiles});
                    $filterAll->add_pattern('*');
                    $self->{dialog}->add_filter($filterAll);
                    $self->{filters} = [];
                }
            }
            $self->{dialog}->set_default_response ('ok');
        }
        bless ($self, $class);
        return $self;
    }

    sub setTitle
    {
        my ($self, $title) = @_;
        $self->{dialog}->set_title($title);
    }

    sub transformFilename
    {
        my ($self, $file) = @_;
        
        #$file = GCUtils::pathToUnix($file);
        if ($self->{autoAppend})
        {
            my $tmpFilter = $self->{dialog}->get_filter;
            if ($tmpFilter)
            {
                my $pattern = $self->{filtersPatterns}->{$tmpFilter->get_name};
                if ($pattern)
                {
                    $pattern =~ s/^.*?([^*]*)$/$1/;
                    $file .= $pattern if $file !~ /\./;
                }
            }
        }
        return $file;
    }

    sub get_filename
    {
        my $self = shift;
        my $filename = $self->{dialog}->get_filename;
        $filename .= (($^O =~ /win32/i) ? '\\' : '/') if ($self->{action} eq 'select-folder');
        #$filename .= '/' if ($self->{action} eq 'select-folder');
        return $self->transformFilename($filename);
    }

    sub set_filename
    {
        my ($self, $file) = @_;
        
        $file ||= $ENV{HOME};
        my $dir = '.';
        if (! File::Spec->file_name_is_absolute( $file ))
        {
            $dir = dirname($self->{parent}->{options}->file)
                if ($self->{parent}->{options})
    	        && ($self->{parent}->{options}->file);
        }
        my $empty = 0;
        $file = $ENV{HOME}.'/' if !$file;
		$file = $dir.'/'.$file if (! File::Spec->file_name_is_absolute( $file ));
        $file =~ s/\//\\/g if ($^O =~ /win32/i);
        $file = Cwd::realpath($file)
            if -e $file;
        $empty = 1 if $file eq '';
        eval {
            $self->{dialog}->set_filename($file) if (!$empty && !(-d $file));
            $self->{dialog}->set_current_folder($file.'/')
                if (($self->{type} eq 'new') && 
                (($empty) || (-d $file)));
        };
        if ($self->{preview})
        {
            $self->updatePreview($self) if ($self->{type} eq 'old');
            $self->{preview}->setValue($file) if ($self->{type} eq 'new');
        }
    }

    sub set_pattern_filter
    {
        my ($self, @filters) = @_;
        return if $self->{ignoreFilter};
        if ($self->{type} eq 'new')
        {
            $self->{dialog}->remove_filter($_) foreach(@{$self->{filters}});
            $self->{filters} = [];
            $self->{filtersPatterns} = {};
            foreach my $filterPattern (@filters)
            {
                my $filter;
                eval '$filter = new Gtk2::FileFilter';
                return if $@;
                $filter->set_name($filterPattern->[0]);
                if (ref($filterPattern->[1]))
                {
                    # Filter pattern is an array. Use a custom filter so file extensions are not case sensitive
                    $filter->add_custom('filename', sub {
                        my ($filename, undef, $extension) = fileparse(shift->{filename},qr{\.[^\.]*});
                        $extension =~ s/[^\.\w]//g;
                        $extension = lc($extension);
                        return (grep {$_ eq $extension} @{$filterPattern->[1]});
                    });

                }
                else
                {
                    # Filter pattern is single valid. Use a custom filter so file extensions are not case sensitive
                    $filter->add_custom('filename', sub {
                        my ($filename, undef, $extension) = fileparse(shift->{filename},qr{\..*});
                        $extension =~ s/[^\.\w]//g;
                        $extension = lc($extension);
                        my $filterExt = $filterPattern->[1];
                        $filterExt =~ s/^[^\.]*//;
                        return ($extension eq $filterExt);
                    });
                }
                push @{$self->{filters}}, $filter;
                $self->{dialog}->add_filter($filter);
                $self->{filtersPatterns}->{$filterPattern->[0]} = $filterPattern->[1];
            }
            $self->{dialog}->set_filter($self->{filters}->[0]) if $self->{filters}->[0];
        }
    }

    sub run
    {
        my $self = shift;
        return $self->{dialog}->run if ($self->{action} ne 'save')
                                    || (($self->{action} eq 'save')
                                     && (!$self->{requireOverwriteConfirmation}));
        my $response;
        while (1)
        {
            $response = $self->{dialog}->run;
            return $response if ($response ne 'ok');
            my $filename = $self->get_filename;
            if (-e $filename)
            {
                my  $dialog = Gtk2::MessageDialog->new($self->{dialog},
                                                       [qw/modal destroy-with-parent/],
                                                       'question',
                                                       'yes-no',
                                                       $self->{parent}->{lang}->{FileChooserOverwrite});

                $dialog->set_position('center-on-parent');
                my $overwrite = $dialog->run;
                $dialog->destroy;
                return $response if ($overwrite eq 'yes');
            }
            else
            {
                return $response;
            }
        }
    }

    sub hide
    {
        my $self = shift;
        return $self->{dialog}->hide;        
    }

    sub setWithImagePreview
    {
        my ($self, $value) = @_;

        if ($value)
        {
            $self->{preview} = new GCItemImage($self->{parent}->{options}, $self->{parent},1);
            $self->{preview}->setImmediate;
            if ($self->{type} eq 'new')
            {
                $self->{dialog}->signal_connect('update-preview' => \&updatePreview, $self);
				$self->{dialog}->set_preview_widget($self->{preview});
				$self->{dialog}->set_preview_widget_active(1);
            }
            else
            {
                $self->{dialog}->file_list->signal_connect('cursor-changed' => \&updatePreview, $self);
                $self->{dialog}->file_list->parent->parent->parent->pack_start($self->{preview},0,0,5);
            }
            $self->{preview}->show;
        }
        else
        {
            if ($self->{preview})
            {
                $self->{dialog}->file_list->parent->parent->parent->remove($self->{preview}) if ($self->{type} eq 'old');
                $self->{preview}->destroy;
                $self->{preview} = undef;
            }
        }
    }

    sub updatePreview
    {
        my ($widget, $self, $other) = @_;
        my $file;
        if ($self->{type} eq 'new')
        {
            eval
            {
                $file = $self->{dialog}->get_preview_filename;
            }
        }
        else
        {
            $file = $self->get_filename;
        }
        $self->{preview}->setValue($file) if $file;
    }

    sub destroy
    {
        my $self = shift;
        $self->{dialog}->destroy;
    }
}

{
    package GCItemWindow;
    use base 'GCModalDialog';
    use GCGraphicComponents;

    sub show
    {
        my $self = shift;

        $self->SUPER::show();
        my $code = $self->run;
        return $code;
    }

    sub new
    {
        my ($proto, $parent, $title, @extraButtons) = @_;
        my $class = ref($proto) || $proto;
        my $self = $class->SUPER::new($parent, '', '', 1, @extraButtons);
        bless ($self, $class);
        
        $self->set_position('none');
        my $options = new GCOptionLoader;
        #$options->lockPanel(0);
        $options->file($parent->{options}->file);
        $self->{panel} = new GCFormPanel($parent, $options, $parent->{model}->getDefaultPanel);
        $self->{panel}->createContent($parent->{model});

        #Init combo boxes
        foreach(@{$parent->{model}->{fieldsHistory}})
        {
            $self->{panel}->{$_}->setValues($parent->{panel}->getValues($_));
        }

        my $scrollPanelItem = new Gtk2::ScrolledWindow;
        $scrollPanelItem->set_policy ('automatic', 'automatic');
        $scrollPanelItem->set_shadow_type('none');
        $scrollPanelItem->add_with_viewport($self->{panel});

        $self->vbox->add($scrollPanelItem);

        $self->vbox->show_all;
        $self->{panel}->setShowOption($parent->getDialog('DisplayOptions')->{show}, 1);
        
        #Adjust some settings
        $self->{panel}->disableAutoUpdate;

        $self->set_default_size($parent->{options}->itemWindowWidth,$parent->{options}->itemWindowHeight);
        $self->setTitle($title);
        return $self;
    }

    sub setTitle
    {
        my ($self, $title) = @_;
        $self->set_title($title.' - GCstar');
    }

}

{
    package GCRandomItemWindow;
    use base 'GCItemWindow';

    sub new
    {
        my ($proto, $parent, $title) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent, $title,
                                       'gtk-go-forward' => 'no');
        bless ($self, $class);
        
        $self->{panel}->deactivate;

        $parent->{tooltips}->set_tip(($self->action_area->get_children)[1],
                                     $parent->{lang}->{RandomOkTip});
        $parent->{tooltips}->set_tip(($self->action_area->get_children)[0],
                                     $parent->{lang}->{RandomNextTip});

        $self->set_default_response('no');
        return $self;
    }
}

{
    package GCCriticalErrorDialog;
    use base 'Gtk2::MessageDialog';
    
    sub new
    {
        my ($proto, $parent, $message) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent,
                                       [qw/modal destroy-with-parent/],
                                       'error',
                                       'ok',
                                        $message);
        bless ($self, $class);
        $self->set_position('center-on-parent');
        $self->{parent} = $parent;
        $self->{message} = $message;
        
        my $label = $parent->{lang}->{MenuBugReport};
        $label =~ s/_//g;
        my $bugReport = new Gtk2::Button($label);
        $self->action_area->pack_start($bugReport,0,0,0);
        $self->action_area->reorder_child($bugReport,0);
        $bugReport->show_all;
        $bugReport->signal_connect('clicked' => sub {
            $self->reportBug;
        });
        
        return $self;
    }
    
    sub show
    {
        my $self = shift;
        $self->run;
        $self->destroy;
    }
    
    sub reportBug
    {
        my $self = shift;
        my $subject = $self->{parent}->{lang}->{BugReportSubject};
        my $message = '
'.$self->{parent}->{lang}->{BugReportVersion}.$self->{parent}->{lang}->{Separator}.$self->{parent}->{version}.'
'.$self->{parent}->{lang}->{BugReportPlatform}.$self->{parent}->{lang}->{Separator}.$^O.'

'.$self->{parent}->{lang}->{BugReportMessage}.$self->{parent}->{lang}->{Separator}.$self->{message}.'

'.$self->{parent}->{lang}->{BugReportInformation}.$self->{parent}->{lang}->{Separator};
        $self->{parent}->reportBug(undef, $subject, $message);
    }
}

1;
