{
    package GCLang::SR;

    use utf8;
###################################################
#
#  Copyright 2005 Tian
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
#  GNU General Public License for more Details.
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

        'LangName' => 'Srpski',
        
        'Separator' => ': ',
        
        'Warning' => '<b>Upozorenje</b>:
        
Informacije skinute sa web sajtova (putem modula za pretragu) su <b>samo za ličnu upotrebu</b>.

Svaka daljna distribucija je zabranjena bez <b>jasne dozvole</b> sajta.

Da biste odredili koji sajt je vlasnik informacija, možete da koristite <b>dugme ispod podataka o filmu</b>.',
        
        'AllItemsFiltered' => 'Nijedan film ne odgovara zadatom kriterijumu', # Accepts model codes
        
#Installation
    	'InstallDirInfo' => 'Instaliraj u',
    	'InstallMandatory' => 'Obavezne komponente',
    	'InstallOptional' => 'Opcione komponente',
    	'InstallErrorMissing' => 'Greška : Sledeće Perl komponente moraju prethodno da budu instalirane: ',
    	'InstallPrompt' => 'Osnovni direktorijum za instalaciju [/usr/local]: ',
    	'InstallEnd' => 'Kraj instalacije',
    	'InstallNoError' => 'Bez grešaka',
    	'InstallLaunch' => 'Da biste koristili ovaj program, možete pokrenuti ',
    	'InstallDirectory' => 'Osnovni direktorijum',
    	'InstallTitle' => 'GCstar instalacija',
    	'InstallDependencies' => 'Zavisnosti',
        'InstallPath' => 'Putanja',
        'InstallOptions' => 'Opcije',
    	'InstallSelectDirectory' => 'Izaberite osnovni direktorijum za instalaciju',
    	'InstallWithClean' => 'Obriš fajlove koji se nalaze u instalacionom direktorijumu',
    	'InstallWithMenu' => 'Dodaj GCstar u listu programa',
    	'InstallNoPermission' => 'Greška: Nemate dozvolu za pisanje u direktorijum koji ste odabrali',
    	'InstallMissingMandatory' => 'Nedostaju obavezne zavisne komponente. Nećete moći da instalirate GCstar dok ih ne dodate u sistem.',
    	'InstallMissingOptional' => 'Nedostaju neke obavezne zavisne komponente. Imena su im izlistana ispod. GCstar se može instalirati, ali neke funkcije vam neće raditi.',
    	'InstallMissingNone' => 'Sve zavisnosti su u redu. Možete da nastavite sa GCstar instalacijom.',
    	'InstallOK' => 'OK',
    	'InstallMissing' => 'Nedostaju',
    	'InstallMissingFor' => 'Nedostaju',
        'InstallCleanDirectory' => 'Removing GCstar\'s files in directory: ',
        'InstallCopyDirectory' => 'Copying files in directory: ',
        'InstallCopyDesktop' => 'Copying desktop file in: ',

#Update
        'UpdateUseProxy' => 'Koristi proxy (pritisnite enter ako ih nema): ',
        'UpdateNoPermission' => 'Odbijena dozvola za pisanje u ovom direktorijumu: ',
        'UpdateNone' => 'Novija verzija nije pronađena',
        'UpdateFileNotFound' => 'Fajl nije pronađen',

#Splash
    	'SplashInit' => 'Startovanje',
    	'SplashLoad' => 'Učitavam kolekciju',
        'SplashDisplay' => 'Displaying Collection',
        'SplashSort' => 'Sorting Collection',
    	'SplashDone' => 'Spremno',

#Import from GCfilms
        'GCfilmsImportQuestion' => 'It seems you were using GCfilms before. What do you want to import from GCfilms to GCstar (it won\'t impact GCfilms if you still want to use it)?',
        'GCfilmsImportOptions' => 'Settings',
        'GCfilmsImportData' => 'Movies list',

#Menus
    	'MenuFile' => '_Fajl',
    		'MenuNewList' => '_Nova Kolekcija',
            'MenuStats' => 'Statistics',
    		'MenuHistory' => '_Poslednje Kolekcije',
    		'MenuLend' => 'Prikaži Po_zajmljene Filmove', # Accepts model codes
    		'MenuImport' => '_Uvezi',	
    		'MenuExport' => '_Izvezi',
            'MenuAddItem' => '_Add Items', # Accepts model codes
    
    	'MenuEdit'  => '_Izmeni',
            'MenuDuplicate' => '_Dupliraj Film', # Accepts model codes
            'MenuDuplicatePlural' => 'Du_plicate Items', # Accepts model codes
            'MenuEditSelectAllItems' => 'Select _All Items', # Accepts model codes
            'MenuEditDeleteCurrent' => '_Obriši Film', # Accepts model codes
            'MenuEditDeleteCurrentPlural' => '_Remove Items', # Accepts model codes 
            'MenuEditFields' => '_Change collection fields',
    		'MenuEditLockItems' => '_Zaključaj Kolekciju',
    
    	'MenuDisplay' => 'F_ilter',
            'MenuSavedSearches' => 'Saved searches',
                'MenuSavedSearchesSave' => 'Save current search',
                'MenuSavedSearchesEdit' => 'Modify saved searches',
            'MenuAdvancedSearch' => 'A_dvanced Search',
    		'MenuViewAllItems' => 'Prikaži _Sve Filmove', # Accepts model codes
            'MenuNoFilter' => '_Bilo Koji',
    
    	'MenuConfiguration' => '_Podešavanja',
            'MenuDisplayMenu' => 'Display',
                'MenuDisplayFullScreen' => 'Full screen',
                'MenuDisplayMenuBar' => 'Menus',
                'MenuDisplayToolBar' => 'Toolbar',
                'MenuDisplayStatusBar' => 'Bottom bar',
    		'MenuDisplayOptions' => '_Prikazane Informacije',
    		'MenuBorrowers' => '_Pozajmljivači',
            'MenuToolbarConfiguration' => '_Toolbar controls',
            'MenuDefaultValues' => 'Default values for new item', # Accepts model codes
            'MenuGenresConversion' => 'Prebacivanje _Žanra',
    
        'MenuBookmarks' => 'My _Collections',
            'MenuBookmarksAdd' => '_Add current collection',
            'MenuBookmarksEdit' => '_Edit bookmarked collections',

    	'MenuHelp' => '_Pomoć',
        	'MenuHelpContent' => '_Pomoć',
            'MenuAllPlugins' => 'View _plugins',
            'MenuBugReport' => 'Report a _bug',
    		'MenuAbout' => '_O GCstar',
    
    	'MenuNewWindow' => 'Prikaži Film U _Novom Prozoru', # Accepts model codes
        'MenuNewWindowPlural' => 'Show Items in _New Window', # Accepts model codes
                
        'ContextExpandAll' => 'Expand all',
        'ContextCollapseAll' => 'Collapse all',
        'ContextChooseImage' => 'Choose _Image',
        'ContextOpenWith' => 'Open Wit_h',
        'ContextImageEditor' => 'Image Editor', 
        'ContextImgFront' => 'Front',
        'ContextImgBack' => 'Back',
        'ContextChooseFile' => 'Choose a File',
        'ContextChooseFolder' => 'Choose a Folder',

        'DialogEnterNumber' => 'Please enter value',

        'RemoveConfirm' => 'Da listvarno želite da obrišete ovaj film?', # Accepts model codes
        'RemoveConfirmPlural' => 'Do you really want to remove these items?', # Accepts model codes
        'DefaultNewItem' => 'New item', # Accepts model codes
        'NewItemTooltip' => 'Dodaj novi film', # Accepts model codes
        'NoItemFound' => 'Film nije pronađen. Da li želite da pretražite drugi sajt?',
        'OpenList' => 'Odaberite kolekciju',
        'SaveList' => 'Odaberite gde ćete da sačuvate kolekciju',
        'SaveListTooltip' => 'Sačuvaj trenutnu kolekciju',
        'SaveUnsavedChanges' => 'There are unsaved changes in your collection. Do you want to save them?',
        'SaveDontSave' => 'Don\'t save',
        'PreferencesTooltip' => 'Podesite svoje parametre',
        'ViewTooltip' => 'Promenite prikaz kolekcije',
        'PlayTooltip' => 'Pustite film', # Accepts model codes
        'PlayFileNotFound' => 'File to launch was not found in this location:',
        'PlayRetry' => 'Retry',

        'StatusSave' => 'Saving...',
        'StatusLoad' => 'Loading...',
        'StatusSearch' => 'Pretraga u toku...',
        'StatusGetInfo' => 'Prikupljanje informacija u toku...',
        'StatusGetImage' => 'Snimanje slike u toku...',
                
        'SaveError' => 'Ne mogu da sačuvam listu filmova. Proverite prava pristupa i slobodan prostor na disku.',
        'OpenError' => 'Ne mogu da otvorim listu filmova. Proverite prava pristupa.',
		'OpenFormatError' => 'Cannot open items list. Format may be incorrect.',
        'OpenVersionWarning' => 'Collection was created with a more recent version of GCstar. If you save it, you may loose some data.',
        'OpenVersionQuestion' => 'Do you still want to continue?',
        'ImageError' => 'Odabrani direktorijum za čuvanje slika nije ispravan. Odaberite drugi.',
        'OptionsCreationError'=> 'Ne mogu da napravim fajl sa opcijama: ',
        'OptionsOpenError'=> 'Ne mogu da otvorim fajl sa opcijama: ',
        'OptionsSaveError'=> 'Ne mogu da sačuvam fajl sa opcijama:  ',
        'ErrorModelNotFound' => 'Model not found: ',
        'ErrorModelUserDir' => 'User defined models are in: ',
        
        'RandomTooltip' => 'Šta gledati večeras ?',
        'RandomError'=> 'Nemate neodgledanih filmova', # Accepts model codes
        'RandomEnd'=> 'Nemate više filmova', # Accepts model codes
        'RandomNextTip'=> 'Sledeći predlog',
        'RandomOkTip'=> 'Biram ovaj film',
        
        'AboutTitle' => 'O GCstar',
        'AboutDesc' => 'Gtk2 Katalog Filmova',
        'AboutVersion' => 'Verzija',
        'AboutTeam' => 'Tim',
        'AboutWho' => 'Christian Jodar (Tian): Vođa projekta, Programer
Nyall Dawson (Zombiepig): Programer
TPF: Programer
Adolfo González: Programer
',
        'AboutLicense' => 'Distribuirano pod GNU GPL uslovima
Logo Copyright le Spektre',
        'AboutTranslation' => 'Prevod na srpski Mario Tomić (http://www.mariotomic.com)',
        'AboutDesign' => 'Łukasz Kowalczk (Qoolman): Skin Designer
Logo i web dizajn le Spektre',

        'ToolbarRandom' => 'Večeras',
        
        'UnsavedCollection' => 'Unsaved Collection',
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
        'ModelCollectionSettingsLending' => 'Items could be borrowed',
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
        'ModelTooltipNumeric' => 'Should the values be consider as numbers for comparison',
        'ModelTooltipQuick' => 'This will add a submenu in the Filters one',
        
        'ResultsTitle' => 'Odaberite film', # Accepts model codes
        'ResultsNextTip' => 'Pretraži sledeći sajt',
        'ResultsPreview' => 'Preview',
        'ResultsInfo' => 'You can add multiple items to the collection by holding down the Ctrl or the Shift key and selecting them', # Accepts model codes
        
        'OptionsTitle' => 'Podešavanja',
		'OptionsExpertMode' => 'Expert Mode',
        'OptionsPrograms' => 'Specify applications to use for different media, leave blank to use system defaults',
        'OptionsBrowser' => 'Web brauzer',
        'OptionsPlayer' => 'Video plejer',
        'OptionsAudio' => 'Audio player',
        'OptionsImageEditor' => 'Image editor',
        'OptionsCdDevice' => 'CD device',
        'OptionsImages' => 'Direktorijum sa slikama',
        'OptionsUseRelativePaths' => 'Koristi relativnu putanju do slika',
        'OptionsLayout' => 'Izgled',
        'OptionsStatus' => 'Pokaži statusnu liniju',
        'OptionsUseStars' => 'Use stars to display ratings',
        'OptionsWarning' => 'Upozorenje: Izmene sa ove kartice se neće videti dok se program ponovo ne pokrene.',
        'OptionsRemoveConfirm' => 'Traži potvrdu pre nego što obrišeš film',
        'OptionsAutoSave' => 'Automatski sačuvaj kolekciju',
        'OptionsAutoLoad' => 'Load previous collection on startup',
        'OptionsSplash' => 'Prikaži uvodni ekran (splash screen)',
        'OptionsTearoffMenus' => 'Enable tear-off menus',
        'OptionsSpellCheck' => 'Use spelling checker for long text fields',
        'OptionsProgramTitle' => 'Odaberite koji program želite da koristite',
		'OptionsPlugins' => 'Sajt sa kog želite da preuzmete podatke',
		'OptionsAskPlugins' => 'Pitaj me (Svi sajtovi)',
		'OptionsPluginsMulti' => 'Neki sajtovi',
		'OptionsPluginsMultiAsk' => 'Pitaj me (Neki sajtovi)',
        'OptionsPluginsMultiPerField' => 'Neki sajtovi (per field)',
        'OptionsPluginsMultiPerFieldWindowTitle' => 'Many sites per field order selection',
        'OptionsPluginsMultiPerFieldDesc' => 'For each selected field we will return the first non empty information beginning from left',
        'OptionsPluginsMultiPerFieldFirst' => 'First',
        'OptionsPluginsMultiPerFieldLast' => 'Last',
        'OptionsPluginsMultiPerFieldRemove' => 'Remove',
        'OptionsPluginsMultiPerFieldClearSelected' => 'Empty selected field list',
		'OptionsPluginsList' => 'Zadaj listu',
        'OptionsAskImport' => 'Odaberite polja za uvoženje',
		'OptionsProxy' => 'Koristi proxy',
		'OptionsCookieJar' => 'Use this cookie jar file',
        'OptionsLang' => 'Jezik',
        'OptionsMain' => 'Glavni',
        'OptionsPaths' => 'Putanje',
        'OptionsInternet' => 'Internet',
        'OptionsConveniences' => 'Funkcije',
        'OptionsDisplay' => 'Prikaz',
        'OptionsToolbar' => 'Alati',
        'OptionsToolbars' => {0 => 'Bez', 1 => 'Mali', 2 => 'Veliki', 3 => 'System setting'},
        'OptionsToolbarPosition' => 'Pozicija',
        'OptionsToolbarPositions' => {0 => 'Vrh', 1 => 'Dno', 2 => 'Levo', 3 => 'Desno'},
        'OptionsExpandersMode' => 'Expanders too long',
        'OptionsExpandersModes' => {'asis' => 'Do nothing', 'cut' => 'Cut', 'wrap' => 'Line wrap'},
        'OptionsDateFormat' => 'Date Format',
        'OptionsDateFormatTooltip' => 'Format is the one used by strftime(3). Default is %d/%m/%Y',
        'OptionsView' => 'Prikaz',
        'OptionsViews' => {0 => 'Tekst', 1 => 'Slika', 2 => 'Detaljno'},
        'OptionsColumns' => 'Kolone',
        'OptionsMailer' => 'E-mail servis',
        'OptionsSMTP' => 'Server',
        'OptionsFrom' => 'Vaš e-mail',
        'OptionsTransform' => 'Stavi članove posle naslova filma',
        'OptionsArticles' => 'Članovi (Odvojeni zarezom)',
        'OptionsSearchStop' => 'Dozvoli da pretraga bude prekinuta',
        'OptionsBigPics' => 'Use big pictures when available',
        'OptionsAlwaysOriginal' => 'Koristi glavni naslov kao originalni ukoliko originalnog nema',
        'OptionsRestoreAccelerators' => 'Restore accelerators',
        'OptionsHistory' => 'Veličina istorije',
        'OptionsClearHistory' => 'Obriši istoriju',
		'OptionsStyle' => 'Promena izgleda',
        'OptionsDontAsk' => 'Ne pitaj više',
        'OptionsPathProgramsGroup' => 'Applications',
        'OptionsProgramsSystem' => 'Use programs defined by system',
        'OptionsProgramsUser' => 'Use specified programs',
        'OptionsProgramsSet' => 'Set programs',
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
        'OptionsConfigureMailers' => 'Configure mailing programs',

        'ImagesOptionsButton' => 'Podešavanja',
        'ImagesOptionsTitle' => 'Podešavanja za liste slika',
        'ImagesOptionsSelectColor' => 'Odaberi boju',
        'ImagesOptionsUseOverlays' => 'Use image overlays',
        'ImagesOptionsBg' => 'Pozadina',
        'ImagesOptionsBgPicture' => 'Upotrebi pozadisku sliku',
        'ImagesOptionsFg'=> 'Selekcija',
        'ImagesOptionsBgTooltip' => 'Promeni boju pozadine',
        'ImagesOptionsFgTooltip'=> 'Promeni boju selekcije',
        'ImagesOptionsResizeImgList' => 'Automatically change number of columns',
        'ImagesOptionsAnimateImgList' => 'Use animations',
        'ImagesOptionsSizeLabel' => 'Veličina',
        'ImagesOptionsSizeList' => {0 => 'Vrlo mali', 1 => 'Mali', 2 => 'Srednji', 3 => 'Veliki', 4 => 'Vrlo veliki'},
        'ImagesOptionsSizeTooltip' => 'Odaberi veličinu slike',
		        
        'DetailedOptionsTitle' => 'Podešavanja za detaljnu listu',
        'DetailedOptionsImageSize' => 'Veličina slike',
        'DetailedOptionsGroupItems' => 'Grupiši filmove prema kolekciji',
        'DetailedOptionsSecondarySort' => 'Sort field for children',
		'DetailedOptionsFields' => 'Odaberi polja za prikaz',
        'DetailedOptionsGroupedFirst' => 'Keep together orphaned items',
        'DetailedOptionsAddCount' => 'Add number of elements on categories',

        'ExtractButton' => 'Informacije',
        'ExtractTitle' => 'Informacije o video fajlu',
        'ExtractImport' => 'Koristi vrednosti',

        'FieldsListOpen' => 'Load a fields list from a file',
        'FieldsListSave' => 'Save fields list to a file',
        'FieldsListError' => 'This fields list cannot be used with this kind of collection',
        'FieldsListIgnore' => '--- Ignore',

        'ExportTitle' => 'Izvezi listu filmova',
        'ExportFilter' => 'Izvezi samo prikazane filmove',
        'ExportFieldsTitle' => 'Polja za izvoženje',
        'ExportFieldsTip' => 'Odaberi polja koja želiš da izvezeš',
        'ExportWithPictures' => 'Kopiraj slike u pod-direktorijum',
        'ExportSortBy' => 'Sort by',
        'ExportOrder' => 'Order',

        'ImportListTitle' => 'Uvezi drugu listu filmova',
        'ImportExportData' => 'Data',
        'ImportExportFile' => 'Fajl',
        'ImportExportFieldsUnused' => 'Neiskorišćena polja',
        'ImportExportFieldsUsed' => 'Iskorišćena polja',
        'ImportExportFieldsFill' => 'Dodaj sva',
        'ImportExportFieldsClear' => 'Ukloni sva',
        'ImportExportFieldsEmpty' => 'Moraš da izabereš barem jedno polje',
        'ImportExportFileEmpty' => 'Moraš da navedeš ime fajla',
        'ImportFieldsTitle' => 'Polja za uvoženje',
        'ImportFieldsTip' => 'Odaberi polja koja želiš da uvezeš',
        'ImportNewList' => 'Napravi novu kolekciju',
        'ImportCurrentList' => 'Dodaj u trenutnu kolekciju',
        'ImportDropError' => 'Došlo je do greške pri otvaranju najmanje jednog fajla. Učitaće se prethodna lista.',
        'ImportGenerateId' => 'Generate identifier for each item',

        'FileChooserOpenFile' => 'Odaberi fajl koji ?eš da koristiš',
        'FileChooserDirectory' => 'Directory',
        'FileChooserOpenDirectory' => 'Odaberite direktorijum',
        'FileChooserOverwrite' => 'Ovaj fajl već postoji. Da li želite da ga zamenite novim fajlom?',
        'FileAllFiles' => 'All Files',
        'FileVideoFiles' => 'Video Files',
        'FileEbookFiles' => 'Ebook Files',
        'FileAudioFiles' => 'Audio Files',
        'FileGCstarFiles' => 'GCstar Collections',

        'PanelCompact' => 'Sažeti',
        'PanelReadOnly' => 'Samo Za čitanje',
        'PanelForm' => 'Kartice',

        'PanelSearchButton' => 'Prikupi informacije',
        'PanelSearchTip' => 'Pretraži internet za informacije o ovom filmu',
        'PanelSearchContextChooseOne' => 'Choose a site ...',
        'PanelSearchContextMultiSite' => 'Use "Many sites"',
        'PanelSearchContextMultiSitePerField' => 'Use "Many sites per field"',
        'PanelSearchContextOptions' => 'Change options ...',
        'PanelImageTipOpen' => 'Klikni na sliku da odabereš neku drugu.',
        'PanelImageTipView' => 'Click on the picture to view it in real size.',
        'PanelImageTipMenu' => ' Desni klik za više opcija.',
        'PanelImageTitle' => 'Odaberi sliku',
        'PanelImageNoImage' => 'No image',
        'PanelSelectFileTitle' => 'Odaberi fajl',
        'PanelLaunch' => 'Launch',        
        'PanelRestoreDefault' => 'Restore default',
        'PanelRefresh' => 'Update',
        'PanelRefreshTip' => 'Update information from web',

        'PanelFrom' =>'From',
        'PanelTo' =>'To',

        'PanelWeb' => 'Pogledaj Informacije',
        'PanelWebTip' => 'Pogledaj Informacije o ovom filmu na internetu', # Accepts model codes
        'PanelRemoveTip' => 'Obriši ovaj film', # Accepts model codes

        'PanelDateSelect' => 'Odaberi datum',
        'PanelNobody' => 'Niko',
        'PanelUnknown' => 'Nepoznat',
        'PanelAdded' => 'Add date',
        'PanelRating' => 'Ocena',
        'PanelPressRating' => 'Press Rating',
        'PanelLocation' => 'Lokacija',

        'PanelLending' => 'Pozajmljivanje',
        'PanelBorrower' => 'Pozajmio',
        'PanelLendDate' => 'Pozajmljen Od',
        'PanelHistory' => 'Istorija Pozajmljivanja',
        'PanelReturned' => 'Vraćen Film', # Accepts model codes
        'PanelReturnDate' => 'Datum vraćanja',
        'PanelLendedYes' => 'Pozajmljen',
        'PanelLendedNo' => 'Ovde',

        'PanelTags' => 'Tags',
        'PanelFavourite' => 'Favourite',
        'TagsAssigned' => 'Assigned Tags', 

        'PanelUser' => 'User fields',

        'CheckUndef' => 'Ili',
        'CheckYes' => 'Da',
        'CheckNo' => 'Ne',

        'ToolbarAll' => 'Vidi sve',
        'ToolbarAllTooltip' => 'Vidi sve filmove',
        'ToolbarGroupBy' => 'Group by',
        'ToolbarGroupByTooltip' => 'Select the field to use to group items in list',
        'ToolbarQuickSearch' => 'Quick search',
        'ToolbarQuickSearchLabel' => 'Search',
        'ToolbarQuickSearchTooltip' => 'Select the field to search in. Enter the search terms and press Enter',
        'ToolbarSeparator' => ' Separator',
        
        'PluginsTitle' => 'Traži po filmovima',
        'PluginsQuery' => 'Query',
        'PluginsFrame' => 'Traži po internet sajtu',
        'PluginsLogo' => 'Logo',
        'PluginsName' => 'Ime',
        'PluginsSearchFields' => 'Search fields',
        'PluginsAuthor' => 'Autor',
        'PluginsLang' => 'Jezik',
        'PluginsUseSite' => 'Koristi odabrani sajt za sledeće pretrage',
        'PluginsPreferredTooltip' => 'Site recommended by GCstar',
        'PluginDisabled' => 'Disabled',

        'BorrowersTitle' => 'Opcije za pozajmljivače',
        'BorrowersList' => 'Pozajmljivači',
        'BorrowersName' => 'Ime',
        'BorrowersEmail' => 'E-mail',
        'BorrowersAdd' => 'Dodaj',
        'BorrowersRemove' => 'Obriši',
        'BorrowersEdit' => 'Promeni',
        'BorrowersTemplate' => 'Predefinisani mail šablon',
        'BorrowersSubject' => 'Naslov maila',
        'BorrowersNotice1' => '%1 će biti zamenjeno imenom onog kome pozajmljuješ',
        'BorrowersNotice2' => '%2 će biti zamenjeno imenom filma',
        'BorrowersNotice3' => '%3 će biti zamenjeno datumom pozajmice',

        'BorrowersImportTitle' => 'Import borrowers information',
        'BorrowersImportType' => 'File format:',
        'BorrowersImportFile' => 'File:',

        'BorrowedTitle' => 'Pozajmljeni filmovi', # Accepts model codes
        'BorrowedDate' => 'Od',
        'BorrowedDisplayInPanel' => 'Show item in main window', # Accepts model codes

        'MailTitle' => 'Pošalji mu e-mail',
        'MailFrom' => 'Od: ',
        'MailTo' => 'Za: ',
        'MailSubject' => 'Naslov: ',
        'MailSmtpError' => 'Problem sa povezivanjem na server za slanje maila (SMTP server)',
        'MailSendmailError' => 'Problem sa startovanjem mail servera (sendmail)',

        'SearchTooltip' => 'Pretraži sve filmove', # Accepts model codes
        'SearchTitle' => 'Traži film', # Accepts model codes
        'SearchNoField' => 'No field have been selected for the search box.
Add some of them in the Filters tab of the collection settings.',

        'QueryReplaceField' => 'Field to replace',
        'QueryReplaceOld' => 'Trenutno ime',
        'QueryReplaceNew' => 'Novo ime',
        'QueryReplaceLaunch' => 'Replace',
        
        'ImportWindowTitle' => 'Odaberi polja koja će se uvesti',
        'ImportViewPicture' => 'Vidi sliku',
        'ImportSelectAll' => 'Odaberi sve',
        'ImportSelectNone' => 'Poništi odabrano',

        'MultiSiteTitle' => 'Za pretragu koristi ove sajtove',
        'MultiSiteUnused' => 'Nekorišćeni dodaci',
        'MultiSiteUsed' => 'Koristi ove dodatke',
        'MultiSiteLang' => 'Ubaci u listu dodatke na engleskom',
        'MultiSiteEmptyError' => 'Lista sajtova je prazna',
        'MultiSiteClear' => 'Obriši listu',
        
        'DisplayOptionsTitle' => 'Prikaži sledeće',
        'DisplayOptionsAll' => 'Odaberi sve',
        'DisplayOptionsSearch' => 'Taster pretrage',

        'GenresTitle' => 'Menjanje Žanrova',
        'GenresCategoryName' => 'Žanr',
        'GenresCategoryMembers' => 'Umesto žanra',
        'GenresLoad' => 'Učitaj listu',
        'GenresExport' => 'Sačuvaj listu kao fajl',
        'GenresModify' => 'Izmeni menjanje žanrova',

        'PropertiesName' => 'Collection name',
        'PropertiesLang' => 'Language code',
        'PropertiesOwner' => 'Owner',
        'PropertiesEmail' => 'Email',
        'PropertiesDescription' => 'Description',
        'PropertiesFile' => 'File Information',
        'PropertiesFilePath' => 'Full path',
        'PropertiesItemsNumber' => 'Number of items', # Accepts model codes
        'PropertiesFileSize' => 'Size',
        'PropertiesFileSizeSymbols' => ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
        'PropertiesCollection' => 'Collection properties',
        'PropertiesDefaultPicture' => 'Default picture',

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

        'BookmarksBookmarks' => 'Bookmarks',
        'BookmarksFolder' => 'Directory',
        'BookmarksLabel' => 'Label',
        'BookmarksPath' => 'Path',
        'BookmarksNewFolder' => 'New folder',

        'AdvancedSearchType' => 'Type of search',
        'AdvancedSearchTypeAnd' => 'Items matching all criteria', # Accepts model codes
        'AdvancedSearchTypeOr' => 'Items matching at least one criterion', # Accepts model codes
        'AdvancedSearchCriteria' => 'Criteria',
        'AdvancedSearchAnyField' => 'Any field',
        'AdvancedSearchSaveTitle' => 'Save search',
        'AdvancedSearchSaveName' => 'Name',
        'AdvancedSearchSaveOverwrite' => 'A saved search already exists with that name. Please use a different one.',
        'AdvancedSearchUseCase' => 'Case sensitive',
        'AdvancedSearchIgnoreDiacritics' => 'Ignore accents and other diacritics',

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

        'DefaultValuesTip' => 'Values set in this window will be used as the default values when creating a new {lowercase1}',
    );
}
1;
