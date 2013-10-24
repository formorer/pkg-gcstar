{
    package GCLang::PL;

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

        'LangName' => 'Polski',
        
        'Separator' => ': ',
        
        'Warning' => '<b>Ostrzeżenie</b>:
        
Informacje pobrane z internetu (za pomocą wtyczki 
do wyszukiwania) są <b>tylko do użytku prywatnego</b>.

Jakakolwiek dystrybucja pobranych danych bez
autoryzacji, <b>zabroniona</b>.

Aby dowiedzieć się skąd pochodzą dane pobrane
można użyć <b>przycisku pod szczegółami</b>.',
        
        'AllItemsFiltered' => 'Brak pozycji pasujących do filtru', # Accepts model codes
        
#Installation
        'InstallDirInfo' => 'Instalacja w ',
        'InstallMandatory' => 'Pakiety wymagane',
        'InstallOptional' => 'Pakiety opcjonalne',
        'InstallErrorMissing' => 'Błąd : Następujące pakiety Perl, są wymagane: ',
        'InstallPrompt' => 'Katalog główny dla instalacji [/usr/local]: ',
        'InstallEnd' => 'Koniec instalacji',
        'InstallNoError' => 'Brak błędu',
        'InstallLaunch' => 'Może być uruchomiona tylko jedna kopia',
        'InstallDirectory' => 'Katalog główny',
        'InstallTitle' => 'Instalacja GCstar',
        'InstallDependencies' => 'Elementy',
        'InstallPath' => 'Ścieżka',
        'InstallOptions' => 'Opcje',
        'InstallSelectDirectory' => 'Wybierz katalog główny dla programu',
        'InstallWithClean' => 'Usuń pliku w katalogu instalacyjnym',
        'InstallWithMenu' => 'Dodaj GCstar do Menu aplikacji',
        'InstallNoPermission' => 'Błąd: Nie masz uprawnień do zapisywania w wybranym katalogu',
        'InstallMissingMandatory' => 'Brakuje wymaganych elementów. Nie będziesz w stanie zainstalować GCstar dopóki ich nie zainstalujesz.',
        'InstallMissingOptional' => 'Brakuje elementów opcjonalnych. Lista znajduje sie poniżej. Niektóre funkcje GCstar mogą nie działać, lub działać niepoprawnie.',
        'InstallMissingNone' => 'Możesz kontynuować instalację GCstar.',
        'InstallOK' => 'OK',
        'InstallMissing' => 'Brak',
        'InstallMissingFor' => 'Brak',
        'InstallCleanDirectory' => 'Usuwanie plików GCstar z katalogu: ',
        'InstallCopyDirectory' => 'Kopiowanie plików w katalogu: ',
        'InstallCopyDesktop' => 'Kopiowanie plików pulpitu w: ',

#Update
        'UpdateUseProxy' => 'Wybierz serwer proxy (naciśnij Enter aby pominąć): ', 
        'UpdateNoPermission' => 'Nie masz uprawnień do zapisu w tym katalogu: ', 
        'UpdateNone' => 'Nie znaleziono aktualizacji', 
        'UpdateFileNotFound' => 'Nie znaleziono pliku',

#Splash
        'SplashInit' => 'Uruchamianie',
        'SplashLoad' => 'Ładowanie Zbioru',
        'SplashDisplay' => 'Wyświetlanie Zbioru',
        'SplashSort' => 'Sortowanie Zbioru',
        'SplashDone' => 'Gotowe',

#Import from GCfilms
        'GCfilmsImportQuestion' => 'Wydaje się, że poprzednio używałeś GCfilms. Co chciałbyś wczytać z GCfilms do GCstar (nie będzie miało to znaczenia dla GCfilms jeśli nadal zechcesz go używać)?',
        'GCfilmsImportOptions' => 'Ustawienia',
        'GCfilmsImportData' => 'Lista filmów',

#Menus
        'MenuFile' => 'Plik',
            'MenuNewList' => 'Nowy Zbiór',
            'MenuStats' => 'Statistics',
            'MenuHistory' => 'Ostatnio używany Zbiór',
            'MenuLend' => 'Wyświetl wypożyczone', # Accepts model codes
            'MenuImport' => 'Import',	
            'MenuExport' => 'Eksport',
            'MenuAddItem' => '_Add Items', # Accepts model codes
    
        'MenuEdit'  => 'Edycja',
            'MenuDuplicate' => 'Kopiuj bieżącą pozycję',, # Accepts model codes
            'MenuDuplicatePlural' => 'Du_plicate Items', # Accepts model codes
            'MenuEditSelectAllItems' => 'Select _All {X}', # Accepts model codes
            'MenuEditDeleteCurrent' => 'Usuń bieżącą pozycję',, # Accepts model codes
            'MenuEditDeleteCurrentPlural' => '_Remove Items', # Accepts model codes   
            'MenuEditFields' => 'Zmień pola Zbioru',
            'MenuEditLockItems' => 'Zablokuj Zbiory',
    
        'MenuDisplay' => 'Filtr',
            'MenuSavedSearches' => 'Zapisane wyszukiwania',
                 'MenuSavedSearchesSave' => 'Zapisz bieżące wyszukiwanie',
                 'MenuSavedSearchesEdit' => 'Edytuj zapisane wyszukiwania',
            'MenuAdvancedSearch' => 'Wyszukiwanie zaawansowane',
            'MenuViewAllItems' => 'Pokaż wszystkie pozycje', # Accepts model codes
            'MenuNoFilter' => 'Wszystkie',
    
        'MenuConfiguration' => 'Ustawienia',
            'MenuDisplayMenu' => 'Display',
                'MenuDisplayFullScreen' => 'Full screen',
                'MenuDisplayMenuBar' => 'Menus',
                'MenuDisplayToolBar' => 'Toolbar',
                'MenuDisplayStatusBar' => 'Bottom bar',
            'MenuDisplayOptions' => 'Wyświetlane informacje',
            'MenuBorrowers' => 'Dłużnicy',
            'MenuToolbarConfiguration' => 'Dos_tosuj pasek narzędzi',
            'MenuDefaultValues' => 'Default values for new item', # Accepts model codes
            'MenuGenresConversion' => 'Konwersja gatunków',
            
        'MenuBookmarks' => 'Ulubione',
            'MenuBookmarksAdd' => 'Dodaj bieżący Zbiór',
            'MenuBookmarksEdit' => 'Edytuj ulubione',

        'MenuHelp' => 'Pomoc',
            'MenuHelpContent' => 'Pomoc',
            'MenuAllPlugins' => 'Przegląd wtyczek',
            'MenuBugReport' => 'Zgłoś błąd',
            'MenuAbout' => 'O programie',
    
        'MenuNewWindow' => 'Pokaż w nowym oknie', # Accepts model codes
        'MenuNewWindowPlural' => 'Show Items in _New Window', # Accepts model codes
                
        'ContextExpandAll' => 'Rozwiń wszystkie',
        'ContextCollapseAll' => 'Zwiń wszystkie',
        'ContextChooseImage' => 'Wyb_ierz obraz',
        'ContextOpenWith' => 'O_twórz w',
        'ContextImageEditor' => 'Otwórz w edytorze graficznym',
        'ContextImgFront' => 'Przód',
        'ContextImgBack' => 'Tył',
        'ContextChooseFile' => 'Choose a File',
        'ContextChooseFolder' => 'Choose a Folder',
    
        'DialogEnterNumber' => 'Wprowadź wartość',

        'RemoveConfirm' => 'Czy naprawdę chcesz usunąć tą pozycję?', # Accepts model codes
        'RemoveConfirmPlural' => 'Do you really want to remove these items?', # Accepts model codes
        'DefaultNewItem' => 'Nowa pozycja', # Accepts model codes
        'NewItemTooltip' => 'Dodaj nową pozycję', # Accepts model codes
        'NoItemFound' => 'Nie znaleziono tej pozycji, czy chcesz przeszukać następną witrynę?',
        'OpenList' => 'Wybierz Zbiór',
        'SaveList' => 'Gdzie mam zapisać Zbiór?',
        'SaveListTooltip' => 'Zapisz Zbiór',
        'SaveUnsavedChanges' => 'Zmiany w Twoim Zbiorze nie zostały zapisane. Czy chcesz je zapisać?',
        'SaveDontSave' => 'Nie zapisuj',
        'PreferencesTooltip' => 'Ustaw swoje preferencje',
        'ViewTooltip' => 'Zmień sposób wyświetlania Zbioru',
        'PlayTooltip' => 'Odtwórz wideo połączone z filmem', # Accepts model codes
        'PlayFileNotFound' => 'W podanym miejscu nie ma pliku do odtworzenia:',
        'PlayRetry' => 'Ponów',

        'StatusSave' => 'Zapisuję...',
        'StatusLoad' => 'Wczytuję...',
        'StatusSearch' => 'Trwa wyszukiwanie...',
        'StatusGetInfo' => 'Pobieranie informacji...',
        'StatusGetImage' => 'Pobieranie zdjęcia...',

        'SaveError' => 'Nie mogę zapisać listy pozycji. Sprawdź uprawnienia lub wolne miejsce na dysku.',
        'OpenError' => 'Nie mogę odczytać listy pozycji. Sprawdź uprawnienia.',
        'OpenFormatError' => 'Nie mogę odczytać listy pozycji.',
        'OpenVersionWarning' => 'Zbiór został utworzony za pomocą nowszej wersji programu GCstar. Jeśli go zapiszesz możesz utracić część danych.',
        'OpenVersionQuestion' => 'Czy mimo to chcesz kontynuować?',
        'ImageError' => 'Wybrany katalog dla obrazów jest niewłaściwy. Wybierz inny.',
        'OptionsCreationError'=> 'Nie mogę stworzyć pliku konfiguracji: ',
        'OptionsOpenError'=> 'Nie mogę otworzyć pliku konfiguracji: ',
        'OptionsSaveError'=> 'Nie mogę zapisać pliku konfiguracji: ',
        'ErrorModelNotFound' => 'Nie znaleziono szablonu: ',
        'ErrorModelUserDir' => 'Szablony zdefiniowane przez użytkownika znajdują się w: ',

        'RandomTooltip' => 'Co by tu dziś ...?',
        'RandomError'=> 'Wszystko już było', # Accepts model codes
        'RandomEnd'=> 'Nie mam więcej propozycji', # Accepts model codes
        'RandomNextTip'=> 'Kolejna propozycja',
        'RandomOkTip'=> 'Wybierz',

        'AboutTitle' => 'O programie',
        'AboutDesc' => 'Menedżer Zbiorów Gtk2',
        'AboutVersion' => 'Wersja',
        'AboutTeam' => 'Organizacja',
        'AboutWho' => 'Christian Jodar (Tian): Project manager, Programmer
Nyall Dawson (Zombiepig): Programmer
TPF: Programmer
Adolfo González: Programmer
',
        'AboutLicense' => 'Rozpowszechniany na warunkach licencji GNU GPL
Logos Copyright le Spektre',
        'AboutTranslation' => 'Tłumaczenie: kepin & zomers, WG',
        'AboutDesign' => 'Łukasz Kowalczk (Qoolman): Skin Designer
Logo i webmaster: le Spektre',

        'ToolbarRandom' => 'Dziś wieczorem',

        'UnsavedCollection' => 'Zbiór nie zapisany',
        'ModelsSelect' => 'Wybierz typ zbioru',
        'ModelsPersonal' => 'Szablony osobiste',
        'ModelsDefault' => 'Szablony domyślne',
        'ModelsList' => 'Definiowanie zbioru',
        'ModelSettings' => 'Ustawienia zbioru',
        'ModelNewType' => 'Nowy typ zbioru',
        'ModelName' => 'Nazwa dla zbiorów tego typu:',
		'ModelFields' => 'Pola',
		'ModelOptions'	=> 'Opcje',
		'ModelFilters'	=> 'Filtry',
        'ModelNewField' => 'Nowe pole',
        'ModelFieldInformation' => 'Informacje',
        'ModelFieldName' => 'Etykieta:',
        'ModelFieldType' => 'Typ:',
        'ModelFieldGroup' => 'Grupa:',
        'ModelFieldValues' => 'Wartości',
        'ModelFieldInit' => 'Domyślna:',
        'ModelFieldMin' => 'Minimum:',
        'ModelFieldMax' => 'Maksimum:',
        'ModelFieldList' => 'Lista wartości:',
        'ModelFieldListLegend' => '<i>oddzielone przecinkami</i>',
        'ModelFieldDisplayAs' => 'Wyświetl jako:',
        'ModelFieldDisplayAsText' => 'Tekst',
        'ModelFieldDisplayAsGraphical' => 'Grafika',
        'ModelFieldTypeShortText' => 'Krótki tekst',
        'ModelFieldTypeLongText' => 'Długi tekst',
        'ModelFieldTypeYesNo' => 'Tak/Nie',
        'ModelFieldTypeNumber' => 'Liczba',
        'ModelFieldTypeDate' => 'Data',
        'ModelFieldTypeOptions' => 'Predefiniowana lista wartości',
        'ModelFieldTypeImage' => 'Obraz',
        'ModelFieldTypeSingleList' => 'Prosta lista',
        'ModelFieldTypeFile' => 'Plik',
        'ModelFieldTypeFormatted' => 'Zależne od innych pól',
        'ModelFieldParameters' => 'Parametry',
        'ModelFieldHasHistory' => 'Korzystaj z historii',
        'ModelFieldFlat' => 'Pokazuj w jednej linii',
        'ModelFieldStep' => 'Krok przyrostu:',
        'ModelFieldFileFormat' => 'Format pliku:',
        'ModelFieldFileFile' => 'Zwykły plik',
        'ModelFieldFileImage' => 'Obraz',
        'ModelFieldFileVideo' => 'Wideo',
        'ModelFieldFileAudio' => 'Audio',
        'ModelFieldFileProgram' => 'Program',
        'ModelFieldFileUrl' => 'URL',
        'ModelFieldFileEbook' => 'Ebook',
        'ModelOptionsFields' => 'Wykorzystane pola',
        'ModelOptionsFieldsAuto' => 'Automatycznie',
        'ModelOptionsFieldsNone' => 'Wcale',
        'ModelOptionsFieldsTitle' => 'Jako tytuł',
        'ModelOptionsFieldsId' => 'Jako identyfikator',
        'ModelOptionsFieldsCover' => 'Jako okładka',
        'ModelOptionsFieldsPlay' => 'Przycisk Odtwórz',
        'ModelCollectionSettings' => 'Ustawienia Zbioru',
        'ModelCollectionSettingsLending' => 'Pozycje mogą być pożyczane',
        'ModelCollectionSettingsTagging' => 'Można stosować znaczniki',
        'ModelFilterActivated' => 'Pole będzie szukane',
        'ModelFilterComparison' => 'Porównanie',
        'ModelFilterContain' => 'Zawiera',
        'ModelFilterDoesNotContain' => 'Nie zawiera',
        'ModelFilterRegexp' => 'Wyrażenie regularne',
        'ModelFilterRange' => 'W zakresie',
        'ModelFilterNumeric' => 'Porównanie jest numeryczne',
        'ModelFilterQuick' => 'Utwórz szybki filtr',
        'ModelTooltipName' => 'Podaj nazwę jeśli chciałbyś używać tego szablonu dla wielu zbiorów. Jeżeli jej nie podasz ustawienia będą przechowywane bezpośrednio w samym zbiorze',
        'ModelTooltipLabel' => 'Wyświetlana nazwa pola',
        'ModelTooltipGroup' => 'Używana do grupowania pól. Pozycje, dla których wartość ta nie będzie ustawiona znajdą się w grupie domyślnej',
        'ModelTooltipHistory' => 'Poprzednio wprowadzone wartości będą przechowywane w liście przypisanej do tego pola',
        'ModelTooltipFormat' => 'Ten format jest używany przy określaniu akcji otwarcia pliku przyciskiem Odtwórz',
        'ModelTooltipLending' => 'Dodaje kilka pól odnoszących się do pożyczania',
        'ModelTooltipTagging' => 'Dodaje kilka pól pozwalających na zarządzanie znacznikami',
        'ModelTooltipNumeric' => 'Wartości będą traktowane jako liczby przy porównaniu',
        'ModelTooltipQuick' => 'Dodaje podmenu w menu Filtrów',

        'ResultsTitle' => 'Wybierz pozycję', # Accepts model codes
        'ResultsNextTip' => 'Szukaj na następnej witrynie',
        'ResultsPreview' => 'Podgląd',
        'ResultsInfo' => 'Do Zbioru możesz dodać wiele pozycji jednocześnie, wybierając je trzymaj wciśnięty klawisz Ctrl lub Shift', # Accepts model codes
        
        'OptionsTitle' => 'Preferencje',
		'OptionsExpertMode' => 'Ustawienia zaawansowane',
        'OptionsPrograms' => 'Wybierz program do obsługi plików danego typu, puste pole spowoduje użycie aplikacji domyślnej',
        'OptionsBrowser' => 'Przeglądarka',
        'OptionsPlayer' => 'Odtwarzacz multimedialny',
        'OptionsAudio' => 'Odtwarzacz muzyczny',
        'OptionsImageEditor' => 'Edytor graficzny',
        'OptionsCdDevice' => 'Urządzenie CD',
        'OptionsImages' => 'Katalog obrazów',
        'OptionsUseRelativePaths' => 'Używaj względnych ścieżek dla obrazów',
        'OptionsLayout' => 'Układ',
        'OptionsStatus' => 'Wyświetlaj pasek stanu',
        'OptionsUseStars' => 'Use stars to display ratings',
        'OptionsWarning' => 'Ostrzeżenie: Zmiany zostaną wprowadzone dopiero po ponownym uruchomieniu programu.',
        'OptionsRemoveConfirm' => 'Potwierdzaj przed usunięciem pozycji',
        'OptionsAutoSave' => 'Autozapis Zbioru',
        'OptionsAutoLoad' => 'Po uruchomieniu załaduj poprzedni Zbiór',
        'OptionsSplash' => 'Pokazuj logo przy uruchamianiu',
        'OptionsTearoffMenus' => 'Włącz odrywane menu',
        'OptionsSpellCheck' => 'Zastosuj korektor pisowni w długich polach tekstowych',
        'OptionsProgramTitle' => 'Wybierz program którego chcesz używać',
		'OptionsPlugins' => 'Witryna do pobierania danych',
		'OptionsAskPlugins' => 'Pytaj (Wszystkie witryny)',
		'OptionsPluginsMulti' => 'Wiele witryn',
		'OptionsPluginsMultiAsk' => 'Pytaj (Wiele witryn)',
        'OptionsPluginsMultiPerField' => 'Wiele witryn (per field)',
        'OptionsPluginsMultiPerFieldWindowTitle' => 'Many sites per field order selection',
        'OptionsPluginsMultiPerFieldDesc' => 'For each selected field we will return the first non empty information beginning from left',
        'OptionsPluginsMultiPerFieldFirst' => 'First',
        'OptionsPluginsMultiPerFieldLast' => 'Last',
        'OptionsPluginsMultiPerFieldRemove' => 'Remove',
        'OptionsPluginsMultiPerFieldClearSelected' => 'Empty selected field list',
		'OptionsPluginsList' => 'Ustaw listę',
        'OptionsAskImport' => 'Wybierz pola do importu',
		'OptionsProxy' => 'Używaj proxy',
		'OptionsCookieJar' => 'Użyj tego pliku JAR',
        'OptionsLang' => 'Język',
        'OptionsMain' => 'Główny',
        'OptionsPaths' => 'Ścieżki',
        'OptionsInternet' => 'Internet',
        'OptionsConveniences' => 'Opcje',
        'OptionsDisplay' => 'Wyświetl',
        'OptionsToolbar' => 'Menu podręczne',
        'OptionsToolbars' => {0 => 'Brak', 1 => 'Małe', 2 => 'Duże', 3 => 'Ustawienia systemowe'},
        'OptionsToolbarPosition' => 'Pozycja',
        'OptionsToolbarPositions' => {0 => 'Góra', 1 => 'Dół', 2 => 'Lewa', 3 => 'Prawa'},
        'OptionsExpandersMode' => 'Rozmiar listy zbyt duży',
        'OptionsExpandersModes' => {'asis' => 'Nie zmieniaj', 'cut' => 'Przytnij', 'wrap' => 'Zawiń linie'},
        'OptionsDateFormat' => 'Format daty',
        'OptionsDateFormatTooltip' => 'Format stosowany w strftime(3). Domyślnie %d/%m/%Y',
        'OptionsView' => 'Lista pozycji',
        'OptionsViews' => {0 => 'Tekst', 1 => 'Obrazki', 2 => 'Szczegóły'},
        'OptionsColumns' => 'Kolumny',
        'OptionsMailer' => 'Program pocztowy',
        'OptionsSMTP' => 'Serwer',
        'OptionsFrom' => 'Twój adres e-mail',
        'OptionsTransform' => 'Umieszczaj rodzajniki na końcu',
        'OptionsArticles' => 'Rodzajniki',
        'OptionsSearchStop' => 'Zezwalaj na zatrzymanie szukania',
        'OptionsBigPics' => 'Użyj dużego zdjęcia jeśli to możliwe',
        'OptionsAlwaysOriginal' => 'Używaj głównego tytułu jako tytułu oryginalnego',
        'OptionsRestoreAccelerators' => 'Przywróć domyślne skróty',
        'OptionsHistory' => 'Rozmiar historii',
        'OptionsClearHistory' => 'Czyść historie',
		'OptionsStyle' => 'Skórka',
        'OptionsDontAsk' => 'Nie pytaj więcej',
        'OptionsPathProgramsGroup' => 'Aplikacje',
        'OptionsProgramsSystem' => 'Użyj programów zdefiniowanych przez system',
        'OptionsProgramsUser' => 'Użyj wybranych programów',
        'OptionsProgramsSet' => 'Wybierz programy',
        'OptionsPathImagesGroup' => 'Obrazy',
        'OptionsInternetDataGroup' => 'Import danych',
        'OptionsInternetSettingsGroup' => 'Ustawienia',
        'OptionsDisplayInformationGroup' => 'Wyświetlanie informacji',
        'OptionsDisplayArticlesGroup' => 'Rodzajniki',
        'OptionsImagesDisplayGroup' => 'Wyświetlanie',
        'OptionsImagesStyleGroup' => 'Styl',
        'OptionsDetailedPreferencesGroup' => 'Ustawienia',
        'OptionsFeaturesConveniencesGroup' => 'Ułatwienia',
        'OptionsPicturesFormat' => 'Prefiks dla obrazów:',
        'OptionsPicturesFormatInternal' => 'gcstar__',
        'OptionsPicturesFormatTitle' => 'Tytuł lub nazwa odpowiedniej pozycji',
        'OptionsPicturesWorkingDir' => '%WORKING_DIR% lub . będzie zastąpione katalogiem Zbioru (stosuj tylko na początku ścieżki)',
        'OptionsPicturesFileBase' => '%FILE_BASE% będzie zastąpione nazwą pliku Zbioru bez rozszerzenia (.gcs)',
        'OptionsPicturesWorkingDirError' => '%WORKING_DIR% może być stosowane wyłącznie na początku ścieżki dla obrazów',
        'OptionsConfigureMailers' => 'Skonfiguruj programy pocztowe',

        'ImagesOptionsButton' => 'Ustawienia',
        'ImagesOptionsTitle' => 'Ustawienia listy obrazków',
        'ImagesOptionsSelectColor' => 'Wybierz kolor',
        'ImagesOptionsUseOverlays' => 'Zastosuj nakładki',
        'ImagesOptionsBg' => 'Tło',
        'ImagesOptionsBgPicture' => 'Obrazek jako tło',
        'ImagesOptionsFg'=> 'Zaznaczenie',
        'ImagesOptionsBgTooltip' => 'Zmień kolor tła',
        'ImagesOptionsFgTooltip'=> 'Zmień kolor zaznaczenia',
        'ImagesOptionsResizeImgList' => 'Automatycznie ustal liczbę kolumn',
        'ImagesOptionsAnimateImgList' => 'Use animations',
        'ImagesOptionsSizeLabel' => 'Rozmiar',
        'ImagesOptionsSizeList' => {0 => 'Bardzo mały', 1 => 'Mały', 2 => 'Średni', 3 => 'Duży', 4 => 'Ogromny'},
        'ImagesOptionsSizeTooltip' => 'Wybierz rozmiar obrazka',

        'DetailedOptionsTitle' => 'Ustawienia dokładnej listy',
        'DetailedOptionsImageSize' => 'Rozmiar obrazków',
        'DetailedOptionsGroupItems' => 'Grupuj pozycje według',
        'DetailedOptionsSecondarySort' => 'Dodatkowo sortuj według',
        'DetailedOptionsFields' => 'Wybierz wyświetlane pola',
        'DetailedOptionsGroupedFirst' => 'Grupuj pozostałe pozycje',
        'DetailedOptionsAddCount' => 'Pokaż liczbę pozycji w grupie',

        'ExtractButton' => 'Informacje',
        'ExtractTitle' => 'Informacja o pliku wideo',
        'ExtractImport' => 'Używaj wartości',

        'FieldsListOpen' => 'Wczytaj listę pól z pliku',
        'FieldsListSave' => 'Zapisz listę pól do pliku',
        'FieldsListError' => 'Ta lista pól nie może być wykorzystana dla Zbioru tego rodzaju',
        'FieldsListIgnore' => '--- Ignore',

        'ExportTitle' => 'Eksportuj listę pozycji',
        'ExportFilter' => 'Eksportuj tylko wyświetlone pozycje',
        'ExportFieldsTitle' => 'Pola do wyeksportowania',
        'ExportFieldsTip' => 'Wybierz pola, które chcesz wyeksportować',
        'ExportWithPictures' => 'Kopiuj obrazy do podkatalogu',
        'ExportSortBy' => 'Sortuj według',
        'ExportOrder' => 'Kolejność',

        'ImportListTitle' => 'Importuj listę pozycji',
        'ImportExportData' => 'Dane',
        'ImportExportFile' => 'Plik',
        'ImportExportFieldsUnused' => 'Nieużywane pola',
        'ImportExportFieldsUsed' => 'Używane pola',
        'ImportExportFieldsFill' => 'Dodaj wszystkie',
        'ImportExportFieldsClear' => 'Usuń wszystkie',
        'ImportExportFieldsEmpty' => 'Musisz zaznaczyć chociaż jedno pole',
        'ImportExportFileEmpty' => 'Musisz określić nazwę pliku',
        'ImportFieldsTitle' => 'Pola do zaimportowania',
        'ImportFieldsTip' => 'Wybierz pola, które chcesz zaimportować',
        'ImportNewList' => 'Stwórz nowy Zbiór',
        'ImportCurrentList' => 'Dodaj do aktualnego Zbioru',
        'ImportDropError' => 'Jeden lub więcej z ładowanych plików spowodował błąd. Poprzednia lista zostanie przywrócona.',
        'ImportGenerateId' => 'Utwórz identyfikator dla każdej z pozycji',

        'FileChooserOpenFile' => 'Wybierz plik, który chcesz użyć',
        'FileChooserDirectory' => 'Katalog',
        'FileChooserOpenDirectory' => 'Wybierz katalog',
        'FileChooserOverwrite' => 'Plik już istnieje. Czy chcesz go zastąpić?',
        'FileAllFiles' => 'All Files',
        'FileVideoFiles' => 'Video Files',
        'FileEbookFiles' => 'Ebook Files',
        'FileAudioFiles' => 'Audio Files',
        'FileGCstarFiles' => 'GCstar Collections',

        'PanelCompact' => 'Kompaktowy',
        'PanelReadOnly' => 'Tylko do odczytu',
        'PanelForm' => 'Zakładki',

        'PanelSearchButton' => 'Pobierz informacje',
        'PanelSearchTip' => 'Szukaj w internecie informacji o tym tytule',
        'PanelSearchContextChooseOne' => 'Choose a site ...',
        'PanelSearchContextMultiSite' => 'Use "Many sites"',
        'PanelSearchContextMultiSitePerField' => 'Use "Many sites per field"',
        'PanelSearchContextOptions' => 'Change options ...',
        'PanelImageTipOpen' => 'Kliknij na zdjęciu aby wybrać inne.',
        'PanelImageTipView' => 'Kliknij na zdjęciu aby obejrzeć go w naturalnym rozmiarze.',
        'PanelImageTipMenu' => ' Prawy przycisk myszy - więcej opcji.',
        'PanelImageTitle' => 'Wybierz zdjęcie',
        'PanelImageNoImage' => 'Brak zdjęcia',
        'PanelSelectFileTitle' => 'Wybierz plik',
        'PanelLaunch' => 'Launch',        
        'PanelRestoreDefault' => 'Przywróć domyślne',
        'PanelRefresh' => 'Update',
        'PanelRefreshTip' => 'Update information from web',

        'PanelFrom' =>'Od',
        'PanelTo' =>'Do',

        'PanelWeb' => 'Sprawdź informacje',
        'PanelWebTip' => 'Sprawdź w sieci informacje o tej pozycji', # Accepts model codes
        'PanelRemoveTip' => 'Usuń bieżącą pozycję', # Accepts model codes

        'PanelDateSelect' => 'Wybierz datę',
        'PanelNobody' => 'Nikt',
        'PanelUnknown' => 'Nieznany',
        'PanelAdded' => 'Dodano',
        'PanelRating' => 'Ocena',
        'PanelPressRating' => 'Ocena prasy',
        'PanelLocation' => 'Lokalizacja',

        'PanelLending' => 'Pożyczanie',
        'PanelBorrower' => 'Dłużnik',
        'PanelLendDate' => 'Data pożyczenia',
        'PanelHistory' => 'Historia wypożyczania',
        'PanelReturned' => 'Pozycja zwrócona', # Accepts model codes
        'PanelReturnDate' => 'Data zwrotu',
        'PanelLendedYes' => 'Pożyczone',
        'PanelLendedNo' => 'Dostępne',

        'PanelTags' => 'Znaczniki',
        'PanelFavourite' => 'Ulubione',
        'TagsAssigned' => 'Znaczniki przydzielone', 

        'PanelUser' => 'Pola użytkownika',

        'CheckUndef' => 'Oba',
        'CheckYes' => 'Tak',
        'CheckNo' => 'Nie',

        'ToolbarAll' => 'Zobacz wszystkie',
        'ToolbarAllTooltip' => 'Zobacz wszystkie pozycje',
        'ToolbarGroupBy' => 'Grupuj według',
        'ToolbarGroupByTooltip' => 'Wybierz pole, według którego będą grupowane pozycje z listy',
        'ToolbarQuickSearch' => 'Szybkie wyszukiwanie',
        'ToolbarQuickSearchLabel' => 'Znajdź',
        'ToolbarQuickSearchTooltip' => 'Wybierz pole do przeszukania. Wprowadź wyrażenie i naciśnij Enter',
        'ToolbarSeparator' => ' Separator',

        'PluginsTitle' => 'Wyszukiwanie',
        'PluginsQuery' => 'Szukaj',
        'PluginsFrame' => 'Przeglądane witryny',
        'PluginsLogo' => 'Logo',
        'PluginsName' => 'Nazwa',
        'PluginsSearchFields' => 'Przeglądane pola',
        'PluginsAuthor' => 'Autor',
        'PluginsLang' => 'Język',
        'PluginsUseSite' => 'Używaj wybranej witryny w kolejnych wyszukiwaniach',
        'PluginsPreferredTooltip' => 'Site recommended by GCstar',
        'PluginDisabled' => 'Disabled',

        'BorrowersTitle' => 'Konfiguracja dłużnika',
        'BorrowersList' => 'Dłużnicy',
        'BorrowersName' => 'Nazwa',
        'BorrowersEmail' => 'E-mail',
        'BorrowersAdd' => 'Dodaj',
        'BorrowersRemove' => 'Usuń',
        'BorrowersEdit' => 'Edytuj',
        'BorrowersTemplate' => 'Kopia e-mail',
        'BorrowersSubject' => 'Temat e-mail',
        'BorrowersNotice1' => '%1 - nazwa dłużnika',
        'BorrowersNotice2' => '%2 - tytuł pozycji',
        'BorrowersNotice3' => '%3 - data wypożyczenia',

        'BorrowersImportTitle' => 'Import informacji o dłużnikach',
        'BorrowersImportType' => 'Format pliku:',
        'BorrowersImportFile' => 'Plik:',

        'BorrowedTitle' => 'Pożyczone pozycje', # Accepts model codes
        'BorrowedDate' => 'Od',
        'BorrowedDisplayInPanel' => 'Pokaż tą pozycję w głównym oknie', # Accepts model codes

        'MailTitle' => 'Wyślij e-mail',
        'MailFrom' => 'Od: ',
        'MailTo' => 'Do: ',
        'MailSubject' => 'Temat: ',
        'MailSmtpError' => 'Problem z serwerem SMTP',
        'MailSendmailError' => 'Błąd załadowania funkcji sendmail',

        'SearchTooltip' => 'Szukaj we wszystkich pozycjach', # Accepts model codes
        'SearchTitle' => 'Wyszukiwanie', # Accepts model codes
        'SearchNoField' => 'Nie wybrano żadnego pola dla wyszukiwania.
Dodaj kilka w zakładce Filtry okienka ustawień Zbioru.',

        'QueryReplaceField' => 'Zamień w polu:',
        'QueryReplaceOld' => 'Znajdź',
        'QueryReplaceNew' => 'Zastąp',
        'QueryReplaceLaunch' => 'Zastąp',

        'ImportWindowTitle' => 'Wybierz pola do importu',
        'ImportViewPicture' => 'Zobacz obraz',
        'ImportSelectAll' => 'Zaznacz wszystkie',
        'ImportSelectNone' => 'Odznacz wszystkie',

        'MultiSiteTitle' => 'Witryny używane do wyszukiwania',
        'MultiSiteUnused' => 'Nieużywane wtyczki',
        'MultiSiteUsed' => 'Używane wtyczki',
        'MultiSiteLang' => 'Wypełnij listę polskimi wtyczkami',
        'MultiSiteEmptyError' => 'Twoja lista witryn jest pusta',
        'MultiSiteClear' => 'Wyczyść listę',

        'DisplayOptionsTitle' => 'Pozycje do wyświetlenia',
        'DisplayOptionsAll' => 'Zaznacz wszystkie',
        'DisplayOptionsSearch' => 'Przycisk Szukania',

        'GenresTitle' => 'Konwersja gatunków',
        'GenresCategoryName' => 'Użyj gatunku',
        'GenresCategoryMembers' => 'Zastąp gatunek',
        'GenresLoad' => 'Załaduj listę',
        'GenresExport' => 'Zapisz listę do pliku',
        'GenresModify' => 'Edytuj konwersje',

        'PropertiesName' => 'Nazwa Zbioru',
        'PropertiesLang' => 'Kod języka',
        'PropertiesOwner' => 'Właściciel',
        'PropertiesEmail' => 'E-mail',
        'PropertiesDescription' => 'Opis',
        'PropertiesFile' => 'Informacje o pliku',
        'PropertiesFilePath' => 'Pełna ścieżka',
        'PropertiesItemsNumber' => 'Ilość pozycji', # Accepts model codes
        'PropertiesFileSize' => 'Rozmiar',
        'PropertiesFileSizeSymbols' => ['Bajtów', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
        'PropertiesCollection' => 'Właściwości Zbioru',
        'PropertiesDefaultPicture' => 'Zdjęcie domyślne',

        'MailProgramsTitle' => 'Programy pocztowe',
        'MailProgramsName' => 'Nazwa',
        'MailProgramsCommand' => 'Polecenie',
        'MailProgramsRestore' => 'Przywróć domyślne',
        'MailProgramsAdd' => 'Dodaj program',
        'MailProgramsInstructions' => 'W linii poleceń mogą występować poniższe symbole:
 %f będzie zastąpione adresem e-mail użytkownika.
 %t będzie zastąpione adresem odbiorcy.
 %s będzie zastąpione tematem wiadomości.
 %b będzie zastąpione tekstem wiadomości.',

        'BookmarksBookmarks' => 'Zakładki',
        'BookmarksFolder' => 'Katalog',
        'BookmarksLabel' => 'Etykieta',
        'BookmarksPath' => 'Ścieżka',
        'BookmarksNewFolder' => 'Nowy katalog',

        'AdvancedSearchType' => 'Typ wyszukiwania',
        'AdvancedSearchTypeAnd' => 'Pozycje spełniające wszystkie warunki', # Accepts model codes
        'AdvancedSearchTypeOr' => 'Pozycje spełniające co najmniej jeden z warunków', # Accepts model codes
        'AdvancedSearchCriteria' => 'Warunki',
        'AdvancedSearchAnyField' => 'Any field',
        'AdvancedSearchSaveTitle' => 'Zapisz wyszukiwanie',
        'AdvancedSearchSaveName' => 'Nazwa',
        'AdvancedSearchSaveOverwrite' => 'Wyszukiwanie o tej nazwie już istnieje. Proszę użyć innej nazwy.',
        'AdvancedSearchUseCase' => 'Uwzględniaj wielkość liter',
        'AdvancedSearchIgnoreDiacritics' => 'Ignoruj znaki diakrytyczne',

        'BugReportSubject' => 'Zgłoszenie błędu wygenerowane z programu GCstar',
        'BugReportVersion' => 'Wersja',
        'BugReportPlatform' => 'System operacyjny',
        'BugReportMessage' => 'Treść zgłoszenia',
        'BugReportInformation' => 'Informacje dodatkowe',

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
