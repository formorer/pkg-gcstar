{
    package GCLang::EN;

    use utf8;
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
    
#
# MODEL-SPECIFIC CODES
#
# Some strings are modified to include the model-specific item type. Inside these strings,
# any strings contained in {}'s will be replaced by the corresponding string from
# the Item collection in the model language file. For example:
#
# {lowercase1} = {Items}->{lowercase1} (item type, singular, all lowercase). EG: game, movie, book
# {1} = {Items}->{1} (item type, singular, with first letter uppercase). EG: Game, Movie, Book
# {lowercaseX} = {Items}->{lowercaseX} (item type, multiple, lowercase). EG: games, movies, books
# {X} = {Items}->{X} (item type, multiple, with first letter uppercase). EG Games, Movies, Books    
#
# GCstar will automatically convert these codes to the relevant translated string. You can 
# use these codes in any string marked by a "Accepts model codes" comment.    
#
    
    use strict;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (

        'LangName' => 'English',
        
        'Separator' => ': ',
        
        'Warning' => '<b>Warning</b>:
        
Information downloaded from web sites (through the 
search plugins) is for <b>personal use only</b>.

Any redistribution is forbidden without the site\'s
<b>explicit authorization</b>.

To determine which site owns the information, you
may use the <b>button below item details</b>.',
        
        'AllItemsFiltered' => 'No {lowercaseX} match your filter criteria', # Accepts model codes
        
#Installation
        'InstallDirInfo' => 'Installing in ',
        'InstallMandatory' => 'Mandatory components',
        'InstallOptional' => 'Optional Components',
        'InstallErrorMissing' => 'Error : Following Perl components have to be installed: ',
        'InstallPrompt' => 'Base directory for installation [/usr/local]: ',
        'InstallEnd' => 'End of the installation',
        'InstallNoError' => 'No error',
        'InstallLaunch' => 'To use this application you can launch ',
        'InstallDirectory' => 'Base directory',
        'InstallTitle' => 'GCstar installation',
        'InstallDependencies' => 'Dependencies',
        'InstallPath' => 'Path',
        'InstallOptions' => 'Options',
        'InstallSelectDirectory' => 'Select base directory for the installation',
        'InstallWithClean' => 'Remove files found in installation directory',
        'InstallWithMenu' => 'Add GCstar to Applications menu',
        'InstallNoPermission' => 'Error: You don\'t have permission to write in the selected directory',
        'InstallMissingMandatory' => 'Mandatory dependencies are missing. You won\'t be able to install GCstar until they have been added to your system.',
        'InstallMissingOptional' => 'Some optional dependencies are missing. These are listed below. GCstar can be installed but some features won\'t be available.',
        'InstallMissingNone' => 'There are no missing dependencies. You may continue and install GCstar.',
        'InstallOK' => 'OK',
        'InstallMissing' => 'Missing',
        'InstallMissingFor' => 'Missing for',
        'InstallCleanDirectory' => 'Removing GCstar\'s files in directory: ',
        'InstallCopyDirectory' => 'Copying files in directory: ',
        'InstallCopyDesktop' => 'Copying desktop file in: ',

#Update
        'UpdateUseProxy' => 'Proxy to use (just press enter if none): ',
        'UpdateNoPermission' => 'Write permission denied in this directory: ',
        'UpdateNone' => 'No updates have been found',
        'UpdateFileNotFound' => 'File not found',

#Splash
        'SplashInit' => 'Initializing',
        'SplashLoad' => 'Loading Collection',
        'SplashDisplay' => 'Displaying Collection',
        'SplashSort' => 'Sorting Collection',
        'SplashDone' => 'Ready',

#Import from GCfilms
        'GCfilmsImportQuestion' => 'It seems you were previously using GCfilms. What do you want to import from GCfilms to GCstar (it won\'t impact GCfilms if you still want to use it)?',
        'GCfilmsImportOptions' => 'Settings',
        'GCfilmsImportData' => 'Movies list',

#Menus
        'MenuFile' => '_File',
            'MenuNewList' => '_New Collection',
            'MenuStats' => 'Statistics',
            'MenuHistory' => '_Recent Collections',
            'MenuLend' => 'Display _Borrowed {X}', # Accepts model codes
            'MenuImport' => '_Import',	
            'MenuExport' => '_Export',
            'MenuAddItem' => '_Add {1}', # Accepts model codes
    
        'MenuEdit'  => '_Edit',
            'MenuDuplicate' => 'Du_plicate {1}', # Accepts model codes
            'MenuDuplicatePlural' => 'Du_plicate {X}', # Accepts model codes
            'MenuEditSelectAllItems' => 'Select _All {X}', # Accepts model codes
            'MenuEditDeleteCurrent' => '_Remove {1}', # Accepts model codes
            'MenuEditDeleteCurrentPlural' => '_Remove {X}', # Accepts model codes    
            'MenuEditFields' => '_Change Collection Fields',
            'MenuEditLockItems' => '_Lock Collection',
    
        'MenuDisplay' => 'F_ilter',
            'MenuSavedSearches' => 'Saved Searches',
                'MenuSavedSearchesSave' => 'Save Current Search',
                'MenuSavedSearchesEdit' => 'Modify Saved Searches',
            'MenuAdvancedSearch' => 'A_dvanced Search',
            'MenuViewAllItems' => 'Show _All {X}', # Accepts model codes
            'MenuNoFilter' => '_Any',
    
        'MenuConfiguration' => '_Settings',
            'MenuDisplayMenu' => 'Di_splay',
                'MenuDisplayFullScreen' => '_Full screen',
                'MenuDisplayMenuBar' => '_Menus',
                'MenuDisplayToolBar' => '_Toolbar',
                'MenuDisplayStatusBar' => 'B_ottom bar',
            'MenuDisplayOptions' => '_Displayed Information',
            'MenuBorrowers' => '_Borrowers',
            'MenuToolbarConfiguration' => '_Toolbar Controls',
            'MenuDefaultValues' => 'Default values for new {1}', # Accepts model codes
            'MenuGenresConversion' => 'Genre _Conversion',
        
        'MenuBookmarks' => 'My _Collections',
            'MenuBookmarksAdd' => '_Add Current Collection',
            'MenuBookmarksEdit' => '_Edit Bookmarked Collections',

        'MenuHelp' => '_Help',
            'MenuHelpContent' => '_Content',
            'MenuAllPlugins' => 'View _Plugins',
            'MenuBugReport' => 'Report a Problem',
            'MenuAbout' => '_About GCstar',
    
        'MenuNewWindow' => 'Show {1} in _New Window', # Accepts model codes
        'MenuNewWindowPlural' => 'Show {X} in _New Window', # Accepts model codes
        
        'ContextExpandAll' => 'Expand All',
        'ContextCollapseAll' => 'Collapse All',
        'ContextChooseImage' => 'Choose _Image',
        'ContextOpenWith' => 'Open Wit_h',
        'ContextImageEditor' => 'Image Editor',
        'ContextImgFront' => 'Front',
        'ContextImgBack' => 'Back',
        'ContextChooseFile' => 'Choose a File',
        'ContextChooseFolder' => 'Choose a Folder',

        'DialogEnterNumber' => 'Please enter value',

        'RemoveConfirm' => 'Do you really want to remove this {lowercase1}?', # Accepts model codes
        'RemoveConfirmPlural' => 'Do you really want to remove these {lowercaseX}?', # Accepts model codes

        'DefaultNewItem' => 'New {lowercase1}', # Accepts model codes
        'NewItemTooltip' => 'Add a new {lowercase1}', # Accepts model codes
        'NoItemFound' => 'Nothing was found. Would you like to search another site?',
        'OpenList' => 'Please select collection',
        'SaveList' => 'Please choose where to save the collection',
        'SaveListTooltip' => 'Save current collection',
        'SaveUnsavedChanges' => 'There are unsaved changes in your collection. Do you want to save them?',
        'SaveDontSave' => 'Don\'t save',
        'PreferencesTooltip' => 'Set your preferences',
        'ViewTooltip' => 'Change collection display',
        'PlayTooltip' => 'Launch file associated to the {lowercase1}', # Accepts model codes
        'PlayFileNotFound' => 'File to launch was not found in this location:',
        'PlayRetry' => 'Retry',

        'StatusSave' => 'Saving...',
        'StatusLoad' => 'Loading...',
        'StatusSearch' => 'Search in progress...',
        'StatusGetInfo' => 'Getting information...',
        'StatusGetImage' => 'Getting picture...',
                
        'SaveError' => 'Cannot save items list. Please check access rights and disk free space.',
        'OpenError' => 'Cannot open items list. Please check access rights.',
        'OpenFormatError' => 'Cannot open items list. Format may be incorrect.',
        'OpenVersionWarning' => 'Collection was created with a more recent version of GCstar. If you save it, you may loose some data.',
        'OpenVersionQuestion' => 'Do you still want to continue?',
        'ImageError' => 'Selected directory to save images is not correct. Please select another one.',
        'OptionsCreationError'=> 'Cannot create options file: ',
        'OptionsOpenError'=> 'Cannot open options file: ',
        'OptionsSaveError'=> 'Cannot save options file: ',
        'ErrorModelNotFound' => 'Model not found: ',
        'ErrorModelUserDir' => 'User defined models are in: ',
        
        'RandomTooltip' => 'What to see this evening?',
        'RandomError'=> 'You have no {lowercaseX} that could be chosen', # Accepts model codes
        'RandomEnd'=> 'You have no more {lowercaseX} to choose from!', # Accepts model codes
        'RandomNextTip'=> 'Next suggestion',
        'RandomOkTip'=> 'Accept this suggestion',
        
        'AboutTitle' => 'About GCstar',
        'AboutDesc' => 'Personal collections manager',
        'AboutVersion' => 'Version',
        'AboutTeam' => 'Team',
        'AboutWho' => 'Christian Jodar (Tian): Project manager, Programmer
Nyall Dawson (Zombiepig): Programmer
TPF: Programmer
Adolfo González: Programmer
',
        'AboutLicense' => 'Distributed under the terms of the GNU GPL
Logos Copyright le Spektre',
        'AboutTranslation' => 'English translation by Christian Jodar and Jason Day',
        'AboutDesign' => 'Łukasz Kowalczk (Qoolman): Skin Designer
Logo and webdesign by le Spektre',

        'UnsavedCollection' => 'Unsaved Collection',

#Collection models
        'ModelsSelect' => 'Select a collection type',
        'ModelsPersonal' => 'Personal models',
        'ModelsDefault' => 'Default models',
        'ModelsList' => 'Collection definition',
        'ModelSettings' => 'Collection settings',
        'ModelNewType' => 'New collection type',
        'ModelName' => 'Name of the collection type:',
		'ModelFields' => 'Fields',
		'ModelOptions'	=> 'Options',
		'ModelFilters'	=> 'Filters',
        'ModelNewField' => 'New field',
        'ModelFieldInformation' => 'Information',
        'ModelFieldName' => 'Label:',
        'ModelFieldType' => 'Type:',
        'ModelFieldGroup' => 'Group:',
        'ModelFieldValues' => 'Values',
        'ModelFieldInit' => 'Default:',
        'ModelFieldMin' => 'Minimum:',
        'ModelFieldMax' => 'Maximum:',
        'ModelFieldList' => 'Values list:',
        'ModelFieldListLegend' => '<i>Comma separated</i>',
        'ModelFieldDisplayAs' => 'Display as:',
        'ModelFieldDisplayAsText' => 'Text',
        'ModelFieldDisplayAsGraphical' => 'Rating Control',
        'ModelFieldTypeShortText' => 'Short text',
        'ModelFieldTypeLongText' => 'Long text',
        'ModelFieldTypeYesNo' => 'Yes/No',
        'ModelFieldTypeNumber' => 'Number',
        'ModelFieldTypeDate' => 'Date',
        'ModelFieldTypeOptions' => 'Pre-defined values list',
        'ModelFieldTypeImage' => 'Image',
        'ModelFieldTypeSingleList' => 'Simple list',
        'ModelFieldTypeFile' => 'File',
        'ModelFieldTypeFormatted' => 'Dependant on other fields',
        'ModelFieldParameters' => 'Parameters',
        'ModelFieldHasHistory' => 'Use an history',
        'ModelFieldFlat' => 'Display on one line',
        'ModelFieldStep' => 'Increment step:',
        'ModelFieldFileFormat' => 'File format:',
        'ModelFieldFileFile' => 'Simple file',
        'ModelFieldFileImage' => 'Image',
        'ModelFieldFileVideo' => 'Video',
        'ModelFieldFileAudio' => 'Audio',
        'ModelFieldFileProgram' => 'Program',
        'ModelFieldFileUrl' => 'URL',
        'ModelFieldFileEbook' => 'Ebook',
        'ModelOptionsFields' => 'Fields to use',
        'ModelOptionsFieldsAuto' => 'Automatic',
        'ModelOptionsFieldsNone' => 'None',
        'ModelOptionsFieldsTitle' => 'As title',
        'ModelOptionsFieldsId' => 'As identifier',
        'ModelOptionsFieldsCover' => 'As cover',
        'ModelOptionsFieldsPlay' => 'For Play button',
        'ModelCollectionSettings' => 'Collection settings',
        'ModelCollectionSettingsLending' => 'Items can be borrowed',
        'ModelCollectionSettingsTagging' => 'Items can be tagged',
        'ModelFilterActivated' => 'Should be in search box',
        'ModelFilterComparison' => 'Comparison',
        'ModelFilterContain' => 'Contains',
        'ModelFilterDoesNotContain' => 'Does not contain',
        'ModelFilterRegexp' => 'Regular expression',
        'ModelFilterRange' => 'Range',
        'ModelFilterNumeric' => 'Comparison is numeric',
        'ModelFilterQuick' => 'Create a quick filter',
        'ModelTooltipName' => 'Use a name to re-use this model for many collections. If empty, the settings will be directly stored in the collection itself',
        'ModelTooltipLabel' => 'The field name as it will be displayed',
        'ModelTooltipGroup' => 'Used to group fields. Items with no value here will be in a default group',
        'ModelTooltipHistory' => 'Should the previous entered values be stored in a list associated to the field',
        'ModelTooltipFormat' => 'This format is used to determine the action to open the file with the Play button',
        'ModelTooltipLending' => 'This will add some fields to manage lendings',
        'ModelTooltipTagging' => 'This will add some fields to manage tags',
        'ModelTooltipNumeric' => 'Should the values be considered as numbers for comparison',
        'ModelTooltipQuick' => 'This will add a submenu in the Filters one',

#Web searches
        'PluginsTitle' => 'Search an item',
        'PluginsQuery' => 'Query',
        'PluginsFrame' => 'Search site',
        'PluginsLogo' => 'Logo',
        'PluginsName' => 'Name',
        'PluginsSearchFields' => 'Search fields',
        'PluginsAuthor' => 'Author',
        'PluginsLang' => 'Language',
        'PluginsUseSite' => 'Use selected site for future searches',
        'PluginsPreferredTooltip' => 'Site recommended by GCstar',
        'PluginDisabled' => 'Disabled',

        'ResultsTitle' => 'Select a {lowercase1}', # Accepts model codes
        'ResultsNextTip' => 'Search in next site',
        'ResultsPreview' => 'Preview',
        'ResultsInfo' => 'You can add multiple {lowercaseX} to the collection by holding down the Ctrl or the Shift key and selecting them', # Accepts model codes

        'ImportWindowTitle' => 'Select Fields to be Imported',
        'ImportViewPicture' => 'View Picture',
        'ImportSelectAll' => 'Select All',
        'ImportSelectNone' => 'Select None',

        'MultiSiteTitle' => 'Sites to use for searches',
        'MultiSiteUnused' => 'Unused plugins',
        'MultiSiteUsed' => 'Plugins to be used',
        'MultiSiteLang' => 'Fill List with English Plugins',
        'MultiSiteEmptyError' => 'You have an empty site list',
        'MultiSiteClear' => 'Clear List',

#Settings
        'OptionsTitle' => 'Preferences',
		'OptionsExpertMode' => 'Expert Mode',
        'OptionsPrograms' => 'Specify applications to use for different media, leave blank to use system defaults',
        'OptionsBrowser' => 'Web browser',
        'OptionsPlayer' => 'Video player',
        'OptionsAudio' => 'Audio player',
        'OptionsImageEditor' => 'Image editor',
        'OptionsCdDevice' => 'CD device',
        'OptionsImages' => 'Images directory',
        'OptionsUseRelativePaths' => 'Use relative paths for images',
        'OptionsLayout' => 'Layout',
        'OptionsStatus' => 'Display status bar',
        'OptionsUseStars' => 'Use stars to display ratings',
        'OptionsWarning' => 'Warning: Changes in this tab won\'t take effect until the application is restarted.',
        'OptionsRemoveConfirm' => 'Ask confirmation before item deletion',
        'OptionsAutoSave' => 'Automatically save collection',
        'OptionsAutoLoad' => 'Load previous collection on startup',
        'OptionsSplash' => 'Show splash screen',
        'OptionsTearoffMenus' => 'Enable tear-off menus',
        'OptionsSpellCheck' => 'Use spelling checker for long text fields',
        'OptionsProgramTitle' => 'Select the program to be used',
        'OptionsPlugins' => 'Site to retrieve data from',
        'OptionsAskPlugins' => 'Ask (All sites)',
        'OptionsPluginsMulti' => 'Many sites',
        'OptionsPluginsMultiAsk' => 'Ask (Many sites)',
        'OptionsPluginsMultiPerField' => 'Many sites (per field)',
        'OptionsPluginsMultiPerFieldWindowTitle' => 'Many sites per field order selection',
        'OptionsPluginsMultiPerFieldDesc' => 'For each field we will fill the field with the first non empty information beginning from left',
        'OptionsPluginsMultiPerFieldFirst' => 'First',
        'OptionsPluginsMultiPerFieldLast' => 'Last',
        'OptionsPluginsMultiPerFieldRemove' => 'Remove',
        'OptionsPluginsMultiPerFieldClearSelected' => 'Empty selected field list',
        'OptionsPluginsList' => 'Set list',
        'OptionsAskImport' => 'Select fields to be imported',
        'OptionsProxy' => 'Use a proxy',
        'OptionsCookieJar' => 'Use this cookie jar file',
        'OptionsLang' => 'Language',
        'OptionsMain' => 'Main',
        'OptionsPaths' => 'Paths',
        'OptionsInternet' => 'Internet',
        'OptionsConveniences' => 'Features',
        'OptionsDisplay' => 'Display',
        'OptionsToolbar' => 'Toolbar',
        'OptionsToolbars' => {0 => 'None', 1 => 'Small', 2 => 'Large', 3 => 'System setting'},
        'OptionsToolbarPosition' => 'Position',
        'OptionsToolbarPositions' => {0 => 'Top', 1 => 'Bottom', 2 => 'Left', 3 => 'Right'},
        'OptionsExpandersMode' => 'Expanders too long',
        'OptionsExpandersModes' => {'asis' => 'Do nothing', 'cut' => 'Cut', 'wrap' => 'Line wrap'},
        'OptionsDateFormat' => 'Date Format',
        'OptionsDateFormatTooltip' => 'Format is the one used by strftime(3). Default is %d/%m/%Y',
        'OptionsView' => 'Items list',
        'OptionsViews' => {0 => 'Text', 1 => 'Image', 2 => 'Detailed'},
        'OptionsColumns' => 'Columns',
        'OptionsMailer' => 'E-mailer',
        'OptionsSMTP' => 'Server',
        'OptionsFrom' => 'Your e-mail',
        'OptionsTransform' => 'Place articles at the end of titles',
        'OptionsArticles' => 'Articles (Comma separated)',
        'OptionsSearchStop' => 'Allow search to be aborted',
        'OptionsBigPics' => 'Download hi-res artwork when available',
        'OptionsAlwaysOriginal' => 'Use main title as the original title if none present',
        'OptionsRestoreAccelerators' => 'Restore Accelerators',
        'OptionsHistory' => 'Size of history',
        'OptionsClearHistory' => 'Clear History',
		'OptionsStyle' => 'Skin',
        'OptionsDontAsk' => 'Don\'t ask anymore',
        'OptionsPathProgramsGroup' => 'Applications',
        'OptionsProgramsSystem' => 'Use programs defined by system',
        'OptionsProgramsUser' => 'Override default programs',
        'OptionsProgramsSet' => 'Set Programs',
        'OptionsPathImagesGroup' => 'Images',
        'OptionsInternetDataGroup' => 'Data import',
        'OptionsInternetSettingsGroup' => 'Settings',
        'OptionsDisplayInformationGroup' => 'Information display',
        'OptionsDisplayArticlesGroup' => 'Articles',
        'OptionsImagesDisplayGroup' => 'Display',
        'OptionsImagesStyleGroup' => 'Style',
        'OptionsDetailedPreferencesGroup' => 'Preferences',
        'OptionsFeaturesConveniencesGroup' => 'Conveniences',
        'OptionsPicturesFormat' => 'Prefix to use for pictures:',
        'OptionsPicturesFormatInternal' => 'gcstar__',
        'OptionsPicturesFormatTitle' => 'Title or name of the associated item',
        'OptionsPicturesWorkingDir' => '%WORKING_DIR% or . will be replaced with collection directory (use only on beginning of path)',
        'OptionsPicturesFileBase' => '%FILE_BASE% will be replaced by collection file name without suffix (.gcs)',
        'OptionsPicturesWorkingDirError' => '%WORKING_DIR% could only be used on the beginning of the path for pictures',
        'OptionsConfigureMailers' => 'Configure Mailing Programs',

#Image list settings
        'ImagesOptionsButton' => 'Settings',
        'ImagesOptionsTitle' => 'Settings for images list',
        'ImagesOptionsSelectColor' => 'Select a color',
        'ImagesOptionsUseOverlays' => 'Use image overlays',
        'ImagesOptionsBg' => 'Background',
        'ImagesOptionsBgPicture' => 'Use a background picture',
        'ImagesOptionsFg'=> 'Selection',
        'ImagesOptionsBgTooltip' => 'Change background color',
        'ImagesOptionsFgTooltip'=> 'Change selection color',
        'ImagesOptionsResizeImgList' => 'Automatically change number of columns',
        'ImagesOptionsAnimateImgList' => 'Use animations',
        'ImagesOptionsSizeLabel' => 'Size',
        'ImagesOptionsSizeList' => {0 => 'Very Small', 1 => 'Small', 2 => 'Medium', 3 => 'Large', 4 => 'Extra Large'},
        'ImagesOptionsSizeTooltip' => 'Select image size',

#Detailed list settings
        'DetailedOptionsTitle' => 'Settings for detailed list',
        'DetailedOptionsImageSize' => 'Images size',
        'DetailedOptionsGroupItems' => 'Group items by',
        'DetailedOptionsSecondarySort' => 'Sort field for children',
		'DetailedOptionsFields' => 'Select fields to display',
        'DetailedOptionsGroupedFirst' => 'Keep together orphaned items',
        'DetailedOptionsAddCount' => 'Add number of elements on categories',

#Fields to display
        'DisplayOptionsTitle' => 'Items to display',
        'DisplayOptionsAll' => 'Select all',
        'DisplayOptionsSearch' => 'Search button',

#Extract plugins
        'ExtractButton' => 'Information',
        'ExtractTitle' => 'File information',
        'ExtractImport' => 'Use values',

#Fields list
        'FieldsListOpen' => 'Load a fields list from a file',
        'FieldsListSave' => 'Save fields list to a file',
        'FieldsListError' => 'This fields list cannot be used with this kind of collection',
        'FieldsListIgnore' => '--- Ignore',

#Export plugins
        'ExportTitle' => 'Export item list',
        'ExportFilter' => 'Export only displayed items',
        'ExportFieldsTitle' => 'Fields to be exported',
        'ExportFieldsTip' => 'Select fields you want to export',
        'ExportWithPictures' => 'Copy pictures in a sub-directory',
        'ExportSortBy' => 'Sort by',
        'ExportOrder' => 'Order',

#Import plugins
        'ImportListTitle' => 'Import another items list',
        'ImportExportData' => 'Data',
        'ImportExportFile' => 'File',
        'ImportExportFieldsUnused' => 'Unused fields',
        'ImportExportFieldsUsed' => 'Used fields',
        'ImportExportFieldsFill' => 'Add All',
        'ImportExportFieldsClear' => 'Remove All',
        'ImportExportFieldsEmpty' => 'You must choose at least one field',
        'ImportExportFileEmpty' => 'You have to specify a file name',
        'ImportFieldsTitle' => 'Fields to be imported',
        'ImportFieldsTip' => 'Select fields you want to import',
        'ImportNewList' => 'Create a new collection',
        'ImportCurrentList' => 'Add to current collection',
        'ImportDropError' => 'There was an error opening at least one file. Previous list will be reloaded.',
        'ImportGenerateId' => 'Generate identifier for each item',

#File chooser
        'FileChooserOpenFile' => 'Please select file to use',
        'FileChooserDirectory' => 'Directory',
        'FileChooserOpenDirectory' => 'Select a directory',
        'FileChooserOverwrite' => 'This file already exists. Do you want to overwrite it?',
        'FileAllFiles' => 'All Files',
        'FileVideoFiles' => 'Video Files',
        'FileEbookFiles' => 'Ebook Files',
        'FileAudioFiles' => 'Audio Files',
        'FileGCstarFiles' => 'GCstar Collections',

#Some default panels
        'PanelCompact' => 'Compact',
        'PanelReadOnly' => 'Read Only',
        'PanelForm' => 'Tabs',

#Default labels used in panels
        'PanelSearchButton' => 'Fetch Information',
        'PanelSearchTip' => 'Search web for information on this name',
        'PanelSearchContextChooseOne' => 'Choose a site ...',
        'PanelSearchContextMultiSite' => 'Use "Many sites"',
        'PanelSearchContextMultiSitePerField' => 'Use "Many sites per field"',
        'PanelSearchContextOptions' => 'Change options ...',
        'PanelImageTipOpen' => 'Click on the picture to select different one.',
        'PanelImageTipView' => 'Click on the picture to view it in real size.',
        'PanelImageTipMenu' => ' Right click for more options.',
        'PanelImageTitle' => 'Select a picture',
        'PanelImageNoImage' => 'No image',
        'PanelSelectFileTitle' => 'Select File',
        'PanelLaunch' => 'Launch',
        'PanelRestoreDefault' => 'Restore Default',
        'PanelRefresh' => 'Update',
        'PanelRefreshTip' => 'Automatically update blank fields',

        'PanelFrom' =>'From',
        'PanelTo' =>'To',

        'PanelWeb' => 'View Information',
        'PanelWebTip' => 'View information on the web about this {lowercase1}', # Accepts model codes
        'PanelRemoveTip' => 'Remove current {lowercase1}', # Accepts model codes

        'PanelDateSelect' => 'Select',
        'PanelNobody' => 'Nobody',
        'PanelUnknown' => 'Unknown',
        'PanelAdded' => 'Add date',
        'PanelRating' => 'Rating',
        'PanelPressRating' => 'Press Rating',
        'PanelLocation' => 'Location',

        'PanelLending' => 'Lending',
        'PanelBorrower' => 'Borrower',
        'PanelLendDate' => 'Out Since',
        'PanelHistory' => 'Lending History',
        'PanelReturned' => '{1} Returned', # Accepts model codes
        'PanelReturnDate' => 'Return date',
        'PanelLendedYes' => 'Lended',
        'PanelLendedNo' => 'Available',

        'PanelTags' => 'Tags',
        'PanelFavourite' => 'Favourite',
        'TagsAssigned' => 'Assigned Tags', 

        'PanelUser' => 'User fields',

        'CheckUndef' => 'Either',
        'CheckYes' => 'Yes',
        'CheckNo' => 'No',

#Toolbar
        'ToolbarRandom' => 'Tonight',
        'ToolbarAll' => 'View All',
        'ToolbarAllTooltip' => 'View all items',
        'ToolbarGroupBy' => 'Group by',
        'ToolbarGroupByTooltip' => 'Select the field to use to group items in list',
        'ToolbarQuickSearch' => 'Quick search',
        'ToolbarQuickSearchLabel' => 'Search',
        'ToolbarQuickSearchTooltip' => 'Select the field to search in. Enter the search terms and press Enter',
        'ToolbarSeparator' => ' Separator',

#Borrowers
        'BorrowersTitle' => 'Borrower Configuration',
        'BorrowersList' => 'Borrowers',
        'BorrowersName' => 'Name',
        'BorrowersEmail' => 'E-mail',
        'BorrowersAdd' => 'Add',
        'BorrowersRemove' => 'Remove',
        'BorrowersEdit' => 'Edit',
        'BorrowersTemplate' => 'Mail template',
        'BorrowersSubject' => 'Mail subject',
        'BorrowersNotice1' => '%1 will be replaced with the borrower\'s name',
        'BorrowersNotice2' => '%2 will be replaced with the item title',
        'BorrowersNotice3' => '%3 will be replaced with the borrow date',

        'BorrowersImportTitle' => 'Import borrowers information',
        'BorrowersImportType' => 'File format:',
        'BorrowersImportFile' => 'File:',

        'BorrowedTitle' => 'Borrowed {lowercaseX}', # Accepts model codes
        'BorrowedDate' => 'Since',
        'BorrowedDisplayInPanel' => 'Show {1} in Main Window', # Accepts model codes

#Mail
        'MailTitle' => 'Send an e-mail',
        'MailFrom' => 'From: ',
        'MailTo' => 'To: ',
        'MailSubject' => 'Subject: ',
        'MailSmtpError' => 'Problem when connecting to SMTP server',
        'MailSendmailError' => 'Problem when launching sendmail',

#Search dialog
        'SearchTooltip' => 'Search all {lowercaseX}', # Accepts model codes
        'SearchTitle' => '{1} Search', # Accepts model codes
        'SearchNoField' => 'No field have been selected for the search box.
Add some of them in the Filters tab of the collection settings.',

        'AdvancedSearchType' => 'Type of search',
        'AdvancedSearchTypeAnd' => '{X} matching all criteria', # Accepts model codes
        'AdvancedSearchTypeOr' => '{X} matching at least one criterion', # Accepts model codes
        'AdvancedSearchCriteria' => 'Criteria',
        'AdvancedSearchAnyField' => 'Any field',
        'AdvancedSearchSaveTitle' => 'Save search',
        'AdvancedSearchSaveName' => 'Name',
        'AdvancedSearchSaveOverwrite' => 'A saved search already exists with that name. Please use a different one.',
        'AdvancedSearchUseCase' => 'Case sensitive',
        'AdvancedSearchIgnoreDiacritics' => 'Ignore accents and other diacritics',

#Query replace
        'QueryReplaceField' => 'Field to replace',
        'QueryReplaceOld' => 'Current value',
        'QueryReplaceNew' => 'New value',
        'QueryReplaceLaunch' => 'Replace',

#Collection properties
        'PropertiesName' => 'Collection name',
        'PropertiesLang' => 'Language code',
        'PropertiesOwner' => 'Owner',
        'PropertiesEmail' => 'Email',
        'PropertiesDescription' => 'Description',
        'PropertiesFile' => 'File Information',
        'PropertiesFilePath' => 'Full path',
        'PropertiesItemsNumber' => 'Number of {lowercaseX}', # Accepts model codes
        'PropertiesFileSize' => 'Size',
        'PropertiesFileSizeSymbols' => ['Bytes', 'kB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
        'PropertiesCollection' => 'Collection properties',
        'PropertiesDefaultPicture' => 'Default picture',

#Mail sending
        'MailProgramsTitle' => 'Programs for mail sending',
        'MailProgramsName' => 'Name',
        'MailProgramsCommand' => 'Command line',
        'MailProgramsRestore' => 'Restore defaults',
        'MailProgramsAdd' => 'Add a program',
        'MailProgramsInstructions' => 'In command line, some substitutions are made:
 %f is replaced with user\'s e-mail address.
 %t is replaced with the recipient address.
 %s is replaced with the subject of the message.
 %b is replaced with the body of the message.',

#Bookmarks
        'BookmarksBookmarks' => 'Bookmarks',
        'BookmarksFolder' => 'Folders',
        'BookmarksLabel' => 'Label',
        'BookmarksPath' => 'Path',
        'BookmarksNewFolder' => 'New folder',

#Bug report
        'BugReportSubject' => 'Bug report generated from GCstar',
        'BugReportVersion' => 'Version',
        'BugReportPlatform' => 'Operating system',
        'BugReportMessage' => 'Error message',
        'BugReportInformation' => 'Additional information',

#Statistics
        'StatsFieldToUse' => 'Field to use',
        'StatsSortByNumber' => 'Sort by number of {lowercaseX}',
        'StatsGenerate' => 'Generate',
        'StatsKindOfGraph' => 'Kind of graphic',
        'StatsBars' => 'Bars',
        'StatsPie' => 'Pie',
        'Stats3DPie' => '3D Pie',
        'StatsArea' => 'Areas',
        'StatsHistory' => 'History',
        'StatsWidth' => 'Width',
        'StatsHeight' => 'Height',
        'StatsFontSize' => 'Font size',
        'StatsDisplayNumber' => 'Show numbers',
        'StatsSave' => 'Save statistics image to a file',
        'StatsAccumulate' => 'Accumulate values',
        'StatsShowAllDates' => 'Show all dates',

#Not used yet
        'GenresTitle' => 'Genre Conversion',
        'GenresCategoryName' => 'Genre to use',
        'GenresCategoryMembers' => 'Genre to replace',
        'GenresLoad' => 'Load a list',
        'GenresExport' => 'Save list to a file',
        'GenresModify' => 'Edit conversion',

#Statistics
        'StatsFieldToUse' => 'Field to use',
        'StatsSortByNumber' => 'Sort by number of {lowercaseX}',
        'StatsGenerate' => 'Generate',
        'StatsKindOfGraph' => 'Kind of graphic',
        'StatsBars' => 'Bars',
        'StatsPie' => 'Pie',
        'Stats3DPie' => '3D Pie',
        'StatsArea' => 'Areas',
        'StatsHistory' => 'History',
        'StatsWidth' => 'Width',
        'StatsHeight' => 'Height',
        'StatsFontSize' => 'Font size',
        'StatsDisplayNumber' => 'Show numbers',
        'StatsSave' => 'Save statistics image to a file',
        'StatsAccumulate' => 'Accumulate values',
        'StatsShowAllDates' => 'Show all dates',

        'DefaultValuesTip' => 'Values set in this window will be used as the default values when creating a new {lowercase1}',

    );
}
1;
