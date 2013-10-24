package GCModel;

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
use GCPlugins;

use Storable;

our $modelsSuffix = '.gcm';
our $autoId = 'gcsautoid';
our $autoField = 'GCSAuto';
our $noneField = 'GCSNone';
our $initDefault = 'DefaultNewItem';
our $linkNameSeparator = '##';

{
    package GCModelLoader;

    use GCUtils 'glob';
    use XML::Simple;
    $XML::Simple::PREFERRED_PARSER='XML::Parser';
    #$XML::Simple::PREFERRED_PARSER='XML::SAX::Expat';

    sub load
    {
        my ($self, $file) = @_;
        open XML, $file;
        binmode(XML, ':utf8');
        $self->{xmlString} = do {local $/; <XML>};
        $self->loadFromString;
        close XML;
    }

    sub loadFromString
    {
        my $self = shift;
        my $xs = XML::Simple->new;
        return if ! $self->{xmlString};
        $self->{collection} = $xs->XMLin($self->{xmlString},
                                         ForceArray => ['item', 'values', 'filter', 'panel', 'group', 'field'],
                                         KeyAttr => {
                                                     'values' => 'id'
                                                    }
                                        );
        $self->doInitialization;
    }
    
    sub doInitialization
    {
        my $self = shift;
        $self->{groups} = $self->{collection}->{groups}->{group};
        $self->{fields} = $self->{collection}->{fields}->{field};
        #$self->{filters} = $self->{collection}->{filters}->{filter};
        $self->initFilters;
        $self->{options} = $self->{collection}->{options};
        $self->{commonFields} = $self->{collection}->{options}->{fields};
        $self->{resultsFields} = $self->{collection}->{options}->{fields}->{results}->{field};
        $self->{summaryFields} = $self->{collection}->{options}->{fields}->{summary}->{field};
        $self->{defaultImage} = $ENV{GCS_SHARE_DIR}.'/logos/'.$self->{options}->{defaults}->{image};
        $self->{userFiltersDir} = $ENV{GCS_DATA_HOME}.'/Filters/'.$self->getName;
        $self->{random} = $self->{collection}->{random}->{filter};
        
        my $lang = exists $self->{collection}->{lang} ? $self->{collection}->{lang} : "GCgeneric";
        my $langName = $self->{parent}->{options}->lang;
        my %tmpLang;

        # The string should be splitted to avoid considering some scopped variables
        eval "use GCLang::$langName"."::GCModels::$lang\n";
        eval "%tmpLang = %GCLang::$langName"."::GCModels::".$lang."::lang";
        $self->{lang} = \%tmpLang;
        
        $self->loadPreferences;
        #$self->checkMaster;
        $self->addDefaultFields;
        $self->addPredefinedValues;
        $self->{searchFields} = 0;
        $self->checkLending;
        $self->checkTags;
        $self->initFields;
        $self->setDefaults;
        $self->initPanels;
    }

    sub getSearchFields
    {
        my $self = shift;
        
        if (!$self->{searchFields})
        {
            if (exists $self->{collection}->{options}->{fields}->{search})
            {
                $self->{searchFields} = [];
                push @{$self->{searchFields}}, $_
                    foreach (@{$self->{collection}->{options}->{fields}->{search}->{field}})
            }
            else
            {
                $self->{searchFields} = [$self->{commonFields}->{title}];
            }
        }
        return $self->{searchFields};
    }

    sub getSummaryFields
    {
        my $self = shift;
        
        if (!$self->{summaryFields})
        {
            $self->{summaryFields} = [];
            for my $field (@{$self->{resultsFields}})
            {
                next if $field eq $self->{commonFields}->{title};
                push @{$self->{summaryFields}}, $field;
            }
        }
        return $self->{summaryFields};
    }

    sub isSearchField
    {
        my ($self, $field) = @_;
        foreach (@{$self->getSearchFields})
        {
            return 1 if $field eq $_;
        }
        return 0;
    }

    sub hasRandom
    {
        my $self = shift;
        return ($self->{random} && (scalar @{$self->{random}})) ? 1 : 0;
    }

    sub hasPlay
    {
        my $self = shift;
        return ($self->{commonFields}->{play}) ? 1 : 0;
    }

    sub saveToFile
    {
        my ($self, $file) = @_;
        
        if (!open DATA, '>'.$file)
        {
            print "Could not save collection description in $file\n";
            return 0;
        }
        binmode(DATA, ':utf8');
        print DATA '<?xml version="1.0" encoding="UTF-8"?>
';
        print DATA $self->toString('collection', 1);
        close DATA;
        $self->{isInline} = 0;
    }
    
    sub setFields
    {
        my ($self, $fields, $hasLending, $hasTags) = @_;
        #Force panel generation
        delete $self->{collection}->{panels}->{panel};
        $self->{collection}->{fields}->{field} = $fields;
        $self->{collection}->{fields}->{lending} = ($hasLending ? 'true' : 'false');
        $self->{collection}->{fields}->{tags} = ($hasTags ? 'true' : 'false');
        $self->doInitialization;
    }
    
    sub setGroups
    {
        my ($self, $groups) = @_;
        
        $self->{collection}->{groups}->{group} = $groups;
    }
    
    sub setOptions
    {
        my ($self, $fields, $defaultImage) = @_;
        $self->{collection}->{options}->{fields} = $fields;
        $self->{collection}->{options}->{defaults}->{image} = $defaultImage;
    }
    
    sub getCommonFields
    {
        my $self = shift;
        
        return $self->{collection}->{options}->{fields};
    }
    
    sub getOriginalCollection
    {
        my ($self, $withPanel) = @_;
        #First we clone our collection to do remove everything that have been auto-generated
        my $collection = Storable::dclone($self->{collection});
        foreach (@{$collection->{fields}->{field}})
        {
            delete $_->{hasHistory};
        }
        delete $collection->{panels} if ! $withPanel;
        if ($self->{hasLending})
        {
            my @fields = @{$collection->{fields}->{field}};
            for (my $i = 0; $i <= $#fields; $i++)
            {
                delete $collection->{fields}->{field}->[$i]
                    if $fields[$i]->{group} eq 'lending';
            }
            delete $collection->{groups}->{group}->[(scalar @{$collection->{groups}->{group}}) - 1];
        }
        if ($self->{hasTags})
        {
            my @fields = @{$collection->{fields}->{field}};
            for (my $i = 0; $i <= $#fields; $i++)
            {
                delete $collection->{fields}->{field}->[$i]
                    if $fields[$i]->{group} eq 'tagpanel';
            }
            delete $collection->{groups}->{group}->[(scalar @{$collection->{groups}->{group}}) - 1];
        }
        if ($self->{defaultModifier})
        {
            delete $collection->{fields}->{lending};
            delete $collection->{fields}->{tags};
            delete $collection->{options};
            delete $collection->{random};
        }
        return $collection;
    }

    sub getAddedFields
    {
        my $self = shift;
        return [] if ! $self->{addedModel};
        return $self->{addedModel}->{collection}->{fields}->{field};
    }
    
    sub getAddedGroups
    {
        my $self = shift;
        return {} if ! $self->{addedModel};
        return $self->{addedModel}->getGroups;
    }

    sub toString
    {
        my ($self, $root, $withPanel) = @_;
        my $xs = XML::Simple->new;
        my $collection = $self->getOriginalCollection($withPanel);
        my $xmlData = $xs->XMLout($collection,
                                  RootName => $root,
                                  KeyAttr => {'group' => '',
                                              'values' => 'id'
                                             });
        if ($self->{defaultModifier})
        {
            $xmlData =~ s|(</?)item|$1userItem|g;
        }
        return $xmlData;
    }

    sub toStringAddedFields
    {
        my ($self, $root) = @_;
        if (($self->{addedModel})
         && exists $self->{addedModel}->{fieldsNames}
         && scalar @{$self->{addedModel}->{fieldsNames}})
        {
            return $self->{addedModel}->toString($root, 1);
        }
        else
        {
            return '';
        }
    }

    sub loadPreferences
    {
        my $self = shift;
        if (! $self->{isInline})
        {
            $self->{configFile} = $ENV{GCS_CONFIG_HOME}.'/GCModels/'.$self->getName.'.conf';
            $self->{preferences} = new GCOptionLoader($self->{configFile}, 0, $self->{parent}->{options});
        }
        $self->{defaultValuesFile} = $ENV{GCS_CONFIG_HOME}.'/GCModels/'.$self->getName.'.default.gcs';
    }

    sub setDefaults
    {
        my $self = shift;
        
        $self->{fieldsInfo}->{$self->{commonFields}->{title}}->{init} = $GCModel::initDefault
            if ! $self->{fieldsInfo}->{$self->{commonFields}->{title}}->{init};
        
        $self->{preferences}->groupBy($self->{options}->{defaults}->{groupby})
            if ! $self->{preferences}->exists('groupBy');

        $self->{preferences}->quickSearchField($self->{commonFields}->{title})
            if ! $self->{preferences}->exists('quickSearchField');
    }

    sub isEmpty
    {
        my $self = shift;
        return (!$self->{fields} || ((scalar @{$self->{fields}}) == 0));
    }

    sub isPersonal
    {
        my $self = shift;
        return ($self->{isInline} || $self->{isPersonal});
    }

    sub isInline
    {
        my $self = shift;
        return $self->{isInline};
    }

    sub initFields
    {
        my $self = shift;
        
        my @fieldsNames;
        my %fieldsInfo;
        my @fieldsHistory;
        my @fieldsNotNull;
        my @fieldsNotFormatted;
        my @fieldsImage;
        my @fieldsDate;
        my @managedImages;
        my $name;
        foreach (@{$self->{fields}})
        {
            $name = $_->{value};
            push @fieldsNames, $name;
            $fieldsInfo{$name} = $_;
            $fieldsInfo{$name}->{displayed} = $self->getDisplayedText($fieldsInfo{$name}->{label});
            if (($_->{type} =~ /history/)
            || (
                 ($_->{type} =~ /list/)
              && ((!exists $_->{history}) || ($_->{history} ne 'false'))
               ))
            {
                push @fieldsHistory, $name;
                $fieldsInfo{$name}->{hasHistory} = 1;
            }
            elsif ($_->{type} eq 'image')
            {
                push @fieldsImage, $name;
                push @managedImages, $name if (exists $_->{imported}) && ($_->{imported} eq 'true');
            }
            elsif ($_->{type} eq 'date')
            {
                push @fieldsDate, $name;
            }
            push @fieldsNotNull, $name
                if (exists $_->{notnull}) && ($_->{notnull} eq 'true');
            push @fieldsNotFormatted, $name
                if ((!exists $_->{type}) || ($_->{type} ne 'formatted'));
        }
        $self->{fieldsNames} = \@fieldsNames;
        $self->{fieldsInfo} = \%fieldsInfo;
        $self->{fieldsHistory} = \@fieldsHistory;
        $self->{fieldsNotNull} = \@fieldsNotNull;
        $self->{fieldsNotFormatted} = \@fieldsNotFormatted;
        $self->{managedImages} = \@managedImages;
        $self->{fieldsImage} = \@fieldsImage;
        $self->{fieldsDate} = \@fieldsDate;
    }

    sub setFilters
    {
        my ($self, $filters) = @_;
        $self->{filters} = [];
        $self->{filtersGroup} = [];
        my %existingGroups = ();
        my $idxGroup = 0;
        # The filters have not groups. And we need to do some copy here
        #foreach (keys %$filters)
        foreach (@{$self->{fieldsNames}})
        {
            next if ! exists $filters->{$_};
            my $filter = {
                           field => $_,
                           comparison => $filters->{$_}->{comparison},
                           numeric => $filters->{$_}->{numeric},
                           quick => $filters->{$_}->{quick}
            };
            $filter->{labelselect} = $filters->{$_}->{labelselect} if $filters->{$_}->{labelselect};
            push @{$self->{filters}}, $filter;
            my $group = $self->{fieldsInfo}->{$_}->{group};
            if (! exists $existingGroups{$group})
            {
                $existingGroups{$group} = $idxGroup;
                $self->{filtersGroup}->[$idxGroup] = {label => $group};
                $idxGroup++;
            }
            push @{$self->{filtersGroup}->[$existingGroups{$group}]->{filter}}, $filter;
        }
        $self->{collection}->{filters}->{group} = $self->{filtersGroup};
    }

    sub initFilters
    {
        my $self = shift;
        
        for my $group (@{$self->{collection}->{filters}->{group}})
        {
            foreach (@{$group->{filter}})
            {
                push @{$self->{filters}}, $_;
            }
        }
        $self->{filtersGroup} = $self->{collection}->{filters}->{group};
    }

    sub getUserFilters
    {
        my $self = shift;
        # Deactive user filters for personal collections without a name
        return [] if ! $self->getName;
        if (!$self->{userFilters})
        {
            my @filters;
            mkdir $self->{userFiltersDir};
            foreach my $filterFile(sort {uc($a) cmp uc($b)} glob($self->{userFiltersDir}.'/*'))
            {
                my $xs = XML::Simple->new;
                my $filter = $xs->XMLin($filterFile,
                                        ForceArray => ['info', 'filter']);
                $self->{isUserFilterSaved}->{$filter->{name}} = 1;
                foreach my $info (@{$filter->{info}})
                {
                    $info->{filter}->[1] = 0 if ref $info->{filter}->[1] eq 'HASH';
                    $info->{filter}->[2] = undef if ref $info->{filter}->[2] eq 'HASH';
                }
                push @filters, $filter;
            }
            $self->{userFilters} = \@filters;
        }
        return $self->{userFilters};
    }

    sub filterNameToFile
    {
        my ($self, $name) = @_;
        my $fileName = GCUtils::getSafeFileName($name);
        return $self->{userFiltersDir}."/$fileName";
    }

    sub saveUserFilters
    {
        my $self = shift;
        my $xs = XML::Simple->new;
        foreach my $filter(@{$self->{userFilters}})
        {
            next if $self->{isUserFilterSaved}->{$filter->{name}};
            $xs->XMLout($filter,
                        RootName => 'search',
                        OutputFile => $self->filterNameToFile($filter->{name}));
            $self->{isUserFilterSaved}->{$filter->{name}} = 1;
        }
    }
    
    sub setUserFilters
    {
        my ($self, $filters) = @_;
        $self->{userFilters} = $filters;
        # Make sure they will be saved if needed
        foreach my $filter(@$filters)
        {
            $self->{isUserFilterSaved}->{$filter->{name}} = $filter->{saved};
            # This should not be saved
            delete $filter->{saved};
        }
    }

    sub addUserFilter
    {
        my ($self, $filter) = @_;
        push (@{$self->{userFilters}}, $filter);
        my @sorted = sort {uc($a->{name}) cmp uc($b->{name})} @{$self->{userFilters}};
        $self->{userFilters} = \@sorted;
        $self->{isUserFilterSaved}->{$filter->{name}} = 0;
    }

    sub deleteUserFilters
    {
        my ($self, $names) = @_;
        foreach my $name(@$names)
        {
            unlink $self->filterNameToFile($name);
        }
    }

    sub existsUserFilter
    {
        my ($self, $name) = @_;
        return 1 if exists $self->{isUserFilterSaved}->{$name};
        return 1 if -e $self->filterNameToFile($name);
    }

    sub addDefaultFields
    {
        my $self = shift;
        return if $self->isEmpty || $self->{defaultModifier};
        if (! $self->{commonFields}->{id})
        {
            $self->{commonFields}->{id} = $GCModel::autoId;
            push @{$self->{fields}},
                {
                    value => $self->{commonFields}->{id},
                    type => 'number',
                    label => '',
                    init => '',
                    group => '',
                    imported => 'false'
                };
        }
    }

    sub addPredefinedValues
    {
        my $self = shift;
        
        # Add file size units if needed
        my @array;
        my $val = 0;
        foreach (@{$self->{parent}->{lang}->{PropertiesFileSizeSymbols}})
        {
            push @array, 
                {displayed => $_, content => $val++};
        }
        $self->{collection}->{options}->{values}->{filesizeunits}->{value} = \@array;
    }

    sub removeAddedFields
    {
        my $self = shift;
        return if ! $self->{addedModel};
        delete $self->{addedModel}->{collection}->{panels}->{panel};
        foreach my $container('fieldsNames', 'fieldsHistory', 'fieldsNotNull',
                              'fieldsNotFormatted', 'managedImages', 'fieldsImage')
        {
            my @filtered = grep(!/gcsfield/, @{$self->{$container}});
            $self->{$container} = \@filtered;
        }
        foreach (keys %{$self->{panels}})
        {
            if ($_ eq 'form')
            {
                if ($self->{formNotebook})
                {
                    my @filtered = grep(!$_->{userDefined}, @{$self->{formNotebook}->{item}});
                    $self->{formNotebook}->{item} = \@filtered;
                }
            }
            else
            {
                my @filtered = grep(!$_->{userDefined}, @{$self->{panels}->{$_}->{item}});
                $self->{panels}->{$_}->{item} = \@filtered;
            }
        }
        my $addedModel = $self->{addedModel};
        delete $self->{addedModel};
        return $addedModel;
    }

    sub updateAddedFields
    {
        my ($self, $fields, $groups) = @_;
        
        # First clean what we previously added
        my $addedModel = $self->removeAddedFields;

        if (!$addedModel)
        {
            # We didn't have one previously. We need to create it.
            $addedModel = GCModelLoader->newEmpty($self->{parent}, {defaultModifier => 1});
        }
        $addedModel->setGroups($groups);
        $addedModel->setFields($fields);

        $self->addFields($addedModel);
    }

    sub addFields
    {
        my ($self, $model) = @_;
        # Fields are stored in another model

        $self->{addedModel} = $model;

        return if ! scalar @{$model->{fieldsNames}};

        # Groups part
        my %groups = map { $_->{id} => 1 } @{$self->{groups}};
        foreach (@{$model->{groups}})
        {
            push @{$self->{groups}}, $_
                if !exists $groups{$_->{id}};
        }

        # initFields part
        foreach(@{$model->{fieldsNames}})
        {
            push @{$self->{fieldsNames}}, $_;
            $self->{fieldsInfo}->{$_} = $model->{fieldsInfo}->{$_};
        }
        push @{$self->{fieldsHistory}}, @{$model->{fieldsHistory}};
        push @{$self->{fieldsNotNull}}, @{$model->{fieldsNotNull}};
        push @{$self->{fieldsNotFormatted}}, @{$model->{fieldsNotFormatted}};
        push @{$self->{managedImages}}, @{$model->{managedImages}};
        push @{$self->{fieldsImage}}, @{$model->{fieldsImage}};
        
        # initPanels part
        foreach (keys %{$model->{panels}})
        {
            # We mark them to be able to remove them later
            foreach my $container(@{$model->{panels}->{$_}->{item}})
            {
                $container->{userDefined} = 1;
            }
            
            if ($_ eq 'form')
            {
                # Search the main notebook
                sub getNotebook
                {
                    my $item = shift;
                    return $item if $item->{type} eq 'notebook';
                    foreach my $child(@{$item->{item}})
                    {
                        my $notebook = getNotebook($child);
                        return $notebook if $notebook;
                    }
                    return undef;
                }
                $self->{formNotebook} = getNotebook($self->{panels}->{$_});
                push @{$self->{formNotebook}->{item}}, @{$model->{panels}->{$_}->{item}};
            }
            else
            {
                push @{$self->{panels}->{$_}->{item}}, @{$model->{panels}->{$_}->{item}};
            }
        }
    }

    sub checkLending
    {
        my $self = shift;
        $self->{hasLending} = 0;
        return if ! ($self->{collection}->{fields}->{lending} eq 'true');
        $self->{hasLending} = 1;        

        # Add group
        push @{$self->{groups}}, {
                                id => 'lending',
                                label => 'PanelLending'
                              };
        
        # Add lending fields
        push @{$self->{fields}}, (
            {
                value => 'borrower',
                type => 'options',
                label => 'PanelBorrower',
                init => 'none',
                group => 'lending',
                imported => 'false'
            },
            {
                value => 'lendDate',
                type => 'date',
                label => 'PanelLendDate',
                init => '',
                group => 'lending',
                imported => 'false'
            },
            {
                value => 'borrowings',
                type => 'triple list',
                label => 'PanelHistory',
                label1 => 'PanelBorrower',
                label2 => 'PanelLendDate',
                label3 => 'PanelReturnDate',
                init => '',
                group => 'lending',
                imported => 'false'
            },
        );
        
        # Set fields names
        $self->{commonFields}->{borrower} = {
                                                name => 'borrower',
                                                date => 'lendDate',
                                                history => 'borrowings'
                                            };
    }

    sub checkTags
    {
        my $self = shift;
        $self->{hasTags} = 0;
        return if ! ($self->{collection}->{fields}->{tags} eq 'true');
        $self->{hasTags} = 1;        

        # Add group
        push @{$self->{groups}}, {
                                id => 'tagpanel',
                                label => 'PanelTags'
                              };
        # Add tag fields
        push @{$self->{fields}}, (
            {
                value => 'favourite',
                type => 'yesno',
                label => 'PanelFavourite',
                init => '0',
                group => 'tagpanel',
                imported => 'false'
            },
            {
                value => 'tags',
                type => 'single list',
                label => 'TagsAssigned',
                init => '',
                group => 'tagpanel',
                imported => 'false'
            },
        );

        # Add filter
        push @{$self->{filters}}, (
            {
                field => 'tags',
                comparison => 'contain',
                quick => 'true',
                numeric => 'false'
            },
            {
                field => 'favourite',
                comparison => 'contain',
                quick => 'true',
                numeric => 'false'
            },
        );

    }

    sub initPanels
    {
        my $self = shift;
        $self->createDefaultPanel if !$self->{collection}->{panels}->{panel};
        return if !$self->{collection}->{panels}->{panel};
        my @panels = @{$self->{collection}->{panels}->{panel}};
        $self->{panelsNames} = [];
        $self->{panels} = {};
        foreach (@panels)
        {
            push @{$self->{panelsNames}}, $_->{name};
            $self->{panels}->{$_->{name}} = $_;
        }
    }

    sub createDefaultPanel
    {
        my $self = shift;
        return if (! $self->{commonFields}->{title}) && (!$self->{defaultModifier});
        my $panel;
        $panel->{name} = 'form';
        $panel->{label} = 'PanelForm';
        $panel->{editable} = 'true';
        my @items;
        
        if (!$self->{defaultModifier})
        {
            my $header = {type => 'line'};
            push @{$header->{item}}, {
                                        type => 'value',
                                        for => $self->{commonFields}->{id},
                                        width => '5'
                                     }
                if $self->{commonFields}->{id} && ($self->{commonFields}->{id} ne $GCModel::autoId);
            push @{$header->{item}}, {
                                        type => 'value',
                                        for => $self->{commonFields}->{title},
                                        expand => 'true'
                                     };
            push @items, $header;
        }
        
        my $fields = $self->getDisplayedInfo;
        my $notebook;
        my $hasTabs;
        if ($self->{defaultModifier})
        {
            $hasTabs = 1;
            $notebook = undef;
        }
        else
        {
            $hasTabs = (scalar @$fields > 1);
            if ($hasTabs)
            {
                $notebook = {type => 'notebook', expand => 'true'};
            }
        }
        
        my $i = 0;
        my $infoFrame;
        foreach (@{$fields})
        {
            next if (($_->{id} eq 'lending') || ($_->{id} eq 'tagpanel'));
            my $tab;
            if ($hasTabs)
            {
                $tab = {type => 'tab', value => 'bla', title => $_->{title}, expand => 'true'};
            }
            else
            {
                $tab = {type => 'box', expand => 'true'};
                $notebook = $tab;
            }
            my $tabRank = 0;
            my $hasInfoFrame = 0;
            if ($i == 0 && $self->{commonFields}->{cover})
            {
                $tab->{item} = [
                                {type => 'line', item => [{type => 'value',
                                                           for => $self->{commonFields}->{cover},
                                                           width => 150,
                                                           height => 150}]},
                                {type => 'table', cols => '2'}
                               ];
                $infoFrame = {type => 'frame', cols => '2'};
                push @{$tab->{item}->[0]->{item}}, $infoFrame;
                $tabRank = 1;
                $hasInfoFrame = 1;
            }
            else
            {
                $tab->{item} = [{type => 'table', cols => '4', expand => 'true'}];
            }
            my $row = 0;
            my $frameRow = 0;
            foreach my $item (@{$_->{items}})
            {
                next if ($item->{id} eq $self->{commonFields}->{id})
                     || ($item->{id} eq $self->{commonFields}->{title})
                     || ($item->{id} eq $self->{commonFields}->{cover})
                     || ($item->{id} eq $self->{commonFields}->{url});
                my $type = $self->{fieldsInfo}->{$item->{id}}->{type};
                my $longField = ($type eq 'long text') || ($type eq 'image')
                             || ($type =~ /list$/);
                my $label = undef;
                $label = {type => 'label', for => $item->{id},
                          col => '0'} if $type ne 'yesno';
                my $value = {type => 'value', for => $item->{id},
                             col => ($label ? 1 : 0), expand => 'true',
                             colspan => ($label ? 1 : 2)};
                my $extra = undef;
                if ($type eq 'file')
                {
                    # Add launcher next to file chooser field
                    $extra = {type => 'launcher', for => $item->{id}, col => '2'};
                }
                if ($hasInfoFrame && ($frameRow < 5) && ! $longField)
                {
                    if ($label)
                    {
                        $label->{row} = $frameRow;
                        push @{$infoFrame->{item}}, $label;
                    }
                    $value->{row} = $frameRow;
                    push @{$infoFrame->{item}}, $value;
                    if ($extra)
                    {
                        $extra->{row} = $frameRow;
                        push @{$infoFrame->{item}}, $extra;
                    }
                    $frameRow++;
                }
                else
                {
                    if (($type =~ /list$/) && ($self->{fieldsInfo}->{$item->{id}}->{flat} eq 'true'))
                    {
                        my $label = 
                        push @{$tab->{item}->[$tabRank]->{item}}, 
                              {type => 'expander', title => $self->{fieldsInfo}->{$item->{id}}->{label},
                               collapsed => '%'.$item->{id}.'%',
                               row => $row, col => 0, colspan => 3,
                               item => [
                                {type => 'value', for => $item->{id}}
                               ]
                              };
                    }
                    else
                    {
                        my ($colspan, $expand);
                        if ($longField)
                        {
                            $value->{colspan} = 3;
                        }
                        else
                        {
                            $value->{expand} = 'default';
                        }
                        if ($label)
                        {
                            $label->{row} = $row;
                            push @{$tab->{item}->[$tabRank]->{item}}, $label;
                        }
                        $value->{row} = $row;
                        push @{$tab->{item}->[$tabRank]->{item}}, $value;
                        if ($extra)
                        {
                            $extra->{row} = $row;
                            push @{$tab->{item}->[$tabRank]->{item}}, $extra;
                        }
                    }
                    $row++;
                }
            }
            $tab->{item}->[$tabRank]->{rows} = $row;
            if ($hasTabs)
            {
                if ($self->{defaultModifier})
                {
                     push @items, $tab;
                }
                else
                {
                    push @{$notebook->{item}}, $tab;
                }
            }
            $i++;
        }
        if ($self->{hasLending})
        {
            my $tab = {type => 'tab', value => 'lending',
                       title => 'PanelLending',
                       item => [
                         {type => 'table', rows => '3', 
                          item => [
                            {type => 'label', for => 'borrower', row => '0', col => '0'},
                            {type => 'value', for => 'borrower', row => '0', col => '1'},
                            {type => 'special', for => 'mailButton', row => '0', col => '2'},
                            {type => 'label', for => 'lendDate', row => '1', col => '0'},
                            {type => 'value', for => 'lendDate', row => '1', col => '1'},
                            {type => 'special', for => 'itemBackButton', row => '1', col => '2'}
                          ]
                         },
                         {type => 'label', for => 'borrowings', align => 'left'},
                         {type => 'line', expand => 'true',
                          item => [
                            {type => 'box', width => '64'},
                            {type => 'value', for => 'borrowings', expand => 'true'},
                            {type => 'box', width => '64'}
                          ]
                         }
                       ]
                      };
            push @{$notebook->{item}}, $tab
        }

        if ($self->{hasTags})
        {
            my $tab = {type => 'tab', value => 'tagpanel',
                       title => 'PanelTags',
                       item => [
                         {type => 'line', 
                          item => [
                            {type => 'value', for => 'favourite'}
                          ]
                         },
                         {type => 'value', for => 'tags', expand => 'true'}
                       ]
                      };
            push @{$notebook->{item}}, $tab
        }

        if (!$self->{defaultModifier})   
        {
            push @items, $notebook;
            my $footer = {type => 'line',
                          item => [
                                    {
                                        type => 'special',
                                        for => 'deleteButton',
                                        expand => 'true'
                                    }
                                  ]
                          };

            unshift @{$footer->{item}}, {
                                        type => 'value',
                                        for => $self->{commonFields}->{url},
                                        expand => 'true'
            } if $self->{commonFields}->{url};
                       
            push @items, $footer;
        }

        $panel->{item} = \@items;
        $self->{collection}->{panels}->{panel}->[0] = $panel;
        $self->createDefaultReadOnlyPanel;
    }

    sub createDefaultReadOnlyPanel
    {
        my $self = shift;
        return if (! $self->{commonFields}->{title}) && (!$self->{defaultModifier});
        my $panel;
        $panel->{name} = 'readonly';
        $panel->{label} = 'PanelReadOnly';
        $panel->{editable} = 'false';
        my @items;
        
        if (!$self->{defaultModifier})
        {
            my $header = {
                            type => 'line', item => [
                                {type => 'value', for => $self->{commonFields}->{title},
                                style => 'header', row => 0, col => 0, colspan => 3,
                                expand => 'true'}
                            ]
                         };
            push @items, $header;
        }
        
        my $fields = $self->getDisplayedInfo;
        my $i = 0;
        my $infoTable;
        my $currentTable;
        foreach (@{$fields})
        {
            $infoTable = 0;
            next if (($_->{id} eq 'lending') || ($_->{id} eq 'tagpanel'));
            my $container;
            my $inExpander = 0;
            if (($i == 0) && (!$self->{defaultModifier}))
            {
                if ($self->{commonFields}->{cover})
                {
                    my $line = {type => 'line',
                                 item => [
                                    {type => 'box', width => '150', style => 'page',
                                     item => [
                                        {type => 'value', width => '140', for => $self->{commonFields}->{cover}}
                                     ]
                                    }
                                 ]
                               };
                    my $infoBox = {type => 'box', expand => 'true', item => []};
                    $infoTable = {type => 'table', cols => '2', expand => 'true'};
                    push @{$infoBox->{item}}, $infoTable;
                    push @{$line->{item}}, $infoBox;
                    push @items, $line;
                }
                $container = {type => 'table', cols => '2', expand => 'true'};
                push @items, $container;
            }
            else
            {
                my $expander = {type => 'expander', title => $_->{title},
                                item => [
                                    {type => 'table', cols => 2, expand => 'true', item => []}
                                ]
                               };
                push @items, $expander;
                $container = $expander->{item}->[0];
                $inExpander = 1;
            }
            my $row = 0;
            my $infoRow = 0;
            foreach my $item (@{$_->{items}})
            {
                next if  ($item->{id} eq $self->{commonFields}->{title})
                      || ($item->{id} eq $self->{commonFields}->{cover})
                      || ($item->{id} eq $self->{commonFields}->{url});
                my $type = $self->{fieldsInfo}->{$item->{id}}->{type};
                my $longField = ($type eq 'long text') || ($type eq 'image')
                             || ($type =~ /list$/o);
                my $label = undef;
                $label = {type => 'label', for => $item->{id},
                          col => '0'};
                my $value = {type => 'value', for => $item->{id},
                             col => 1, expand => 'true', flat => ($item->{flat} || 'false'),
                             colspan => 1};
                if ($infoTable && ($infoRow < 5) && ! $longField)
                {
                     $label->{row} = $infoRow;
                     push @{$infoTable->{item}}, $label;
                     $value->{row} = $infoRow;
                     push @{$infoTable->{item}}, $value;
                     $infoRow++;
                }
                else
                {
                    my ($colspan, $expand);
                    $label->{row} = $row;
                    $value->{row} = $row;
                    push @{$container->{item}}, $label;
                    push @{$container->{item}}, $value;
                    $row++;
                }
            }
            $container->{rows} = $row;
            $i++;
        }
        if ($self->{hasLending})
        {
            my $lendingExpander = {
                       type => 'expander',
                       title => 'PanelLending',
                       item => [
                         {type => 'table', rows => '4', cols => '2',
                          item => [
                            {type => 'label', for => 'borrower', row => '0', col => '0'},
                            {type => 'value', for => 'borrower', row => '0', col => '1', expand => 'true'},
                            {type => 'label', for => 'lendDate', row => '1', col => '0'},
                            {type => 'value', for => 'lendDate', row => '1', col => '1', expand => 'true'},
                            {type => 'line', row => '2', col => '0', colspan => '2', height => '12', expand => 'true'},
                            {type => 'line', row => '2', col => '0', colspan => '2', expand => 'true',
                             item => [
                                {type => 'box', width => '50', style => 'page'},
                                {type => 'value', for => 'borrowings',  expand => 'true'},
                                {type => 'box', width => '50', style => 'page'},
                             ]
                            }
                          ]
                         }
                       ]
            };
            push @items, $lendingExpander;
        }
        if ($self->{hasTags})
        {
            my $tagsExpander = {
                       type => 'expander',
                       title => 'PanelTags',
                       item => [
                         {type => 'value', for => 'tags', expand => 'true'}
                       ]
            };
            push @items, $tagsExpander;
        }
        
        $panel->{item} = \@items;
        $self->{collection}->{panels}->{panel}->[1] = $panel;        
    }

    sub getGroups
    {
        my $self = shift;
        
        if (!$self->{groupsHash})
        {
            $self->{groupsHash} = {};
            foreach (@{$self->{groups}})
            {
                $self->{groupsHash}->{$_->{id}} = {
                                                      id => $_->{id},
                                                      label => $_->{label},
                                                      displayed => $self->getDisplayedText($_->{label})
                                                  };
            }
        }
        return $self->{groupsHash};
    }

    sub getDefaultPanel
    {
        my $self = shift;
        return $self->{panels}->{$self->{panelsNames}->[0]};
    }

    sub getName
    {
        my $self = shift;
        return $self->{collection}->{name};
    }

    sub getDescription
    {
        my $self = shift;
        my $description = $self->{collection}->{description} ? 
        $self->{collection}->{description} : $self->getDisplayedText('CollectionDescription');
        return $description eq 'CollectionDescription' ? $self->getName : $description;
    }

    sub getDisplayedText
    {
        my ($self, $id) = @_;

        return $self->{fieldsInfo}->{lc $id}->{displayed}
            if $id =~ /^gcsfield/i;
        return $self->{lang}->{$id} if exists $self->{lang}->{$id};
        return $self->{parent}->{lang}->{$id} if exists $self->{parent}->{lang}->{$id};
        return $id;
    }

    sub getDisplayedLabel
    {
        my ($self, $field) = @_;

        return $self->getDisplayedText($self->{fieldsInfo}->{$field}->{label})
            if exists $self->{fieldsInfo}->{$field};
        return $self->getGroups->{$field}->{displayed}
            if exists $self->getGroups->{$field};
        return $self->getDisplayedText($field);
    }

    sub getDisplayedValue
    {
        my ($self, $values, $value) = @_;
        foreach (@{$self->{collection}->{options}->{'values'}->{$values}->{value}})
        {
            return $self->getDisplayedText($_->{displayed}) if $_->{content} eq $value;
        }
        return "";
    }

    sub getDisplayedItems
    {
        my ($self, $number) = @_;
        $number = 'X' if !defined $number;
        return 'Items' if !exists $self->{lang}->{Items};
        my $items = $self->{lang}->{Items};
        if (ref($items) eq 'HASH')
        {
            return $items->{$number} if exists $items->{$number};
            return $items->{X};
        }
        elsif (ref($items) eq 'CODE')
        {
            # Example of Items definition:
            #Items => sub {
            #    my $number = shift;
            #    return 'Movie' if $number < 2;
            #    return 'Movies';
            #},

            return $items->($number);
        }
        else
        {
            return $items;
        }
    }

    sub getValues
    {
        my ($self, $id) = @_;
        my @result;
        if ($id eq $self->{commonFields}->{borrower}->{name})
        {
            @result = (
                        {value => '', displayed => ''},
                        {value => 'none', displayed => $self->getDisplayedText('PanelNobody')}
                      );
            my @borrowers = split m/\|/, $self->{parent}->{options}->borrowers;
            foreach (@borrowers)
            {
                push @result, {value => $_, displayed => $_};
            }
            push @result, {value => 'unknown', displayed => $self->getDisplayedText('PanelUnknown')};
        }
        else
        {
            if ($id =~ /,/)
            {
                # If it contains a comma, it needs no translation (used by user-defined collections)
                push @result, {displayed => $_, value => $_}
                   foreach (split /\s*,\s*/, $id);
            }
            else
            {
                push @result, {displayed => $self->getDisplayedText($_->{displayed}), value => $_->{content}}
                   foreach (@{$self->{collection}->{options}->{'values'}->{$id}->{value}});
            }
        }
        return \@result;
    }

    sub getFieldsCopy
    {
        my $self = shift;
        my @result;
        foreach (@{$self->{fieldsNames}})
        {
            my $info = $self->{fieldsInfo}->{$_};
            #next if exists $info->{linkedto};
            push @result, $_ if $info->{group}
                             && $info->{label};
        }
        return \@result;
    }
 
    sub getDisplayedInfo
    {
        my $self = shift;
        # It will return a reference to an array. Each item will
        # be like this :
        # title => 'title of the corresponding tab'
        # items => [ collection of items {id => '', label => ''} ]
        my $result = [];
        my %groups;
        
        my $i = 0;

        foreach (@{$self->{fieldsNames}})
        {
            my $info = $self->{fieldsInfo}->{$_};
            next if (! $info->{label}); # || (exists $info->{linkedto});
            my $group = $info->{group};
            push @{$groups{$group}}, {
                id => $_,
                label => $self->getDisplayedText($info->{label})
            } if $group;
            
            $i++;
        }
        foreach (@{$self->{groups}})
        {
            push @$result, {
                id => $_->{id},
                title => $self->getDisplayedText($_->{label}),
                items => $groups{$_->{id}}
            };
        }
        
        return $result;
    }

    sub getInitInfo
    {
        my $self = shift;
        my $info = {};
        foreach my $field (@{$self->{fieldsNames}})
        {
            $info->{$field} = $self->getDisplayedText($self->{fieldsInfo}->{$field}->{init});
            if ($self->{fieldsInfo}->{$field}->{type} eq 'formatted')
            {
                $info->{$field} =~ s/\[(.*?)\]//g;
                $info->{$field} =~ s/%(.*?)%//g;
            }
            #foreach (@{$self->{fieldsNames}});
        }
        return $info;
    }

    # Required to use current class as a parameter of backend
    sub preloadModel
    {
        my $self = shift;
        return;
    }
    
    # Required to use current class as a parameter of backend
    sub setCurrentModel
    {
        my $self = shift;
        return 1;
    }
    
    # Required to use current class as a parameter of backend
    sub transformPicturePath
    {
        my ($self, @args) = @_;
        
        # Force the use of absolute path
        my $currentOption = $self->{parent}->{options}->useRelativePaths;
        $self->{parent}->{options}->useRelativePaths(0);
                
        return $self->{parent}->transformPicturePath(@args);
        
        $self->{parent}->{options}->useRelativePaths($currentOption);
    }
    
    sub getDefaultValuesBackend
    {
        my ($self) = @_;
        $self->{defaultValuesBackend} = new GCBackend::GCBeXmlParser($self)
            if !$self->{defaultValuesBackend};
        $self->{defaultValuesBackend}->setParameters(file => $self->{defaultValuesFile},
                                        version => $self->{parent}->{version});
        return $self->{defaultValuesBackend}
    }

    sub getDefaultValues
    {
        my $self = shift;
        if (! exists $self->{defaultValues})
        {
            # First get the default values as defined in the model
            my $info = $self->getInitInfo;
            
            # Then try to load user ones
            if ( -r $self->{defaultValuesFile})
            {
                my $backend = $self->getDefaultValuesBackend;
                my $loaded = $backend->load;
                # We only consider the first item
                my $userValues = $loaded->{data}->[0];
                # We store that for later use
                $self->{defaultValuesInformation} = $loaded->{information};
                
                # Remove 'current' value for date, otherwise we'll store the current date
                # as the default value
                foreach ($self->{fieldsDate})
                {
                    delete $userValues->{$_}
                        if $userValues->{$_} eq 'current';
                }

                # Merge init values with the loaded ones                
                $info = {%{$info}, %{$userValues}};
            }
            
            $self->{defaultValues} = $info;
        }
        return $self->{defaultValues};
    }

    sub setDefaultValues
    {
        my ($self, $info) = @_;
        
        $self->{defaultValues} = $info;
        my $backend = $self->getDefaultValuesBackend;
        
        my $result = $backend->save([$info],
                                    $self->{defaultValuesInformation},
                                    undef,
                                    1);
        if ($result->{error})
        {
            return $result->{error};
        }
    }


    sub getFilterType
    {
        my ($self, $filter) = @_;
        
        if (! $self->{filterTypes})
        {
            foreach (@{$self->{filters}})
            {
                $self->{filterTypes}->{$_->{field}} = [$_->{comparison}, $_->{numeric}, $_->{preprocess}];
            }
        }
        return $self->{filterTypes}->{$filter};
    }

    sub getPluginsNames
    {
        my $self = shift;
        
        my $tmp = $GCPlugins::pluginsNameArrays{$self->getName};
        return [] if !$tmp;
        return $tmp;
    }

    sub getAllPlugins
    {
        my $self = shift;
        
        my $tmp = $GCPlugins::pluginsMap{$self->getName};
        return {} if !$tmp;
        return $tmp;
    }
    
    sub getPlugin
    {
        my ($self, $pluginName) = @_;
        
        return $GCPlugins::pluginsMap{$self->getName}->{$pluginName};
    }

    sub getExtracter
    {
        my $self = shift;
        #return $self->{extracter} if exists $self->{extracter};
        return 0 if $self->isPersonal;
        my $extracter;
        (my $module = 'GCExtract::GCExtract'.$self->getName) =~ s/(GCExtract)GC(.)/$1\U$2\E/;
        eval "use $module";
        my $extracterName = 'GCExtract::'.$self->getName.'Extracter';
        $extracter = new $extracterName(@_);
        #$self->{extracter} = ($extracter->{errors} ? 0 : $extracter);
        #return $self->{extracter};
        return ($extracter->{errors} ? 0 : $extracter);
    }

    sub new
    {
        my ($proto, $parent, $file, $isPersonal) = @_;
        my $class = ref($proto) || $proto;
        my $self  = {parent => $parent, isPersonal => $isPersonal};
        bless $self, $class;
        $self->{isInline} = 0;

        # backend expects the model to be in {model}
        # so we store there a reference to ourselves
        $self->{model} = $self;
        
        $self->load($file);
        GCPlugins::loadPlugins($self->getName) if !$isPersonal && !$ENV{GCS_PROFILING};
        return $self;
    }

    sub newFromInline
    {
        my ($proto, $parent, $container) = @_;
        my $class = ref($proto) || $proto;
        my $self  = {parent => $parent};
        bless $self, $class;
        $self->{isInline} = 1;
        $self->{xmlString} = $container->{inlineModel};
        $self->{defaultModifier} = $container->{defaultModifier};
        $self->{preferences} = GCOptionLoader->newFromXmlString($container->{inlinePreferences}, 0, $self->{parent}->{options});
        $self->loadFromString;
        return $self;
    }
    
    sub newEmpty
    {
        my ($proto, $parent, $container) = @_;
        my $class = ref($proto) || $proto;
        my $self  = {parent => $parent, isInline => 1, isPersonal => 1};
        bless $self, $class;
        $self->{xmlString} = '<collection><options/><groups/><fields lending="false" tags="false"/></collection>';
        $self->{preferences} = GCOptionLoader->newFromXmlString('',0, $self->{parent}->{options});
        if ($container)
        {
            $self->{defaultModifier} = $container->{defaultModifier};
        }
        $self->loadFromString;
        return $self;
    }
    
    sub save
    {
        my $self = shift;
        $self->{preferences}->save
            if ! $self->{isInline};
        $self->saveUserFilters;
    }
}
{
    package GCModelsChanges;

    use File::Basename;
    use GCUtils 'glob';
    my %versionwithchanges;

    sub new
    {
        my ($proto, $parent,$model) = @_;
        my $class = ref($proto) || $proto;
        my $self  = {
            parent => $parent,
            cache => {},
            lang => $parent->{lang},
            persoDirectory => $ENV{GCS_DATA_HOME}.'/GCModels/',
            defaultDirectory => $ENV{GCS_LIB_DIR}.'/GCModels/',
            modelsSuffix => $GCModel::modelsSuffix,
            model => $model
        };

        $self->{modelsDirectories} = [$self->{persoDirectory}, $self->{defaultDirectory}],

        bless $self, $class;
        $self->loadChangedVersionNumber;
        return $self;
    }

    sub applyChanges
    {
        my($self,$data,$fileversion,$gcstarversion)=@_;
        my @fileVersionSplited=split /\./,$fileversion;
        my @gcstarVersionSplited=split /\./,$gcstarversion;
        my $modelChanges=$versionwithchanges{$self->{model}};
        sub compare
        {
            my ($arr1,$arr2,$i)=@_;
            return 0 if ($i>$#$arr1 && $i>$#$arr2);
            return -(0>$arr2->[$i])if ($i>$#$arr1);
            return (0>$arr1->[$i]) if ($i>$#$arr2);
            
            return -1 if $arr1->[$i]<$arr2->[$i];
            return 1 if $arr1->[$i]>$arr2->[$i];
            return compare($arr1,$arr2,$i+1);
        }
        # Warning : we assume that versions are sorted ascend
        for my $vers(keys %$modelChanges)
        {
            my @versSplited=split /\./,$vers;
            my $isConcerned=(compare \@fileVersionSplited,\@versSplited)<0;
            $isConcerned&=(compare \@versSplited,\@gcstarVersionSplited)<=0;
            foreach my $item(@$data)
            {
                $modelChanges->{$vers}($item);
            }
            
        }
    }

    sub loadChangedVersionNumber
    {
        my($self)=@_;
        # TODO load from files
        
        # Here is, for each model, a hash "versionNumber"=>sub
        # example : "1.4.4"=>sub {
        #                        $_[0]->{title}=lc $_[0]->{title};
        #                    };
        $versionwithchanges{GCfilms}={
            };
        # TODO sort version changes asc
    }
}

{
    package GCModelsCache;

    use File::Basename;
    use GCUtils 'glob';

    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        mkdir $ENV{GCS_DATA_HOME}.'/GCModels/';
        mkdir $ENV{GCS_DATA_HOME}.'/Filters/';
        my $self  = {
            parent => $parent,
            cache => {},
            lang => $parent->{lang},
            persoDirectory => $ENV{GCS_DATA_HOME}.'/GCModels/',
            defaultDirectory => $ENV{GCS_LIB_DIR}.'/GCModels/',
            modelsSuffix => $GCModel::modelsSuffix
        };

        $self->{modelsDirectories} = [$self->{persoDirectory}, $self->{defaultDirectory}],

        bless $self, $class;
        return $self;
    }

    sub getModel
    {
        my ($self, $name) = @_;

        my $suffix = $self->{modelsSuffix};
        (my $cacheId = $name) =~ s/$suffix$//;
        if (!exists $self->{cache}->{$cacheId})
        {
            my $dir;
            foreach $dir(@{$self->{modelsDirectories}})
            {
                my $file = $dir.$name;
                $file .= $self->{modelsSuffix}
                    if $file !~ /$self->{modelsSuffix}$/;
                next if ! -e $file;
                $self->{cache}->{$cacheId} = GCModelLoader->new($self->{parent},
                                                                $file,
                                                                ($dir eq $self->{persoDirectory}));
            }
        }
        # Clean it if user added some fields
        $self->{cache}->{$cacheId}->removeAddedFields
            if $self->{cache}->{$cacheId};
        return $self->{cache}->{$cacheId};
    }

    sub getInfoFromFile
    {
        my ($self, $file) = @_;
        my $result;
        open DATA, $file;
        
        while (<DATA>)
        {
            if ($_ =~ /<collection description="([^"]*?)".*?name="([^"]*?)"/)
            {
                $result = {
                            description => $1,
                            name => $2
                };
                last;
            }
        }
        
        close DATA;
        return $result;
    }

    sub getAllModels
    {
        my $self = shift;
        
        my @results;
        my $file;
        my $dir;
        foreach $dir(@{$self->{modelsDirectories}})
        {
            foreach $file(glob $dir.'*'.$self->{modelsSuffix})
            {
                push @results, $self->getModel(basename($file));
            }
        }
        return \@results;
    }
    
    sub getPersonalModels
    {
        my $self = shift;
        
        #Results is [ {name => '', description => ''} ]
        # name could be used with getModel
        
        my @results;

        foreach (glob $self->{persoDirectory}.'*'.$self->{modelsSuffix})
        {
            my $info = $self->getInfoFromFile($_);
            next if (! $info->{description}) || (! $info->{name});
            push @results, $info;
        }
        return \@results;
    }

    sub getDefaultModels
    {
        my $self = shift;
        
        #Results is [ {name => '', description => ''} ]
        # name could be used with getModel
        
        my @results;
        $self->{langName} = $self->{parent}->{options}->lang;
        foreach (glob $self->{defaultDirectory}.'*'.$self->{modelsSuffix})
        {
            #my $model = $self->getModel(basename($_));
            #push @results, {name => $model->getName,
            #                description => $model->getDescription};
            push @results, $self->extractInfos($_);
        }
        @results = sort {$a->{description} cmp $b->{description}} @results;
        return \@results;
    }
    
    sub extractInfos
    {
        my ($self, $file) = @_;
        my $result;
        
        open FILE, $file;
        my $lang;
        while (<FILE>)
        {
            $result->{name} = $1
                if /name="(.*?)"/;
            if (m|<lang>(.*?)</lang>|)
            {
                $lang = $1;
                last;
            }
        }
        close FILE;

        open LANG, $ENV{GCS_LIB_DIR}.'/GCLang/'.$self->{langName}."/GCModels/$lang.pm";
        binmode(LANG, ':utf8');
        while (<LANG>)
        {
            if (/CollectionDescription\s*=>\s*'(.*?)',/)
            {
                ($result->{description} = $1) =~ s/\\'/'/g;
                last;
            }
            
        }
        close LANG;

        return $result;
    }
}

use Gtk2;

{
    package GCModelsDialog;

    use GCImport;
    use base "GCModalDialog";

    sub show
    {
        my $self = shift;
        
        $self->setModelsList;
        
        $self->SUPER::show();
        $self->show_all;
        
        my $result = 0;
        $self->{model} = undef;
        $self->{gotKey} = 0;
        while (1)
        {
            my $response = $self->run;
            if ($response eq 'ok')
            {
                $result = 1;
                my $path = ($self->{modelsList}->get_cursor)[0];
                my @indices = $path ? $path->get_indices : (0);
                if ($indices[0] == 0)
                {
                    $self->{model} = GCModelLoader->newEmpty($self->{parent});
                }
                else
                {
                    if (!exists $indices[1])
                    {
                        if ($self->{gotKey})
                        {
                            # We expand/collapse row if called by a pressed key
                            if ($self->{modelsList}->row_expanded($path))
                            {
                                $self->{modelsList}->collapse_row($path)
                            }
                            else
                            {
                                $self->{modelsList}->expand_row($path, 0)
                            }
                            $self->{gotKey} = 0;
                        }
                        $self->{modelsList}->grab_focus;
                        next;
                    }
                    my $hasPerso = scalar @{$self->{persoList}};
                    if ((($indices[0] == 2) && !$hasPerso)
                      || ($indices[0] == 3))
                    {
                        # Here we are importing
                        $self->{model} = 0;
                        $self->{importer} = $self->{importers}->[$indices[1]];
                    }
                    else
                    {
                        my $name = ((($indices[0] == 1) && ($hasPerso)) ? 
                           $self->{persoList}->[$indices[1]]->{name} : $self->{defaultList}->[$indices[1]]->{name});
                        $self->{model} = $self->{factory}->getModel($name);
                    }
                }
            }
            last;
        }
        $self->hide;
        return $result;
    }

    sub new
    {
        my ($proto, $parent, $factory, $init) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent, $parent->{lang}->{ModelsSelect});
        
        bless ($self, $class);
        $self->{parent} = $parent;

        my $column = Gtk2::TreeViewColumn->new_with_attributes('', Gtk2::CellRendererText->new, 
                                                               'text' => 0);
        $self->{modelsModel} = new Gtk2::TreeStore('Glib::String');
        $self->{modelsList} = Gtk2::TreeView->new_with_model($self->{modelsModel});
        $self->{modelsList}->append_column($column);
        $self->{modelsList}->set_headers_visible(0);
        $self->{modelsList}->signal_connect ('row-activated' => sub {
             $self->{gotKey} = 1;
             $self->response('ok');
        });        

        my $scrollPanelList = new Gtk2::ScrolledWindow;
        $scrollPanelList->set_border_width(5);
        $scrollPanelList->set_policy('never', 'automatic');
        $scrollPanelList->set_shadow_type('etched-in');
        $scrollPanelList->add($self->{modelsList});

        $self->vbox->pack_start($scrollPanelList, 1, 1, 10);
        
        $self->{factory} = $factory;
        $self->{initVersion} = $init;
        $self->set_default_size(300,350);
        
        return $self;
    }

    sub isImporting
    {
        my $self = shift;
        return $self->{model} == 0;
    }

    sub getModel
    {
        my $self = shift;
        return $self->{model};
    }

    sub getImporter
    {
        my $self = shift;
        return $self->{importer};
    }

    sub setModelsList
    {
        my $self = shift;
        $self->{modelsModel}->clear;

        my $iter = $self->{modelsModel}->append(undef);
        $self->{modelsModel}->set($iter, (0 => $self->{parent}->{lang}->{ModelNewType}));

        $self->{persoList} = $self->{factory}->getPersonalModels;
        if (scalar @{$self->{persoList}})
        {
            my $persoIter = $self->{modelsModel}->append(undef);
            $self->{modelsModel}->set($persoIter, (0 => $self->{parent}->{lang}->{ModelsPersonal}));
            foreach (@{$self->{persoList}})
            {
                $iter = $self->{modelsModel}->append($persoIter);
                $self->{modelsModel}->set($iter, (0 => $_->{description}));
            }
        }
        my $defaultIter = $self->{modelsModel}->append(undef);
        $self->{modelsModel}->set($defaultIter, (0 => $self->{parent}->{lang}->{ModelsDefault}));
        $self->{defaultList} = $self->{factory}->getDefaultModels;
        foreach (@{$self->{defaultList}})
        {
            $iter = $self->{modelsModel}->append($defaultIter);
            $self->{modelsModel}->set($iter, (0 => $_->{description}));
        }
        $self->{modelsList}->expand_row($self->{modelsModel}->get_path($defaultIter), 0);
        $self->{modelsList}->get_selection->select_iter($self->{modelsModel}->get_iter_first);

        $self->addImport if $self->{initVersion};

        $self->{modelsList}->grab_focus;
    }

    sub addImport
    {
        my $self = shift;
        my $importIter = $self->{modelsModel}->append(undef);
        (my $label = $self->{parent}->{lang}->{MenuImport}) =~ s/_//g;
        $self->{modelsModel}->set($importIter, (0 => $label));
        $self->{importers} = [];
        my $iter;
        foreach my $importer(@GCImport::importersArray)
        {
            next if scalar @{$importer->getModels} == 0;
            push @{$self->{importers}}, $importer;
            $iter = $self->{modelsModel}->append($importIter);
            $self->{modelsModel}->set($iter, (0 => $importer->getName));
        }        
    }
}


{
    package GCModelsSettingsDialog;

    use base 'GCModalDialog';

    use GCGraphicComponents::GCBaseWidgets;

    sub setPersonalMode
    {
        my ($self, $personal) = @_;
        $self->{personal} = $personal;
        if ($personal)
        {
            $self->set_title($self->{parent}->{lang}->{ModelSettings});
        }
        else
        {
            $self->set_title($self->{parent}->{lang}->{PanelUser});
            $self->{notebook}->set_current_page(0);
        }
        $self->{notebook}->set_show_tabs($personal);
        $self->{collectionName}->set_sensitive($personal);
    }

    sub setDescription
    {
        my ($self, $desc) = @_;
        $self->{collectionName}->setValue($desc);
    }

    sub setSensitive
    {
        my ($self, $value) = @_;
        $self->{fieldsOptionsTable}->set_sensitive($value);
        $self->{removeButton}->set_sensitive($value);
        $self->{toUp}->set_sensitive($value);
        $self->{toDown}->set_sensitive($value);
        $self->activateOkButton($value)
            if $self->{personal};
    }

    sub initFields
    {
        my ($self, $fields, $groups, $commonFields, $withLending, $withTags) = @_;

        # A clone was already made by caller
        #$self->{fields} = Storable::dclone($fields) if $fields;
        $self->{fields} = $fields;

        $self->clearForm;
        $self->{params}->{group}->setValues([]);
        $self->{currentField} = -1;
        $self->{fieldsList}->get_model->clear;
        $self->{maxId} = 0;
        my $i = -1;
        if ($fields)
        {
            if (scalar @$fields)
            {
                $self->setSensitive(1);
                $self->checkFieldType;
            }
            else
            {
                $self->setSensitive(0);
            }
            $self->{idToLabel} = {};
            foreach (@{$self->{fields}})
            {
                $i++;
                $_->{label} = $_->{displayed} if $_->{displayed};
                $_->{group} = $groups->{$_->{group}}->{displayed}
                    if $groups->{$_->{group}}->{displayed};
                $self->{params}->{group}->addHistory($_->{group});
                if ($_->{value} eq $GCModel::autoId)
                {
                    delete $self->{fields}->[$i];
                    next;
                }
                push @{$self->{fieldsList}->{data}}, [$_->{label}];
                $_->{value} =~ /([0-9]+)$/;
                $self->{maxId} = $1 if $self->{maxId} < $1;
                $self->{idToLabel}->{$_->{value}} = $_->{label};
                $_->{init} = $self->convertFormat($_->{init}, 1)
                    if $_->{type} eq 'formatted';
            }
            $self->displayField(0) if scalar(@{$self->{fields}});
        }
        $self->initCommonFields($commonFields);
        $self->{hasLending}->setValue($withLending);
        $self->{hasTags}->setValue($withTags);
    }

    sub convertFormat
    {
        my ($self, $format, $toUser) = @_;
        my $converted = $format;
        if ($toUser)
        {
            $converted =~ s/%(.*?)%/'%'.$self->idToLabel($1).'%'/ge;
        }
        else
        {
            $converted =~ s/%(.*?)%/'%'.$self->labelToId($1).'%'/ge;
        }
        # If some replacements failed, we clean the string
        $converted =~ s/%%//g;
        return $converted;
    }

    sub idToLabel
    {
        my ($self, $id) = @_;
        for my $field (@{$self->{fields}})
        {
            return $field->{label}
                if $field->{value} eq $id;
        }
        return '';
    }

    sub labelToId
    {
        my ($self, $label) = @_;
        for my $field (@{$self->{fields}})
        {
            return $field->{value}
                if $field->{label} eq $label;
        }
        return '';
    }

    sub initFilters
    {
        my ($self, $filters) = @_;

        $self->{filters} = {};
        foreach (@{$filters})
        {
            $self->{filters}->{$_->{field}} = {
                comparison => $_->{comparison},
                numeric => $_->{numeric},
                quick => $_->{quick}
            };
        }
        
        $self->displayFilter(0) if scalar(@{$self->{fields}});
        $self->checkFilterActivated;
    }

    sub getFilters
    {
        my ($self, $fieldsInfo) = @_;
        
        my $type;
        foreach (keys %{$self->{filters}})
        {
            my $filter = $self->{filters}->{$_};
            $type = $fieldsInfo->{$_}->{type};
            $filter->{labelselect} = $self->{filter}->{comparison}->valueToDisplayed($filter->{comparison})
                if ($type eq 'number') || ($type eq 'date');
        }
        
        return $self->{filters};
    }

    sub getGroups
    {
        my $self = shift;
        my $groups = [];
        my %alreadyPushed = ();
        foreach (@{$self->{fields}})
        {
            push @$groups, {id => $_->{group}, label => $_->{group}}
                if  $_->{group}
                && !$alreadyPushed{$_->{group}};
            $alreadyPushed{$_->{group}} = 1;
        }
        if (! scalar(@$groups))
        {
            if ($self->{personal})
            {
                push @$groups, {id => $self->{parent}->{lang}->{OptionsMain}, label => 'OptionsMain',
                                displayed => $self->{parent}->{lang}->{OptionsMain}};
            }
            else
            {
                push @$groups, {id => $self->{parent}->{lang}->{PanelUser},
                                label => 'PanelUser',
                                displayed => $self->{parent}->{lang}->{PanelUser}};
            }
        }
        my $defaultGroup = $groups->[0]->{id};
        foreach (@{$self->{fields}})
        {
            $_->{group} = $defaultGroup if ! $_->{group};
        }
        return $groups;
    }

    sub show
    {
        my $self = shift;
        $self->SUPER::show();
        $self->show_all;
        
        my $response = $self->run;
        $self->saveCurrent;
        $self->saveCurrentFilter;
        $self->hide;
        if ($response eq 'ok')
        {
            # Restore formats
            foreach my $field(@{$self->{fields}})
            {
                $field->{init} = $self->convertFormat($field->{init}, 0)
                    if $field->{type} eq 'formatted';
            }
        }
        return ($response eq 'ok');
    }

    sub getName
    {
        # returns (collection description, safe name, full file name)
        my $self = shift;
        my $description = $self->{collectionName}->getValue;
        my $name = GCUtils::getSafeFileName($description);
        my $file = $ENV{GCS_DATA_HOME}.'/GCModels/'.$name.$GCModel::modelsSuffix;
        return ($description, $name, $file);
    }

    sub saveCurrent
    {
        my $self = shift;
        return if $self->{currentField} < 0;
        foreach (keys %{$self->{params}})
        {
            $self->{fields}->[$self->{currentField}]->{$_} = $self->{params}->{$_}->getValue
                if $self->{params}->{$_}->is_sensitive;
        }
        # Some adjustments
        my $type = $self->{fields}->[$self->{currentField}]->{type};
        # history text is managed through 2 fields
        if ($type eq 'short text')
        {
            $self->{fields}->[$self->{currentField}]->{type} = 'history text'
                if $self->{fields}->[$self->{currentField}]->{history};
            delete $self->{fields}->[$self->{currentField}]->{history};
        }
        # By default, the image will be displayed, right click to change it
        $self->{fields}->[$self->{currentField}]->{default} = 'view'
            if $type eq 'image';
        $self->{fields}->[$self->{currentField}]->{history} = 
            $self->{fields}->[$self->{currentField}]->{history} ? 'true' : 'false'
            if exists $self->{fields}->[$self->{currentField}]->{history};
        $self->{fields}->[$self->{currentField}]->{flat} = 
            $self->{fields}->[$self->{currentField}]->{flat} ? 'true' : 'false'
            if exists $self->{fields}->[$self->{currentField}]->{flat};
        $self->{params}->{group}->addHistory;
    }

    sub saveCurrentFilter
    {
        my $self = shift;
        return if $self->{currentFilter} < 0;
        # As we use the same model, the index is the same in the fields array
        my $field = $self->{fields}->[$self->{currentFilter}]->{value};
        if ($self->{filter}->{activated}->getValue)
        {
            $self->{filters}->{$field} = {
                                            comparison => $self->{filter}->{comparison}->getValue,
                                            numeric => $self->{filter}->{numeric}->getValueAsText,
                                            quick => $self->{filter}->{quick}->getValueAsText
                                         };
        }
        else
        {
            delete $self->{filters}->{$field};
        }
    }

    sub changeCurrentLabel
    {
        my $self = shift;
        return if $self->{currentField} < 0;
        $self->{fieldsList}->{data}->[$self->{currentField}]->[0] = $self->{params}->{label}->getValue;
    }

    sub displayField
    {
        my ($self, $idx) = @_;
        
        $self->{currentField} = $idx;
        foreach (keys %{$self->{params}})
        {
            my $value = $self->{fields}->[$idx]->{$_};
            if ($_ eq 'init')
            {
                $value = '' if $value eq $GCModel::initDefault;
            }
            elsif (($_ eq 'history') || ($_ eq 'flat'))
            {
                $value = ($value eq 'true') ? 1 : 0;
            }
            $self->{params}->{$_}->setValue($value);
        }
        if ($self->{fields}->[$idx]->{type} eq 'history text')
        {
            $self->{params}->{type}->setValue('short text');
            $self->{params}->{history}->setValue(1);
        }
        $self->{fieldsList}->select($idx);
    }

    sub displayFilter
    {
        my ($self, $idx) = @_;
        
        $self->{currentFilter} = $idx;
        my $field = $self->{fields}->[$idx]->{value};
        my $hasFilter = (exists $self->{filters}->{$field});
        my $info = $self->{fields}->[$self->{currentFilter}];
        if ($hasFilter)
        {
            $self->{filter}->{activated}->setValue(1);
            $self->{filter}->{comparison}->setValue($self->{filters}->{$field}->{comparison});
            $self->{filter}->{numeric}->setValue($self->{filters}->{$field}->{numeric} eq 'true');
            $self->{filter}->{quick}->setValue($self->{filters}->{$field}->{quick} eq 'true');
        }
        else
        {
            $self->{filter}->{activated}->setValue(0);
            $self->{filter}->{comparison}->setValue(0);
            $self->{filter}->{numeric}->setValue(0);
            $self->{filter}->{quick}->setValue(0);
        }
        $self->checkFilterSettings;
        $self->{filtersList}->select($idx);
    }

    sub clearForm
    {
        my $self = shift;
        foreach (keys %{$self->{params}})
        {
            $self->{params}->{$_}->setValue('');
        }
        
    }

    sub moveDownUp
    {
        my ($self, $dir) = @_;
        $self->saveCurrent;
        my $newField = $self->{currentField} + $dir;
        return if ($newField < 0) || ($newField >= scalar @{$self->{fields}});
        ($self->{fields}->[$self->{currentField}], $self->{fields}->[$newField])
         = ($self->{fields}->[$newField], $self->{fields}->[$self->{currentField}]);
         $self->{fieldsList}->{data}->[$self->{currentField}] = [$self->{fields}->[$self->{currentField}]->{label}];
         $self->{fieldsList}->{data}->[$newField] = [$self->{fields}->[$newField]->{label}];
        $self->displayField($newField);
    }

    sub addField
    {
        my $self = shift;
        my $newLabel = $self->{parent}->{lang}->{ModelNewField};
        $self->saveCurrent;
        $self->{maxId}++;
        push (@{$self->{fields}}, {value => $self->{fieldsPrefix}.$self->{maxId},
                                   label => $newLabel});
        push (@{$self->{fieldsList}->{data}}, [$newLabel]);
        my $nbFields = scalar(@{$self->{fields}});
        if ($nbFields)
        {
            $self->setSensitive(1);
            $self->checkFieldType;
        }
        $self->displayField($nbFields - 1);
        $self->{params}->{label}->selectAll;
    }

    sub removeCurrent
    {
        my $self = shift;
        splice(@{$self->{fieldsList}->{data}}, $self->{currentField}, 1);
        splice(@{$self->{fields}}, $self->{currentField}, 1);
        $self->{currentField}-- if $self->{currentField} >= scalar @{$self->{fields}};
        if ($self->{currentField} < 0)
        {
            $self->clearForm;
            $self->setSensitive(0);
        }
        else
        {
            $self->displayField($self->{currentField});
        }
    }

    sub initCommonFields
    {
        my ($self, $init) = @_;
        
        my @imgValues = ({value => $GCModel::autoField, displayed => $self->{parent}->{lang}->{ModelOptionsFieldsAuto}});
        my @txtValues = ({value => $GCModel::autoField, displayed => $self->{parent}->{lang}->{ModelOptionsFieldsAuto}});
        my @fileValues = ({value => $GCModel::autoField, displayed => $self->{parent}->{lang}->{ModelOptionsFieldsAuto}},
                          {value => $GCModel::noneField, displayed => $self->{parent}->{lang}->{ModelOptionsFieldsNone}});
        if ($self->{fields})
        {
            foreach (@{$self->{fields}})
            {
                my $value = {value => $_->{value}, displayed => $_->{label}};
                if ($_->{type} eq 'image')
                {
                    push @imgValues, $value;
                }
                elsif ($_->{type} eq 'file')
                {
                    push @fileValues, $value;
                }
                else
                {
                    push @txtValues, $value;
                }
            }
        }
        
        $self->{common}->{title}->setValues(\@txtValues, 0, 1);
        $self->{common}->{id}->setValues(\@txtValues, 0, 1);
        $self->{common}->{cover}->setValues(\@imgValues, 0, 1);
        $self->{common}->{play}->setValues(\@fileValues, 0, 1);
        
        if ($init)
        {
            foreach (keys %{$self->{common}})
            {
                my $value = $init->{$_};
                $value ||= (($_ eq 'play') ? $GCModel::noneField : $GCModel::autoField);
                $self->{common}->{$_}->setValue($value);
            }
        }
    }

    sub getIdField
    {
        my $self = shift;
        my $value = $self->{common}->{id}->getValue;
        $value = '' if $value eq $GCModel::autoField;
        return $value;
    }

    sub getCoverField
    {
        my $self = shift;
        my $value = $self->{common}->{cover}->getValue;
        # We look for the 1st picture
        if ($value eq $GCModel::autoField)
        {
            $value = '';
            foreach (@{$self->{fields}})
            {
                ($value = $_->{value}, last) if $_->{type} eq 'image';
            }
        }
        # TODO We should check it is a picture
        return $value;
    }

    sub getTitleField
    {
        my $self = shift;
        my $value = $self->{common}->{title}->getValue;
        if ($value eq $GCModel::autoField)
        {
            # TODO We should filter to find the 1st suitable one
            $value = $self->{fields}->[0]->{value};
        }
        return $value;
    }

    sub getPlayField
    {
        my $self = shift;
        my $value = $self->{common}->{play}->getValue;
        $value = '' if $value eq $GCModel::noneField;
        # We look for the 1st file
        if ($value eq $GCModel::autoField)
        {
            $value = '';
            foreach (@{$self->{fields}})
            {
                ($value = $_->{value}, last) if $_->{type} eq 'file';
            }
        }
        # TODO We should check it is a file
        return $value;
    }

    sub hasLending
    {
        my $self = shift;

        return $self->{hasLending}->getValue;
    }

    sub hasTags
    {
        my $self = shift;

        return $self->{hasTags}->getValue;
    }

    sub checkFieldType
    {
        my $self = shift;
        
        my $type = $self->{params}->{type}->getValue;
        
        my $sensitive = 0;
        $sensitive = 1 if $type eq 'number';
        $self->{minLabel}->set_sensitive($sensitive);
        $self->{params}->{min}->set_sensitive($sensitive);
        $self->{maxLabel}->set_sensitive($sensitive);
        $self->{params}->{max}->set_sensitive($sensitive);
        $self->{stepLabel}->set_sensitive($sensitive);
        $self->{params}->{step}->set_sensitive($sensitive);
        $self->{displayasLabel}->set_sensitive($sensitive);
        $self->{params}->{displayas}->set_sensitive($sensitive);
        $sensitive = 0;
        $sensitive = 1 if $type eq 'options';
        $self->{valuesListLabel}->set_sensitive($sensitive);
        $self->{params}->{values}->set_sensitive($sensitive);
        $self->{valuesListLegend}->set_sensitive($sensitive);
        $sensitive = 0;
        $sensitive = 1 if $type eq 'file';
        $self->{formatLabel}->set_sensitive($sensitive);
        $self->{params}->{format}->set_sensitive($sensitive);
        $sensitive = 0;
        $sensitive = 1 if ($type eq 'short text') || ($type =~ /list$/);
        $self->{params}->{history}->set_sensitive($sensitive);
        $sensitive = 0;
        $sensitive = 1 if $type =~ /list$/;
        $self->{params}->{flat}->set_sensitive($sensitive);
    }

    sub checkFilterActivated
    {
        my $self = shift;
        
        my $activated = $self->{filter}->{activated}->getValue;
        $self->{comparisonLabel}->set_sensitive($activated);
        $self->{filter}->{comparison}->set_sensitive($activated);
        $self->{filter}->{numeric}->set_sensitive($activated);
        $self->{filter}->{quick}->set_sensitive($activated);
        $self->checkFilterSettings;
    }

    sub checkFilterSettings
    {
        my $self = shift;
        # We activate quick filter only for some fields
        my $activated = 0;
        my $info = $self->{fields}->[$self->{currentFilter}];
        my $hasFilter = $self->{filter}->{activated}->getValue;
        my $type = $info->{type};
        $activated = 1
            if $hasFilter && (
                ($info->{history} eq 'true')
             || ($type eq 'history text')
             || ($type eq 'yesno')
             || ($type eq 'number')
             || ($type eq 'date')
             || ($type eq 'options')
            );
        $self->{filter}->{quick}->set_sensitive($activated);
        $self->{filter}->{quick}->setValue(0) if !$activated;
        $activated = 0;
        $activated = 1
            if $hasFilter
             && ($type ne 'date')
             && ($type ne 'yesno')
             && ($type ne 'number');
        $self->{filter}->{numeric}->set_sensitive($activated);
        $self->{filter}->{numeric}->setValue(($info->{type} eq 'number')) if !$activated;
        $activated = 1;
        $activated = 0 if $type eq 'image';
        $self->{filter}->{activated}->set_sensitive($activated);
        $self->{filter}->{comparison}->set_sensitive($activated);
    }

    sub new
    {
        my ($proto, $parent, $list) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent,
                                       $parent->{lang}->{ModelSettings},
                                      );
        bless ($self, $class);

        $self->{parent} = $parent;
        $self->{tooltips} = Gtk2::Tooltips->new();
        
        $self->{currentField} = -1;
        $self->{currentFilter} = -1;
        $self->{fieldsPrefix} = 'gcsfield';
        
        my $hboxCollectionName = new Gtk2::HBox(0,0);
        my $collectionNameLabel = new GCLabel($parent->{lang}->{ModelName});
        $self->{collectionName} = new GCShortText;
        $self->{tooltips}->set_tip($self->{collectionName},
                                   $self->{parent}->{lang}->{ModelTooltipName});
        $hboxCollectionName->pack_start($collectionNameLabel, 0, 0, $GCUtils::margin);
        $hboxCollectionName->pack_start($self->{collectionName}, 1, 1, 0);
        
        $self->{notebook} = new Gtk2::Notebook;
        $self->{notebook}->set_tab_pos('left');
        $self->{notebook}->set_show_border(0);
        
        my $vboxFields = new Gtk2::VBox(0,0);
        my $vboxOptions = new Gtk2::VBox(0,0);
        my $vboxFilters = new Gtk2::VBox(0,0);

        $self->{fieldsList} = new Gtk2::SimpleList(
            '' => "text"
        );
        $self->{fieldsList}->signal_connect (cursor_changed => sub {
            my ($sl, $path, $column) = @_;
            my @idx = $sl->get_selected_indices;
            $self->changeCurrentLabel;
            $self->saveCurrent;
            $self->displayField($idx[0]);
        });
        
        $self->{fieldsList}->set_headers_visible(0);
        my $vboxFieldsList = new Gtk2::VBox(0,0);
        $self->{scrollPanelFields} = new Gtk2::ScrolledWindow;
        $self->{scrollPanelFields}->set_policy ('automatic', 'automatic');
        $self->{scrollPanelFields}->set_shadow_type('etched-in');
        $self->{scrollPanelFields}->add($self->{fieldsList});
        $vboxFieldsList->pack_start($self->{scrollPanelFields},1,1,0);
        my $hboxFieldsActions = new Gtk2::HBox(0,0);
        my $addButton = GCButton->newFromStock('gtk-add', 0);
        $addButton->signal_connect('clicked' => sub {
                $self->addField;
            });
        $self->{removeButton} = GCButton->newFromStock('gtk-remove', 0);
        $self->{removeButton}->signal_connect('clicked' => sub {
                $self->removeCurrent;
            });
        $hboxFieldsActions->pack_start($addButton,1,1,$GCUtils::halfMargin);
        $hboxFieldsActions->pack_start($self->{removeButton},1,1,$GCUtils::halfMargin);  
        $vboxFieldsList->pack_start($hboxFieldsActions,0,0,$GCUtils::halfMargin);

        my $vboxMove = new Gtk2::VBox(0,0);
        $self->{toUp} =GCButton->newFromStock('gtk-go-up', 0);
        $self->{toUp}->signal_connect('clicked' => sub {
            $self->moveDownUp(-1);
        });
        $self->{toDown} =GCButton->newFromStock('gtk-go-down', 0);
        $self->{toDown}->signal_connect('clicked' => sub {
            $self->moveDownUp(1);
        });
        $vboxMove->pack_start($self->{toUp}, 0, 0, $GCUtils::margin);
        $vboxMove->pack_start($self->{toDown}, 0, 0, $GCUtils::margin);
        
        $self->{fieldsOptionsTable} = new Gtk2::Table(18, 4);
        $self->{fieldsOptionsTable}->set_row_spacings($GCUtils::halfMargin);
        $self->{fieldsOptionsTable}->set_col_spacings($GCUtils::margin);
        $self->{fieldsOptionsTable}->set_border_width($GCUtils::margin);

        # Information
        #############
        my $nameLabel = GCLabel->new($parent->{lang}->{ModelFieldName});
        $self->{params}->{label} = new GCShortText;
        $self->{tooltips}->set_tip($self->{params}->{label},
                                   $parent->{lang}->{ModelTooltipLabel});
        $self->{params}->{label}->signal_connect('focus-out-event' => sub {
            $self->changeCurrentLabel;
            return 0;
        });
        my $typeLabel = GCLabel->new($parent->{lang}->{ModelFieldType});
        $self->{params}->{type} = new GCMenuList;
        $self->{params}->{type}->setValues([
                                    {value => 'short text', displayed => $parent->{lang}->{ModelFieldTypeShortText}},
                                    {value => 'long text', displayed => $parent->{lang}->{ModelFieldTypeLongText}},
                                    {value => 'yesno', displayed => $parent->{lang}->{ModelFieldTypeYesNo}},
                                    {value => 'number', displayed => $parent->{lang}->{ModelFieldTypeNumber}},
                                    {value => 'date', displayed => $parent->{lang}->{ModelFieldTypeDate}},
                                    {value => 'options', displayed => $parent->{lang}->{ModelFieldTypeOptions}},
                                    {value => 'image', displayed => $parent->{lang}->{ModelFieldTypeImage}},
                                    {value => 'single list', displayed => $parent->{lang}->{ModelFieldTypeSingleList}},
                                    {value => 'file', displayed => $parent->{lang}->{ModelFieldTypeFile}},
                                    {value => 'formatted', displayed => $parent->{lang}->{ModelFieldTypeFormatted}},
                                 ]);
        $self->{params}->{type}->signal_connect('changed' => sub {
            $self->checkFieldType;
        });
        my $groupLabel = GCLabel->new($parent->{lang}->{ModelFieldGroup});
        $self->{params}->{group} = new GCHistoryText;
        $self->{tooltips}->set_tip($self->{params}->{group},
                                   $parent->{lang}->{ModelTooltipGroup});
        my $informationLabel = new GCHeaderLabel($parent->{lang}->{ModelFieldInformation});
        $self->{fieldsOptionsTable}->attach($informationLabel, 0, 4, 0, 1, 'fill', 'fill', 0, 0);  
        $self->{fieldsOptionsTable}->attach($nameLabel, 2, 3, 1, 2, 'fill', 'fill', 0, 0);  
        $self->{fieldsOptionsTable}->attach($self->{params}->{label}, 3, 4, 1, 2, ['expand', 'fill'], 'fill', 0, 0);  
        $self->{fieldsOptionsTable}->attach($typeLabel, 2, 3, 2, 3, 'fill', 'fill', 0, 0);  
        $self->{fieldsOptionsTable}->attach($self->{params}->{type}, 3, 4, 2, 3, ['expand', 'fill'], 'fill', 0, 0);  
        $self->{fieldsOptionsTable}->attach($groupLabel, 2, 3, 3, 4, 'fill', 'fill', 0, 0);  
        $self->{fieldsOptionsTable}->attach($self->{params}->{group}, 3, 4, 3, 4, ['expand', 'fill'], 'fill', 0, 0);  
        
        # Parameters
        #############
        $self->{params}->{history} = GCCheckBox->new($parent->{lang}->{ModelFieldHasHistory});
        $self->{params}->{flat} = GCCheckBox->new($parent->{lang}->{ModelFieldFlat});
        $self->{tooltips}->set_tip($self->{params}->{history},
                                   $parent->{lang}->{ModelTooltipHistory});
        $self->{formatLabel} = GCLabel->new($parent->{lang}->{ModelFieldFileFormat});
        $self->{params}->{format} = new GCMenuList;
        $self->{tooltips}->set_tip($self->{params}->{format},
                                   $parent->{lang}->{ModelTooltipFormat});
        $self->{params}->{format}->setValues([
                                    {value => 'file', displayed => $parent->{lang}->{ModelFieldFileFile}},
                                    {value => 'video', displayed => $parent->{lang}->{ModelFieldFileVideo}},
                                    {value => 'audio', displayed => $parent->{lang}->{ModelFieldFileAudio}},
                                    {value => 'image', displayed => $parent->{lang}->{ModelFieldFileImage}},
                                    {value => 'program', displayed => $parent->{lang}->{ModelFieldFileProgram}},
                                    {value => 'url', displayed => $parent->{lang}->{ModelFieldFileUrl}},
                                    {value => 'ebook', displayed => $parent->{lang}->{ModelFieldFileEbook}}
                                 ]);
        my $parametersLabel = new GCHeaderLabel($parent->{lang}->{ModelFieldParameters});
        $self->{fieldsOptionsTable}->attach($parametersLabel, 0, 4, 5, 6, 'fill', 'fill', 0, 0);  
        $self->{fieldsOptionsTable}->attach($self->{params}->{history}, 2, 4, 6, 7, ['expand', 'fill'], 'fill', 0, 0);  
        $self->{fieldsOptionsTable}->attach($self->{params}->{flat}, 2, 4, 7, 8, ['expand', 'fill'], 'fill', 0, 0);  
        $self->{fieldsOptionsTable}->attach($self->{formatLabel}, 2, 3, 8, 9, 'fill', 'fill', 0, 0);  
        $self->{fieldsOptionsTable}->attach($self->{params}->{format}, 3, 4, 8, 9, ['expand', 'fill'], 'fill', 0, 0);  

        # Values
        #############
        my $initLabel = GCLabel->new($parent->{lang}->{ModelFieldInit});
        $self->{params}->{init} = new GCShortText;
        $self->{minLabel} = GCLabel->new($parent->{lang}->{ModelFieldMin});
        $self->{params}->{min} = new GCShortText;
        $self->{maxLabel} = GCLabel->new($parent->{lang}->{ModelFieldMax});
        $self->{params}->{max} = new GCShortText;
        $self->{stepLabel} = GCLabel->new($parent->{lang}->{ModelFieldStep});
        $self->{params}->{step} = new GCCheckedText('0-9.');
        $self->{valuesListLabel} = GCLabel->new($parent->{lang}->{ModelFieldList});
        $self->{params}->{values} = new GCShortText;
        $self->{valuesListLegend} = GCLabel->new($parent->{lang}->{ModelFieldListLegend});
        $self->{displayasLabel} = GCLabel->new($parent->{lang}->{ModelFieldDisplayAs});
        $self->{params}->{displayas} = new GCMenuList;
        $self->{params}->{displayas}->setValues([
                                    {value => 'text', displayed => $parent->{lang}->{ModelFieldDisplayAsText}},
                                    {value => 'graphical', displayed => $parent->{lang}->{ModelFieldDisplayAsGraphical}}
                                 ]);
        my $valuesLabel = new GCHeaderLabel($parent->{lang}->{ModelFieldValues});
        $self->{fieldsOptionsTable}->attach($valuesLabel, 0, 4, 10, 11, 'fill', 'fill', 0, 0);  
        $self->{fieldsOptionsTable}->attach($initLabel, 2, 3, 11, 12, 'fill', 'fill', 0, 0);  
        $self->{fieldsOptionsTable}->attach($self->{params}->{init}, 3, 4, 11, 12, ['expand', 'fill'], 'fill', 0, 0);  
        $self->{fieldsOptionsTable}->attach($self->{minLabel}, 2, 3, 12, 13, 'fill', 'fill', 0, 0);  
        $self->{fieldsOptionsTable}->attach($self->{params}->{min}, 3, 4, 12, 13, ['expand', 'fill'], 'fill', 0, 0);  
        $self->{fieldsOptionsTable}->attach($self->{maxLabel}, 2, 3, 13, 14, 'fill', 'fill', 0, 0);  
        $self->{fieldsOptionsTable}->attach($self->{params}->{max}, 3, 4, 13, 14, ['expand', 'fill'], 'fill', 0, 0);  
        $self->{fieldsOptionsTable}->attach($self->{stepLabel}, 2, 3, 14, 15, 'fill', 'fill', 0, 0);  
        $self->{fieldsOptionsTable}->attach($self->{params}->{step}, 3, 4, 14, 15, ['expand', 'fill'], 'fill', 0, 0);  
        $self->{fieldsOptionsTable}->attach($self->{displayasLabel}, 2, 3, 15, 16, 'fill', 'fill', 0, 0);  
        $self->{fieldsOptionsTable}->attach($self->{params}->{displayas}, 3, 4, 15, 16, ['expand', 'fill'], 'fill', 0, 0);  
        $self->{fieldsOptionsTable}->attach($self->{valuesListLabel}, 2, 3, 16, 17, 'fill', 'fill', 0, 0);  
        $self->{fieldsOptionsTable}->attach($self->{params}->{values}, 3, 4, 16, 17, ['expand', 'fill'], 'fill', 0, 0);  
        $self->{fieldsOptionsTable}->attach($self->{valuesListLegend}, 3, 4, 17, 18, ['expand', 'fill'], 'fill', 0, 0);  
        
        $self->{scrollFieldsPane} = new Gtk2::ScrolledWindow;
        $self->{scrollFieldsPane}->set_policy ('never', 'automatic');
        $self->{scrollFieldsPane}->set_shadow_type('none');
        $self->{scrollFieldsPane}->set_border_width($GCUtils::margin);
        $self->{scrollFieldsPane}->add_with_viewport($self->{fieldsOptionsTable});

        my $hboxFields = new Gtk2::HBox(0,0);
        $hboxFields->set_border_width($GCUtils::margin);
        $self->{fieldsPane} = new Gtk2::HPaned;
        $self->{fieldsPane}->signal_connect('size-allocate' => sub {
            $self->{scrollPanelFilters}->set_size_request($self->{scrollPanelFields}->allocation->width, -1);
        });
        $hboxFields->pack_start($vboxFieldsList, 1, 1, 0);
        $hboxFields->pack_start($vboxMove, 0, 0, $GCUtils::halfMargin);
        $self->{fieldsPane}->pack1($hboxFields,1,0);
        $self->{fieldsPane}->pack2($self->{scrollFieldsPane},1,0);
        $vboxFields->pack_start($self->{fieldsPane}, 1, 1, 0);

        my $optionsTable = new Gtk2::Table(9, 4);
        $optionsTable->set_row_spacings($GCUtils::halfMargin);
        $optionsTable->set_col_spacings($GCUtils::margin);
        $optionsTable->set_border_width($GCUtils::margin);

        my $titleFieldLabel = GCLabel->new($parent->{lang}->{ModelOptionsFieldsTitle});
        $self->{common}->{title} = new GCMenuList;
        my $coverFieldLabel = GCLabel->new($parent->{lang}->{ModelOptionsFieldsCover});
        $self->{common}->{cover} = new GCMenuList;
        my $idFieldLabel = GCLabel->new($parent->{lang}->{ModelOptionsFieldsId});
        $self->{common}->{id} = new GCMenuList;
        my $playFieldLabel = GCLabel->new($parent->{lang}->{ModelOptionsFieldsPlay});
        $self->{common}->{play} = new GCMenuList;
        $self->{hasLending} = new GCCheckBox($parent->{lang}->{ModelCollectionSettingsLending});
        $self->{tooltips}->set_tip($self->{hasLending},
                                   $parent->{lang}->{ModelTooltipLending});
        $self->{hasTags} = new GCCheckBox($parent->{lang}->{ModelCollectionSettingsTagging});
        $self->{tooltips}->set_tip($self->{hasTags},
                                   $parent->{lang}->{ModelTooltipTagging});

        my $commonFieldsLabel = new GCHeaderLabel($parent->{lang}->{ModelOptionsFields});
        $optionsTable->attach($commonFieldsLabel, 0, 4, 0, 1, 'fill', 'fill', 0, 0);
        $optionsTable->attach($titleFieldLabel, 2, 3, 1, 2, 'fill', 'fill', 0, 0);
        $optionsTable->attach($self->{common}->{title}, 3, 4, 1, 2, ['expand', 'fill'], 'fill', 0, 0);
        $optionsTable->attach($coverFieldLabel, 2, 3, 2, 3, 'fill', 'fill', 0, 0);
        $optionsTable->attach($self->{common}->{cover}, 3, 4, 2, 3, ['expand', 'fill'], 'fill', 0, 0);
        $optionsTable->attach($idFieldLabel, 2, 3, 3, 4, 'fill', 'fill', 0, 0);
        $optionsTable->attach($self->{common}->{id}, 3, 4, 3, 4, ['expand', 'fill'], 'fill', 0, 0);
        $optionsTable->attach($playFieldLabel, 2, 3, 4, 5, 'fill', 'fill', 0, 0);
        $optionsTable->attach($self->{common}->{play}, 3, 4, 4, 5, ['expand', 'fill'], 'fill', 0, 0);
        my $collectionSettingsLabel = new GCHeaderLabel($parent->{lang}->{ModelCollectionSettings});
        $optionsTable->attach($collectionSettingsLabel, 0, 4, 6, 7, 'fill', 'fill', 0, 0);
        $optionsTable->attach($self->{hasLending}, 2, 4, 7, 8, ['expand', 'fill'], 'fill', 0, 0);
        $optionsTable->attach($self->{hasTags}, 2, 4, 8, 9, ['expand', 'fill'], 'fill', 0, 0);

        $vboxOptions->pack_start($optionsTable, 1, 1, 0);

        $self->{notebook}->signal_connect('switch-page' => sub {
            my ($widget, $pointer, $number) = @_;
            $self->saveCurrent;
            $self->saveCurrentFilter;
            $self->initCommonFields if $number == 1;
        });


        $self->{filtersList} = new Gtk2::SimpleList('' => "text");
        $self->{filtersList}->set_model($self->{fieldsList}->get_model);
        $self->{filtersList}->signal_connect (cursor_changed => sub {
            my ($sl, $path, $column) = @_;
            my @idx = $sl->get_selected_indices;
            $self->saveCurrentFilter;
            $self->displayFilter($idx[0]);
        });

        $self->{filtersList}->set_headers_visible(0);
        $self->{scrollPanelFilters} = new Gtk2::ScrolledWindow;
        $self->{scrollPanelFilters}->set_policy ('automatic', 'automatic');
        $self->{scrollPanelFilters}->set_shadow_type('etched-in');
        $self->{scrollPanelFilters}->add($self->{filtersList});

        $self->{filter}->{activated} = GCCheckBox->new($parent->{lang}->{ModelFilterActivated});
        $self->{filter}->{activated}->signal_connect('toggled' => sub {
            $self->checkFilterActivated;
        });
        $self->{comparisonLabel} = GCLabel->new($parent->{lang}->{ModelFilterComparison});
        $self->{filter}->{comparison} = new GCComparisonSelector($parent);
        $self->{filter}->{numeric} = GCCheckBox->new($parent->{lang}->{ModelFilterNumeric});
        $self->{tooltips}->set_tip($self->{filter}->{numeric},
                                   $parent->{lang}->{ModelTooltipNumeric});
        $self->{filter}->{quick} = GCCheckBox->new($parent->{lang}->{ModelFilterQuick});
        $self->{tooltips}->set_tip($self->{filter}->{quick},
                                   $parent->{lang}->{ModelTooltipQuick});

        $self->{filtersOptionsTable} = new Gtk2::Table(4, 4);
        $self->{filtersOptionsTable}->set_row_spacings($GCUtils::halfMargin);
        $self->{filtersOptionsTable}->set_col_spacings($GCUtils::margin);
        $self->{filtersOptionsTable}->set_border_width($GCUtils::margin);
 
        $self->{filtersOptionsTable}->attach($self->{filter}->{activated}, 0, 4, 0, 1, 'fill', 'fill', 0, 0);  
        $self->{filtersOptionsTable}->attach($self->{comparisonLabel}, 2, 3, 1, 2, 'fill', 'fill', 0, 0);  
        $self->{filtersOptionsTable}->attach($self->{filter}->{comparison}, 3, 4, 1, 2, 'fill', 'fill', 0, 0);  
        $self->{filtersOptionsTable}->attach($self->{filter}->{numeric}, 2, 4, 2, 3, 'fill', 'fill', 0, 0);  
        $self->{filtersOptionsTable}->attach($self->{filter}->{quick}, 2, 4, 3, 4, 'fill', 'fill', 0, 0);  

        my $hboxFilters = new Gtk2::HBox(0,0);
        $hboxFilters->set_border_width($GCUtils::margin);
        $hboxFilters->pack_start($self->{scrollPanelFilters}, 0, 0, 0);
        $hboxFilters->pack_start($self->{filtersOptionsTable}, 1, 1, $GCUtils::halfMargin);
        $vboxFilters->pack_start($hboxFilters,1,1,0);

        $self->{notebook}->append_page($vboxFields, $parent->{lang}->{ModelFields});
        $self->{notebook}->append_page($vboxOptions, $parent->{lang}->{ModelOptions});
        $self->{notebook}->append_page($vboxFilters, $parent->{lang}->{ModelFilters});

        $self->vbox->pack_start($hboxCollectionName, 0, 0, $GCUtils::margin);
        $self->vbox->pack_start($self->{notebook}, 1, 1, 0);
        $self->vbox->show_all;
        
        # Set dialog size to fit nicely onto screen
        my $dialogWidth = $self->get_screen->get_width < 800 ? $self->get_screen->get_width - 50 : 750;
        my $dialogHeight = $self->get_screen->get_height < 650 ? $self->get_screen->get_height - 50 : 650;
        $self->set_default_size($dialogWidth, $dialogHeight);
       
        $self->setSensitive(0);

        return $self;
    }
}
 
1;
