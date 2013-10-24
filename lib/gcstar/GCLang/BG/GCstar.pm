{
    package GCLang::BG;

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

        'LangName' => 'Bulgarian',
        
        'Separator' => ': ',
        
        'Warning' => '<b>Внимание</b>:
        
Информация, свалена от уеб-страници (чрез приставките за търсене) е
  <b>само за лично ползване</b>.

Всякакво разпространение е забранено без <b>изричното съгласие</b>
на собствениците на страницата.

За да определите коя страница притежава информацията, можете
да използвате <b>бутона под детайлите на филма</b>.',
        
        'AllItemsFiltered' => 'Няма филм, отговарящ на критериите ви за търсене', # Accepts model codes
        
#Installation
        'InstallDirInfo' => 'Инсталиране в ',
        'InstallMandatory' => 'Задължителни компоненти',
        'InstallOptional' => 'Незадължителни компоненти',
        'InstallErrorMissing' => 'Грешка : Следните Perl компоненти следва да се инсталират: ',
        'InstallPrompt' => 'Основна директория за инсталиране [/usr/local]: ',
        'InstallEnd' => 'Край на инсталацията',
        'InstallNoError' => 'Няма възникнали грешки',
        'InstallLaunch' => 'За да използвате приложението, можете да стартирате ',
        'InstallDirectory' => 'Базова директория',
        'InstallTitle' => 'GCstar инсталация',
        'InstallDependencies' => 'Зависимости',
        'InstallPath' => 'Пътека',
        'InstallOptions' => 'Настройки',
        'InstallSelectDirectory' => 'Изберете базова директория за инсталация',
        'InstallWithClean' => 'Премахване на файлове в инстлационната директория',
        'InstallWithMenu' => 'Добавяне на GCstar в менюто',
        'InstallNoPermission' => 'Грешка: Нямате права за писане в избраната директория',
        'InstallMissingMandatory' => 'Липсват задължителни модули. Няма да сте в състояние да инсталирате  GCstar преди те да бъдат добавени на вашата система.',
        'InstallMissingOptional' => 'Някои незадължителни зависимости липсват. Техния списък е предоставен по-долу. GCstar може да бъде инсталиран, но някои негови функции няма да бъдат налични.',
        'InstallMissingNone' => 'Няма липсващи зависимости. Можете да продължите с инсталацията на  GCstar.',
        'InstallOK' => 'OK',
        'InstallMissing' => 'Липсващ',
        'InstallMissingFor' => 'Липсващ за',
        'InstallCleanDirectory' => 'Removing GCstar\'s files in directory: ',
        'InstallCopyDirectory' => 'Copying files in directory: ',
        'InstallCopyDesktop' => 'Copying desktop file in: ',

#Update
        'UpdateUseProxy' => 'Proxy to use (just press enter if none): ',
        'UpdateNoPermission' => 'Write permission denied in this directory: ',
        'UpdateNone' => 'No update have been found',
        'UpdateFileNotFound' => 'File not found',

#Splash
        'SplashInit' => 'Инициализация',
        'SplashLoad' => 'Зареждане на колекцията',
        'SplashDisplay' => 'Displaying Collection',
        'SplashSort' => 'Sorting Collection',
        'SplashDone' => 'Готово',

#Import from GCfilms
        'GCfilmsImportQuestion' => 'It seems you were using GCfilms before. What do you want to import from GCfilms to GCstar (it won\'t impact GCfilms if you still want to use it)?',
        'GCfilmsImportOptions' => 'Settings',
        'GCfilmsImportData' => 'Movies list',

#Menus
        'MenuFile' => '_Файл',
            'MenuNewList' => '_Нова колекция',
            'MenuStats' => 'Statistics',
            'MenuHistory' => '_Скоро използвани колекции',
            'MenuLend' => 'Показване на заети филми', # Accepts model codes
            'MenuImport' => '_Импорт',	
            'MenuExport' => '_Експорт',
            'MenuAddItem' => '_Add Item', # Accepts model codes

        'MenuEdit'  => '_Редактиране',
            'MenuDuplicate' => '_Дубликат на филм', # Accepts model codes
            'MenuDuplicatePlural' => 'Du_plicate Items', # Accepts model codes
            'MenuEditSelectAllItems' => 'Select _All Items', # Accepts model codes
            'MenuEditDeleteCurrent' => '_Премахване на филм', # Accepts model codes  
            'MenuEditDeleteCurrentPlural' => '_Remove Items', # Accepts model codes  
            'MenuEditFields' => '_Change collection fields',
            'MenuEditLockItems' => '_Заключване на колекция',

        'MenuDisplay' => 'Ф_илтър',
            'MenuSavedSearches' => 'Saved searches',
                'MenuSavedSearchesSave' => 'Save current search',
                'MenuSavedSearchesEdit' => 'Modify saved searches',
            'MenuAdvancedSearch' => 'A_dvanced Search',
            'MenuViewAllItems' => 'Показване на _всички филми', # Accepts model codes  
            'MenuNoFilter' => '_Всякакъв',

        'MenuConfiguration' => '_Настройки',
            'MenuDisplayMenu' => 'Display',
                'MenuDisplayFullScreen' => 'Full screen',
                'MenuDisplayMenuBar' => 'Menus',
                'MenuDisplayToolBar' => 'Toolbar',
                'MenuDisplayStatusBar' => 'Bottom bar',
            'MenuDisplayOptions' => '_Показана информация',
            'MenuBorrowers' => '_Наематели',
            'MenuToolbarConfiguration' => '_Toolbar controls',
            'MenuDefaultValues' => 'Default values for new item', # Accepts model codes
            'MenuGenresConversion' => 'Конвертиране на жанр',

        'MenuBookmarks' => 'My _Collections',
            'MenuBookmarksAdd' => '_Add current collection',
            'MenuBookmarksEdit' => '_Edit bookmarked collections',

        'MenuHelp' => '_Помощ',
            'MenuHelpContent' => '_Помощ',
            'MenuAllPlugins' => 'View _plugins',
            'MenuBugReport' => 'Report a _bug',
            'MenuAbout' => '_Относно GCstar',

        'MenuNewWindow' => 'Показване на филм в _Нов Прозорец', # Accepts model codes  
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

        'RemoveConfirm' => 'Сигурни ли сте, че желаето премахването на филма?', # Accepts model codes 
        'RemoveConfirmPlural' => 'Do you really want to remove these items?', # Accepts model codes
        
        'DefaultNewItem' => 'New item', # Accepts model codes
        'NewItemTooltip' => 'Добавяне на нов филм', # Accepts model codes
        'NoItemFound' => 'Не е намерен филм. Желаети ли търсене в друг сайт?',
        'OpenList' => 'Моля изберете колекция',
        'SaveList' => 'Моля изберете къде да се съхрани колекцията',
        'SaveListTooltip' => 'Съхраняване на текуща колекция',
        'SaveUnsavedChanges' => 'There are unsaved changes in your collection. Do you want to save them?',
        'SaveDontSave' => 'Don\'t save',
        'PreferencesTooltip' => 'Установете предпочитанията си',
        'ViewTooltip' => 'Промяна на изгледа на колекция',
        'PlayTooltip' => 'Възпроизвеждане на видео, асоцииран с филм', # Accepts model codes
        'PlayFileNotFound' => 'File to launch was not found in this location:',
        'PlayRetry' => 'Retry',

        'StatusSave' => 'Saving...',
        'StatusLoad' => 'Loading...',
        'StatusSearch' => 'Извършва се търсене...',
        'StatusGetInfo' => 'Получаване на информация...',
        'StatusGetImage' => 'Получаване на изображение...',
                
        'SaveError' => 'Списъкът с филми не може да бъде съхранен . Моля проверете правата за достъп и наличното дисково пространство.',
        'OpenError' => 'Списъкът с филми не може да бъде отворен. Моля проверенте правата за достъп.',
		'OpenFormatError' => 'Списъкът с филми не може да бъде отворен.',
        'OpenVersionWarning' => 'Collection was created with a more recent version of GCstar. If you save it, you may loose some data.',
        'OpenVersionQuestion' => 'Do you still want to continue?',
        'ImageError' => 'Избраната директория за съхраняване на изображения не е коректна. Моля изберете друга.',
        'OptionsCreationError'=> 'Файлът с настройки не може да бъде създаден: ',
        'OptionsOpenError'=> 'Файлът с настройки не може да бъде отворен: ',
        'OptionsSaveError'=> 'Файлът с настройки не може да бъде съхранен:',
        'ErrorModelNotFound' => 'Model not found: ',
        'ErrorModelUserDir' => 'User defined models are in: ',
        
        'RandomTooltip' => 'Какво да се гледа тази вечер?',
        'RandomError'=> 'Няме филми, които да не сте гледали', # Accepts model codes
        'RandomEnd'=> 'Няма повече филми', # Accepts model codes
        'RandomNextTip'=> 'Следващо предложение',
        'RandomOkTip'=> 'Приемане на този филм',
        
        'AboutTitle' => 'Относно GCstar',
        'AboutDesc' => 'Gtk2 каталог на филми',
        'AboutVersion' => 'Версия',
        'AboutTeam' => 'Екип',
        'AboutWho' => 'Christian Jodar (Tian): Мениджър на проекта, Програмист
Nyall Dawson (Zombiepig): Програмист
TPF: Програмист
Adolfo González: Програмист
',

        'AboutLicense' => 'Разпространява се под условията на GNU GPL
Автор на логото le Spektre',
        'AboutTranslation' => 'Българският превод е направен от Филип Андонов',
        'AboutDesign' => 'Łukasz Kowalczk (Qoolman): Skin Designer
Лого и дизайн на страницата от le Spektre',

        'ToolbarRandom' => 'Довечера',
        
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

        'ResultsTitle' => 'Избор на филм', # Accepts model codes
        'ResultsNextTip' => 'Търсене в следващ сайт',
        'ResultsPreview' => 'Preview',
        'ResultsInfo' => 'You can add multiple items to the collection by holding down the Ctrl or the Shift key and selecting them', # Accepts model codes
        
        'OptionsTitle' => 'Предпочитания',
		'OptionsExpertMode' => 'Expert Mode',
        'OptionsPrograms' => 'Specify applications to use for different media, leave blank to use system defaults',
        'OptionsBrowser' => 'Уеб-четец',
        'OptionsPlayer' => 'Видео плеър',
        'OptionsAudio' => 'Audio player',
        'OptionsImageEditor' => 'Image Editor',
        'OptionsCdDevice' => 'CD device',
        'OptionsImages' => 'Директория с изображения',
        'OptionsUseRelativePaths' => 'Използване на относителни пътеки към изображения',
        'OptionsLayout' => 'Оформление',
        'OptionsStatus' => 'Показване на статус-лента',
        'OptionsUseStars' => 'Use stars to display ratings',
        'OptionsWarning' => 'Внимание: Промените няма да имат ефект докато приложението не бъде рестартирано.',
        'OptionsRemoveConfirm' => 'Изисване на потвърждение преди изтриване',
        'OptionsAutoSave' => 'Автоматично съхраняване на колекция',
        'OptionsAutoLoad' => 'Load previous collection on startup',
        'OptionsSplash' => 'Показване на splash екран',
        'OptionsTearoffMenus' => 'Enable tear-off menus',
        'OptionsSpellCheck' => 'Use spelling checker for long text fields',
        'OptionsProgramTitle' => 'Избор на програма, която да бъде използвана',
		'OptionsPlugins' => 'Сайтове, от които да се получава информация',
		'OptionsAskPlugins' => 'Питане (Всички сайтове)',
		'OptionsPluginsMulti' => 'Много сайтове',
		'OptionsPluginsMultiAsk' => 'Питане (Много сайтове)',
        'OptionsPluginsMultiPerField' => 'Много сайтове (per field)',
        'OptionsPluginsMultiPerFieldWindowTitle' => 'Many sites per field order selection',
        'OptionsPluginsMultiPerFieldDesc' => 'For each selected field we will return the first non empty information beginning from left',
        'OptionsPluginsMultiPerFieldFirst' => 'First',
        'OptionsPluginsMultiPerFieldLast' => 'Last',
        'OptionsPluginsMultiPerFieldRemove' => 'Remove',
        'OptionsPluginsMultiPerFieldClearSelected' => 'Empty selected field list',
		'OptionsPluginsList' => 'Установяване на списък',
        'OptionsAskImport' => 'Избор на полета, които да бъдат импортирани',
		'OptionsProxy' => 'Използване на proxy',
		'OptionsCookieJar' => 'Use this cookie jar file',
        'OptionsLang' => 'Език',
        'OptionsMain' => 'Основен',
        'OptionsPaths' => 'Пътеки',
        'OptionsInternet' => 'Интернет',
        'OptionsConveniences' => 'Свойства',
        'OptionsDisplay' => 'Дисплей',
        'OptionsToolbar' => 'Лента с инструменти',
        'OptionsToolbars' => {0 => 'Без', 1 => 'Малък', 2 => 'Голям', 3 => 'System setting'},
        'OptionsToolbarPosition' => 'Позиция',
        'OptionsToolbarPositions' => {0 => 'Горе', 1 => 'Долу', 2 => 'Ляво', 3 => 'Дясно'},
        'OptionsExpandersMode' => 'Expanders too long',
        'OptionsExpandersModes' => {'asis' => 'Do nothing', 'cut' => 'Cut', 'wrap' => 'Line wrap'},
        'OptionsDateFormat' => 'Date Format',
        'OptionsDateFormatTooltip' => 'Format is the one used by strftime(3). Default is %d/%m/%Y',
        'OptionsView' => 'Дисплей',
        'OptionsViews' => {0 => 'Техт', 1 => 'Изображение', 2 => 'Детайлно'},
        'OptionsColumns' => 'Колони',
        'OptionsMailer' => 'Програма за електронна поща',
        'OptionsSMTP' => 'Сървър',
        'OptionsFrom' => 'Вашият адрес',
        'OptionsTransform' => 'Поставяне на статиите в края на заглавията',
        'OptionsArticles' => 'Статии (Разделени със запетая)',
        'OptionsSearchStop' => 'Позволяване прекъсване на търсенето',
        'OptionsBigPics' => 'Use big pictures when available',
        'OptionsAlwaysOriginal' => 'Използване на основното заглавие ако оригиналното не е представено',
        'OptionsRestoreAccelerators' => 'Restore accelerators',
        'OptionsHistory' => 'Размер на историята',
        'OptionsClearHistory' => 'Изчистване на историята',
		'OptionsStyle' => 'Кожа',
        'OptionsDontAsk' => 'Не питай повече',
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

        'ImagesOptionsButton' => 'Настройки',
        'ImagesOptionsTitle' => 'Настройки за списък с изображения',
        'ImagesOptionsSelectColor' => 'Избор на цвят',
        'ImagesOptionsUseOverlays' => 'Use image overlays',
        'ImagesOptionsBg' => 'Фон',
        'ImagesOptionsBgPicture' => 'Използване на изображение за фон',
        'ImagesOptionsFg'=> 'Избор',
        'ImagesOptionsBgTooltip' => 'Промяна на фонов цвят',
        'ImagesOptionsFgTooltip'=> 'Промяна на избран цвят',
        'ImagesOptionsResizeImgList' => 'Automatically change number of columns',
        'ImagesOptionsAnimateImgList' => 'Use animations',
        'ImagesOptionsSizeLabel' => 'Размер',
        'ImagesOptionsSizeList' => {0 => 'Много малък', 1 => 'Малък', 2 => 'Среден', 3 => 'Голям', 4 => 'Много голям'},
        'ImagesOptionsSizeTooltip' => 'Избор на размер на изображение',

        'DetailedOptionsTitle' => 'Настройки за детайлен списък',
        'DetailedOptionsImageSize' => 'Размер на изображение',
        'DetailedOptionsGroupItems' => 'Group items by',
        'DetailedOptionsSecondarySort' => 'Sort field for children',
		'DetailedOptionsFields' => 'ИЗбор на приятели за показване',
        'DetailedOptionsGroupedFirst' => 'Keep together orphaned items',
        'DetailedOptionsAddCount' => 'Add number of elements on categories',

        'ExtractButton' => 'Информация',
        'ExtractTitle' => 'Информация за видео файл',
        'ExtractImport' => 'Използване на стойности',

        'FieldsListOpen' => 'Load a fields list from a file',
        'FieldsListSave' => 'Save fields list to a file',
        'FieldsListError' => 'This fields list cannot be used with this kind of collection',
        'FieldsListIgnore' => '--- Ignore',

        'ExportTitle' => 'Експортиране на списък с филми',
        'ExportFilter' => 'Експортиране само на показани филми',
        'ExportFieldsTitle' => 'Полета, които да бъдат експортирани',
        'ExportFieldsTip' => 'Избор на полета, които да бъдат експортирани',
        'ExportWithPictures' => 'Копиране на изображенията в под-директория',
        'ExportSortBy' => 'Sort by',
        'ExportOrder' => 'Order',

        'ImportListTitle' => 'Импортиране на друг списък с филми',
        'ImportExportData' => 'Data',
        'ImportExportFile' => 'Файл',
        'ImportExportFieldsUnused' => 'Неизползвани полета',
        'ImportExportFieldsUsed' => 'Използвани полета',
        'ImportExportFieldsFill' => 'Добавяне на всички',
        'ImportExportFieldsClear' => 'Премахване на всички',
        'ImportExportFieldsEmpty' => 'Необходимо е да изберете поне едно поле',
        'ImportExportFileEmpty' => 'Необходимо е да определите име на файл',
        'ImportFieldsTitle' => 'Полета, които да бъдат импортирани',
        'ImportFieldsTip' => 'Избор на полета, които желаете да бъдат импортирани',
        'ImportNewList' => 'Създаване на нова колекция',
        'ImportCurrentList' => 'Добавяне към текущата колекция',
        'ImportDropError' => 'There was an error opening at least one file. Previous list will be reloaded.',
        'ImportGenerateId' => 'Generate identifier for each item',

        'FileChooserOpenFile' => 'Моля изберете друг файл',
        'FileChooserDirectory' => 'Directory',
        'FileChooserOpenDirectory' => 'Избор на директория',
        'FileChooserOverwrite' => 'Този файл вече съществува. Желаете ли презапис?',
        'FileAllFiles' => 'All Files',
        'FileVideoFiles' => 'Video Files',
        'FileEbookFiles' => 'Ebook Files',
        'FileAudioFiles' => 'Audio Files',
        'FileGCstarFiles' => 'GCstar Collections',

        'PanelCompact' => 'Компактен',
        'PanelReadOnly' => 'Само за четене',
        'PanelForm' => 'Табове',

        'PanelSearchButton' => 'Добиване на информация',
        'PanelSearchTip' => 'Търсене в уеб за информация относно това заглавие',
        'PanelSearchContextChooseOne' => 'Choose a site ...',
        'PanelSearchContextMultiSite' => 'Use "Many sites"',
        'PanelSearchContextMultiSitePerField' => 'Use "Many sites per field"',
        'PanelSearchContextOptions' => 'Change options ...',
        'PanelImageTipOpen' => 'Щракнете върху изображението за да изберете друго.',
        'PanelImageTipView' => 'Click on the picture to view it in real size.',
        'PanelImageTipMenu' => ' Десен бутон за повече възможности.',
        'PanelImageTitle' => 'Избор на изображение',
        'PanelImageNoImage' => 'No image',
        'PanelSelectFileTitle' => 'Избор на файл',
        'PanelLaunch' => 'Launch',
        'PanelRestoreDefault' => 'Restore default',
        'PanelRefresh' => 'Update',
        'PanelRefreshTip' => 'Update information from web',

        'PanelFrom' =>'From',
        'PanelTo' =>'To',

        'PanelWeb' => 'Показване на информация',
        'PanelWebTip' => 'Показване на информация от уеб за този филм', # Accepts model codes
        'PanelRemoveTip' => 'Премахване на текущ филм', # Accepts model codes

        'PanelDateSelect' => 'Избор на дата',
        'PanelNobody' => 'Никой',
        'PanelUnknown' => 'Неизвестен',
        'PanelAdded' => 'Add date',
        'PanelRating' => 'Рейтинг',
        'PanelPressRating' => 'Press Rating',
        'PanelLocation' => 'Местоположение',

        'PanelLending' => 'Заемане',
        'PanelBorrower' => 'Взел',
        'PanelLendDate' => 'Не е наличен от',
        'PanelHistory' => 'История на заемането',
        'PanelReturned' => 'Върнат филм', # Accepts model codes
        'PanelReturnDate' => 'Дата на връщане',
        'PanelLendedYes' => 'Даден',
        'PanelLendedNo' => 'Наличен',

        'PanelTags' => 'Tags',
        'PanelFavourite' => 'Favourite',
        'TagsAssigned' => 'Assigned Tags', 

        'PanelUser' => 'User fields',

        'CheckUndef' => 'Без значение',
        'CheckYes' => 'Да',
        'CheckNo' => 'Не',

        'ToolbarAll' => 'Показване на всички',
        'ToolbarAllTooltip' => 'Показване на всички филми',
        'ToolbarGroupBy' => 'Group by',
        'ToolbarGroupByTooltip' => 'Select the field to use to group items in list',
        'ToolbarQuickSearch' => 'Quick search',
        'ToolbarQuickSearchLabel' => 'Search',
        'ToolbarQuickSearchTooltip' => 'Select the field to search in. Enter the search terms and press Enter',
        'ToolbarSeparator' => ' Separator',
        
        'PluginsTitle' => 'Търсене на филм',
        'PluginsQuery' => 'Query',
        'PluginsFrame' => 'Сайт за търсене',
        'PluginsLogo' => 'Лого',
        'PluginsName' => 'Име',
        'PluginsSearchFields' => 'Search fields',
        'PluginsAuthor' => 'Автор',
        'PluginsLang' => 'Език',
        'PluginsUseSite' => 'Използване на избрания сайт за бъдещи търсения',
         'PluginsPreferredTooltip' => 'Site recommended by GCstar',
         'PluginDisabled' => 'Disabled',

        'BorrowersTitle' => 'Конфигуриране на наемателя',
		'BorrowersList' => 'Наематели',
        'BorrowersName' => 'Име',
        'BorrowersEmail' => 'Е-поща',
        'BorrowersAdd' => 'Добавяне',
        'BorrowersRemove' => 'Премахване',
        'BorrowersEdit' => 'Редактиране',
        'BorrowersTemplate' => 'Шаблон за писмо',
        'BorrowersSubject' => 'Заглавие на писмото',
        'BorrowersNotice1' => '%1 ще бъде заменено с името на наемателя',
        'BorrowersNotice2' => '%2 ще бъде заменено със заглавието на филма',
        'BorrowersNotice3' => '%3 ще бъде заменено с датата на заемане',

        'BorrowersImportTitle' => 'Import borrowers information',
        'BorrowersImportType' => 'File format:',
        'BorrowersImportFile' => 'File:',

        'BorrowedTitle' => 'Дадени филми', # Accepts model codes
        'BorrowedDate' => 'От',
        'BorrowedDisplayInPanel' => 'Show item in main window', # Accepts model codes

        'MailTitle' => 'Изпращане на е-поща',
        'MailFrom' => 'От: ',
        'MailTo' => 'До: ',
        'MailSubject' => 'Заглавие: ',
        'MailSmtpError' => 'Проблем при свързване със SMTP сървър',
        'MailSendmailError' => 'Проблем при стартиране на sendmail',

        'SearchTooltip' => 'Търсене на всички филми', # Accepts model codes
        'SearchTitle' => 'Търсене на филм', # Accepts model codes
        'SearchNoField' => 'No field have been selected for the search box.
Add some of them in the Filters tab of the collection settings.',

        'QueryReplaceField' => 'Field to replace',
        'QueryReplaceOld' => 'Текущо име',
        'QueryReplaceNew' => 'Ново име',
        'QueryReplaceLaunch' => 'Replace',
        
        'ImportWindowTitle' => 'Избор на приятели, които да бъдат импортирани',
        'ImportViewPicture' => 'Показване на изображение',
        'ImportSelectAll' => 'Избор на всички',
        'ImportSelectNone' => 'Премахване на избор',

        'MultiSiteTitle' => 'Сайтове които да бъдат използвани за търсене',
        'MultiSiteUnused' => 'Неизползвани приставки',
        'MultiSiteUsed' => 'Приставки, които да бъдат използвани',
        'MultiSiteLang' => 'Попълване на списъка с английски приставки',
        'MultiSiteEmptyError' => 'Вие имате празен списък със сайтове',
        'MultiSiteClear' => 'Изчистване на списъка',

        'DisplayOptionsTitle' => 'Неща за показване',
        'DisplayOptionsAll' => 'Избор на всички',
        'DisplayOptionsSearch' => 'Бутон за търсене',

        'GenresTitle' => 'Конвертиране на жанр',
        'GenresCategoryName' => 'Използване на жанр',
        'GenresCategoryMembers' => 'Жанр за подмяна',
        'GenresLoad' => 'Зареждане на списък',
        'GenresExport' => 'Съхраняване на списък във файл',
        'GenresModify' => 'Редактиране на конвертирането',

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
