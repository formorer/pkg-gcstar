{
    package GCPlugins;
    
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
use GCDialogs;

use base 'Exporter';
our @EXPORT = qw(%pluginsMap %pluginsNameArrays);

our %pluginsMap;
our %pluginsNameArrays;

sub loadPlugins
{
    my $model = shift;
    return if $pluginsNameArrays{$model};
    my $dir = $ENV{GCS_LIB_DIR}.'/GCPlugins/'.$model;
    foreach (glob "$dir/*.pm")
    {
        my $plugin = basename($_, '.pm')."\n";
        next if $plugin =~ /Common/;
        (my $class = $plugin) =~ s/^GC/GCPlugin/;
        my $obj;
        eval "use GCPlugins::".$model."::$plugin; \$obj = new GCPlugins::".$model."::$class;";
        die "Fatal error with plugin $plugin : $@" if $@;
        $pluginsMap{$model}->{$obj->getName} = $obj;
    }
    my @names = sort keys %{$pluginsMap{$model}};
    $pluginsNameArrays{$model} = \@names;
    
}

sub loadAllPlugins
{
    foreach my $dir(glob $ENV{GCS_LIB_DIR}.'/GCPlugins/*')
    {
        next if $dir =~ /PluginsBase/;
        my $model = basename($dir);
        next if ($model !~ /^GC/) || ($model eq 'GCstar');
        loadPlugins($model);
    }
}
    
    {
        package GCPluginJob;
        
        use Storable qw(store_fd fd_retrieve);
        use IO::Handle;
        use GCPlugins::GCPluginsBase;
        
        sub new
        {
            my ($proto, $command, $data) = @_;
            my $class = ref($proto) || $proto;
            
            my $self  = {command => $command, data => $data};
            $command->autoflush(1);
            $data->autoflush(1);
            #GCPlugins::loadPlugins if ! $ENV{GCS_PROFILING};

            bless ($self, $class);
            return $self;
        }
        
        sub run
        {
            my $self = shift;
            my $command = $self->{command};
            my $info;
            while (1)
            {
                local $Storable::forgive_me = 1;
                $info = fd_retrieve($command);
                eval {$self->beginSearch($info)};
            }
        }
        
        sub quit
        {
            my $self = shift;
            close $self->{command};
            close $self->{data};
            wait;
            exit;
        }
        
        sub beginSearch
        {
            my ($self, $info) = @_;
            my $pid;
            GCPlugins::loadPlugins($info->{model}) if $info->{model};
            if ($pid = fork)
            {
                my $command = $self->{command};
                $command->autoflush(1);
                my $cmd = readline($command);
                chomp $cmd;
                kill 9,$pid if ($cmd eq 'STOP');
                $self->quit if $cmd eq 'EXIT';
                wait;
            }
            else
            {
                #$info could be a simple hash or the plugin itself depending on the phase
                if ($info->{type} eq 'load')
                {
                    # Here we create the plugin
                    my $plugin = $pluginsMap{$info->{model}}->{$info->{name}};
                    $plugin->setProxy($info->{proxy});
                    $plugin->setCookieJar($info->{cookieJar});
                    $plugin->{type} = $info->{type};
                    $plugin->{urlField} = $info->{urlField};
                    $plugin->{bigPics} = $info->{bigPics};

                    $self->{currentPlugin} = $plugin;

                    $plugin->{title} = $info->{query};
                    $plugin->{searchField} = $info->{field};
                    $plugin->{pass} = $info->{pass};
                    $plugin->{nextUrl} = $info->{nextUrl};

                    $plugin->load;
                    
                    # Remove the user agent part of the data, otherwise the Storable lib complains
                    # about not being able to store the sub's stored in it.
                    undef($plugin->{ua});
                    
                    local $Storable::forgive_me = 1;
                    store_fd $plugin, $self->{data};
                }
                elsif ($info->{type} ne 'exit')
                {
                    # Here we re-use it
                    my $plugin = $info;
                    store_fd $plugin->getItemInfo, $self->{data};
                }
                exit;   
            }
        }
    }
 
    use Gtk2;
 
    {
        package GCPluginsDialog;
        
        use base 'GCModalDialog';
    
        sub show
        {
            my $self = shift;
            $self->{useThisSite}->set_active(0);
            $self->SUPER::show();
            $self->show_all;
            $self->{fieldsList}->hide if $self->{hideFieldsList};
            my $path = $self->{pluginsList}->get_selection->get_selected_rows;
            $self->{pluginsList}->scroll_to_cell($path) if $path;
            
            my $response = $self->run;
            $self->{plugin} = undef;
            if ($response eq 'ok')
            {
                my $pluginName = '';
                my $idx = ($self->{pluginsList}->get_selected_indices)[0];
                $pluginName = $self->{pluginsList}->{data}->[$idx]->[0];

                $self->{plugin} = $self->{model}->getPlugin($pluginName);

                if ($self->{useThisSite}->get_active)
                {
                   $self->{parent}->{model}->{preferences}->plugin($pluginName);
                   $self->{parent}->checkPlugin;
                }
            }
            $self->hide;
        }
        
        sub new
        {
            my ($proto, $parent) = @_;
            my $class = ref($proto) || $proto;
            my $self  = $class->SUPER::new($parent,
                                           $parent->{lang}->{PluginsTitle},
                                           'gtk-jump-to'
                                          );
    
                bless ($self, $class);
    
            $self->{parent} = $parent;

            $self->{titleGroup} = new GCGroup($parent->{lang}->{PluginsQuery});
            my $queryHbox = new Gtk2::HBox(0,0);
            $self->{query} = new GCShortText;
            $self->{query}->signal_connect(activate => sub {
                $self->response('ok');
            });

            $self->{fieldsList} = new GCMenuList;
            $queryHbox->pack_start($self->{query}, 1, 1, 0);
            $queryHbox->pack_start($self->{fieldsList}, 0, 0, $GCUtils::halfMargin);
            $self->{titleGroup}->addWidget($queryHbox);
            $self->vbox->pack_start($self->{titleGroup}, 0, 0, 0);
        
        
            my $pluginGroup = undef;
            my $pluginsFrame = new GCGroup($parent->{lang}->{PluginsFrame});
             
            $self->{pluginsList} = new Gtk2::SimpleList($parent->{lang}->{PluginsName} => "text",
                                                        $parent->{lang}->{PluginsLang} => "text",
                                                        $parent->{lang}->{PluginsSearchFields} => "text",
                                                        $parent->{lang}->{PluginsAuthor} => "text",
                                                        $parent->{lang}->{PluginsPreferred} => "pixbuf",);
            $self->{pluginsList}->set_border_width(5);
            $self->{pluginsList}->set_rules_hint(1);
            $self->{pluginsList}->get_column(0)->set_min_width(150);
            for my $i (0..2)
            {
                $self->{pluginsList}->get_column($i)->set_resizable(1);
            }
            $self->{pluginsList}->signal_connect(row_activated => sub {
                $self->response('ok');
            });

            # Setup tooltips for list control
            $self->{pluginsList}->set_has_tooltip(1);
            $self->{pluginsList}->signal_connect (query_tooltip => sub {
                my ($widget, $x, $y, $keyboard_mode, $tooltip) = @_;

                # Place the tooltip in the right position
                my $path = $self->{pluginsList}->get_path_at_pos ($x, $y);
                return 0 unless $path;
                $self->{pluginsList}->set_tooltip_row($tooltip, $path);

                # If row is for a preferred plugin, set the tooltip
                my $index = ($path->get_indices)[0];
                if (${ $self->{pluginsList}->{data} }[$index][4]  == $self->{starPixbuf})
                {
                    $tooltip->set_text($parent->{lang}->{PluginsPreferredTooltip});
                    return 1;
                }
                else
                {
                    return 0;
                }
            });

            # Pixbufs for preferred and standard plugins
            $self->{starPixbuf} = Gtk2::Gdk::Pixbuf->new_from_file($ENV{GCS_SHARE_DIR}.'/icons/star.png');
            $self->{blankPixbuf} = Gtk2::Gdk::Pixbuf->new ('rgb', 1, 8, 1, 1);
            $self->{blankPixbuf}->fill(0x00000000);

            $self->{currentPluginList} = undef;

            #$self->setModel;
    
            my $scrollPanelList = new Gtk2::ScrolledWindow;
            $scrollPanelList->set_border_width(5);
            $scrollPanelList->set_policy ('never', 'automatic');
            $scrollPanelList->set_shadow_type('etched-in');
            $scrollPanelList->add($self->{pluginsList});

            $self->{useThisSite} = Gtk2::CheckButton->new($parent->{lang}->{PluginsUseSite});
            
            my $pluginBox = new Gtk2::VBox(0,0);
            $pluginBox->pack_start($scrollPanelList, 1, 1, 0);
            $pluginBox->pack_start(Gtk2::VBox->new, 0, 0, $GCUtils::halfMargin);
            $pluginBox->pack_start($self->{useThisSite}, 0, 0, 0);
            
            $pluginsFrame->addWidget($pluginBox);
            $self->vbox->pack_start($pluginsFrame, 1, 1, 0);

            $self->set_default_size(1,550);
            
            return $self;
        }
    
        sub query
        {
            my $self = shift;
            if (@_)
            {
               my ($query, $field, $queries) = @_;
               $self->{fieldsList}->setValue($field);
               $self->{query}->setValue($query);
               $self->{queries} = $queries;
               $self->{fieldsList}->signal_connect('changed' => sub {
                   # Only change the search query if it's not empty, otherwise keep existing value 
                   if ($self->{queries}->{$self->{fieldsList}->getValue})
                   {    
                       $self->{query}->setValue(
                           $self->{queries}->{$self->{fieldsList}->getValue}
                       );
                   }
               });
               #$self->{fieldsList}->setDefaultValues(shift);
               #$self->{searchField} = shift;
            }
            return ($self->{query}->getValue, $self->{fieldsList}->getValue);
        }
    
        sub plugin
        {
            my $self = shift;
            
            return $self->{plugin};
        }

        sub setModel
        {
            my ($self, $model, $list) = @_;
            $model ||= $self->{parent}->{model};
            my @plugins_array = sort split (",", $list) if $list;
    
            my @fields = @{$model->getSearchFields};
            if ($#fields < 1)
            {
                $self->{hideFieldsList} = 1;
            }
            else
            {
                $self->{hideFieldsList} = 0;
                my @values;
                foreach (@fields)
                {
                    push @values, {value => $_,
                                   displayed => $model->getDisplayedText($model->{fieldsInfo}->{$_}->{label})};
                }
                $self->{fieldsList}->setValues(\@values);
            }

#            if ($model)
#            {
#                my $titleField = $model->{commonFields}->{title};
#                my $titleInfo = $self->{parent}->{model}->{fieldsInfo}->{$titleField};
#                my $titleText = $model->getDisplayedText($titleInfo->{label});
#                $self->{titleGroup}->setLabel($titleText);
#            }

            return if $list && ($self->{currentPluginList} eq $list);
            $self->{currentPluginList} = $list;

            my $pluginGroup = undef;
            my $i = 0;
            my @newData;
            
            $self->{model} = $model;
            
            if ($model)
            {
                foreach (sort keys %{$model->getAllPlugins})
                {
                    my $plugin = $model->getPlugin($_);
                    if ((!$list) || ($plugin->getName eq $plugins_array[$i]))
                    {
                        # Add plugin to list
                        # Plugin should be marked as a default if it's both preferred, and for the user's language,
                        # or if isPreferred is 2 (not language dependant)
                        push @newData, [$plugin->getName, "\n".$plugin->getLang."\n",
                                        $plugin->getSearchFields($model), $plugin->getAuthor,
                                        ((($plugin->isPreferred == 1)
                                            && ($self->{parent}->{options}->lang eq $plugin->getLang))
                                            || ($plugin->isPreferred == 2))
                                            ? $self->{starPixbuf} : $self->{blankPixbuf}];

                        $i++;
                    }
                }
            }

            # Sort list with preferred plugins first
            @{$self->{pluginsList}->{data}} = sort {
                if (($a->[4] == $self->{starPixbuf}) && ($b->[4] == $self->{starPixbuf}))
                    { return lc($a->[0]) cmp lc($b->[0]); }
                elsif ($a->[4] == $self->{starPixbuf}) { return -1; } 
                elsif ($b->[4] == $self->{starPixbuf}) { return 1; } 
                else { return lc($a->[0]) cmp lc($b->[0]); }
                }  @newData;

            $self->{pluginsList}->select(0);
        }
    }
     
    {
        package GCAllPluginsDialog;
        
        use base 'GCModalDialog';
    
        sub show
        {
            my $self = shift;
            $self->SUPER::show();
            $self->show_all;
            ($self->action_area->get_children)[1]->hide_all;
            my $response = $self->run;
            $self->hide;
        }
        
        sub new
        {
            my ($proto, $parent) = @_;
            my $class = ref($proto) || $proto;
            my $self  = $class->SUPER::new($parent,
                                           $parent->{lang}->{PluginsFrame},
                                           'gtk-close'
                                          );
    
            bless ($self, $class);

            $self->{parent} = $parent;
            $self->{factory} = $parent->{modelsFactory};

            my @columnsNames = ('Name', 'Lang', 'SearchFields', 'Author', 'Preferred');
            $self->{pluginsModel} = new Gtk2::TreeStore(map {'Glib::String'} @columnsNames);
            $self->{pluginsList} = Gtk2::TreeView->new_with_model($self->{pluginsModel});

            my @columns;
            my $i = 0;
            for my $col(@columnsNames)
            {
                my $column = Gtk2::TreeViewColumn->new_with_attributes($parent->{lang}->{'Plugins'.$col},
                                                                       Gtk2::CellRendererText->new,
                                                                       'text' => $i);
                $column->set_resizable(1);
                $self->{pluginsList}->append_column($column);
                $i++;
            }

            $self->{pluginsList}->set_border_width(5);
            $self->{pluginsList}->set_rules_hint(1);

            my $scrollPanelList = new Gtk2::ScrolledWindow;
            $scrollPanelList->set_border_width(5);
            $scrollPanelList->set_policy ('never', 'automatic');
            $scrollPanelList->set_shadow_type('etched-in');
            $scrollPanelList->add($self->{pluginsList});

            $self->{useThisSite} = Gtk2::CheckButton->new($parent->{lang}->{PluginsUseSite});

            my $pluginBox = new Gtk2::VBox(0,0);
            $pluginBox->pack_start($scrollPanelList, 1, 1, 0);

            for my $modelInfo (@{$self->{factory}->getDefaultModels})
            {
                my $modelIter = $self->{pluginsModel}->append(undef);
                $self->{pluginsModel}->set($modelIter,
                                           (0 => $modelInfo->{description})
                                          );

                my $model = $self->{factory}->getModel($modelInfo->{name});
                for my $pluginName (sort keys %{$model->getAllPlugins})
                {
                    my $plugin = $model->getPlugin($pluginName);
                    my $pluginIter = $self->{pluginsModel}->append($modelIter);
                    my %data;
                    $i = 0;
                    my $method;
                    ($method = 'get'.$_, $data{$i++} = $plugin->$method($model))
                        foreach (@columnsNames);
                    $self->{pluginsModel}->set($pluginIter, %data);
#                                               (
#                                                0 => $plugin->getName,
#                                                1 => $plugin->getLang,
#                                                2 => $plugin->getSearchFieldsAsString($model),
#                                                4 => $plugin->getAuthor
#                                               )
#                                              );
                }
            }

            $self->vbox->pack_start($pluginBox, 1, 1, 0);

            $self->set_default_size(1,550);
            
            return $self;
        }
    
        sub setModel
        {
            my ($self, $model, $list) = @_;
            $model ||= $self->{parent}->{model};
            my @plugins_array = sort split (",", $list) if $list;
    
            my @fields = @{$model->getSearchFields};
            if ($#fields < 1)
            {
                $self->{hideFieldsList} = 1;
            }
            else
            {
                $self->{hideFieldsList} = 0;
                my @values;
                foreach (@fields)
                {
                    push @values, {value => $_,
                                   displayed => $model->getDisplayedText($model->{fieldsInfo}->{$_}->{label})};
                }
                $self->{fieldsList}->setValues(\@values);
            }

            return if $list && ($self->{currentPluginList} eq $list);
            $self->{currentPluginList} = $list;

            my $pluginGroup = undef;
            my $i = 0;
            my @newData;
            
            $self->{model} = $model;
            
            if ($model)
            {
                foreach (sort keys %{$model->getAllPlugins})
                {
                    my $plugin = $model->getPlugin($_);
                    if ((!$list) || ($plugin->getName eq $plugins_array[$i]))
                    {
                        push @newData, [$plugin->getName, "\n".$plugin->getLang."\n", $plugin->getAuthor,
                                        $plugin->isPreferred ? $self->{starPixbuf} : $self->{blankPixbuf}];
                        $i++;
                    }
                }
            }

            # Sort list with preferred plugins first
            @{$self->{pluginsList}->{data}} = sort {
                if (($a->[4] == $self->{starPixbuf}) && ($b->[4] == $self->{starPixbuf}))
                    { return lc($a->[0]) cmp lc($b->[0]); }
                elsif ($a->[4] == $self->{starPixbuf}) { return -1; } 
                elsif ($b->[4] == $self->{starPixbuf}) { return 1; } 
                else { return lc($a->[0]) cmp lc($b->[0]); }
                }  @newData;

            $self->{pluginsList}->select(0);
        }
    }

    {
        #Class that is used to let user select
        #plugins he wants to use in a multi-site search.
        package GCMultiSiteDialog;

        use base 'GCDoubleListDialog';
        
        sub getInitData
        {
            my $self = shift;
            
            return $self->{model}->getPluginsNames;
        }
        
        sub getData
        {
            my $self = shift;
            
            my @array = split m/,/, $self->{model}->{preferences}->multisite;
            return \@array;
        }
        
        sub saveList
        {
            my ($self, $list) = @_;
            
            my $value = join ',', @$list;
            $self->{model}->{preferences}->multisite($value);
        }
        
        sub getPlugin
        {
            my ($self, $idx) = @_;
            $self->init;
            return $self->{usedArray}->[$idx];
        }
        
        sub getPluginsNumber
        {
            my $self = shift;
            $self->init;
            return scalar @{$self->{usedArray}};
        }
                
        sub preFill
        {
            my $self = shift;
            
            my @data;
            my $langName = $self->{options}->lang;
            foreach (@{$self->{model}->getPluginsNames})
            {
                push @data, $_ if $self->{model}->getPlugin($_)->getLang eq $langName;
            }
            $self->getDoubleList->setListData(\@data);
        }

        sub setModel
        {
            my ($self, $model) = @_;
            
            $self->{model} = $model;
        }               

        sub new
        {
            my ($proto, $parent, $model) = @_;
            my $class = ref($proto) || $proto;
            my $self  = $class->SUPER::new(
                                    $parent,
                                    $parent->{lang}->{MultiSiteTitle},
                                    0,
                                    $parent->{lang}->{MultiSiteUnused},
                                    $parent->{lang}->{MultiSiteUsed}
                                );
            bless ($self, $class);

            $self->setModel($model);

            if (! $self->{model}->{preferences}->exists('multisite'))
            {
                $self->preFill;
                $self->saveList(\@{$self->{usedArray}});
                $self->{initialized} = 1;
            }

            my $langButton = new Gtk2::Button($parent->{lang}->{MultiSiteLang});
            $langButton->set_border_width($GCUtils::margin);
            $langButton->signal_connect('clicked' => sub {
                $self->preFill;
            });
            my $clearButton = new Gtk2::Button($parent->{lang}->{MultiSiteClear});
            $clearButton->set_border_width($GCUtils::margin);
            $clearButton->signal_connect('clicked' => sub {
                $self->clearList;
            });            
            
            $self->getDoubleList->setDataHandler($self);
            $self->getDoubleList->addBottomButtons($langButton,$clearButton);
            
            return $self;
        }
    }
    
    {
        #Class that is used to let user select
        #plugin order he wants to use for each imported fields
        package GCMultiSitePerFieldDialog;
        use base 'GCModalDialog';
        
        our $removeValue = 'GCListRemove';
        my $startColMenus=1;
        
        my $pluginListOrderPerField;
        my $fieldsToFetch;
        my $remainingSourcesOrderPerField;

        sub show
        {
            my $self = shift;
    
            $self->SUPER::show();
            $self->show_all;
            
            my $response = $self->run;
            $self->hide;
            $self->cleanListOrder;
            $self->savePrefOrderListFromForm if ($response eq 'ok');
            $self->loadPrefOrderListInForm if ($response ne 'ok');
            return ($response eq 'ok');
        }

        sub getSourcesListMenu
        {
            my ($self,$withRemoveItem) = @_;
            return new GCMenuList($self->{sourcesList}) if !$withRemoveItem;
            return new GCMenuList($self->{sourcesListWithRemoveItem}) if $withRemoveItem;
        }

        sub createRowForField
        {
            my ($self, $field, $row, $mandatory) = @_;
            my $fieldsInfo = $self->{parent}->{model}->{fieldsInfo};
            $self->{fields}->{$field}->{row}=$row;
            $self->{fields}->{$field}->{'Cb'} = new GCCheckBox($self->{parent}->{model}->getDisplayedText($fieldsInfo->{$field}->{label}));
            if ($mandatory)
            {
                $self->{fields}->{$field}->{'Cb'}->lock(1);
                $self->{fields}->{$field}->{'Cb'}->setValue(1);
                $self->{fields}->{$field}->{'Cb'}->{mandatory} = 1;
            }
            $self->{table}->attach($self->{fields}->{$field}->{'Cb'}, 0, 1, $row, $row + 1, 'fill', ['fill', 'expand'], 0, 0);
            
            my $curNbSite=0;
            $self->{fields}->{$field}->{'SiteListMenus'}=[];
            $self->{fields}->{$field}->{'SiteListAddLast'}=new Gtk2::Button("+");
            $self->{fields}->{$field}->{'SiteListAddLast'}->signal_connect('clicked' => sub {
                    $self->addSiteListToField($field,-1);
            });
            $self->{fields}->{$field}->{'SiteListAddLast'}->set_no_show_all(1);
            
            $self->{fields}->{$field}->{'SiteListAddFirst'}=new Gtk2::Button("+");
            $self->{fields}->{$field}->{'SiteListAddFirst'}->signal_connect('clicked' => sub {
                    $self->addSiteListToField($field,0);
            });
            $self->{table}->attach($self->{fields}->{$field}->{'SiteListAddFirst'}, $startColMenus, 1+$startColMenus, $row, $row + 1, 'fill', 'fill', 0, 0);
            
            my $Align = new Gtk2::Alignment(0.0, 0.5, 0.0, 0.0);
            my $Hbox = new Gtk2::HBox();
            $self->{fields}->{$field}->{'Hbox'}=$Hbox;
            $Hbox->pack_start($self->{fields}->{$field}->{'SiteListAddLast'},1,0,0);
            $Align->add($Hbox);
            $self->{table}->attach($Align, 1+$startColMenus, 2+$startColMenus, $row, $row + 1, ['expand','fill'], 'fill', 0, 0);
        }

        sub addSiteListToField
        {
            my ($self, $field, $position,$value) = @_;
            my $curListMenus=$self->{fields}->{$field}->{'SiteListMenus'};
            my $curNbSite=scalar @{$curListMenus};
            $curNbSite++;
            $position=$curNbSite-1 if $position==-1;
            my $Hbox = $self->{fields}->{$field}-> {'Hbox'};
            my $newSiteList = $self->getSourcesListMenu(1);
            $value=$self->{bottomline}->{siteAddToAll}->getValue(1) if !$value;
            $newSiteList->setValue($value);
            $newSiteList->{orderInList}=$position;
            $newSiteList->signal_connect('changed' => sub {
                if ($newSiteList->getValue eq $removeValue)
                {
                    $self->removeSiteListFromField($field, $newSiteList->{orderInList})
                }
            });
            #insert the new siteList
            splice @{$curListMenus}, $position, 0, $newSiteList;
            $Hbox->pack_start($newSiteList,0,0,0);
            $Hbox->reorder_child($newSiteList,$position);
            $newSiteList->show;
            #move other siteList on this row to the right
            for (my $idx=$position;$idx<$curNbSite;$idx++)
            {
                $curListMenus->[$idx]->{orderInList}=$idx;
            }
            if($curNbSite==1)
            {
                $self->{fields}->{$field}->{'SiteListAddLast'}->set_no_show_all(0);
                $self->{fields}->{$field}->{'SiteListAddLast'}->show;
            }
       }

        sub removeSiteListFromField
        {
            my ($self, $field, $position) = @_;
            my $curListMenus=$self->{fields}->{$field}->{'SiteListMenus'};
            my $curNbSite=scalar @{$curListMenus};
            $position=$curNbSite-1 if $position==-1;
            my $oldSiteList=splice @{$curListMenus}, $position, 1;
            my $Hbox = $self->{fields}->{$field}-> {'Hbox'};
            $Hbox->remove($oldSiteList);
            $curNbSite--;
            #move other siteList on this row to the left
            for (my $idx=$position;$idx<$curNbSite;$idx++)
            {
                $curListMenus->[$idx]->{orderInList}=$idx;
            }
            if($curNbSite==0)
            {
                $self->{fields}->{$field}->{'SiteListAddLast'}->set_no_show_all(1);
                $self->{fields}->{$field}->{'SiteListAddLast'}->hide;
            }
        }

        sub removeAllSourceListFromField
        {
            my ($self, $field) = @_;
            my $curNbSite=scalar @{$self->{fields}->{$field}->{'SiteListMenus'}};
            for (my $i=0;$i<$curNbSite;$i++)
            {
                $self->removeSiteListFromField($field,-1);
            }
        }

        sub new
        {
            my ($proto, $parent, $model,$usePlugins,$otherSources) = @_;
            my $class = ref($proto) || $proto;
            my $self  = $class->SUPER::new($parent,
                                           $parent->{lang}->{OptionsPluginsMultiPerFieldWindowTitle}
                                          );
    
            bless ($self, $class);
            $model=$parent->{model} if !$model;
            $self->{parent} = $parent;
     
            $self->set_modal(1);
            $self->set_position('center');
            $self->set_default_size(1,500);
            my $layoutHbox = new Gtk2::HBox(0,0);
            $self->{layoutVBox} = new Gtk2::VBox(0,0);
            $self->vbox->pack_start($layoutHbox, 1,1,0);
            $layoutHbox->pack_start($self->{layoutVBox},0,0,$GCUtils::margin);
    
            $self->{table} = new Gtk2::Table(1, 3, 0);
            $self->{table}->set_row_spacings($GCUtils::halfMargin);
            $self->{table}->set_col_spacings($GCUtils::margin);
            $self->{table}->set_border_width($GCUtils::margin);
    
            $self->{scrollPanelList} = new Gtk2::ScrolledWindow;
            $self->{scrollPanelList}->set_policy ('never', 'automatic');
            $self->{scrollPanelList}->set_shadow_type('none');
            $self->{scrollPanelList}->add_with_viewport($self->{table});
    
            $self->{descriptionLabel}=new GCLabel($parent->{lang}->{OptionsPluginsMultiPerFieldDesc});
            $self->{layoutVBox}->pack_start($self->{descriptionLabel},0,0,$GCUtils::margin);
    
            $self->{layoutVBox}->pack_start($self->{scrollPanelList},1,1,$GCUtils::margin);
    
            $self->setModel($model);
            
            $self->setSourceList($usePlugins,$otherSources);
            $self->initForm;
            if (! $self->{model}->{preferences}->exists('multisiteperfield'))
            {
                $self->savePrefOrderListFromForm;
            }
            else
            {
                $self->loadPrefOrderListInForm;
            }
            return $self;
        }

        sub setSourceList
        {
            my ($self,$usePlugins,$otherSourcesList) = @_;
            $#{$self->{sourcesList}}=-1;
            $#{$self->{sourcesListWithRemoveItem}}=-1;
            if ($usePlugins)
            {
                foreach (@{$self->{model}->getPluginsNames})
                {
                    push @{$self->{sourcesList}},{value=>$_,
                                        displayed=>$_};
                }
            }
            if ($otherSourcesList && scalar (@$otherSourcesList))
            {
                foreach (@{$otherSourcesList})
                {
                    push @{$self->{sourcesList}},Storable::dclone($_);
                }
            }
            $self->{sourcesListWithRemoveItem}=Storable::dclone($self->{sourcesList});
            unshift @{$self->{sourcesListWithRemoveItem}}, {value=>$removeValue,displayed=>$self->{parent}->{lang}->{OptionsPluginsMultiPerFieldRemove}};
        }

        sub setModel
        {
            my ($self, $model) = @_;
            
            
            my $parent = $self->{parent};
            return if $self->{model} == $model;
            $self->{model} = $model;
        }

        sub initForm
        {
            my ($self) = @_;
            
            my $parent = $self->{parent};
            my $fieldsInfo = $self->{model}->{fieldsInfo};
            $self->{urlField} = $self->{parent}->{model}->{commonFields}->{url};
    
            foreach ($self->{table}->get_children)
            {
                $self->{table}->remove($_);
                $_->destroy;
            }
            
            my $row = 0;
            my $field;
            foreach $field(@{$self->{model}->{fieldsNames}})
            {
                next if $fieldsInfo->{$field}->{imported} ne 'true';
                next if ($field eq $self->{urlField});
                $self->createRowForField($field, $row);
                $row++;
            }
            
            $row++;
            if($self->{bottomline})
            {
                foreach($self->{bottomline}->get_children)
                {
                    $self->{bottomline}->remove($_);
                    $_->destroy;
                }
                $self->{bottomline}->destroy;
                undef $self->{bottomline};
            }
            $self->{bottomline}=new Gtk2::HBox;
            
            $self->{bottomline}->{selectAll}=new Gtk2::Button($parent->{lang}->{ImportSelectAll});
            $self->{bottomline}->{selectAll}->signal_connect('clicked' => sub {
                while ( my ($field, $row) = each(%{$self->{fields}}) ) {
                     $row->{'Cb'}->setValue(1);
                }
            });
            $self->{bottomline}->pack_start($self->{bottomline}->{selectAll},0,0,0);
            
            $self->{bottomline}->{selectNone}=new Gtk2::Button($parent->{lang}->{ImportSelectNone});
            $self->{bottomline}->{selectNone}->signal_connect('clicked' => sub {
                while ( my ($field, $row) = each(%{$self->{fields}}) ) {
                     $row->{'Cb'}->setValue(0);
                }
            });
            $self->{bottomline}->pack_start($self->{bottomline}->{selectNone},0,0,0);
            
            $self->{bottomline}->{clear}=new Gtk2::Button($parent->{lang}->{OptionsPluginsMultiPerFieldClearSelected});
            $self->{bottomline}->{clear}->signal_connect('clicked' => sub {
                while ( my ($field, $row) = each(%{$self->{fields}}) ) {
                     $self->removeAllSourceListFromField($field) if $row->{'Cb'}->getValue;
                }
            });
            $self->{bottomline}->pack_start($self->{bottomline}->{clear},0,0,0);
            
            $self->{bottomline}->{positionAddToAll} = new GCMenuList([{value=>'First',displayed=>$parent->{lang}->{OptionsPluginsMultiPerFieldFirst}},
                                                    {value=>'Last',displayed=>$parent->{lang}->{OptionsPluginsMultiPerFieldLast}}]);
            $self->{bottomline}->pack_end($self->{bottomline}->{positionAddToAll},0,0,0);
            
            $self->{bottomline}->{siteAddToAll} = $self->getSourcesListMenu;
            $self->{bottomline}->pack_end($self->{bottomline}->{siteAddToAll},0,0,0);
            
            $self->{bottomline}->{addToAll} = GCButton->newFromStock('gtk-add', 0);
            $self->{bottomline}->{addToAll}->signal_connect('clicked' => sub {
                    my $positionAdd=$self->{bottomline}->{positionAddToAll}->getValue(0) eq 'First' ? 0:-1;
                    foreach $field(keys %{$self->{fields}})
                    {
                        $self->addSiteListToField($field,$positionAdd,$self->{bottomline}->{siteAddToAll}->getValue(0));
                    }
            });
            $self->{bottomline}->pack_end($self->{bottomline}->{addToAll},0,0,0);
            
            $self->{layoutVBox}->pack_start($self->{bottomline},0,0,$GCUtils::margin);
         }


        sub loadPrefOrderListInForm
        {
            my $self = shift;
            # load from preference string
            undef $pluginListOrderPerField;
            undef $fieldsToFetch;
            my $valueStr = $self->{model}->{preferences}->multisiteperfield;
            my @arrValues= split ';', $valueStr;
            foreach (@arrValues)
            {
                my @line=split ',',$_;
                my $field=shift @line;
                $fieldsToFetch->{$field}=shift @line;
                $pluginListOrderPerField->{$field}=\@line if scalar(@line);
            }
            # add values in form 
            while ( my ($field, $row) = each(%{$self->{fields}}) ) {
                $self->removeAllSourceListFromField($field);
                $self->addSiteListToField($field,-1,$_) foreach (@{$pluginListOrderPerField->{$field}});
                $self->{fields}->{$field}->{Cb}->setValue($fieldsToFetch->{$field});
            }
            $self->cleanListOrder;
        }

        sub savePrefOrderListFromForm
        {
            my $self = shift;
            undef $pluginListOrderPerField;
            undef $fieldsToFetch;
            # load from form
            $self->cleanListOrder;
            while ( my ($field, $row) = each(%{$self->{fields}}) ) {
                $fieldsToFetch->{$field}= $row->{'Cb'}->getValue;
                push @{$pluginListOrderPerField->{$field}},$_->getValue foreach (@{$row->{'SiteListMenus'}});
            }
            # save to preference string
            my $valueStrArr = [];
            while ( my ($field, $row) = each(%{$self->{fields}}) ) {
                my $value=$field.','.$fieldsToFetch->{$field};
                $value=$value.','.join ',',@{$pluginListOrderPerField->{$field}} if $pluginListOrderPerField->{$field};
                push @$valueStrArr,$value;
            }
            $self->{model}->{preferences}->multisiteperfield(join ';',@$valueStrArr);
        }

        sub cleanListOrder
        {
            my $self = shift;
            # remove double sitename for each fields, keep the first one
            for my $field (keys %{$self->{fields}} ) {
                my $sites={};
                my $row=$self->{fields}->{$field}->{SiteListMenus};
                for (my $i = 0; $i <= $#$row; ++$i)
                {
                    if ($sites->{$row->[$i]->getValue})
                    {
                        $self->removeSiteListFromField($field,$i);
                        $i--;
                    }
                    else
                    {
                        $sites->{$row->[$i]->getValue}=1;
                    }
                }
                undef $sites;
            }
        }

        sub resetCurrentFetchingStatus
        {
            undef $remainingSourcesOrderPerField;
            foreach (keys %$fieldsToFetch)
            {
                $remainingSourcesOrderPerField->{$_}=Storable::dclone($pluginListOrderPerField->{$_}) if $fieldsToFetch->{$_} ;
            
            }
        }

        sub getNextSourceNeeded
        {
            my $self = shift;
            foreach my $field(keys %$remainingSourcesOrderPerField)
            {
                if (scalar(@{$remainingSourcesOrderPerField->{$field}})>0)
                {
                    return $remainingSourcesOrderPerField->{$field}->[0];
                }
            }
            return undef;
        }

        sub getPlugin
        {
            my ($self,$pluginName) = @_;
            return $self->{model}->getPlugin($pluginName);
        }

        sub getNonEmptyFields
        {
            my ($self,$info)=@_;
            my $nonEmptyFields=[];
            foreach my $field(keys %$info)
            {
                push @$nonEmptyFields,$field if $self->isFieldNonEmpty($info->{$field});
            }
            return $nonEmptyFields;
        }

        sub isFieldNonEmpty
        {
            my ($self,$var)=@_;
            return 0 if !defined $var;
            my $reftype=ref $var;
            if (!$reftype)
            {
                return $var ne '';
            }
            elsif ($reftype eq 'SCALAR')
            {
                return $$var ne '' && $var!=undef;
            }
            elsif ($reftype eq 'ARRAY')
            {
                return scalar($var)>0;
            }
            elsif ($reftype eq 'HASH')
            {
                return scalar(keys(%{$var}))>0;
            }
        }

        sub doneWithSourceName
        {
            my ($self,$pluginName,$info) = @_;
            foreach my $field(keys %$remainingSourcesOrderPerField)
            {
                foreach my $pluginIdx (0..$#{$remainingSourcesOrderPerField->{$field}})
                {
                    if ($remainingSourcesOrderPerField->{$field}->[$pluginIdx] eq $pluginName)
                    {
                        if ($self->isFieldNonEmpty($info->{$field}))
                        {
                            # if we have the field, so we wont need other info
                            $#{$remainingSourcesOrderPerField->{$field}}=$pluginIdx-1;
                            last;
                        }
                        else
                        {
                            # else we will still need the next one
                            splice @{$remainingSourcesOrderPerField->{$field}},$pluginIdx,1;
                            last;
                        }
                    }
                }
            }
        }

        sub joinInfo
        {
            my ($self,$infoPerPlugin) = @_;
            my $info={};
            my $fetchedSources=Storable::dclone($pluginListOrderPerField);
            my %urls;
            my $urlField=$self->{parent}->{model}->{commonFields}->{url};
            foreach my $field(keys %$pluginListOrderPerField)
            {
                shift @{$fetchedSources->{$field}} while (scalar(@{$fetchedSources->{$field}}) && !$self->isFieldNonEmpty($infoPerPlugin->{$fetchedSources->{$field}->[0]}->{$field}));
                if (scalar(@{$fetchedSources->{$field}})>0)
                {
                    $info->{$field}=$infoPerPlugin->{$fetchedSources->{$field}->[0]}->{$field} ;
                    $urls{$fetchedSources->{$field}->[0]}=$infoPerPlugin->{$fetchedSources->{$field}->[0]}->{$urlField};
                }
            }
            $info->{$urlField}=join ';',values %urls;
            return $info;
        }
    }
}

{
    package GCResultsDialog;
    use base 'GCModalDialog';

    sub show
    {
        my $self = shift;
        for my $i (0..$self->{nbCols} - 1)
        {
            $self->{results}->get_column($i)->set_sort_indicator(0);
        }
        $self->{order} = 1;
        $self->{sort} = '';

        $self->{validated} = 0;
        $self->SUPER::show();
        $self->show_all;
        $self->{nextButton}->hide if !$self->{withNext};
        $self->{multipleSelectionLabel}->hide if ! $self->{multipleSelection};
        my $ended = 0;
        my $code;
        while (!$ended)
        {
            $code = $self->run;
            if ($code eq 'ok')
            {
                $self->{validated} = 1;
                $self->{itemsIndexes} = [];
                my @idxs = $self->{results}->get_selected_indices;
                foreach my $idx(@idxs)
                {
                    push @{$self->{itemsIndexes}}, $self->{items}->[$idx]->{'#'};
                }
            }
            elsif ($code eq 'yes')
            {
                my @idx = $self->{results}->get_selected_indices;
                my $itemIndex = $self->{items}->[$idx[0]]->{'#'};
                $self->{parent}->downloadItemInfoFromPlugin($self->{plugin}, $itemIndex, 1);
            }
            $ended = 1 if ($code eq 'ok') || ($code eq 'cancel') || ($code eq 'delete-event') || ($code eq 'no');
        }
        $self->hideTooltip;
        $self->hide;
        return ($code eq 'no');
    }

    sub getItemsIndexes
    {
        my $self = shift;
        return $self->{itemsIndexes};
    }

    sub setMultipleSelection
    {
        my ($self, $activate) = @_;
        return if !$self->{results};
        $self->{results}->get_selection->set_mode ($activate ? 'multiple' : 'single');
        $self->{multipleSelection} = $activate;
    }

    sub setWithNext
    {
        my ($self, $value) = @_;
        
        $self->{withNext} = $value;
    }

    sub setSearchPlugin
    {
        my ($self, $plugin) = @_;
       
        $self->{plugin} = $plugin;
        $self->set_title($self->{parent}->{lang}->{ResultsTitle}.' ('.$plugin->getName.')');
 
        for my $i (0..$self->{nbCols} - 2)
        {
            # If plugin is a multi-pass plugin, then update the column headers for this pass
            $plugin->getReturnedFields() if $plugin->getNumberPasses > 1;

            $self->{results}->get_column($i)->set_visible($plugin->hasField($self->{fields}->[$i]));
        }
 
        if ($plugin->getExtra)
        {
            $self->{results}->get_column($self->{nbCols} - 1)->set_visible(1);
            $self->{results}->get_column($self->{nbCols} - 1)->set_title($plugin->getExtra);
            $self->{withExtra} = 1;
        }
        else
        {
            $self->{results}->get_column($self->{nbCols} - 1)->set_visible(0);
            $self->{withExtra} = 0;
        }
    }

    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent,
                                       $parent->{lang}->{ResultsTitle},
                                       undef, 0,
                                       'gtk-zoom-in' => 'yes'
                                      );
        bless ($self, $class);

        $self->{results} = 0;
        $self->{withExtra} = 0;
        $self->{withNext} = 0;
        $self->{multipleSelection} = 0;
        $self->{nextButton} = Gtk2::Button->new_from_stock('gtk-go-forward');
        $parent->{tooltips}->set_tip($self->{nextButton},
                                     $parent->{lang}->{ResultsNextTip});
        $self->add_action_widget($self->{nextButton}, 'no');

        $self->{parent} = $parent;

        $self->set_modal(1);
        $self->set_position('center');

        $self->{scrollPanelList} = new Gtk2::ScrolledWindow;
        $self->{scrollPanelList}->set_policy ('never', 'automatic');
        $self->{scrollPanelList}->set_shadow_type('etched-in');
                                            
        $self->vbox->pack_start($self->{scrollPanelList}, 1, 1, 0);
        $self->vbox->pack_start(Gtk2::HSeparator->new, 0, 0, 0);
        my $fillBox = new Gtk2::HBox(0,0);
        $self->{multipleSelectionLabel} = GCLabel->new('<i>'.$parent->{lang}->{ResultsInfo}.'</i>');
        $self->{multipleSelectionLabel}->set_line_wrap(1);
        $self->{multipleSelectionLabel}->set_justify('center');
        $self->{multipleSelectionLabel}->set_padding($GCUtils::margin, 0);
        $fillBox->pack_start(Gtk2::HBox->new(0,0),1,1,0);
        $fillBox->pack_start($self->{multipleSelectionLabel}, 0, 0, $GCUtils::margin);
        $fillBox->pack_start(Gtk2::HBox->new(0,0),1,1,0);
        $self->vbox->pack_start($fillBox, 0 , 0, $GCUtils::margin);
         
        # To create a tooltip as it is not implemented directly in Gtk2
        $self->{tooltipLabel} = Gtk2::Label->new;
        $self->{tooltipLabel}->set_line_wrap(1);
        $self->{tooltipLabel}->set_padding($GCUtils::margin, $GCUtils::margin);
        $self->{tooltip} = Gtk2::Window->new('popup');
        $self->{tooltip}->set_decorated(0);
        $self->{tooltip}->set_sensitive(1);
        $self->{tooltip}->modify_fg('normal', Gtk2::Gdk::Color->parse('#000000'));
        $self->{tooltip}->modify_bg('normal', Gtk2::Gdk::Color->parse('#ffffbf'));
        $self->{tooltip}->set_position('mouse');
        $self->{tooltip}->add($self->{tooltipLabel});
        $self->{tooltip}->signal_connect('button_press_event' => sub {
            $self->hideTooltip;
            if ($self->{results})
            {
                shift;
                $self->{results}->signal_emit('button_press_event', @_);
            }
        });
        $self->{tooltip}->signal_connect('motion-notify-event' => sub {
            my ($widget, $event) = @_;
            my ($x, $y) = ($event->x_root, $event->y_root);
            my ($xoffset, $yoffset) = $widget->window->get_root_origin;
            my $allocation = $widget->allocation();
            my $x1 = $xoffset + 2 * $allocation->x;
            my $y1 = $yoffset + 2 * $allocation->y;
            my $x2 = $x1 + $allocation->width;
            my $y2 = $y1 + $allocation->height;
            my $isInWidget = ($x > $x1 && $x < $x2 && $y > $y1 && $y < $y2);
            
            return if $isInWidget;
            if ($self->{results})
            {
                shift;
                $self->{results}->signal_emit('motion-notify-event', @_);
            }            
        });
        $self->{tooltipDisplayed} = 0;        
 
        return $self;
    }

    sub setModel
    {
        my ($self, $model, $fieldsInfo) = @_;
        
        if ($self->{results})
        {
            $self->{scrollPanelList}->remove($self->{results});
            $self->{results}->destroy;
        }

        
        $self->{fields} = [];
        my @cols;
        
        foreach my $field(@{$model->{resultsFields}})
        {
            push @cols, ($fieldsInfo->{$field}->{displayed} => 'text');
            push @{$self->{fields}}, $field;
        }
        
        # Extra column
        push @cols, ('' => 'text');
        push @{$self->{fields}}, 'extra';

        $self->{nbCols} = scalar @{$self->{fields}};
        
        $self->{results} = Gtk2::SimpleList->new(@cols);
        
        $self->{results}->set_rules_hint(1);
        $self->{results}->set_headers_clickable(1);

        $self->{order} = 1;
        $self->{sort} = '';
        
        for my $i (0..$self->{nbCols} - 1)
        {
            $self->{results}->get_column($i)->set_sort_indicator(0);
            $self->{results}->get_column($i)->set_resizable(1);
            $self->{results}->get_column($i)->signal_connect('clicked' => sub {
                $self->sort($self->{fields}->[$i]);
            });
            $self->{results}->get_column($i)->{column_number} = $i;
        }
         
       $self->{scrollPanelList}->add($self->{results});

       $self->{results}->signal_connect(row_activated => sub {
            my ($sl, $path, $column) = @_;
            $self->response('ok');
        });
        $self->{results}->signal_connect('motion-notify-event' => sub {
            my ($widget, $event) = @_;
            $self->displayTooltip($event);
        });
        $self->{results}->signal_connect('leave-notify-event' => sub {
            my ($widget, $event) = @_;
            # It corresponds to a leave of the whole widget not from a single cell
            $self->hideTooltip if $event->detail eq 'ancestor';
        });
        
        $self->{multipleSelectionLabel}->set_markup('<i>'.$self->{parent}->{lang}->{ResultsInfo}.'</i>');

    }

    sub sort
    {
        my ($self, $type) = @_;
        
        my $col = 0;
        
        for my $i (0..$self->{nbCols} - 1)
        {
            $self->{results}->get_column($i)->set_sort_indicator(0);
            $col = $i if $self->{fields}->[$i] eq $type;
        }
        
        my @items = @{$self->{items}};
        
        if ($self->{sort} eq $type)
        {
            $self->{order} = 1 - $self->{order}
        }
        else
        {
            $self->{order} = 1;
        }

        @items = sort {$a->{$type} cmp $b->{$type}} @items;
        
        @items = reverse @items if ! $self->{order};
        
        $self->{results}->get_column($col)->set_sort_indicator(1);
        $self->{results}->get_column($col)->set_sort_order($self->{order} ? 'ascending' : 'descending');
        
        $self->setList('',@items);

        $self->{sort} = $type;
    }
    
    sub setList
    {
        my ($self, $title, @items) = @_;
        
        $self->set_title($self->get_title . ' - '.$title) if $title;
        
        $self->{items} = \@items;

        @{$self->{results}->{data}} = ();
        $self->{tooltipsStrings} = {};

        my $idx = 0;
        my $col = 0;
        foreach my $item (@items)
        {
            my $infos = [];
            $col = 0;
            foreach my $field(@{$self->{fields}})
            {
                my $value = '';
                $value = $item->{$field} if exists $item->{$field};
                (my $shortField = $value) =~ s/(.{40}).*/$1.../;
                push @$infos, $shortField."\n";
                # We store a tooltip is the text has been truncated
                $self->{tooltipsStrings}->{$idx}->{$col} = $value
                    if $value ne $shortField;
                $col++;
            }
            $item->{'#'} = $idx if ! exists $item->{'#'};
            push @{$self->{results}->{data}}, $infos;
            #push @{$self->{tooltipsStrings}}, $item->{$self->{fields}->[0]};
            $idx++;
        }
        $self->{results}->select(0);
        $self->{results}->columns_autosize;
        $self->set_default_size(-1,400);
    }
 
 
     sub displayTooltip 
     {        
        my ($self, $event) = @_;
        my ($path, $column, $cell_x, $cell_y) = $self->{results}->get_path_at_pos ($event->x, $event->y);
        if ($path)
        {
            my $model = $self->{results}->get_model;
            my $col = $column->{column_number};
            my $row = $path->to_string();
            
            # If a new cell is selected, then hide the tooltip
            # It'll be re-shown as required by the code down under
            if ($self->{selectedRow} ne $row or $self->{selectedCol} != $col)
            {
                $self->hideTooltip;
                $self->{selectedRow} = $row;
                $self->{selectedCol} = $col;
            }
            else
            {
                return;
            }
            if ($row ne '')
            {
                # Pick that popup string from our hash
                #my $str = $popup_hash->{$row}->{$i};
                my $str = $self->{tooltipsStrings}->{$row}->{$col};
                if ($str)
                {
                    $self->{tooltipLabel}->set_label($str);
                    if (!$self->{tooltipDisplayed})
                    {
                        $self->{tooltip}->show_all;
                        Gtk2->grab_add($self->{tooltip});
                        Gtk2::Gdk->pointer_grab(
                            $self->{tooltip}->window, 1,
                            [qw/button-press-mask button-release-mask pointer-motion-mask/],
                            undef, undef, 0);
                        Gtk2::Gdk->keyboard_grab ($self->{tooltip}->window, 0, 0);
                        $self->{tooltip}->grab_focus;
                        my ($thisx, $thisy) = $self->{tooltip}->window->get_origin;
                        # The window to be a bit away from the mouse pointer.
                        $self->{tooltip}->move($thisx, $thisy-20);
                        $self->{tooltipDisplayed} = 1;
                    } 
                } 
            }
            return 0;
        }
    }
    
    sub hideTooltip
    {
        my $self = shift;
        if ($self->{tooltipDisplayed})
        {
            Gtk2->grab_remove($self->{tooltip});
            $self->{tooltip}->hide;
            $self->{tooltipDisplayed} = 0;
        }
     }
   
}

{
    package GCImportFieldsDialog;
    use base 'GCModalDialog';

    sub setReadOnly
    {
        my ($self, $value) = @_;
        $self->{readOnly} = $value;
        my @children = $self->{table}->get_children;
        foreach (@children)
        {
            $_->set_sensitive(!$value) if ($_->get_name eq 'GtkCheckButton')
                                       && (!$_->{mandatory});
        }
        $self->set_title($value ? $self->{parent}->{lang}->{ResultsPreview}
                                : $self->{parent}->{lang}->{ImportWindowTitle});
    }

    sub info
    {
        my $self = shift;
        
        my $fieldsInfo = $self->{parent}->{model}->{fieldsInfo};
        
        if (@_)
        {
            my $info = shift;

            $self->{info} = $info;
        
            my @children = $self->{table}->get_children;
            foreach (@children)
            {
                $_->set_text('') if $_->get_name eq 'GtkEntry';
            }

            my $fieldsInfo = $self->{parent}->{model}->{fieldsInfo};        
            foreach (keys %{$info})
            {
                my $tmp = $info->{$_};
                if ($fieldsInfo->{$_}->{type} =~ /list/)
                {
                    $tmp = GCPreProcess::multipleList($tmp, $fieldsInfo->{$_}->{type});
                }
                if ($fieldsInfo->{$_}->{values})
                {
                    $tmp = $self->{parent}->{model}->getDisplayedValue($fieldsInfo->{$_}->{values},
                                                                       $tmp);
                }
                if ($_ ne $self->{urlField})
                {
                    $tmp =~ s/\n/ /g;
                    $tmp =~ s/(.{50}).*/$1.../m;
                }
                $self->{$_}->set_text($tmp)
                    if $self->{$_};
            }
        }
        else
        {
            my $ignore = $self->{parent}->{ignoreString};
            
            foreach my $field(@{$self->{parent}->{model}->{fieldsNames}})
            {
                next if $fieldsInfo->{$field}->{imported} ne 'true';
                next if ($fieldsInfo->{$field}->{type} eq 'url');
                if (! $self->{$field.'Cb'}->get_active)
                {
                    unlink $self->{info}->{$field}
                        if ($fieldsInfo->{$field}->{type} eq 'image')
                        && ($self->{info}->{$field} !~ m|^http://|);
                    $self->{info}->{$field} = $ignore;
                }
            }            

            return $self->{info};
        }
    }
    
    sub showImage
    {
        use File::Temp qw/ :POSIX  /;
        
        my ($self, $field) = @_;
        
        my $location = $self->{info}->{$field};
        if ($location =~ m|^http://|)
        {
            my ($name,$path,$suffix) = File::Basename::fileparse($location, "\.gif", "\.jpg", "\.jpeg", "\.png");
            $self->window->set_cursor(Gtk2::Gdk::Cursor->new('watch'));
            GCUtils::updateUI;
            (my $tmpFile = tmpnam) .= $suffix;
            GCUtils::downloadFile($location, $tmpFile, $self->{parent});
            $self->window->set_cursor(Gtk2::Gdk::Cursor->new('left_ptr'));
            $self->{parent}->launch($tmpFile, 'image', 0, $self);
            $self->{info}->{$field} = $tmpFile;
        }
        else
        {
            $self->{parent}->launch($location, 'image', 0, $self);
        }
    }
    
    sub show
    {
        my $self = shift;

        $self->SUPER::show();
        $self->show_all;
        if ($self->{readOnly})
        {
            $self->{selectAll}->hide;
            $self->{selectNone}->hide;
            ($self->action_area->get_children)[1]->hide;
        }
        
        foreach (keys %{$self->{imagesButton}})
        {
            $self->{$_}->hide if $self->{info}->{$_};
            $self->{imagesButton}->{$_}->hide if ! $self->{info}->{$_};
        }
        my $response = $self->run;
        $self->hide;
        return ($response eq 'ok');
    }

    sub createItem
    {
        my ($self, $field, $row, $mandatory) = @_;
        my $fieldsInfo = $self->{parent}->{model}->{fieldsInfo};
        $self->{$field.'Cb'} = new Gtk2::CheckButton($self->{parent}->{model}->getDisplayedText($fieldsInfo->{$field}->{label}));
        if ($mandatory)
        {
            $self->{$field.'Cb'}->set_sensitive(0);
            $self->{$field.'Cb'}->set_active(1);
            $self->{$field.'Cb'}->{mandatory} = 1;
        }
        $self->{$field} = new Gtk2::Entry;
        $self->{$field}->set_editable(0);
        $self->{table}->attach($self->{$field.'Cb'}, 0, 1, $row, $row + 1, 'fill', ['fill', 'expand'], 0, 0);
        $self->{table}->attach($self->{$field}, 1, 2, $row, $row + 1, ['fill', 'expand'], 'fill', 0, 0);
    }

    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent,
                                       $parent->{lang}->{ImportWindowTitle}
                                      );

        bless ($self, $class);
        
        $self->{parent} = $parent;
 
        $self->set_modal(1);
        $self->set_position('center');
        $self->set_default_size(1,500);

        $self->{table} = new Gtk2::Table(1, 2, 0);
        $self->{table}->set_row_spacings($GCUtils::halfMargin);
        $self->{table}->set_col_spacings($GCUtils::margin);
        $self->{table}->set_border_width($GCUtils::margin);

        $self->{scrollPanelList} = new Gtk2::ScrolledWindow;
        $self->{scrollPanelList}->set_policy ('never', 'automatic');
        $self->{scrollPanelList}->set_shadow_type('none');
        $self->{scrollPanelList}->add_with_viewport($self->{table});

        $self->vbox->pack_start($self->{scrollPanelList},1,1,$GCUtils::margin);

        $self->setModel($parent->{model});

        return $self;
    }
    
    sub setModel
    {
        my ($self, $model) = @_;
        
        my $parent = $self->{parent};
        
        $self->{model} = $model;
        my $fieldsInfo = $model->{fieldsInfo};
        $self->{urlField} = $self->{parent}->{model}->{commonFields}->{url};

        foreach ($self->{table}->get_children)
        {
            $self->{table}->remove($_);
            $_->destroy;
        }

        my $row = 0;
        
        my @picFields;
        my $field;
        foreach $field(@{$model->{fieldsNames}})
        {
            next if $fieldsInfo->{$field}->{imported} ne 'true';
            next if ($field eq $self->{urlField});
            if ($fieldsInfo->{$field}->{type} eq 'image')
            {
                push @picFields, $field;
                next;
            }
            $self->createItem($field, $row);
            $row++;
        }
        
        foreach $field(@picFields)
        {
            $self->createItem($field, $row);
            $self->{imagesButton}->{$field} = new Gtk2::Button($parent->{lang}->{ImportViewPicture});
            $self->{imagesButton}->{$field}->signal_connect('clicked' => sub {
                $self->showImage($field);
            });
            $self->{table}->attach($self->{imagesButton}->{$field}, 1, 2, $row, $row + 1, 'fill', 'fill', 0, 0);
            $row++;
        }

        if ($self->{urlField})
        {
            $self->createItem($self->{urlField}, $row, 1);
            $row++;
        }

        $row++;

        $self->{selectAll} = new Gtk2::Button($parent->{lang}->{ImportSelectAll});
        $self->{selectAll}->signal_connect('clicked' => sub {
                my @children = $self->{table}->get_children;
                foreach (@children)
                {
                    $_->set_active(1) if $_->get_name eq 'GtkCheckButton';
                }
        });
        $self->{table}->attach($self->{selectAll}, 0, 1, $row, $row + 1, 'fill', 'fill', 0, 0);
        $row++;
        $self->{selectNone} = new Gtk2::Button($parent->{lang}->{ImportSelectNone});
        $self->{selectNone}->signal_connect('clicked' => sub {
                my @children = $self->{table}->get_children;
                # Remove 2 items corresponding to website to keep it checked
                splice @children, 2, 2;
                foreach (@children)
                {
                    $_->set_active(0) if $_->get_name eq 'GtkCheckButton';
                }
        });
        $self->{table}->attach($self->{selectNone}, 0, 1, $row, $row + 1, 'fill', 'fill', 0, 0);


    }
    
}

1;
