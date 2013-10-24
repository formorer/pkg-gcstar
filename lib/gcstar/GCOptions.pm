package GCOptions;

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

our $DEFAULT_IMG_DIR='./.%FILE_BASE%_pictures/';

{
    package GCOptionLoader;

    my $DEFAULT_LANG='EN';
    #my $DEFAULT_IMG_DIR=$ENV{GCS_DATA_HOME}.'/images/';

    use XML::Simple;
    use IO::File;
    use POSIX (':errno_h');
    use GCLang;

    sub new
    {
        # fallbackOptions has been added in 1.7.0. Previous versions stored some collection
        # specific settings at global level. This has been moved to collection level, but to
        # let users keep their previous settings, it will try to find it at global level if not found
        # at collection level.
        
        my ($proto, $file, $main, $fallbackOptions) = @_;
        my $class = ref($proto) || $proto;
        my $self  = {created => 0, fallbackOptions => $fallbackOptions};
        
        #GCLang::loadLangs;
        
        bless ($self, $class);
        $self->load($file, $main) if $file;
        return $self;
    }

    sub newFromXmlString
    {
        my ($proto, $string) = @_;
        my $class = ref($proto) || $proto;
        my $self  = {created => 0};
        bless ($self, $class);
        if ($string)
        {
            my $xs = XML::Simple->new;
            $self->{options} = $xs->XMLin($string,
                                          SuppressEmpty => 1);
        }
        return $self;
    }

    sub toXmlString
    {
        my $self = shift;

        my $result = '<collectionInlinePreferences>
';
        while (my ($key,$value) = each(%{$self->{options}}))
        {
            $result .= "  <$key>".GCUtils::encodeEntities($value)."</$key>\n";
        }
        $result .= '</collectionInlinePreferences>';
        return $result;
    }

    sub error
    {
        my ($self, $type, $errmsg) = @_;
        if ($self->{parent})
        {
            $self->{parent}->optionsError($type, $errmsg);
        }
        else
        {
            print "Error performing $type for ".$self->{file}.": $errmsg\n";
        }
    }

    sub setParent
    {
        my ($self, $parent) = @_;
        $self->{parent} = $parent;
    }


    sub load
    {
        my ( $self, $file, $main ) = @_;
        
        my %defaults;
        if ( $main )
        {
            my $lang = $ENV{LANG};
            if ($lang)
            {
                $lang =~ s/(..)_?.*/\U$1\E/;
            }
            else
            {
                $lang = $DEFAULT_LANG;
            }; # if
            
            %defaults = (
                images           => $GCOptions::DEFAULT_IMG_DIR,
                autosave         => 1,
                noautoload       => 0,
                programs         => "system",
                browser          => "firefox",
                player           => "mplayer",
                audio            => "xmms",
                imageEditor      => "gimp",
                file             => "",
                split            => 300,
                width            => 920,
                height           => 640,
                confirm          => 1,
                lang             => $lang,
                status           => 1,
                splash           => 1,
                tearoffMenus     => 0, 
                toolbar          => 3,
                toolbarPosition  => 0,
                transform        => 1,
                articles         => "le,la,les,l,un,une,des,a,the,der,die,das,ein,eine,el,los,una",
                askImport        => 0,
                searchStop       => 1,
                alwaysOriginal   => 0,
                proxy            => "",
                cookieJar        => "",
                borrowers        => "",
                emails           => "",
                view             => 0,
                columns          => 3,
                resizeImgList    => 1,
                animateImgList   => 1,
                listBgPicture    => 1,
                useOverlays      => 1,
                mailer           => "Sendmail",
                from             => "",
                subject          => "GCstar email",
                smtp             => "",
                template         => "Hello %1,<br/><br/>You have borrowed my %2 since %3. I\'d like to get it back shortly.",
                history          => "none|none|none|none|none",
                historysize      => "5",
                useRelativePaths => 1,
                useTitleForPics  => 1,
                expandersMode    => 'cut',
                dateFormat       => '%d/%m/%Y',
                spellCheck       => 1,
                cdDevice         => '/dev/cd',
                useStars         => 1,
                bigPics          => 0,
                listPaneSplit    => 10000,  # Big value to make sure it's hidden by default
                displayMenuBar   => 1
            ); 
        }; # if

        $self->{file} = $file;
        $self->{options} = \%defaults;    # Use default values for now.
        my $handle = IO::File->new($file, "<:utf8");
        if (defined( $handle))
        {
            # File opened succesfully, read it.
            my $options = \%defaults;
            while (my $line = $handle->getline())
            {
                # Remove last character if white space
                # This includes carriage return and fix an issue when using DOS-encoded file on Unix system
                $line =~ s/\s$//;
                if ($line =~ m{^(.*?)=(.*)$})
                {
                    $options->{$1} = $2;
                }
                else
                {
                    # TODO: Report an error in config file.
                } # if    
            } # while
            # Close file, check errors.
            my $rc = $handle->close();
            if ($rc)
            {
                # File was read successfully, update options.
                $self->{options} = $options;
            }
            else
            {
                # File was not read, do not change default values and report error.
                $self->error( 'read', $! );
            } #if
        }
        else
        {
            # File is not opened. Check the reason.
            if ($! == ENOENT)
            {
                # File does not exist -- not a problem, just continue with defaults.
                $self->{options} = \%defaults;
            }
            else
            {
                # It is a real error, report it.
                # ???: Why report goes to stdout?
                # TODO: Open a error window.
                $self->error('read', $!);
            } # if
        } # if

        if (!GCLang::loadLangs($self->lang) && $main)
        {
            $self->lang($DEFAULT_LANG);
            GCLang::loadLangs($self->lang);
        }
    }

    sub getFullLang
    {
        my $self = shift;
        (my $lang = $self->lang) =~ s/(.*)/\L$1\E_$1/;
        $lang =~ s/_EN/_US/; # Fix for english
        $lang =~ s/_CS/_CZ/; # Fix for Czech
        $lang =~ s/_cn_ZH//; # Fix for Simplified Chinese
        $lang =~ s/_ZH/_TW/; # Fix for Traditional Chinese
        $lang .= '.UTF-8';
        $lang = 'sr@Latn' if $lang =~ /^sr/;  # Fix for serbian
        return $lang;
    }

    sub save
    {
        my $self = shift;
        return if !$self->{file};
        my $handle = IO::File->new($self->{file}, ">:utf8");
        if (defined($handle))
        {
            while ( my ( $key, $value ) = each( %{ $self->{options} } ) )
            {
                if ($key)
                {
                    $handle->print( "$key=$value\n" );
                } # if
            } # while
            $handle->close() or $self->error('save', $!); 
        }
        else
        {
            $self->error( 'save', $! );
        }; # if    
    }

    sub exists
    {
        my ($self, $name) = @_;
        
        return exists $self->{options}->{$name};
    }

    sub AUTOLOAD
    {
        my $self = shift;
        my $name = our $AUTOLOAD;
        return if $name =~ /::DESTROY$/;
        my @comp = split('::', $name);
        $name = $comp[-1];
        if (@_)
        {
            $self->{options}->{$name} = shift;
        }
        else
        {
            if (!exists $self->{options}->{$name} && $self->{fallbackOptions})
            {
                $self->{options}->{$name} = $self->{fallbackOptions}->$name;
            }
            return $self->{options}->{$name};
        }
    }
    
    sub checkPreviousGCfilms
    {
        my ($self, $parent) = @_;
        
        $self->{modelsFactory} = $parent->{modelsFactory};
        my $gcfilmsconf = $ENV{XDG_CONFIG_HOME}.'/gcfilms/gcfilms.conf';

        if ( -e $gcfilmsconf)
        {
            my  $dialog = Gtk2::MessageDialog->new($parent,
                        [qw/modal destroy-with-parent/],
                        'question',
                        'ok-cancel',
                        $parent->{lang}->{GCfilmsImportQuestion});
            
            my $withOptionsCb = new Gtk2::CheckButton($parent->{lang}->{GCfilmsImportOptions});
            my $withDataCb = new Gtk2::CheckButton($parent->{lang}->{GCfilmsImportData});
            $dialog->vbox->pack_start($withOptionsCb, 0, 0, 0);
            $dialog->vbox->pack_start($withDataCb, 0, 0, 0);
            $dialog->vbox->show_all;
            #$parent->{splash}->hide if $parent->{splash};
            my $response = $dialog->run;
            my $withOptions = $withOptionsCb->get_active;
            my $withData = $withDataCb->get_active;
            $dialog->destroy;
            return if $response ne 'ok';
            my $gcfilmsOptions = GCOptionLoader->new($gcfilmsconf, 0);
            $self->importGCfilmsOptions($gcfilmsOptions) if $withOptions;
            $self->importGCfilmsData($gcfilmsOptions) if $withData;            
        }
    }
    
    sub importGCfilmsOptions
    {
        my ($self, $options) = @_;
        
        my @commonOptions = (
                                'listImgSize',
                                'historysize',
                                'browser',
                                'listBgColor',
                                'listFgColor',
                                'searchStop',
                                'groupItems',
                                'view',
                                'split',
                                'autosave',
                                'articles',
                                'lang',
                                'template',
                                'askImport',
                                'subject',
                                'toolbar',
                                'listImgSkin',
                                'columns',
                                'proxy',
                                'width',
                                'mailer',
                                'smtp',
                                'status',
                                'borrowers',
                                'confirm',
                                'itemWindowHeight',
                                'from',
                                'useRelativePaths',
                                'toolbarPosition',
                                'transform',
                                'itemWindowWidth',
                                'player',
                                'height',
                                'listBgPicture',
                                'emails',
                                'splash'
                            );
                            
        my @specificOptions = (
                                'sortOrder',
                                'details',
                                'sortField',
                                'plugin',
                                'multisite',
                              );
                              
        foreach (@commonOptions)
        {
            (my $gcfilmsOption = $_) =~ s/item/movie/;
            my $value = $options->$gcfilmsOption;
            $value =~ s|<br>|<br/>|gm;
            $self->$_($value);
        }
        my $newOptions = $self->{modelsFactory}->getModel('GCfilms')->{preferences};
        foreach (@specificOptions)
        {
            $newOptions->$_($options->$_);
        }
        
        # Special processing for order -> layout
        my $layout = 'form';
        my $order = $options->order;
        $layout = 'compact' if ($order == 1) || ($order == 2);
        $layout = 'readonly' if ($order == 3) || ($order == 4);
        $newOptions->layout($layout);

        $newOptions->save;
    }
    
    sub importGCfilmsData
    {
        my ($self, $options) = @_;
        $self->{parent}->importWithDetect($options->file, 1);
        $self->{options}->{file} = $ENV{GCS_DATA_HOME}.'/films.gcs';
        $self->{parent}->{items}->save($self->{parent});
        #$self->{parent}->setFileName($self->{options}->{file});
        $self->{parent}->refreshTitle;
    }
}

{
    package GCOptionsDialog;

    use Glib::Object::Subclass
                Gtk2::Dialog::
    ;
    
    @GCOptionsDialog::ISA = ('GCModalDialog');

    use GCPlugins;

    use GCLang;
    use GCStyle;
    use GCMail;

    sub on_destroy
    {
        my ($widget, $self) = @_;
        return 1;
    }

    sub initValues
    {
        my $self = shift;

        $self->{viewChanged} = 0;
        $self->{viewOptionsChanged} = 0;
        $self->{expert}->set_active($self->{options}->expert);

        if ($self->{options}->programs eq 'system')
        {
            $self->{systemPrograms}->set_active(1);
        }
        else
        {
            $self->{userPrograms}->set_active(1);
        }
        $self->{defineProgramsButton}->lock($self->{systemPrograms}->get_active);
        $self->{browser} = $self->{options}->browser;
        $self->{player} = $self->{options}->player;
        $self->{audio} = $self->{options}->audio;
        $self->{imageEditor} = $self->{options}->imageEditor;

        $self->{cdDevice}->setValue($self->{options}->cdDevice);
        $self->{images}->setValue($self->{options}->images);
        $self->{confirm}->set_active($self->{options}->confirm);
        $self->{autosave}->set_active($self->{options}->autosave);
        $self->{autoload}->set_active(! $self->{options}->noautoload);
        $self->{splash}->set_active($self->{options}->splash);
        $self->{tearoffMenus}->set_active($self->{options}->tearoffMenus);
        $self->{options}->spellCheck(1) if ! $self->{options}->exists('spellCheck');
        $self->{spellCheck}->set_active($self->{options}->spellCheck)
            if $self->{spellCheck};
        $self->{useRelativePaths}->set_active($self->{options}->useRelativePaths);
        $self->{useStars}->set_active($self->{options}->useStars);
        $self->{proxycb}->set_active($self->{options}->proxy);
        $self->{proxyurl}->set_text($self->{options}->proxy);
        $self->{cookieJarcb}->set_active($self->{options}->cookieJar);
        $self->{cookieJarPath}->setValue($self->{options}->cookieJar);
        $self->{transform}->set_active($self->{options}->transform);
        $self->{articles}->set_text($self->{options}->articles);

        if ($self->{options}->useTitleForPics)
        {
            $self->{picturesNameTitle}->set_active(1);
        }
        else
        {
            $self->{picturesNameAuto}->set_active(1);
        }

        $self->{options}->columns(3) if ! $self->{options}->exists('columns');
        $self->{columns} = $self->{options}->columns;

        $self->{options}->resizeImgList(0) if ! $self->{options}->exists('resizeImgList');
        $self->{resizeImgList} = $self->{options}->resizeImgList;

        $self->{options}->animateImgList(1) if ! $self->{options}->exists('animateImgList');
        $self->{animateImgList} = $self->{options}->animateImgList;

        $self->{options}->toolbar(3) if ! $self->{options}->exists('toolbar');
        $self->{toolbarOption}->setValue($self->{options}->toolbar);

        $self->{options}->toolbarPosition(0) if ! $self->{options}->exists('toolbarPosition');
        $self->{toolbarPositionOption}->setValue($self->{options}->toolbarPosition);

        $self->{options}->expandersMode('cut') if ! $self->{options}->exists('expandersMode');
        $self->{expandersMode}->setValue($self->{options}->expandersMode);

        $self->{dateFormat}->setValue($self->{options}->dateFormat)
            if $self->{dateFormat};

        $self->{options}->view(0) if ! $self->{options}->exists('view');
        $self->{viewOption}->setValue($self->{options}->view);
       
        $self->{model}->{preferences}->plugin('ask')
            if ! $self->{model}->{preferences}->exists('plugin');
        $self->{pluginOption}->setValue($self->{model}->{preferences}->plugin);

        $self->{askImport}->set_active($self->{options}->askImport);
        $self->{searchStop}->set_active($self->{options}->searchStop);
        $self->{bigPics}->set_active($self->{options}->bigPics);
        
        $self->{langOption}->setValue($self->{options}->lang);
        $self->{styleOption}->setValue($self->{options}->style);

        $self->{layoutOption}->setValue($self->{model}->{preferences}->layout);
        $self->{panelStyleOption}->setValue($self->{options}->panelStyle);

        $self->{options}->mailer('Sendmail') if ! $self->{options}->exists('mailer');
        $self->{mailerOption}->setValue($self->{options}->mailer);

        $self->{from}->set_text($self->{options}->from);
        
        # Picture size for image mode
        $self->{options}->listImgSize(2) if ! $self->{options}->exists('listImgSize');
        $self->{listImgSize} = $self->{options}->listImgSize;
        $self->{options}->listImgSkin($GCStyle::defaultList) if ! $self->{options}->exists('listImgSkin');
        $self->{listImgSkin} = $self->{options}->listImgSkin;
        $self->{options}->listBgColor('65535,65535,65535') if ! $self->{options}->exists('listBgColor');
        $self->{options}->listFgColor('0,0,0') if ! $self->{options}->exists('listFgColor');
        $self->{mlbg} = $self->{options}->listBgColor;
        $self->{mlfg} = $self->{options}->listFgColor;
        $self->{useOverlays} = $self->{options}->useOverlays;
        $self->{listBgPicture} = $self->{options}->listBgPicture;
                
        $self->{proxyurl}->set_editable(0) if ! $self->{proxycb}->get_active;
        $self->{proxyurl}->set_editable(1) if $self->{proxycb}->get_active;
        $self->{cookieJarPath}->lock(1) if ! $self->{cookieJarcb}->get_active;
        $self->{cookieJarPath}->lock(0) if $self->{cookieJarcb}->get_active;

        $self->{historysize}->set_value($self->{options}->historysize);

         # Picture size for detailed mode
        $self->{options}->detailImgSize($self->{options}->listImgSize)
            if ! $self->{options}->exists('detailImgSize');

       $self->{model}->{preferences}->details($self->{model}->{commonFields}->{title})
            if ! $self->{model}->{preferences}->exists('details');
        $self->{details} = $self->{model}->{preferences}->details;
        
        $self->{detailImgSize} = $self->{options}->detailImgSize;
        $self->{groupBy} = $self->{model}->{preferences}->groupBy;
        $self->{secondarySort} = $self->{model}->{preferences}->secondarySort;
        $self->{groupedFirst} = $self->{model}->{preferences}->groupedFirst;
        $self->{addCount} = $self->{model}->{preferences}->addCount;
    }
    
    sub saveValues
    {
        my $self = shift;

        $self->{options}->expert(($self->{expert}->get_active) ? 1 : 0);

        $self->{options}->programs(($self->{systemPrograms}->get_active) ? 'system' : 'user');
        $self->{options}->browser($self->{browser});
        $self->{options}->player($self->{player});
        $self->{options}->audio($self->{audio});
        $self->{options}->imageEditor($self->{imageEditor});

        $self->{options}->cdDevice($self->{cdDevice}->getValue);
        $self->{options}->images($self->{images}->getValue);
        $self->{options}->confirm(($self->{confirm}->get_active) ? 1 : 0);
        $self->{options}->autosave(($self->{autosave}->get_active) ? 1 : 0);
        $self->{options}->noautoload(($self->{autoload}->get_active) ? 0 : 1);
        $self->{options}->splash(($self->{splash}->get_active) ? 1 : 0);
        $self->{options}->tearoffMenus(($self->{tearoffMenus}->get_active) ? 1 : 0);
        $self->{options}->spellCheck(($self->{spellCheck}->get_active) ? 1 : 0)
            if $self->{spellCheck};
        $self->{options}->useStars(($self->{useStars}->get_active) ? 1 : 0);
        $self->{options}->useRelativePaths(($self->{useRelativePaths}->get_active) ? 1 : 0);
        $self->{options}->useTitleForPics(($self->{picturesNameTitle}->get_active) ? 1 : 0);
        $self->{options}->transform(($self->{transform}->get_active) ? 1 : 0);
        $self->{options}->articles($self->{articles}->get_text);

        if ($self->{proxycb}->get_active)
        {
            $self->{options}->proxy($self->{proxyurl}->get_text);
        }
        else
        {
            $self->{options}->proxy('');
        }

        if ($self->{cookieJarcb}->get_active)
        {
            $self->{options}->cookieJar($self->{cookieJarPath}->getValue);
        }
        else
        {
            $self->{options}->cookieJar('');
        }

        $self->{options}->lang($self->{langOption}->getValue);
        $self->{options}->style($self->{styleOption}->getValue);
        $self->{model}->{preferences}->layout($self->{layoutOption}->getValue);
        $self->{options}->panelStyle($self->{panelStyleOption}->getValue);
        $self->{options}->toolbar($self->{toolbarOption}->getValue);
        $self->{options}->toolbarPosition($self->{toolbarPositionOption}->getValue);
        $self->{options}->expandersMode($self->{expandersMode}->getValue);
        $self->{options}->dateFormat($self->{dateFormat}->getValue)
            if $self->{dateFormat};
        my $currentView = $self->{options}->view;
        $self->{options}->view($self->{viewOption}->getValue);
        
        if (($currentView != $self->{options}->view)
         || ($self->{viewOptionsChanged}))
        {
            $self->{parent}->setItemsList(0, 1);
            $self->{viewChanged} = 1;
        }

        $self->{model}->{preferences}->plugin($self->{pluginOption}->getValue);
   
        $self->{options}->askImport(($self->{askImport}->get_active) ? 1 : 0);
        $self->{options}->searchStop(($self->{searchStop}->get_active) ? 1 : 0);
        $self->{options}->bigPics(($self->{bigPics}->get_active) ? 1 : 0);
        #$self->{options}->alwaysOriginal(($self->{alwaysOriginal}->get_active) ? 1 : 0);

        $self->{options}->mailer($self->{mailerOption}->getValue);
        $self->{options}->smtp($self->{smtp}->get_text);
        $self->{options}->from($self->{from}->get_text);

        $self->{parent}->checkImagesDirectory(1);
        $self->{options}->historysize($self->{historysize}->get_value);
        $self->{parent}->{menubar}->{menuHistoryItem}->remove_submenu();
        $self->{parent}->{menubar}->{menuHistory} = Gtk2::Menu->new();
        $self->{parent}->{menubar}->addHistoryMenu();
        
        #$self->{model}->{preferences}->details($self->{details});
        
        $self->{options}->save;
    }
    
    sub checkValues
    {
        my $self = shift;
        
        return $self->{parent}->{lang}->{OptionsPicturesWorkingDirError}
            if $self->{images}->getValue =~ /.%WORKING_DIR%/;
        return undef;
    }
    
    sub activateInternetOptions
    {
        my ($self, $value) = @_;
        
        $self->{dataGroupLabel}->set_sensitive($value);
        $self->{pluginLabel}->set_sensitive($value);
        $self->{pluginOption}->set_sensitive($value);
        $self->{pluginList}->set_sensitive($value);
        $self->{askImport}->set_sensitive($value);
        $self->{searchStop}->set_sensitive($value);
        $self->{bigPics}->set_sensitive($value);
    }
    
    sub show_all
    {
        my $self = shift;
        $self->SUPER::show_all;
        $self->{hboxImages}->hide;
        $self->{hboxDetails}->hide;
        $self->{hboxSMTP}->hide if $self->{mailerOption}->getValue ne 'SMTP';
        if ($self->{expert}->get_active)
        {
            $self->{hboxImages}->show_all if ($self->{options}->view == 1);
            $self->{hboxDetails}->show_all if ($self->{options}->view == 2);
        }
        else
        {
            # Toolbar and status bar
            $self->{labelToolbar}->hide_all;
            $self->{toolbarOption}->hide_all;
            $self->{labelToolbarPosition}->hide_all;
            $self->{toolbarPositionOption}->hide_all;
            $self->{labelExpandersMode}->hide_all;
            $self->{expandersMode}->hide_all;
            if ($self->{dateFormat})
            {
                $self->{labelDateFormat}->hide_all;
                $self->{dateFormat}->hide_all;
            }
            $self->{useStars}->hide_all;
            # CD Device
            $self->{cdDeviceLabel}->hide_all;
            $self->{cdDevice}->hide_all;
            # Pictures
            $self->{picturesNameFormat}->hide_all;
            $self->{picturesNameAuto}->hide_all;
            $self->{picturesNameTitle}->hide_all;
            $self->{useRelativePaths}->hide_all;
            # Internet searches
            $self->{searchStop}->hide_all;
            # Internet access
            $self->{proxycb}->hide_all;
            $self->{proxyurl}->hide_all;
            $self->{cookieJarcb}->hide_all;
            $self->{cookieJarPath}->hide_all;
            $self->{mailerLabel}->hide_all;
            $self->{mailerOption}->hide_all;
            $self->{hboxSMTP}->hide_all;
            $self->{hboxMua}->hide_all;
            # Features
            $self->{tearoffMenus}->hide_all;
            $self->{autoload}->hide_all;
            $self->{OptionsRestoreAccelerators}->hide_all;
            # History
            $self->{fileHistoryLabel}->hide_all;
            $self->{labelHistorysize}->hide_all;
            $self->{historysize}->hide_all;
            $self->{buttonClearHistory}->hide_all;
        }
        $self->{allShown} = 1;
        $self->{layoutOption}->signal_emit('changed');
    }

    sub show
    {
        my $self = shift;
        my $tabToShow= shift;

        $self->initValues;
        $self->show_all if !$self->{allShown};
        $self->{optionstabs}->set_current_page ($tabToShow) if $tabToShow;
        $self->activateInternetOptions(! $self->{model}->isPersonal);

        $self->{hboxSMTP}->hide if $self->{options}->mailer ne 'SMTP';
        $self->{pluginList}->hide
            if (($self->{model}->{preferences}->plugin ne 'multi')
             && ($self->{model}->{preferences}->plugin ne 'multiperfield')
             && ($self->{model}->{preferences}->plugin ne 'multiask'));

        while (1)
        {
            my $code = $self->run;
            last if $code ne 'ok';
            my $errorMessage = $self->checkValues;
            if (!$errorMessage)
            {
                $self->saveValues;
                last;
            }
            else
            {
                my  $dialog = Gtk2::MessageDialog->new_with_markup($self->{parent},
                        [qw/modal destroy-with-parent/],
                        'error',
                        'ok',
                        $errorMessage);
                $dialog->run;
                $dialog->destroy;
                next;
            }
        }
        $self->hide;
    }

    sub changeDetails
    {
        my $self = shift;
        my $parent = $self->{parent};
        my @tmpOptionsArray = split m/\|/, $self->{details};

        my $fieldsDialog = new GCDetailedOptionsDialog($self,
                                                       \@tmpOptionsArray);
        
        
        $fieldsDialog->show;
        $fieldsDialog->destroy;
    }

    sub setModel
    {
        my ($self, $model) = @_;

        $self->{model} = $model;
        my @plugins = map {{value => $_,
                           displayed => $_}}
                         @{$model->getPluginsNames};
        unshift @plugins, (
                            {value => 'ask', displayed => $self->{parent}->{lang}->{OptionsAskPlugins}},
                            {value => 'multiask', displayed => $self->{parent}->{lang}->{OptionsPluginsMultiAsk}},
                            {value => 'multi', displayed => $self->{parent}->{lang}->{OptionsPluginsMulti}},
                            {value => 'multiperfield', displayed => $self->{parent}->{lang}->{OptionsPluginsMultiPerField}},
                          );
        $self->{pluginOption}->setValues(\@plugins);

        my @panels = map {{value => $_,
                           displayed => $model->getDisplayedText($model->{panels}->{$_}->{label})}}
                         @{$model->{panelsNames}};
        $self->{layoutOption}->setValues(\@panels);
    }

    sub initMailerOption
    {
        my $self = shift;
        use locale;
        my @mailers = ({value => 'Sendmail', displayed => 'Sendmail'},
                       {value => 'SMTP', displayed => 'SMTP'});
        my $mailPrograms = GCMail::getMailers;
        foreach (sort keys %{$mailPrograms})
        {
            push @mailers, {value => $_, displayed => $_};
        }
        $self->{mailerOption}->setValues(\@mailers, 2);
    }

    sub new
    {
        my ($proto, $parent, $options) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent,
                                       $parent->{lang}->{OptionsTitle},
                                      );
        bless ($self, $class);

        $self->{allShown} = 0;
        $self->set_has_separator(0);

        $options = $parent->{options} if !$options;
        $self->{options} = $options;
        
        $self->{parent} = $parent;

        $self->{lang} = $parent->{lang};
        $self->{tooltips} = $parent->{tooltips};

        ################
        # Main options
        ################
        my $tableMain = new Gtk2::Table(3,2,0);
        $tableMain->set_row_spacings($GCUtils::halfMargin);
        $tableMain->set_col_spacings($GCUtils::margin);
        $tableMain->set_border_width($GCUtils::margin);
        
        my $labelLang = new GCLabel($parent->{lang}->{OptionsLang});
        $self->{langOption} = new GCMenuList;
        my @langValues;
        push @langValues, {value => $_, displayed => $GCLang::langs{$_}->{LangName}}
            foreach (keys %GCLang::langs);
        @langValues = sort {$a->{displayed} cmp $b->{displayed}} @langValues;
        $self->{langOption}->setValues(\@langValues);

        $tableMain->attach($labelLang, 0, 1, 1, 2, 'fill', 'fill', 0, 0);
        $tableMain->attach($self->{langOption}, 1, 2, 1, 2, 'fill', 'fill', 0, 0);

        my $labelStyle = new GCLabel($parent->{lang}->{OptionsStyle});
        $self->{styleOption} = new GCMenuList;
        my @styleValues;
        push @styleValues, {value => $_, displayed => $_} foreach (sort keys %GCStyle::styles);
        $self->{styleOption}->setValues(\@styleValues);
        $tableMain->attach($labelStyle, 0, 1, 2, 3, 'fill', 'fill', 0, 0);
        $tableMain->attach($self->{styleOption}, 1, 2, 2, 3, 'fill', 'fill', 0, 0);
	
        $self->{tearoffMenus} = new Gtk2::CheckButton($parent->{lang}->{OptionsTearoffMenus});
        $self->{tearoffMenus}->set_active($options->tearoffMenus);
        $self->{tearoffMenus}->set_active(1) if (! $options->exists('tearoffMenus'));
        $tableMain->attach($self->{tearoffMenus}, 0, 2, 3, 4, 'fill', 'fill', 0, 0);

        my $labelWarning = new Gtk2::Label;
        $labelWarning->set_markup('<b>'.$parent->{lang}->{OptionsWarning}.'</b>');
        $labelWarning->set_use_underline(1);
        $labelWarning->set_line_wrap(1);
        $labelWarning->set_justify('center');
        
        my $vboxMain = new Gtk2::VBox(0,0);
        $vboxMain->set_border_width(20);
        $vboxMain->pack_start($tableMain,1,1,0);
        #$vboxMain->pack_start(Gtk2::HSeparator->new,1,1,10);
        $vboxMain->pack_start($labelWarning,1,1,0);

        ##################
        # Display options
        ##################
        my $tableDisplay = new Gtk2::Table(10, 6, 0);
        $tableDisplay->set_row_spacings($GCUtils::halfMargin);
        $tableDisplay->set_col_spacings($GCUtils::margin);
        $tableDisplay->set_border_width($GCUtils::margin);
        
        my $labelDisplayInformationGroup = new GCHeaderLabel($parent->{lang}->{OptionsDisplayInformationGroup});
        $tableDisplay->attach($labelDisplayInformationGroup, 0, 6, 0, 1, 'fill', 'fill', 0, 0);

        my $labelView = new GCLabel($parent->{lang}->{OptionsView});
        my %views = %{$parent->{lang}->{OptionsViews}};
        $self->{viewOption} = new GCMenuList;
        my @viewsOptions = map {{value => $_, displayed => $views{$_}}}
                              (sort keys %views);
        $self->{viewOption}->setValues(\@viewsOptions);



        $tableDisplay->attach($labelView, 2, 3, 1, 2, 'fill', 'fill', 0, 0);
        $tableDisplay->attach($self->{viewOption}, 3, 4, 1, 2, 'fill', 'fill', 0, 0);

        $self->{hboxImages} = new Gtk2::HBox(0,0);
        $self->{imagesButton} = new Gtk2::Button($parent->{lang}->{ImagesOptionsButton});
        $self->{imagesButton}->signal_connect('clicked', sub {
            $self->{imagesOptionsDialog} = new GCImagesOptionsDialog($self)
                if ! $self->{imagesOptionsDialog};
            $self->{imagesOptionsDialog}->show;
        });
        $self->{hboxImages}->pack_start($self->{imagesButton}, 0, 0, 0);

        $self->{hboxDetails} = new Gtk2::HBox(0,0);
        $self->{buttonDetails} = new Gtk2::Button($parent->{lang}->{ImagesOptionsButton});
        $self->{buttonDetails}->signal_connect('clicked' => sub {
            $self->changeDetails;
        });
        $self->{hboxDetails}->pack_start($self->{buttonDetails}, 0, 0, 0);

        $self->{viewOption}->signal_connect('changed' => sub {
                my $i = $self->{viewOption}->getValue;
                $self->{hboxImages}->hide;
                $self->{hboxDetails}->hide;
                if ($self->{expert}->get_active)
                {
                    $self->{hboxImages}->show_all if ($i == 1);
                    $self->{hboxDetails}->show_all if ($i == 2);
                }
        });
        $tableDisplay->attach($self->{hboxImages}, 4, 6, 1, 2, 'fill', 'fill', 0, 0);
        $tableDisplay->attach($self->{hboxDetails}, 4, 6, 1, 2, 'fill', 'fill', 0, 0);

        my $labelLayout = new GCLabel($parent->{lang}->{OptionsLayout});
        $self->{layoutOption} = new GCMenuList;
        $self->{layoutOption}->signal_connect('changed' => sub {
                my $panelName = $self->{layoutOption}->getValue;
                my $readonly = ($self->{model}->{panels}->{$panelName}->{editable} eq 'false');
                if ($readonly)
                {
                    $self->{labelPanelStyle}->show;
                    $self->{panelStyleOption}->show;
                }
                else
                {
                    $self->{labelPanelStyle}->hide;
                    $self->{panelStyleOption}->hide;
                }
        });
        $tableDisplay->attach($labelLayout, 2, 3, 2, 3, 'fill', 'fill', 0, 0);
        $tableDisplay->attach($self->{layoutOption}, 3, 4, 2, 3, 'fill', 'fill', 0, 0);

        $self->{labelPanelStyle} = new GCLabel($parent->{lang}->{OptionsStyle});
        $self->{panelStyleOption} = new GCMenuList;
        my @panelStyles = map {{value => $_, displayed => $_}}
                              (sort @GCStyle::readOnlyStyles);
        $self->{panelStyleOption}->setValues(\@panelStyles);

        $tableDisplay->attach($self->{labelPanelStyle}, 4, 5, 2, 3, 'fill', 'fill', 0, 0);
        $tableDisplay->attach($self->{panelStyleOption}, 5, 6, 2, 3, ['fill', 'expand'], 'fill', 0, 0);

        $self->{labelToolbar} = new GCLabel($parent->{lang}->{OptionsToolbar});
        $self->{toolbarOption} = new GCMenuList;
        my %toolbars = %{$parent->{lang}->{OptionsToolbars}};
        my @toolbarValues = map {{value => $_, displayed => $toolbars{$_}}}
                                (sort keys %toolbars);
        $self->{toolbarOption}->setValues(\@toolbarValues);

        $tableDisplay->attach($self->{labelToolbar}, 2, 3, 3, 4, 'fill', 'fill', 0, 0);
        $tableDisplay->attach($self->{toolbarOption}, 3, 4, 3, 4, 'fill', 'fill', 0, 0);

        $self->{labelToolbarPosition} = new GCLabel($parent->{lang}->{OptionsToolbarPosition});
        $self->{toolbarPositionOption} = new GCMenuList;
        my %toolbarPositions = %{$parent->{lang}->{OptionsToolbarPositions}};
        my @positionValues = map {{value => $_, displayed => $toolbarPositions{$_}}}
                                 (sort keys %toolbarPositions);
        $self->{toolbarPositionOption}->setValues(\@positionValues);

        $tableDisplay->attach($self->{labelToolbarPosition}, 4, 5, 3, 4, 'fill', 'fill', 0, 0);
        $tableDisplay->attach($self->{toolbarPositionOption}, 5, 6, 3, 4, ['fill', 'expand'], 'fill', 0, 0);

        $self->{labelExpandersMode} = new GCLabel($parent->{lang}->{OptionsExpandersMode});
        $self->{expandersMode} = new GCMenuList;
        my %expandersModes = %{$parent->{lang}->{OptionsExpandersModes}};
        my @ExpandersModeValues = map {{value => $_, displayed => $expandersModes{$_}}}
                                (sort keys %expandersModes);
        $self->{expandersMode}->setValues(\@ExpandersModeValues);

        $tableDisplay->attach($self->{labelExpandersMode}, 2, 3, 4, 5, 'fill', 'fill', 0, 0);
        $tableDisplay->attach($self->{expandersMode}, 3, 4, 4, 5, 'fill', 'fill', 0, 0);

        $self->{useStars} = new Gtk2::CheckButton($parent->{lang}->{OptionsUseStars});
        $tableDisplay->attach($self->{useStars}, 4, 6, 4, 5, ['expand', 'fill'], 'fill', 0, 0);

        if ($GCUtils::hasTimeConversion)
        {
            $self->{labelDateFormat} = new GCLabel($parent->{lang}->{OptionsDateFormat});
            $self->{dateFormat} = new GCShortText;
            $self->{dateFormat}->set_width_chars(10);
            $self->{tooltips}->set_tip($self->{dateFormat},
                                       $parent->{lang}->{OptionsDateFormatTooltip});
            $tableDisplay->attach($self->{labelDateFormat}, 2, 3, 5, 6, 'fill', 'fill', 0, 0);
            $tableDisplay->attach($self->{dateFormat}, 3, 6, 5, 6, 'fill', 'fill', 0, 0);
        }

        my $labelDisplayArticlesGroup = new GCHeaderLabel($parent->{lang}->{OptionsDisplayArticlesGroup});
        $tableDisplay->attach($labelDisplayArticlesGroup, 0, 6, 7, 8, 'fill', 'fill', 0, 0);

        $self->{transform} = new Gtk2::CheckButton($parent->{lang}->{OptionsTransform});
        $tableDisplay->attach($self->{transform}, 2, 6, 8, 9, 'fill', 'fill', 0, 0);
        my $labelArticles = new GCLabel($parent->{lang}->{OptionsArticles});
        $tableDisplay->attach($labelArticles, 2, 4, 9, 10, 'fill', 'fill', 0, 0); 
		$self->{articles} = new Gtk2::Entry;
		$self->{articles}->set_width_chars(10);
        $tableDisplay->attach($self->{articles}, 4, 6, 9, 10, ['expand', 'fill'], 'fill', 0, 0);
        $options->articles('le,la,les,l,un,une,des,a,the') if (! $options->exists('articles'));

        my $vboxDisplay = new Gtk2::VBox(0,0);
        $vboxDisplay->set_border_width(0);
        $vboxDisplay->pack_start($tableDisplay, 0, 0, 0);

        #################
        # Paths options
        #################
        my $vboxPath = new Gtk2::VBox(0,0);

        my $tablePath = new Gtk2::Table(14, 4, 0);
        my $pathRow = -1;
        $tablePath->set_row_spacings($GCUtils::halfMargin);
        $tablePath->set_col_spacings($GCUtils::margin);
        $tablePath->set_border_width($GCUtils::margin);

        my $labelProgramsGroup = new GCHeaderLabel($parent->{lang}->{OptionsPathProgramsGroup});
        $pathRow++;
        $tablePath->attach($labelProgramsGroup, 0, 4, $pathRow, $pathRow + 1, 'fill', 'fill', 0, 0);
        
        $self->{systemPrograms} = new Gtk2::RadioButton(undef, $parent->{lang}->{OptionsProgramsSystem});
        $pathRow++;
        $tablePath->attach($self->{systemPrograms}, 2, 4, $pathRow, $pathRow + 1, 'fill', 'fill', 0, 0);
        $self->{programTypeGroup} = $self->{systemPrograms}->get_group;
        $self->{userPrograms} = new Gtk2::RadioButton($self->{programTypeGroup}, $parent->{lang}->{OptionsProgramsUser});
        $self->{defineProgramsButton} = new GCButton($parent->{lang}->{OptionsProgramsSet});
        $self->{defineProgramsButton}->signal_connect('clicked' => sub {
            $self->{programsDialog} = new GCProgramsOptionsDialog($self)
                if ! $self->{programsDialog};
            $self->{programsDialog}->show;
        });
        my $hboxDefinePrograms = new Gtk2::HBox(0,0);
        $hboxDefinePrograms->pack_start($self->{userPrograms}, 0, 0, 0);
        $hboxDefinePrograms->pack_start($self->{defineProgramsButton}, 0, 0, 2*$GCUtils::margin);
        $pathRow++;
        $tablePath->attach($hboxDefinePrograms, 2, 4, $pathRow, $pathRow + 1, 'fill', [], 0, 0);
        $self->{userPrograms}->signal_connect('toggled' => sub {
            $self->{defineProgramsButton}->lock(! $self->{userPrograms}->get_active);
        });

        $self->{cdDeviceLabel} = new GCLabel($parent->{lang}->{OptionsCdDevice});
        $self->{cdDevice} = new GCFile($self,
                                       $self->{parent}->{lang}->{FileChooserOpenDirectory},
                                       'select-folder');
        $pathRow++;
        $tablePath->attach($self->{cdDeviceLabel}, 2, 3, $pathRow, $pathRow + 1, 'fill', 'fill', 0, 0);
        $tablePath->attach($self->{cdDevice}, 3, 4, $pathRow, $pathRow + 1, 'fill', 'fill', 0, 0);

        $self->{labelImagesGroup} = new GCHeaderLabel($parent->{lang}->{OptionsPathImagesGroup});
        $pathRow += 2;
        $tablePath->attach($self->{labelImagesGroup}, 0, 4, $pathRow, $pathRow + 1, 'fill', 'fill', 0, 0);
        $self->{labelImages} = new GCLabel($parent->{lang}->{OptionsImages});
        $pathRow++;
        $tablePath->attach($self->{labelImages}, 2, 3, $pathRow, $pathRow + 1, 'fill', 'fill', 0, 0);
        $self->{images} = new GCFile($self,
                                     $self->{parent}->{lang}->{FileChooserOpenDirectory},
                                     'select-folder',
                                     0,
                                     $GCOptions::DEFAULT_IMG_DIR);
        $self->{images}->setWidth(40);
        $tablePath->attach($self->{images}, 3, 4, $pathRow, $pathRow + 1, ['expand', 'fill'], 'fill', 0, 0);
	
        $self->{labelPicturesWorkingDir} = new GCLabel($parent->{lang}->{OptionsPicturesWorkingDir});
        $pathRow++;
        $tablePath->attach($self->{labelPicturesWorkingDir}, 2, 4, $pathRow, $pathRow + 1, 'fill', 'fill', 2*$GCUtils::margin, 0);
        $self->{labelPicturesFileBase} = new GCLabel($parent->{lang}->{OptionsPicturesFileBase});
        $pathRow++;
        $tablePath->attach($self->{labelPicturesFileBase}, 2, 4, $pathRow, $pathRow + 1, 'fill', 'fill', 2*$GCUtils::margin, 0);

        $self->{picturesNameFormat} = new GCLabel($parent->{lang}->{OptionsPicturesFormat});
        $pathRow += 2;
        $tablePath->attach($self->{picturesNameFormat}, 2, 4, $pathRow, $pathRow + 1, 'fill', 'fill', 0, 0);
        $self->{picturesNameAuto} = new Gtk2::RadioButton(undef, $parent->{lang}->{OptionsPicturesFormatInternal});
        $pathRow++;
        $tablePath->attach($self->{picturesNameAuto}, 2, 4, $pathRow, $pathRow + 1, 'fill', 'fill', 2*$GCUtils::margin, 0);
        $self->{picturesNameGroup} = $self->{picturesNameAuto}->get_group;
        $self->{picturesNameTitle} = new Gtk2::RadioButton($self->{picturesNameGroup}, $parent->{lang}->{OptionsPicturesFormatTitle});
        $pathRow++;
        $tablePath->attach($self->{picturesNameTitle}, 2, 4, $pathRow, $pathRow + 1, 'fill', 'fill', 2*$GCUtils::margin, 0);

        $self->{useRelativePaths} = new Gtk2::CheckButton($parent->{lang}->{OptionsUseRelativePaths});
        $self->{useRelativePaths}->set_active($options->useRelativePaths);
        $self->{useRelativePaths}->set_active(0) if (! $options->exists('useRelativePaths'));
        $pathRow++;
        $tablePath->attach($self->{useRelativePaths}, 2, 4, $pathRow, $pathRow + 1, 'fill', 'fill', 0, 0);

        $vboxPath->pack_start($tablePath, 0, 0, 0);

        ###################
        # Internet options
        ###################
        my $tableInternet = new Gtk2::Table(12, 5, 0);
        $tableInternet->set_row_spacings($GCUtils::halfMargin);
        $tableInternet->set_col_spacings($GCUtils::margin);
        $tableInternet->set_border_width($GCUtils::margin);
	
        $self->{dataGroupLabel} = new GCHeaderLabel($parent->{lang}->{OptionsInternetDataGroup});
        $tableInternet->attach($self->{dataGroupLabel}, 0, 5, 0, 1, 'fill', 'fill', 0, 0); 
	    
        $self->{pluginLabel} = new GCLabel($parent->{lang}->{OptionsPlugins});
        $self->{pluginOption} = new GCMenuList;
        $self->{pluginList} = new Gtk2::Button($parent->{lang}->{OptionsPluginsList});
        $self->{pluginList}->signal_connect('clicked' => sub {
            $parent->getDialog('MultiSite')->show if (($self->{pluginOption}->getValue eq 'multi') 
             || ($self->{pluginOption}->getValue eq 'multiask'));
            $parent->getDialog('MultiSitePerField')->show if (($self->{pluginOption}->getValue eq 'multiperfield'));
        });
        $self->{pluginOption}->signal_connect('changed' => sub {
            if (($self->{pluginOption}->getValue eq 'multi') 
             || ($self->{pluginOption}->getValue eq 'multiask') 
             || ($self->{pluginOption}->getValue eq 'multiperfield'))
            {
                $self->{pluginList}->show;
            }
            else
            {
                $self->{pluginList}->hide;
            }
        });		
        $self->{askImport} = new Gtk2::CheckButton($parent->{lang}->{OptionsAskImport});
        $tableInternet->attach($self->{pluginLabel}, 2, 3, 1, 2, 'fill', 'fill', 0, 0); 
        $tableInternet->attach($self->{pluginOption}, 3, 4, 1, 2, 'fill', 'fill', 0, 0); 
        $tableInternet->attach($self->{pluginList}, 4, 5, 1, 2, 'fill', 'fill', 20, 0);
        $tableInternet->attach($self->{askImport}, 2, 5, 2, 3, 'fill', 'fill', 0, 0); 
        $self->{bigPics} = new Gtk2::CheckButton($parent->{lang}->{OptionsBigPics});
        $tableInternet->attach($self->{bigPics}, 2, 5, 3, 4, 'fill', 'fill', 0, 0);
        $self->{searchStop} = new Gtk2::CheckButton($parent->{lang}->{OptionsSearchStop});
        $tableInternet->attach($self->{searchStop}, 2, 5, 4, 5, 'fill', 'fill', 0, 0) if ($^O !~ /win32/i);

        my $settingsGroupLabel = new GCHeaderLabel($parent->{lang}->{OptionsInternetSettingsGroup});
        $tableInternet->attach($settingsGroupLabel, 0, 5, 6, 7, 'fill', 'fill', 0, 0); 
	
        $self->{proxycb} = new Gtk2::CheckButton($parent->{lang}->{OptionsProxy});
        $self->{proxycb}->set_active($options->proxy);
        $self->{proxyurl} = new Gtk2::Entry;
        $self->{proxyurl}->set_text($options->proxy);
        $self->{proxycb}->signal_connect('clicked' => sub {
            if ($self->{proxycb}->get_active)
            {
                $self->{proxyurl}->set_editable(1);
            }
            else
            {
                $self->{proxyurl}->set_editable(0);
            }
        });
        $tableInternet->attach($self->{proxycb}, 2, 3, 7, 8, 'fill', 'fill', 0, 0);
        $tableInternet->attach($self->{proxyurl}, 3, 4, 7, 8, 'fill', 'shrink', 0, 0);
        
        $self->{cookieJarcb} = new Gtk2::CheckButton($parent->{lang}->{OptionsCookieJar});
        $self->{cookieJarcb}->set_active($options->cookieJar);
        $self->{cookieJarcb}->signal_connect('clicked' => sub {
            if ($self->{cookieJarcb}->get_active)
            {
                $self->{cookieJarPath}->lock(0);
            }
            else
            {
                $self->{cookieJarPath}->lock(1);
            }
        });
        $tableInternet->attach($self->{cookieJarcb}, 2, 3, 8, 9, 'fill', 'fill', 0, 0);
        $self->{cookieJarPath} = new GCFile($self,
                                     $self->{parent}->{lang}->{OptionsCookieJar},
                                     'open',
                                     0 );
        $tableInternet->attach($self->{cookieJarPath}, 3, 4, 8, 9, 'fill', 'fill', 0, 0);

        my $labelFrom = new GCLabel($self->{parent}->{lang}->{OptionsFrom});
        $self->{from} = new Gtk2::Entry;
        $tableInternet->attach($labelFrom, 2, 3, 9, 10, 'fill', 'fill', 0, 0);
        $tableInternet->attach($self->{from}, 3, 4, 9, 10, 'fill', 'fill', 0, 0);

        $self->{mailerLabel} = new GCLabel($parent->{lang}->{OptionsMailer});
        $self->{mailerOption} = new GCMenuList;
        $self->initMailerOption;
        $tableInternet->attach($self->{mailerLabel}, 2, 3, 10, 11, 'fill', 'fill', 0, 0);
        $tableInternet->attach($self->{mailerOption}, 3, 4, 10, 11, 'fill', 'fill', 0, 0);
        
        $self->{hboxSMTP} = new Gtk2::HBox(0,0);
        my $SMTPLabel = new GCLabel($parent->{lang}->{OptionsSMTP});
        $self->{smtp} = new Gtk2::Entry;
        $self->{smtp}->set_text($options->smtp);
        $self->{smtp}->set_width_chars(20);
        $self->{hboxSMTP}->pack_start($SMTPLabel,0,0,0);
        $self->{hboxSMTP}->pack_start($self->{smtp},0,0,5);
        $tableInternet->attach($self->{hboxSMTP}, 4, 5, 10, 11, 'fill', 'fill', 0, 0);

        $self->{mailerOption}->signal_connect('changed' => sub {
            if ('SMTP' eq $self->{mailerOption}->getValue)
            {
                $self->{hboxSMTP}->show;
            }
            else
            {
                $self->{hboxSMTP}->hide;
            }
        });
        
        my $mailersButton = new GCButton($parent->{lang}->{OptionsConfigureMailers});
        $self->{hboxMua} = new Gtk2::HBox(0,0);
        $self->{hboxMua}->pack_start($mailersButton,0,0,0);
        $tableInternet->attach($self->{hboxMua}, 2, 4, 11, 12, 'fill', 'fill', 0, 0);
        $mailersButton->signal_connect('clicked' => sub {
            my $dialog = $self->{parent}->getDialog('MailPrograms');
            $self->initMailerOption if $dialog->show;
        });

        my $vboxInternet = new Gtk2::VBox(0,0);
        $vboxInternet->set_border_width(0);
        $vboxInternet->pack_start($tableInternet,0,0,0);

        ###################
        # Features options
        ###################
        my $vboxConvenience = new Gtk2::VBox(0,0);
        my $tableFeature = new Gtk2::Table(11, 5, 0);
        $tableFeature->set_row_spacings($GCUtils::halfMargin);
        $tableFeature->set_col_spacings($GCUtils::margin);
        $tableFeature->set_border_width($GCUtils::margin);

        $self->{confirm} = new Gtk2::CheckButton($parent->{lang}->{OptionsRemoveConfirm});
        $self->{confirm}->set_active($options->confirm);
        $self->{autosave} = new Gtk2::CheckButton($parent->{lang}->{OptionsAutoSave});
        $self->{autosave}->set_active($options->autosave);
        $self->{autoload} = new Gtk2::CheckButton($parent->{lang}->{OptionsAutoLoad});
        $self->{autoload}->set_active(! $options->noautoload);
        $self->{splash} = new Gtk2::CheckButton($parent->{lang}->{OptionsSplash});
        $self->{splash}->set_active($options->splash);
        $self->{splash}->set_active(1) if (! $options->exists('splash'));
        $self->{spellCheck} = 0;
        my $restoreAccelOffset = 0;
        if ($GCBaseWidgets::hasSpellChecker)
        {
            $self->{spellCheck} = new Gtk2::CheckButton($parent->{lang}->{OptionsSpellCheck});
            $self->{spellCheck}->set_active($options->spellCheck);
            $restoreAccelOffset = 1;
        }
        $self->{OptionsRestoreAccelerators} = new Gtk2::Button($parent->{lang}->{OptionsRestoreAccelerators});
        $self->{OptionsRestoreAccelerators}->signal_connect('clicked' => sub {
            $self->{parent}->{menubar}->restoreDefaultAccels;
        });


        my $conveniencesLabel = new GCHeaderLabel($parent->{lang}->{OptionsFeaturesConveniencesGroup});
        $tableFeature->attach($conveniencesLabel, 0, 4, 0, 1, 'fill', 'fill', 0, 0);
        $tableFeature->attach($self->{splash}, 2, 4, 1, 2, 'fill', 'fill', 0, 0);
        $tableFeature->attach($self->{confirm}, 2, 4, 2, 3, 'fill', 'fill', 0, 0);
        $tableFeature->attach($self->{autosave}, 2, 4, 3, 4, 'fill', 'fill', 0, 0);
        $tableFeature->attach($self->{autoload}, 2, 4, 4, 5, 'fill', 'fill', 0, 0);
        $tableFeature->attach($self->{spellCheck}, 2, 4, 5, 6, 'fill', 'fill', 0, 0)
            if $self->{spellCheck};
        $tableFeature->attach($self->{OptionsRestoreAccelerators}, 2, 3,
                              5 + $restoreAccelOffset, 6 + $restoreAccelOffset,
                             'fill', 'fill', 0, 0);

        my $fileHistoryLabelText = $parent->{lang}->{MenuHistory};
        $fileHistoryLabelText =~ s/_//g;
        $self->{fileHistoryLabel} = new GCHeaderLabel($fileHistoryLabelText);
        $tableFeature->attach($self->{fileHistoryLabel}, 0, 4, 9, 10, 'fill', 'fill', 0, 0);        

        $self->{labelHistorysize} = new GCLabel($parent->{lang}->{OptionsHistory});
        my $adjHistory = Gtk2::Adjustment->new(0, 1, 20, 1, 1, 0) ;
        $self->{historysize} = Gtk2::SpinButton->new($adjHistory, 0, 0);
        $self->{buttonClearHistory} = new Gtk2::Button($parent->{lang}->{OptionsClearHistory});
        $self->{buttonClearHistory}->signal_connect('clicked' => sub {
            $self->{options}->history('');
        });
        $tableFeature->attach($self->{labelHistorysize}, 2, 3, 10, 11, 'fill', 'fill', 0, 0);
        $tableFeature->attach($self->{historysize}, 3, 4, 10, 11, 'fill', 'fill', 0, 0);
        $tableFeature->attach($self->{buttonClearHistory}, 2, 3, 11, 12, 'fill', 'fill', 0, 0);

        $vboxConvenience->pack_start($tableFeature,0,0,0);

        ###################
        # Tab Gesture Stuff
        ###################

        my $tabs = Gtk2::Notebook->new();
        $tabs->set_name('GCOptionsTabs');
        $tabs->set_tab_pos('left');
        $tabs->set_show_border(0);

        my ($mainButton, $displayButton, $pathButton, $internetButton, $conveniencesButton);

        $mainButton = GCImageBox->new_from_stock('gtk-home',
                                                  $parent->{lang}->{OptionsMain});
        $displayButton = GCImageBox->new_from_stock('gtk-select-color',
                                                     $parent->{lang}->{OptionsDisplay});
        $pathButton = GCImageBox->new_from_stock('gtk-directory',
                                                  $parent->{lang}->{OptionsPaths});
        $internetButton = GCImageBox->new_from_stock('gtk-network',
                                                      $parent->{lang}->{OptionsInternet});
        $conveniencesButton = GCImageBox->new_from_stock('gtk-properties',
                                                          $parent->{lang}->{OptionsConveniences});
        
        $tabs->append_page_menu($vboxMain, $mainButton, Gtk2::Label->new($parent->{lang}->{OptionsMain}));
        $tabs->append_page_menu($vboxDisplay, $displayButton, Gtk2::Label->new($parent->{lang}->{OptionsDisplay}));
        $tabs->append_page_menu($vboxPath, $pathButton, Gtk2::Label->new($parent->{lang}->{OptionsPaths}));
        $tabs->append_page_menu($vboxInternet, $internetButton, Gtk2::Label->new($parent->{lang}->{OptionsInternet}));
        $tabs->append_page_menu($vboxConvenience, $conveniencesButton, Gtk2::Label->new($parent->{lang}->{OptionsConveniences}));

        $tabs->set_tab_label_packing ($vboxMain, 1, 0, 'start');
        $tabs->set_tab_label_packing ($vboxDisplay, 1, 0, 'start');
        $tabs->set_tab_label_packing ($vboxPath, 1, 0, 'start');
        $tabs->set_tab_label_packing ($vboxInternet, 1, 0, 'start');
        $tabs->set_tab_label_packing ($vboxConvenience, 1, 0, 'start');

        $self->vbox->pack_start($tabs, 1, 1, 0);
        $self->{optionstabs}=$tabs;
        $self->{expert} = new Gtk2::CheckButton($parent->{lang}->{OptionsExpertMode});
        $self->{expert}->signal_connect('toggled' => sub {
            $self->show_all;
        });
        $self->{expert}->set_border_width($GCUtils::margin);
        $self->vbox->pack_start($self->{expert}, 0, 1, 0);

        $self->{lang} = $parent->{lang};

        return $self;
    }

}

{
    # Class used to let user select images options
    package GCImagesOptionsDialog;
    use base "GCModalDialog";
    use GCItemsLists::GCListOptions;

    sub show
    {
        my $self = shift;

        $self->{panel}->initValues;
        
        $self->show_all;
        my $code = $self->run;
        if ($code eq 'ok')
        {
            $self->{panel}->saveValues;
            $self->{parent}->{viewOptionsChanged} = 1;
        }
        $self->hide;
    }
    
    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        
        my $self  = $class->SUPER::new($parent,
                                       $parent->{lang}->{ImagesOptionsTitle},
                                      );

        $self->{panel} = new GCImagesOptionsPanel($parent->{model}->{preferences}, $parent->{parent});
        $self->{parent} = $parent;

        $self->vbox->pack_start($self->{panel},1,1,0);

        bless ($self, $class);
        return $self;
    }
}

{
    # Class used to let user select detailed options
    package GCDetailedOptionsDialog;
    use base "GCModalDialog";
    use GCItemsLists::GCListOptions;

    sub show
    {
        my $self = shift;

        $self->{panel}->initValues;
        
        $self->show_all;
        my $code = $self->run;
        if ($code eq 'ok')
        {
            $self->{panel}->saveValues;
            $self->{parent}->{viewOptionsChanged} = 1;
        }
        $self->hide;
    }
    
    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        
        my $self  = $class->SUPER::new($parent,
                                       $parent->{lang}->{DetailedOptionsTitle},
                                      );

        $self->{panel} = new GCDetailedOptionsPanel($parent->{model}->{preferences}, $parent->{parent});
        $self->{parent} = $parent;

        $self->vbox->pack_start($self->{panel},1,1,0);

        bless ($self, $class);
        return $self;
    }
}


{
    # Class used to let user select program to run
    package GCProgramsOptionsDialog;
    use base "GCModalDialog";
    
    sub initValues
    {
        my $self = shift;
        
        foreach (@{$self->{programs}})
        {
            $self->{paths}->{$_}->setValue($self->{parent}->{$_});
        }
    }
    
    sub saveValues
    {
        my $self = shift;
        
        foreach (@{$self->{programs}})
        {
            $self->{parent}->{$_} = $self->{paths}->{$_}->getValue;
        }
    }
    
    sub show
    {
        my $self = shift;

        $self->initValues;
        
        $self->show_all;
        my $code = $self->run;
        if ($code eq 'ok')
        {
            $self->saveValues;
        }
        $self->hide;
    }
    
    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;

        my $self  = $class->SUPER::new($parent,
                                       $parent->{lang}->{OptionsProgramsSet},
                                      );

        $self->{programs} = ['browser', 'player', 'audio', 'imageEditor'];

        my $tablePath = new Gtk2::Table(scalar @{$self->{programs}} + 1, 4);
        $tablePath->set_row_spacings($GCUtils::halfMargin);
        $tablePath->set_col_spacings($GCUtils::margin);
        $tablePath->set_border_width($GCUtils::margin);

        $self->{labelPrograms} = new GCHeaderLabel($parent->{lang}->{OptionsPrograms});
        $tablePath->attach($self->{labelPrograms}, 0, 4, 0, 1, 'fill', 'fill', 0, $GCUtils::halfMargin);

        my $line = 1;
        foreach my $program(@{$self->{programs}})
        {
            my $label = new GCLabel($parent->{lang}->{'Options'.ucfirst($program)});
            $tablePath->attach($label, 2, 3, $line, $line + 1, 'fill', 'fill', 0, 0);
            $self->{paths}->{$program} = new GCFile($parent, $parent->{lang}->{OptionsProgramTitle});
            $self->{paths}->{$program}->setWidth(40);
            $tablePath->attach($self->{paths}->{$program}, 3, 4, $line, $line + 1, ['expand', 'fill'], 'fill', 0, 0);
            $line++;
        }

        $tablePath->show_all;

        $self->vbox->pack_start($tablePath,1,1,0);

        bless ($self, $class);
        return $self;
    }
}

{
    # Class used to let user select information to be displayed
    package GCDisplayOptionsDialog;
    use base "Gtk2::Dialog";
    
    sub show
    {
        my $self = shift;

        $self->initValues;
        
        $self->show_all;
        my $code = $self->run;
        if ($code eq 'ok')
        {
            $self->saveValues;
        }
        $self->hide;
    }
    
    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        
        my $self  = $class->SUPER::new($parent->{lang}->{DisplayOptionsTitle},
                              $parent,
                              [qw/modal destroy-with-parent/],
                              @GCDialogs::okCancelButtons
                            );

        bless($self, $class);

        $self->{show} = {};
        $self->{options} = $parent->{model}->{preferences};
        $self->{parent} = $parent;

        $self->{lang} = $parent->{lang};
        $self->set_default_size(-1,480);
        return $self;
    }
    
    sub createContent
    {
        my ($self, $model) = @_;

        $self->{options} = $model->{preferences};
        if ($self->{tabs})
        {
            $self->vbox->remove($self->{hboxActions});
            $self->{hboxActions}->destroy;
            $self->vbox->remove($self->{tabs});
            $self->{tabs}->destroy;
        }

        $self->{fieldsInfo} = $model->getDisplayedInfo;
        $self->{fields} = $model->getFieldsCopy;
        
        #Add special items
        if (! $model->isPersonal)
        {
            unshift @{$self->{fields}}, 'searchButton';
            unshift @{$self->{fieldsInfo}->[0]->{items}},
                    {id => 'searchButton',
                     label => $model->getDisplayedText('PanelSearchButton')};
        }
        $self->createComponents;
        $self->initValues;
    }
    
    sub initValues
    {
        my $self = shift;
        $self->{show} = {};

        foreach (@{$self->{fields}})
        {
            my $isShown = 1;
            $isShown = 0 if ($self->{options}->hidden =~ m/\|$_\|/);
            $self->{show}->{$_} = $isShown;
            # Only set active if field exists. Works around problems caused trying
            # to open corrupted collections
            $self->{$_}->set_active($isShown)
                if exists $self->{$_};
        }
    }
    
    sub saveValues
    {
        my $self = shift;
        $self->{show} = {};
        
        my $hidden = '|';
        foreach (@{$self->{fields}})
        {
            my $isShown = 0;
            $isShown = 1 if $self->{$_}->get_active;
            $self->{show}->{$_} = $isShown;
            $hidden .= $_.'|' if !$isShown;
        }
        $self->{options}->hidden($hidden);
        $self->{options}->save;
    }
    
    sub selectAll
    {
        my $self = shift;
        
        foreach (@{$self->{fields}})
        {
            $self->{$_}->set_active(1);
        }
    }
    
    sub initBox
    {
        my ($self, $box, $values) = @_;
        $box->set_border_width(2);
        foreach (@$values)
        {
            $self->{$_->{id}} = new Gtk2::CheckButton($_->{label});
            $box->pack_start($self->{$_->{id}}, 0,0,5);
        }
    }
    
    sub createComponents
    {
        my $self = shift;
        
        $self->{tabs} = Gtk2::Notebook->new();
        $self->{tabs}->set_border_width(12);
        foreach (@{$self->{fieldsInfo}})
        {
            my $frame = new Gtk2::Frame();
            $frame->set_shadow_type('none');
            $frame->set_border_width($GCUtils::margin);
            $frame->set_label_align(1.0, 0.0);
            my $vbox = new Gtk2::VBox(0,0);
            $self->initBox($vbox, $_->{items});
            my $scroll = new Gtk2::ScrolledWindow;
            $scroll->set_policy ('automatic', 'automatic');
            $frame->add($scroll);
            $scroll->add_with_viewport($vbox);
            $scroll->set_shadow_type('none');
            $scroll->child->set_shadow_type('none');
            $self->{tabs}->append_page($frame, $_->{title});
        }
		
		$self->{hboxActions} = new Gtk2::HBox(0,0);
		my $allButton = new Gtk2::Button($self->{lang}->{DisplayOptionsAll});
		$allButton->signal_connect( clicked => sub {
		  $self->selectAll;
		});
		$self->{hboxActions}->pack_end($allButton,1,0,20);
		
		$self->vbox->pack_start($self->{tabs}, 1, 1, 2);
        $self->vbox->pack_start($self->{hboxActions}, 0, 0, 10);
    }
}

1;
