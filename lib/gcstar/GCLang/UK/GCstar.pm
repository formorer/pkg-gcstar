{
    package GCLang::UK;

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

        'LangName' => 'Ukrainian',
        
        'Separator' => ': ',
        
        'Warning' => '<b>Попередження</b>:
        
Інформація, звантажена з веб-сайтів (за допомогою 
пошукових втулків) призначена <b>лише для особистого використання</b>.

Заборонений будь-який перерозподіл без
<b>явного дозволу сайту</b>.

Щоб визначити, який сайт володіє інформацією,
можна скористатись <b>кнопкою на вкладці подробиць про фільм</b>.',
        
        'AllItemsFiltered' => 'Не знайдено відповідностей вашому запиту', # Accepts model codes
        
#Installation
        'InstallDirInfo' => 'Встановити до ',
        'InstallMandatory' => 'Обов\'язкові компоненти',
        'InstallOptional' => 'Додаткові компоненти',
        'InstallErrorMissing' => 'Помилка : Потрібно встановити наступні компоненти Perl: ',
        'InstallPrompt' => 'Основна тека для встановлення [/usr/local]: ',
        'InstallEnd' => 'Кінець встановлення',
        'InstallNoError' => 'Немає помилок',
        'InstallLaunch' => 'Для використання цього додатку ви можете запустити ',
        'InstallDirectory' => 'Основна таке',
        'InstallTitle' => 'Встановлення GCstar',
        'InstallDependencies' => 'Залежності',
        'InstallPath' => 'Шлях',
        'InstallOptions' => 'Опції',
        'InstallSelectDirectory' => 'Виберіть основну теку для встановлення',
        'InstallWithClean' => 'Усунути файли, знайдені у теці встановлення',
        'InstallWithMenu' => 'Додати GCstar меню Додатки',
        'InstallNoPermission' => 'Помилка: Ви не маєте дозволу для запису в обрану теку',
        'InstallMissingMandatory' => 'Обов\'язкові залежності відсутні. Ви не можете встановити GCstar поки вони не будуть додані до системи.',
        'InstallMissingOptional' => 'Деякі додаткові залежності відсутні. Їх список нижче. GCstar можна встановити, але деякі можливості будуть недоступні.',
        'InstallMissingNone' => 'Усі залежності забезпечено. Ви можете продовжити встановлення GCstar.',
        'InstallOK' => 'OK',
        'InstallMissing' => 'Відсутні',
        'InstallMissingFor' => 'Відсутні для',
        'InstallCleanDirectory' => 'Усунення файлів GCstar з теки: ',
        'InstallCopyDirectory' => 'Копіювання файлів до теки: ',
        'InstallCopyDesktop' => 'Копіювання файлів стільниці: ',

#Update
        'UpdateUseProxy' => 'Вживати проксі (просто натисніть ввід, якщо немає): ',
        'UpdateNoPermission' => 'Немає дозволу запису до цієї теки: ',
        'UpdateNone' => 'Оновлень не знайдено',
        'UpdateFileNotFound' => 'Файл не знайдений',

#Splash
        'SplashInit' => 'Ініціалізування',
        'SplashLoad' => 'Завантаження колекції',
        'SplashDisplay' => 'Показ колекції',
        'SplashSort' => 'Сортування колекції',
        'SplashDone' => 'Готово',

#Import from GCfilms
        'GCfilmsImportQuestion' => 'Здається ви раніше користувались GCfilms. Що ви хочете імпортувати з GCfilms до GCstar (це не вплине на GCfilms якщо ви і далі хочете ним користуватись)?',
        'GCfilmsImportOptions' => 'Налаштування',
        'GCfilmsImportData' => 'Список фільмів',

#Menus
        'MenuFile' => '_Файл',
            'MenuNewList' => '_Нова колекція',
            'MenuStats' => 'Statistics',
            'MenuHistory' => '_Останні колекції',
            'MenuLend' => 'Показати _позичені', # Accepts model codes
            'MenuImport' => '_Імпорт',	
            'MenuExport' => '_Експорт',
            'MenuAddItem' => '_Add Items', # Accepts model codes
    
        'MenuEdit'  => '_Редагування',
            'MenuDuplicate' => '_Дублювати фільм', # Accepts model codes
            'MenuDuplicatePlural' => 'Du_plicate Items', # Accepts model codes
            'MenuEditSelectAllItems' => 'Select _All Items', # Accepts model codes
            'MenuEditDeleteCurrent' => '_Усунути фільм', # Accepts model codes
            'MenuEditDeleteCurrentPlural' => '_Remove Items', # Accepts model codes  
            'MenuEditFields' => '_Змінити поля колекції',
            'MenuEditLockItems' => 'За_блокувати колекцію',
    
        'MenuDisplay' => 'Ф_ільтр',
            'MenuSavedSearches' => 'Saved searches',
                'MenuSavedSearchesSave' => 'Save current search',
                'MenuSavedSearchesEdit' => 'Modify saved searches',
            'MenuAdvancedSearch' => '_Розширений пошук',
            'MenuViewAllItems' => 'Показати _всі записи', # Accepts model codes
            'MenuNoFilter' => '_Усі',
    
        'MenuConfiguration' => '_Параметри',
            'MenuDisplayMenu' => 'Display',
                'MenuDisplayFullScreen' => 'Full screen',
                'MenuDisplayMenuBar' => 'Menus',
                'MenuDisplayToolBar' => 'Toolbar',
                'MenuDisplayStatusBar' => 'Bottom bar',
            'MenuDisplayOptions' => '_Відображувана інформація',
            'MenuBorrowers' => '_Боржники',
            'MenuToolbarConfiguration' => '_Toolbar controls',
            'MenuDefaultValues' => 'Default values for new item', # Accepts model codes
            'MenuGenresConversion' => 'Зміна _Жанру',
        
        'MenuBookmarks' => '_Мої колекції',
            'MenuBookmarksAdd' => '_Додати поточну колекцію',
            'MenuBookmarksEdit' => '_Редагувати закладки',

        'MenuHelp' => '_Допомога',
            'MenuHelpContent' => '_Зміст',
            'MenuAllPlugins' => 'Перегляд _втулків',
            'MenuBugReport' => '_Надіслати звіт про помилку',
            'MenuAbout' => '_Про GCstar',
    
        'MenuNewWindow' => 'Показати запис у _новому вікні', # Accepts model codes
        'MenuNewWindowPlural' => 'Show Items in _New Window', # Accepts model codes
        
        'ContextExpandAll' => 'Розгорнути усі',
        'ContextCollapseAll' => 'Згорнути усі',
        'ContextChooseImage' => 'Choose _Image',
        'ContextOpenWith' => 'Open Wit_h',
        'ContextImageEditor' => 'Image Editor',
        'ContextImgFront' => 'Front',
        'ContextImgBack' => 'Back',
        'ContextChooseFile' => 'Choose a File',
        'ContextChooseFolder' => 'Choose a Folder',
        
        'DialogEnterNumber' => 'Будь ласка, введіть значення',

        'RemoveConfirm' => 'Ви дійсно хочете усунути цей запис?', # Accepts model codes
        'RemoveConfirmPlural' => 'Do you really want to remove these items?', # Accepts model codes
        'DefaultNewItem' => 'Новий запис', # Accepts model codes
        'NewItemTooltip' => 'Додати новий запис', # Accepts model codes
        'NoItemFound' => 'Нічого не знайдено. Ви хочете шукати на іншому сайті?',
        'OpenList' => 'Будь ласка, оберіть колекцію',
        'SaveList' => 'Будь ласка, виберіть куди зберегти колекцію',
        'SaveListTooltip' => 'Зберегти поточну колекцію',
        'SaveUnsavedChanges' => 'Є незбережені зміни у вашій колекції. Ви хочете їх зберегти?',
        'SaveDontSave' => 'Не зберігати',
        'PreferencesTooltip' => 'Налаштуйте ваші уподобання',
        'ViewTooltip' => 'Змініть показ колекції',
        'PlayTooltip' => 'Програвати відео, зв\'язане з записом', # Accepts model codes
        'PlayFileNotFound' => 'File to launch was not found in this location:',
        'PlayRetry' => 'Retry',

        'StatusSave' => 'Збереження...',
        'StatusLoad' => 'Завантаження...',
        'StatusSearch' => 'Виконується пошук...',
        'StatusGetInfo' => 'Отримання інформації...',
        'StatusGetImage' => 'Отримання зображення...',
                
        'SaveError' => 'Неможливо зберегти список записів. Будь ласка, перевірте права доступу та наявність вільного місця на диску.',
        'OpenError' => 'Неможливо зберегти список записів. Будь ласка, перевірте права доступу.',
		'OpenFormatError' => 'Неможливо відкрити список записів. Формат може бути неправильним.',
        'OpenVersionWarning' => 'Collection was created with a more recent version of GCstar. If you save it, you may loose some data.',
        'OpenVersionQuestion' => 'Do you still want to continue?',
        'ImageError' => 'Обрана тека для збереження зображень некоректна. Будь ласка, виберіть іншу.',
        'OptionsCreationError'=> 'Неможливо створити файл опцій: ',
        'OptionsOpenError'=> 'Неможливо відкрити файл опцій: ',
        'OptionsSaveError'=> 'Неможливо зберегти файл опцій: ',
        'ErrorModelNotFound' => 'Model not found: ',
        'ErrorModelUserDir' => 'User defined models are in: ',
        
        'RandomTooltip' => 'Що подивитись сьогодні ввечері ?',
        'RandomError'=> 'У вас немає вибраних записів', # Accepts model codes
        'RandomEnd'=> 'Немає більше записів', # Accepts model codes
        'RandomNextTip'=> 'Наступна пропозиція',
        'RandomOkTip'=> 'Прийняти цей запис',
        
        'AboutTitle' => 'Про GCstar',
        'AboutDesc' => 'Менеджер колекцій',
        'AboutVersion' => 'Версія',
        'AboutTeam' => 'Команда',
        'AboutWho' => 'Tian: Керівник проекту, програміст
Nyall Dawson (Zombiepig): програміст
TPF: програміст        
Adolfo González : програміст
',
        'AboutLicense' => 'Розповсюджується згідно умов GNU GPL
Права на логотипи належать le Spektre',
        'AboutTranslation' => 'Український переклад виконав Ailandar',
        'AboutDesign' => 'Łukasz Kowalczk (Qoolman): Skin Designer
Логотип та вебдизайн le Spektre',

        'ToolbarRandom' => 'Цього вечора',

        'UnsavedCollection' => 'Unsaved Collection',
        'ModelsSelect' => 'Виберіть тип колекції',
        'ModelsPersonal' => 'Особисті моделі',
        'ModelsDefault' => 'Типові моделі',
        'ModelsList' => 'Опис колекції',
        'ModelSettings' => 'Налаштування колекції',
        'ModelNewType' => 'Новий тип колекції',
        'ModelName' => 'Ім\'я типу колекції:',
		'ModelFields' => 'Поля',
		'ModelOptions'	=> 'Опції',
		'ModelFilters'	=> 'Фільтри',
        'ModelNewField' => 'Нове поле',
        'ModelFieldInformation' => 'Інформація',
        'ModelFieldName' => 'Мітка:',
        'ModelFieldType' => 'Тип:',
        'ModelFieldGroup' => 'Група:',
        'ModelFieldValues' => 'Значення',
        'ModelFieldInit' => 'Типово:',
        'ModelFieldMin' => 'Мінімум:',
        'ModelFieldMax' => 'Максимум:',
        'ModelFieldList' => 'Список значень:',
        'ModelFieldListLegend' => '<i>Розділені комами</i>',
        'ModelFieldDisplayAs' => 'Display as:',
        'ModelFieldDisplayAsText' => 'Text',
        'ModelFieldDisplayAsGraphical' => 'Rating Control',
        'ModelFieldTypeShortText' => 'Короткий текст',
        'ModelFieldTypeLongText' => 'Довгий текст',
        'ModelFieldTypeYesNo' => 'Так/Ні',
        'ModelFieldTypeNumber' => 'Номер',
        'ModelFieldTypeDate' => 'Дата',
        'ModelFieldTypeOptions' => 'Напередвизначений список значень',
        'ModelFieldTypeImage' => 'Зображення',
        'ModelFieldTypeSingleList' => 'Простий список',
        'ModelFieldTypeFile' => 'Файл',
        'ModelFieldTypeFormatted' => 'Залежне від інших полів',
        'ModelFieldParameters' => 'Параметри',
        'ModelFieldHasHistory' => 'Використовувати історію',
        'ModelFieldFlat' => 'Показувати в один рядок',
        'ModelFieldStep' => 'Крок збільшення:',
        'ModelFieldFileFormat' => 'Формат файлу:',
        'ModelFieldFileFile' => 'Прстий файл',
        'ModelFieldFileImage' => 'Зображення',
        'ModelFieldFileVideo' => 'Відео',
        'ModelFieldFileAudio' => 'Аудіо',
        'ModelFieldFileProgram' => 'Програма',
        'ModelFieldFileUrl' => 'URL',
        'ModelFieldFileEbook' => 'Ebook',
        'ModelOptionsFields' => 'Використовувати поля',
        'ModelOptionsFieldsAuto' => 'Автоматично',
        'ModelOptionsFieldsNone' => 'Ніяк',
        'ModelOptionsFieldsTitle' => 'Як заголовок',
        'ModelOptionsFieldsId' => 'Як ідентифікатор',
        'ModelOptionsFieldsCover' => 'Як обкладинку',
        'ModelOptionsFieldsPlay' => 'Для кнопки Програти',
        'ModelCollectionSettings' => 'Налаштування колекції',
        'ModelCollectionSettingsLending' => 'Об\'єкти можна позичати',
        'ModelCollectionSettingsTagging' => 'Записам можна призначати бирки',
        'ModelFilterActivated' => 'Може бути в рядку пошуку',
        'ModelFilterComparison' => 'Порівняння',
        'ModelFilterContain' => 'Містить',
        'ModelFilterDoesNotContain' => 'Does not contain',
        'ModelFilterRegexp' => 'Regular expression',
        'ModelFilterRange' => 'Діапазон',
        'ModelFilterNumeric' => 'Порівняння є числовим',
        'ModelFilterQuick' => 'Створити швидкий фільтр',
        'ModelTooltipName' => 'Використовувати ім\'я щоб вживати цю модель в інших колекціях. Якщо порожнє, налаштування будуть збережені безпосередньо в самій колекції',
        'ModelTooltipLabel' => 'Ім\'я поля, як воно буде показуватись',
        'ModelTooltipGroup' => 'Вживається для групування полів. Записи без даного значення можуть бути в типовій групі',
        'ModelTooltipHistory' => 'Попередньо введені значення повинні зберігатись у списку зв\'язаних з полем',
        'ModelTooltipFormat' => 'Цей формат вживається для визначення дії при відкритті файлу кнопкою Програти',
        'ModelTooltipLending' => 'Це додає декілька полів для керування видачами',
        'ModelTooltipTagging' => 'Це додає декілька полів для керування бирками',
        'ModelTooltipNumeric' => 'Значення можуть використовуватись як числа при порівнянні',
        'ModelTooltipQuick' => 'Це додає підменю у меню Фільтри',
        
        'ResultsTitle' => 'Виберіть об\'єкт', # Accepts model codes
        'ResultsNextTip' => 'Шукати на наступному сайті',
        'ResultsPreview' => 'Попередній перегляд',
        'ResultsInfo' => 'Ви можете додавати декілька записів до колекції утримуючи клавішу Ctrl або Shift та вибираючи записи', # Accepts model codes
        
        'OptionsTitle' => 'Параметри',
        'OptionsExpertMode' => 'Expert Mode',
        'OptionsPrograms' => 'Specify applications to use for different media, leave blank to use system defaults',
        'OptionsBrowser' => 'Веб оглядач',
        'OptionsPlayer' => 'Відео програвач',
        'OptionsAudio' => 'Аудіо програвач',
        'OptionsImageEditor' => 'Image editor',
        'OptionsCdDevice' => 'CD device',
        'OptionsImages' => 'Тека зображень',
        'OptionsUseRelativePaths' => 'Вживати відносні шляхи для зображень',
        'OptionsLayout' => 'Вигляд',
        'OptionsStatus' => 'Показувати рядок стану',
        'OptionsUseStars' => 'Use stars to display ratings',
        'OptionsWarning' => 'Попередження: Зміни на цій сторінці будуть застосовані після перезавантаження програми.',
        'OptionsRemoveConfirm' => 'Питати підтвердження перед видаленням записів',
        'OptionsAutoSave' => 'Автоматично зберігати колекцію',
        'OptionsAutoLoad' => 'Завантажувати попередню колекцію при запуску',
        'OptionsSplash' => 'Показувати екран заставки',
        'OptionsTearoffMenus' => 'Enable tear-off menus',
        'OptionsSpellCheck' => 'Використовувати перевірку правопису для великих текстових полів',
        'OptionsProgramTitle' => 'Оберіть програму для використання',
		'OptionsPlugins' => 'Отримувати дані з сайту',
		'OptionsAskPlugins' => 'Питати (Всі сайти)',
		'OptionsPluginsMulti' => 'Декілька сайтів',
		'OptionsPluginsMultiAsk' => 'Питати (Декілька сайтів)',
        'OptionsPluginsMultiPerField' => 'Декілька сайтів (per field)',
        'OptionsPluginsMultiPerFieldWindowTitle' => 'Many sites per field order selection',
        'OptionsPluginsMultiPerFieldDesc' => 'For each selected field we will return the first non empty information beginning from left',
        'OptionsPluginsMultiPerFieldFirst' => 'First',
        'OptionsPluginsMultiPerFieldLast' => 'Last',
        'OptionsPluginsMultiPerFieldRemove' => 'Remove',
        'OptionsPluginsMultiPerFieldClearSelected' => 'Empty selected field list',
		'OptionsPluginsList' => 'Встановити список',
        'OptionsAskImport' => 'Виберіть поля для імпортування',
		'OptionsProxy' => 'Використовувати проксі',
		'OptionsCookieJar' => 'Використовувати цей cookie jar файл',
        'OptionsLang' => 'Мова',
        'OptionsMain' => 'Головне',
        'OptionsPaths' => 'Шляхи',
        'OptionsInternet' => 'Інтернет',
        'OptionsConveniences' => 'Функції',
        'OptionsDisplay' => 'Вигляд',
        'OptionsToolbar' => 'Панель інструментів',
        'OptionsToolbars' => {0 => 'Немає', 1 => 'Малі значки', 2 => 'Великі значки', 3 => 'System setting'},
        'OptionsToolbarPosition' => 'Розміщення',
        'OptionsToolbarPositions' => {0 => 'Вгорі', 1 => 'Внизу', 2 => 'Ліворуч', 3 => 'Праворуч'},
        'OptionsExpandersMode' => 'Розширювачі занадто довгі',
        'OptionsExpandersModes' => {'asis' => 'Не робити нічого', 'cut' => 'Обрізати', 'wrap' => 'Перенести рядок'},
        'OptionsDateFormat' => 'Формат дати',
        'OptionsDateFormatTooltip' => 'Формат - один з тих, що використовуються функцією strftime(3). Типово це %d/%m/%Y',
        'OptionsView' => 'Список записів',
        'OptionsViews' => {0 => 'Текст', 1 => 'Зображення', 2 => 'Детальний'},
        'OptionsColumns' => 'Колонки',
        'OptionsMailer' => 'Відсилати через',
        'OptionsSMTP' => 'Сервер',
        'OptionsFrom' => 'Ваш e-mail',
        'OptionsTransform' => 'Розміщувати артиклі в кінці заголовків',
        'OptionsArticles' => 'Артиклі (Розділені комами)',
        'OptionsSearchStop' => 'Дозволяти переривання пошуку',
        'OptionsBigPics' => 'Use big pictures when available',
        'OptionsAlwaysOriginal' => 'Використовувати головний заголовок як оригінальний, якщо останній відсутній',
        'OptionsRestoreAccelerators' => 'Відновити акселератори',
        'OptionsHistory' => 'Розмір історії',
        'OptionsClearHistory' => 'Очистити історію',
		'OptionsStyle' => 'Вигляд',
        'OptionsDontAsk' => 'Більше не питати',
        'OptionsPathProgramsGroup' => 'Додатки',
        'OptionsProgramsSystem' => 'Використовувати програми, визначені системою',
        'OptionsProgramsUser' => 'Використовувати інші програми',
        'OptionsProgramsSet' => 'Обрати програми',
        'OptionsPathImagesGroup' => 'Зображення',
        'OptionsInternetDataGroup' => 'Імпорт даних',
        'OptionsInternetSettingsGroup' => 'Налаштування',
        'OptionsDisplayInformationGroup' => 'Показ інформації',
        'OptionsDisplayArticlesGroup' => 'Статті',
        'OptionsImagesDisplayGroup' => 'Показати',
        'OptionsImagesStyleGroup' => 'Стиль',
        'OptionsDetailedPreferencesGroup' => 'Уподобання',
        'OptionsFeaturesConveniencesGroup' => 'Зручності',
        'OptionsPicturesFormat' => 'Префікс для використання у зображеннях:',
        'OptionsPicturesFormatInternal' => 'gcstar__',
        'OptionsPicturesFormatTitle' => 'Заголовок або ім\'я зв\'язаного запису',
        'OptionsPicturesWorkingDir' => '%WORKING_DIR% або . буде замінене текою колекції (вживається лише на початку шляху)',
        'OptionsPicturesFileBase' => '%FILE_BASE% буде замінене іменем колекції без суфіксу (.gcs)',
        'OptionsPicturesWorkingDirError' => '%WORKING_DIR% може вживатись тільки на початку шляху до зображень',
        'OptionsPicturesWorkingDirError' => '%WORKING_DIR% може вживатись тільки на початку шляху до зображень',
        'OptionsConfigureMailers' => 'Налаштування поштових програм',

        'ImagesOptionsButton' => 'Налаштування',
        'ImagesOptionsTitle' => 'Налаштування для списку зображень',
        'ImagesOptionsSelectColor' => 'Оберіть колір',
        'ImagesOptionsUseOverlays' => 'Використовувати покриття зображень',
        'ImagesOptionsBg' => 'Тло',
        'ImagesOptionsBgPicture' => 'Вживати фонове зображення',
        'ImagesOptionsFg'=> 'Відбір',
        'ImagesOptionsBgTooltip' => 'Змінити колір тла',
        'ImagesOptionsFgTooltip'=> 'Змінити колір відбору',
        'ImagesOptionsResizeImgList' => 'Automatically change number of columns',
        'ImagesOptionsAnimateImgList' => 'Use animations',
        'ImagesOptionsSizeLabel' => 'Розмір',
        'ImagesOptionsSizeList' => {0 => 'Дуже малий', 1 => 'Малий', 2 => 'Середній', 3 => 'Великий', 4 => 'Дуже великий'},
        'ImagesOptionsSizeTooltip' => 'Виберіть розмір зображення',
		        
        'DetailedOptionsTitle' => 'Налаштування для детального списку',
        'DetailedOptionsImageSize' => 'Розмір зображень',
        'DetailedOptionsGroupItems' => 'Групувати записи за',
        'DetailedOptionsSecondarySort' => 'Сортувати поля для дітей',
		'DetailedOptionsFields' => 'Обрати поля для відображення',
        'DetailedOptionsGroupedFirst' => 'Збирати разом осиротілі записи',
        'DetailedOptionsAddCount' => 'Додати номер елемента в категорії',

        'ExtractButton' => 'Інформація',
        'ExtractTitle' => 'Інформація про файл',
        'ExtractImport' => 'Вживати значення',

        'FieldsListOpen' => 'Завантажити список полів з файлу',
        'FieldsListSave' => 'Зберегти список полів до файлу',
        'FieldsListError' => 'Цей список полів не може використовуватись з даним видом колекцій',
        'FieldsListIgnore' => '--- Ігнорувати',

        'ExportTitle' => 'Експортування списку записів',
        'ExportFilter' => 'Експортувати тільки відображувані записи',
        'ExportFieldsTitle' => 'Поля для експортування',
        'ExportFieldsTip' => 'Оберіть поля, які ви хочете експортувати',
        'ExportWithPictures' => 'Копіювати зображення у підтеку',
        'ExportSortBy' => 'Сортувати за',
        'ExportOrder' => 'Order',

        'ImportListTitle' => 'Імпортувати інший список записів',
        'ImportExportData' => 'Дані',
        'ImportExportFile' => 'Файл',
        'ImportExportFieldsUnused' => 'Невикористовувані поля',
        'ImportExportFieldsUsed' => 'Використовувані поля',
        'ImportExportFieldsFill' => 'Додати всі',
        'ImportExportFieldsClear' => 'Усунути всі',
        'ImportExportFieldsEmpty' => 'Ви повинні обрати хоча б одне поле',
        'ImportExportFileEmpty' => 'Ви повинні визначити ім\'я файлу',
        'ImportFieldsTitle' => 'Поля для імпорту',
        'ImportFieldsTip' => 'Оберіть поля, які ви хочете імпортувати',
        'ImportNewList' => 'Створити нову колекцію',
        'ImportCurrentList' => 'Додати до поточної колекції',
        'ImportDropError' => 'Виникла помилка при відкритті щонайменше одного файлу. Попередній список буде перевантажений.',
        'ImportGenerateId' => 'Створити ідентифікатор для кожного запису',

        'FileChooserOpenFile' => 'Будь ласка, оберіть файл для використання',
        'FileChooserDirectory' => 'Directory',
        'FileChooserOpenDirectory' => 'Оберіть теку',
        'FileChooserOverwrite' => 'Це поле уже існує. Ви хочете його переписати?',
        'FileAllFiles' => 'All Files',
        'FileVideoFiles' => 'Video Files',
        'FileEbookFiles' => 'Ebook Files',
        'FileAudioFiles' => 'Audio Files',
        'FileGCstarFiles' => 'GCstar Collections',

        #Some default panels
        'PanelCompact' => 'Компактний',
        'PanelReadOnly' => 'Лише для читання',
        'PanelForm' => 'Вкладки',

        'PanelSearchButton' => 'Отримати інформацію',
        'PanelSearchTip' => 'Пошук в інтернеті інформації за цим іменем',
        'PanelSearchContextChooseOne' => 'Choose a site ...',
        'PanelSearchContextMultiSite' => 'Use "Many sites"',
        'PanelSearchContextMultiSitePerField' => 'Use "Many sites per field"',
        'PanelSearchContextOptions' => 'Change options ...',
        'PanelImageTipOpen' => 'Клацніть на зображенні для вибору іншого.',
        'PanelImageTipView' => 'Клацніть на зображенні для перегляду його справжнього розміру.',
        'PanelImageTipMenu' => ' Клацніть правою клавішею для інших варіантів.',
        'PanelImageTitle' => 'Вибрати зображення',
        'PanelImageNoImage' => 'Немає зображення',
        'PanelSelectFileTitle' => 'Оберіть файл',
        'PanelLaunch' => 'Launch',        
        'PanelRestoreDefault' => 'Відновити типову',
        'PanelRefresh' => 'Update',
        'PanelRefreshTip' => 'Update information from web',

        'PanelFrom' =>'Від',
        'PanelTo' =>'До',

        'PanelWeb' => 'Перегляд інформації',
        'PanelWebTip' => 'Перегляд інформації в інтернеті про даний запис', # Accepts model codes
        'PanelRemoveTip' => 'Усунути поточний запис', # Accepts model codes

        'PanelDateSelect' => 'Обрати',
        'PanelNobody' => 'Ніхто',
        'PanelUnknown' => 'Невідомий',
        'PanelAdded' => 'Дата додавання',
        'PanelRating' => 'Оцінка',
        'PanelPressRating' => 'Press Rating',
        'PanelLocation' => 'Місце',

        'PanelLending' => 'Позичка',
        'PanelBorrower' => 'Боржник',
        'PanelLendDate' => 'Позичив',
        'PanelHistory' => 'Історія позичок',
        'PanelReturned' => 'Річ повернута', # Accepts model codes
        'PanelReturnDate' => 'Дата повернення',
        'PanelLendedYes' => 'Позичено',
        'PanelLendedNo' => 'Доступно',

        'PanelTags' => 'Бирки',
        'PanelFavourite' => 'Улюблене',
        'TagsAssigned' => 'Призначені бирки', 

        'PanelUser' => 'User fields',

        'CheckUndef' => 'Будь-які',
        'CheckYes' => 'Так',
        'CheckNo' => 'Ні',

        'ToolbarAll' => 'Показати всі',
        'ToolbarAllTooltip' => 'Показати всі записи',
        'ToolbarGroupBy' => 'Групувати за',
        'ToolbarGroupByTooltip' => 'Оберіть поле для групування за ним записів у списку',
        'ToolbarQuickSearch' => 'Quick search',
        'ToolbarQuickSearchLabel' => 'Search',
        'ToolbarQuickSearchTooltip' => 'Select the field to search in. Enter the search terms and press Enter',
        'ToolbarSeparator' => ' Separator',
        
        'PluginsTitle' => 'Пошук запису',
        'PluginsQuery' => 'Запит',
        'PluginsFrame' => 'Пошук на сайті',
        'PluginsLogo' => 'Логотип',
        'PluginsName' => 'Ім\'я',
        'PluginsSearchFields' => 'Поля пошуку',
        'PluginsAuthor' => 'Автор',
        'PluginsLang' => 'Мова',
        'PluginsUseSite' => 'Використовувати поточний сайт для майбутніх пошуків',
        'PluginsPreferredTooltip' => 'Site recommended by GCstar',
        'PluginDisabled' => 'Disabled',

        'BorrowersTitle' => 'Налаштування боржників',
        'BorrowersList' => 'Боржники',
        'BorrowersName' => 'Ім\'я',
        'BorrowersEmail' => 'E-mail',
        'BorrowersAdd' => 'Додати',
        'BorrowersRemove' => 'Усунути',
        'BorrowersEdit' => 'Редагувати',
        'BorrowersTemplate' => 'Шаблон листа',
        'BorrowersSubject' => 'Тема листа',
        'BorrowersNotice1' => '%1 буде замінене на ім\'я боржника',
        'BorrowersNotice2' => '%2 буде замінене на назву речі',
        'BorrowersNotice3' => '%3 буде замінене на дату позички',

        'BorrowersImportTitle' => 'Імпорт інформації про боржників',
        'BorrowersImportType' => 'Формат файлу:',
        'BorrowersImportFile' => 'Файл:',

        'BorrowedTitle' => 'Позичені речі', # Accepts model codes
        'BorrowedDate' => 'З',
        'BorrowedDisplayInPanel' => 'Show item in main window', # Accepts model codes

        'MailTitle' => 'Надіслати e-mail',
        'MailFrom' => 'Від: ',
        'MailTo' => 'Кому: ',
        'MailSubject' => 'Тема: ',
        'MailSmtpError' => 'Проблема підключення до SMTP сервера',
        'MailSendmailError' => 'Проблема запуску sendmail',

        'SearchTooltip' => 'Шукати всі записи', # Accepts model codes
        'SearchTitle' => 'Пошук запису', # Accepts model codes
        'SearchNoField' => 'No field have been selected for the search box.
Add some of them in the Filters tab of the collection settings.',

        'QueryReplaceField' => 'Поля для заміни',
        'QueryReplaceOld' => 'Поточне значення',
        'QueryReplaceNew' => 'Нове значення',
        'QueryReplaceLaunch' => 'Замінити',
        
        'ImportWindowTitle' => 'Виберіть поля для імпорту',
        'ImportViewPicture' => 'Перегляд зображення',
        'ImportSelectAll' => 'Вибрати всі',
        'ImportSelectNone' => 'Не вибрати жодного',

        'MultiSiteTitle' => 'Сайти для використання при пошуку',
        'MultiSiteUnused' => 'Невикористовувані втулки',
        'MultiSiteUsed' => 'Використовувати втулки',
        'MultiSiteLang' => 'Заповніть список англійськими втулками',
        'MultiSiteEmptyError' => 'У вас порожній список сайтів',
        'MultiSiteClear' => 'Очистити список',
        
        'DisplayOptionsTitle' => 'Елементи для відображення',
        'DisplayOptionsAll' => 'Вибрати всі',
        'DisplayOptionsSearch' => 'Кнопка пошуку',

        'GenresTitle' => 'Зміна жанру',
        'GenresCategoryName' => 'Використовується жанр',
        'GenresCategoryMembers' => 'Жанр для заміни',
        'GenresLoad' => 'Завантажити список',
        'GenresExport' => 'Зберегти список до файлу',
        'GenresModify' => 'Редагувати заміну',

        'PropertiesName' => 'Назва колекції',
        'PropertiesLang' => 'Language code',
        'PropertiesOwner' => 'Власник',
        'PropertiesEmail' => 'Email',
        'PropertiesDescription' => 'Опис',
        'PropertiesFile' => 'Інформація про файл',
        'PropertiesFilePath' => 'Повний шлях',
        'PropertiesItemsNumber' => 'Кількість записів', # Accepts model codes
        'PropertiesFileSize' => 'Розмір',
        'PropertiesFileSizeSymbols' => ['Байтів', 'Кб', 'Мб', 'Гб', 'Тб', 'PB', 'EB', 'ZB', 'YB'],
        'PropertiesCollection' => 'Властивості колекції',
        'PropertiesDefaultPicture' => 'Default picture',

        'MailProgramsTitle' => 'Програми для надсилання пошти',
        'MailProgramsName' => 'Назва',
        'MailProgramsCommand' => 'Командкий рядок',
        'MailProgramsRestore' => 'Відновити типові',
        'MailProgramsAdd' => 'Додати програму',
        'MailProgramsInstructions' => 'В командному рядку роляться деякі заміни:
 %f замінюється на e-mail адресу користувача.
 %t замінюється на адресу одержувача.
 %s замінюється на тему повідомлення.
 %b замінюється на тіло повідомлення.',

        'BookmarksBookmarks' => 'Закладки',
        'BookmarksFolder' => 'Теки',
        'BookmarksLabel' => 'Мітка',
        'BookmarksPath' => 'Шлях',
        'BookmarksNewFolder' => 'Нова тека',

        'AdvancedSearchType' => 'Тип пошуку',
        'AdvancedSearchTypeAnd' => 'Записи, що відповідають всім критеріям', # Accepts model codes
        'AdvancedSearchTypeOr' => 'Записи, що відповідають хоча б одному критерію', # Accepts model codes
        'AdvancedSearchCriteria' => 'Критерій',
        'AdvancedSearchAnyField' => 'Будь-яке поле',
        'AdvancedSearchSaveTitle' => 'Save search',
        'AdvancedSearchSaveName' => 'Name',
        'AdvancedSearchSaveOverwrite' => 'A saved search already exists with that name. Please use a different one.',
        'AdvancedSearchUseCase' => 'Case sensitive',
        'AdvancedSearchIgnoreDiacritics' => 'Ignore accents and other diacritics',
 
        'BugReportSubject' => 'Звіт про помилку, згенерований GCstar',
        'BugReportVersion' => 'Версія',
        'BugReportPlatform' => 'Операційна система',
        'BugReportMessage' => 'Повідомлення про помилку',
        'BugReportInformation' => 'Додаткова інформація',

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
