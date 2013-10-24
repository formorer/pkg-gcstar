{
    package GCLang::HU;

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

        'LangName' => 'Magyar',
        
        'Separator' => ': ',
        
        'Warning' => '<b>Figyelmeztetés</b>:
        
A weboldalakról letöltött információk (a bővítményeken keresztül)
<b>csak személyes használatra engedélyezettek</b>.

Bármilyen újraközlés az oldal
<b>külön engedélye</b> nélkül tilos.

<b>Az elemek alatti gomb</b> megnyomásával nyomonkövethetjük,
hogy melyik oldalról valók az információk.',
        
        'AllItemsFiltered' => 'Nincs megfelelő elem a keresési feltételeidhez', # Accepts model codes
        
#Installation
        'InstallDirInfo' => 'Telepítés ide',
        'InstallMandatory' => 'Szükséges összetevők',
        'InstallOptional' => 'Választható összetevők',
        'InstallErrorMissing' => 'Hiba : A következő Perl összetevőket telepíteni kell: ',
        'InstallPrompt' => 'A telepítés alapkönyvtára [/usr/local]: ',
        'InstallEnd' => 'A telepítés befejeződött',
        'InstallNoError' => 'Nincs hiba',
        'InstallLaunch' => 'Az alkalmazás használatához indítsd ',
        'InstallDirectory' => 'Alapkönyvtár',
        'InstallTitle' => 'GCstar telepítése',
        'InstallDependencies' => 'Függőségek',
        'InstallPath' => 'Elérési út',
        'InstallOptions' => 'Beállítások',
        'InstallSelectDirectory' => 'Válassz ki egy alapkönyvtárat a telepítéshez',
        'InstallWithClean' => 'A telepítőkönyvtár fájlainak törlése',
        'InstallWithMenu' => 'A GCstar hozzáadása az Alkalmazások menühöz',
        'InstallNoPermission' => 'Hiba: Nincs írásjogod a kiválasztott könyvtárra',
        'InstallMissingMandatory' => 'Szükséges összetevők hiányoznak. Amíg nem telepíted őket, a GCstar nem telepíthető.',
        'InstallMissingOptional' => 'Néhány, alul listázott választható összetevő hiányzik. A GCstar telepíthető, de néhány funkció nem lesz elérhető.',
        'InstallMissingNone' => 'Nincs hiányzó függőség. Folytathatod a GCstar telepítését.',
        'InstallOK' => 'Rendben',
        'InstallMissing' => 'Hiányzik',
        'InstallMissingFor' => 'Hiányzó',
        'InstallCleanDirectory' => 'Eltávolítható GCstar-fájlok ebben a könyvtárban: ',
        'InstallCopyDirectory' => 'Fájlok másolása: ',
        'InstallCopyDesktop' => 'A desktopfájlok másolása ide: ',

#Update
        'UpdateUseProxy' => 'Proxy használata (üss Entert, ha mégsem): ',
        'UpdateNoPermission' => 'Írási engedély megtagadva a könyvtárban: ',
        'UpdateNone' => 'Nem található frissítés',
        'UpdateFileNotFound' => 'A fájl nem található',

#Splash
        'SplashInit' => 'Inicializáció',
        'SplashLoad' => 'Gyűjtemény betöltése',
        'SplashDisplay' => 'Gyűjtemény megjelenítése',
        'SplashSort' => 'Gyűjtemény rendezése',
        'SplashDone' => 'Kész',

#Import from GCfilms
        'GCfilmsImportQuestion' => 'Úgy tűnik, hogy korábban használtad a GCfilms-t. Mit szeretnél a GCfilms-ből a GCstar-ba importálni (ez nem befolyásolja a GCfilms-t, ha használni akarod)?',
        'GCfilmsImportOptions' => 'Beállítások',
        'GCfilmsImportData' => 'Filmlisták',

#Menus
        'MenuFile' => '_Fájl',
            'MenuNewList' => '_Új gyűjtemény',
            'MenuStats' => 'Statistics',
            'MenuHistory' => 'K_orábbi gyűjtemények',
            'MenuLend' => 'Kölcsönadott _elemek megjelenítése', # Accepts model codes
            'MenuImport' => '_Importálás',	
            'MenuExport' => 'E_xportálás',
            'MenuAddItem' => '_Add Items', # Accepts model codes
    
        'MenuEdit'  => '_Szerkesztés',
            'MenuDuplicate' => 'Elem _kettőzése', # Accepts model codes
            'MenuDuplicatePlural' => 'Du_plicate Items', # Accepts model codes
            'MenuEditSelectAllItems' => 'Select _All Items', # Accepts model codes
            'MenuEditDeleteCurrent' => '_Elem eltávolítása', # Accepts model codes
            'MenuEditDeleteCurrentPlural' => '_Remove Items', # Accepts model codes    
            'MenuEditFields' => '_Gyűjtemény mezőinek megváltoztatása',
            'MenuEditLockItems' => 'Gyűjtemény _zárolása',
    
        'MenuDisplay' => 'S_zűrő',
            'MenuSavedSearches' => 'Elmentett keresések',
                'MenuSavedSearchesSave' => 'A jelenlegi keresés elmentése',
                'MenuSavedSearchesEdit' => 'Elmentett keresések módosítása',
            'MenuAdvancedSearch' => 'Haladó keresés',
            'MenuViewAllItems' => '_Elemek mutatása', # Accepts model codes
            'MenuNoFilter' => '_Minden',
    
        'MenuConfiguration' => '_Beállítások',
            'MenuDisplayMenu' => 'Display',
                'MenuDisplayFullScreen' => 'Full screen',
                'MenuDisplayMenuBar' => 'Menus',
                'MenuDisplayToolBar' => 'Toolbar',
                'MenuDisplayStatusBar' => 'Bottom bar',
            'MenuDisplayOptions' => '_Megjelenítendő elemek',
            'MenuBorrowers' => '_Kölcsönvevők',
            'MenuToolbarConfiguration' => '_Eszköztár beállítása',
            'MenuDefaultValues' => 'Default values for new item', # Accepts model codes
            'MenuGenresConversion' => '_Jellemzők konvertálása',
        
        'MenuBookmarks' => 'S_aját gyűjtemények',
            'MenuBookmarksAdd' => '_Jelenlegi gyűjtemény hozzáadása',
            'MenuBookmarksEdit' => 'Gyűjtemények _szerkesztése',

        'MenuHelp' => 'S_úgó',
            'MenuHelpContent' => '_Tartalom',
            'MenuAllPlugins' => 'Bővítmények _megtekintése',
            'MenuBugReport' => 'Hibajelentés _küldése',
            'MenuAbout' => '_A GCstar-ról',
    
        'MenuNewWindow' => 'Megjelenítés új _ablakban', # Accepts model codes
        'MenuNewWindowPlural' => 'Show Items in _New Window', # Accepts model codes
        
        'ContextExpandAll' => 'Szálak kibontása',
        'ContextCollapseAll' => 'Szálak összecsukása',
        'ContextChooseImage' => 'Válassz _Képet',
        'ContextOpenWith' => 'Megnyitás ezze_l',
        'ContextImageEditor' => 'Képszerkesztő',
        'ContextImgFront' => 'Borító',
        'ContextImgBack' => 'Hátlap',
        'ContextChooseFile' => 'Choose a File',
        'ContextChooseFolder' => 'Choose a Folder',
       
        'DialogEnterNumber' => 'Addj meg egy értéket',

        'RemoveConfirm' => 'Valóban el akarod távolítani az elemet?', # Accepts model codes
        'RemoveConfirmPlural' => 'Do you really want to remove these items?', # Accepts model codes
        'DefaultNewItem' => 'Új elem', # Accepts model codes
        'NewItemTooltip' => 'Új elem hozzáadása', # Accepts model codes
        'NoItemFound' => 'Nincs találat. Akarsz egy másik oldalon keresni?',
        'OpenList' => 'Jelölj ki egy gyűjteményt',
        'SaveList' => 'Válaszd ki, hogy hova legyen mentve a gyűjtemény!',
        'SaveListTooltip' => 'Jelenlegi gyűjtemény mentése',
        'SaveUnsavedChanges' => 'Nem mentett változások vannak a gyűjteményedben. Akarod őket menteni?',
        'SaveDontSave' => 'Ne mentse',
        'PreferencesTooltip' => 'Beállítások',
        'ViewTooltip' => 'A gyűjtemény megjelenítésének változtatása',
        'PlayTooltip' => 'Az elemhez kapcsolódó videó lejátszása', # Accepts model codes
        'PlayFileNotFound' => 'Ezen a helyen nem található az indítandó fájl:',
        'PlayRetry' => 'Újra',

        'StatusSave' => 'Mentés...',
        'StatusLoad' => 'Betöltés...',
        'StatusSearch' => 'Haladó keresés...',
        'StatusGetInfo' => 'Információk betöltése...',
        'StatusGetImage' => 'Képek betöltése...',
                
        'SaveError' => 'Nem lehet menteni a listát. Ellenőrízd a jogokat és a szabad tárhelyet.',
        'OpenError' => 'Nem lehet megnyitni a listát. Ellenőrízd a jogokat.',
		'OpenFormatError' => 'Nem lehet megnyitni a listát. Hibás formátum.',
        'OpenVersionWarning' => 'A gyűjtemény egy újabb verziójú GCstar-ral készült. Ha elmented, elveszthetsz néhány adatot.',
        'OpenVersionQuestion' => 'Biztosan folytatni akarod?',
        'ImageError' => 'A képek mentéséhez kiválasztott könyvtár helytelen. Válassz egy másikat.',
        'OptionsCreationError'=> 'Nem lehet létrehozni a beállítás-fájlt: ',
        'OptionsOpenError'=> 'Nem lehet megnyitni a beállítás-fájlt: ',
        'OptionsSaveError'=> 'Nem lehet menteni a beállítás-fájlt: ',
        'ErrorModelNotFound' => 'Sablon nem található: ',
        'ErrorModelUserDir' => 'A felhasználó által meghatározott sablonok: ',
        
        'RandomTooltip' => 'Mit nézünk ma este ?',
        'RandomError'=> 'Nincs kijelölhető elem', # Accepts model codes
        'RandomEnd'=> 'Nincs több elem', # Accepts model codes
        'RandomNextTip'=> 'Következő javaslat',
        'RandomOkTip'=> 'Elem elfogadása',
        
        'AboutTitle' => 'A GCstar-ról',
        'AboutDesc' => 'Személyes gyűjteménykezelő',
        'AboutVersion' => 'Verzió',
        'AboutTeam' => 'Csapat',
        'AboutWho' => 'Christian Jodar (Tian): Project menedzser, Programozó
Nyall Dawson (Zombiepig): Programozó
TPF: Programozó
Adolfo González: Programozó
',
        'AboutLicense' => 'Készült a GNU GPL licensz alapján
Logók Copyright le Spektre',
        'AboutTranslation' => 'Magyar fordítás: Takács László Krisztián tlk at t-online dot hu',
        'AboutDesign' => 'Łukasz Kowalczk (Qoolman): Skin Designer
Logó és webdizájn: le Spektre',

        'ToolbarRandom' => 'Ma este',

        'UnsavedCollection' => 'Nem mentett Gyűjtemény',
        'ModelsSelect' => 'A gyűjtemény típusának kiválasztása',
        'ModelsPersonal' => 'Személyes sablonok',
        'ModelsDefault' => 'Alapértelmezett sablonok',
        'ModelsList' => 'Gyűjteménysablon',
        'ModelSettings' => 'Gyűjtemény beállítások',
        'ModelNewType' => 'Új gyűjteménytípus',
        'ModelName' => 'A gyűjteménytípus neve:',
		'ModelFields' => 'Mezők',
		'ModelOptions'	=> 'Beállítások',
		'ModelFilters'	=> 'Szűrők',
        'ModelNewField' => 'Új mező',
        'ModelFieldInformation' => 'Információ',
        'ModelFieldName' => 'Címke:',
        'ModelFieldType' => 'Típus:',
        'ModelFieldGroup' => 'Csoport:',
        'ModelFieldValues' => 'Értékek',
        'ModelFieldInit' => 'Alapértelmezett:',
        'ModelFieldMin' => 'Minimális:',
        'ModelFieldMax' => 'Maximális:',
        'ModelFieldList' => 'Értékek listája:',
        'ModelFieldListLegend' => '<i>Vesszővel elválasztva</i>',
        'ModelFieldDisplayAs' => 'Megjelenik mint:',
        'ModelFieldDisplayAsText' => 'Szöveg',
        'ModelFieldDisplayAsGraphical' => 'Kategória Beállítás',
        'ModelFieldTypeShortText' => 'Rövid szöveg',
        'ModelFieldTypeLongText' => 'Hosszú szöveg',
        'ModelFieldTypeYesNo' => 'Igen/Nem',
        'ModelFieldTypeNumber' => 'Szám',
        'ModelFieldTypeDate' => 'Dátum',
        'ModelFieldTypeOptions' => 'Előredefiniált lista',
        'ModelFieldTypeImage' => 'Kép',
        'ModelFieldTypeSingleList' => 'Egyszerű lista',
        'ModelFieldTypeFile' => 'Fájl',
        'ModelFieldTypeFormatted' => 'Más mezőknek alárendelve',
        'ModelFieldParameters' => 'Parametéterek',
        'ModelFieldHasHistory' => 'Előzmények használata',
        'ModelFieldFlat' => 'Kijelzés egy sorban',
        'ModelFieldStep' => 'Növekvő lépés:',
        'ModelFieldFileFormat' => 'Fájl formátum:',
        'ModelFieldFileFile' => 'Egyszerű fájl',
        'ModelFieldFileImage' => 'Kép',
        'ModelFieldFileVideo' => 'Videó',
        'ModelFieldFileAudio' => 'Hang',
        'ModelFieldFileProgram' => 'Program',
        'ModelFieldFileUrl' => 'URL',
        'ModelFieldFileEbook' => 'Ebook',
        'ModelOptionsFields' => 'Mezők használata',
        'ModelOptionsFieldsAuto' => 'Automatikus',
        'ModelOptionsFieldsNone' => 'Semmi',
        'ModelOptionsFieldsTitle' => 'Címként',
        'ModelOptionsFieldsId' => 'Azonosítóként',
        'ModelOptionsFieldsCover' => 'Borítóként',
        'ModelOptionsFieldsPlay' => 'Lejátszógomb',
        'ModelCollectionSettings' => 'Gyűjtemény beállítások',
        'ModelCollectionSettingsLending' => 'Kölcsönadható elemek',
        'ModelCollectionSettingsTagging' => 'Cimkézhető elemek',
        'ModelFilterActivated' => 'A keresősávban kell legyen',
        'ModelFilterComparison' => 'Összehasonlítás',
        'ModelFilterContain' => 'Tartalmazza',
        'ModelFilterDoesNotContain' => 'Nem tartalmazza',
        'ModelFilterRegexp' => 'Pontos kifejezés',
        'ModelFilterRange' => 'Sorozat',
        'ModelFilterNumeric' => 'Számalapú összehasonlítás',
        'ModelFilterQuick' => 'Gyorsszűrő létrehozása',
        'ModelTooltipName' => 'Név a modell használatához a további gyűjteményekben. Ha üresen marad, akkor a beállítások közvetlenül a gyűjteményen belül tárolódnak',
        'ModelTooltipLabel' => 'A mező neve, ahogy az meg fog jelenni',
        'ModelTooltipGroup' => 'Mezők csoportosítása. Az érték nélküli elemek az alapértelmezett csoportba kerülnek',
        'ModelTooltipHistory' => 'Az itt megadott értékek a mezőhöz kapcsolt listába kerülnek elmentésre',
        'ModelTooltipFormat' => 'Ez a formátum használatos a megnyitógomb által elindított eseményhez',
        'ModelTooltipLending' => 'Mezők hozzáadása a kölcsönzés-kezelőhöz',
        'ModelTooltipTagging' => 'Mezők hozzáadása a cimke-kezelőhöz',
        'ModelTooltipNumeric' => 'Az értékek az összehasonlításban számként lesznek jelölve',
        'ModelTooltipQuick' => 'Almenü hozzáadása a szűrőkhöz',
        
        'ResultsTitle' => 'Elem kijelölése', # Accepts model codes
        'ResultsNextTip' => 'Keresés a következő oldalon',
        'ResultsPreview' => 'Előnézet',
        'ResultsInfo' => 'Több elem hozzáadása lehetséges a gyűjteményhez. Nyomd le a Crtl vagy a Shift gombot, és válassz', # Accepts model codes
        
        'OptionsTitle' => 'Beállítások',
        'OptionsExpertMode' => 'Haladó mód',
        'OptionsPrograms' => 'Bizonyos alkalmazások használata különböző médiákhoz, hagyd üresen az alapbeállítások használatához',
        'OptionsBrowser' => 'Böngésző',
        'OptionsPlayer' => 'Videólejátszó',
        'OptionsAudio' => 'Hanglejátszó',
        'OptionsImageEditor' => 'Képszerkesztő',
        'OptionsCdDevice' => 'CD-eszköz',
        'OptionsImages' => 'Képek',
        'OptionsUseRelativePaths' => 'Relatív elérési utak használata a képekhez',
        'OptionsLayout' => 'Elrendezés',
        'OptionsStatus' => 'Állapotjelző mutatása',
        'OptionsUseStars' => 'Csillagok használata az értékelések kijelzéséhez',
        'OptionsWarning' => 'Figyelem: A beállítások csak a program újraindítása után lépnek életbe.',
        'OptionsRemoveConfirm' => 'Kérjen megerősítést az elem törlése előtt',
        'OptionsAutoSave' => 'Gyűjtemény automatikus mentése',
        'OptionsAutoLoad' => 'Előző gyűjtemény betöltése induláskor',
        'OptionsSplash' => 'Bejelentkező képernyő mutatása',
        'OptionsTearoffMenus' => 'Előjegyzési menük engedélyezése',
        'OptionsSpellCheck' => 'Helyesírásellenőrző használata a hosszú, szöveges mezőkhöz',
        'OptionsProgramTitle' => 'Használandó program kiválasztása',
		'OptionsPlugins' => 'Oldal, ahol adatot keres',
		'OptionsAskPlugins' => 'Keres (Minden oldalon)',
		'OptionsPluginsMulti' => 'Több oldalon',
		'OptionsPluginsMultiAsk' => 'Keres (Több oldalon)',
        'OptionsPluginsMultiPerField' => 'Több oldalon (per field)',
        'OptionsPluginsMultiPerFieldWindowTitle' => 'Many sites per field order selection',
        'OptionsPluginsMultiPerFieldDesc' => 'For each selected field we will return the first non empty information beginning from left',
        'OptionsPluginsMultiPerFieldFirst' => 'First',
        'OptionsPluginsMultiPerFieldLast' => 'Last',
        'OptionsPluginsMultiPerFieldRemove' => 'Remove',
        'OptionsPluginsMultiPerFieldClearSelected' => 'Empty selected field list',
		'OptionsPluginsList' => 'Lista beállítása',
        'OptionsAskImport' => 'Importálandó mezők kiválasztása',
		'OptionsProxy' => 'Proxy használata',
		'OptionsCookieJar' => 'Használja ezt a jar-fájlt a cookie-khoz',
        'OptionsLang' => 'Nyelv',
        'OptionsMain' => 'Általános',
        'OptionsPaths' => 'Útvonalak',
        'OptionsInternet' => 'Internet',
        'OptionsConveniences' => 'Tulajdonságok',
        'OptionsDisplay' => 'Megjelenítés',
        'OptionsToolbar' => 'Eszköztár',
        'OptionsToolbars' => {0 => 'Semmi', 1 => 'Kicsi', 2 => 'Nagy', 3 => 'Rendszer beállítás'},
        'OptionsToolbarPosition' => 'Pozíció',
        'OptionsToolbarPositions' => {0 => 'Fennt', 1 => 'Lennt', 2 => 'Balra', 3 => 'Jobbra'},
        'OptionsExpandersMode' => 'Túl hosszú kiterjesztések',
        'OptionsExpandersModes' => {'asis' => 'Úgy hagy', 'cut' => 'Kivág', 'wrap' => 'Tördel'},
        'OptionsDateFormat' => 'Dátum formátuma',
        'OptionsDateFormatTooltip' => 'A strftime(3) által használt dátum. Alapértelmezett %d/%m/%Y',
        'OptionsView' => 'Elemek listája',
        'OptionsViews' => {0 => 'Szöveg', 1 => 'Kép', 2 => 'Részletes'},
        'OptionsColumns' => 'Oszlopok',
        'OptionsMailer' => 'E-mail kliens',
        'OptionsSMTP' => 'Szerver',
        'OptionsFrom' => 'E-mail cím',
        'OptionsTransform' => 'Névelők helye a címek végén',
        'OptionsArticles' => 'Névelők (vesszővel elválasztva)',
        'OptionsSearchStop' => 'A keresés leállítható',
        'OptionsBigPics' => 'Nagy képek használata, ha lehetséges',
        'OptionsAlwaysOriginal' => 'A fő cím használata eredeti címként, ha az nem elérhető',
        'OptionsRestoreAccelerators' => 'Gyorsítók visszaállítása',
        'OptionsHistory' => 'Előzmények mérete',
        'OptionsClearHistory' => 'Előzmények törlése',
		'OptionsStyle' => 'Felület',
        'OptionsDontAsk' => 'Ne kérdezzen rá többet',
        'OptionsPathProgramsGroup' => 'Alkalmazások',
        'OptionsProgramsSystem' => 'Rendszer által kínált programok használata',
        'OptionsProgramsUser' => 'Egyéni programok használata',
        'OptionsProgramsSet' => 'Programok beállítása',
        'OptionsPathImagesGroup' => 'Képek',
        'OptionsInternetDataGroup' => 'Adat importálás',
        'OptionsInternetSettingsGroup' => 'Beállítások',
        'OptionsDisplayInformationGroup' => 'Információ megjelenítése',
        'OptionsDisplayArticlesGroup' => 'Névelők',
        'OptionsImagesDisplayGroup' => 'Kijelző',
        'OptionsImagesStyleGroup' => 'Stílus',
        'OptionsDetailedPreferencesGroup' => 'Beállítások',
        'OptionsFeaturesConveniencesGroup' => 'Kényelem',
        'OptionsPicturesFormat' => 'Előtag használata képekhez:',
        'OptionsPicturesFormatInternal' => 'gcstar__',
        'OptionsPicturesFormatTitle' => 'Az összekapcsolt elemek címe vagy neve',
        'OptionsPicturesWorkingDir' => '%WORKING_DIR% vagy . lecserélődik a gyűjtemény könyvtárára (csak az elérési út megadásánál használandó)',
        'OptionsPicturesFileBase' => '%FILE_BASE% lecserélődik a gyűjtemény nevére kiterjesztés nélkül (.gcs)',
        'OptionsPicturesWorkingDirError' => '%WORKING_DIR% csak a képek elérési útjának megadásánál használható',
        'OptionsConfigureMailers' => 'Levelezőprogramok beállítása',

        'ImagesOptionsButton' => 'Beállítások',
        'ImagesOptionsTitle' => 'Képek listájának beállításai',
        'ImagesOptionsSelectColor' => 'Szín kijelölése',
        'ImagesOptionsUseOverlays' => 'Képrátétek használata',
        'ImagesOptionsBg' => 'Háttér',
        'ImagesOptionsBgPicture' => 'Háttérkép használata',
        'ImagesOptionsFg'=> 'Kiválasztás',
        'ImagesOptionsBgTooltip' => 'Háttérszín változtatása',
        'ImagesOptionsFgTooltip'=> 'Kijelölés színének változtatása',
        'ImagesOptionsResizeImgList' => 'Az oszlopok számának automatikus változtatása',
        'ImagesOptionsAnimateImgList' => 'Use animations',
        'ImagesOptionsSizeLabel' => 'Méret',
        'ImagesOptionsSizeList' => {0 => 'Nagyon kicsi', 1 => 'Kicsi', 2 => 'Közepes', 3 => 'Nagy', 4 => 'Nagyon nagy'},
        'ImagesOptionsSizeTooltip' => 'Képméret kiválasztása',
		        
        'DetailedOptionsTitle' => 'A részletes lista beállításai',
        'DetailedOptionsImageSize' => 'Képek mérete',
        'DetailedOptionsGroupItems' => 'Elemek csoportosítása',
        'DetailedOptionsSecondarySort' => 'Mezők csoportosítása gyerekeknek',
		'DetailedOptionsFields' => 'A megjelenítendő mezők kiválasztása',
        'DetailedOptionsGroupedFirst' => 'Árva sorok együttartása',
        'DetailedOptionsAddCount' => 'Elemek számának hozzáadása a kategóriákhoz',

        'ExtractButton' => 'Információ',
        'ExtractTitle' => 'Fájl információ',
        'ExtractImport' => 'Értékek használata',

        'FieldsListOpen' => 'Mezők listájának betöltése fájlból',
        'FieldsListSave' => 'Mezők listájának mentése fájlba',
        'FieldsListError' => 'A gyűjtemény ezen típusához ez a mezőlista nem használható',
        'FieldsListIgnore' => '--- Mellőz',

        'ExportTitle' => 'Elemlista exportálása',
        'ExportFilter' => 'Csak a kijelzett elemek exportálása',
        'ExportFieldsTitle' => 'Mezők exportálva',
        'ExportFieldsTip' => 'Válaszd ki az exportálandó elemeket',
        'ExportWithPictures' => 'Képek másolása az alkönyvtárba',
        'ExportSortBy' => 'Rendezés',
        'ExportOrder' => 'Order',

        'ImportListTitle' => 'Egyéb elemlista importálása',
        'ImportExportData' => 'Adat',
        'ImportExportFile' => 'Fájl',
        'ImportExportFieldsUnused' => 'Nem használt mezők',
        'ImportExportFieldsUsed' => 'Használt mezők',
        'ImportExportFieldsFill' => 'Mindet hozzáad',
        'ImportExportFieldsClear' => 'Mindet eltávolít',
        'ImportExportFieldsEmpty' => 'Legalább egy mezőt kell választanod',
        'ImportExportFileEmpty' => 'Legalább egy fájlnevet meg kell adnod',
        'ImportFieldsTitle' => 'Mezők importálva',
        'ImportFieldsTip' => 'Jelöld ki az importálandó mezőket',
        'ImportNewList' => 'Új gyűjtemény létrehozása',
        'ImportCurrentList' => 'Hozzáadás a jelenlegi gyűjteményhez',
        'ImportDropError' => 'A fájl betöltésekor hiba történt. Az előző lista vissza lesz töltve.',
        'ImportGenerateId' => 'Azonosító létrehozása minden elemhez',

        'FileChooserOpenFile' => 'Válaszd ki a használandó fájlt!',
        'FileChooserDirectory' => 'Könyvtár',
        'FileChooserOpenDirectory' => 'Könyvtár kiválasztása',
        'FileChooserOverwrite' => 'A fájl már létezik. Felül akarod írni?',
        'FileAllFiles' => 'All Files',
        'FileVideoFiles' => 'Video Files',
        'FileEbookFiles' => 'Ebook Files',
        'FileAudioFiles' => 'Audio Files',
        'FileGCstarFiles' => 'GCstar Collections',

        #Some default panels
        'PanelCompact' => 'Egyszerű',
        'PanelReadOnly' => 'Csak olvasható',
        'PanelForm' => 'Cimkék',

        'PanelSearchButton' => 'Internetes keresés',
        'PanelSearchTip' => 'Keresés az interneten erre a névre',
        'PanelSearchContextChooseOne' => 'Choose a site ...',
        'PanelSearchContextMultiSite' => 'Use "Many sites"',
        'PanelSearchContextMultiSitePerField' => 'Use "Many sites per field"',
        'PanelSearchContextOptions' => 'Change options ...',
        'PanelImageTipOpen' => 'Kattins a képre a változtatáshoz.',
        'PanelImageTipView' => 'Eredeti mérethez kattints a képre.',
        'PanelImageTipMenu' => ' Jobb klikk a további beállításokhoz.',
        'PanelImageTitle' => 'Kép kiválasztása',
        'PanelImageNoImage' => 'Nincs kép',
        'PanelSelectFileTitle' => 'Fájl kiválasztása',
        'PanelLaunch' => 'Launch',        
        'PanelRestoreDefault' => 'Visszaállítás',
        'PanelRefresh' => 'Update',
        'PanelRefreshTip' => 'Update information from web',

        'PanelFrom' =>'Feladó',
        'PanelTo' =>'Címzett',

        'PanelWeb' => 'Információk megtekintése',
        'PanelWebTip' => 'Információ megtekintése az interneten erről az elemről', # Accepts model codes
        'PanelRemoveTip' => 'Jelenlegi elem eltávolítása', # Accepts model codes

        'PanelDateSelect' => 'Kijelöl',
        'PanelNobody' => 'Senki',
        'PanelUnknown' => 'Ismeretlen',
        'PanelAdded' => 'Dátum hozzáadása',
        'PanelRating' => 'Értékelés',
        'PanelPressRating' => 'Press Rating',
        'PanelLocation' => 'Hely',

        'PanelLending' => 'Kölcsönzés',
        'PanelBorrower' => 'Kölcsönvevő',
        'PanelLendDate' => 'Kölcsönadás ideje',
        'PanelHistory' => 'Kölcsönzési előzmények',
        'PanelReturned' => 'Visszaadva', # Accepts model codes
        'PanelReturnDate' => 'Visszaadás dátuma',
        'PanelLendedYes' => 'Kölcsönadva',
        'PanelLendedNo' => 'Elérhető',

        'PanelTags' => 'Cimkék',
        'PanelFavourite' => 'Kedvencek',
        'TagsAssigned' => 'Kijelölt cimkék', 

        'PanelUser' => 'User fields',

        'CheckUndef' => 'Bármelyik',
        'CheckYes' => 'Igen',
        'CheckNo' => 'Nem',

        'ToolbarAll' => 'Mindent megtekint',
        'ToolbarAllTooltip' => 'Elemek mutatása',
        'ToolbarGroupBy' => 'Csoportosítás',
        'ToolbarGroupByTooltip' => 'Jelöld ki a lista elemeinek csoportosításához használni kívánt mezőt',
        'ToolbarQuickSearch' => 'Gyorskeresés',
        'ToolbarQuickSearchLabel' => 'Keresés',
        'ToolbarQuickSearchTooltip' => 'Válaszd ki azt a mezőt, amiben keresnél. Üsd be a kifejezéseket és nyomj Entert',
        'ToolbarSeparator' => ' Elválasztó',
        
        'PluginsTitle' => 'Elem keresése',
        'PluginsQuery' => 'Kérdés',
        'PluginsFrame' => 'Oldal keresése',
        'PluginsLogo' => 'Logó',
        'PluginsName' => 'Név',
        'PluginsSearchFields' => 'Keresési mezők',
        'PluginsAuthor' => 'Szerző',
        'PluginsLang' => 'Nyelv',
        'PluginsUseSite' => 'A kiválasztott oldal használata további keresésekhez',
        'PluginsPreferredTooltip' => 'Site recommended by GCstar',
        'PluginDisabled' => 'Disabled',

        'BorrowersTitle' => 'Kölcsönvevők beállításai',
        'BorrowersList' => 'Kölcsönvevők',
        'BorrowersName' => 'Név',
        'BorrowersEmail' => 'E-mail cím',
        'BorrowersAdd' => 'Hozzáadás',
        'BorrowersRemove' => 'Eltávolítás',
        'BorrowersEdit' => 'Szerkesztés',
        'BorrowersTemplate' => 'Levélsablon',
        'BorrowersSubject' => 'Levél tárgya',
        'BorrowersNotice1' => '%1 a kölcsönvevő nevére lesz cserélve',
        'BorrowersNotice2' => '%2 az elem címére lesz cserélve',
        'BorrowersNotice3' => '%3 a kölcsönzés dátumára lesz cserélve',

        'BorrowersImportTitle' => 'Információk importálása a kölcsönvevőkről',
        'BorrowersImportType' => 'Fájlformátum:',
        'BorrowersImportFile' => 'Fájl:',

        'BorrowedTitle' => 'Kölcsönadott elemek', # Accepts model codes
        'BorrowedDate' => 'Kölcsönadás ideje',
        'BorrowedDisplayInPanel' => 'Elemek megjelenítése a fő ablakban', # Accepts model codes

        'MailTitle' => 'E-mail küldése',
        'MailFrom' => 'Feladó: ',
        'MailTo' => 'Címzett: ',
        'MailSubject' => 'Tárgy: ',
        'MailSmtpError' => 'Hiba az SMTP szerverhez való kapcsolódáskor',
        'MailSendmailError' => 'Hiba a sendmail futtatásakor',

        'SearchTooltip' => 'Elemek keresése', # Accepts model codes
        'SearchTitle' => 'Elem keresése', # Accepts model codes
        'SearchNoField' => 'No field have been selected for the search box.
Add some of them in the Filters tab of the collection settings.',

        'QueryReplaceField' => 'Mezőcsere',
        'QueryReplaceOld' => 'Jelenlegi érték',
        'QueryReplaceNew' => 'Új érték',
        'QueryReplaceLaunch' => 'Csere',
        
        'ImportWindowTitle' => 'Importálandó mezők kiválasztása',
        'ImportViewPicture' => 'Kép megtekintése',
        'ImportSelectAll' => 'Mindent kijelöl',
        'ImportSelectNone' => 'Kijelölés megszüntetése',

        'MultiSiteTitle' => 'A kereséshez használt oldalak',
        'MultiSiteUnused' => 'Nem használt bővítmények',
        'MultiSiteUsed' => 'Használt bővítmények',
        'MultiSiteLang' => 'Töltse fel a listát a magyar bővítményekkel',
        'MultiSiteEmptyError' => 'A lista üres',
        'MultiSiteClear' => 'Lista törlése',
        
        'DisplayOptionsTitle' => 'Megjelenítendő elemek',
        'DisplayOptionsAll' => 'Mindent kijelöl',
        'DisplayOptionsSearch' => 'Keresőgomb',

        'GenresTitle' => 'Jellemzők konvertálása',
        'GenresCategoryName' => 'Jellemzők használata',
        'GenresCategoryMembers' => 'Jellemzők cseréje',
        'GenresLoad' => 'Lista betöltése',
        'GenresExport' => 'Lista mentése fájlba',
        'GenresModify' => 'Változások szerkesztése',

        'PropertiesName' => 'Gyűjtemény neve',
        'PropertiesLang' => 'Nyelv kód',
        'PropertiesOwner' => 'Tulajdonos',
        'PropertiesEmail' => 'E-mail cím',
        'PropertiesDescription' => 'Leírás',
        'PropertiesFile' => 'Fájlinformáció',
        'PropertiesFilePath' => 'Elérési út',
        'PropertiesItemsNumber' => 'Elemek száma', # Accepts model codes
        'PropertiesFileSize' => 'Méret',
        'PropertiesFileSizeSymbols' => ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
        'PropertiesCollection' => 'Gyűjtemény tulajdonságai',
        'PropertiesDefaultPicture' => 'Alapértelmezett kép',

        'MailProgramsTitle' => 'Levelezőprogramok',
        'MailProgramsName' => 'Név',
        'MailProgramsCommand' => 'Parancssor',
        'MailProgramsRestore' => 'Visszaállítás',
        'MailProgramsAdd' => 'Program hozzáadása',
        'MailProgramsInstructions' => 'A parancssorban néhány csere történt:
 %f kicserélve a felhasználó e-mail címére.
 %t kicserélve a címzett e-mail címére.
 %s kicserélve az üzenet tárgyára.
 %b kicserélve az üzenet tartalmára.',

        'BookmarksBookmarks' => 'Könyvjelzők',
        'BookmarksFolder' => 'Könyvtárak',
        'BookmarksLabel' => 'Cimke',
        'BookmarksPath' => 'Elérési út',
        'BookmarksNewFolder' => 'Új könyvtár',

        'AdvancedSearchType' => 'Keresés típusa',
        'AdvancedSearchTypeAnd' => 'Minden kritériumnak megfelelő elemek', # Accepts model codes
        'AdvancedSearchTypeOr' => 'Legalább egy kritériumnak megfelelő elemek', # Accepts model codes
        'AdvancedSearchCriteria' => 'Kritérium',
        'AdvancedSearchAnyField' => 'Bármely mező',
        'AdvancedSearchSaveTitle' => 'Keresés elmentése',
        'AdvancedSearchSaveName' => 'Név',
        'AdvancedSearchSaveOverwrite' => 'Ezzel a névvel már létezik elmentett keresés. Válassz egy másikat.',
        'AdvancedSearchUseCase' => 'Ügyel a nagybetűs írásmódra',
        'AdvancedSearchIgnoreDiacritics' => 'Különleges karakterek mellőzése',
 
        'BugReportSubject' => 'Hibajelentés a GCstar-tól',
        'BugReportVersion' => 'Verzió',
        'BugReportPlatform' => 'Operációsrendszer',
        'BugReportMessage' => 'Hibaüzenet',
        'BugReportInformation' => 'További információk',

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
