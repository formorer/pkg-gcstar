package GCMainWindow;

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
use Gtk2;

{
    package GCFrame;

    use Glib::Object::Subclass
                Gtk2::Window::
    ;
    
    @GCFrame::ISA = ('Gtk2::Window');

    # Internal modules
    use GCDialogs;
    use GCPlugins;
    use GCModel;
    use GCGraphicComponents::GCBaseWidgets;
    use GCMenu;
    use GCPanel;
    use GCUtils 'glob';
    use GCOptions;
    use GCStyle;
    use GCBorrowings;
    use GCExtract;
    use GCExport;
    use GCImport;
    use GCSplash;
    use GCLang;
    use GCDisplay;
    use GCData;
    use GCMail;
    use GCBookmarks;
    use GCStats;

    use GCItemsLists::GCTextLists;
    use GCItemsLists::GCImageLists;

    #use GCGenres;

    # Pragmas
    use filetest 'access';
 
    # External modules
    use LWP;
    use URI::Escape;
    use File::Basename;
    use File::Spec;
    use File::Copy;
    use File::Path;
    use IO::Handle;
    use Storable qw(store_fd fd_retrieve);
    use File::Temp qw(tempdir);
    use Encode;

    sub showMe
    {
        my $self = shift;
        $self->present;
    }

    sub beforeDestroy
    {
		my $self = shift;
		$self->leave;
		return 1;
    }

    sub savePreferences
    {
        my $self = shift;
        $self->{itemsView}->savePreferences($self->{model}->{preferences})
            if $self->{itemsView} && $self->{model} && $self->{model}->{preferences};
    }

    sub leave
    {
        my $self = shift;

        return if !$self->checkAndSave;

        my ($width, $height) = $self->get_size;
        $self->{options}->file('')
            if $self->{options}->noautoload;
        $self->{options}->width($width);
        $self->{options}->height($height);
        $self->{options}->split($self->{pane}->get_position) if ($self->{pane});
        $self->{options}->listPaneSplit($self->{listPane}->get_position) if ($self->{listPane});

        $self->{options}->save;
        $self->savePreferences;
        $self->{model}->save
            if $self->{model};

        $self->{items}->clean;

        if (($^O !~ /win32/i) && ($self->{searchJob}->{pid}))
        {
            store_fd {type => 'exit'}, $self->{searchJob}->{command};
            my $command = $self->{searchJob}->{command};
            print $command "EXIT\n";
            close $self->{searchJob}->{command};
            close $self->{searchJob}->{data};
            kill 9, $self->{searchJob}->{pid};
            wait;
        }
        $self->{menubar}->save();
        $self->destroy;
    }

    sub deleteCurrentItem
    {
        my $self = shift;
        my $response = 'yes';
        my $confirm = 0;

        if ($self->{options}->confirm)
        {
            my  $dialog = Gtk2::MessageDialog->new($self,
                                                   [qw/modal destroy-with-parent/],
                                                   'question',
                                                   'cancel',
                                                   $self->{items}->{multipleMode} ? $self->{lang}->{RemoveConfirmPlural} :
                                                                                    $self->{lang}->{RemoveConfirm});

            my $delButton = Gtk2::Button->new_from_stock('gtk-delete');
            $delButton->can_default(1);
            $dialog->add_action_widget($delButton, 'yes');
            $delButton->show_all;
            $dialog->set_default_response('yes');
            $dialog->set_position('center-on-parent');
            my $check = new Gtk2::CheckButton($self->{lang}->{OptionsDontAsk});
            $dialog->vbox->pack_start($check,0,0,5);
            $dialog->vbox->pack_start(Gtk2::HSeparator->new,0,0,5);
            $dialog->vbox->show_all;
            $response = $dialog->run;
            $confirm = ($check->get_active ? 0 : 1);
            $dialog->destroy;
        }
	
        if ($response eq 'yes')
        {
            $self->markAsUpdated;
            $self->{items}->removeCurrentItems;
            $self->setNbItems;
            $self->{options}->confirm($confirm);
            $self->{panel}->hide if ! $self->{itemsView}->getNbItems;
        }
    }

    sub newItem
    {
			
        my ($self, $self2, $noDisplay) = @_;
        $self = $self2 if $self2;

        #$self->{options}->lockPanel(0);
        # Uncomment to memorize
        #$self->{panel}->changeState($self->{panel}, 0);
        $self->{menubar}->setCollectionLock(0);
        
        my $info = $self->{model}->getDefaultValues;
        $self->addItem($info, 1, undef, 1);
        
        $self->displayInWindow(undef, 'item', 1)
            if $self->{panel}->isReadOnly && !$noDisplay;
    }

    sub selectAll
    {
        my $self = shift;
        
        $self->{itemsView}->selectAll;
    }

    sub duplicateItem
    {
			
        my ($self, $self2) = @_;
        $self = $self2 if $self2;

        my @added;
        my $indexes = $self->{itemsView}->getCurrentItems;
        foreach my $idx(@$indexes)
        {
            my $newItem = Storable::dclone(($self->{items}->getItemsListFiltered)->[$idx]);
            # Duplicate all the managed pictures
            foreach (@{$self->{model}->{managedImages}})
            {
                (my $origPic = $newItem->{$_}) =~ /^(.*)(\.[^\.]*)$/;
                next if !$origPic;
                my ($base, $suffix) = ($1, $2);
                my $newPic;
                my $count = 0;
                $count++ while (-e ($newPic = $base.'_'.$count.$suffix));
                copy($origPic,$newPic);
                $self->{items}->markToBeAdded($newPic);
                $newItem->{$_} = $newPic;
            }
            push @added, $newItem;
        }

        foreach my $info(@added)
        {
            $self->addItem($info, 1);
        }
    }

    sub loadUrl
    {
        my ($self, $url, $existing) = @_;
        
        my $baseUrl;
        my $plugin;

        foreach (values %{$self->{model}->getAllPlugins})
        {
            ($baseUrl = $_->getItemUrl) =~ s/http:\/\/(w{3})?//;
            $plugin = $_;

            last if ((($baseUrl) && ($url =~ m/$baseUrl/))
                    && (($plugin->testURL($url)) || (!$plugin->needsLanguageTest())));
        }

        return unless $url =~ m/$baseUrl/;
        $self->setWaitCursor($self->{lang}->{StatusGetInfo});
        
        # Create a new item if we're not wanting to update the existing one
        $self->newItem
            if (!$existing);
        $plugin->{bigPics} = $self->{options}->bigPics;
        my $info = $plugin->loadUrl($url);
        $self->restoreCursor;
        return if ! $info->{$self->{model}->{commonFields}->{title}};

        if ($existing)
        {
            # We only want to update blank fields during the refresh
            foreach my $field (keys(%{$info}))
            {
                # Loop through fields returned and check if they were previously blank
                # or an empty array. Only exception is the press rating field,
                # which we'll always want to update
                if ((($self->{panel}->$field) && ($field ne 'ratingpress'))
                        && !((ref($self->{panel}->$field)) && ( @{$self->{panel}->$field} == 0)))
                {
                    # Ignore field
                    $info->{$field} =  $self->{ignoreString};
                }
            }
            
        }
        
        $self->addItem($info, 0);
    }

    sub refreshItemForPanel
    {
        my ($self, $panel, $url) = @_;

        $self->{previousPanel} = $self->{panel};
        $self->{panel} = $panel;

        # Clear the ## part off the end of stored urls
        $url =~ s/#.*$//;
        
        # Fetch information from the stored url
        $self->loadUrl($url, 1);

        $self->{panel} = $self->{previousPanel} if ($panel);
        delete $self->{previousPanel};
    }
    
    sub searchItemForPanel
    {
        my ($self, $panel, $pluginType) = @_;
        
        if ($panel)
        {
            $self->{previousPanel} = $self->{panel};
            $self->{panel} = $panel;
        }
        my $query;
        my $field;
        my %queries;
        foreach (@{$self->{model}->getSearchFields})
        {
            $queries{$_} = $self->{panel}->getValue($_);
            if (!$query)
            {
                $query = $queries{$_};
                $field = $_;
            }
        }
        $self->searchItem($query, $pluginType, 0, $field, \%queries);
        $self->{panel} = $self->{previousPanel} if ($panel);
        delete $self->{previousPanel};
    }
    
    sub searchItem
    {
        my ($self, $query, $pluginType, $currentPlugin, $searchField, $queries) = @_;

        # Search for information on websites thanks to plugins

        # This will contain the plugin that should be used to fetch the information
        my $plugin;
        # When information are previewed, they are stored in this map to avoid getting twice
        # the same information. The key is the index in the list of results.
        $self->{previewCache} = {};

        # Fetch mode, if not forced take it from prefs
        $pluginType=$self->{model}->{preferences}->plugin if !$pluginType;
        
        # Many sites per field
        if ($pluginType eq 'multiperfield')
        {
            my $whenMultiple='Ask';
            my $info=$self->searchItemInfoWithPluginList($query, $whenMultiple, $currentPlugin, $searchField, $queries);
            $self->addItem($info, 0);
            return;
        }
        # Many sites
        elsif ($pluginType eq 'multi')
        {
            # Here we get the next plugin in the list if the user set a list
            my $pluginName = $self->getDialog('MultiSite')->getPlugin($currentPlugin);
            $plugin = $self->{model}->getPlugin($pluginName);
            if (!$plugin)
            {
                my $dialog = Gtk2::MessageDialog->new($self,
							   [qw/modal destroy-with-parent/],
							   'error',
							   'ok',
							   $self->{lang}->{MultiSiteEmptyError});

                $dialog->set_position('center-on-parent');
                my $response = $dialog->run;
                $dialog->destroy;
                return;
            }
        }
        # Ask (within in a specific list)
        elsif ($pluginType eq 'multiask')
        {
            # Display the list of plugins to use
            $self->getDialog('PluginsAsk')->setModel($self->{model},
                                                     $self->{model}->{preferences}->multisite);
            $self->getDialog('PluginsAsk')->query($query, $searchField, $queries);
            $self->getDialog('PluginsAsk')->show;
            $plugin = $self->getDialog('PluginsAsk')->plugin;
            return if !$plugin;
            ($query, $searchField) = $self->getDialog('PluginsAsk')->query;
        }
        # Ask (All sites)
        # Also activated if forced by user (e.g. if a search returned no result)
        elsif ($pluginType eq 'ask' || ! $self->{plugin})
        {
            $self->getDialog('Plugins')->query($query, $searchField, $queries);
            $self->getDialog('Plugins')->show;
            $plugin = $self->getDialog('Plugins')->plugin;
            return if !$plugin;
            ($query, $searchField) = $self->getDialog('Plugins')->query;
        }
        # Explicit plugin
        else
        {
            $plugin = $self->{plugin};
        }

        # Loop through search/select routine for plugin's desired number of passes
        for (my $pass = 1; $pass <= $plugin->getNumberPasses; $pass++)
        {
            # Force values of query and search field if they are incompatible with current plugin
            my $compatible = 1;
            $compatible = grep /^$searchField$/, @{$plugin->getSearchFieldsArray}
                if $searchField;
            if (!$compatible)
            {
                # If it is not, we use the 1st compatible one
                $searchField = $plugin->getSearchFieldsArray->[0];
                $query = $queries->{$searchField};
            }

            # If the search cannot be stopped
            if (! $self->{options}->searchStop)
            {
                # Prepare the plugin with required information
                $plugin->setProxy($self->{options}->proxy);
                $plugin->setCookieJar($self->{options}->cookieJar);

                # Title to search
                $plugin->{title} = $query;
                $plugin->{pass} = $pass;
                # Type set to load means a search on the website
                $plugin->{type} = 'load';
                $plugin->{urlField} = $self->{model}->{commonFields}->{url};
                $plugin->{bigPics} = $self->{options}->bigPics;
                $plugin->{searchField} = $searchField;
            
                $self->setWaitCursor($self->{lang}->{StatusSearch}.' ('.$plugin->getName.')');
                # Perform the load
                $plugin->load;
                $self->restoreCursor;
            }
            else
            {
                # Prepare the information for search
                # Nearly the same as the ones set directly on plugin when search cannot be stopped
                my $info = {
                                name => $plugin->getName,
                                model => $self->{model}->getName,
                                proxy => $self->{options}->proxy,
                                cookieJar => $self->{options}->cookieJar,
                                query => $query,
                                field => $searchField,
                                type  => 'load',
                                urlField => $self->{model}->{commonFields}->{url},
                                bigPics => $self->{options}->bigPics,
                                pass => $pass,
                                nextUrl => $plugin->{nextUrl}
                           };
                # Send the information to the other process that will perform the actual search
                store_fd $info, $self->{searchJob}->{command};
                my $getInfo = 0;
                # Dialog with progress bar and cancel button
                my $dialog = Gtk2::MessageDialog->new($self,
                    [qw/modal destroy-with-parent/],
                    'info',
                    'cancel',
                    $self->{lang}->{StatusSearch} . "\n" . $plugin->getName);
                    
                my $progress = new Gtk2::ProgressBar;
                $dialog->vbox->pack_start($progress,1,1,10);
                $progress->set_pulse_step(0.05);
                $progress->show_all;
                my $pulseTimeout = Glib::Timeout->add(50 , sub {
                    # $getInfo will be set by the watcher that looks for data from the other process
                    return 0 if $getInfo;
                    $progress->pulse;
                    return 1;
                });

                # If there is already something in the pipe...
                my $rin = '';
                vec($rin,fileno($self->{searchJob}->{data}),1) = 1;
                if (select($rin,undef,undef,0.01))
                {
                    # ... We just get it to empty the pipe
                    my $trash = fd_retrieve($self->{searchJob}->{data});
                }
                # Monitor the pipe from process
                my $watch = Glib::IO->add_watch(fileno($self->{searchJob}->{data}),
                                    'in',
                                    sub {
                                        return if !$dialog;
                                        # Close the dialog window
                                        $dialog->response('cancel');
                                        # Set variable to indicate we got some data
                                        $getInfo = 1;
                                        return 0;
                                     });

                $dialog->set_position('center-on-parent');
                # It will run until we get some information, or the user press cancel
                $dialog->run if !$getInfo;
                # Stop everything
                Glib::Source->remove($watch);
                Glib::Source->remove($pulseTimeout);
                $dialog->destroy;
                my $command = $self->{searchJob}->{command};
                # Did we get something?
                if ($getInfo)
                {
                    # Then we read the data from pipe
                    $plugin = fd_retrieve($self->{searchJob}->{data});
                    # And we inform the process we got it
                    print $command "OK\n";
                }
                else
                {
                    # Tell the process the information is no more required
                    print $command "STOP\n";
                    return;
                }
            }

            # Get the number of retrieved items
            my $itemNumber = $plugin->getItemsNumber();
            $self->{defaultPictureSuffix} = $plugin->getDefaultPictureSuffix;

            # If there is none, we will use next plugin ('multi' mode) or ask the user
            # to select another one
            if ($itemNumber == 0)
            {
                my $force = 0;
                my $idx = 0;
                if (($pluginType eq 'multi') && (($currentPlugin + 1) < $self->getDialog('MultiSite')->getPluginsNumber))
                {
                    $idx = $currentPlugin + 1;
                }
                else
                {
                    my  $dialog = Gtk2::MessageDialog->new($self,
                                                           [qw/modal destroy-with-parent/],
                                                           'error',
                                                           'yes-no',
                                                           $self->{lang}->{NoItemFound});
               
                    $dialog->set_position('center-on-parent');
                    my $response = $dialog->run;
                    $dialog->destroy;
                    return if $response ne 'yes';
                    $pluginType = 'ask';
                }
                # Call the same method again with new plugin
                $self->searchItem($query, $pluginType, $idx, $searchField, $queries);
            }
            # Just one item, directly fetch its information
            elsif ($itemNumber == 1)
            {
                if ($pass == $plugin->getNumberPasses)
                {
                    # Final pass, so grab item info
                    $self->downloadItemInfoFromPlugin($plugin, 0);
                }
                else
                {
                    # Still have more passes to do, find the next url to parse
                    my @items = $plugin->getItems();
                    $plugin->{nextUrl} = $items[0]->{nextUrl};
                }
            }
            else
            {
                # Should we display the Next button to perform the search on the next website?
                my $withNext = 0;
                $withNext = 1 if ($pluginType eq 'multi') && (($currentPlugin + 1) < $self->getDialog('MultiSite')->getPluginsNumber);

                # Get an array with all the results
                my @items = $plugin->getItems();
                # Dialog that will contain them
                my $resultsDialog = $self->getDialog('Results');
                $resultsDialog->setModel($self->{model}, $self->{model}->{fieldsInfo});
                $resultsDialog->setMultipleSelection($pass == $plugin->getNumberPasses);
                $resultsDialog->setWithNext($withNext);
                $resultsDialog->setSearchPlugin($plugin);
                $resultsDialog->setList('', @items);
                my $next = $resultsDialog->show;
                # If the user selected one of the results
                if ($resultsDialog->{validated})
                {
                    if ($pass == $plugin->getNumberPasses)
                    {
                        # Final pass, so grab item information

                        my $indexes = $resultsDialog->getItemsIndexes;
                        # Fetch the information from the website
                        $self->downloadItemInfoFromPlugin($plugin, $indexes->[0]);
                        # If more than one were selected, other items are automatically created
                        # and their information fetched
                        if (scalar(@$indexes) > 1)
                        {
                            shift @$indexes;
                            foreach my $idx(@$indexes)
                            {
                                if ((exists $self->{previousPanel})
                                 && ($self->{previousPanel}->isReadOnly))
                                {
                                    $self->updateSelectedItemInfoFromGivenPanelAndSelect($self->{panel}, $idx);
                                }
                                if ($pass == $plugin->getNumberPasses)
                                {
                                    $self->newItem(undef, 0);
                                }
                                $self->downloadItemInfoFromPlugin($plugin, $idx);
                            }
                        }
                    }
                    else
                    {
                        # More passes to do, so find next url to parse
                        # TODO - make sure we stop users from selecting more than one item
                        # on anything but the last pass. At the moment this will ignore
                        # everything but the first item selected
                        if ($resultsDialog->{validated})
                        {
                            my $indexes = $resultsDialog->getItemsIndexes;            
                            $plugin->{nextUrl} = @items[$indexes->[0]]->{nextUrl};
                        }
                    }
                }
                # If the user pressed Next button, call the same method again with next plugin
                elsif ($next)
                {
                    $self->searchItem($query, $pluginType, $currentPlugin + 1, $searchField, $queries);
                }
            }
        }
    }

    sub searchItemInfoWithPluginList
    {
        my ($self, $query, $whenMultiple, $currentPlugin, $searchField, $queries, $otherSourcesNames,$otherSources) = @_;
    
        # Search for information on websites thanks to plugins
        # Get info for each fields in the priority asked by $pluginListOrderPerField
        
        # Get the list of fields and plugin
        my $myHelperSourcesPerField=$self->getDialog('MultiSitePerField');
        $myHelperSourcesPerField->setModel($self->{model});
        my $otherSourcesMenu;
        $otherSourcesMenu=map { value=>$_,displayed =>$otherSourcesNames->{$_} }, keys %$otherSourcesNames if ($otherSourcesNames);
        $myHelperSourcesPerField->setSourceList(1, $otherSourcesMenu);
        
        $myHelperSourcesPerField->resetCurrentFetchingStatus;
        my $infoPerPlugin={};
        PLUGIN: while(1){
            # This will contain the plugin that should be used to fetch the information
            my $pluginName=$myHelperSourcesPerField->getNextSourceNeeded;
            last PLUGIN unless ($pluginName);
            if(grep /$pluginName/, keys %$otherSources)
            {
                $infoPerPlugin->{$pluginName}=$otherSources->{$pluginName};
            }
            else
            {
                my $plugin=$myHelperSourcesPerField->getPlugin($pluginName);
                # Now we have the plugin to use
                $infoPerPlugin->{$pluginName} = $self->searchOneItemInfoWithPlugin($query, $whenMultiple, $plugin, $searchField, $queries);
            }
            # TODO update the query to avoid re asking if multiple results for next plugin i.e. add info from fetched data to the query
            
            # Update fields fetched with this plugin
            $myHelperSourcesPerField->doneWithSourceName($pluginName,$infoPerPlugin->{$pluginName});
        }
        my $info=$myHelperSourcesPerField->joinInfo($infoPerPlugin);
        # TODO manage multiple url, for instance we throw them
        return $info;
    }

    sub searchOneItemInfoWithPlugin
    {
        my ($self, $query, $whenMultiple, $plugin, $searchField, $queries) = @_;
        # Search for information on websites thanks to plugins
        # Return $info
                
        # When information are previewed, they are stored in this map to avoid getting twice
        # the same information. The key is the index in the list of results.
        $self->{previewCache} = {};
        my $info={};
        # Loop through search/select routine for plugin's desired number of passes
        for (my $pass = 1; $pass <= $plugin->getNumberPasses; $pass++)
        {
            # Force values of query and search field if they are incompatible with current plugin
            my $compatible = grep /^$searchField$/, @{$plugin->getSearchFieldsArray};
            if (!$compatible)
            {
                # If it is not, we use the 1st compatible one
                $searchField = $plugin->getSearchFieldsArray->[0];
                $query = $queries->{$searchField};
            }

            # If the search cannot be stopped
            if (! $self->{options}->searchStop)
            {
                # Prepare the plugin with required information
                $plugin->setProxy($self->{options}->proxy);
                $plugin->setCookieJar($self->{options}->cookieJar);

                # Title to search
                $plugin->{title} = $query;
                $plugin->{pass} = $pass;
                # Type set to load means a search on the website
                $plugin->{type} = 'load';
                $plugin->{urlField} = $self->{model}->{commonFields}->{url};
                $plugin->{bigPics} = $self->{options}->bigPics;
                $plugin->{searchField} = $searchField;
            
                $self->setWaitCursor($self->{lang}->{StatusSearch}.' ('.$plugin->getName.')');
                # Perform the load
                $plugin->load;
                $self->restoreCursor;
            }
            else
            {
                # Prepare the information for search
                # Nearly the same as the ones set directly on plugin when search cannot be stopped
                my $info = {
                                name => $plugin->getName,
                                model => $self->{model}->getName,
                                proxy => $self->{options}->proxy,
                                cookieJar => $self->{options}->cookieJar,
                                query => $query,
                                field => $searchField,
                                type  => 'load',
                                urlField => $self->{model}->{commonFields}->{url},
                                bigPics => $self->{options}->bigPics,
                                pass => $pass,
                                nextUrl => $plugin->{nextUrl}
                           };
                # Send the information to the other process that will perform the actual search
                store_fd $info, $self->{searchJob}->{command};
                my $getInfo = 0;
                # Dialog with progress bar and cancel button
                my $dialog = Gtk2::MessageDialog->new($self,
                    [qw/modal destroy-with-parent/],
                    'info',
                    'cancel',
                    $self->{lang}->{StatusSearch} . "\n" . $plugin->getName);
                    
                my $progress = new Gtk2::ProgressBar;
                $dialog->vbox->pack_start($progress,1,1,10);
                $progress->set_pulse_step(0.05);
                $progress->show_all;
                my $pulseTimeout = Glib::Timeout->add(50 , sub {
                    # $getInfo will be set by the watcher that looks for data from the other process
                    return 0 if $getInfo;
                    $progress->pulse;
                    return 1;
                });

                # If there is already something in the pipe...
                my $rin = '';
                vec($rin,fileno($self->{searchJob}->{data}),1) = 1;
                if (select($rin,undef,undef,0.01))
                {
                    # ... We just get it to empty the pipe
                    my $trash = fd_retrieve($self->{searchJob}->{data});
                }
                # Monitor the pipe from process
                my $watch = Glib::IO->add_watch(fileno($self->{searchJob}->{data}),
                                    'in',
                                    sub {
                                        return if !$dialog;
                                        # Close the dialog window
                                        $dialog->response('cancel');
                                        # Set variable to indicate we got some data
                                        $getInfo = 1;
                                        return 0;
                                     });

                $dialog->set_position('center-on-parent');
                # It will run until we get some information, or the user press cancel
                $dialog->run if !$getInfo;
                # Stop everything
                Glib::Source->remove($watch);
                Glib::Source->remove($pulseTimeout);
                $dialog->destroy;
                my $command = $self->{searchJob}->{command};
                # Did we get something?
                if ($getInfo)
                {
                    # Then we read the data from pipe
                    $plugin = fd_retrieve($self->{searchJob}->{data});
                    # And we inform the process we got it
                    print $command "OK\n";
                }
                else
                {
                    # Tell the process the information is no more required
                    print $command "STOP\n";
                    return;
                }
            }

            # Get the number of retrieved items
            my $itemNumber = $plugin->getItemsNumber();
            $self->{defaultPictureSuffix} = $plugin->getDefaultPictureSuffix;
            # If there is none, we will use next plugin ('multi' mode) or ask the user
            # to select another one
            if ($itemNumber == 0)
            {
                
            }
            # Just one item, directly fetch its information
            elsif ($itemNumber == 1 || $whenMultiple eq 'TakeFirst')
            {
                if ($pass == $plugin->getNumberPasses)
                {
                    # Final pass, so grab item info
                    $info=$self->fetchItemInfoFromPlugin($plugin, 0);
                }
                else
                {
                    # Still have more passes to do, find the next url to parse
                    my @items = $plugin->getItems();
                    $plugin->{nextUrl} = $items[0]->{nextUrl};
                }
            }
            else
            {
                if($whenMultiple eq 'Ask')
                {
                    # Get an array with all the results
                    my @items = $plugin->getItems();
                    # Dialog that will contain them
                    my $resultsDialog = $self->getDialog('Results');
                    $resultsDialog->setModel($self->{model}, $self->{model}->{fieldsInfo});
                    $resultsDialog->setMultipleSelection(0);
                    $resultsDialog->setWithNext(0);
                    $resultsDialog->setSearchPlugin($plugin);
                    $resultsDialog->setList('', @items);
                    my $next = $resultsDialog->show;
                    # If the user selected one of the results
                    if ($resultsDialog->{validated})
                    {
                        if ($pass == $plugin->getNumberPasses)
                        {
                            # Final pass, so grab item information
                            my $indexes = $resultsDialog->getItemsIndexes;
                            # Fetch the information from the website
                            $info=$self->fetchItemInfoFromPlugin($plugin, $indexes->[0]);
                        }
                        else
                        {
                            # More passes to do, so find next url to parse
                            if ($resultsDialog->{validated})
                            {
                                my $indexes = $resultsDialog->getItemsIndexes;            
                                $plugin->{nextUrl} = @items[$indexes->[0]]->{nextUrl};
                            }
                        }
                    }
                }
            }
        }
        return $info;
    }
    
    sub fetchItemInfoFromPlugin
    {
        my ($self, $plugin, $idx) = @_;

        my $info;
        
        # Gets from cache if we already previewed it
        if ($self->{previewCache}->{$idx})
        {
            $info = $self->{previewCache}->{$idx};
        }
        else
        {
            # Tell the plugin what we want
            $plugin->{wantedIdx} = $idx;
            $plugin->{type} = 'info';
            
            if (! $self->{options}->searchStop)
            {
                $self->setWaitCursor($self->{lang}->{StatusGetInfo});
                # Fetch the information
                $info = $plugin->getItemInfo;
                $self->restoreCursor;
            }
            else
            {
                # Send directly the plugin to the other process
                store_fd $plugin, $self->{searchJob}->{command};
                # Indicates if something was returned by plugin
                my $getInfo = 0;
                my $dialogGet = Gtk2::MessageDialog->new($self,
                    [qw/modal destroy-with-parent/],
                    'info',
                    'cancel',
                    $self->{lang}->{StatusGetInfo});
                    
                my $progress = new Gtk2::ProgressBar;
                $dialogGet->vbox->pack_start($progress,1,1,10);
                $progress->set_pulse_step(0.05);
                $progress->show_all;
                my $pulseTimeout = Glib::Timeout->add(50 , sub {
                    # $getInfo will be set by the watcher that looks for data from the other process
                    return 0 if $getInfo;
                    $progress->pulse;
                    return 1;
                });
                    
                # Monitor the pipe from process
                my $watch = Glib::IO->add_watch(fileno($self->{searchJob}->{data}),
                                    'in',
                                    sub {
                                        return if !$dialogGet;
                                        $dialogGet->response('cancel');
                                        # Set the flag when we got something
                                        $getInfo = 1;
                                        return 0;
                                    });
    
                $dialogGet->set_position('center-on-parent');
                # It will run until we get some information, or the user press cancel
                $dialogGet->run if !$getInfo;
                # Stop everything
                Glib::Source->remove($watch);
                Glib::Source->remove($pulseTimeout);
                $dialogGet->destroy;
                my $command = $self->{searchJob}->{command};
                # Did we get something?
                if ($getInfo)
                {
                    # Then we read the data from pipe
                    $info = fd_retrieve($self->{searchJob}->{data});
                    # And we inform the process we got it
                    print $command "OK\n";
                }
                else
                {
                    # Tell the process the information is no more required
                    print $command "STOP\n";
                }
            }
        }
        return $info;
    }

    sub downloadItemInfoFromPlugin
    {
        my ($self, $plugin, $idx, $withPreview) = @_;

        my $info;
        
        # Gets from cache if we already previewed it
        if ($self->{previewCache}->{$idx})
        {
            $info = $self->{previewCache}->{$idx};
        }
        else
        {
            # Tell the plugin what we want
            $plugin->{wantedIdx} = $idx;
            $plugin->{type} = 'info';
            
            if (! $self->{options}->searchStop)
            {
                $self->setWaitCursor($self->{lang}->{StatusGetInfo});
                # Fetch the information
                $info = $plugin->getItemInfo;
                $self->restoreCursor;
            }
            else
            {
                # Send directly the plugin to the other process
                store_fd $plugin, $self->{searchJob}->{command};
                # Indicates if something was returned by plugin
                my $getInfo = 0;
                my $dialogGet = Gtk2::MessageDialog->new($self,
                    [qw/modal destroy-with-parent/],
                    'info',
                    'cancel',
                    $self->{lang}->{StatusGetInfo});
                    
                my $progress = new Gtk2::ProgressBar;
                $dialogGet->vbox->pack_start($progress,1,1,10);
                $progress->set_pulse_step(0.05);
                $progress->show_all;
                my $pulseTimeout = Glib::Timeout->add(50 , sub {
                    # $getInfo will be set by the watcher that looks for data from the other process
                    return 0 if $getInfo;
                    $progress->pulse;
                    return 1;
                });
                    
                # Monitor the pipe from process
                my $watch = Glib::IO->add_watch(fileno($self->{searchJob}->{data}),
                                    'in',
                                    sub {
                                        return if !$dialogGet;
                                        $dialogGet->response('cancel');
                                        # Set the flag when we got something
                                        $getInfo = 1;
                                        return 0;
                                    });
    
                $dialogGet->set_position('center-on-parent');
                # It will run until we get some information, or the user press cancel
                $dialogGet->run if !$getInfo;
                # Stop everything
                Glib::Source->remove($watch);
                Glib::Source->remove($pulseTimeout);
                $dialogGet->destroy;
                my $command = $self->{searchJob}->{command};
                # Did we get something?
                if ($getInfo)
                {
                    # Then we read the data from pipe
                    $info = fd_retrieve($self->{searchJob}->{data});
                    # And we inform the process we got it
                    print $command "OK\n";
                }
                else
                {
                    # Tell the process the information is no more required
                    print $command "STOP\n";
                    return;
                }
            }
        }

        # If we are doing a preview instead of really fetching the data
        if ($withPreview)
        {
            # Stores in cache
            $self->{previewCache}->{$idx} = $info;
            $self->getDialog('ImportFields')->info($info);
            $self->getDialog('ImportFields')->setReadOnly(1);
            $self->getDialog('ImportFields')->show;
        }
        else
        {
            # If user want to select the fields to fetch
            if ($self->{options}->askImport)
            {
                $self->getDialog('ImportFields')->info($info);
                $self->getDialog('ImportFields')->setReadOnly(0);
                return if ! $self->getDialog('ImportFields')->show;
                $info = $self->getDialog('ImportFields')->info;
            }
            # Set the information (2nd parameter set to 0 means no item creation).
            $self->addItem($info, 0);
        }
    }
    
    sub checkDefaultImage
    {
        my $self = shift;
        my $previous = $self->{defaultImage};
        my $specific = $self->{items}->getInformation->{defaultImage};
        if ($specific && (-f $specific))
        {
            $self->{defaultImage} = $specific;
        }
        elsif (-f $self->{model}->{defaultImage})
        {
            $self->{defaultImage} = $self->{model}->{defaultImage};
        }
        else
        {
            if (-f $self->{logosDir}.'no.png')
            {
                $self->{defaultImage} = $self->{logosDir}.'no.png';
            }
            else
            {
                $self->{defaultImage} = $ENV{GCS_SHARE_DIR}.'/no.jpg';
            }
        }
        $self->setItemsList
            if !$self->{initializing} && $self->{itemsView} && ($previous ne $self->{defaultImage});
    }

    sub getImagesDir
    {
        my $self = shift;

        my $imagesDir = '';
        $imagesDir = $self->{items}->getInformation->{images}
            if $self->{items};
        my $i = 0;
        #We use the global one if none exists in the collection
        $imagesDir ||= $self->{options}->images;
        if ($self->{options}->file)
        {
            $imagesDir =~ s/^(%WORKING_DIR%|\.)/dirname($self->{options}->file)/e;
            $imagesDir =~ s/%FILE_BASE%/basename($self->{options}->file,  '.gcs')/e;
        }
        else
        {
            # If value contains one of the variables and we don't have a directory name
            # we store everything in the temporary directory
            $imagesDir = $self->{tmpImageDir}
                if ($imagesDir =~ m/^(%WORKING_DIR%|\.)/)
                || ($imagesDir =~ m/%FILE_BASE%/);
        }
        
        return GCUtils::pathToUnix($imagesDir);
    }

    sub getUniqueImageFileName
    {
        my ($self, $suffix, $itemTitle, $imagesDir) = @_;
        
        # If none specified, we use the default one
        $imagesDir ||= $self->getImagesDir;
        $imagesDir =~ s+([^/])$+$1/+;
        my $imagePrefix;
        if ($self->{options}->useTitleForPics)
        {
            $imagePrefix = GCUtils::getSafeFileName($itemTitle);
            $imagePrefix .= '_';
        }
        else
        {
            $imagePrefix = $self->{imagePrefix};
        }

        if ( ! -e $imagesDir)
        {
            mkdir($imagesDir);
        }

        my $filePrefix = $imagesDir.$imagePrefix;
        my @tmp_filenames;
        @tmp_filenames = glob $filePrefix.'*.*';
        my $sysPrefix = $filePrefix;
        $sysPrefix =~ s/\\/\\\\/g if ($^O =~ /win32/i);
        my @numbers = sort {$b <=> $a} map {
            /$sysPrefix([0-9]*)\./ && $1;
        } @tmp_filenames;
        my $mostRecent = $numbers[0] || 0;

        my $picture = $filePrefix.$mostRecent.$suffix;

        while (-e $picture)
        {
            $mostRecent++;
            $picture = $filePrefix.$mostRecent.$suffix;
        }
        return $picture;
    }

    sub isManagedPicture
    {
        my ($self, $pic) = @_;
        my $file = GCUtils::getDisplayedImage($pic, '', $self->{options}->file);
        my $imagePrefix = $self->{imagePrefix};
        my $imageDir = $self->getImagesDir;
        if (($file =~ /(\/|\\)$imagePrefix[0-9]*\./)
         && ($file =~ m|^\Q$imageDir\E|))
        {
            return $file;
        }
        else
        {
            return 0;
        }
    }

    sub checkPictureToBeRemoved
    {
        my ($self, $pic) = @_;
        if (my $file = $self->isManagedPicture($pic))
        {
            $self->{items}->markToBeRemoved($file);
        }        
    }
    
#    sub changeInfo
#    {
#        my ($self, $info) = @_;
#
#        my @genres = split /,/, $info->{type};
#        my $newGenres = '';
#        
#        foreach (@genres)
#        {
#            $newGenres .= $self->getDialog('GenresGroups')->{convertor}->convert($_).',';
#        }
#        $newGenres =~ s/.$//;
#        
#        $info->{type} = $newGenres;
#    }
    
    sub addItem
    {
        my ($self, $info, $newItem, $keepId, $defaultValues) = @_;

        #$self->changeInfo($info);
        my $ignore = $self->{ignoreString};
        
        if ($newItem)
        {
            $self->{items}->updateSelectedItemInfoFromPanel;
            $self->markAsUpdated;
            my $id = $self->{items}->addItem($info, $keepId);
            my @picFields = ();
            for my $field (@{$self->{model}->{fieldsNames}})
            {
                if ($self->{model}->{fieldsInfo}->{$field}->{type} eq 'image')
                {
                    push @picFields, $field;
                    next;
                }
                $self->{panel}->$field($info->{$field});
            }
            $self->{panel}->selectTitle;
            my $title = $info->{$self->{model}->{commonFields}->{title}};
            my $imagePrefix = $self->{imagePrefix};
            foreach my $pic(@picFields)
            {
                if ($info->{$pic} && ($info->{$pic} ne $ignore))
                {
                    $self->checkPictureToBeRemoved($self->{panel}->$pic);
                    ($info->{$pic}, my $picture) = $self->downloadPicture($info->{$pic}, $title)
                        if !$defaultValues;
                    
                    # Only set the picture if one was returned. Otherwise the download was rejected, so stick with
                    # the existing picture
                    if ($info->{$pic})
                    {                        
                        $self->{panel}->$pic($info->{$pic})
                    }
                    else
                    {
                        $info->{$pic} = $ignore;
                    }
                }
            }
            $self->{items}->updateSelectedItemInfoFromPanel(1);
            $self->{panel}->show if $self->{itemsView}->getNbItems;
            $self->setNbItems;
            my $idField = $self->{model}->{commonFields}->{id};
            $self->{panel}->$idField($id);
        }
        else
        {
            my $previous = $self->{panel}->getAsHash;
            my @picFields = ();
            foreach my $field(@{$self->{model}->{fieldsNames}})
            {
                if ($self->{model}->{fieldsInfo}->{$field}->{type} eq 'image')
                {
                    push @picFields, $field;
                    next;
                }
                #next if ($field eq $cover);
                if (($self->{model}->{fieldsInfo}->{$field}->{imported} ne 'true')
                 || ($info->{$field} eq $ignore)
                 || ($info->{$field} eq ''))
                {
                    $info->{$field} = $previous->{$field};
                }
                else
                {
                    $self->{panel}->$field($info->{$field});
                }
            }
            my $title = $info->{$self->{model}->{commonFields}->{title}};
            my $imagePrefix = $self->{imagePrefix};
            foreach my $pic(@picFields)
            {
                if ($info->{$pic} && ($info->{$pic} ne $ignore))
                {
                    $self->checkPictureToBeRemoved($self->{panel}->$pic);
                    ($info->{$pic}, my $picture) = $self->downloadPicture($info->{$pic}, $title);
                    
                    # Only set the picture if one was returned. Otherwise the download was rejected, so stick with
                    # the existing picture
                    if ($info->{$pic})
                    {                        
                        $self->{panel}->$pic($info->{$pic})
                    }
                    else
                    {
                        $info->{$pic} = $ignore;
                    }
                }
                $info->{$pic} = $previous->{$pic} if $info->{$pic} eq $ignore;
            }
                        
            $self->{items}->updateSelectedItemInfoFromPanel(1);
            $self->{itemsView}->showCurrent;
        }
        $self->{panel}->dataChanged;
    }
    
    sub downloadPicture
    {
        my ($self, $pictureUrl, $title) = @_;
    
        $title ||= $self->{panel}->getValue($self->{model}->{commonFields}->{title});

        my ($name,$path,$suffix) = fileparse($pictureUrl, "\.gif", "\.jpg", "\.jpeg", "\.png");
        $suffix ||= $self->{defaultPictureSuffix};
        my $picture = $self->getUniqueImageFileName($suffix, $title);

        if ($pictureUrl =~ m|^http://|)
        {
            $self->setWaitCursor($self->{lang}->{StatusGetImage});
            GCUtils::downloadFile($pictureUrl, $picture, $self);
            $self->restoreCursor;
            
             # Check for file size of returned file. If it's less than 1000, we'll reject it, since it's
             # most likely a corrupt file
            my $filesize = -s $picture;
            if ($filesize < 1000)
            {
                unlink $picture;
                $picture = "";
            }
        }
        else
        {
            copy $pictureUrl, $picture;
        }
        $self->{items}->markToBeAdded($picture)
            if ($picture);
        return ($self->transformPicturePath($picture), $picture);
    }

    sub transformPicturePath
    {
        my ($self, $path, $file) = @_;
        return '' if !$path;
        $file ||= $self->{options}->file;
        $path = GCUtils::getDisplayedImage($path, $path, $file);
        my $dir = undef;
        $dir = dirname($file) if $file;
        return GCUtils::pathToUnix(File::Spec->rel2abs($path,$dir), 1)
            if !$self->{options}->useRelativePaths;
        return GCUtils::pathToUnix(File::Spec->abs2rel($path,$dir));
    }

    sub addBookmark
    {
        my $self = shift;
        
        my $dialog = $self->getDialog('BookmarkAdder');
        $dialog->setBookmark($self->{options}->file, $self->{items}->getInformation->{name});
        $dialog->setBookmarksFolders($self->{bookmarksLoader}->{bookmarks});
        if ($dialog->show)
        {
            $self->{bookmarksLoader}->save($dialog->getBookmarks);
        }
    }

    sub editBookmark
    {
        my $self = shift;
        
        #my $dialog = $self->getDialog('BookmarksEdit');
        my $dialog = new GCBookmarksEditDialog($self);
        
        $dialog->setBookmarksFolders($self->{bookmarksLoader}->{bookmarks});
        if ($dialog->show)
        {
            $self->{bookmarksLoader}->save($dialog->getBookmarks);
        }
    }

    sub addFileHistory
    {
        my ($self, $filename) = @_;

        $filename =~ s|/|\\|g if $^O =~ /win32/i;
        $self->{options}->historysize(5) if !$self->{options}->exists('historysize');
        my $maxSize = $self->{options}->historysize;
        my @historyArray = split(/\|/, $self->{options}->history);
        my $idx = 0;
        # Remove previous occurence in history if any
        foreach my $file(@historyArray)
        {
            if ($filename eq $file)
            {
                splice @historyArray, $idx, 1;
                last;
            }
            $idx++;
        }
        # Prepend filename
        splice @historyArray, 0, 0, $filename;
        # Shrink array if too big
        if (scalar @historyArray > $maxSize)
        {
            $#historyArray = $maxSize - 1;
        }
        $self->{options}->history(join '|', @historyArray);
        $self->{menubar}->{menuHistoryItem}->remove_submenu;
        $self->{menubar}->{menuHistory} = new Gtk2::Menu;
        $self->{menubar}->addHistoryMenu(\@historyArray);
    }
    
    sub openFile
    {
        my ($self, $filename) = @_;
        return if !$self->checkAndSave;
        my ($success, $error) = (1, undef);
        $self->initProgress($self->{lang}->{StatusLoad});
        $self->{openingFile} = 1;
        my $previousFile = $self->{options}->file;
        $self->setFile($filename);
        $self->savePreferences;
        my $previousModel;
        $previousModel = $self->{model}->getName
            if $self->{model};
        my @collectionVersion = split(/\./, $self->{items}->getVersion($filename));
        if (@collectionVersion)
        {
            my @softVersion = split (/\./, $self->{version});
    
            # We only use 2 major numbers. Last one should not impact data
            if (($collectionVersion[0] > $softVersion[0])
             || (($collectionVersion[0] == $softVersion[0])
              && ($collectionVersion[1] > $softVersion[1])))
            {
         	    my $dialog = Gtk2::MessageDialog->new($self,
                                                      [qw/modal destroy-with-parent/],
                                                      'warning',
                                                      'yes-no',
                                                      $self->{lang}->{OpenVersionWarning}
                                                     ."\n\n"
                                                     .$self->{lang}->{OpenVersionQuestion});
                $dialog->set_default_response('cancel');
                $dialog->set_position('center-on-parent');
                my $response = $dialog->run;
                $success = 0 if $response eq 'no';
                $dialog->destroy;
            }
        }

        if ($success)
        {
            ($success, $error) = $self->{items}->load($filename, $self, 1);
            if ($success)
            {
                $self->checkDefaultImage;
                $self->{filterSearch}->clear if $previousModel ne $self->{model}->getName;
                $self->refreshFilters;
                $self->viewAllItems;
                $self->addFileHistory($filename);
                $self->{options}->save;
                $self->selectFirst;
                $self->refreshTitle;
                $self->{menubar}->setLock($self->{items}->getLock);
                $self->endProgress;
            }
            else
            {
                my $dialog = new GCCriticalErrorDialog(
                    $self,
                    GCUtils::formatOpenSaveError(
                        $self->{lang},
                        $filename,
                        $error
                    )
                );
                $dialog->show;
            }
        }
        
        if (!$success)
        {
            if ($previousFile)
            {
                $self->openFile($previousFile);
            }
            else
            {
                $self->endProgress;
            }
        }
        $self->{openingFile} = 0;
        # Just to be sure
        $self->{saveIsNeeded} = 0;
    }

    sub openList
    {
        my $self = shift;
        my $fileDialog = new GCFileChooserDialog($self->{lang}->{OpenList}, $self, 'open', 1);
        $fileDialog->set_pattern_filter([$self->{lang}->{FileGCstarFiles}, '*.gcs']);

        $fileDialog->set_filename($self->{options}->file);
        my $response = $fileDialog->run;
        if ($response eq 'ok')
        {
            my $fileName = $fileDialog->get_filename;
            $fileDialog->destroy;
            $self->openFile($fileName);
        }
        else
        {
            $fileDialog->destroy;
        }
    }

    sub newList
    {
        my ($self, $modelName, $modelAlreadySet, $saveAlreadyDone) = @_;
        return if !$saveAlreadyDone && !$self->checkAndSave;

        if (!$modelAlreadySet)
        {
            if ($modelName)
            {
                $self->setCurrentModel(
                    $self->{modelsFactory}->getModel($modelName)
                );
            }
            else
            {
                if ($self->getDialog('Models')->show)
                {
                    if ($self->getDialog('Models')->isImporting)
                    {
                        $self->import($self->getDialog('Models')->getImporter);
                        return;
                    }
                    else
                    {
                        my $model = $self->getDialog('Models')->getModel;
                        if ($model->isEmpty)
                        {
                            $self->{model} = $model;
                            $self->editModel;
                        }
                        else
                        {
                            $self->setCurrentModel($model);
                        }
                    }
                }
                else
                {
                    return if !$self->{initializing};
                    $self->setCurrentModel('GCfilms');
                }
            }
        }

        $self->{items}->clearList;
        $self->reloadDone(1);
        $self->setFile('');
        $self->{menubar}->setAddBookmarkActive(0);
        $self->refreshTitle;
    }

    sub saveAs
    {
        my $self = shift;
        my $fileDialog = new GCFileChooserDialog($self->{lang}->{SaveList}, $self, 'save', 1, 1);
        $fileDialog->set_pattern_filter([$self->{lang}->{FileGCstarFiles}, '*.gcs']);
        $fileDialog->set_filename($self->{options}->file);
        my $response;
        while (1)
        {
            $response = $fileDialog->run;
            if ($response eq 'ok')
            {
                my $filename = $fileDialog->get_filename;
                my $previousFile = $self->{options}->file;
                my $prevImages = $self->getImagesDir;
                $self->setFile($filename);
                # We re-generate it because it could have changed with new file name
                my $newImages = $self->getImagesDir;
                if (($prevImages ne $newImages) || ($previousFile && ($previousFile ne $filename)))
                {
                    # The last parameter is for copy. When saving a new file, we move.
                    $self->{items}->setNewImagesDirectory($newImages, $prevImages,
                                                          $previousFile ? 1 : 0);
                    $self->{items}->setPreviousFile($previousFile)
                        if ($previousFile ne $filename);
                }
                if ($self->saveList)
                {
                    $self->addFileHistory($filename);
                    $self->{options}->save;
                    $self->refreshTitle;
                    last;
                }
                else
                {
                    $self->setFile($previousFile);
                }            
    		}
    		last if ($response ne 'ok')
        }
        $fileDialog->destroy;
        
        # Check if the user has cancelled the dialog without giving a filename, if so
        # return false to the save as request
        if ($response eq 'ok')
        {
            return 1;
        }
        else
        {
            return 0;
        }
    } 

    sub checkAndSave
    {
        my $self = shift;
        # Return value 1 means everything is OK.
        # 0 means the user clicked cancel for save confirmation and then
        # the process should be stopped.
        if (!$self->{items}->getNbItems)
        {
            $self->removeUpdatedMark;
            return 1;
        }
        $self->{items}->updateSelectedItemInfoFromPanel;
        return 1 if !$self->{saveIsNeeded};
        if (($self->{options}->autosave) && ($self->{options}->file))
        {
            $self->saveList;
            return 1;
        }
        my $dialog = Gtk2::MessageDialog->new($self,
                                              [qw/modal destroy-with-parent/],
                                              'warning',
                                              'none',
                                              $self->{lang}->{SaveUnsavedChanges});
        my $noButton = Gtk2::Button->new($self->{lang}->{SaveDontSave});
        $dialog->add_action_widget($noButton, 'no');
        my $cancelButton = Gtk2::Button->new_from_stock('gtk-cancel');
        $dialog->add_action_widget($cancelButton, 'cancel');
        my $saveButton = Gtk2::Button->new_from_stock('gtk-save');
        $saveButton->can_default(1);
        $dialog->add_action_widget($saveButton, 'yes');
        $noButton->show_all;
        $cancelButton->show_all;
        $saveButton->show_all;
        $dialog->set_default_response('yes');
        $dialog->set_position('center-on-parent');
        my $response = $dialog->run();
        $dialog->destroy;

        if ($response eq 'yes')
        {
            my $saveResponse = $self->saveList;
            # If save request has returned false, we need to cancel the current operation
            return 0 if (!$saveResponse);
        }
        
        
        return 0 if $response eq 'cancel';
        $self->removeUpdatedMark;

        return 1;
    }

    sub saveList
    {
        my ($self, $self2) = @_;
        $self = $self2 if $self2;
        my $response = 'yes';
        #$self->{itemsView}->{filter}->refilter;
        if ($self->{options}->file)
        {
            my ($success, $error) = $self->{items}->save($self);
            if ($success)
            {
                return 1;
            }
            else
            {
                my $dialog = Gtk2::MessageDialog->new($self,
                                              [qw/modal destroy-with-parent/],
                                              'error',
                                              'ok',
                                              GCUtils::formatOpenSaveError(
                                                $self->{lang},
                                                $self->{options}->file,
                                                $error
                                              ));
                $dialog->set_position('center-on-parent');
                $dialog->run();
                $dialog->destroy ;
                return 0;
            }
#            $self->{items}->save($self);
        }
        else
        {
            # Run save as dialog
            my $result = $self->saveAs;
            # If result of dialog is false, user has cancelled without choosing a filename, so we return false
            # to the save request to cancel operation
            if ($result)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
    }

    sub selectFirst
    {
        my $self = shift;

        $self->{items}->display($self->{items}->select(-1));
    }

    sub removeSearch
    {
        my ($self, $noRefresh) = @_;
        $self->setFilter('', '', $noRefresh);
        # Clear search mode
        $self->{filterSearch}->setMode;
        $self->{toolbar}->removeSearch
            if $self->{toolbar};
    }
    
    sub search
    {
        my ($self, $self2, $value) = @_;
        $self = $self2 if ($self2 ne 'all') && ($self2 ne 'displayed');
        $self->{items}->updateSelectedItemInfoFromPanel;
        $self->{items}->displayCurrent;
        my $type = 'all';
        $type = $value if ($self != $self2);

        $self->getDialog('Search')->show;
        
        my $info = $self->getDialog('Search')->search;
        return if ! $info;
        
        $self->{menubar}->selectAll if $type eq 'all';
        $self->setSearch($info);
    }
    
    sub advancedSearch
    {
        my $self = shift;
        my $dialog = $self->getDialog('AdvancedSearch');
        $dialog->initSearch($self->{filterSearch}->getCurrentSearch);
        $dialog->show;
        my $info = $dialog->search;
        return if ! $info;
        $self->setSearchWithTypes(info => $info,
                                  mode => $dialog->getMode,
                                  case => $dialog->getCase,
                                  ignoreDiacritics => $dialog->getIgnoreDiacritics);
    }

    sub addUserFilter
    {
        my ($self, $filter) = @_;
        $self->{model}->addUserFilter($filter);
        $self->{menubar}->createUserFilters($self->{model});
        $self->{toolbar}->createUserFilters($self->{model});
    }

    sub saveCurrentSearch
    {
        my $self = shift;
        my $dialog = $self->getDialog('AdvancedSearch');
        $dialog->initSearch($self->{filterSearch}->getCurrentSearch);
        $dialog->saveSearch;
    }

    sub editSavedSearches
    {
        my $self = shift;
        my $dialog = $self->getDialog('UserFilters');
        $self->{model}->saveUserFilters;
        $dialog->setModel($self->{model});
        if ($dialog->show)
        {
            $self->{model}->setUserFilters($dialog->getUserFilters);
            $self->{model}->deleteUserFilters($dialog->getDeletedFilters);
            $self->{menubar}->createUserFilters($self->{model});
            $self->{toolbar}->createUserFilters($self->{model});
        }
    }

    sub showBorrowed
    {
        my $self = shift;
        $self->{items}->updateSelectedItemInfoFromPanel;
        $self->getDialog('Borrowed')->setList($self->{items}, $self->{model});
        $self->getDialog('Borrowed')->show;
    }
    
    sub export
    {
        my ($self, $exporter) = @_;
        $self->getDialog('Export')->setModule($exporter);
        $self->getDialog('Export')->show;
    }

    sub import
    {
        my ($self, $importer) = @_;
        $self->getDialog('Import')->setModule($importer);
        $self->getDialog('Import')->show;
    }

    sub importWithDetect
    {
        my ($self, $file, $realPath) = @_;

        if (!$realPath)
        {
            $file =~ s/^file:\/\/(.*)\W*$/$1/;
            $file =~ s/.$//ms;
        }
        
        foreach my $importer(@GCImport::importersArray)
        {
            my $current = $importer->getSuffix;
            next if !$current;
            #if ($current eq $suffix)
            if ($file =~ /$current$/)
            {
                $self->setWaitCursor($self->{lang}->{StatusGetInfo});
                my %options;
                $options{parent} = $self;
                $options{newList} = 0;
                $options{file} = $file;
                $options{lang} = $self->{lang};
                $importer->process(\%options);
                #$self->restoreCursor;
                return 1;
            }
        }
        return 0;
    }

    sub optionsError
    {
        my ($self, $type, $errmsg) = @_;

        my $msg;
        if ($type eq 'open')
        {
            $msg = $self->{lang}->{OptionsOpenError};
        }
        elsif ($type eq 'create')
        {
            $msg = $self->{lang}->{OptionsCreateError};
        }
        else
        {
            $msg = $self->{lang}->{OptionsSaveError};
        }
            
        my $dialog = Gtk2::MessageDialog->new($self,
                                              [qw/modal destroy-with-parent/],
                                              'error',
                                              'ok',
                                              $msg.$self->{options}->{file}."\n$errmsg");

        $dialog->set_position('center-on-parent');
        $dialog->run();
        $dialog->destroy ;

        $self->destroy;
    }

    sub checkImagesDirectory
    {
        my ($self, $withDialog) = @_;
        my $error = 0;
        my $imagesDir = $self->getImagesDir;
        if ( ! -e $imagesDir)
        {
            eval {mkpath $imagesDir};
            $error = 1 if (! -e $imagesDir) && (-e $self->{options}->file);
        }
        else
        {
            #$error = 1 if !( -d _ && -r _ && -w _ && -x _ )
            # _ cannot be used when filtest access is on
            $error = 1 if !( -d $imagesDir && -r $imagesDir && -w $imagesDir && -x $imagesDir );
        }
        if ($error)
        {
            my $itemsImagesDir = '';
            $itemsImagesDir = $self->{items}->getInformation->{images}
                if $self->{items};
            if ($itemsImagesDir)
            {
                # Problem was because of a specific image dir, we clear it
                $self->{items}->getInformation->{images} = '';
                # And we check again
                $error = $self->checkImagesDirectory(0);
            }
        }
        return $error if !$withDialog;
        if ($error)
        {
            $self->{splash}->hide if $self->{splash};
            my $fileDialog = new GCFileChooserDialog($self->{lang}->{FileChooserOpenDirectory}, $self, 'select-folder');
            my  $errorDialog = Gtk2::MessageDialog->new($self,
						   [qw/modal destroy-with-parent/],
						   'error',
						   'ok',
						   $self->{lang}->{ImageError});

            $errorDialog->set_position('center-on-parent');
            $fileDialog->set_filename($imagesDir);
            my $response;
            do
            {
                $errorDialog->run();
                $errorDialog->hide();
                $response = '';
                $response = $fileDialog->run;
                exit 1 if $response ne 'ok';
                $self->{options}->images($fileDialog->get_filename);
            } while ($self->checkImagesDirectory(0));
            $errorDialog->destroy;
            $fileDialog->destroy;
        }
        return $error;
    }

    sub setFile
    {
        my ($self, $filename) = @_;

        $self->{options}->file($filename);
        $self->{menubar}->setAddBookmarkActive($filename ne '');
    }
    
    sub refreshTitle
    {
        my $self = shift;
        my $name = '';
        if ($self->{options}->file)
        {
            $name = $self->{items}->getInformation->{name}
                if $self->{items};
            $name ||= basename($self->{options}->file);
        }
        else
        {
            $name = $self->{lang}->{UnsavedCollection};
        }
        $self->{windowTitle} = $name.' - GCstar';
        $self->set_title($self->{windowTitle});
    }

    sub properties
    {
        my $self = shift;
        
        my $prevImages = $self->getImagesDir;

        my $dialog = $self->getDialog('Properties');
        $dialog->setProperties($self->{items}->getInformation,
                               $self->{options}->file,
                               $self->{items}->getNbItems);
        if ($dialog->show)
        {
            $self->{items}->setInformation($dialog->getProperties);
            $self->checkDefaultImage;
            $self->refreshTitle;
            # We check if it has changed
            my $newImages = $self->getImagesDir;
            if ($prevImages ne $newImages)
            {
                # Here we want to move pictures
                $self->{items}->setNewImagesDirectory($newImages, $prevImages, 0);
            }
            $self->checkSpellChecking;
            #$self->moveImages($prevImages, $self->{items}->getInformation->{images});
            $self->markAsUpdated;
        }
    }

    sub markAsUpdated
    {
        my $self = shift;
        $self->{saveIsNeeded} = 1;
        $self->set_title('*'.$self->{windowTitle});
        $self->{menubar}->setSaveActive(1);
        $self->{toolbar}->setSaveActive(1);
    }

    sub removeUpdatedMark
    {
        my $self = shift;
        $self->{saveIsNeeded} = 0;
        $self->set_title($self->{windowTitle});
        $self->{menubar}->setSaveActive(0);
        $self->{toolbar}->setSaveActive(0);

        # Make sure the panel status is resetted
        for my $field (@{$self->{model}->{fieldsNotFormatted}})
        {
            $self->{panel}->{$field}->resetChanged
                if $self->{panel}->{$field};
        }
        $GCGraphicComponent::somethingChanged = 0;
    }

    sub refreshFilters
    {
        my $self = shift;
        $self->{menubar}->refreshFilters;
    }

    sub setWaitCursor
    {
        my ($self, $message) = @_;
        $self->setStatus($message);
        $self->window->set_cursor(Gtk2::Gdk::Cursor->new('watch'));
        GCUtils::updateUI;
    }
    sub restoreCursor
    {
        my $self = shift;
        $self->restoreStatus;
        $self->window->set_cursor(Gtk2::Gdk::Cursor->new('left_ptr'));
        GCUtils::updateUI;
    }

    sub setFilter
    {
        my ($self, $filter, $parameter, $noRefresh) = @_;
        $self->{items}->updateSelectedItemInfoFromPanel(1);
        $self->{filterSearch}->setFilter($filter, $parameter,
                                         $self->{model}->getFilterType($filter),
                                         $self->{model});
        $self->filter(1) unless $noRefresh;
    }

    sub setQuickSearch
    {
        my ($self, $field, $value) = @_;
        $self->{items}->updateSelectedItemInfoFromPanel(1);
        my $isNumeric = ($self->{model}->{fieldsInfo}->{$field}->{type} eq 'number');
        $self->{filterSearch}->setFilter($field, $value,
                                         ['contain', $isNumeric, undef],
                                         $self->{model});
        $self->filter(1);
    }

    sub setSearch
    {
        my ($self, $info) = @_;        
        $self->{filterSearch}->clear;
        $self->{filterSearch}->setFilter($_,
                                         $info->{$_},
                                         $self->{model}->getFilterType($_),
                                         $self->{model})
            foreach (keys %$info);

        $self->filter(1);
    }

    sub setSearchWithTypes
    {
        my ($self, %searchParameters) = @_;
        
        $self->{filterSearch}->clear;
        $self->{filterSearch}->setMode($searchParameters{mode});
        $self->{filterSearch}->setCase($searchParameters{case});
        $self->{filterSearch}->setIgnoreDiacritics($searchParameters{ignoreDiacritics});
        foreach (@{$searchParameters{info}})
        {
            $self->{filterSearch}->setFilter($_->{field},
                                             $_->{value},
                                             $_->{filter},
                                             $self->{model},
                                             1);
        }
        $self->filter(1);
        #$self->{filterSearch}->removeTemporaryFilters;

        # What's the point of this line? It clears the filter mode so all filters return to "and" types
        # resulting in filtered exports giving unexpected results.
        # Removed 28/10/2009 by zombiepig, but I'm not sure if there'll be unexpected side effects
        # $self->{filterSearch}->setMode;
    }

    sub checkPanelVisibility
    {
        my $self = shift;
        if ($self->{itemsView}->getNbItems)
        {
            $self->{panel}->show;
        }
        else
        {
            $self->{panel}->hide(1);
        }
    }

    sub filter
    {
        my ($self, $refresh, $splash) = @_;
        $self->{filterSearch}->setModel($self->{model});
        my $current = $self->{itemsView}->setFilter($self->{filterSearch},
                                                    $self->{items}->getItemsListFiltered,
                                                    $refresh,
                                                    $splash);
        $self->{items}->display($current);
        $self->{itemsView}->select($current, 1);
    
        $self->checkPanelVisibility;    
        
        $self->setNbItems;
    }

    sub reloadDone
    {
        my ($self, $noFilter, $splash) = @_;
        my $reloadOnDone = $self->{initializing};
        my $needFilter = ! ($reloadOnDone || $noFilter);
        if ($self->{itemsView})
        {
            $self->{itemsView}->setSortOrder(undef, $splash, $needFilter);
            $self->{itemsView}->done($splash, $reloadOnDone);
        }
        $self->filter(1, $splash) if $needFilter;
        $self->setNbItems;
    }

    sub getDialog
    {
        my ($self, $name) = @_;

        if ($name eq 'PluginsAsk')
        {
            $self->{PluginsAskDialog} = new GCPluginsDialog($self)
                if !$self->{PluginsAskDialog};
        }
        elsif ($name eq 'MultiSite')
        {
            $self->{MultiSiteDialog}->{$self->{model}->getName} = new GCMultiSiteDialog($self, $self->{model})
                if !$self->{MultiSiteDialog}->{$self->{model}->getName};
            return $self->{MultiSiteDialog}->{$self->{model}->getName};
        }
        
        elsif ($name eq 'MultiSitePerField')
        {
            $self->{MultiSitePerFieldDialog}->{$self->{model}->getName} = new GCMultiSitePerFieldDialog($self, $self->{model},1)
                if !$self->{MultiSitePerFieldDialog}->{$self->{model}->getName};
            return $self->{MultiSitePerFieldDialog}->{$self->{model}->getName};
        }
        elsif ($name eq 'About')
        {
            $self->{AboutDialog} = new GCAboutDialog($self, $self->{version})
                if ! $self->{AboutDialog};
        }
        elsif ($name eq 'Models')
        {
            $self->{ModelsDialog} = new GCModelsDialog($self,
                                                       $self->{modelsFactory},
                                                       1)
                if ! $self->{ModelsDialog};
        }
        else
        {
            my $className = 'GC'.$name.'Dialog';
            if (! $self->{$name.'Dialog'})
            {
                $self->{$name.'Dialog'} = new $className($self);
                # Actually Plugins, Export and Import don't need the parameter, but
                # it has no impact and make the code more simple
                $self->{$name.'Dialog'}->setModel($self->{model})
                    if $name =~ /^(AdvancedSearch|Search|Options|QueryReplace|Plugins|Export|Import)$/
                    && $self->{model};
            }
        }

        return $self->{$name.'Dialog'};
    }

    sub options
    {
        my ($self, $self2,$tabToShow) = @_;
        $self = $self2 if $self2;
        my $transform = $self->{options}->transform;
        my $articles = $self->{options}->articles;
        my $formats = $self->{options}->formats;
        my $layout = $self->{model}->{preferences}->layout;
        my $panelStyle = $self->{options}->panelStyle;
        my $toolbar = $self->{options}->toolbar;
        my $toolbarPosition = $self->{options}->toolbarPosition;
        my $prevImages = $self->getImagesDir;
        my $expandersMode = $self->{options}->expandersMode;
        my $dateFormat = $self->{options}->dateFormat;
        my $spellCheck = $self->{options}->spellCheck;
        my $imageEditor = $self->{options}->imageEditor;
        my $programs = $self->{options}->programs;
        my $useStars = $self->{options}->useStars;

        $self->savePreferences;

        $self->getDialog('Options')->show($tabToShow);

        my $newImages = $self->getImagesDir;
        if ($prevImages ne $newImages)
        {
            # Here we want to move pictures
            $self->{items}->setNewImagesDirectory($newImages, $prevImages, 0);
            $self->markAsUpdated;
        }

        $self->checkTransform
            if ($self->{options}->articles ne $articles)
            || ($self->{options}->transform != $transform);

        # Need to reload the panel if the layout or style has changed
        $self->changePanel(0,0)
            if ($self->{model}->{preferences}->layout ne $layout)
            || ($self->{options}->panelStyle ne $panelStyle)
            || ($self->{options}->useStars ne $useStars);

        $self->{panel}->setExpandersMode($self->{options}->expandersMode)
            if $expandersMode ne $self->{options}->expandersMode;
    
        if ($dateFormat ne $self->{options}->dateFormat)
        {
            $self->{panel}->setDateFormat($self->{options}->dateFormat);
            
            # TODO We could optimize this with a method setDateFormat on
            # items view that would only change what needed
           if  ($self->{itemsView}                              # We have a view
            && ($self->{itemsView}->isUsingDate)                # It uses the date format
            && (!$self->getDialog('Options')->{viewChanged}))   # And we didn't already change it
           {
                $self->setItemsList(0, 1);                      # Then we re-create it
           }
        }

        if ($spellCheck ne $self->{options}->spellCheck)
        {
            $self->checkSpellChecking;
        }

        $self->checkToolbarPosition
            if ($self->{options}->toolbarPosition ne $toolbarPosition) || ($self->{options}->toolbar ne $toolbar);
            
        $self->{menubar}->setDisplayToolbarState($self->{options}->toolbar == 0 ? 0 : 1)
            if $self->{options}->toolbar != $toolbar;

        $self->checkPlugin;
        $self->checkView;
        #$self->checkToolbarOptions
    }
    
    sub displayOptions
    {
        my ($self, $self2) = @_;
        $self = $self2 if $self2;

        my $dialog = $self->getDialog('DisplayOptions');
        my $hidden = $self->{model}->{preferences}->hidden;
        $dialog->show;
        if ($self->{model}->{preferences}->hidden ne $hidden)
        {
            $self->checkPanelContent;
            $self->markAsUpdated
                if $self->{model}->isInline;
        }
            
    }

    sub toolbarOptions
    {
        my ($self, $self2) = @_;
        $self = $self2 if $self2;

        my $dialog = $self->getDialog('ToolbarOptions');
        if ($dialog->show eq 'ok')
        {
            $self->removeToolbar;
            $self->{toolbar}->destroy;
            $self->{toolbar} = GCToolBar->new($self);
            $self->{toolbar}->setModel($self->{model})
                if $self->{model};
            $self->checkToolbarOptions;
            $self->checkToolbarPosition(1);
        }
    }
    
    sub getUserModelsDirError
    {
        my $self = shift;
        return $self->{lang}->{ErrorModelUserDir}
              .$self->{modelsFactory}->{persoDirectory};
    }

    sub setCurrentModel
    {
        my ($self, $model) = @_;
        $model = 'GCfilms' if ! $model;
        $self->savePreferences;
        $self->{model}->save if $self->{model} && (ref($self->{model}) ne 'HASH');
        if ((ref $model) =~ /GCModelLoader/)
        {
            $self->{model} = $model;
        }
        else
        {
            $self->{model} = $self->{modelsFactory}->getModel($model)
        }
        if (!$self->{model})
        {
            return 0;
        }
        $self->{items}->initModel($self->{model});
        return 1;
    }

    sub preloadModel
    {
        my ($self, $model) = @_;
        # Preload the model into the factory cache
        $self->{modelsFactory}->getModel($model);
    }

    sub setCurrentModelFromInline
    {
        my ($self, $container) = @_;
        my $model = GCModelLoader->newFromInline($self, $container);
        $self->setCurrentModel($model);
    }

    sub addFieldsToDefaultModel
    {
        my ($self, $inlineModel) = @_;
        my $model = GCModelLoader->newFromInline($self, {inlineModel => $inlineModel, defaultModifier => 1});
        $self->{model}->addFields($model);
        $self->notifyModelChange;
    }

    sub setGrouping
    {
        my ($self, $field) = @_;
        # Automatically switch to detailed list if the current one is text list
        $self->{options}->view(2)
            if $self->{options}->view == 0;
        $self->{model}->{preferences}->groupBy($field);
        $self->setItemsList(0);
    }

    sub setLock
    {
        my ($self, $value) = @_;
        $self->{items}->setLock($value);
        $self->{panel}->changeState($self->{panel}, $value);
        $self->markAsUpdated;
    }

    sub notifyModelChange
    {
        my ($self, $modelUpdated) = @_;

        # Might need to recreate the Tonight window
        $self->{remakeItemWindow}->{random} = 1
  	             if exists($self->{itemWindow}->{random});
        $self->{remakeItemWindow}->{item} = 1
  	             if exists($self->{itemWindow}->{item}); 
        $self->{remakeItemWindow}->{defaultValues} = 1
  	             if exists($self->{itemWindow}->{defaultValues}); 
  	             
        # Update strings to reflect model change
        $self->GCLang::updateModelSpecificStrings;
        
        #We deactivate some updates
        my $previousInitializing = $self->{initializing};
        $self->{initializing} = 1;
        $self->checkDefaultImage;
        $self->setItemsList(1, 1);
        $self->getDialog('DisplayOptions')->createContent($self->{model});
        $self->changePanel(1, $modelUpdated);
        if (%{$self->{panel}})
        {
            $self->{panel}->createContent($self->{model});
            $self->{panel}->deactivate if $self->{items}->getLock;
        }
        $self->{menubar}->setModel($self->{model});
        $self->{toolbar}->setModel($self->{model});
        # Update strings in dialogs if needed
        $self->updateDialogStrings;
        $self->checkToolbarOptions;        

        $self->getDialog('Search')->setModel($self->{model})
            if $self->{SearchDialog};
        $self->getDialog('AdvancedSearch')->setModel($self->{model})
            if $self->{AdvancedSearchDialog};
        $self->getDialog('Options')->setModel($self->{model})
            if $self->{OptionsDialog};
        $self->getDialog('QueryReplace')->setModel($self->{model})
            if $self->{QueryReplaceDialog};
        $self->getDialog('Plugins')->setModel
            if $self->{PluginsDialog};
        $self->getDialog('ImportFields')->setModel($self->{model})
            if $self->{ImportFieldsDialog};
        $self->getDialog('Export')->setModel
            if $self->{ExportDialog};
        $self->getDialog('Import')->setModel
            if $self->{ImportDialog};

        $self->checkPlugin;
        
        $self->{initializing} = $previousInitializing;
    }
    
    sub updateDialogStrings
    {
        my $self = shift;
        
        # Update model-specific text strings in dialog boxes
        $self->getDialog('Properties')->{info}->{itemsLabel}->set_label($self->{lang}->{PropertiesItemsNumber});
        $self->getDialog('Borrowed')->set_title($self->{lang}->{BorrowedTitle});
        $self->getDialog('Borrowed')->{returned}->get_children->set_label($self->{lang}->{PanelReturned});
        $self->getDialog('Borrowed')->{display}->get_children->set_label($self->{lang}->{BorrowedDisplayInPanel});
        $self->getDialog('Search')->set_title($self->{lang}->{SearchTitle});
        $self->getDialog('AdvancedSearch')->set_title($self->{lang}->{SearchTitle});
    }

    sub editModel
    {
        my $self = shift;
        my $dialog = $self->getDialog('ModelsSettings');
        my $isPersonal = $self->{model}->isPersonal;
        $dialog->setPersonalMode($isPersonal);
        $dialog->setDescription($self->{model}->getDescription);
        if ($isPersonal)
        {
            $dialog->initFields($self->{model}->getOriginalCollection->{fields}->{field},
                                $self->{model}->getGroups,
                                $self->{model}->getCommonFields,
                                $self->{model}->{hasLending},
                                $self->{model}->{hasTags});
            $dialog->initFilters($self->{model}->{filters});
        }
        else
        {
            $dialog->initFields($self->{model}->getAddedFields,
                                $self->{model}->getAddedGroups);            
        }
        if ($dialog->show)
        {
            $self->markAsUpdated;
            if ($isPersonal)
            {
                my $file;
                ($self->{model}->{collection}->{description}, $self->{model}->{collection}->{name}, $file)
                 = $dialog->getName;
    
                my %fields = (
                    id => $dialog->getIdField,
                    title => $dialog->getTitleField,
                    cover => $dialog->getCoverField,
                    play => $dialog->getPlayField,
                );
                $self->{model}->setOptions(\%fields, 'no.png');
                $self->{model}->setGroups($dialog->getGroups);
                $self->{model}->setFields($dialog->{fields}, $dialog->hasLending, $dialog->hasTags);
                $self->{model}->setFilters($dialog->getFilters($self->{model}->{fieldsInfo}));
                if ($self->{model}->{collection}->{name})
                {
                    $self->{model}->saveToFile($file);
                    # This is done twice, because the 1st time the model thought it is online
                    $self->{model}->loadPreferences;
                }
            }
            else
            {
                $self->{model}->updateAddedFields($dialog->{fields}, $dialog->getGroups);
            }
            #$self->notifyModelChange;
            $self->{items}->initModel($self->{model}, 1);
            $self->reloadList;
        }
    }

    sub borrowers
    {
        my ($self, $self2) = @_;
        $self = $self2 if $self2;

        $self->getDialog('Borrowers')->show;
        $self->checkBorrowers;
        # Some models could use the borrower as a filter
        # TODO only refresh filters when needed (see previous line)
        $self->refreshFilters;
    }

#    sub genresConversion
#    {
#        my ($self, $self2) = @_;
#        $self = $self2 if $self2;
#
#        $self->getDialog('GenresGroups')->show;
#    }
    
    sub queryReplace
    {
        my ($self, $self2) = @_;
        $self = $self2 if $self2;

        if ($self->getDialog('QueryReplace')->show)
        {
            $self->{items}->queryReplace($self->getDialog('QueryReplace')->{field},
                                         $self->getDialog('QueryReplace')->{oldValue},
                                         $self->getDialog('QueryReplace')->{newValue},
                                         $self->getDialog('QueryReplace')->{caseSensitive});
            $self->markAsUpdated;
        }
    }

    sub about
    {
        my $self = shift;

        $self->getDialog('About')->show;
    }

    sub stats
    {
        my $self = shift;
        my $dialog = $self->getDialog('Stats');
        (my $title = $self->{windowTitle}) =~ s/ - GCstar$//;
        $dialog->setData($self->{model}, $self->{items}->getItemsListFiltered, $title);
        $dialog->show;
        #my $dialog = new GCStatsDialog($self);
        #$dialog->setData($self->{model}, $self->{items}->getItemsListFiltered);
        #$dialog->show;
    }

    sub showDependencies
    {
        my $self = shift;
        $self->getDialog('Dependencies')->show;
    }

    sub showAllPlugins
    {
        my $self = shift;
        $self->getDialog('AllPlugins')->show;
    }

    sub help
    {
        my ($self, $self2) = @_;
        $self = $self2 if $self2;

        $self->launch('http://wiki.gcstar.org/', 'url');
    }

    sub reportBug
    {
        my ($self, $self2, $subject, $message) = @_;
        $self = $self2 if $self2;

        my %topicIds = (
            EN => '4',
            FR => '9'
        );
        
        my $id = $topicIds{$self->{options}->lang} || $topicIds{EN};

        my $url;
        if ($message)
        {
            # TODO: Move this part across to launchpad when https://bugs.launchpad.net/malone/+bug/552142 is fixed
            $url = 'http://forums.gcstar.org/postbug.php?req_subject='.uri_escape($subject).'&req_message='.uri_escape($message).'&fid='.$id;
            $url =~ s/\(/%28/g;
            $url =~ s/\)/%29/g;
        }
        else
        {
            $url = 'https://bugs.launchpad.net/gcstar/+filebug';
        }
        $self->launch($url, 'url');
    }

    sub playItem
    {
        my $self = shift;
        my $field = $self->{model}->{commonFields}->{play};
        my $format = $self->{model}->{fieldsInfo}->{$field}->{format};
        $self->launch($self->{panel}->$field, $format);
    }

    sub launch
    {
        my ($self, $file, $format, $withParams, $windowParent) = @_;
        
        $format ||= 'program';
        my $command;
        # For image, we have an internal viewer
        if ($format eq 'image')
        {
            $file = GCUtils::getDisplayedImage($file, '', $self->{options}->file);
            my $dialog = new GCImageDialog($self, $file, $windowParent);
            $dialog->show;
            $dialog->destroy;

            if ((exists $self->{itemWindow}->{item}) && ($self->{itemWindow}->{item}->visible))
            {
                $self->{itemWindow}->{item}->showMe;
            } 
            return;
        }
        elsif ($format eq 'program')
        {
           if ($^O =~ /win32/i)
            {
                # Encode filename to work with foreign characters
				$file = Encode::encode("iso-8859-1", $file);

                if ($withParams)
                {
                    $command = $file;
                }
                else
                {
                    $file =~ s/([^\\])"/$1\\"/g;
                    $command = '"'.$file.'"';
                }
            }
            else
            {
                $command = $file;
            }
        }
        else
        {
            # For the other ones, we use external programs

            if ($self->{options}->programs eq 'user')
            {
                $command = $self->{options}->browser if $format eq 'url';
                $command = $self->{options}->player if $format eq 'video';
                $command = $self->{options}->audio if $format eq 'audio';
            }
            
            # If using system default programs, or user has not overriden system default
            if (( $self->{options}->programs eq 'system' ) || ( !$command ))
            {
                $command = ($^O =~ /win32/i) ? ''
                         : ($^O =~ /macos/i) ? '/usr/bin/open'
                         :                     $ENV{GCS_SHARE_DIR}.'/helpers/xdg-open';
            }

            if ($file && ($format ne 'url'))
            {
                if ($file !~ /^(http|ftp)/)
                {
                    my $dialog;

                    # Encode filename to work with foreign characters under Win32
    				$file = Encode::encode("iso-8859-1", $file) if ($^O =~ /win32/i);

                    while (! -e $file)
                    {
                        if (!$dialog)
                        {
                            $dialog = Gtk2::MessageDialog->new($self,
                                [qw/modal destroy-with-parent/],
                                'warning',
                                'none',
                                $self->{lang}->{PlayFileNotFound}."\n\n".$file);
                            my $cancelButton = Gtk2::Button->new_from_stock('gtk-cancel');
                            $dialog->add_action_widget($cancelButton, 'cancel');
                            my $retryButton = Gtk2::Button->new($self->{lang}->{PlayRetry});
                            $retryButton->can_default(1);
                            $dialog->add_action_widget($retryButton, 'yes');
                            $cancelButton->show_all;
                            $retryButton->show_all;
                            $dialog->set_default_response('yes');
                            $dialog->set_position('center-on-parent');
                        }
                        my $response = $dialog->run;
                        last if $response eq 'cancel';
                    }
                    $dialog->destroy if $dialog;
                    return if ! -e $file;
                }
            }

            if ($^O =~ /win32/i)
            {
                $command = '"'.$command.'"' if $command;
                $file =~ s/([^\\])"/$1\\"/g;
                $command .= ' "'.$file.'"';
            }
            else
            {
                $file =~ s/([^\\])"/$1\\"/g;
                #"
                $command .= ' "'.$file.'"';
            }

        }

        return if !$command;
        # Finalize the command line
        if ($^O =~ /win32/i)
        {
            system("start \"\" $command");
        }
        else
        {
            system "$command &";
        }
        if ($ENV{GCS_SET_FAVOURITE_AFTER_PLAY})
        {
            my $current = $self->{panel}->favourite;
            $self->{panel}->favourite($current ? 0 : 1);
            $self->{items}->updateSelectedItemInfoFromPanel(1);
        }
    }

    sub sendBorrowerEmail
    {
        my ($self, $info) = @_;

        $self->{mailer} = new GCMailer($self) if ! $self->{mailer};
        $self->{mailer}->sendBorrowerEmail($info);
    }

    sub extractInfo
    {
        my ($self, $file, $panel) = @_;
        
        my $infoExtractor = $self->{model}->getExtracter($self, $file, $panel, $self->{model});
        #$self->getDialog('Extract')->setInfo($infoExtractor->getInfo, $panel);
        #$self->getDialog('Extract')->show;
        my $dialog = new GCExtractDialog($self, $self->{model}, $infoExtractor);
        $dialog->setInfo($infoExtractor, $panel);
        $dialog->show;
    }

    sub setStatus
    {
        my ($self, $status) = @_;
        $self->{status}->push(1, $status) if ($self->{status});
    }
    
    sub restoreStatus
    {
        my $self = shift;
        $self->{status}->pop(1);
    }

    sub setNbItems
    {
        my $self = shift;

        return if !$self->{itemsView};
        my $number = $self->{itemsView}->getNbItems;
        my $status = " $number ".$self->{model}->getDisplayedItems($number);
        $self->setStatus($status);
    }

    sub updateSelectedItemInfoFromGivenPanelAndSelect
    {
        my ($self, $panel, $idx) = @_;
        $self->{items}->updateSelectedItemInfoFromGivenPanel($panel);
        $self->{items}->displayInPanel($self->{panel}, $idx);
        #Init combo boxes
        foreach(@{$self->{model}->{fieldsHistory}})
        {
            $self->{panel}->{$_}->setValues($panel->getValues($_));
        }
    }

    sub display
    {
        my ($self, @idx) = @_;
        if ($self->{items}->display(@idx))
        {
            $self->setNbItems;
        }
    }
    
    sub getItemWindow
    {
        my ($self, $type) = @_;

        my $created = 0;
        
        if ((! exists $self->{itemWindow}->{$type}) || ($self->{remakeItemWindow}->{$type}))
        {
            $self->{itemWindow}->{$type}->destroy
                if exists $self->{itemWindow}->{$type};
                
            $self->{itemWindow}->{$type} = 
                ($type eq 'item')          ? new GCItemWindow($self, "") :
                ($type eq 'random')        ? new GCRandomItemWindow($self, "") :
                ($type eq 'defaultValues') ? new GCDefaultValuesWindow($self, "") :
                                             undef;
  	        $created = 1;      
  	        $self->{remakeItemWindow}->{$type} = 0
        }

        my $window = $self->{itemWindow}->{$type};

        if ($created && $self->{options}->exists('itemWindowWidth'))
        {
            $window->set_default_size(
                $self->{options}->itemWindowWidth,
                $self->{options}->itemWindowHeight
            );
        }

        if ($self->{previousWindowPosition})
        {
            $window->move($self->{previousWindowPosition}->{x},
                          $self->{previousWindowPosition}->{y});
        }
        $window->{panel}->setBorrowers;
        $window->{panel}->disableBorrowerChange;
        
        return $window;
    }

    sub saveItemWindowSettings
    {
        my ($self, $window) = @_;
        
        my ($width, $height) = $window->get_size;
        $self->{options}->itemWindowWidth($width);
        $self->{options}->itemWindowHeight($height);

        ($self->{previousWindowPosition}->{x}, $self->{previousWindowPosition}->{y})
            = $window->get_position;
    }
    
    sub displayInWindow
    {
        my ($self, $idx, $type, $select) = @_;
        
        $type ||= 'item';

        my $title = $self->{items}->getTitle($idx);

        my $window = $self->getItemWindow($type);
        $window->setTitle($title);

        $self->{items}->displayInPanel($window->{panel}, $idx);
        $window->{panel}->selectTitle if $select;
        
        my $code = $window->show;

        if (($type eq 'item') && ($code eq 'ok'))
        {
            $self->updateSelectedItemInfoFromGivenPanelAndSelect($window->{panel}, $idx);
            $self->refreshFilters;
        }

        $self->saveItemWindowSettings($window);

        $window->hide;
        
        return $code;
    }

    sub randomItem
    {
        my ($self) = @_;
        my @tmpArray = undef;
        $self->{items}->updateSelectedItemInfoFromPanel;
        
        my $message = '';

        #Initialize items array.
        $self->{randomPool} = [];
        my $realId = 0;
        my $filterSearch = new GCFilterSearch;
        foreach my $filter(@{$self->{model}->{random}})
        {
            $filterSearch->setFilter($filter->{field},
                                     $filter->{value},
                                     [$filter->{comparison}, $filter->{numeric}],
                                     $self->{model});
        }

        foreach (@{$self->{items}->getItemsListFiltered})
        {
            #if (!$_->{seen})
            if ($filterSearch->test($_))
            {
                $_->{realId} = $realId;
                push @{$self->{randomPool}}, $_;
            }
            $realId++;
        }
 
        if (scalar @{$self->{randomPool}} > 0)
        {
            my $code = 'no';
            my $idx = 0;
            while ($code eq 'no')
            {
        	   $idx = int rand(scalar @{$self->{randomPool}});
        	   $realId = $self->{randomPool}->[$idx]->{realId};
        	   $code = $self->displayInWindow($realId, 'random');
        	   splice @{$self->{randomPool}}, $idx, 1;
        	   last if ! @{$self->{randomPool}};
            }
            $message = $self->{lang}->{RandomEnd} if $code eq 'no';
            if ($code eq 'ok')
            {
                foreach my $filter(@{$self->{model}->{random}})
                {
                    next if !exists $filter->{after};
                    my $field = $filter->{field};
                    ($self->{items}->getItemsListFiltered)->[$realId]->{$field} = $filter->{after};
                    $self->{panel}->$field($filter->{after})
                        if $self->{items}->{currentItem} == $realId;
                }
            }
        }
    	else
    	{
    	   $message = $self->{lang}->{RandomError};
    	}

        if ($message)
        {
            my $dialog = Gtk2::MessageDialog->new($self,
    		  	                                 [qw/modal destroy-with-parent/],
                                                'info',
                                                  'ok',
                                                  $message);
            $dialog->set_position('center-on-parent');
    		$dialog->run();
	       	$dialog->destroy;
        }
        
        #Clean items array.
        foreach (@{$self->{items}->getItemsListFiltered})
        {
            delete $_->{realId};
        }
    }
    
    sub setSensitive
    {
        my ($self, $sensitive) = @_;
        $self->{menubar}->set_sensitive($sensitive);
        $self->{toolbar}->set_sensitive($sensitive);
        $self->{pane}->set_sensitive($sensitive);
    }
    
    sub initProgress
    {
        my ($self, $label) = @_;
        if ($label)
        {
            $self->setStatus($label);
            $self->{restoreNeeded} = 1;
        }
        return if $self->{openingFile};
        $self->setProgress(0.0);
        $self->setSensitive(0);
    }

    sub endProgress
    {
        my $self = shift;
        $self->setProgress(1.0);
        if ($self->{restoreNeeded})
        {
            $self->{restoreNeeded} = 0;
            $self->restoreStatus;
        }
        Glib::Timeout->add(500 , sub {
            $self->setProgress(0.0);
            return 0;
        });
        $self->checkSpellChecking;
        $self->setSensitive(1);
    }
    
    sub setProgress
    {
        my ($self, $current) = @_;
        $self->{progress}->set_fraction($current);
        GCUtils::updateUI;
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
        return if ! $self->{openingFile};
        return if ($current % $self->{step});
        if ($self->{total})
        {
            my $value = ($current / $self->{total}) / 2;
            $value = 0.5 if $value > 0.5;
            #$self->{progress}->set_fraction($value);
            $self->setProgress($value);
        }
        else
        {
            #$self->{progress}->set_fraction(0.3);
            $self->setProgress(0.3);
        }
        GCUtils::updateUI;
    }

    sub setProgressForItemsDisplay
    {
        my ($self, $current) = @_;
        return if ($current % $self->{step});
        if ($self->{total})
        {
            my $value = ($current / (2*$self->{total}));
            $value = ($value / 2) + 0.5 if $self->{openingFile};
            $value = 0.75 if $value > 0.75;
            $self->setProgress($value);
            #$self->{progress}->set_fraction($value);
        }
        else
        {
            $self->setProgress(0.5);
            #$self->{progress}->set_fraction(0.5);
        }
        GCUtils::updateUI;
    }

    sub setProgressForItemsSort
    {
        my ($self, $current) = @_;
        return if ($current % $self->{step});
        if ($self->{total})
        {
            my $value = ($current / (2*$self->{total})) + 0.5;
            $value = (($value - 0.5) / 2) + 0.75 if $self->{openingFile};
            $value = 1.0 if $value > 1;
            $self->setProgress($value);
            $self->{progress}->set_fraction($value);
        }
        else
        {
            $self->setProgress(0.7);
            $self->{progress}->set_fraction(0.7);
        }
        GCUtils::updateUI;
    }

    sub blockListUpdates
    {
        my ($self, $value) = @_;
        
        $self->{items}->{block} = $value;
    }

    sub reloadList
    {
        my $self = shift;
        $self->{items}->reloadList($self, 1);
        $self->endProgress;
    }

    sub setItemsList
    {
        my ($self, $init, $doNotSavePreferences) = @_;

        my $view = $self->{options}->view;
        my $columns = $self->{options}->columns;
        $columns = 0 if $self->{options}->resizeImgList;

        my $current = -1;
        if ($self->{itemsView})
        {
            $current = $self->{itemsView}->getCurrentIdx if !$init;
            $self->{listPane}->remove($self->{itemsView}) if $self->{listPane};
            $self->savePreferences if ! $doNotSavePreferences;
            $self->{itemsView}->destroy;
        }

        if ($view == 0)
        {
            $self->{itemsView} = new GCTextList($self, $self->{model}->getDisplayedItems);
        }
        elsif ($view == 1)
        {
            $self->{itemsView} = new GCImageList($self, $columns);
        }
        else
        {
            $self->{itemsView} = new GCDetailedList($self);
        }
        $self->{itemsView}->{initializing} = 1;

        $self->{listOptionsPanel}->setView($view);

        $self->setExpandCollapseInContext($self->{itemsView}->couldExpandAll);

        if ($self->{listPane})
        {
            $self->{listPane}->pack1($self->{itemsView},1,0);
            $self->{itemsView}->show_all;
        }
        if ($self->{items})
        {
            $self->reloadList if ! $self->{initializing};
            Glib::Timeout->add(100 ,\&showCurrent, $self);
        }

        #Change corresponding item in context menu        
        $self->{ignoreContextActivation} = 1;

        if ($self->{options}->tearoffMenus)
        {
            $self->{context}->{menuDisplayType}->set_active($view + 1);
        }
        else
        {
            $self->{context}->{menuDisplayType}->set_active($view);            
        }
        $self->{context}->{menuDisplayType}->get_active->set_active(1);
        $self->{ignoreContextActivation} = 0;
        #Assign context menu to items list that will be in charge of displaying it.

        if (!$init)
        {
            $self->checkToolbarOptions; # if !$doNotSavePreferences;
            $self->{items}->display($current);
            $self->{itemsView}->select($current);
        }
    }
    
    sub checkToolbarOptions
    {
        my $self = shift;
        $self->{toolbar}->{blocked} = 1;
        # Text list doesn't support grouping
        if ($self->{options}->view == 0)
        {
            $self->{toolbar}->setGroupField('')
        }
        else
        {
            $self->{toolbar}->setGroupField($self->{model}->{preferences}->groupBy);
        }
        $self->{toolbar}->setItemsList($self->{options}->view);
        $self->{toolbar}->setLayout($self->{model}->{preferences}->layout);
        $self->{toolbar}->{blocked} = 0;        
    }
    
    sub createContextMenu
    {
        my $self = shift;

        # Context menu creation. It is displayed when right clicking on a list item.
        $self->{context} = new Gtk2::Menu;
        
        if ($self->{options}->tearoffMenus)
        {
            $self->{context}->append(Gtk2::TearoffMenuItem->new());
        }
        
        $self->{contextNewWindow} = Gtk2::MenuItem->new_with_mnemonic($self->{lang}->{MenuNewWindow});
        $self->{contextNewWindow}->signal_connect("activate" , sub {
                $self->displayInWindow(undef, 'item');
        });
        $self->{context}->append($self->{contextNewWindow});
   
        $self->{contextExpand}->{expand} = Gtk2::MenuItem->new_with_mnemonic($self->{lang}->{ContextExpandAll});
        $self->{contextExpand}->{expand}->signal_connect('activate', sub {
            $self->{itemsView}->expandAll;
        });
        $self->{context}->append($self->{contextExpand}->{expand});

        $self->{contextExpand}->{collapse} = Gtk2::MenuItem->new_with_mnemonic($self->{lang}->{ContextCollapseAll});
        $self->{contextExpand}->{collapse}->signal_connect('activate', sub {
            $self->{itemsView}->collapseAll;
        });
        $self->{context}->append($self->{contextExpand}->{collapse});
        
        
        #$self->{contextExpand}->{separator} = new Gtk2::SeparatorMenuItem;
        $self->{context}->append(Gtk2::SeparatorMenuItem->new);

        $self->{contextDuplicateItem} = Gtk2::ImageMenuItem->new_from_stock('gtk-dnd');
        $self->{contextDuplicateItem}->set_accel_path('<main>/Edit/gtk-dnd');
        $self->{contextDuplicateItem}->signal_connect('activate' , sub {
            $self->duplicateItem;
        });
        $self->{context}->append($self->{contextDuplicateItem});

        $self->{contextSelectAllItem} = Gtk2::ImageMenuItem->new_from_stock('gtk-select-all',undef);
        $self->{contextSelectAllItem}->signal_connect("activate" , sub {
            $self->selectAll;
        });
        $self->{context}->append($self->{contextSelectAllItem});

        $self->{contextItemDelete} = Gtk2::ImageMenuItem->new_from_stock('gtk-delete',undef);
        $self->{contextItemDelete}->signal_connect("activate" , sub {
            $self->deleteCurrentItem;
        });
        $self->{context}->append($self->{contextItemDelete});
        
        $self->{context}->append(Gtk2::SeparatorMenuItem->new);
        $self->{context}->{menuDisplayType} = new Gtk2::Menu;
        if ($self->{options}->tearoffMenus)
        {        
            $self->{context}->{menuDisplayType}->append(Gtk2::TearoffMenuItem->new());
        }
        my %views = %{$self->{lang}->{OptionsViews}};
        my $displayGroup = undef;
		foreach (0..(scalar(keys %views) - 1))
		{
		    my $item = Gtk2::RadioMenuItem->new_with_mnemonic($displayGroup, $views{$_});
		    $item->signal_connect('activate', sub {
		        my ($widget, $self) = @_;
		        return if ($self->{ignoreContextActivation});
                if ($widget->get_active)
                {
                    my $group = $widget->get_group;
                    my $i = 0;
                    $i++ while ($views{$i} ne $widget->child->get_label);
                    $self->{options}->view($i);
                    $self->setItemsList(0)
                        if ! $self->{initializing};
                    $self->checkView;
                    
                }
		    }, $self);
		    $self->{context}->{menuDisplayType}->append($item);
		    $displayGroup = $item->get_group;
		}
		
        $self->{context}->{itemDisplayType} = Gtk2::MenuItem->new_with_mnemonic($self->{lang}->{OptionsView});
        $self->{context}->{itemDisplayType}->set_submenu($self->{context}->{menuDisplayType});
        $self->{context}->append($self->{context}->{itemDisplayType});
        
        $self->{context}->{displayItem} = Gtk2::MenuItem->new_with_mnemonic($self->{lang}->{MenuDisplayMenu});
        $self->{context}->append($self->{context}->{displayItem});
        
        $self->{context}->append(Gtk2::SeparatorMenuItem->new);
        
        # Filters selection
                
        my $menuDisplay = Gtk2::Menu->new();
        my $filterItem = Gtk2::MenuItem->new_with_mnemonic($self->{lang}->{MenuDisplay});
        
        $self->{contextViewAllItems} = Gtk2::MenuItem->new_with_mnemonic($self->{lang}->{MenuViewAllItems});
        $self->{contextViewAllItems}->signal_connect("activate" , sub {
                $self->viewAllItems;
        });
        $menuDisplay->append($self->{contextViewAllItems});
        
        my $searchSelectedItems = Gtk2::ImageMenuItem->new_from_stock('gtk-find',undef);
        $searchSelectedItems->signal_connect("activate" , sub {
                $self->search('displayed');
        });
        $menuDisplay->append($searchSelectedItems);
        
        $filterItem->set_submenu($menuDisplay);
        $self->{context}->append($filterItem);
        
        $self->{context}->signal_connect('show' => sub {
            $self->{menubar}->attachDisplayMenu($self->{context}->{displayItem});
        });
        
        $self->{context}->signal_connect('hide' => sub {
            $self->{menubar}->attachDisplayMenu();
        });
        
        $self->{context}->show_all;
      
    }
    
    sub setExpandCollapseInContext
    {
        my ($self, $active) = @_;
        
        foreach (keys %{$self->{contextExpand}})
        {
            $self->{contextExpand}->{$_}->set_sensitive($active);
        }
    }
    
    sub contextDisplayChange
    {
        my ($self, $widget, $menuName, $number) = @_;
        
        return if $widget && ! $widget->get_active;
        return if $self->{menubar}->{contextUpdating};

        $self->{menubar}->{contextUpdating} = 1;
        $self->{menubar}->{$menuName}->set_active($number);
        $self->{menubar}->{$menuName}->get_active->activate;
        $self->{menubar}->{contextUpdating} = 0;
    }
    
    sub showCurrent
    {
        my $self = shift;
        $self->{itemsView}->showCurrent;
        return 0;
    }
    
    sub viewAllItems
    {
        my ($self, $self2) = @_;
        $self = $self2 if $self2;

        $self->{menubar}->selectAll;
    }
    
    sub transformTitle
    {
        my ($self, $title) = @_;

        return $title if ! $self->{options}->{options}->{transform};
        
        return $title if $title !~ $self->{articlesRegexp};
        #'
        #return $title if $title !~ /^($self->{articlesRegexp})(\s+|('))(.*)/i;
        return ucfirst($4)." ($1$3)";
    }

    sub transformValue
    {
        my ($self, $value, $field, $withMulti) = @_;

        my $type = '';
        $type = $self->{model}->{fieldsInfo}->{$field}->{type}
            if defined $self->{model}->{fieldsInfo}->{$field}->{type};
        if ($field eq $self->{model}->{commonFields}->{borrower}->{name})
        {
            $value = $self->{lang}->{PanelNobody} if (! $value) || ($value eq 'none');
        }
        else
        {
            if ($type eq 'date')
            {
                $value = GCUtils::timeToStr($value, $self->{options}->dateFormat);
            }
            elsif ($type =~ /list$/o)
            {
                if ($withMulti)
                {
                    $value = GCPreProcess::multipleListToArray($value);
                }
                else
                {
                    $value = GCPreProcess::multipleList($value, $type);
                }
            }
            elsif ($type eq 'options')
            {
                $value = $self->{items}->valueToDisplayed($value, $field) || $value;
            }
            if ($field eq $self->{model}->{commonFields}->{title})
            {
               $value = $self->transformTitle($value);
            }
        }
        return $value;
    }
    
    sub new
    {
        my ($proto, $options, $version, $searchJob) = @_;

        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new('toplevel');
        bless ($self, $class);

        $options->setParent($self);
        $self->{options} = $options;
        $self->{version} = $version;
        $self->{searchJob} = $searchJob;
        
        $self->{logosDir} = $ENV{GCS_SHARE_DIR}.'/logos/';
        $self->{hasPictures} = (-f $self->{logosDir}.'splash.png');
        $self->{tmpImageDir} = tempdir(CLEANUP => 1);

        $self->{lang} = $GCLang::langs{$self->{options}->lang};

        if (! $ENV{GCS_PROFILING})
        {
            #GCPlugins::loadPlugins;
            GCExport::loadExporters;
            GCImport::loadImporters;
        }

        if (! $options->exists('style'))
        {
            $options->style('Gtk')    if ($^O !~ /win32/i);
            $options->style('GCstar') if ($^O =~ /win32/i);
        }
        GCStyle::initStyles;
        my $style = $GCStyle::styles{$options->style};
        
        if ((! $options->exists('itemWindowWidth'))
         || (! $options->exists('itemWindowHeight')))
        {
            $options->itemWindowWidth(600);
            $options->itemWindowHeight(500);
        }

        $self->{style} = $style;
        
        $self->{initializing} = 1;

        if (($self->{options}->splash) || (! $self->{options}->exists('splash')))
        {
            $self->{splash} = new GCSplashWindow($self, $self->{version});
        }
        else
        {            
            $self->init;
            $self->loadPrevious;
            $self->initEnd;
            $self->{initializing} = 0;
            $self->setSensitive(1);
        }

        return $self;
    }

    sub createStockItems
    {
        my $self = shift;
        
        my $baseStock;
        $baseStock->{translation_domain} = 'gtk20';
        $baseStock->{keyval} = 0;
        $baseStock->{modifier} = [  ];
        
        $baseStock->{stock_id} = 'gtk-execute';
        $baseStock->{label} = $self->{lang}->{ToolbarRandom};                
        Gtk2::Stock->add($baseStock);
        
        $baseStock->{stock_id} = 'gtk-refresh';
        $baseStock->{label} = $self->{lang}->{ToolbarAll};
        Gtk2::Stock->add($baseStock);
        
        $baseStock->{stock_id} = 'gtk-convert';
        $baseStock->{label} = $self->{lang}->{MenuImport};
        Gtk2::Stock->add($baseStock);
        
        $baseStock->{stock_id} = 'gtk-revert-to-saved';
        $baseStock->{label} = $self->{lang}->{MenuExport};
        Gtk2::Stock->add($baseStock);

        $baseStock->{stock_id} = 'gtk-dnd';
        $baseStock->{label} = $self->{lang}->{MenuDuplicate};
        Gtk2::Stock->add($baseStock);
        my $iconFactory = Gtk2::IconFactory->new;
        $iconFactory->add('gtk-dnd', (Gtk2::IconFactory->lookup_default ('gtk-copy')));
        $iconFactory->add_default;      

        $baseStock->{stock_id} = 'gtk-jump-to';
        $baseStock->{label} = $self->{lang}->{PanelSearchButton};
        Gtk2::Stock->add($baseStock);

        $baseStock->{stock_id} = 'gtk-help';
        #$baseStock->{keyval} = 'F1';
        #$baseStock->{modifier} = [];
        $baseStock->{label} = $self->{lang}->{MenuHelpContent};
        Gtk2::Stock->add($baseStock);

        $baseStock->{stock_id} = 'gtk-about';
        $baseStock->{label} = $self->{lang}->{MenuAbout};
        Gtk2::Stock->add($baseStock);
        
        $baseStock->{stock_id} = 'gtk-zoom-in';
        $baseStock->{label} = $self->{lang}->{ResultsPreview};
        Gtk2::Stock->add($baseStock);
        
        my $addStock = Gtk2::Stock->lookup('gtk-add');
        # Ctrl-T
        $addStock->{keyval} = ord('T');
        $addStock->{modifier} = [ 'control-mask' ];
        Gtk2::Stock->add($addStock);
        
        my $selectAllStock = Gtk2::Stock->lookup('gtk-select-all');
        if (!$selectAllStock)
        {
            $baseStock->{stock_id} = 'gtk-select-all';
            $baseStock->{label} = $self->{lang}->{DisplayOptionsAll};
            $baseStock->{modifier} = [];
            Gtk2::Stock->add($baseStock);
        }
        
    }

    sub init
    {
        my $self = shift;
        my $splash = shift;

        $self->{options}->save if $self->checkImagesDirectory(1);
        
        $self->createStockItems;
        $splash->setProgress(0.01) if $splash;

        $self->{modelsFactory} = new GCModelsCache($self);

        Gtk2::Rc->parse($self->{style}->{rcFile});

        $self->{AccelMapFile} = $ENV{GCS_CONFIG_HOME}.'/AccelMap';
        $self->{agent} = 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.5) Gecko/20041111 Firefox/1.0';
        $self->{ignoreString} = 'gcf_000_ignore';
        $self->{imagePrefix} = 'gcstar_';
        
        $self->{tooltips} = Gtk2::Tooltips->new();
        if ($self->{searchJob}->{command})
        {
            $self->{searchJob}->{command}->autoflush(1);
            $self->{searchJob}->{data}->autoflush(1);
        }
        
        $self->refreshTitle;
        my $iconPrefix = $ENV{GCS_SHARE_DIR}.'/icons/gcstar_';
        my $pixbuf16 = Gtk2::Gdk::Pixbuf->new_from_file($iconPrefix.'16x16.png');
        my $pixbuf32 = Gtk2::Gdk::Pixbuf->new_from_file($iconPrefix.'32x32.png');
        my $pixbuf48 = Gtk2::Gdk::Pixbuf->new_from_file($iconPrefix.'48x48.png');
        my $pixbuf64 = Gtk2::Gdk::Pixbuf->new_from_file($iconPrefix.'64x64.png');
        $self->set_default_icon_list($pixbuf16, $pixbuf32, $pixbuf48, $pixbuf64);

        $self->signal_connect(delete_event => \&beforeDestroy, $self);
        $self->signal_connect(destroy => sub { Gtk2->main_quit; });
        
        $self->createContextMenu;

        $splash->setProgress(0.03) if $splash;
        
        $self->{items} = new GCItems($self);
        $self->{panel} = 0;

        $self->{menubar} = new GCMenuBar($self, $self->{AccelMapFile});
        $self->{menubar}->set_name('GCMenubar');
        
        $self->{bookmarksLoader} = new GCBookmarksLoader($self, $self->{menubar});
        $self->{toolbar} = GCToolBar->new($self);
        
        $self->{mainVbox} = new Gtk2::VBox(0, 0);
        $self->{mainHbox} = new Gtk2::HBox(0, 0);
        $self->{pane} = new Gtk2::HPaned;
        $self->{listPane} = new Gtk2::VPaned;

        $self->{pane}->set_position($self->{options}->split);
        $self->{listPane}->set_position($self->{options}->listPaneSplit);
        $self->{pane}->pack1($self->{listPane},1,0);
        $self->{listOptionsPanel} = new GCListOptionsPanel($self->{options}, $self);
        $self->{listPane}->pack2($self->{listOptionsPanel},1,1);

        $self->{mainVbox}->pack_start($self->{menubar}, 0, 0, 0);
        $self->{mainHbox}->pack_start($self->{pane},1,1,0);
        $self->{mainVbox}->pack_start($self->{mainHbox}, 1, 1, 0);

        $self->{status} = Gtk2::Statusbar->new;
        $self->{status}->set_has_resize_grip(1);
        $self->{progress} = new Gtk2::ProgressBar;
        $self->{progress}->set_size_request(100,-1);
        $self->{status}->pack_start($self->{progress}, 0, 0, 5);
        $self->{mainVbox}->pack_start($self->{status},0,0,0);

        $self->setSensitive(0);
        $self->checkToolbarPosition;
        $self->add($self->{mainVbox});

        $splash->setProgress(0.05) if $splash;

        $self->set_default_size($self->{options}->width,$self->{options}->height);

        $self->drag_dest_set('all', ['copy','private','default','move','link','ask']);

        $self->signal_connect(drag_data_received => \&drop_handler, $self);

        my $target_list = Gtk2::TargetList->new();
        my $atom1 = Gtk2::Gdk::Atom->new('text/uri-list');
        my $atom2 = Gtk2::Gdk::Atom->new('text/plain');
        $target_list->add($atom1, 0, 0);
        $target_list->add($atom2, 0, 0);
        if ($^O =~ /win32/i)
        {
            my $atom3 = Gtk2::Gdk::Atom->new('DROPFILES_DND');
            $target_list->add($atom3, 0, 0);
        }
        
        $self->drag_dest_set_target_list($target_list);

        sub drop_handler {
            my ($widget, $context, $widget_x, $widget_y, $data, $info, $time, $self) = @_;
            my $type = $data->type->name;
                                                 
            if (($type eq 'text/uri-list')
             || ($type eq 'DROPFILES_DND'))
            {
                my @files = split /\n/, $data->data;
                my $numbers = scalar @files;
                $numbers-- if ($files[$#files] =~ /^\W*$/);
                
                my ($filename, undef, $extension) = fileparse($files[0],qr{\..*});
                $extension =~ s/[^\.\w]//g;
                $extension = lc($extension);

                if (($numbers == 1)
                 && ($files[0] =~ /\.gcs.?$/))
                {
                    # Special case when only one .gcs file is dropped
                    (my $fileName = $files[0]) =~ s/^file:\/\/(.*)\W*$/$1/;
                    $fileName =~ s/.$//ms;
                    $self->openFile($fileName);
                }
                elsif (($numbers == 1)
                 && ($files[0] =~ /^http:\/\//))
                {
                    # One url has been dropped, parse it for item data
                    $self->loadUrl($files[0]);
                }
                elsif ((grep {$_ eq $extension} @GCBaseWidgets::videoExtensions)
                         && ($self->{model}->{collection}->{name} eq 'GCfilms'))
                {
                    # At least one video file was dropped and a movie collection is open    
                    $self->handleDroppedFiles(\@files, \@GCBaseWidgets::videoExtensions, 'trailer');
                }
                elsif ((grep {$_ eq $extension} @GCBaseWidgets::ebookExtensions)
                         && ($self->{model}->{collection}->{name} eq 'GCbooks'))
                {
                    # At least one ebook file was dropped and a book collection is open    
                    $self->handleDroppedFiles(\@files, \@GCBaseWidgets::ebookExtensions, 'digitalfile');
                }
                elsif ((grep {$_ eq $extension} @GCBaseWidgets::audioExtensions)
                         && ($self->{model}->{collection}->{name} eq 'GCmusics'))
                {
                    # At least one audio file was dropped and a music collection is open    
                    $self->handleDroppedFiles(\@files, \@GCBaseWidgets::audioExtensions, 'playlist');
                }
                else
                {
                    my $fileName = $self->{options}->file;
                    #$self->newList;
                    foreach (@files)
                    {
                        if (!$self->importWithDetect($_))
                        {
                            my $dialog = Gtk2::MessageDialog->new($self,
							    [qw/modal destroy-with-parent/],
							    'error',
							    'ok',
							    $self->{lang}->{ImportDropError});

                            $dialog->set_position('center-on-parent');
                            my $response = $dialog->run;
                            $dialog->destroy;

                            $self->openFile($fileName);
                            last;
                        }
                    }
                    #$self->{items}->setStatus;
                    $self->setNbItems;
                }
            }
            elsif ((my $url = $data->data) =~ m/^http:\/\//)
            {
                $self->loadUrl($url);
            }
        }

        $splash->setProgress(0.07) if $splash;
        
        $self->show_all;
        
        $self->checkDisplayed;
        $self->checkView;
        $self->checkTransform;
        
        $self->{filterSearch} = new GCFilterSearch;

        $splash->setProgress(0.09) if $splash;

        $self->{options}->searchStop(0) if ($^O =~ /win32/i);
    }
    
    sub handleDroppedFiles
    {
        my ($self, $files, $acceptedExtensions, $field) = @_;

        foreach (@$files)
        {
            # Split filename up into parts
            my ($filename, undef, $extension) = fileparse($_,qr{\..*});
            $extension =~ /(\.\w\w\w)/;
            $extension = lc($1);

            # Double check that the current file being handled is acceptable
            if (grep {$_ eq $extension} @$acceptedExtensions)
            {
                # Extract a clean version of the filename
                (my $file = $_) =~ s/\W*$//;
                $file =~ s/^file:\/\///;

                # Add a new item
                $self->newItem;
                
                # Set the file field to match the dropped filename 
                $self->{panel}->$field(uri_unescape($file));
                
                # Fetch info
                $filename = uri_unescape($filename);
                $self->searchItem($filename, undef, 0, $self->{model}->{commonFields}->{title});
            }
        }
    }

    sub setPanel
    {
        my $self = shift;
        my $panelInfo;
        if (! $self->{model}->{preferences}->exists('layout') || (! $self->{model}->{preferences}->layout))
        {
            $panelInfo = $self->{model}->getDefaultPanel;
            $self->{model}->{preferences}->layout($panelInfo->{name})
        }
        else
        {
            $panelInfo = $self->{model}->{panels}->{$self->{model}->{preferences}->layout};
        }
        if ($panelInfo->{editable} eq 'true')
        {
            $self->{panel} = new GCFormPanel($self, $self->{options}, $panelInfo);
        }
        else
        {
            $self->{panel} = new GCReadOnlyPanel($self, $self->{options}, $panelInfo);
        }
        $self->{panel}->setExpandersMode($self->{options}->expandersMode);
        $self->{panel}->show_all;
    }

    sub changePanel
    {
        # $modelChanged means there was any change in the model and not that we are just
        # changing the panel because the layout was changed in preferences
        # $modelUpdated means the model is the same, but some fields were added/removed
        my ($self, $modelChanged, $modelUpdated) = @_;

        #Save previous histories
        my %savedHistories;
        if ($self->{panel})
        {
            # If there was no change or just an update, we save the history
            if ((!$modelChanged) || $modelUpdated)
            {
                foreach(@{$self->{model}->{fieldsHistory}})
                {
                    $savedHistories{$_} = $self->{panel}->getValues($_);
                }
                $self->{items}->updateSelectedItemInfoFromPanel if !$modelUpdated;
            }
            $self->{scrollPanelItem}->remove($self->{scrollPanelItem}->get_child);
            $self->{panel}->destroy;
            $self->{pane}->remove($self->{scrollPanelItem});
            $self->{scrollPanelItem}->destroy;
        }

        $self->setPanel;
        $self->{panel}->createContent($self->{model});

        $self->{scrollPanelItem} = new Gtk2::ScrolledWindow;
        $self->{scrollPanelItem}->set_policy ('automatic', 'automatic');
        $self->{scrollPanelItem}->set_shadow_type('none');
        $self->{scrollPanelItem}->add_with_viewport($self->{panel});
        $self->{pane}->pack2($self->{scrollPanelItem},1,1);
        $self->{scrollPanelItem}->show_all;
        $self->{items}->setPanel($self->{panel});
        $self->checkBorrowers;
        $self->checkPanelContent;

        if (%savedHistories)
        {
            #Restore histories
            foreach(@{$self->{model}->{fieldsHistory}})
            {
                $self->{panel}->{$_}->setValues($savedHistories{$_});
            }
        }
        
        $self->{items}->displayCurrent;
        $self->checkToolbarOptions;
    }

    sub removeToolbar
    {
        my $self = shift;

        #Remove previous if exists
        if ($self->{toolbar})
        {
            $self->{mainHbox}->remove($self->{toolbar})
                if ($self->{toolbar}->parent eq $self->{mainHbox});
            $self->{mainVbox}->remove($self->{toolbar})
                if ($self->{toolbar}->parent eq $self->{mainVbox});
        };
    }

    sub checkToolbarPosition
    {
        my ($self, $deactivateRemoval) = @_;

        $self->removeToolbar if !$deactivateRemoval;

        my $position = $self->{options}->toolbarPosition;
        
        # 0 => top
        # 1 => bottom
        # 2 => left
        # 3 => right
        
        if ($position > 1) # left or right
        {
            $self->{toolbar}->set_orientation('vertical');
            $self->{mainHbox}->pack_start($self->{toolbar},0,0,0);
            if ($position == 2) # left
            {
                $self->{mainHbox}->reorder_child($self->{toolbar},0);
            }
            else # right
            {
                $self->{mainHbox}->reorder_child($self->{toolbar},1);
            }
        }
        else # top or bottom
        {
            $self->{toolbar}->set_orientation('horizontal');
            $self->{mainVbox}->pack_start($self->{toolbar},0,0,0 );
            if ($position == 1) # bottom
            {
                $self->{mainVbox}->reorder_child($self->{toolbar},2);
            }
            else # top
            {
                $self->{mainVbox}->reorder_child($self->{toolbar},1);
            }
        }
        $self->{toolbar}->show_all;
        $self->{toolbar}->setShowFieldsSelection($position <= 1);
    }

    sub checkDisplayed
    {
        my $self = shift;
        
        $self->setDisplayMenuBar($self->{options}->displayMenuBar);
        $self->setDisplayStatusBar($self->{options}->status);
        $self->setDisplayToolBar($self->{options}->toolbar);
    }

    sub checkProxy
    {
		my $self= shift;
		
		$self->{plugin}->setProxy($self->{options}->proxy) if ($self->{plugin});
    }
    
    sub checkCookieJar
    {
        my $self= shift;
        $self->{plugin}->setCookieJar($self->{options}->cookieJar) if ($self->{plugin});
     }

    sub checkPlugin
    {
        my $self = shift;
        $self->{plugin} = undef;
        $self->{plugin} = $self->{model}->getPlugin($self->{model}->{preferences}->plugin);

        $self->checkProxy;
        $self->checkCookieJar;
    }
    
    sub checkBorrowers
    {
        my $self = shift;

        #my @borrowers = split m/\|/, $self->{options}->borrowers;
        $self->{panel}->setBorrowers;
    }
    
    sub checkView
    {
        my $self = shift;
        if ($self->{options}->tearoffMenus)
        {
            $self->{context}->{menuDisplayType}->set_active($self->{options}->view + 1);
        }
        else
        {
            $self->{context}->{menuDisplayType}->set_active($self->{options}->view);
        }
        $self->{context}->{menuDisplayType}->get_active->set_active(1);
    }
    
    sub checkTransform
    {
        my $self = shift;
 
        my @array = split m/,/, $self->{options}->articles;

        my $tmpExpr = '';
        
        foreach (@array)
        {
            s/^\s*//;
            s/\s*$//;
            $tmpExpr .= "\Q$_\E|";
        }
        chomp $tmpExpr;
        
        $self->{articles} = \@array;
        #$self->{articlesRegexp} = $tmpExpr;
        $self->{articlesRegexp} = qr/^($tmpExpr)(\s+|('))(.*)/i;
        #'
        $self->reloadList if ! $self->{initializing};
    }
    
    sub checkPanelContent
    {
        my $self = shift;

        my $hasToShow = 1;
        $hasToShow = 0 if (! $self->{itemsView}->getNbItems);
                       
        $self->{panel}->setShowOption($self->getDialog('DisplayOptions')->{show}, $hasToShow);
    }

    sub checkSpellChecking
    {
        my $self = shift;
        my $lang;
        if ($self->{items})
        {
            $lang = $self->{items}->getInformation->{lang};
            $lang =~ s/^(\w*).*$/$1/;
        }
        $self->{panel}->setSpellChecking($self->{options}->spellCheck,
                                         $lang);
    }

    sub loadPrevious
    {
        my $self = shift;
        my $splash = shift;
        $self->{items}->setOptions($self->{options});
        return if !$self->{options}->file;
        
        #if ($self->{items}->setOptions($self->{options}, $splash))
        my ($success, $error) = $self->{items}->load($self->{options}->file, $splash, 0);
        if ($success)
        {
            $self->checkDefaultImage;
            $self->refreshFilters;
            $self->refreshTitle;
            $self->{menubar}->setLock($self->{items}->getLock);
            $self->addFileHistory($self->{options}->file);  
            $self->checkPanelContent;
            $self->checkBorrowers;
#            $self->checkSpellChecking;
        }
        else
        {
            $splash->hide if $splash;
            my $dialog = new GCCriticalErrorDialog(
                $self,
                GCUtils::formatOpenSaveError(
                    $self->{lang},
                    $self->{options}->file,
                    $error
                )
            );
            $dialog->show;
            $self->{options}->file('');

        }

        #$self->{itemsView}->setSortOrder;

        #$splash->setProgress(0.99) if $splash;
    }
    
    sub initEnd
    {
        my $self = shift;
        
        if ($self->{options}->{created})
        {
            $self->{options}->checkPreviousGCfilms($self);
        }
        
        if (! $self->{options}->file)
        {
            $self->{splash}->destroy
                if $self->{splash};
            $self->{splash} = 0;
            $self->newList;
        }
        
        $self->reloadDone(0,$self->{splash});
        #$self->{itemsView}->done;
        $self->{items}->display($self->{items}->select(-1,1));

        if ($ENV{GCS_PROFILING} > 2)
        {
            $self->leave;
        }
        
        $self->{changedChecked} = Glib::Timeout->add(2000 , sub {
            if ($GCGraphicComponent::somethingChanged)
            {
                $self->markAsUpdated;
                $GCGraphicComponent::somethingChanged = 0;
            }
            return 1;
        });
    }

    sub setFullScreen
    {
        my ($self, $fullscreen) = @_;
        
        if ($fullscreen)
        {
            $self->fullscreen;
        }
        else
        {
            $self->unfullscreen;
        }
    }

    sub setDisplayMenuBar
    {
        my ($self, $show) = @_;
        
        if ($show)
        {
            $self->{menubar}->show_all;
        }
        else
        {
            $self->{menubar}->hide;
        }
        $self->{options}->displayMenuBar($show);
    }

    sub setDisplayToolBar
    {
        my ($self, $show) = @_;
        
        if ($show)
        {
            $self->{toolbar}->show_all;
        }
        else
        {
            $self->{toolbar}->hide;
        }
        $self->{options}->toolbar($show);
    }

    sub setDisplayStatusBar
    {
        my ($self, $show) = @_;
        
        if ($show)
        {
            $self->{status}->show_all;
        }
        else
        {
            $self->{status}->hide;
        }
        $self->{options}->status($show);
    }
    
    sub setDefaultValues
    {
        my $self = shift;
        
        my $window = $self->getItemWindow('defaultValues');
        my $title = $self->{lang}->{MenuDefaultValues};
        
        $window->setTitle($title);

        my $info = $self->{model}->getDefaultValues;
        $self->{items}->displayDataInPanel($window->{panel}, $info);
        my $code = $window->show;

        if ($code eq 'ok')
        {
            my ($changed, $info, $previous) = $self->{items}->getInfoFromPanel($window->{panel}, $info);
            $self->{model}->setDefaultValues($info);
        }

        $self->saveItemWindowSettings($window);

        $window->hide;
        
        return $code;
        
    }
}

1;
