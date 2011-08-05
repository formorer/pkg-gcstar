{
    package GCLang::IT;
    
    use utf8;
######################################################
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
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
#######################################################
#
#  v1.0.2 - Italian localization by Andreas Troschka
#
#  for GCstar v1.1.1
#
#######################################################

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

        'LangName' => 'Italiano',
        
        'Separator' => ': ',
        
        'Warning' => '<b>Attenzione</b>:
        
Le informazioni scaricate dai siti Internet (con i plugin di ricerca) sono previste
<b>esclusivamente per l\'uso personale</b>.

La loro redistributione senza l\'esplicita autorizzazione scritta dei siti web e\'
<b>severamente vietata!</b> e viene penalmente perseguita!

Per determinare il sito web proprietario delle informazioni consultare l\'etichetta <b>[dettagli]</b>.',
        
        'AllItemsFiltered' => 'Nessun articolo soddisfa ai criteri di filtro selezionati', # Accepts model codes

#Installation
        'InstallDirInfo' => 'Installazione in ',
        'InstallMandatory' => 'Componenti obbligatorie',
        'InstallOptional' => 'Componenti opzionali',
        'InstallErrorMissing' => 'Errore : Occorre installare le seguenti componenti Perl: ',
        'InstallPrompt' => 'Directory radice d\'installazione [es. /usr/local]: ',
        'InstallEnd' => 'Installazione terminata',
        'InstallNoError' => 'Nessun errore',
        'InstallLaunch' => 'Per utilizzare questa applicazione si puo\' lanciare ',
        'InstallDirectory' => 'Directory radice',
        'InstallTitle' => 'Installazione di GCstar',
        'InstallDependencies' => 'Dipendenze',
        'InstallPath' => 'Percorso',
        'InstallOptions' => 'Opzioni',
        'InstallSelectDirectory' => 'Selezionare la directory radice per l\'installazione',
        'InstallWithClean' => 'Rimuovere i file trovati nella directory di installazione',
       	'InstallWithMenu' => 'Aggiungere GCstar al menu\' Applicazioni',
       	'InstallNoPermission' => 'Errore: Diritti di scrittura mancanti per la directory selezionata',
        'InstallMissingMandatory' => 'Alcune dipendenze necessarie sono mancanti. Non e\' possibile installare GCstar sinche\' esse non sono presenti nel sistema.',
        'InstallMissingOptional' => 'Mancano alcune dipendenze opzionali, elencate qui sotto. There are listed under. GCstar verra\' installato ma alcune funzioni non saranno disponibili.',
        'InstallMissingNone' => 'Tutte le dipendenze sono soddisfatte. Continuare con l\'installazione di GCstar.',
        'InstallOK' => 'OK',
        'InstallMissing' => 'Mancante',
        'InstallMissingFor' => 'Mancante per',
        'InstallCleanDirectory' => 'Rimozione dei file di GCStar dalla directory: ',
        'InstallCopyDirectory' => 'Copia dei file nella directory: ',
        'InstallCopyDesktop' => 'Copia dei file di desktop in: ',
        
#Update
        'UpdateUseProxy' => 'Proxy (premere Invio se nessuno): ',
        'UpdateNoPermission' => 'Diritti di scrittura negati per questa directory: ',
        'UpdateNone' => 'Non e\' stato trovato alcun aggiornamento',
        'UpdateFileNotFound' => 'File non trovato',

#Splash
        'SplashInit' => 'Inizializzazione',
        'SplashLoad' => 'Caricamento Collezione',
        'SplashDisplay' => 'Visualizzazione Collezione',
        'SplashSort' => 'Sorting Collection',
        'SplashDone' => 'Finito!',

#Import from GCfilms
        'GCfilmsImportQuestion' => 'Sono stati individuati elementi di GCfilms. Cosa si vuole importare di GCfilms in GCstar? (e\' comunque possibile continuare ad utilizzare GCfilms in parallelo)',
        'GCfilmsImportOptions' => 'Impostazioni',
        'GCfilmsImportData' => 'Collezione film',

#Menus
        'MenuFile' => 'File',
            'MenuNewList' => '_Nuova collezione',
            'MenuStats' => 'Statistics',
            'MenuHistory' => 'Ultime collezioni aperte',
            'MenuLend' => 'Visualizza articoli prestati', # Accepts model codes
            'MenuImport' => '_Importa',
            'MenuExport' => '_Esporta',
            'MenuAddItem' => '_Add Items', # Accepts model codes

		'MenuEdit'  => 'Modifica',
            'MenuDuplicate' => '_Duplica articolo', # Accepts model codes
            'MenuDuplicatePlural' => 'Du_plicate articolos', # Accepts model codes
            'MenuEditSelectAllItems' => 'Select _All Articolos', # Accepts model codes
            'MenuEditDeleteCurrent' => '_Rimuovi articolo corrente',, # Accepts model codes
            'MenuEditDeleteCurrentPlural' => '_Remove articolo', # Accepts model codes  
            'MenuEditFields' => '_Cambia campi della collezione',
    		'MenuEditLockItems' => 'B_locca la collezione',

        'MenuDisplay' => 'F_iltri',
            'MenuSavedSearches' => 'Saved searches',
                'MenuSavedSearchesSave' => 'Save current search',
                'MenuSavedSearchesEdit' => 'Modify saved searches',
            'MenuAdvancedSearch' => 'Ricerca Avanzata',
            'MenuViewAllItems' => 'Mostr_a tutti gli articoli', # Accepts model codes
            'MenuNoFilter' => 'Tutti',
        
        'MenuConfiguration' => 'Configurazione',
            'MenuDisplayOptions' => 'Visualizzazione articoli',
            'MenuBorrowers' => 'Gestione prestiti',
            'MenuToolbarConfiguration' => '_Toolbar controls',
            'MenuGenresConversion' => '_Conversione di Genere',

        'MenuBookmarks' => '_Collezioni',
            'MenuBookmarksAdd' => '_Aggiungi collezione corrente',
            'MenuBookmarksEdit' => '_Edita collezioni selezionate',

        'MenuHelp' => '?',
            'MenuHelpContent' => 'Contenuti',
            'MenuAllPlugins' => 'Mostra _plugin',
            'MenuBugReport' => 'Segnala un _bug',
            'MenuAbout' => 'Su GCstar',

        'MenuNewWindow' => 'Visulizza articoli in una nuova finestra', # Accepts model codes
        'MenuNewWindowPlural' => 'Visulizza articoli in una nuova finestra', # Accepts model codes
        
        'ContextExpandAll' => 'Espandi tutti',
        'ContextCollapseAll' => 'Collassa tutti',
        'ContextChooseImage' => 'Choose _Image',
        'ContextOpenWith' => 'Open Wit_h',
        'ContextImageEditor' => 'Image Editor', 
        'ContextImgFront' => 'Front',
        'ContextImgBack' => 'Back',
        'ContextChooseFile' => 'Choose a File',
        'ContextChooseFolder' => 'Choose a Folder',

        'DialogEnterNumber' => 'Immetere valore',

        'RemoveConfirm' => 'Desideri davvero rimuovere questo articolo?', # Accepts model codes
        'RemoveConfirmPlural' => 'Do you really want to remove these items?', # Accepts model codes
        'DefaultNewItem' => 'Nuovo articolo', # Accepts model codes
        'NewItemTooltip' => 'Aggiungi un nuovo articolo', # Accepts model codes
        'NoItemFound' => 'Nessun articolo trovato. Effettuare una ricerca su un altro sito?',
        'OpenList' => 'Scegliere collezione',
        'SaveList' => 'Scegli il nome e dove salvare la collezione',
        'SaveListTooltip' => 'Salva collezione corrente',
        'SaveUnsavedChanges' => 'Ci sono modifiche alla collezione non ancora salvate. Salvarle?',
        'SaveDontSave' => 'Non salvare',
        'PreferencesTooltip' => 'Impostazione preferenze',
        'ViewTooltip' => 'Cambia visualizzazione',
        'PlayTooltip' => 'Mostra il video associato all\'articolo', # Accepts model codes
        'PlayFileNotFound' => 'File to launch was not found in this location:',
        'PlayRetry' => 'Retry',

        'StatusSave' => 'Salvataggio...',
        'StatusLoad' => 'Caricamento...',
        'StatusSearch' => 'Ricerca in atto...',
        'StatusGetInfo' => 'Recupero informazioni...',
        'StatusGetImage' => 'Recupero immagine...',
                
        'SaveError' => 'Impossibile salvare la collezione! Controllare i diritti di accesso e lo spazio libero sul disco.',
        'OpenError' => 'Impossibile caricare la collezione! Controllare i diritti di accesso.',
        'OpenFormatError' => 'Impossibile interpretare la collezione! Formato probabilmente scorretto.',
        'OpenVersionWarning' => 'Collection was created with a more recent version of GCstar. If you save it, you may loose some data.',
        'OpenVersionQuestion' => 'Do you still want to continue?',
        'ImageError' => 'Directory non corretta! Selezionarne un\'altra.',
        'OptionsCreationError'=> 'Generazione file opzioni impossibile: ',
        'OptionsOpenError'=> 'Caricamento file opzioni impossibile: ',
        'OptionsSaveError'=> 'Salvataggio file opzioni impossibile: ',
        'ErrorModelNotFound' => 'Model not found: ',
        'ErrorModelUserDir' => 'User defined models are in: ',

        'RandomTooltip' => 'Articoli non visti',
        'RandomError'=> 'Non ci sono articoli non visti', # Accepts model codes
        'RandomEnd'=> 'Non ci sono piu\' articoli', # Accepts model codes
        'RandomNextTip'=> 'Prossimo suggerimento',
        'RandomOkTip'=> 'Accetto questo articolo',
        
        'AboutTitle' => 'Su GCstar',
        'AboutDesc' => 'Manager di collezioni',
        'AboutVersion' => 'Versione',
        'AboutTeam' => 'Team',
        'AboutWho' => 'Christian Jodar (Tian) : Project Manager, Programmatore
Nyall Dawson (Zombiepig) : Programmatore
TPF : Programmatore
Adolfo González : Programmatore
',
        'AboutLicense' => 'Distribuito nei i termini della GNU GPL
Logo Copyright le Spektre
http://le-spektre.org',
        'AboutTranslation' => 'Traduzione italiana v1.0.2 - 2006-05-04 di: 
Andreas Troschka - <swsolutions@om.it.eu.org>',
        'AboutDesign' => 'Łukasz Kowalczk (Qoolman): Skin Designer
Logo e webdesign di le Spektre',

        'ToolbarRandom' => 'Non visti',

        'UnsavedCollection' => 'Unsaved Collection',
        'ModelsSelect' => 'Selezionare un modello/collezione',
        'ModelsPersonal' => 'Personali',
        'ModelsDefault' => 'Predefiniti',
        'ModelsList' => 'Definizione collezione',
        'ModelSettings' => 'Impostazioni della collezione',
        'ModelNewType' => 'Nuovo modello di collezione',
        'ModelName' => 'Nome modello di collezione:',
		'ModelFields' => 'Campi',
		'ModelOptions'	=> 'Opzioni',
		'ModelFilters'	=> 'Filtri',
        'ModelNewField' => 'Nuovo campo',
        'ModelFieldInformation' => 'Informazioni',
        'ModelFieldName' => 'Etichetta:',
        'ModelFieldType' => 'Tipo:',
        'ModelFieldGroup' => 'Gruppo:',
        'ModelFieldValues' => 'Valori',
        'ModelFieldInit' => 'Predefiniti:',
        'ModelFieldMin' => 'Minimo:',
        'ModelFieldMax' => 'Massimo:',
        'ModelFieldList' => 'Lista valori:',
        'ModelFieldListLegend' => '<i>separati da virgole</i>',
        'ModelFieldDisplayAs' => 'Display as:',
        'ModelFieldDisplayAsText' => 'Text',
        'ModelFieldDisplayAsGraphical' => 'Rating Control',
        'ModelFieldTypeShortText' => 'Testo corto',
        'ModelFieldTypeLongText' => 'Testo lungo',
        'ModelFieldTypeYesNo' => 'Si/No',
        'ModelFieldTypeNumber' => 'Numero',
        'ModelFieldTypeDate' => 'Data',
        'ModelFieldTypeOptions' => 'Lista valori predefiniti',
        'ModelFieldTypeImage' => 'Immagine',
        'ModelFieldTypeSingleList' => 'Lista semplice',
        'ModelFieldTypeFile' => 'File',
        'ModelFieldTypeFormatted' => 'Dipendente da altri campi',
        'ModelFieldParameters' => 'Parametri',
        'ModelFieldHasHistory' => 'Utilizza la cronologia',
        'ModelFieldFlat' => 'Visualizza su una riga',
        'ModelFieldStep' => 'Passi di incremento:',
        'ModelFieldFileFormat' => 'Formato file:',
        'ModelFieldFileFile' => 'File semplice',
        'ModelFieldFileImage' => 'Immagine',
        'ModelFieldFileVideo' => 'Video',
        'ModelFieldFileAudio' => 'Audio',
        'ModelFieldFileProgram' => 'Programma',
        'ModelFieldFileUrl' => 'URL',
        'ModelFieldFileEbook' => 'Ebook',
        'ModelOptionsFields' => 'Campi da utilizzare',
        'ModelOptionsFieldsAuto' => 'Automatico',
        'ModelOptionsFieldsNone' => 'Nessuno',
        'ModelOptionsFieldsTitle' => 'Come titolo',
        'ModelOptionsFieldsId' => 'Come identificatore',
        'ModelOptionsFieldsCover' => 'Come copertina',
        'ModelOptionsFieldsPlay' => 'Per pulsante Play',
        'ModelCollectionSettings' => 'Impostazioni collezione',
        'ModelCollectionSettingsLending' => 'Prestabile',
        'ModelCollectionSettingsTagging' => 'Items can be tagged',
        'ModelFilterActivated' => 'Nel box di ricerca',
        'ModelFilterComparison' => 'Comparazione',
        'ModelFilterContain' => 'Contiene',
        'ModelFilterDoesNotContain' => 'Does not contain',
        'ModelFilterRegexp' => 'Regular expression',
        'ModelFilterRange' => 'Campo',
        'ModelFilterNumeric' => 'Comparazione numerica',
        'ModelFilterQuick' => 'Creazione filtro veloce',
        'ModelTooltipName' => 'Specifica un nome per riutilizzare questo modello in altre collezioni. In caso di nome nullo le impostazioni verranno registrate dentro il file della collezione stessa, ma non saranno piu\' disponibili per altre collezioni.',
        'ModelTooltipLabel' => 'Il nome del campo cosi\' come deve essere visualizzato',
        'ModelTooltipGroup' => 'Utilizzato per raggruppare campi. Articoli con valore nullo verranno inseriti in un gruppo predefinito',
        'ModelTooltipHistory' => 'I valori precedentemente inseriti devono essere salvati in una lista associata al campo?',
        'ModelTooltipFormat' => 'Questo formato viene utilizzato per determinare l\'azione necessaria per aprire il file mediante il tasto Play',
        'ModelTooltipLending' => 'Aggiunge alcuni campi per la gestione dei prestiti',
        'ModelTooltipTagging' => 'This will add some fields to manage tags',
        'ModelTooltipNumeric' => 'Nella comparazione i valori sono considerati numeri',
        'ModelTooltipQuick' => 'Aggiunge una voce di submenu\' nel menu\' filtri',

        'ResultsTitle' => 'Seleziona un articolo', # Accepts model codes
        'ResultsNextTip' => 'Cerca nel prossimo sito',
        'ResultsPreview' => 'Anteprima',
        'ResultsInfo' => 'You can add multiple items to the collection by holding down the Ctrl or the Shift key and selecting them', # Accepts model codes
        
        'OptionsTitle' => 'Preferenze',
		'OptionsExpertMode' => 'Expert Mode',
        'OptionsPrograms' => 'Specify applications to use for different media, leave blank to use system defaults',
        'OptionsBrowser' => 'Web browser',
        'OptionsPlayer' => 'Video player',
        'OptionsAudio' => 'Audio player',
        'OptionsImageEditor' => 'Image editor',
        'OptionsCdDevice' => 'CD device',
        'OptionsImages' => 'Indice di immagini',
        'OptionsUseRelativePaths' => 'Utilizza percorsi relativi per le immagini',
        'OptionsLayout' => 'Maschera',
        'OptionsStatus' => 'Visualizza la barra di stato in fondo alla finestra',
        'OptionsUseStars' => 'Use stars to display ratings',
        'OptionsWarning' => 'Attenzione:  Le modifiche eventualmente appportate in questo pannello avranno effetto solo dopo il riavvio dell\' applicazione GCstar!!!',
        'OptionsRemoveConfirm' => 'Chiedi conferma prima di rimuovere un articolo dalla collezione',
        'OptionsAutoSave' => 'Salva automaticamente la collezione',
        'OptionsAutoLoad' => 'All\'avvio carica l\'ultima collezione trattata',
        'OptionsSplash' => 'Mostra splashscreen',
        'OptionsTearoffMenus' => 'Enable tear-off menus',
        'OptionsSpellCheck' => 'Use spelling checker for long text fields',
        'OptionsProgramTitle' => 'Seleziona il programma per essere usato',
		'OptionsPlugins' => 'Siti da utilizzare per le informazioni degli articoli',
		'OptionsAskPlugins' => 'Chiedi (Tutti i siti)',
		'OptionsPluginsMulti' => 'Diversi siti',
		'OptionsPluginsMultiAsk' => 'Chiedi (Diversi siti)',
        'OptionsPluginsMultiPerField' => 'Diversi siti (per field)',
        'OptionsPluginsMultiPerFieldWindowTitle' => 'Many sites per field order selection',
        'OptionsPluginsMultiPerFieldDesc' => 'For each selected field we will return the first non empty information beginning from left',
        'OptionsPluginsMultiPerFieldFirst' => 'First',
        'OptionsPluginsMultiPerFieldLast' => 'Last',
        'OptionsPluginsMultiPerFieldRemove' => 'Remove',
        'OptionsPluginsMultiPerFieldClearSelected' => 'Empty selected field list',
		'OptionsPluginsList' => 'Configura la lista',
        'OptionsAskImport' => 'Seleziona i campi da importare',
		'OptionsProxy' => 'Usa un proxy',
		'OptionsCookieJar' => 'Use this cookie jar file',
        'OptionsLang' => 'Lingua',
        'OptionsMain' => 'Principale',
        'OptionsPaths' => 'Percorsi',
        'OptionsInternet' => 'Internet',
        'OptionsConveniences' =>'Strumenti',
        'OptionsDisplay' => 'Visualizzazione',
        'OptionsToolbar' => 'Toolbar',
        'OptionsToolbars' => {0 => 'Nessuno', 1 => 'Piccolo', 2 => 'Grande', 3 => 'System setting'},
        'OptionsToolbarPosition' => 'Posizione',
        'OptionsToolbarPositions' => {0 => 'In alto', 1 => 'In basso', 2 => 'A sinistra', 3 => 'A destra'},
        'OptionsExpandersMode' => 'Expanders too long',
        'OptionsExpandersModes' => {'asis' => 'Do nothing', 'cut' => 'Cut', 'wrap' => 'Line wrap'},
        'OptionsDateFormat' => 'Date Format',
        'OptionsDateFormatTooltip' => 'Format is the one used by strftime(3). Default is %d/%m/%Y',
        'OptionsView' => 'Visualizzazione articoli',
        'OptionsViews' => {0 => 'Testo', 1 => 'Immagine', 2 => 'Dettagli'},
        'OptionsColumns' => 'Colonne',
        'OptionsMailer' => 'Metodo di invio',
        'OptionsSMTP' => 'Server',
        'OptionsFrom' => 'Mittente e-mail',
        'OptionsTransform' => 'Mettere gli articoli alla fine dei titoli',
        'OptionsArticles' => 'Articoli (separare mediante virgola)',
        'OptionsSearchStop' => 'L\'utente può arrestare una ricerca',
        'OptionsBigPics' => 'Use big pictures when available',
        'OptionsAlwaysOriginal' => 'Utilizza il titolo principale come originale in mancanza di uno specificato',
        'OptionsRestoreAccelerators' => 'Restore accelerators',
        'OptionsHistory' => 'Dimensione della cronologia',
        'OptionsClearHistory' => 'Cancella cronologia',
		'OptionsStyle' => 'Skin',
        'OptionsDontAsk' => 'Non chiedere piu\'',
        'OptionsPathProgramsGroup' => 'Applicazioni',
        'OptionsProgramsSystem' => 'Utilizza i programmi definiti dal sistema',
        'OptionsProgramsUser' => 'Utilizza i programmi specificati',
        'OptionsProgramsSet' => 'Impostazione programmi',
        'OptionsPathImagesGroup' => 'Immagini',
        'OptionsInternetDataGroup' => 'Importazione dati',
        'OptionsInternetSettingsGroup' => 'Impostazioni',
        'OptionsDisplayInformationGroup' => 'Informazioni',
        'OptionsDisplayArticlesGroup' => 'Articoli',
        'OptionsImagesDisplayGroup' => 'Display',
        'OptionsImagesStyleGroup' => 'Stile',
        'OptionsDetailedPreferencesGroup' => 'Preferenze',
        'OptionsFeaturesConveniencesGroup' => 'Conveniences',
        'OptionsPicturesFormat' => 'Prefisso per le immagini:',
        'OptionsPicturesFormatInternal' => 'gcstar__',
        'OptionsPicturesFormatTitle' => 'Titolo o nome dell\'articolo associato',
        'OptionsPicturesWorkingDir' => '%WORKING_DIR% o . verra\' rimpiazzato dal nome della directory della collezione (utilizza solo all\'inizio del percorso)',
        'OptionsPicturesFileBase' => '%FILE_BASE% verra\'  rimpiazzato dal nome della collezione senza il suffisso (.gcs)',
        'OptionsPicturesWorkingDirError' => '%WORKING_DIR% puo\' essere utilizzato solo all\'inizio del percorso che punta alle immagini',
        'OptionsConfigureMailers' => 'Configura programmi di posta',

        'ImagesOptionsButton' => 'Impostazioni',
        'ImagesOptionsTitle' => 'Impostazioni della lista delle immagini',
        'ImagesOptionsSelectColor' => 'Seleziona un colore',
        'ImagesOptionsUseOverlays' => 'Use image overlays',
        'ImagesOptionsBg' => 'Sfondo',
        'ImagesOptionsBgPicture' => 'Usa un\'immagine come sfondo',
        'ImagesOptionsFg'=> 'Selezione',
        'ImagesOptionsBgTooltip' => 'Cambia colore di sfondo',
        'ImagesOptionsFgTooltip'=> 'Cambia il colore di selezione',
        'ImagesOptionsResizeImgList' => 'Automatically change number of columns',
        'ImagesOptionsSizeLabel' => 'Dimensione',
        'ImagesOptionsSizeList' => {0 => 'Ultra piccola', 1 => 'Piccola', 2 => 'Media', 3 => 'Grande', 4 => 'Extra Grande'},
        'ImagesOptionsSizeTooltip' => 'Seleziona dimensioni immagine',
		        
        'DetailedOptionsTitle' => 'Impostazioni lista dettagliata',
        'DetailedOptionsImageSize' => 'Dimensioni immagine',
        'DetailedOptionsGroupItems' => 'Raggruppa gli articoli per',
        'DetailedOptionsSecondarySort' => 'Sort field for children',
		'DetailedOptionsFields' => 'Scegli i campi da visualizzare',
        'DetailedOptionsGroupedFirst' => 'Keep together orphaned items',
        'DetailedOptionsAddCount' => 'Add number of elements on categories',

        'ExtractButton' => 'Informazioni',
        'ExtractTitle' => 'Informazioni file',
        'ExtractImport' => 'Utilizza i valori',

        'FieldsListOpen' => 'Caricare un elenco di campi da un file',
        'FieldsListSave' => 'Salvare un elenco di campi in un file',
        'FieldsListError' => 'L\'elenco di campi non puo\' essere utilizzato con questo modello di collezione',
        'FieldsListIgnore' => '--- Ignore',

        'ExportTitle' => 'Gestione elenco campi da esportare',
        'ExportFilter' => 'Esportare solo i campi visualizzati',
        'ExportFieldsTitle' => 'Campi da esportare',
        'ExportFieldsTip' => 'Campi prescelti per l\'esportazione',
        'ExportWithPictures' => 'Copiare le immagini in una sottodirectory',
        'ExportSortBy' => 'Sort by',
        'ExportOrder' => 'Order',

        'ImportListTitle' => 'Importazione della collezione:',
        'ImportExportData' => 'Dati',
        'ImportExportFile' => 'Elenco',
        'ImportExportFieldsUnused' => 'Campi non selezionati',
        'ImportExportFieldsUsed' => 'Campi selezionati',
        'ImportExportFieldsFill' => 'Tutti i campi',
        'ImportExportFieldsClear' => 'Nessun campo',
        'ImportExportFieldsEmpty' => 'Occorre selezionare almeno un campo',
        'ImportExportFileEmpty' => 'Specificare un nome per il file',
        'ImportFieldsTitle' => 'Campi da importare',
        'ImportFieldsTip' => 'Scegliere i campi da importare',
        'ImportNewList' => 'Creare una nuova collezione',
        'ImportCurrentList' => 'Aggiungere alla collezione corrente',
        'ImportDropError' => 'Si e\' verificato un errore durante l\'apertura di almeno un file. Viene ricaricata la precedente collezione!',
        'ImportGenerateId' => 'Generare identificatore per ogni articolo',

        'FileChooserOpenFile' => 'Selezionare l\'elenco',
        'FileChooserDirectory' => 'Directory',
        'FileChooserOpenDirectory' => 'Seleziona un indice',
        'FileChooserOverwrite' => 'Questa collezione esiste gia\', sovrascriverla?',
        'FileAllFiles' => 'All Files',
        'FileVideoFiles' => 'Video Files',
        'FileEbookFiles' => 'Ebook Files',
        'FileAudioFiles' => 'Audio Files',
        'FileGCstarFiles' => 'GCstar Collections',

        'PanelCompact' => 'Compattare',
        'PanelReadOnly' => 'Sola lettura',
        'PanelForm' => 'Etichette',

        'PanelSearchButton' => 'Recupera informazioni',
        'PanelSearchTip' => 'Cerca informazioni secondo il titolo dell\'articolo inserito',
        'PanelSearchContextChooseOne' => 'Choose a site ...',
        'PanelSearchContextMultiSite' => 'Use "Many sites"',
        'PanelSearchContextMultiSitePerField' => 'Use "Many sites per field"',
        'PanelSearchContextOptions' => 'Change options ...',
        'PanelImageTipOpen' => 'Clicca sull\'immagine per sceglierne un\'altra.',
        'PanelImageTipView' => 'Clicca sull\'immagine per visualizzare in grandezza naturale.',
        'PanelImageTipMenu' => 'Clicca tasto destro per piu\' opzioni.',
        'PanelImageTitle' => 'Scegliere un\'immagine',
        'PanelImageNoImage' => 'Nessuna immagine',
        'PanelSelectFileTitle' => 'Seleziona un file',
        'PanelLaunch' => 'Launch',        
        'PanelRestoreDefault' => 'Ripristina predefiniti',
        'PanelRefresh' => 'Update',
        'PanelRefreshTip' => 'Update information from web',

        'PanelFrom' =>'From',
        'PanelTo' =>'To',

        'PanelWeb' => 'Leggi informazioni dell\'articolo',
        'PanelWebTip' => 'Leggi informazioni su questo articolo e disponibili sul web', # Accepts model codes
        'PanelRemoveTip' => 'Rimuovi l\'articolo corrente', # Accepts model codes

        'PanelDateSelect' => 'Scegli una data',
        'PanelNobody' => 'Nessuno',
        'PanelUnknown' => 'Sconosciuta',
        'PanelAdded' => 'Aggiungi data',
        'PanelRating' => 'Valutazione',
        'PanelPressRating' => 'Press Rating',
        'PanelLocation' => 'Luogo',
        
        'PanelLending' => 'Prestiti',
        'PanelBorrower' => 'Prestiti',
        'PanelLendDate' => 'Data',
        'PanelHistory' => 'Cronologia',
        'PanelReturned' => 'Articolo restituito', # Accepts model codes
        'PanelReturnDate' => 'Data restituzione',
        'PanelLendedYes' => 'Prestato',
        'PanelLendedNo' => 'Disponibile',

        'PanelTags' => 'Tags',
        'PanelFavourite' => 'Favourite',
        'TagsAssigned' => 'Assigned Tags', 

        'PanelUser' => 'User fields',

        'CheckUndef' => 'Nessun problema',
        'CheckYes' => 'Sì',
        'CheckNo' => 'No',

        'ToolbarAll' => 'Mostra tutto',
        'ToolbarAllTooltip' => 'Visualizza tutti gli articoli',
        'ToolbarGroupBy' => 'Raggruppa per',
        'ToolbarGroupByTooltip' => 'Selezionare il campo da utilizzare per raggruppare gli articoli della collezione',
        'ToolbarQuickSearch' => 'Quick search',
        'ToolbarQuickSearchLabel' => 'Search',
        'ToolbarQuickSearchTooltip' => 'Select the field to search in. Enter the search terms and press Enter',
        'ToolbarSeparator' => ' Separator',
               
        'PluginsTitle' => 'Cerca un articolo',
        'PluginsQuery' => 'Query',
        'PluginsFrame' => 'Cerca un sito',
        'PluginsLogo' => 'Logo',
        'PluginsName' => 'Nome',
        'PluginsSearchFields' => 'Cerca campi',
        'PluginsAuthor' => 'Autore',
        'PluginsLang' => 'Lingua',
        'PluginsUseSite' => 'Utilizza il sito selezionato per ricerche future',
        'PluginsPreferredTooltip' => 'Site recommended by GCstar',
        'PluginDisabled' => 'Disabled',

        'BorrowersTitle' => 'Configurazione prestiti',
        'BorrowersList' => 'Beneficiari dei prestiti',
        'BorrowersName' => 'Nome',
        'BorrowersEmail' => 'E-mail',
        'BorrowersAdd' => 'Aggiungi',
        'BorrowersRemove' => 'Elimina',
        'BorrowersEdit' => 'Modifica',
        'BorrowersTemplate' => 'Modello mail',
        'BorrowersSubject' => 'Oggetto',
        'BorrowersNotice1' => '%1 inserisce il nome di chi beneficia del prestito',
        'BorrowersNotice2' => '%2 inserisce il nome dell\'articolo',
        'BorrowersNotice3' => '%3 inserisce la data del prestito',

        'BorrowersImportTitle' => 'Importa informazioni beneficiari di prestito',
        'BorrowersImportType' => 'Formato file:',
        'BorrowersImportFile' => 'File:',

        'BorrowedTitle' => 'Articoli prestati', # Accepts model codes
        'BorrowedDate' => 'Il',
        'BorrowedDisplayInPanel' => 'Show item in main window', # Accepts model codes

        'MailTitle' => 'Manda una e-mail',
        'MailFrom' => 'Da: ',
        'MailTo' => 'A: ',
        'MailSubject' => 'Oggetto: ',
        'MailSmtpError' => 'Problema di connessione al server SMTP',
        'MailSendmailError' => 'Problema nell\'inviare l\'e-mail',

        'SearchTooltip' => 'Cerca nella collezione', # Accepts model codes
        'SearchTitle' => 'Cerca', # Accepts model codes
        'SearchNoField' => 'No field have been selected for the search box.
Add some of them in the Filters tab of the collection settings.',
        
        'QueryReplaceField' => 'Campo da sostituire',
        'QueryReplaceOld' => 'Nome corrente',
        'QueryReplaceNew' => 'Nuovo nome',
        'QueryReplaceLaunch' => 'Sostituisci',
        
        'ImportWindowTitle' => 'Scegli i campi da importare',
        'ImportViewPicture' => 'Visualizza immagine',
        'ImportSelectAll' => 'Aggiungi tutti',
        'ImportSelectNone' => 'Rimuovi tutti',

        'MultiSiteTitle' => 'Siti da interrogare per le ricerche',
        'MultiSiteUnused' => 'Plugin inutilizzati',
        'MultiSiteUsed' => 'Plugin da utilizzare',
        'MultiSiteLang' => 'Riempi la lista con il plugin inglese',
        'MultiSiteEmptyError' => 'Hai una lista di siti vuota',
        'MultiSiteClear' => 'Pulisci la lista',

        'DisplayOptionsTitle' => 'Articoli da visualizzare',
        'DisplayOptionsAll' => 'Scegli tutto',
        'DisplayOptionsSearch' => 'Pulsante ricerche',

        'GenresTitle' => 'Conversione di genere',
        'GenresCategoryName' => 'Genere da utilizzare',
        'GenresCategoryMembers' => 'Genere da sostituire',
        'GenresLoad' => 'Carica lista',
        'GenresExport' => 'Salva lista in un file',
        'GenresModify' => 'Modifica conversione',

        'PropertiesName' => 'Nome collezione',
        'PropertiesLang' => 'Language code',
        'PropertiesOwner' => 'Proprietario',
        'PropertiesEmail' => 'e-mail',
        'PropertiesDescription' => 'Descrizione',
        'PropertiesFile' => 'Informazione file',
        'PropertiesFilePath' => 'Percorso completo',
        'PropertiesItemsNumber' => 'Numero di articoli', # Accepts model codes
        'PropertiesFileSize' => 'Dimensione',
        'PropertiesFileSizeSymbols' => ['Byte', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
        'PropertiesCollection' => 'Proprieta\' collezione',
        'PropertiesDefaultPicture' => 'Default picture',

        'MailProgramsTitle' => 'Programmi per spedizione e-mail',
        'MailProgramsName' => 'Nome',
        'MailProgramsCommand' => 'Linea di comando',
        'MailProgramsRestore' => 'Riproponi predefiniti',
        'MailProgramsAdd' => 'Aggiungi programma',
        'MailProgramsInstructions' => 'Nella command-line:
 %f inserisce l\'indirizzo di e-mail del mittente.
 %t inserisce l\'indirizzo di e-mail del destinatario.
 %s inserisce il soggetto del messaggio.
 %b inserisce il testo del messaggio.',

        'BookmarksBookmarks' => 'Bookmarks',
        'BookmarksFolder' => 'Directory',
        'BookmarksLabel' => 'Etichetta',
        'BookmarksPath' => 'Percorso',
        'BookmarksNewFolder' => 'Nuova cartella',

        'AdvancedSearchType' => 'Tipo di ricerca',
        'AdvancedSearchTypeAnd' => 'Articoli soddisfacenti tutti i criteri (AND)', # Accepts model codes
        'AdvancedSearchTypeOr' => 'Articoli soddisfacenti almeno un criterio (OR)', # Accepts model codes
        'AdvancedSearchCriteria' => 'Criteri',
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
    );
}
1;
