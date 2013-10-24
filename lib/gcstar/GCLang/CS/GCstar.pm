{
    package GCLang::CS;

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

        'LangName' => 'Czech',
        
        'Separator' => ': ',
        
        'Warning' => '<b>Varování</b>:
        
Informace získané ze serverů (vyhledávacím pluginem) 
jsou pouze pro <b>osobní použití</b>.

Jakákoliv redistribuce je zakázána bez <b>přímého souhlasu</b> serverů.

K rozlišení, který server vlastní dané informace, můžete použít
<b>tlačítko pod detaily každé položky</b>.',
        
        'AllItemsFiltered' => 'Žádný záznam pro Vaše zadání', # Accepts model codes
        
#Installation
        'InstallDirInfo' => 'Instaluji do ',
        'InstallMandatory' => 'Povinné součásti',
        'InstallOptional' => 'Volitelné součásti',
        'InstallErrorMissing' => 'Chyba: Musí být nainstalovány následující komponenty Perlu: ',
        'InstallPrompt' => 'Základní adresář pro instalaci [/usr/local]: ',
        'InstallEnd' => 'Konec instalace',
        'InstallNoError' => 'Bez chyb',
        'InstallLaunch' => 'Před použitím aplikace musíte spustit ',
        'InstallDirectory' => 'Základní adresář',
        'InstallTitle' => 'Instalace GCstar',
        'InstallDependencies' => 'Závislosti',
        'InstallPath' => 'Cesta',
        'InstallOptions' => 'Volby',
        'InstallSelectDirectory' => 'Vyberte adresář pro instalaci',
        'InstallWithClean' => 'Odstraňte soubory z adresáře pro instalaci',
        'InstallWithMenu' => 'Přidat GCstar do menu Aplikace',
        'InstallNoPermission' => 'Chyba: Nemáte oprávnění k zápisu do zvoleného adresáře',
        'InstallMissingMandatory' => 'Povinné závislosti chybí. Instalace GCstar není možná, dokud nebudou přidány do systému.',
        'InstallMissingOptional' => 'Několik volitelných součástí chybí. Jejich seznam je níže. GCstar může být nainstalován, ale některé vlastnosti nebudou dostupné.',
        'InstallMissingNone' => 'Všechny potřebné součásti jsou nainstalovány. Instalace může pokračovat.',
        'InstallOK' => 'OK',
        'InstallMissing' => 'Chybí',
        'InstallMissingFor' => 'Chybí',
        'InstallCleanDirectory' => 'Odstraňování souborů programu GCstar v adresáři: ',
        'InstallCopyDirectory' => 'Kopírování souborů do adresáře: ',
        'InstallCopyDesktop' => 'Kopírování souboru pracovní plochy do: ',		#Copying desktop file in

#Update
        'UpdateUseProxy' => 'Použít Proxy (pokud není potřeba, stiskni enter): ',
        'UpdateNoPermission' => 'Nemáte právo zápisu v tomto adresáři: ',
        'UpdateNone' => 'Update není k dispozici',
        'UpdateFileNotFound' => 'Soubor nenalezen',

#Splash
        'SplashInit' => 'Inicializace',
        'SplashLoad' => 'Nahrávám sbírku',
        'SplashDisplay' => 'Zobrazuji sbírku',
        'SplashSort' => 'Řadím sbírku',
        'SplashDone' => 'Hotovo',

#Import from GCfilms
        'GCfilmsImportQuestion' => 'Zdá se, že jste dříve používal(a) GCfilms. Co chcete importovat z GCfilms do GCstar (nebude to mít vliv na GCfilms pokud jej nadále budete chtít používat)?',
        'GCfilmsImportOptions' => 'Nastavení',
        'GCfilmsImportData' => 'Seznam filmů',

#Menus
        'MenuFile' => '_Soubor',
            'MenuNewList' => '_Nová sbírka',
            'MenuStats' => 'Statistics',
            'MenuHistory' => 'N_edávné sbírky',
            'MenuLend' => 'Zobraz _půjčené položky', # Accepts model codes
            'MenuImport' => '_Import',	
            'MenuExport' => '_Export',
            'MenuAddItem' => '_Add Items', # Accepts model codes
    
        'MenuEdit'  => '_Úpravy',
            'MenuDuplicate' => '_Duplikuj položku', # Accepts model codes
            'MenuDuplicatePlural' => 'Du_plicate Items', # Accepts model codes
            'MenuEditSelectAllItems' => 'Select _All Items', # Accepts model codes
            'MenuEditDeleteCurrent' => '_Vymaž položku', # Accepts model codes
            'MenuEditDeleteCurrentPlural' => '_Remove Items', # Accepts model codes   
            'MenuEditFields' => '_Změň pole sbírky',			# Change collection fields
            'MenuEditLockItems' => '_Uzamkni sbírku',
    
        'MenuDisplay' => '_Filtr',
            'MenuSavedSearches' => 'Saved searches',
                'MenuSavedSearchesSave' => 'Save current search',
                'MenuSavedSearchesEdit' => 'Modify saved searches',
            'MenuAdvancedSearch' => '_Pokročilé vyhledávání',
            'MenuViewAllItems' => 'Zobrazit _všechny položky', # Accepts model codes
            'MenuNoFilter' => '_Vše',
    
        'MenuConfiguration' => '_Nastavení',
            'MenuDisplayMenu' => 'Display',
                'MenuDisplayFullScreen' => 'Full screen',
                'MenuDisplayMenuBar' => 'Menus',
                'MenuDisplayToolBar' => 'Toolbar',
                'MenuDisplayStatusBar' => 'Bottom bar',
            'MenuDisplayOptions' => '_Zobrazené informace',
            'MenuBorrowers' => '_Dlužníci',
            'MenuToolbarConfiguration' => '_Toolbar controls',
            'MenuDefaultValues' => 'Default values for new item', # Accepts model codes
            'MenuGenresConversion' => '_Konverze žánru',
        
        'MenuBookmarks' => 'Mé _Sbíky',
            'MenuBookmarksAdd' => '_Přidat aktuální sbírku',
            'MenuBookmarksEdit' => '_Editovat založené sbírky',	# Edit bookmarked collections

        'MenuHelp' => '_Nápověda',
            'MenuHelpContent' => '_Nápověda',
            'MenuAllPlugins' => 'Zobrazit _pluginy',
            'MenuBugReport' => 'Nahlásit _chybu',
            'MenuAbout' => '_O aplikaci GCstar',
    
        'MenuNewWindow' => 'Zobrazit položky v _novém okně', # Accepts model codes
        'MenuNewWindowPlural' => 'Show Items in _New Window', # Accepts model codes
        
        'ContextExpandAll' => 'Zobraz vše',
        'ContextCollapseAll' => 'Skryj vše',
        'ContextChooseImage' => 'Choose _Image',
        'ContextOpenWith' => 'Open Wit_h',
        'ContextImageEditor' => 'Image Editor',
        'ContextImgFront' => 'Front',
        'ContextImgBack' => 'Back',
        'ContextChooseFile' => 'Choose a File',
        'ContextChooseFolder' => 'Choose a Folder',

        'DialogEnterNumber' => 'Prosím zadej hodnotu',

        'RemoveConfirm' => 'Opravdu chcete vymazat tuto položku?', # Accepts model codes
        'RemoveConfirmPlural' => 'Do you really want to remove these items?', # Accepts model codes

        'DefaultNewItem' => 'Nová položka', # Accepts model codes
        'NewItemTooltip' => 'Přidat novou položku', # Accepts model codes
        'NoItemFound' => 'Položka nebyla nalezena. Chcete ji zkusit najít na jiném serveru?',
        'OpenList' => 'Prosím vyberte sbírku',
        'SaveList' => 'Prosím vyberte, kam uložit sbírku',
        'SaveListTooltip' => 'Uložit současnou sbírku',
        'SaveUnsavedChanges' => 'Ve sbírce jste provedli změny. Chcete je nyní uložit?',
        'SaveDontSave' => 'Neukládat',
        'PreferencesTooltip' => 'Umožňuje změnu nastavení',
        'ViewTooltip' => 'Změní zobrazení sbírky',
        'PlayTooltip' => 'Přehraje video asociované filmem', # Accepts model codes
        'PlayFileNotFound' => 'File to launch was not found in this location:',
        'PlayRetry' => 'Retry',

        'StatusSave' => 'Ukládám...',
        'StatusLoad' => 'Nahrávám...',
        'StatusSearch' => 'Hledám...',
        'StatusGetInfo' => 'Stahuji informace...',
        'StatusGetImage' => 'Stahuji obrázek...',
                
        'SaveError' => 'Nemohu uložit seznam. Prosím zkontrolujte přístupová práva a volné místo na disku.',
        'OpenError' => 'Nemohu otevřít seznam. Prosím zkontrolujte přístupová práva.',
        'OpenFormatError' => 'Nemohu otevřít seznam.',
        'OpenVersionWarning' => 'Collection was created with a more recent version of GCstar. If you save it, you may loose some data.',
        'OpenVersionQuestion' => 'Do you still want to continue?',
        'ImageError' => 'Adresář vybraný k ukládání obrázků není správný. Prosím vyberte jiný.',
        'OptionsCreationError'=> 'Nemohu vytvořit soubor s nastavením: ',
        'OptionsOpenError'=> 'Nemohu otevřít soubor s nastavením: ',
        'OptionsSaveError'=> 'Nemohu uložit soubor s nastavením: ',
        'ErrorModelNotFound' => 'Model not found: ',
        'ErrorModelUserDir' => 'User defined models are in: ',
        
        'RandomTooltip' => 'Co budu dělat dnes večer?',
        'RandomError'=> 'Nic nemáte', # Accepts model codes
        'RandomEnd'=> 'Nic dalšího nemáte', # Accepts model codes
        'RandomNextTip'=> 'Další tip',
        'RandomOkTip'=> 'Přijmout tento tip',
        
        'AboutTitle' => 'O aplikaci GCstar',
        'AboutDesc' => 'Katalog sbírek',
        'AboutVersion' => 'Verze',
        'AboutTeam' => 'Tým',
        'AboutWho' => 'Christian Jodar (Tian): Project manager, Programmer
Nyall Dawson (Zombiepig): Programmer
TPF: Programmer
Adolfo González: Programmer
',
        'AboutLicense' => 'Distribuováno za podmínek GNU GPL
Logos Copyright le Spektre',
        'AboutTranslation' => 'Český překlad připravil Tomáš Klimek (Tomas.Klimek@gmail.com)',
        'AboutDesign' => 'Łukasz Kowalczk (Qoolman): Skin Designer
Logo a webdesign od le Spektre',

        'ToolbarRandom' => 'Dnes večer',
        
        'UnsavedCollection' => 'Unsaved Collection',
        'ModelsSelect' => 'Vyber typ sbírky',
        'ModelsPersonal' => 'Vlastní šablony',
        'ModelsDefault' => 'Standardní šablony',
        'ModelsList' => 'Typy sbírek',
        'ModelSettings' => 'Nastavení sbírek',
        'ModelNewType' => 'Nový typ sbírky',
        'ModelName' => 'Název nového typu sbírky:',
		'ModelFields' => 'Pole',
		'ModelOptions'	=> 'Nastavení',
		'ModelFilters'	=> 'Filtry',
        'ModelNewField' => 'Nové pole',
        'ModelFieldInformation' => 'Informace',
        'ModelFieldName' => 'Štítek:',
        'ModelFieldType' => 'Typ:',
        'ModelFieldGroup' => 'Skupina:',
        'ModelFieldValues' => 'Hodnoty',
        'ModelFieldInit' => 'Implicitní:',
        'ModelFieldMin' => 'Minimální:',
        'ModelFieldMax' => 'Maximální:',
        'ModelFieldList' => 'Seznam hodnot:',
        'ModelFieldListLegend' => '<i>Oddělovač je čárka</i>',
        'ModelFieldDisplayAs' => 'Display as:',
        'ModelFieldDisplayAsText' => 'Text',
        'ModelFieldDisplayAsGraphical' => 'Rating Control',
        'ModelFieldTypeShortText' => 'Krátký text',
        'ModelFieldTypeLongText' => 'Dlouhý text',
        'ModelFieldTypeYesNo' => 'Ano/Ne',
        'ModelFieldTypeNumber' => 'Číslo',
        'ModelFieldTypeDate' => 'Datum',
        'ModelFieldTypeOptions' => 'Předdefinovaný seznam hodnot',
        'ModelFieldTypeImage' => 'Obrázek',
        'ModelFieldTypeSingleList' => 'Jednoduchý seznam',
        'ModelFieldTypeFile' => 'Soubor',
        'ModelFieldTypeFormatted' => 'Závislý na jiných typech',
        'ModelFieldParameters' => 'Parametry',
        'ModelFieldHasHistory' => 'Používat historii',
        'ModelFieldFlat' => 'Zobrazit v jedné řadě',
        'ModelFieldStep' => 'Krok přírůstku:',
        'ModelFieldFileFormat' => 'Typ souboru:',
        'ModelFieldFileFile' => 'Prostý soubor',
        'ModelFieldFileImage' => 'Obrázek',
        'ModelFieldFileVideo' => 'Video',
        'ModelFieldFileAudio' => 'Audio',
        'ModelFieldFileProgram' => 'Program',
        'ModelFieldFileUrl' => 'URL',
        'ModelFieldFileEbook' => 'Ebook',
        'ModelOptionsFields' => 'Přiřazení polí',
        'ModelOptionsFieldsAuto' => 'Automaticky',
        'ModelOptionsFieldsNone' => 'Nic',
        'ModelOptionsFieldsTitle' => 'Nadpis',
        'ModelOptionsFieldsId' => 'Identifikátor',
        'ModelOptionsFieldsCover' => 'Obal',
        'ModelOptionsFieldsPlay' => 'Tlačítko přehrát',
        'ModelCollectionSettings' => 'Nastavení sbírky',
        'ModelCollectionSettingsLending' => 'Položky mohou být půjčeny',
        'ModelCollectionSettingsTagging' => 'Items can be tagged',
        'ModelFilterActivated' => 'Pole bude ve vyhledávání',
        'ModelFilterComparison' => 'Porovnání',
        'ModelFilterContain' => 'Obsahuje',
        'ModelFilterDoesNotContain' => 'Does not contain',
        'ModelFilterRegexp' => 'Regular expression',
        'ModelFilterRange' => 'Rozsah',
        'ModelFilterNumeric' => 'Porovnávání je číselné',
        'ModelFilterQuick' => 'Vytvořit rychlý filtr',
        'ModelTooltipName' => 'Zadejte název pokud chcete šablonu použít v dalších kolekcích. Pokud název nezadáte, bude nastavení uloženo přímo v kolekci',
        'ModelTooltipLabel' => 'Zobrazený název pole',
        'ModelTooltipGroup' => 'Použití pro seskupování polí. Položky bez přiřazené hodnoty budou v implicitní skupině',
        'ModelTooltipHistory' => 'Pro uchování dříve zadaných hodnot do seznamu přiřazenému poli',
        'ModelTooltipFormat' => 'Typ souboru se použije pro rozlišení akce při otevírání souboru tlačítkem Přehrát',
        'ModelTooltipLending' => 'Tato možnost přidá několik polí pro správu půjčování',
        'ModelTooltipTagging' => 'This will add some fields to manage tags',
        'ModelTooltipNumeric' => 'Hodnoty budou považovány za čísla při porovnání',
        'ModelTooltipQuick' => 'Do menu filtr přidá submenu',			#This will add a submenu in the Filters one

        'ResultsTitle' => 'Vyberte si ze seznamu', # Accepts model codes
        'ResultsNextTip' => 'Hledat na dalším serveru',
        'ResultsPreview' => 'Náhled',
        'ResultsInfo' => 'You can add multiple items to the collection by holding down the Ctrl or the Shift key and selecting them', # Accepts model codes
        
        'OptionsTitle' => 'Možnosti',
		'OptionsExpertMode' => 'Expert Mode',
        'OptionsPrograms' => 'Specify applications to use for different media, leave blank to use system defaults',
        'OptionsBrowser' => 'Webový prohlížeč',
        'OptionsPlayer' => 'Přehrávač videa',
        'OptionsAudio' => 'Přehrávač hudby',
        'OptionsImageEditor' => 'Image Editor',
        'OptionsCdDevice' => 'CD device',
        'OptionsImages' => 'Adresář s obrázky',
        'OptionsUseRelativePaths' => 'Pro obrázky používat relativní cesty',
        'OptionsLayout' => 'Rozložení',
        'OptionsStatus' => 'Zobrazit stavový řádek',
        'OptionsUseStars' => 'Use stars to display ratings',
        'OptionsWarning' => 'Varování: Změny v této záložce budou bez efektu až do restartu aplikace',
        'OptionsRemoveConfirm' => 'Před smazáním položky požadovat potvrzení',
        'OptionsAutoSave' => 'Automaticky ukládat sbírku',
        'OptionsAutoLoad' => 'Při startu nahrát předchozí sbírku',
        'OptionsSplash' => 'Zobrazit úvodní obrázek',
        'OptionsTearoffMenus' => 'Enable tear-off menus',
        'OptionsSpellCheck' => 'Use spelling checker for long text fields',
        'OptionsProgramTitle' => 'Vyberte webový prohlížeč',
		'OptionsPlugins' => 'Server, odkud stahovat data',
		'OptionsAskPlugins' => 'Zeptat se (všechny servery)',
		'OptionsPluginsMulti' => 'Více serverů',
		'OptionsPluginsMultiAsk' => 'Zeptat se (více serverů)',
        'OptionsPluginsMultiPerField' => 'Více serverů (per field)',
        'OptionsPluginsMultiPerFieldWindowTitle' => 'Many sites per field order selection',
        'OptionsPluginsMultiPerFieldDesc' => 'For each selected field we will return the first non empty information beginning from left',
        'OptionsPluginsMultiPerFieldFirst' => 'First',
        'OptionsPluginsMultiPerFieldLast' => 'Last',
        'OptionsPluginsMultiPerFieldRemove' => 'Remove',
        'OptionsPluginsMultiPerFieldClearSelected' => 'Empty selected field list',
		'OptionsPluginsList' => 'Nastavit seznam',
        'OptionsAskImport' => 'Vyberte pole, která se importují',
		'OptionsProxy' => 'Použít proxy',
		'OptionsCookieJar' => 'Use this cookie jar file',
        'OptionsLang' => 'Jazyk',
        'OptionsMain' => 'Hlavní',
        'OptionsPaths' => 'Cesty',
        'OptionsInternet' => 'Internet',
        'OptionsConveniences' => 'Vlastnosti',
        'OptionsDisplay' => 'Zobrazení',
        'OptionsToolbar' => 'Nástrojová lišta',
        'OptionsToolbars' => {0 => 'Žádná', 1 => 'Malá', 2 => 'Velká', 3 => 'System setting'},
        'OptionsToolbarPosition' => 'Umístění',
        'OptionsToolbarPositions' => {0 => 'Nahoře', 1 => 'Dole', 2 => 'Vlevo', 3 => 'Vpravo'},
        'OptionsExpandersMode' => 'Expanders too long',
        'OptionsExpandersModes' => {'asis' => 'Do nothing', 'cut' => 'Cut', 'wrap' => 'Line wrap'},
        'OptionsDateFormat' => 'Date Format',
        'OptionsDateFormatTooltip' => 'Format is the one used by strftime(3). Default is %d/%m/%Y',
        'OptionsView' => 'Zobrazení',
        'OptionsViews' => {0 => 'Text', 1 => 'Obrázek', 2 => 'Detailní'},
        'OptionsColumns' => 'Sloupce',
        'OptionsMailer' => 'E-mailer',
        'OptionsSMTP' => 'Server',
        'OptionsFrom' => 'E-mail',
        'OptionsTransform' => 'Členy umístit na konce názvů',
        'OptionsArticles' => 'Členy (odděleny čárkou)',
        'OptionsSearchStop' => 'Umožnit zrušení hledání',
        'OptionsBigPics' => 'Use big pictures when available',
        'OptionsAlwaysOriginal' => 'Použít hlavní titul jako originální titul, pokud není vyplněn',
        'OptionsRestoreAccelerators' => 'Restore accelerators',
        'OptionsHistory' => 'Velikost historie',
        'OptionsClearHistory' => 'Vyčistit historii',
		'OptionsStyle' => 'Skin',
        'OptionsDontAsk' => 'Příště se nedotazovat',
        'OptionsPathProgramsGroup' => 'Programy',
        'OptionsProgramsSystem' => 'Použít programy stanovené v systému',
        'OptionsProgramsUser' => 'Použít jiné programy',
        'OptionsProgramsSet' => 'Nastavit programy',
        'OptionsPathImagesGroup' => 'Obrázky',
        'OptionsInternetDataGroup' => 'Import dat',
        'OptionsInternetSettingsGroup' => 'Nastavení',
        'OptionsDisplayInformationGroup' => 'Informační panel',
        'OptionsDisplayArticlesGroup' => 'Členy',
        'OptionsImagesDisplayGroup' => 'Zobrazení',
        'OptionsImagesStyleGroup' => 'Styl',
        'OptionsDetailedPreferencesGroup' => 'Předvolby',
        'OptionsFeaturesConveniencesGroup' => 'Nastavení',
        'OptionsPicturesFormat' => 'Předpona použitá pro obrázky:',
        'OptionsPicturesFormatInternal' => 'gcstar__',
        'OptionsPicturesFormatTitle' => 'Titul nebo název asociované položky',
        'OptionsPicturesWorkingDir' => '%WORKING_DIR% nebo . bude nahrazen adresářem se sbírkou (používat pouze pro začátek cesty)',
        'OptionsPicturesFileBase' => '%FILE_BASE% bude nahrazen názvem sbírky bez přípony (.gcs)',
        'OptionsPicturesWorkingDirError' => '%WORKING_DIR% může být použit pouze pro začátek cesty s obrázky',
        'OptionsConfigureMailers' => 'Nastavení e-mailových programů',

        'ImagesOptionsButton' => 'Nastavení',
        'ImagesOptionsTitle' => 'Nastavení pro seznam obrázků',
        'ImagesOptionsSelectColor' => 'Vybrat barvu',
        'ImagesOptionsUseOverlays' => 'Use image overlays',
        'ImagesOptionsBg' => 'Pozadí',
        'ImagesOptionsBgPicture' => 'Použít obrázek na pozadí',
        'ImagesOptionsFg'=> 'Výběr',
        'ImagesOptionsBgTooltip' => 'Změna barvy pozadí',
        'ImagesOptionsFgTooltip'=> 'Změna barvy výběru',
        'ImagesOptionsResizeImgList' => 'Automatically change number of columns',
        'ImagesOptionsAnimateImgList' => 'Use animations',
        'ImagesOptionsSizeLabel' => 'Velikost obrázků',
        'ImagesOptionsSizeList' => {0 => 'Velmi malé', 1 => 'Malé', 2 => 'Středně velké', 3 => 'Velké', 4 => 'Velmi velké'},
        'ImagesOptionsSizeTooltip' => 'Výběr velikosti obrázků',
		        
        'DetailedOptionsTitle' => 'Nastavení detailního seznamu',
        'DetailedOptionsImageSize' => 'Velikost obrázků',
        'DetailedOptionsGroupItems' => 'Řadit podle',
        'DetailedOptionsSecondarySort' => 'Sort field for children',
		'DetailedOptionsFields' => 'Výběr zobrazených polí',
        'DetailedOptionsGroupedFirst' => 'Osiřelé položky nechat pohromadě',
        'DetailedOptionsAddCount' => 'Zobrazit počet prvků v kategoriích',

        'ExtractButton' => 'Informace',
        'ExtractTitle' => 'Informace o video souboru',
        'ExtractImport' => 'Použít hodnoty',

        'FieldsListOpen' => 'Nahrát seznam polí ze souboru',
        'FieldsListSave' => 'Uložit seznam polí do souboru',
        'FieldsListError' => 'Tento seznam polí nemůže být použit s tímto typem sbírky',
        'FieldsListIgnore' => '--- Ignore',

        'ExportTitle' => 'Export seznamu',
        'ExportFilter' => 'Export pouze zobrazených položek',
        'ExportFieldsTitle' => 'Pole k exportu',
        'ExportFieldsTip' => 'Vyber pole k exportu',
        'ExportWithPictures' => 'Zkopírovat obrázky do podadresáře',
        'ExportSortBy' => 'Řadit podle',
        'ExportOrder' => 'Order',

        'ImportListTitle' => 'Import dalšího seznamu',
        'ImportExportData' => 'Data',
        'ImportExportFile' => 'Soubor',
        'ImportExportFieldsUnused' => 'Nepoužité pole',
        'ImportExportFieldsUsed' => 'Použité pole',
        'ImportExportFieldsFill' => 'Přidat vše',
        'ImportExportFieldsClear' => 'Odebrat vše',
        'ImportExportFieldsEmpty' => 'Musíte vybrat alespoň jedno pole',
        'ImportExportFileEmpty' => 'Musíte zadat jméno souboru',
        'ImportFieldsTitle' => 'Pole k importu',
        'ImportFieldsTip' => 'Vyberte pole k importu',
        'ImportNewList' => 'Vytvořit novou kolekci',
        'ImportCurrentList' => 'Přidat do stávající kolekce',
        'ImportDropError' => 'Při otevírání souboru se vyskytl problém. Znovu se načte předchozí seznam.',
        'ImportGenerateId' => 'Vytvořit identifikátor pro každou položku',

        'FileChooserOpenFile' => 'Prosím vyberte soubor',
        'FileChooserDirectory' => 'Directory',
        'FileChooserOpenDirectory' => 'Vyberte adresář pro ukládání obrázků',
        'FileChooserOverwrite' => 'Tento soubor již existuje. Chcete jej přepsat?',
        'FileAllFiles' => 'All Files',
        'FileVideoFiles' => 'Video Files',
        'FileEbookFiles' => 'Ebook Files',
        'FileAudioFiles' => 'Audio Files',
        'FileGCstarFiles' => 'GCstar Collections',

        'PanelCompact' => 'Kompaktní',
        'PanelReadOnly' => 'Pouze pro čtení',
        'PanelForm' => 'Záložky',

        'PanelSearchButton' => 'Stáhnout Informace',
        'PanelSearchTip' => 'Hledá informace o tomto názvu na webu',
        'PanelSearchContextChooseOne' => 'Choose a site ...',
        'PanelSearchContextMultiSite' => 'Use "Many sites"',
        'PanelSearchContextMultiSitePerField' => 'Use "Many sites per field"',
        'PanelSearchContextOptions' => 'Change options ...',
        'PanelImageTipOpen' => 'Pro výběr jiného obrázku na obrázek klikněte.',
        'PanelImageTipView' => 'Pro zobrazení skutečné velikosti obrázku na něj klikněte.',
        'PanelImageTipMenu' => 'Pod pravým tlačítkem je více voleb.',
        'PanelImageTitle' => 'Vyberte obrázek',
        'PanelImageNoImage' => 'Bez obrázku',
        'PanelSelectFileTitle' => 'Vyberte soubor',
        'PanelLaunch' => 'Launch',        
        'PanelRestoreDefault' => 'Obnovit výchozí nastavení',
        'PanelRefresh' => 'Update',
        'PanelRefreshTip' => 'Update information from web',

        'PanelFrom' =>'Od',
        'PanelTo' =>'Do',

        'PanelWeb' => 'Zobrazit informace',
        'PanelWebTip' => 'Zobrazí informace o vybrané položce na webu', # Accepts model codes
        'PanelRemoveTip' => 'Odstraní stávající položku', # Accepts model codes

        'PanelDateSelect' => 'Vyberte datum',
        'PanelNobody' => 'Žádný',
        'PanelUnknown' => 'Neznámý',
        'PanelAdded' => 'Přidáno',
        'PanelRating' => 'Hodnocení',
        'PanelPressRating' => 'Press Rating',
        'PanelLocation' => 'Umístění',

        'PanelLending' => 'Zápůjčky',
        'PanelBorrower' => 'Dlužník',
        'PanelLendDate' => 'Půjčeno od',
        'PanelHistory' => 'Historie zápůjček',
        'PanelReturned' => 'Položka vrácena', # Accepts model codes
        'PanelReturnDate' => 'Datum vrácení',
        'PanelLendedYes' => 'Půjčeno',
        'PanelLendedNo' => 'Dostupné',

        'PanelTags' => 'Tags',
        'PanelFavourite' => 'Favourite',
        'TagsAssigned' => 'Assigned Tags', 

        'PanelUser' => 'User fields',

        'CheckUndef' => 'Nezáleží',
        'CheckYes' => 'Ano',
        'CheckNo' => 'Ne',

        'ToolbarAll' => 'Zobrazit vše',
        'ToolbarAllTooltip' => 'Zobrazí celý seznam',
        'ToolbarGroupBy' => 'Řadit podle',
        'ToolbarGroupByTooltip' => 'Vyberte pole, podle kterého se mají řadit položky seznamu',
        'ToolbarQuickSearch' => 'Quick search',
        'ToolbarQuickSearchLabel' => 'Search',
        'ToolbarQuickSearchTooltip' => 'Select the field to search in. Enter the search terms and press Enter',
        'ToolbarSeparator' => ' Separator',
        
        'PluginsTitle' => 'Hledat',
        'PluginsQuery' => 'Dotaz',
        'PluginsFrame' => 'Hledat na serveru',
        'PluginsLogo' => 'Logo',
        'PluginsName' => 'Jméno',
        'PluginsSearchFields' => 'Hledat v poli',
        'PluginsAuthor' => 'Autor',
        'PluginsLang' => 'Jazyk',
        'PluginsUseSite' => 'Použít vybraný server pro další hledání',
        'PluginsPreferredTooltip' => 'Site recommended by GCstar',
        'PluginDisabled' => 'Disabled',

        'BorrowersTitle' => 'Konfigurace dlužníků',
        'BorrowersList' => 'Dlužníci',
        'BorrowersName' => 'Jméno',
        'BorrowersEmail' => 'E-mail',
        'BorrowersAdd' => 'Přidat',
        'BorrowersRemove' => 'Odebrat',
        'BorrowersEdit' => 'Editace',
        'BorrowersTemplate' => 'Šablona mailu',
        'BorrowersSubject' => 'Předmět mailu',
        'BorrowersNotice1' => '%1 bude nahrazen jménem dlužníka',
        'BorrowersNotice2' => '%2 bude nahrazen názvem položky',
        'BorrowersNotice3' => '%3 bude nahrazen datem výpůjčky',

        'BorrowersImportTitle' => 'Importovat informace o dlužnících',
        'BorrowersImportType' => 'Formát souboru:',
        'BorrowersImportFile' => 'Soubor:',

        'BorrowedTitle' => 'Půjčené položky', # Accepts model codes
        'BorrowedDate' => 'Od',
        'BorrowedDisplayInPanel' => 'Show item in main window', # Accepts model codes

        'MailTitle' => 'Poslat e-mail',
        'MailFrom' => 'Od: ',
        'MailTo' => 'Komu: ',
        'MailSubject' => 'Předmět: ',
        'MailSmtpError' => 'Problém s připojením k SMTP serveru',
        'MailSendmailError' => 'Problém se spuštěním sendmailu',

        'SearchTooltip' => 'Prohledává celý seznam', # Accepts model codes
        'SearchTitle' => 'Hledání', # Accepts model codes
        'SearchNoField' => 'No field have been selected for the search box.
Add some of them in the Filters tab of the collection settings.',

        'QueryReplaceField' => 'Nahradit v poli',
        'QueryReplaceOld' => 'Současné jméno',
        'QueryReplaceNew' => 'Nové jméno',
        'QueryReplaceLaunch' => 'Nahradit',
        
        'ImportWindowTitle' => 'Vyberte pole k importu',
        'ImportViewPicture' => 'Zobrazit obrázek',
        'ImportSelectAll' => 'Vybrat vše',
        'ImportSelectNone' => 'Nevybírat nic',

        'MultiSiteTitle' => 'Pro hledání použít tyto servery',
        'MultiSiteUnused' => 'Nepoužité servery',
        'MultiSiteUsed' => 'Použité servery',
        'MultiSiteLang' => 'Vybrat české servery',
        'MultiSiteEmptyError' => 'Máte prázdný seznam serverů',
        'MultiSiteClear' => 'Vymazat seznam',
        
        'DisplayOptionsTitle' => 'Zobrazit položky',
        'DisplayOptionsAll' => 'Vybrat vše',
        'DisplayOptionsSearch' => 'Stáhnout informace',

        'GenresTitle' => 'Konverze žánrů',
        'GenresCategoryName' => 'Použít žánr',
        'GenresCategoryMembers' => 'Nahradit žánr',
        'GenresLoad' => 'Nahrát seznam',
        'GenresExport' => 'Uložit seznam do souboru',
        'GenresModify' => 'Upravit konverzi',

        'PropertiesName' => 'Název sbírky',
        'PropertiesLang' => 'Language code',
        'PropertiesOwner' => 'Vlastník',
        'PropertiesEmail' => 'E-mail',
        'PropertiesDescription' => 'Popis',
        'PropertiesFile' => 'Informace o souboru',
        'PropertiesFilePath' => 'Úplná cesta',
        'PropertiesItemsNumber' => 'Počet položek', # Accepts model codes
        'PropertiesFileSize' => 'Velikost',
        'PropertiesFileSizeSymbols' => ['Bytů', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
        'PropertiesCollection' => 'Vlastnosti sbírky',
        'PropertiesDefaultPicture' => 'Default picture',

        'MailProgramsTitle' => 'Programy pro odesílání mailů',
        'MailProgramsName' => 'Název',
        'MailProgramsCommand' => 'Příkazová řádka',
        'MailProgramsRestore' => 'Obnovit implicitní',
        'MailProgramsAdd' => 'Přidat program',
        'MailProgramsInstructions' => 'V příkazové řádce je provedeno několik substitucí:
 %f je nahrazeno e-mailovou adresou uživatele.
 %t je nahrazeno adresou příjemce.
 %s je nahrazeno předmětem zprávy.
 %b je nahrazeno obsahem zprávy.',

        'BookmarksBookmarks' => 'Záložky',
        'BookmarksFolder' => 'Adresář',
        'BookmarksLabel' => 'Štítek',					#Label
        'BookmarksPath' => 'Cesta',
        'BookmarksNewFolder' => 'Nový adresář',

        'AdvancedSearchType' => 'Typ hledání',
        'AdvancedSearchTypeAnd' => 'Položky odpovídají všem podmínkám', # Accepts model codes
        'AdvancedSearchTypeOr' => 'Položky odpovídají alespoň jedné podmínce', # Accepts model codes
        'AdvancedSearchCriteria' => 'Podmínky',
        'AdvancedSearchAnyField' => 'Any field',
        'AdvancedSearchSaveTitle' => 'Save search',
        'AdvancedSearchSaveName' => 'Name',
        'AdvancedSearchSaveOverwrite' => 'A saved search already exists with that name. Please use a different one.',
        'AdvancedSearchUseCase' => 'Case sensitive',
        'AdvancedSearchIgnoreDiacritics' => 'Ignore accents and other diacritics',

        'BugReportSubject' => 'Zpráva o chybě generovaná z GCstar',
        'BugReportVersion' => 'Verze',
        'BugReportPlatform' => 'Operační systém',
        'BugReportMessage' => 'Chybová zpráva',
        'BugReportInformation' => 'Další informace',

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
