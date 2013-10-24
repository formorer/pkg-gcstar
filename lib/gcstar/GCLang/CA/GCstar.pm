{
    package GCLang::CA;
    
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

        'LangName' => 'Català',
        
        'Separator' => ' : ',

        'Warning' => '<b>Avís</b>:

La informació descarregada des d\'Internet (gràcies als
connectors de cerca) és només per a <b>ús personal</b>

Qualsevol redistribució queda prohibida <b>sense 
l\'autorització explícita dels respectius webs</b>.

Per a saber quin és el web al que pertany la informació,
podeu usar <b>el botó situat devall dels detalls de la pel·lícula</b>.',

        'AllItemsFiltered' => 'Cap pel·lícula compleix amb els criteris de filtrat', # Accepts model codes

#Installation
        'InstallDirInfo' => 'Instal·la a ',
        'InstallMandatory' => 'Components obligatoris',
        'InstallOptional' => 'Components opcionals',
        'InstallErrorMissing' => 'Error: els components següents han d\'instal·lar-se: ',
        'InstallPrompt' => 'Directori predeterminat per a la instal·lació [/usr/local]: ',
        'InstallEnd' => 'Fi de la instal·lació',
        'InstallNoError' => 'Cap error',
        'InstallLaunch' => 'Per utilitzar l\'aplicació, executa ',
        'InstallDirectory' => 'Repertori bàsic',
        'InstallTitle' => 'Instal·lació de GCstar',
        'InstallDependencies' => 'Dependències',	
        'InstallPath' => 'Camí',
        'InstallOptions' => 'Opcions',
        'InstallSelectDirectory' => 'Trieu el directori per a la instal·lació',   
        'InstallWithClean' => 'Elimina arxius del directori d\'instal·lació.',
       	'InstallWithMenu' => 'Afegeix GCstar al menú d\'Aplicacions',
       	'InstallNoPermission' => 'Error: No teniu permisos per a instal·lar en el directori seleccionat!!',
        'InstallMissingMandatory' => 'Algunes dependències obligatòries no estan disponibles. No podreu instal·lar GCstar fins que s\'instal·lin en el sistema.',
        'InstallMissingOptional' => 'Algunes dependències opcionals no estan disponibles. Es detallen a sota. GCstar s\'instal·larà amb algunes funcions deshabilitades.',
        'InstallMissingNone' => 'Dependències satisfetes. Podeu continuar i instal·lar GCstar.',
        'InstallOK' => 'OK',
        'InstallMissing' => 'No disponible',
        'InstallMissingFor' => 'No disponible per',
        'InstallCleanDirectory' => 'Eliminats els fitxers de GCstar del directori: ',
        'InstallCopyDirectory' => 'Copiant fitxers en el directori: ',
        'InstallCopyDesktop' => 'Copiant el fitxer .desktop a: ',
        
#Update
        'UpdateUseProxy' => 'Proxy a utilitzar (si no n\'utilitzeu cap presioneu la tecla de retorn): ',
        'UpdateNoPermission' => 'Permís d\'escriptura denegat en aquest directori: ',
        'UpdateNone' => 'No s\'ha trobat cap actualització',
        'UpdateFileNotFound' => 'Fitxer no trobat',

#Splash
        'SplashInit' => 'Inicialització',
        'SplashLoad' => 'Carregant pel·lícules',
        'SplashDisplay' => 'Mostrant Col·lecció',
        'SplashSort' => 'Sorting Collection',
        'SplashDone' => 'Fet',

#Import from GCfilms
        'GCfilmsImportQuestion' => 'Sembla que heu emprat GCfilms abans. Voleu importar des de GCfilms a GCstar (no afectarà a GCfilms si el voleu seguir utilitzant)?',
        'GCfilmsImportOptions' => 'Configuració',
        'GCfilmsImportData' => 'Llista de pel.lícules',

#Menus
        'MenuFile' => '_Fitxer',
            'MenuNewList' => '_Nova llista de pel·lícules',	
            'MenuStats' => 'Estadístiques',
            'MenuHistory' => '_Fitxers oberts recentment',
            'MenuLend' => '_Mostra pel·lícules prestades', # Accepts model codes
            'MenuImport' => '_Importa',
            'MenuExport' => '_Exporta',	
            'MenuAddItem' => '_Add Items', # Accepts model codes

        'MenuEdit'  => '_Edita',
       	    'MenuDuplicate' => '_Duplica pel·lícula', # Accepts model codes
            'MenuDuplicatePlural' => 'Du_plicate Items', # Accepts model codes
            'MenuEditSelectAllItems' => 'Select _All Items', # Accepts model codes
            'MenuEditDeleteCurrent' => '_Esborra pel·lícula actual', # Accepts model codes
            'MenuEditDeleteCurrentPlural' => '_Remove Items', # Accepts model codes    
            'MenuEditFields' => '_Canvia camps Col·lecció',
            'MenuEditLockItems' => '_Bloqueja la informació',
        
        'MenuDisplay' => '_Visualitza',
            'MenuSavedSearches' => 'Cerques desades',
                 'MenuSavedSearchesSave' => 'Desa la cerca actual',
                 'MenuSavedSearchesEdit' => 'Modica cerques desades',
            'MenuAdvancedSearch' => '_Cerca avançada',
            'MenuViewAllItems' => '_Mostra tots les elements', # Accepts model codes
            'MenuNoFilter' => '_Tot',

        'MenuConfiguration' => '_Configura',	
            'MenuDisplayMenu' => 'Display',
                'MenuDisplayFullScreen' => 'Full screen',
                'MenuDisplayMenuBar' => 'Menus',
                'MenuDisplayToolBar' => 'Toolbar',
                'MenuDisplayStatusBar' => 'Bottom bar',
            'MenuDisplayOptions' => '_Informació a mostrar',
            'MenuBorrowers' => '_Prestataris',	
            'MenuToolbarConfiguration' => '_Controls de la barra d\'eines',
            'MenuDefaultValues' => 'Default values for new item', # Accepts model codes
            'MenuGenresConversion' => '_Conversió de gèneres',

        'MenuBookmarks' => 'Les _meves Col·leccions',
            'MenuBookmarksAdd' => '_Afegeix Col·lecció actual',
            'MenuBookmarksEdit' => '_Edita Col·leccions marcades',

        'MenuHelp' => '_?',
            'MenuHelpContent' => '_?',
            'MenuAllPlugins' => 'Mostra _complements',
            'MenuBugReport' => 'Comunica un _error',
            'MenuAbout' => 'A propòsit de _GCstar',	

        'MenuNewWindow' => 'Mostra elements a una nova finestra', # Accepts model codes
        'MenuNewWindowPlural' => 'Show Items in _New Window', # Accepts model codes
        
        'ContextExpandAll' => 'Expandeix tots',
        'ContextCollapseAll' => 'Colapsa tots',
        'ContextChooseImage' => 'Tria _Imatge',
        'ContextImageEditor' => 'Obri amb l\'editor d\'imatges',
        'ContextOpenWith' => 'Obri _amb',
        'ContextImgFront' => 'A sobre',
        'ContextImgBack' => 'A sota',
        'ContextChooseFile' => 'Tria un fitxer',
        'ContextChooseFolder' => 'Tria una carpeta',

        'DialogEnterNumber' => 'Entreu un valor',

        'RemoveConfirm' => 'Realment voleu eliminar aquesta pel·lícula?',  # Accepts model codes
        'RemoveConfirmPlural' => 'Do you really want to remove these items?', # Accepts model codes
 
        'DefaultNewItem' => 'Nou element', # Accepts model codes
        'NewItemTooltip' => 'Afegeix un nou element', # Accepts model codes
        'NoItemFound' => 'Cap element trobat. Voleu intentar una nova cerca a un altre lloc?',
        'OpenList' => 'Seleccioneu una col·lecció',
        'SaveList' => 'Seleccioneu on voleu desar la col·lecció',	
        'SaveListTooltip' => 'Desa la col·lecció actual', 
        'SaveUnsavedChanges' => 'Hi ha canvis no desats a la Col·lecció. Voleu desar-los?',
        'SaveDontSave' => 'No ho guardis',
        'PreferencesTooltip' => 'Canvia les preferències',
        'ViewTooltip' => 'Canvia el tipus de col·lecció',
        'PlayTooltip' => 'Reprodueix el vídeo associat a l\'element', # Accepts model codes
        'PlayFileNotFound' => 'El fitxer a reproduir no s\'ha trobat en aquest lloc:',
        'PlayRetry' => 'Torna-ho a intentar',
        
        'StatusSave' => 'Desant...',
        'StatusLoad' => 'Carregant...',
        'StatusSearch' => 'Cercant...',
        'StatusGetInfo' => 'Descarregant la informació...',
        'StatusGetImage' => 'Descarregant la imatge...',	
        
        'SaveError' => 'Impossible desar la llista d\'elements. Comproveu els permisos i l\'espai disponible en el disc.',
        'OpenError' => 'Impossible obrir la llista d\'elements. Comproveu els permisos.',
        'OpenFormatError' => 'Impossible obrir la llista d\'elements. El format pot ser incorrecte',
        'OpenVersionWarning' => 'La col·lecció s\'ha creat amb una versió més recent de GCstar. Si la deseu, podeu perdre dades.',
        'OpenVersionQuestion' => 'Encara voleu continuar?',
        'ImageError' => 'El directori triat per a desar les imatges no és correcte. Voleu triar-ne un altre?',
        'OptionsCreationError'=> 'Impossible crear el fitxer d\'opcions: ',
        'OptionsOpenError'=> 'Impossible obrir el fitxer d\'opcions: ',
        'OptionsSaveError'=> 'Impossible desar el fitxer d\'opcions: ',
        'ErrorModelNotFound' => 'Model no trobat: ',
        'ErrorModelUserDir' => 'Els models definits per l\'usuari són a: ',

        'RandomTooltip' => 'Qué voleu veure aquesta nit?',
        'RandomError'=> 'No queden elements per a seleccionar', # Accepts model codes
        'RandomEnd'=> 'No hi ha més elements', # Accepts model codes
        'RandomNextTip'=> 'Següent suggerència',
        'RandomOkTip'=> 'Accepta aquest element',
                        
        'AboutTitle' => 'A propòsit de GCstar',
        'AboutDesc' => 'Gtk2 Catàleg de pel·lícules',
        'AboutVersion' => 'Versió',
        'AboutTeam' => 'Equip',
        'AboutWho' => 'Christian Jodar (Tian): Gestió del projecte, Programació
Nyall Dawson (Zombiepig): Programació
TPF: Programació
Adolfo González: Programació
',
        'AboutLicense' => 'Distribuït segons els termes de la GNU GPL
Logos Copyright le Spektre',
        'AboutTranslation' => 'Traducció: Ponç J. Llaneras',
        'AboutDesign' => 'Łukasz Kowalczk (Qoolman): Skin Designer
Logo i disseny web per le Spektre',
        
        'ToolbarRandom' => 'Aquesta nit',

        'UnsavedCollection' => 'Col·lecció no desada',
        'ModelsSelect' => 'Seleccioneu un tipus de Col·lecció',
        'ModelsPersonal' => 'Models personals',
        'ModelsDefault' => 'Models predeterminats',
        'ModelsList' => 'Definició de Col·lecció',
        'ModelSettings' => 'Opcions de Col·lecció',
        'ModelNewType' => 'Nou tipus de Col·lecció',
        'ModelName' => 'Nom del tipus de Col·lecció:',
		'ModelFields' => 'Camps',
		'ModelOptions'	=> 'Opcions',
		'ModelFilters'	=> 'Filtres',
        'ModelNewField' => 'Nou camp',
        'ModelFieldInformation' => 'Informació',
        'ModelFieldName' => 'Etiqueta:',
        'ModelFieldType' => 'Tipus:',
        'ModelFieldGroup' => 'Grup:',
        'ModelFieldValues' => 'Valors',
        'ModelFieldInit' => 'Predeterminat:',
        'ModelFieldMin' => 'Mínim:',
        'ModelFieldMax' => 'Màxim:',
        'ModelFieldList' => 'Llista de valors:',
        'ModelFieldListLegend' => '<i>Separat per a coma</i>',
        'ModelFieldDisplayAs' => 'Mostra com:',
        'ModelFieldDisplayAsText' => 'Text',
        'ModelFieldDisplayAsGraphical' => 'Control de rati',
        'ModelFieldTypeShortText' => 'Text curt',
        'ModelFieldTypeLongText' => 'Text llarg',
        'ModelFieldTypeYesNo' => 'Sí/No',
        'ModelFieldTypeNumber' => 'Nombre',
        'ModelFieldTypeDate' => 'Data',
        'ModelFieldTypeOptions' => 'Llista de valors predefinits',
        'ModelFieldTypeImage' => 'Imatge',
        'ModelFieldTypeSingleList' => 'Llista simple',
        'ModelFieldTypeFile' => 'Fitxer',
        'ModelFieldTypeFormatted' => 'Depèn d\'altres camps',
        'ModelFieldParameters' => 'Paràmetres',
        'ModelFieldHasHistory' => 'Utilitza un històric',
        'ModelFieldFlat' => 'Mostra amb una línia',
        'ModelFieldStep' => 'Increment:',
        'ModelFieldFileFormat' => 'Format del fitxer:',
        'ModelFieldFileFile' => 'Fitxer simple',
        'ModelFieldFileImage' => 'Imatge',
        'ModelFieldFileVideo' => 'Vídeo',
        'ModelFieldFileAudio' => 'Audio',
        'ModelFieldFileProgram' => 'Programa',
        'ModelFieldFileUrl' => 'URL',
        'ModelFieldFileEbook' => 'Ebook',
        'ModelOptionsFields' => 'Camps a utilitzar',
        'ModelOptionsFieldsAuto' => 'Automàtic',
        'ModelOptionsFieldsNone' => 'Cap',
        'ModelOptionsFieldsTitle' => 'Com a títol',
        'ModelOptionsFieldsId' => 'Com a identificador',
        'ModelOptionsFieldsCover' => 'Com a coberta',
        'ModelOptionsFieldsPlay' => 'Com a botó de "Play"',
        'ModelCollectionSettings' => 'Opcions de col·lecció',
        'ModelCollectionSettingsLending' => 'Elements que es poden prestar',
        'ModelCollectionSettingsTagging' => 'Els elements es poden etiquetar',
        'ModelFilterActivated' => 'Hauria d\'estar al formulari de cerca',
        'ModelFilterComparison' => 'Comparació',
        'ModelFilterContain' => 'Conté',
        'ModelFilterDoesNotContain' => 'No conté',
        'ModelFilterRegexp' => 'Expressió regular',
        'ModelFilterRange' => 'Rang',
        'ModelFilterNumeric' => 'La comparació és numèrica',
        'ModelFilterQuick' => 'Crea un filtre ràpid',
        'ModelTooltipName' => 'Empra un nom per a reutilitzar aquest model per a moltes Col·leccions. Si està buid, les opcions es desaran directament dins la mateixa col·lecció',
        'ModelTooltipLabel' => 'El camp nom es mostrarà tal qual',
        'ModelTooltipGroup' => 'Utilitzat per agrupar camps. Els elements sense valor aquí estaran al grup predeterminat',
        'ModelTooltipHistory' => 'Els valors entrats anteriorment es desaran a una llista associada al camp',
        'ModelTooltipFormat' => 'Aquest format s\'utilitza per determinar l\'acció per obrir el fitxer amb el botó "Play"',
        'ModelTooltipLending' => 'Aquest afegirà alguns camps per manejar els préstecs',
        'ModelTooltipTagging' => 'Això afegirà alguns camps per manejar les etiquetes',
        'ModelTooltipNumeric' => 'Els valors es consideran com nombres per a la comparació',
        'ModelTooltipQuick' => 'Aquest afegirà un submenú al de filtres',

        'ResultsTitle' => 'Tria una pel·lícula', # Accepts model codes
        'ResultsNextTip' => 'Cerca en el següent lloc',
        'ResultsPreview' => 'Previsualitza',
        'ResultsInfo' => 'Podeu afegir múltiples elements a la col·lecció pitjant la tecla Ctrl o Majús i seleccionant-los', # Accepts model codes

        'OptionsTitle' => 'Preferències',
		'OptionsExpertMode' => 'Mode Expert',
        'OptionsPrograms' => 'Especifiqueu els programes a utilitzar pels diferents continguts, deixau-ho en blanc per utilitzar els predeterminats del sistema',
        'OptionsBrowser' => 'Navegador d\'Internet',
        'OptionsPlayer' => 'Reproductor de vídeo',
        'OptionsAudio' => 'Reproductor d\'audio',
        'OptionsImageEditor' => 'Editor d\'imatges',
        'OptionsCdDevice' => 'Dispositiu de CD',
        'OptionsImages' => 'Directori d\'imatges',
        'OptionsUseRelativePaths' => 'Utilitza camins relatius per a les imatges',
        'OptionsLayout' => 'Disposició',
        'OptionsStatus' => 'Mostra la barra d\'estat',	
        'OptionsUseStars' => 'Use stars to display ratings',
        'OptionsWarning' => 'Alerteu: Els canvis fets a n\'aquest formulari no es tindran en compte fins reiniciar l\'aplicació', 
        'OptionsRemoveConfirm' => 'Demana confirmació abans d\'eliminar',
        'OptionsAutoSave' => 'Desa automàticament la col·lecció',
        'OptionsAutoLoad' => 'Carrega la col·lecció prèvia a l\'inici',
        'OptionsSplash' => 'Mostra la pantalla d\'inici', 
        'OptionsTearoffMenus' => 'Activa els menús desplegables',
        'OptionsSpellCheck' => 'Utilitza la correcció ortogràfica pels camps de text llargs',
        'OptionsProgramTitle' => 'Tria el programa que ha d\'utilitzar-se',
        'OptionsPlugins' => 'Lloc per descarregar les fitxes',
        'OptionsAskPlugins' => 'Pregunta',
        'OptionsPluginsMulti' => 'Diversos llocs',
        'OptionsPluginsMultiAsk' => 'Pregunta (Diversos llocs)',
        'OptionsPluginsMultiPerField' => 'Molts llocs (per camp)',
        'OptionsPluginsMultiPerFieldWindowTitle' => 'Molts llocs per ordre de selecció de camp',
        'OptionsPluginsMultiPerFieldDesc' => 'Per a cada camp l\'omplirem amb la primera informació no buida començant per l\'esquerra',
        'OptionsPluginsMultiPerFieldFirst' => 'Primer',
        'OptionsPluginsMultiPerFieldLast' => 'Darrer',
        'OptionsPluginsMultiPerFieldRemove' => 'Elimina',
        'OptionsPluginsMultiPerFieldClearSelected' => 'Llista de camps seleccionats buida',
        'OptionsPluginsList' => 'Defineix la llista',
        'OptionsAskImport' => 'Tria els camps que han d\'importar-se',	
        'OptionsProxy' => 'Empra un proxy',	
		'OptionsCookieJar' => 'Utilitza aquesta galeta jar',
        'OptionsMain' => 'Principal',	
        'OptionsLang' => 'Idioma',	
        'OptionsPaths' => 'Directoris',
        'OptionsInternet' => 'Internet',
        'OptionsConveniences' => 'Opcions',	
        'OptionsDisplay' => 'Visualitza',
        'OptionsToolbar' => 'Barra d\'eines',	
        'OptionsToolbars' => {0 => 'Cap', 1 => 'Petita', 2 => 'Gran', 3 => 'Ajustament per sistema'},
        'OptionsToolbarPosition' => 'Posició',
        'OptionsToolbarPositions' => {0 => 'Amunt', 1 => 'Avall', 2 => 'Esquerra', 3 => 'Dreta'},
        'OptionsExpandersMode' => 'Estensors massa llargs',
        'OptionsExpandersModes' => {'asis' => 'No facis res', 'cut' => 'Talla', 'wrap' => 'Divideix les línies'},
        'OptionsDateFormat' => 'Format de data',
        'OptionsDateFormatTooltip' => 'El format es l\'utilitzat per strftime(3). Per omissió és %d/%m/%Y',
        'OptionsView' => 'Llista dels elements',
        'OptionsViews' => {0 => 'Text', 1 => 'Imatge', 2 => 'Detallada'},
        'OptionsColumns' => 'Columnes',	
        'OptionsMailer' => 'Mètode d\'enviament dels correus electrònics',
        'OptionsSMTP' => 'Servidor',
        'OptionsFrom' => 'El vostre correu electrònic',	
        'OptionsTransform' => 'Posar els articles al final dels títols',	
        'OptionsArticles' => 'Articles (separats per una coma)',	
        'OptionsSearchStop' => 'L\'usuari pot aturar las cerques',
        'OptionsBigPics' => 'Utilitza les imatges grans quan estiguin disponibles',
        'OptionsAlwaysOriginal' => 'Empra el títol principal com l\'original si no se\'n troba cap',
        'OptionsRestoreAccelerators' => 'Restaura acceleradors',
        'OptionsHistory' => 'Mida de l\'historial',
        'OptionsClearHistory' => 'Neteja l\'historial',
        'OptionsStyle' => 'Pell',
        'OptionsDontAsk' => 'No ho demanis mai més',
        'OptionsPathProgramsGroup' => 'Aplicacions',
        'OptionsProgramsSystem' => 'Utilitza els programes definits pel sistema',
        'OptionsProgramsUser' => 'Utilitza els programes especificats',
        'OptionsProgramsSet' => 'Estableix els programes',
        'OptionsPathImagesGroup' => 'Imatges',
        'OptionsInternetDataGroup' => 'Importa dades',
        'OptionsInternetSettingsGroup' => 'Opcions',
        'OptionsDisplayInformationGroup' => 'Mostra informació',
        'OptionsDisplayArticlesGroup' => 'Articles',
        'OptionsImagesDisplayGroup' => 'Mostra',
        'OptionsImagesStyleGroup' => 'Estil',
        'OptionsDetailedPreferencesGroup' => 'Preferències',
        'OptionsFeaturesConveniencesGroup' => 'Conveniències',
        'OptionsPicturesFormat' => 'Prefixe a emprar per a les imatges:',
        'OptionsPicturesFormatInternal' => 'gcstar__',
        'OptionsPicturesFormatTitle' => 'Títol o nom de l\'element associat',
        'OptionsPicturesWorkingDir' => '%WORKING_DIR% o . se substituirà amb el directori de la col·lecció (utilitzeu només en el principi del camí)',
        'OptionsPicturesFileBase' => '%FILE_BASE% se substituirà pel nom de la col·lecció sense el sufixe (.gcs)',
        'OptionsPicturesWorkingDirError' => '%WORKING_DIR% només es pot emprar en el començament del camí per a les imatges',
        'OptionsConfigureMailers' => 'Configura els programes de correu',
		       
        'ImagesOptionsButton' => 'Preferències',
        'ImagesOptionsTitle' => 'Preferències per al llistat d\'imatges',
        'ImagesOptionsSelectColor' => 'Trieu un color',
        'ImagesOptionsUseOverlays' => 'Utilitza superposició d\'imatges',
        'ImagesOptionsBg' => 'Fons',
        'ImagesOptionsBgPicture' => 'Empra una imatge de fons',
        'ImagesOptionsFg'=> 'Selecció',
        'ImagesOptionsBgTooltip' => 'Canvia el color de fons',
        'ImagesOptionsFgTooltip'=> 'Canvia el color de la selecció',
        'ImagesOptionsResizeImgList' => 'Canvia automàticament el nombre de columnes',
        'ImagesOptionsAnimateImgList' => 'Use animations',
        'ImagesOptionsSizeLabel' => 'Mida',
        'ImagesOptionsSizeList' => {0 => 'Molt Petit', 1 => 'Petit', 2 => 'Mitjà', 3 => 'Gran', 4 => 'Molt Gran'},
        'ImagesOptionsSizeTooltip' => 'Trieu la mida de la imatge',

        'DetailedOptionsTitle' => 'Preferències del llistat detallat',
        'DetailedOptionsImageSize' => 'Mida de les imatges',
        'DetailedOptionsGroupItems' => 'Agrupar elements per',
        'DetailedOptionsSecondarySort' => 'Ordena els camps pels nins',
        'DetailedOptionsFields' => 'Trieu els camps a mostrar',
        'DetailedOptionsGroupedFirst' => 'Manté junts els elements orfes',
        'DetailedOptionsAddCount' => 'Afegeix el nombre d\'elements a les categories',

        'ExtractButton' => 'Informació',
        'ExtractTitle' => 'Informació del fitxer',
        'ExtractImport' => 'Utilitza els valors',

        'FieldsListOpen' => 'Carrega una llista de camps des d\'un fitxer',
        'FieldsListSave' => 'Desa una llista de camps a un fitxer',
        'FieldsListError' => 'Aquesta llista de camps no es pot utilitzar amb aquesta classe de Col·lecció',
        'FieldsListIgnore' => '--- Ignore',

        'ExportTitle' => 'Exporta el llistat d\'elements',	
        'ExportFilter' => 'Exporta només els elements mostrats',
        'ExportFieldsTitle' => 'Camps a exportar',
        'ExportFieldsTip' => 'Trieu els camps a exportar',
        'ExportWithPictures' => 'Copia les imatges a un subdirectori',
        'ExportSortBy' => 'Ordena per',
        'ExportOrder' => 'Ordre',

        'ImportListTitle' => 'Importa un altre llistat d\'elements',
        'ImportExportData' => 'Dades',
        'ImportExportFile' => 'fitxer',
        'ImportExportFieldsUnused' => 'Camps sense utilitzar',
        'ImportExportFieldsUsed' => 'Camps utilitzats',
        'ImportExportFieldsFill' => 'Tots els camps',
        'ImportExportFieldsClear' => 'Cap camp',
        'ImportExportFieldsEmpty' => 'Heu de marcar al menys un camp',
        'ImportExportFileEmpty' => 'Especifiqueu un nom per al fitxer',
        'ImportFieldsTitle' => 'Camps a importar',
        'ImportFieldsTip' => 'Trieu els camps a importar',
        'ImportNewList' => 'Crea un nou llistat',
        'ImportCurrentList' => 'Afegeix al llistat actual',
        'ImportDropError' => 'Hi ha hagut un error obrint al menys un fitxer. Es recarregarà el llistat anterior.',
        'ImportGenerateId' => 'Genera un identificador per a cada element',

        'FileChooserOpenFile' => 'Tria el fitxer a utilitzar', 	
        'FileChooserDirectory' => 'Directori',
        'FileChooserOpenDirectory' => 'Tria un directori',	
        'FileChooserOverwrite' => 'Aquest fitxer ja existeix. Voleu substituir-lo?',
        'FileAllFiles' => 'Tots els fitxers',
        'FileVideoFiles' => 'Fitxers de vídeo',
        'FileEbookFiles' => 'Fitxers de llibres electrònics',
        'FileAudioFiles' => 'Fitxers de so',
        'FileGCstarFiles' => 'Col·leccions GCstar',

        #Some default panels
        'PanelCompact' => 'Compacte',
        'PanelReadOnly' => 'Només de lectura',
        'PanelForm' => 'Pestanyes',

        'PanelSearchButton' => 'Cerca informació',
        'PanelSearchTip' => 'Cerca informació al web sobre aquest nom',
        'PanelSearchContextChooseOne' => 'Selecciona un lloc...',
        'PanelSearchContextMultiSite' => 'Utilitza "Molts llocs"',
        'PanelSearchContextMultiSitePerField' => 'Utilitza "Molts llocs per camp"',
        'PanelSearchContextOptions' => 'Canvia opcions...',
        'PanelImageTipOpen' => 'Feu clic a la imatge per triar-ne una altre.',
        'PanelImageTipView' => 'Feu clic a la imatge per veure-la a mida real.',
        'PanelImageTipMenu' => 'Feu clic amb el botó dret per a més opcions.',
        'PanelImageTitle' => 'Tria una imatge',	
        'PanelImageNoImage' => 'Sense imatge',
        'PanelSelectFileTitle' => 'Tria un fitxer',
        'PanelLaunch' => 'Launch',
        'PanelRestoreDefault' => 'Restaura els valors per defecte',
        'PanelRefresh' => 'Actualitza',
        'PanelRefreshTip' => 'Actualitza la informació des del web',

        'PanelFrom' =>'De',
        'PanelTo' =>'Per a',

        'PanelWeb' => 'Veure la fitxa a Internet',
        'PanelWebTip' => 'Veure la fitxa de l\'element a Internet', # Accepts model codes
        'PanelRemoveTip' => 'Elimina l\'element actual', # Accepts model codes

        'PanelDateSelect' => 'Canvia la data',	
        'PanelNobody' => 'Ningú',	
        'PanelUnknown' => 'Desconegut',	
        'PanelAdded' => 'Afegeix una data',
        'PanelRating' => 'Valoració',
        'PanelPressRating' => 'Valoració de la premsa',
        'PanelLocation' => 'Lloc',

        'PanelLending' => 'Préstec',
        'PanelBorrower' => 'Prestatari',
        'PanelLendDate' => 'Data',
        'PanelHistory' => 'Historial',
        'PanelReturned' => 'Element retornat', # Accepts model codes	
        'PanelReturnDate' => 'Data de devolució',
        'PanelLendedYes' => 'Prestada',
        'PanelLendedNo' => 'Disponible',

        'PanelTags' => 'Etiquetes',
        'PanelFavourite' => 'Favorit',
        'TagsAssigned' => 'Etiquetes assignades', 

        'PanelUser' => 'Camps d\'usuari',

        'CheckUndef' => 'Qualsevol',
        'CheckYes' => 'Sí',
        'CheckNo' => 'No',

        'ToolbarAll' => 'Mostra tots',
        'ToolbarAllTooltip' => 'Mostra tots els elements',	
        'ToolbarGroupBy' => 'Agrupa per',
        'ToolbarGroupByTooltip' => 'Tria el camp per agrupar elements a la llista',
        'ToolbarQuickSearch' => 'Cerca ràpida',
        'ToolbarQuickSearchLabel' => 'Cerca',
        'ToolbarQuickSearchTooltip' => 'Seleccioneu el camp per a cercar. Entreu els termes de cerca i premeu Intro',
        'ToolbarSeparator' => ' Separador',

        'PluginsTitle' => 'Cerca un element',
        'PluginsQuery' => 'Petició',
        'PluginsFrame' => 'Lloc on cercar',
        'PluginsLogo' => 'Logotip',
        'PluginsName' => 'Nom',
        'PluginsSearchFields' => 'Camps de cerca',
        'PluginsAuthor' => 'Autor',
        'PluginsLang' => 'Idioma',
        'PluginsUseSite' => 'Utilitza el lloc seleccionat per a futures cerques',
        'PluginsPreferredTooltip' => 'Lloc recomenat per GCstar', 
        'PluginDisabled' => 'Desactivat',
       
        'BorrowersTitle' => 'Configuració dels prestataris',	
        'BorrowersList' => 'Prestataris',
        'BorrowersName' => 'Nom',
        'BorrowersEmail' => 'Correu electrònic',	
        'BorrowersAdd' => 'Afegeix',
        'BorrowersRemove' => 'Elimina',	
        'BorrowersEdit' => 'Modifica',	
        'BorrowersTemplate' => 'Model de correu electrònic',	
        'BorrowersSubject' => 'Títol del correu electrònic',	
        'BorrowersNotice1' => '%1 es substituirà pel nom del prestatari',	
        'BorrowersNotice2' => '%2 es substituirà pel títol de l\'element',	
        'BorrowersNotice3' => '%3 es substituirà per la data del préstec',	
      
        'BorrowersImportTitle' => 'Importa informació dels prestataris',
        'BorrowersImportType' => 'Format del fitxer:',
        'BorrowersImportFile' => 'Fitxer:',

        'BorrowedTitle' => 'Elements prestats', # Accepts model codes
        'BorrowedDate' => 'Des del',
        'BorrowedDisplayInPanel' => 'Mostra l\'element a la finestra principal', # Accepts model codes
        
        'MailTitle' => 'Envia un correu electrònic',	
        'MailFrom' => 'De: ',	
        'MailTo' => 'A: ',	
        'MailSubject' => 'Tema: ',
        'MailSmtpError' => 'Problema de connexió amb el servidor SMTP',	
        'MailSendmailError' => 'Problema executant sendmail',	

        'SearchTooltip' => 'Cerca a tots els elements', # Accepts model codes
        'SearchTitle' => 'Cerca elements', # Accepts model codes	
        'SearchNoField' => 'No heu seleccionat cap camp a la finestra de cerca.
Afegiu-ne alguns a la pestanya de filtres de la configuració de col·lecció.',
                
        'QueryReplaceField' => 'Camp per canviar',
        'QueryReplaceOld' => 'Nom actual',	
        'QueryReplaceNew' => 'Nom nou',	
        'QueryReplaceLaunch' => 'Canvia',
        
        'ImportWindowTitle' => 'Tria els camps que han d\'importar-se',	
        'ImportViewPicture' => 'Mostra la imatge',
        'ImportSelectAll' => 'Selecciona-ho tot',	
        'ImportSelectNone' => 'No seleccionis res',  

        'MultiSiteTitle' => 'Llocs on cercar',
        'MultiSiteUnused' => 'Connectors no utilitzats',
        'MultiSiteUsed' => 'Connectors a utilitzar',
        'MultiSiteLang' => 'Utilitza tots els connectors espanyols',
        'MultiSiteEmptyError' => 'La llista de llocs està buida',
        'MultiSiteClear' => 'Buida la llista',

        'DisplayOptionsTitle' => 'Elements a mostrar',
        'DisplayOptionsAll' => 'Selecciona-ho tot',
        'DisplayOptionsSearch' => 'Cerca',

        'GenresTitle' => 'Conversió de gèneres',
        'GenresCategoryName' => 'Gènere a utilitzar',
        'GenresCategoryMembers' => 'Gèneres a canviar',
        'GenresLoad' => 'Carrega una llista predefinida',
        'GenresExport' => 'Desa la llista a un fitxer',
        'GenresModify' => 'Edita la conversió',

        'PropertiesName' => 'Nom de la col·lecció',
        'PropertiesLang' => 'Codi d\'idioma',
        'PropertiesOwner' => 'Propietari',
        'PropertiesEmail' => 'Correu electrònic',
        'PropertiesDescription' => 'Descripció',
        'PropertiesFile' => 'Informació del fitxer',
        'PropertiesFilePath' => 'Cami complet',
        'PropertiesItemsNumber' => 'Nombre d\'elements', # Accepts model codes
        'PropertiesFileSize' => 'Mida',
        'PropertiesFileSizeSymbols' => ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
        'PropertiesCollection' => 'Propietats de la col·lecció',
        'PropertiesDefaultPicture' => 'Imatge per omissió',

        'MailProgramsTitle' => 'Programes per enviar correu',
        'MailProgramsName' => 'Nom',
        'MailProgramsCommand' => 'Línia d\'ordres',
        'MailProgramsRestore' => 'Restaura els valors per defecte',
        'MailProgramsAdd' => 'Afegeix un programa',
        'MailProgramsInstructions' => 'A la línia d\'ordres, es fan algunes substitucions:
 %f es substituirà pel correu electrònic de l\'usuari.
 %t es substituirà per l\'adreça.
 %s es substituirà pel subjecte del missatge.
 %b es substituirà pel cos del missatge.',

        'BookmarksBookmarks' => 'Marques',
        'BookmarksFolder' => 'Directoris',
        'BookmarksLabel' => 'Etiqueta',
        'BookmarksPath' => 'Camí',
        'BookmarksNewFolder' => 'Nova carpeta',

        'AdvancedSearchType' => 'Tipus de cerca',
        'AdvancedSearchTypeAnd' => 'Elements que compleixen amb tots els criteris', # Accepts model codes
        'AdvancedSearchTypeOr' => 'Elements que compleixen al menys amb un criteri', # Accepts model codes
        'AdvancedSearchCriteria' => 'Criteri',
        'AdvancedSearchAnyField' => 'Any field',
        'AdvancedSearchSaveTitle' => 'Desa la cerca',
        'AdvancedSearchSaveName' => 'Nom',
        'AdvancedSearchSaveOverwrite' => 'Ja existeix una cerca desada amb aquest nom. Trieu-ne un altre.',
        'AdvancedSearchUseCase' => 'Sensible a les majúscules',
        'AdvancedSearchIgnoreDiacritics' => 'Ignora els accents',

        'BugReportSubject' => 'Informe d\'error generat per GCstar',
        'BugReportVersion' => 'Versió',
        'BugReportPlatform' => 'Sistema Operatiu',
        'BugReportMessage' => 'Missatge d\'error',
        'BugReportInformation' => 'Informació adicional',

#Statistics
        'Stats3DPie' => 'Pastís 3D',
        'StatsAccumulate' => 'Acumula valors',
        'StatsArea' => 'Àrees',
        'StatsBars' => 'Barres',
        'StatsDisplayNumber' => 'Mostra nombres',
        'StatsFieldToUse' => 'Camp a utilitzar',
        'StatsFontSize' => 'Mida de la font',
        'StatsGenerate' => 'Genera',
        'StatsHeight' => 'Alçada',
        'StatsHistory' => 'Història',
        'StatsKindOfGraph' => 'Tipus de gràfica',
        'StatsPie' => 'Pastís',
        'StatsSave' => 'Desa la imatge de les estadístiques a un fitxer',
        'StatsShowAllDates' => 'Mostra totes les dates',
        'StatsSortByNumber' => 'Ordena pel nombre de {lowercaseX}',
        'StatsWidth' => 'Amplada',

        'DefaultValuesTip' => 'Values set in this window will be used as the default values when creating a new {lowercase1}',
    );
}
1;
