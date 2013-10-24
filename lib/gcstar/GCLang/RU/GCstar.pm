{
    package GCLang::RU;

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

        'LangName' => 'Russian',
        
        'Separator' => ': ',
        
        'Warning' => '<b>Предупреждение</b>:
        
Информация загруженная с вэб-сайтов (через плагин поиска) 
предназначена только для <b>персонального</b> использования.

Любое её распространение запрещено без
<b>соответсвующего разрешения</b> сайта.

Для того что определить какой сайт является владельцем информации 
вы можете использоватье <b>кнопку на закладке детальной информации о фильме</b>.',
        
        'AllItemsFiltered' => 'Нет фильмов удовлетворяющих вашим критериям', # Accepts model codes
        
#Installation
        'InstallDirInfo' => 'Инсталлировать в ',
        'InstallMandatory' => 'Необходимые компоненты',
        'InstallOptional' => 'Допонительные (необязательные) компоненты',
        'InstallErrorMissing' => 'Ошибка : Следующие Perl-компонеты должны быть установлены: ',
        'InstallPrompt' => 'Базовая директория для инсталляции [/usr/local]: ',
        'InstallEnd' => 'Конец инсталляции',
        'InstallNoError' => 'Без ошибок',
        'InstallLaunch' => 'Для того что бы использоватть это приложение вы можете запустить ',
        'InstallDirectory' => 'Базовая директория',
        'InstallTitle' => 'Инсталляция GCstar',
        'InstallDependencies' => 'Зависимости',
        'InstallPath' => 'Путь',
        'InstallOptions' => 'Опции',
        'InstallSelectDirectory' => 'Выберите базовую директорию для инсталляции',
        'InstallWithClean' => 'Удалить файлы найденные в директории для инсталляции',
        'InstallWithMenu' => 'Добавить GCstar в меню Приложений',
        'InstallNoPermission' => 'Ошибка : У вас нет прав на запись в указанную директорию',
        'InstallMissingMandatory' => 'Необходимые зависмости не удовлетворены. Вы не можете проинсталлировать GCfilms пока не будут установлены зависимые компоненты.',
        'InstallMissingOptional' => 'Некоторые из дополнительных компонентов отсутствуют. Они перечислены ниже. GCfilms может быть проинсталлированн, но некоторые возможности не будут доступны.',
        'InstallMissingNone' => 'Не неудовлетворённых зависимостей. Вы можете продолжить инсталляцию GCfilms',
        'InstallOK' => 'OK',
        'InstallMissing' => 'Отсутствует',
        'InstallMissingFor' => 'Отсутствует',
        'InstallCleanDirectory' => 'Удаление файлов GCstar в директории: ',
        'InstallCopyDirectory' => 'Копируются файлы в директорию: ',
        'InstallCopyDesktop' => 'Копируются файлы рабочего стола в диреткорию: ',

#Update
        'UpdateUseProxy' => 'Использовать прокси-сервер (или просто нажмите Enter если не нужно): ',
        'UpdateNoPermission' => 'Права записи в эту директорию отсутствуют : ',
        'UpdateNone' => 'Обновлений не найдены',
        'UpdateFileNotFound' => 'Файл не найден',

#Splash
        'SplashInit' => 'Инициализация',
        'SplashLoad' => 'Загружается',
        'SplashDisplay' => 'Отображать коллекцию',
        'SplashSort' => 'Sorting Collection',
        'SplashDone' => 'Всё готово',

#Import from GCfilms
        'GCfilmsImportQuestion' => 'Кажется вы ранее уже использовали GCFilms. Что вы хотите импортировать из GCfilms в GCstar (это не затронет приложение GCFilms если Вы все ещё захотите потом его использовать)?',
        'GCfilmsImportOptions' => 'Установки',
        'GCfilmsImportData' => 'Список фильмов',

#Menus
        'MenuFile' => '_Файл',
            'MenuNewList' => '_Новая коллекция',
            'MenuStats' => 'Statistics',
            'MenuHistory' => '_Последние коллеции',
            'MenuLend' => 'Показать фильмы на _Руках', # Accepts model codes
            'MenuImport' => '_Импорт',	
            'MenuExport' => '_Экспорт',
            'MenuAddItem' => '_Add Items', # Accepts model codes

        'MenuEdit'  => '_Редактирование',
            'MenuDuplicate' => '_Дублировать фильм', # Accepts model codes
            'MenuDuplicatePlural' => 'Du_plicate Items', # Accepts model codes
            'MenuEditSelectAllItems' => 'Select _All Items', # Accepts model codes
            'MenuEditDeleteCurrent' => '_Удалить фильм', # Accepts model codes
            'MenuEditDeleteCurrentPlural' => '_Remove Items', # Accepts model codes    
            'MenuEditFields' => '_Изменить поля коллекции',
            'MenuEditLockItems' => '_Зафиксировать коллекцию',
    
        'MenuDisplay' => '_Фильтр',
            'MenuSavedSearches' => 'Saved searches',
                'MenuSavedSearchesSave' => 'Save current search',
                'MenuSavedSearchesEdit' => 'Modify saved searches',
            'MenuAdvancedSearch' => 'Расширенный _Поиск',
            'MenuViewAllItems' => 'Показать _ВСЕ фильмы', # Accepts model codes
            'MenuNoFilter' => '_Любой',
    
        'MenuConfiguration' => '_Настройки',
            'MenuDisplayMenu' => 'Display',
                'MenuDisplayFullScreen' => 'Full screen',
                'MenuDisplayMenuBar' => 'Menus',
                'MenuDisplayToolBar' => 'Toolbar',
                'MenuDisplayStatusBar' => 'Bottom bar',
            'MenuDisplayOptions' => '_Отображаемая информация',
            'MenuBorrowers' => '_Должники',
            'MenuToolbarConfiguration' => '_Toolbar controls',
            'MenuDefaultValues' => 'Default values for new item', # Accepts model codes
            'MenuGenresConversion' => '_Преобразование жанров',
        
        'MenuBookmarks' => 'Моя _Коллекция',
            'MenuBookmarksAdd' => 'Добавить _текущую коллекцию',
            'MenuBookmarksEdit' => '_Редактировать закладки коллекций',

        'MenuHelp' => '_Помощь',
            'MenuHelpContent' => '_Помощь',
            'MenuAllPlugins' => 'Все подключаемые _модули',
            'MenuBugReport' => 'Отправить отчёт об _ошибке',
            'MenuAbout' => '_О GCstar',
    
        'MenuNewWindow' => 'Показать фильм в _Новом Окне', # Accepts model codes
        'MenuNewWindowPlural' => 'Show Items in _New Window', # Accepts model codes
        
        'ContextExpandAll' => 'Развернуть всё',
        'ContextCollapseAll' => 'Свернуть всё',
        'ContextChooseImage' => 'Choose _Image',
        'ContextOpenWith' => 'Open Wit_h',
        'ContextImageEditor' => 'Image Editor',
        'ContextImgFront' => 'Front',
        'ContextImgBack' => 'Back',
        'ContextChooseFile' => 'Choose a File',
        'ContextChooseFolder' => 'Choose a Folder',
    
        'DialogEnterNumber' => 'Пожалуйста введите занчение',

        'RemoveConfirm' => 'Вы действительно хотите удалить этот фильм?', # Accepts model codes
        'RemoveConfirmPlural' => 'Do you really want to remove these items?', # Accepts model codes
        'DefaultNewItem' => 'Новый элемент', # Accepts model codes
        'NewItemTooltip' => 'Добавить новый фильм', # Accepts model codes
        'NoItemFound' => 'Фильм не был найде. Хотите поискать на другом сайте?',
        'OpenList' => 'Пожалуйста выберите коллекцию',
        'SaveList' => 'Пожалуйста выберите куда сохранить коллекцию',
        'SaveListTooltip' => 'Сохранить текущую коллекцию',
        'SaveUnsavedChanges' => 'В вашей коллекций есть несохранённые изменения, хотите их сохранить?',
        'SaveDontSave' => 'Не сохранять',
        'PreferencesTooltip' => 'Установите свои предпочтения',
        'ViewTooltip' => 'Изменить отоюражение коллекции',
        'PlayTooltip' => 'Воспроизвести видео ассоциируемое с фильмом', # Accepts model codes
        'PlayFileNotFound' => 'File to launch was not found in this location:',
        'PlayRetry' => 'Retry',

        'StatusSave' => 'Сохраняется...',
        'StatusLoad' => 'Загружается...',
        'StatusSearch' => 'Идёт поиск...',
        'StatusGetInfo' => 'Получается информация...',
        'StatusGetImage' => 'Получается изображение...',
                
        'SaveError' => 'Не могу сохранить список фильмов. Пожалуйста проверьте права доступа и свободное мето на диске.',
        'OpenError' => 'Не могу открыть список фильмо. Пожалуйста проверьте права доступа.',
        'OpenFormatError' => 'Не могу открыть список фильмо.',
        'OpenVersionWarning' => 'Collection was created with a more recent version of GCstar. If you save it, you may loose some data.',
        'OpenVersionQuestion' => 'Do you still want to continue?',
        'ImageError' => 'Выбранная для сохранения изображение директория не верна. Пожалуйста выберите другую.',
        'OptionsCreationError'=> 'Не могу создать файл опций: ',
        'OptionsOpenError'=> 'Не могу открыть файл опций: ',
        'OptionsSaveError'=> 'Не могу сохранить файл опций: ',
        'ErrorModelNotFound' => 'Model not found: ',
        'ErrorModelUserDir' => 'User defined models are in: ',
        
        'RandomTooltip' => 'Чего бы посмотреть сегодня вечером ?',
        'RandomError'=> 'У вас нет непросмотренных фильмов', # Accepts model codes
        'RandomEnd'=> 'Больше нет фильмов', # Accepts model codes
        'RandomNextTip'=> 'Следущее предложение',
        'RandomOkTip'=> 'Я согласен на этот фильм',
        
        'AboutTitle' => 'О GCstar',
        'AboutDesc' => 'Gtk2 Каталог Фиьмов',
        'AboutVersion' => 'Версия',
        'AboutTeam' => 'Команда',
        'AboutWho' => 'Christian Jodar (Tian): Руководитель проекта, Программист
Nyall Dawson (Zombiepig): Программист
TPF: Программист
Adolfo González: Программист
',
        'AboutLicense' => 'Распространяется под лицензией GNU GPL
Логотипы Copyright le Spektre',
        'AboutTranslation' => 'Русский перевод Андрей Гуселетов',
        'AboutDesign' => 'Łukasz Kowalczk (Qoolman): Skin Designer
Логотипы и вэб-дизайн : le Spektre',

        'ToolbarRandom' => 'Сегодня вечером',
        
        'UnsavedCollection' => 'Unsaved Collection',
        'ModelsSelect' => 'Выберите тип коллекции',
        'ModelsPersonal' => 'Персональные модели',
        'ModelsDefault' => 'По-умолчанию',
        'ModelsList' => 'Определение коллекции',
        'ModelSettings' => 'настройки коллекции',
        'ModelNewType' => 'новый тип коллекции',
        'ModelName' => 'Имя нового типа коллекции:',
		'ModelFields' => 'Fields',
		'ModelOptions'	=> 'Options',
		'ModelFilters'	=> 'Filters',
        'ModelNewField' => 'Новое поле',
        'ModelFieldInformation' => 'Информация',
        'ModelFieldName' => 'Метка:',
        'ModelFieldType' => 'Тип:',
        'ModelFieldGroup' => 'Группа:',
        'ModelFieldValues' => 'Значения',
        'ModelFieldInit' => 'По-умолчанию:',
        'ModelFieldMin' => 'Минимум:',
        'ModelFieldMax' => 'Максимум:',
        'ModelFieldList' => 'Список значений:',
        'ModelFieldListLegend' => '<i>Разделённые запятой</i>',
        'ModelFieldDisplayAs' => 'Display as:',
        'ModelFieldDisplayAsText' => 'Text',
        'ModelFieldDisplayAsGraphical' => 'Rating Control',
        'ModelFieldTypeShortText' => 'Короткое описание текст',
        'ModelFieldTypeLongText' => 'Длинное описание',
        'ModelFieldTypeYesNo' => 'Да/Нет',
        'ModelFieldTypeNumber' => 'Число',
        'ModelFieldTypeDate' => 'Дата',
        'ModelFieldTypeOptions' => 'Предопределённый список значений',
        'ModelFieldTypeImage' => 'Изображение',
        'ModelFieldTypeSingleList' => 'Простой список',
        'ModelFieldTypeFile' => 'Файл',
        'ModelFieldTypeFormatted' => 'Dependant on other fields',
        'ModelFieldParameters' => 'Параметры',
        'ModelFieldHasHistory' => 'Использовать историю',
        'ModelFieldFlat' => 'Отображать на одной строке',
        'ModelFieldStep' => 'Шаг увеличения:',
        'ModelFieldFileFormat' => 'Формат файла:',
        'ModelFieldFileFile' => 'Простой файл',
        'ModelFieldFileImage' => 'Изображение',
        'ModelFieldFileVideo' => 'Видео',
        'ModelFieldFileAudio' => 'Аудио',
        'ModelFieldFileProgram' => 'Программа',
        'ModelFieldFileUrl' => 'URL',
        'ModelFieldFileEbook' => 'Ebook',
        'ModelOptionsFields' => 'Использовать поля',
        'ModelOptionsFieldsAuto' => 'Автоматически',
        'ModelOptionsFieldsNone' => 'Нет',
        'ModelOptionsFieldsTitle' => 'Как заголовок',
        'ModelOptionsFieldsId' => 'Как идентифекатор',
        'ModelOptionsFieldsCover' => 'Как обложку',
        'ModelOptionsFieldsPlay' => 'Для кнопки Воспроизведение',
        'ModelCollectionSettings' => 'Настройки коллекции',
        'ModelCollectionSettingsLending' => 'Предмет может быть дан взаймы',
        'ModelCollectionSettingsTagging' => 'Items can be tagged',
        'ModelFilterActivated' => 'Должно быть в строке поиска',
        'ModelFilterComparison' => 'Сравнение',
        'ModelFilterContain' => 'Содержит',
        'ModelFilterDoesNotContain' => 'Does not contain',
        'ModelFilterRegexp' => 'Regular expression',
        'ModelFilterRange' => 'Диапазон',
        'ModelFilterNumeric' => 'ИСпользовать цифровое сравнение',
        'ModelFilterQuick' => 'Создать бытрый фильтр',
        'ModelTooltipName' => 'Используйте имя для того чтобы потом можно было использовать эту модель в других коллекция. Оставьте значение по-умолчанию, для того чтобы сохранить модель только в самой коллекции.',
        'ModelTooltipLabel' => 'Поле имени так как оно будет отображено',
        'ModelTooltipGroup' => 'Используется для группировки полей. Элементы без значений здесь будут в группе по-умолчанию.',
        'ModelTooltipHistory' => 'Должно ли введенное значение сохраняться в списке ассоциированном с полем',
        'ModelTooltipFormat' => 'Формат используется для определения действия которое происходит при нажатии кнопки Воспроизведение',
        'ModelTooltipLending' => 'Тут будут добавлены некоторые поля для управления займами',
        'ModelTooltipTagging' => 'This will add some fields to manage tags',
        'ModelTooltipNumeric' => 'Должны ли значения считаться цифрами при сравнении',
        'ModelTooltipQuick' => 'Это добавит подменю в фильтры',

        'ResultsTitle' => 'Выберите фильм', # Accepts model codes
        'ResultsNextTip' => 'искать на следующем сайте',
        'ResultsPreview' => 'Предпросмотр',
        'ResultsInfo' => 'You can add multiple items to the collection by holding down the Ctrl or the Shift key and selecting them', # Accepts model codes
        
        'OptionsTitle' => 'Предпочтения',
		'OptionsExpertMode' => 'Expert Mode',
        'OptionsPrograms' => 'Specify applications to use for different media, leave blank to use system defaults',
        'OptionsBrowser' => 'Вэб браузер',
        'OptionsPlayer' => 'Видео проигрыватель',
        'OptionsAudio' => 'Аудио проигрыватель',
        'OptionsImageEditor' => 'Image editor',
        'OptionsCdDevice' => 'CD device',
        'OptionsImages' => 'Директория с изображения',
        'OptionsUseRelativePaths' => 'Использовать относительные пути для изображений',
        'OptionsLayout' => 'Расположение',
        'OptionsStatus' => 'Отображать строку статуса',
        'OptionsUseStars' => 'Use stars to display ratings',
        'OptionsWarning' => 'Внимание : изменения на этой вкладке не будут применыны до перезагрузки приложения.',
        'OptionsRemoveConfirm' => 'Спрашивать подтверждение перед удалением фильма',
        'OptionsAutoSave' => 'Автоматически сохранять коллекцию',
        'OptionsAutoLoad' => 'Загружать предыдущую коллекцию при старте',
        'OptionsSplash' => 'Показывать стартовый экран',
        'OptionsTearoffMenus' => 'Enable tear-off menus',
        'OptionsSpellCheck' => 'Use spelling checker for long text fields',
        'OptionsProgramTitle' => 'Выберите программу',
		'OptionsPlugins' => 'Сайт с которого нужно получать данные',
		'OptionsAskPlugins' => 'Спрашивать (Все сайты)',
		'OptionsPluginsMulti' => 'Несколько сайтов',
		'OptionsPluginsMultiAsk' => 'Спрашивать (Несколько сайтов)',
        'OptionsPluginsMultiPerField' => 'Несколько сайтов (per field)',
        'OptionsPluginsMultiPerFieldWindowTitle' => 'Many sites per field order selection',
        'OptionsPluginsMultiPerFieldDesc' => 'For each selected field we will return the first non empty information beginning from left',
        'OptionsPluginsMultiPerFieldFirst' => 'First',
        'OptionsPluginsMultiPerFieldLast' => 'Last',
        'OptionsPluginsMultiPerFieldRemove' => 'Remove',
        'OptionsPluginsMultiPerFieldClearSelected' => 'Empty selected field list',
		'OptionsPluginsList' => 'Задать список',
        'OptionsAskImport' => 'Выберите поля для импортирования',
		'OptionsProxy' => 'Использовать прокси',
		'OptionsCookieJar' => 'Use this cookie jar file',
        'OptionsLang' => 'Язык',
        'OptionsMain' => 'Основные',
        'OptionsPaths' => 'Пути',
        'OptionsInternet' => 'Интернет',
        'OptionsConveniences' => 'Возможности',
        'OptionsDisplay' => 'Отображение',
        'OptionsToolbar' => 'Панель инструментов',
        'OptionsToolbars' => {0 => 'Нет', 1 => 'Маленькая', 2 => 'Большая', 3 => 'System setting'},
        'OptionsToolbarPosition' => 'Позиция',
        'OptionsToolbarPositions' => {0 => 'Вверху', 1 => 'Внизу', 2 => 'Слева', 3 => 'Справа'},
        'OptionsExpandersMode' => 'Expanders too long',
        'OptionsExpandersModes' => {'asis' => 'Do nothing', 'cut' => 'Cut', 'wrap' => 'Line wrap'},
        'OptionsDateFormat' => 'Date Format',
        'OptionsDateFormatTooltip' => 'Format is the one used by strftime(3). Default is %d/%m/%Y',
        'OptionsView' => 'Вид',
        'OptionsViews' => {0 => 'Текст', 1 => 'Картинка', 2 => 'Детально'},
        'OptionsColumns' => 'Колонки',
        'OptionsMailer' => 'Почтовый сервер',
        'OptionsSMTP' => 'Сервер',
        'OptionsFrom' => 'Ваш e-mail',
        'OptionsTransform' => 'Помещать артикли в конце названия',
        'OptionsArticles' => 'Артикли (разделённые запятой)',
        'OptionsSearchStop' => 'Разрешить прерывать поиск',
        'OptionsBigPics' => 'Use big pictures when available',
        'OptionsAlwaysOriginal' => 'Использовать основной заголовок вместо оригинального, если он отсутствует',
        'OptionsRestoreAccelerators' => 'Restore accelerators',
        'OptionsHistory' => 'Размер истории',
        'OptionsClearHistory' => 'Очистить историю',
		'OptionsStyle' => 'Шкура',
        'OptionsDontAsk' => 'Больше не спрашивать',
        'OptionsPathProgramsGroup' => 'Приложения',
        'OptionsProgramsSystem' => 'Use programs defined by system',
        'OptionsProgramsUser' => 'Use specified programs',
        'OptionsProgramsSet' => 'Set programs',
        'OptionsPathImagesGroup' => 'Изображения',
        'OptionsInternetDataGroup' => 'Импорт данных',
        'OptionsInternetSettingsGroup' => 'Настройки',
        'OptionsDisplayInformationGroup' => 'Информация',
        'OptionsDisplayArticlesGroup' => 'Статьи',
        'OptionsImagesDisplayGroup' => 'Отобразить',
        'OptionsImagesStyleGroup' => 'Стиль',
        'OptionsDetailedPreferencesGroup' => 'Предпочтения',
        'OptionsFeaturesConveniencesGroup' => 'Соглашения',
        'OptionsPicturesFormat' => 'Префикс для использования в изображениях:',
        'OptionsPicturesFormatInternal' => 'gcstar__',
        'OptionsPicturesFormatTitle' => 'Заголовок или имя ассоциированного элемента ',
        'OptionsPicturesWorkingDir' => '%WORKING_DIR% or . will be replaced with collection directory (use only on beginning of path)',
        'OptionsPicturesFileBase' => '%FILE_BASE% will be replaced by collection file name without suffix (.gcs)',
        'OptionsPicturesWorkingDirError' => '%WORKING_DIR% could only be used on the beginning of the path for pictures',
        'OptionsConfigureMailers' => 'Настройка почтовой программы',

        'ImagesOptionsButton' => 'Настройки',
        'ImagesOptionsTitle' => 'Настройки для списка изображений',
        'ImagesOptionsSelectColor' => 'Выберите цвет',
        'ImagesOptionsUseOverlays' => 'Use image overlays',
        'ImagesOptionsBg' => 'Фон',
        'ImagesOptionsBgPicture' => 'Выберите фоновое изображение',
        'ImagesOptionsFg'=> 'Выделение',
        'ImagesOptionsBgTooltip' => 'Изменить цвет фона',
        'ImagesOptionsFgTooltip'=> 'Изменить цвет выделения',
        'ImagesOptionsResizeImgList' => 'Automatically change number of columns',
        'ImagesOptionsAnimateImgList' => 'Use animations',
        'ImagesOptionsSizeLabel' => 'Размер',
        'ImagesOptionsSizeList' => {0 => 'Очень маленькое', 1 => 'Маленькое', 2 => 'Среднее', 3 => 'Большое', 4 => 'Очень большое'},
        'ImagesOptionsSizeTooltip' => 'Выберите размер изображеня',
		        
        'DetailedOptionsTitle' => 'Настройки для детализированного списка',
        'DetailedOptionsImageSize' => 'Размер изображения',
        'DetailedOptionsGroupItems' => 'Группировать элементы по',
        'DetailedOptionsSecondarySort' => 'Sort field for children',
		'DetailedOptionsFields' => 'Выберите поля для отображения',
        'DetailedOptionsGroupedFirst' => 'Keep together orphaned items',
        'DetailedOptionsAddCount' => 'Add number of elements on categories',

        'ExtractButton' => 'Информация',
        'ExtractTitle' => 'Информация из видеофайла',
        'ExtractImport' => 'Использовать значения',

        'FieldsListOpen' => 'Загрузить список полей из файла',
        'FieldsListSave' => 'Сохранить список полей в файл',
        'FieldsListError' => 'Этот список полей не может быть использован с данным типом коллекции',
        'FieldsListIgnore' => '--- Ignore',

        'ExportTitle' => 'Экспортировать список фильмов',
        'ExportFilter' => 'Экспортировать только показанные фильмы',
        'ExportFieldsTitle' => 'Поля для экспорта',
        'ExportFieldsTip' => 'Выберите поля которые вы хотите экспортировать',
        'ExportWithPictures' => 'Скопировать изображения в под-директорию',
        'ExportSortBy' => 'Sort by',
        'ExportOrder' => 'Order',

        'ImportListTitle' => 'Импортировать другой список фильмоа',
        'ImportExportData' => 'Данные',
        'ImportExportFile' => 'Файл',
        'ImportExportFieldsUnused' => 'Неиспользуемые поля',
        'ImportExportFieldsUsed' => 'Используемые поля',
        'ImportExportFieldsFill' => 'Добавить все',
        'ImportExportFieldsClear' => 'Удалить все',
        'ImportExportFieldsEmpty' => 'Вы должны выбрать по карйней мере одно поле',
        'ImportExportFileEmpty' => 'Вы должны указать имя файла',
        'ImportFieldsTitle' => 'Поля для экспорта',
        'ImportFieldsTip' => 'Выберите поля которые вы хотите экспортировать',
        'ImportNewList' => 'Создать новую коллекцию',
        'ImportCurrentList' => 'Добавить к текущей коллекции',
        'ImportDropError' => 'Произошла ошибка в процессе открытия, по крайней мере в одном файле. Будет загружен предыдущий список.',
        'ImportGenerateId' => 'Generate identifier for each item',

        'FileChooserOpenFile' => 'Пожалуйста, выберите файл',
        'FileChooserDirectory' => 'Directory',
        'FileChooserOpenDirectory' => 'Выберите директорию',
        'FileChooserOverwrite' => 'Такой файл уже существует. Вы хотите перезаписать его?',
        'FileAllFiles' => 'All Files',
        'FileVideoFiles' => 'Video Files',
        'FileEbookFiles' => 'Ebook Files',
        'FileAudioFiles' => 'Audio Files',
        'FileGCstarFiles' => 'GCstar Collections',

        'PanelCompact' => 'Компактно',
        'PanelReadOnly' => 'Только для чтения',
        'PanelForm' => 'Вкладки',

        'PanelSearchButton' => 'Получить информацию',
        'PanelSearchTip' => 'Искать в Инетрнет информацию по этому заголовку',
        'PanelSearchContextChooseOne' => 'Choose a site ...',
        'PanelSearchContextMultiSite' => 'Use "Many sites"',
        'PanelSearchContextMultiSitePerField' => 'Use "Many sites per field"',
        'PanelSearchContextOptions' => 'Change options ...',
        'PanelImageTipOpen' => 'Щёлкните на картинке для выбора другой.',
        'PanelImageTipView' => 'Нажмите на картинке для просмотра её в оригинальном размере.',
        'PanelImageTipMenu' => ' Правый щелчок - еще опции',
        'PanelImageTitle' => 'Выберите картинку',
        'PanelImageNoImage' => 'No image',
        'PanelSelectFileTitle' => 'Выберите файл',
        'PanelLaunch' => 'Launch',        
        'PanelRestoreDefault' => 'Restore default',
        'PanelRefresh' => 'Update',
        'PanelRefreshTip' => 'Update information from web',

        'PanelFrom' =>'От',
        'PanelTo' =>'Куда',

        'PanelWeb' => 'Смотреть информацию',
        'PanelWebTip' => 'Посмотреть информацию в Интернет об этом фильме', # Accepts model codes
        'PanelRemoveTip' => 'Удалить текущий фильм', # Accepts model codes

        'PanelDateSelect' => 'Выберите дату',
        'PanelNobody' => 'Никто',
        'PanelUnknown' => 'Неизвестно',
        'PanelAdded' => 'Добавить дату',
        'PanelRating' => 'Рейтинг',
        'PanelPressRating' => 'Press Rating',
        'PanelLocation' => 'Размещение',

        'PanelLending' => 'На руках',
        'PanelBorrower' => 'Должник',
        'PanelLendDate' => 'С ',
        'PanelHistory' => 'История',
        'PanelReturned' => 'Фильм возвращён', # Accepts model codes
        'PanelReturnDate' => 'Дата возврата',
        'PanelLendedYes' => 'Взято напрокат',
        'PanelLendedNo' => 'Доступно',

        'PanelTags' => 'Tags',
        'PanelFavourite' => 'Favourite',
        'TagsAssigned' => 'Assigned Tags', 

        'PanelUser' => 'User fields',

        'CheckUndef' => 'Или',
        'CheckYes' => 'Да',
        'CheckNo' => 'Нет',

        'ToolbarAll' => 'Показать все',
        'ToolbarAllTooltip' => 'Показать все фильмы',
        'ToolbarGroupBy' => 'Группировать по',
        'ToolbarGroupByTooltip' => 'Выберите поля для группировки элементов в списке',
        'ToolbarQuickSearch' => 'Quick search',
        'ToolbarQuickSearchLabel' => 'Search',
        'ToolbarQuickSearchTooltip' => 'Select the field to search in. Enter the search terms and press Enter',
        'ToolbarSeparator' => ' Separator',
        
        'PluginsTitle' => 'Искать фильм',
        'PluginsQuery' => 'Запрос',
        'PluginsFrame' => 'Искать сайт',
        'PluginsLogo' => 'Лого',
        'PluginsName' => 'Имя',
        'PluginsSearchFields' => 'Поля для поиска',
        'PluginsAuthor' => 'Автор',
        'PluginsLang' => 'Язык',
        'PluginsUseSite' => 'Использовать выбранный сайт для последующего поиска',
        'PluginsPreferredTooltip' => 'Site recommended by GCstar',
        'PluginDisabled' => 'Disabled',

        'BorrowersTitle' => 'Конфигурация должника',
        'BorrowersList' => 'Должники',
        'BorrowersName' => 'Имя',
        'BorrowersEmail' => 'E-mail',
        'BorrowersAdd' => 'Добавить',
        'BorrowersRemove' => 'Удалить',
        'BorrowersEdit' => 'Редактировать',
        'BorrowersTemplate' => 'Шаблон для почты',
        'BorrowersSubject' => 'Тема письма',
        'BorrowersNotice1' => '%1 будет заменено именем должника',
        'BorrowersNotice2' => '%2 будет заменено названием фильма',
        'BorrowersNotice3' => '%3 будет заменено датой',

        'BorrowersImportTitle' => 'Импорт информации о должниках',
        'BorrowersImportType' => 'Формат файла:',
        'BorrowersImportFile' => 'Файл:',

        'BorrowedTitle' => 'На руках', # Accepts model codes
        'BorrowedDate' => 'С ',
        'BorrowedDisplayInPanel' => 'Show item in main window', # Accepts model codes

        'MailTitle' => 'Послать e-mail',
        'MailFrom' => 'От: ',
        'MailTo' => 'Кому: ',
        'MailSubject' => 'Тема: ',
        'MailSmtpError' => 'Проблемы в процессе присоединения к SMTP серверу',
        'MailSendmailError' => 'Проблемы при запуске sendmail',

        'SearchTooltip' => 'Искать все фильмы', # Accepts model codes
        'SearchTitle' => 'Поиск фильмов', # Accepts model codes
        'SearchNoField' => 'No field have been selected for the search box.
Add some of them in the Filters tab of the collection settings.',

        'QueryReplaceField' => 'Поле для замены',
        'QueryReplaceOld' => 'Текущее имя',
        'QueryReplaceNew' => 'Новое имя',
        'QueryReplaceLaunch' => 'Заменить',
        
        'ImportWindowTitle' => 'Выберите поля для импортирования',
        'ImportViewPicture' => 'Посмотреть картинку',
        'ImportSelectAll' => 'Выбрать все',
        'ImportSelectNone' => 'Сбросить выбор',

        'MultiSiteTitle' => 'Использовать для поиска сайты',
        'MultiSiteUnused' => 'Неиспользуемые плагины',
        'MultiSiteUsed' => 'Использовать плагины',
        'MultiSiteLang' => 'Заполнить список Английскими плагинами',
        'MultiSiteEmptyError' => 'У вас пустой список сайтов',
        'MultiSiteClear' => 'Очистить список',
        
        'DisplayOptionsTitle' => 'Отображать',
        'DisplayOptionsAll' => 'Выбрать все',
        'DisplayOptionsSearch' => 'Кнопки поиска',

        'GenresTitle' => 'Конвертация жанров',
        'GenresCategoryName' => 'Использовать жанр',
        'GenresCategoryMembers' => 'Заменить на',
        'GenresLoad' => 'Загрузить список',
        'GenresExport' => 'Сохранить список жанров в файл',
        'GenresModify' => 'Редактировать конвертацию',

        'PropertiesName' => 'Имя коллекции',
        'PropertiesLang' => 'Language code',
        'PropertiesOwner' => 'Владелец',
        'PropertiesEmail' => 'E-mail',
        'PropertiesDescription' => 'Описание',
        'PropertiesFile' => 'Информация о файле',
        'PropertiesFilePath' => 'Полный путь',
        'PropertiesItemsNumber' => 'Количество элементов', # Accepts model codes
        'PropertiesFileSize' => 'Размер',
        'PropertiesFileSizeSymbols' => ['Байт', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
        'PropertiesCollection' => 'Свойства коллекции',
        'PropertiesDefaultPicture' => 'Default picture',

        'MailProgramsTitle' => 'Программы для отправки почты',
        'MailProgramsName' => 'Имя',
        'MailProgramsCommand' => 'Коммандная строка',
        'MailProgramsRestore' => 'Восстановить значения по-умолчанию',
        'MailProgramsAdd' => 'Добавить программу',
        'MailProgramsInstructions' => 'В коммандной строке делаются такие подстановки:
 %f заменяется e-mail адресом пользователя.
 %t заменяется адресом получателя.
 %s заменяется темой сообщения.
 %b заменяется телом сообщения.',

        'BookmarksBookmarks' => 'Закладки',
        'BookmarksFolder' => 'Директория',
        'BookmarksLabel' => 'Метка',
        'BookmarksPath' => 'Путь',
        'BookmarksNewFolder' => 'Новая папка',

        'AdvancedSearchType' => 'Тип поиска',
        'AdvancedSearchTypeAnd' => 'Элементы удовлетворяющие всем критериям', # Accepts model codes
        'AdvancedSearchTypeOr' => 'Элементы удовлетворяющие по крайней мере одному критерию', # Accepts model codes
        'AdvancedSearchCriteria' => 'Критерий',
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
