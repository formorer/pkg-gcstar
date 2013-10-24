{
    package GCLang::RO;

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

        'LangName' => 'Română',
        
        'Separator' => ': ',
        
        'Warning' => '<b>Atenţie</b>:
        
Informaţiile transferate de pe siturile web (prin intermediul
modulelor de căutare) sunt <b>doar pentru uz personal</b>.

Orice redistribuire este interzisă fără <b>autorizarea
explicită</b> a sitului web.

Pentru a determina ce sit web este proprietarul informaţiei,
puteţi folosi <b>butonul aflat sub detaliile filmului</b>.',
        
        'AllItemsFiltered' => 'Nici un element nu se potriveşte criteriilor dumneavoastră de filtrare', # Accepts model codes
        
#Installation
        'InstallDirInfo' => 'Instalare în ',
        'InstallMandatory' => 'Componente obligatorii',
        'InstallOptional' => 'Componente opţionale',
        'InstallErrorMissing' => 'Eroare : Următoarele componente Perl trebuie instalate: ',
        'InstallPrompt' => 'Directorul principal pentru instalare [/usr/local]: ',
        'InstallEnd' => 'Sfârşitul instalării',
        'InstallNoError' => 'Nici o eroare',
        'InstallLaunch' => 'Pentru a folosi acestă aplicaţie, se poate porni ',
        'InstallDirectory' => 'Directorul principal',
        'InstallTitle' => 'Instalare GCstar',
        'InstallDependencies' => 'Dependinţe',
        'InstallPath' => 'Cale',
        'InstallOptions' => 'Opţiuni',
        'InstallSelectDirectory' => 'Selectaţi directorul principal pentru instalare',
        'InstallWithClean' => 'Şterge fişierele aflate în directorul de instalare',
        'InstallWithMenu' => 'Adaugă GCstar la meniul Aplicaţii',
        'InstallNoPermission' => 'Eroare: Nu aveţi permisiunile necesare pentru a scrie în directorul selectat',
        'InstallMissingMandatory' => 'Dependinţe esenţiale lipsesc. Nu veţi putea instala GCstar până când acestea nu vor fi prezente pe sistemul dumneavoastră.',
        'InstallMissingOptional' => 'Unele dependinţe opţionale lipsesc. Acestea sunt listate mai jos. GCstar poate fi instalat dar unele facilităţi ar putea să nu fie disponibile.',
        'InstallMissingNone' => 'Toate dependinţele sunt satisfăcute. Puteţi continua cu instalarea GCstar.',
        'InstallOK' => 'OK',
        'InstallMissing' => 'Lipsă',
        'InstallMissingFor' => 'Lipsă pentru',
        'InstallCleanDirectory' => 'Şterg fişierele GCstar din directorul: ',
        'InstallCopyDirectory' => 'Copiez fişierele în directorul: ',
        'InstallCopyDesktop' => 'Copiez fişierul desktop ‪în: ',

#Update
        'UpdateUseProxy' => 'Proxy-ul folosit (apăsaţi enter dacă nu e nevoie de unul): ',
        'UpdateNoPermission' => 'Nu există permsiuni pentru scriere în acest director: ',
        'UpdateNone' => 'Nici o actualizare nu a fost găsită',
        'UpdateFileNotFound' => 'Fişierul nu a fost găsit',

#Splash
        'SplashInit' => 'Iniţializare',
        'SplashLoad' => 'Încărcare colecţie',
        'SplashDisplay' => 'Afişare colecţie',
        'SplashSort' => 'Sortare colecţie',
        'SplashDone' => 'Gata',

#Import from GCfilms
        'GCfilmsImportQuestion' => 'Se pare că foloseaţi GCfilms anterior. Ce doriţi să importaţi din GCfilms în GCstar (nu va influeţa GCfilms în cazul în care încă îl mai folosiţi)?',
        'GCfilmsImportOptions' => 'Setări',
        'GCfilmsImportData' => 'Listă filme',

#Menus
        'MenuFile' => '_Fişier',
            'MenuNewList' => 'Colecţie _nouă',
            'MenuStats' => 'Statistics',
            'MenuHistory' => 'Colecţii _recente',
            'MenuLend' => 'Afişează elementele î_mprumutate', # Accepts model codes
            'MenuImport' => '_Importă',	
            'MenuExport' => '_Exportă',
            'MenuAddItem' => '_Add Items', # Accepts model codes
    
        'MenuEdit'  => '_Editare',
            'MenuDuplicate' => '_Duplică element', # Accepts model codes
            'MenuDuplicatePlural' => 'Du_plicate Items', # Accepts model codes
            'MenuEditSelectAllItems' => 'Select _All Items', # Accepts model codes
            'MenuEditDeleteCurrent' => 'Ş_terge element', # Accepts model codes
            'MenuEditDeleteCurrentPlural' => '_Remove Items', # Accepts model codes    
            'MenuEditFields' => 'S_chimbă câmpurile colecţiei',
            'MenuEditLockItems' => 'B_lochează colecţia',
    
        'MenuDisplay' => 'F_iltrare',
            'MenuSavedSearches' => 'Saved searches',
                'MenuSavedSearchesSave' => 'Save current search',
                'MenuSavedSearchesEdit' => 'Modify saved searches',
            'MenuAdvancedSearch' => 'Căutare a_vansată',
            'MenuViewAllItems' => 'Afişează to_ate elementele', # Accepts model codes
            'MenuNoFilter' => '_Oricare',

        'MenuConfiguration' => '_Setări',
            'MenuDisplayMenu' => 'Display',
                'MenuDisplayFullScreen' => 'Full screen',
                'MenuDisplayMenuBar' => 'Menus',
                'MenuDisplayToolBar' => 'Toolbar',
                'MenuDisplayStatusBar' => 'Bottom bar',
            'MenuDisplayOptions' => '_Informaţii afişate',
            'MenuBorrowers' => '_Persoane care au împrumutat',
            'MenuToolbarConfiguration' => '_Toolbar controls',
            'MenuDefaultValues' => 'Default values for new item', # Accepts model codes
            'MenuGenresConversion' => '_Conversie gen',

        'MenuBookmarks' => '_Colecţiile mele',
            'MenuBookmarksAdd' => '_Adaugă colecţia curentă',
            'MenuBookmarksEdit' => '_Editează colecţiile favorite',

        'MenuHelp' => '_Ajutor',
            'MenuHelpContent' => '_Ajutor',
            'MenuAllPlugins' => 'Arată _modulele',
            'MenuBugReport' => 'Raportează un _bug',
            'MenuAbout' => '_Despre GCstar',
    
        'MenuNewWindow' => 'Afişează elementul în fereastră _nouă', # Accepts model codes
        'MenuNewWindowPlural' => 'Show Items in _New Window', # Accepts model codes
        
        'ContextExpandAll' => 'Desfă tot',
        'ContextCollapseAll' => 'Strânge tot',
        'ContextChooseImage' => 'Choose _Image',
        'ContextOpenWith' => 'Open Wit_h',
        'ContextImageEditor' => 'Image Editor',
        'ContextImgFront' => 'Front',
        'ContextImgBack' => 'Back',
        'ContextChooseFile' => 'Choose a File',
        'ContextChooseFolder' => 'Choose a Folder',

        'DialogEnterNumber' => 'Vă rugăm introduceţi o valoare',

        'RemoveConfirm' => 'Sunteţi sigur că doriţi să ştergeţi acest element?', # Accepts model codes
        'RemoveConfirmPlural' => 'Do you really want to remove these items?', # Accepts model codes
        'DefaultNewItem' => 'Element nou', # Accepts model codes
        'NewItemTooltip' => 'Adaugă un element nou', # Accepts model codes
        'NoItemFound' => 'Nu a fost găsit nimic. Doriţi să căutaţi pe alt sit?',
        'OpenList' => 'Vă rugăm selectaţi colecţia',
        'SaveList' => 'Vă rugăm alegeţi unde să salvaţi colecţia',
        'SaveListTooltip' => 'Salvează colecţia curentă',
        'SaveUnsavedChanges' => 'Aveţi modificări nesalvate în colecţia dumneavoastră. Doriţi să le salvaţi?',
        'SaveDontSave' => 'Nu salva',
        'PreferencesTooltip' => 'Setaţi preferinţele dumneavoastră',
        'ViewTooltip' => 'Schimbă afişarea colecţiei',
        'PlayTooltip' => 'Redă fişierul video asociat acestui element', # Accepts model codes
        'PlayFileNotFound' => 'File to launch was not found in this location:',
        'PlayRetry' => 'Retry',

        'StatusSave' => 'Salvez...',
        'StatusLoad' => 'Încarc...',
        'StatusSearch' => 'Căutare în curs...',
        'StatusGetInfo' => 'Obţin informaţiile...',
        'StatusGetImage' => 'Obţin imaginea...',
                
        'SaveError' => 'Nu am putut salva lista de elemente. Vă rugăm verificaţi drepturile de acces şi spaţiul liber pe disc.',
        'OpenError' => 'Nu am putut deschide lista de elemente. Vă rugăm verificaţi drepturile de acces.',
        'OpenFormatError' => 'Nu am putut deschide lista de elemente.',
        'OpenVersionWarning' => 'Collection was created with a more recent version of GCstar. If you save it, you may loose some data.',
        'OpenVersionQuestion' => 'Do you still want to continue?',
        'ImageError' => 'Directorul selectat pentru a salva imaginile nu este corect. Vă rugăm selectaţi alt director.',
        'OptionsCreationError'=> 'Nu pot crea fişierul de opţiuni: ',
        'OptionsOpenError'=> 'Nu pot deschide fişierul de opţiuni: ',
        'OptionsSaveError'=> 'Nu pot salva fişierul de opţiuni: ',
        'ErrorModelNotFound' => 'Model not found: ',
        'ErrorModelUserDir' => 'User defined models are in: ',
        
        'RandomTooltip' => 'Ce să vedem în acestă seară?',
        'RandomError'=> 'Nu aveţi nici un element care să poate fi selectat', # Accepts model codes
        'RandomEnd'=> 'Nu mai sunt alte elemente', # Accepts model codes
        'RandomNextTip'=> 'Următoarea sugestie',
        'RandomOkTip'=> 'Acceptă acest element',
        
        'AboutTitle' => 'Despre GCstar',
        'AboutDesc' => 'Manager de colecţii',
        'AboutVersion' => 'Versiune',
        'AboutTeam' => 'Echipa',
        'AboutWho' => 'Christian Jodar (Tian): Manager de proiect, programator
Nyall Dawson (Zombiepig) : Programator
TPF : Programator
Adolfo González : Programator
',
        'AboutLicense' => 'Distribuit în termenii licenţei GNU GPL
Copyright logo le Spektre',
        'AboutTranslation' => 'Traducerea în română de către Mugurel Tudor',
        'AboutDesign' => 'Łukasz Kowalczk (Qoolman): Skin Designer
Logo şi design web de către le Spektre',

        'ToolbarRandom' => 'În seara asta',
        
        'UnsavedCollection' => 'Unsaved Collection',
        'ModelsSelect' => 'Selectaţi un tip de colecţie',
        'ModelsPersonal' => 'Modele personale',
        'ModelsDefault' => 'Modele implicite',
        'ModelsList' => 'Definire colecţie',
        'ModelSettings' => 'Setări colecţie',
        'ModelNewType' => 'Nou tip de colecţie',
        'ModelName' => 'Numele tipului de colecţie:',
		'ModelFields' => 'Câmpuri',
		'ModelOptions'	=> 'Opţiuni',
		'ModelFilters'	=> 'Filtre',
        'ModelNewField' => 'Câmp nou',
        'ModelFieldInformation' => 'Informaţii',
        'ModelFieldName' => 'Etichetă:',
        'ModelFieldType' => 'Tip:',
        'ModelFieldGroup' => 'Grup:',
        'ModelFieldValues' => 'Valori',
        'ModelFieldInit' => 'Implicit:',
        'ModelFieldMin' => 'Minim:',
        'ModelFieldMax' => 'Maxim:',
        'ModelFieldList' => 'Listă valori:',
        'ModelFieldListLegend' => '<i>Separare prin virgulă</i>',
        'ModelFieldDisplayAs' => 'Display as:',
        'ModelFieldDisplayAsText' => 'Text',
        'ModelFieldDisplayAsGraphical' => 'Rating Control',
        'ModelFieldTypeShortText' => 'Text scurt',
        'ModelFieldTypeLongText' => 'Text lung',
        'ModelFieldTypeYesNo' => 'Da/Nu',
        'ModelFieldTypeNumber' => 'Număr',
        'ModelFieldTypeDate' => 'Dată',
        'ModelFieldTypeOptions' => 'Listă predefinită de valori',
        'ModelFieldTypeImage' => 'Imagine',
        'ModelFieldTypeSingleList' => 'Listă simplă',
        'ModelFieldTypeFile' => 'Fişier',
        'ModelFieldTypeFormatted' => 'Depinde de alte câmpuri',
        'ModelFieldParameters' => 'Parametri',
        'ModelFieldHasHistory' => 'Foloseşte un istoric',
        'ModelFieldFlat' => 'Afişare pe o linie',
        'ModelFieldStep' => 'Pas de incrementare:',
        'ModelFieldFileFormat' => 'Format fişier:',
        'ModelFieldFileFile' => 'Fişier simplu',
        'ModelFieldFileImage' => 'Imagine',
        'ModelFieldFileVideo' => 'Video',
        'ModelFieldFileAudio' => 'Audio',
        'ModelFieldFileProgram' => 'Program',
        'ModelFieldFileUrl' => 'URL',
        'ModelFieldFileEbook' => 'Ebook',
        'ModelOptionsFields' => 'Câmpuri folosite',
        'ModelOptionsFieldsAuto' => 'Automat',
        'ModelOptionsFieldsNone' => 'Nici unul',
        'ModelOptionsFieldsTitle' => 'Ca titlu',
        'ModelOptionsFieldsId' => 'Ca identificator',
        'ModelOptionsFieldsCover' => 'Ca şi copertă',
        'ModelOptionsFieldsPlay' => 'Pentru butonul de redare',
        'ModelCollectionSettings' => 'Setări colecţie',
        'ModelCollectionSettingsLending' => 'Elementele pot fi împrumutate',
        'ModelCollectionSettingsTagging' => 'Items can be tagged',
        'ModelFilterActivated' => 'Ar trebui să apară în fereastra de căutare',
        'ModelFilterComparison' => 'Comparaţie',
        'ModelFilterContain' => 'Conţine',
        'ModelFilterDoesNotContain' => 'Does not contain',
        'ModelFilterRegexp' => 'Regular expression',
        'ModelFilterRange' => 'Domeniu',
        'ModelFilterNumeric' => 'Comparaţia e numerică',
        'ModelFilterQuick' => 'Creaţi un filtru rapid',
        'ModelTooltipName' => 'Folosiţi un nume pentru a reutiliza acest model pentru mai multe colecţii. Dacă este gol, setările vor fi stocate direct în colecţie',
        'ModelTooltipLabel' => 'Numele câmpului aşa cum va fi afişat',
        'ModelTooltipGroup' => 'Folosit pentru a grupa câmpurile. Elementele care nu au o valoare aici vor fi într-un grup implicit',
        'ModelTooltipHistory' => 'Dacă elementele introduse anterior vor fi stocate într-o listă asociată acestui câmp',
        'ModelTooltipFormat' => 'Acest format este folosit pentru a determina acţiunea de a deschide un fişier cu butonul de Redare',
        'ModelTooltipLending' => 'Aceasta va adăuga unele câmpuri pentru a gestiona împrumuturile',
        'ModelTooltipTagging' => 'This will add some fields to manage tags',
        'ModelTooltipNumeric' => 'Dacă valorile trebuie considerate ca numere în comparaţii',
        'ModelTooltipQuick' => 'Aceasta va adăuga un submeniu la Filtre',

        'ResultsTitle' => 'Selectaţi un element', # Accepts model codes
        'ResultsNextTip' => 'Caută pe următorul sit',
        'ResultsPreview' => 'Previzualizare',
        'ResultsInfo' => 'You can add multiple items to the collection by holding down the Ctrl or the Shift key and selecting them', # Accepts model codes
        
        'OptionsTitle' => 'Preferinţe',
		'OptionsExpertMode' => 'Expert Mode',
        'OptionsPrograms' => 'Specify applications to use for different media, leave blank to use system defaults',
        'OptionsBrowser' => 'Navigator web',
        'OptionsPlayer' => 'Player video',
        'OptionsAudio' => 'Player audio',
        'OptionsImageEditor' => 'Image editor',
        'OptionsCdDevice' => 'CD device',
        'OptionsImages' => 'Director de imagini',
        'OptionsUseRelativePaths' => 'Foloseşte căi relative pentru imagini',
        'OptionsLayout' => 'Layout',
        'OptionsStatus' => 'Afişează bara de status',
        'OptionsUseStars' => 'Use stars to display ratings',
        'OptionsWarning' => 'Atenţie: Modificările din acest tab nu vor avea efect decât după repornirea aplicaţiei.',
        'OptionsRemoveConfirm' => 'Cere o confirmare înainte de ştergerea elementului',
        'OptionsAutoSave' => 'Salvează colecţia automat',
        'OptionsAutoLoad' => 'Încarcă colecţia anterioară la pornire',
        'OptionsSplash' => 'Afişează ecranul de pornire',
        'OptionsTearoffMenus' => 'Enable tear-off menus',
        'OptionsSpellCheck' => 'Use spelling checker for long text fields',
        'OptionsProgramTitle' => 'Selectaţi programul ce va fi folosit',
		'OptionsPlugins' => 'Situl de la care se vor obţine informaţiile',
		'OptionsAskPlugins' => 'Întreabă (toate siturile)',
		'OptionsPluginsMulti' => 'Multe situri',
		'OptionsPluginsMultiAsk' => 'Întreabă (multe situri)',
        'OptionsPluginsMultiPerField' => 'Multe situri (per field)',
        'OptionsPluginsMultiPerFieldWindowTitle' => 'Many sites per field order selection',
        'OptionsPluginsMultiPerFieldDesc' => 'For each selected field we will return the first non empty information beginning from left',
        'OptionsPluginsMultiPerFieldFirst' => 'First',
        'OptionsPluginsMultiPerFieldLast' => 'Last',
        'OptionsPluginsMultiPerFieldRemove' => 'Remove',
        'OptionsPluginsMultiPerFieldClearSelected' => 'Empty selected field list',
		'OptionsPluginsList' => 'Setează lista',
        'OptionsAskImport' => 'Selectează câmpurile ce vor fi importate',
		'OptionsProxy' => 'Foloseşte un proxy',
		'OptionsCookieJar' => 'Foloseşte acest fişier cookie',
        'OptionsLang' => 'Limbă',
        'OptionsMain' => 'Principal',
        'OptionsPaths' => 'Căi',
        'OptionsInternet' => 'Internet',
        'OptionsConveniences' => 'Facilităţi',
        'OptionsDisplay' => 'Afişare',
        'OptionsToolbar' => 'Bară de unelte',
        'OptionsToolbars' => {0 => 'Fără', 1 => 'Mică', 2 => 'Mare', 3 => 'Setări sistem'},
        'OptionsToolbarPosition' => 'Poziţie',
        'OptionsToolbarPositions' => {0 => 'Sus', 1 => 'Jos', 2 => 'Stânga', 3 => 'Dreapta'},
        'OptionsExpandersMode' => 'Desfăsurători prea lungi',
        'OptionsExpandersModes' => {'asis' => 'Ignoră', 'cut' => 'Taie', 'wrap' => 'Rupe linia'},
        'OptionsDateFormat' => 'Format dată',
        'OptionsDateFormatTooltip' => 'Formatul este cel folosit de strftime(3). Implicit este %d/%m/%Y.',
        'OptionsView' => 'Afişare',
        'OptionsViews' => {0 => 'Text', 1 => 'Imagine', 2 => 'Detalii'},
        'OptionsColumns' => 'Coloane',
        'OptionsMailer' => 'Trimitere email',
        'OptionsSMTP' => 'Server',
        'OptionsFrom' => 'Email-ul dumneavoastră',
        'OptionsTransform' => 'Plasează articolele la sfârşitul titlurilor',
        'OptionsArticles' => 'Articole (separate prin virgulă)',
        'OptionsSearchStop' => 'Permite întreruperea căutărilor',
        'OptionsBigPics' => 'Use big pictures when available',
        'OptionsAlwaysOriginal' => 'Foloseşte titlul principal ca titlu original în cazul în care acesta nu este prezent',
        'OptionsRestoreAccelerators' => 'Restore accelerators',
        'OptionsHistory' => 'Mărime istoric',
        'OptionsClearHistory' => 'Şterge istoricul',
		'OptionsStyle' => 'Temă',
        'OptionsDontAsk' => 'Nu mai întreba din nou',
        'OptionsPathProgramsGroup' => 'Aplicaţii',
        'OptionsProgramsSystem' => 'Foloseşte programele definite de sistem',
        'OptionsProgramsUser' => 'Foloseşte programele specificate',
        'OptionsProgramsSet' => 'Setare programe',
        'OptionsPathImagesGroup' => 'Imagini',
        'OptionsInternetDataGroup' => 'Importare date',
        'OptionsInternetSettingsGroup' => 'Setări',
        'OptionsDisplayInformationGroup' => 'Afişare informaţii',
        'OptionsDisplayArticlesGroup' => 'Articole',
        'OptionsImagesDisplayGroup' => 'Afişare',
        'OptionsImagesStyleGroup' => 'Stil',
        'OptionsDetailedPreferencesGroup' => 'Preferinţe',
        'OptionsFeaturesConveniencesGroup' => 'Convenţii',
        'OptionsPicturesFormat' => 'Prefix folosit pentru imagini:',
        'OptionsPicturesFormatInternal' => 'gcstar__',
        'OptionsPicturesFormatTitle' => 'Titlul sau numele elementului asociat',
        'OptionsPicturesWorkingDir' => '%WORKING_DIR% sau . va fi înlocuit cu directorul colecţiei (folosiţi doar pentru începutul căilor)',
        'OptionsPicturesFileBase' => '%FILE_BASE% va fi înlocuit de numele fişierului de colecţie fără sufix (.gcs)',
        'OptionsPicturesWorkingDirError' => '%WORKING_DIR% poate fi folosit doar la începutul căii pentru imagini',
        'OptionsConfigureMailers' => 'Configurează aplicaţiile pentru mail',

        'ImagesOptionsButton' => 'Setări',
        'ImagesOptionsTitle' => 'Setări pentru lista de imagini',
        'ImagesOptionsSelectColor' => 'Selectaţi o culoare',
        'ImagesOptionsUseOverlays' => 'Use image overlays',
        'ImagesOptionsBg' => 'Fundal',
        'ImagesOptionsBgPicture' => 'Foloseşte o imagine de fundal',
        'ImagesOptionsFg'=> 'Selecţie',
        'ImagesOptionsBgTooltip' => 'Schimbă culoarea pentru fundal',
        'ImagesOptionsFgTooltip'=> 'Schimbă culoarea pentru selecţie',
        'ImagesOptionsResizeImgList' => 'Automatically change number of columns',
        'ImagesOptionsAnimateImgList' => 'Use animations',
        'ImagesOptionsSizeLabel' => 'Mărime',
        'ImagesOptionsSizeList' => {0 => 'Foarte mică', 1 => 'Mică', 2 => 'Medie', 3 => 'Mare', 4 => 'Foarte mare'},
        'ImagesOptionsSizeTooltip' => 'Selectaţi mărimea imaginii',
		        
        'DetailedOptionsTitle' => 'Setări pentru lista detaliată',
        'DetailedOptionsImageSize' => 'Mărime imagini',
        'DetailedOptionsGroupItems' => 'Grupează elementele după',
        'DetailedOptionsSecondarySort' => 'Sort field for children',
		'DetailedOptionsFields' => 'Selectează câmpurile afişate',
        'DetailedOptionsGroupedFirst' => 'Păstrează împreună elementele orfane',
        'DetailedOptionsAddCount' => 'Adaugă numărul elementelor la categorii',

        'ExtractButton' => 'Informaţii',
        'ExtractTitle' => 'Informaţii fişier video',
        'ExtractImport' => 'Foloseşte valorile',

        'FieldsListOpen' => 'Încarcă o listă de câmpuri dintr-un fişier',
        'FieldsListSave' => 'Salvează lista de câmpuri într-un fişier',
        'FieldsListError' => 'Această listă de fişiere nu poate fi folosită cu acest tip de colecţie',
        'FieldsListIgnore' => '--- Ignore',

        'ExportTitle' => 'Exportă lista de elemente',
        'ExportFilter' => 'Exportă doar elementele afişate',
        'ExportFieldsTitle' => 'Câmpurile ce vor fi exportate',
        'ExportFieldsTip' => 'Selectaţi câmpurile pe care doriţi să le exportaţi',
        'ExportWithPictures' => 'Copiază imaginile într-un subdirector',
        'ExportSortBy' => 'Sortare după',
        'ExportOrder' => 'Order',

        'ImportListTitle' => 'Importă altă listă de elemente',
        'ImportExportData' => 'Data',
        'ImportExportFile' => 'Fişier',
        'ImportExportFieldsUnused' => 'Câmpuri nefolosite',
        'ImportExportFieldsUsed' => 'Câmpuri folosite',
        'ImportExportFieldsFill' => 'Adaugă toate',
        'ImportExportFieldsClear' => 'Şterge toate',
        'ImportExportFieldsEmpty' => 'Trebuie să alegeţi cel puţin un câmp',
        'ImportExportFileEmpty' => 'Trebuie să specificaţi un nume de fişier',
        'ImportFieldsTitle' => 'Câmpurile ce vor fi importate',
        'ImportFieldsTip' => 'Selectaţi câmpurile pe care le doriţi importate',
        'ImportNewList' => 'Creează o nouă colecţie',
        'ImportCurrentList' => 'Adaugă la colecţia curentă',
        'ImportDropError' => 'A intervenit o eroare la deschiderea a cel puţin unui fişier. Listă precedentă va fi reîncărcată.',
        'ImportGenerateId' => 'Generează identificator pentru fiecare element',

        'FileChooserOpenFile' => 'Vă rugăm selectaţi fişierul pentru folosire',
        'FileChooserDirectory' => 'Directory',
        'FileChooserOpenDirectory' => 'Selectaţi un director',
        'FileChooserOverwrite' => 'Acest fişier deja există. Doriţi să îl suprascrieţi?',
        'FileAllFiles' => 'All Files',
        'FileVideoFiles' => 'Video Files',
        'FileEbookFiles' => 'Ebook Files',
        'FileAudioFiles' => 'Audio Files',
        'FileGCstarFiles' => 'GCstar Collections',

        'PanelCompact' => 'Compact',
        'PanelReadOnly' => 'Doar pentru citire',
        'PanelForm' => 'Taburi',

        'PanelSearchButton' => 'Obţine informaţii',
        'PanelSearchTip' => 'Caută pe web informaţii despre acest titlu',
        'PanelSearchContextChooseOne' => 'Choose a site ...',
        'PanelSearchContextMultiSite' => 'Use "Many sites"',
        'PanelSearchContextMultiSitePerField' => 'Use "Many sites per field"',
        'PanelSearchContextOptions' => 'Change options ...',
        'PanelImageTipOpen' => 'Clic pe imagine pentru a selecta alta.',
        'PanelImageTipView' => 'Clic pe image pentru a o vedea la dimensiunea originală.',
        'PanelImageTipMenu' => ' Clic dreapta pentru mai multe opţiuni.',
        'PanelImageTitle' => 'Selectaţi o imagine',
        'PanelImageNoImage' => 'Nici o imagine',
        'PanelSelectFileTitle' => 'Selectaţi un fişier',
        'PanelLaunch' => 'Launch',        
        'PanelRestoreDefault' => 'Restaurează valorile implicite',
        'PanelRefresh' => 'Update',
        'PanelRefreshTip' => 'Update information from web',

        'PanelFrom' =>'De la',
        'PanelTo' =>'Către',

        'PanelWeb' => 'Mai multe informaţii',
        'PanelWebTip' => 'Afişează informaţii de pe web despre acest element', # Accepts model codes
        'PanelRemoveTip' => 'Şterge elementul curent', # Accepts model codes

        'PanelDateSelect' => 'Selectaţi o dată',
        'PanelNobody' => 'Nimeni',
        'PanelUnknown' => 'Necunoscut',
        'PanelAdded' => 'Adaugă dată',
        'PanelRating' => 'Evaluare',
        'PanelPressRating' => 'Press Rating',
        'PanelLocation' => 'Locaţie',

        'PanelLending' => 'Împrumuturi',
        'PanelBorrower' => 'Împrumutat',
        'PanelLendDate' => 'Din data',
        'PanelHistory' => 'Istoric împrumuturi',
        'PanelReturned' => 'Element returnat', # Accepts model codes
        'PanelReturnDate' => 'Data returnării',
        'PanelLendedYes' => 'Împrumutat',
        'PanelLendedNo' => 'Disponibil',

        'PanelTags' => 'Tags',
        'PanelFavourite' => 'Favourite',
        'TagsAssigned' => 'Assigned Tags', 

        'PanelUser' => 'User fields',

        'CheckUndef' => 'Nu contează',
        'CheckYes' => 'Da',
        'CheckNo' => 'Nu',

        'ToolbarAll' => 'Afişează tot',
        'ToolbarAllTooltip' => 'Afişează toate elementele',
        'ToolbarGroupBy' => 'Grupează după',
        'ToolbarGroupByTooltip' => 'Selectaţi câmpul folosit pentru a grupa elementele din listă',
        'ToolbarQuickSearch' => 'Quick search',
        'ToolbarQuickSearchLabel' => 'Search',
        'ToolbarQuickSearchTooltip' => 'Select the field to search in. Enter the search terms and press Enter',
        'ToolbarSeparator' => ' Separator',
        
        'PluginsTitle' => 'Cautare elemente',
        'PluginsQuery' => 'Interogare',
        'PluginsFrame' => 'Sit pentru căutare',
        'PluginsLogo' => 'Logo',
        'PluginsName' => 'Nume',
        'PluginsSearchFields' => 'Câmpuri căutate',
        'PluginsAuthor' => 'Autor',
        'PluginsLang' => 'Limbă',
        'PluginsUseSite' => 'Foloseşte situl selectat pentru viitoarele căutări',
        'PluginsPreferredTooltip' => 'Site recommended by GCstar',
        'PluginDisabled' => 'Disabled',

        'BorrowersTitle' => 'Configurare împrumuturi',
        'BorrowersList' => 'Persoane care au împrumutat',
        'BorrowersName' => 'Nume',
        'BorrowersEmail' => 'E-mail',
        'BorrowersAdd' => 'Adaugă',
        'BorrowersRemove' => 'Şterge',
        'BorrowersEdit' => 'Editează',
        'BorrowersTemplate' => 'Şablon mail',
        'BorrowersSubject' => 'Subiect mail',
        'BorrowersNotice1' => '%1 va fi înlocuit cu numele celui care a împrumutat',
        'BorrowersNotice2' => '%2 va fi înlocuit cu numele filmului',
        'BorrowersNotice3' => '%3 va fi înlocuit cu data împrumutului',

        'BorrowersImportTitle' => 'Importă informaţiile despre cel care a împrumutat',
        'BorrowersImportType' => 'Format fişier:',
        'BorrowersImportFile' => 'Fişier:',

        'BorrowedTitle' => 'Elemente împrumutate', # Accepts model codes
        'BorrowedDate' => 'Din data de',
        'BorrowedDisplayInPanel' => 'Show item in main window', # Accepts model codes

        'MailTitle' => 'Trimite un email',
        'MailFrom' => 'De la: ',
        'MailTo' => 'Către: ',
        'MailSubject' => 'Subiect: ',
        'MailSmtpError' => 'Problemă la conectarea la serverul SMTP',
        'MailSendmailError' => 'Problemă la lansarea sendmail',

        'SearchTooltip' => 'Caută toate elementele', # Accepts model codes
        'SearchTitle' => 'Căutare element', # Accepts model codes
        'SearchNoField' => 'No field have been selected for the search box.
Add some of them in the Filters tab of the collection settings.',

        'QueryReplaceField' => 'Câmp pentru înlocuire',
        'QueryReplaceOld' => 'Numele actual',
        'QueryReplaceNew' => 'Noul nume',
        'QueryReplaceLaunch' => 'Înlocuieşte',
        
        'ImportWindowTitle' => 'Selectaţi câmpurile pentru import',
        'ImportViewPicture' => 'Afişează imaginea',
        'ImportSelectAll' => 'Selectează tot',
        'ImportSelectNone' => 'Nu selecta nimic',

        'MultiSiteTitle' => 'Siturile folosite pentru căutări',
        'MultiSiteUnused' => 'Module nefolosite',
        'MultiSiteUsed' => 'Module ce vor fi folosite',
        'MultiSiteLang' => 'Umple lista cu module pentru limba engleză',
        'MultiSiteEmptyError' => 'Lista de situri este goală',
        'MultiSiteClear' => 'Şterge lista',

        'DisplayOptionsTitle' => 'Elemente afişate',
        'DisplayOptionsAll' => 'Selectează tot',
        'DisplayOptionsSearch' => 'Buton căutare',

        'GenresTitle' => 'Conversie gen',
        'GenresCategoryName' => 'Genul de folosit',
        'GenresCategoryMembers' => 'Genul de înlocuit',
        'GenresLoad' => 'Încarcă o listă',
        'GenresExport' => 'Salvează lista într-un fişier',
        'GenresModify' => 'Editează conversia',

        'PropertiesName' => 'Nume colecţie',
        'PropertiesLang' => 'Language code',
        'PropertiesOwner' => 'Proprietar',
        'PropertiesEmail' => 'Email',
        'PropertiesDescription' => 'Descriere',
        'PropertiesFile' => 'Informaţii fişier',
        'PropertiesFilePath' => 'Cale completă',
        'PropertiesItemsNumber' => 'Număr de elemente', # Accepts model codes
        'PropertiesFileSize' => 'Mărime',
        'PropertiesFileSizeSymbols' => ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
        'PropertiesCollection' => 'Proprietăţi colecţie',
        'PropertiesDefaultPicture' => 'Default picture',

        'MailProgramsTitle' => 'Programe pentru trimis mailuri',
        'MailProgramsName' => 'Nume',
        'MailProgramsCommand' => 'Linie de comandă',
        'MailProgramsRestore' => 'Restaurează valorile implicite',
        'MailProgramsAdd' => 'Adaugă un progra,',
        'MailProgramsInstructions' => 'În linia de comandă, unele înlocuiri sunt făcute:
 %f este înlocuit cu adresa de mail a utilizatorului.
 %t este înlocuit cu adresa de mail a destinatarului.
 %s este înlocuit cu subiectul mesajului.
 %b este înlocuit cu corpul mesajului.',

        'BookmarksBookmarks' => 'Favorite',
        'BookmarksFolder' => 'Director',
        'BookmarksLabel' => 'Etichetă',
        'BookmarksPath' => 'Cale',
        'BookmarksNewFolder' => 'Dosar nou',

        'AdvancedSearchType' => 'Tipul de căutare',
        'AdvancedSearchTypeAnd' => 'Elemente se potrivesc la toate criteriile', # Accepts model codes
        'AdvancedSearchTypeOr' => 'Elementele se potrivesc la cel puţin un criteriu', # Accepts model codes
        'AdvancedSearchCriteria' => 'Criteriu',
        'AdvancedSearchAnyField' => 'Orice câmp',
        'AdvancedSearchSaveTitle' => 'Save search',
        'AdvancedSearchSaveName' => 'Name',
        'AdvancedSearchSaveOverwrite' => 'A saved search already exists with that name. Please use a different one.',
        'AdvancedSearchUseCase' => 'Case sensitive',
        'AdvancedSearchIgnoreDiacritics' => 'Ignore accents and other diacritics',

        'BugReportSubject' => 'Raportare bug generată de GCstar',
        'BugReportVersion' => 'Versiune',
        'BugReportPlatform' => 'Sistem de operare',
        'BugReportMessage' => 'Mesaj de eroare',
        'BugReportInformation' => 'Informaţii adiţionale',

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
