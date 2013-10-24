{
    package GCLang::DE;

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

        'LangName' => 'Deutsch',

        'Separator' => ': ',
        
        'Warning' => '<b>Warnung</b>:
        
Informationen, die Sie (durch Plugins) von Webseiten herunterladen, 
sind <b>ausschließlich für den persönlichen Gebrauch bestimmt.</b>.

Jede <b>Weitergabe</b> ist ohne die explizite Erlaubnis der
Seitenbetreiber <b>verboten</b>.

Der Button unter den Elementen verweist Sie auf die jeweilige
Webseite, von der die Informationen stammen.',

        'AllItemsFiltered' => 'Kein Element erfüllt Ihre Filtereinstellungen.', # Accepts model codes
        
        'InstallDirInfo' => 'Installiere nach ',
        'InstallMandatory' => 'Erforderliche Komponenten',
        'InstallOptional' => 'Optionale Komponenten',
        'InstallErrorMissing' => 'Fehler : Die folgenden Komponenten müssen installiert sein: ',
        'InstallPrompt' => 'Basisverzeichnis für die Installation [/usr/local]: ',
        'InstallEnd' => 'Installation beendet',
        'InstallNoError' => 'Keine Fehler',
        'InstallLaunch' => 'Um die Anwendung zu verwenden starten Sie ',
        'InstallDirectory' => 'Installationsverzeichnis',
        'InstallTitle' => 'Installation von GCstar',
        'InstallDependencies' => 'Abhängigkeiten',
        'InstallPath' => 'Pfad',
        'InstallOptions' => 'Optionen',
        'InstallSelectDirectory' => 'Wählen Sie ein Basisverzeichnis für die Installation',
        'InstallWithClean' => 'Daten im Installationsverzeichnis löschen',
        'InstallWithMenu' => 'GCstar zum Anwendungsmenü hinzufügen',
        'InstallNoPermission' => 'Fehler: Sie haben keine Schreibrechte im gewählten Verzeichnis',
        'InstallMissingMandatory' => 'Abhängigkeiten können auf Ihrem System nicht gelöst werden. Sie müssen diese ergänzen, um GCstar installieren zu können.',
        'InstallMissingOptional' => 'Einige unten aufgelistete optionale Abhängigkeiten können nicht gelöst werden. GCstar kann installiert werden, aber einige Eigenschaften werden nicht verfügbar sein.',
        'InstallMissingNone' => 'Es gibt keine ungelösten Abhängigkeiten. Sie können mit der Installation fortfahren.',
        'InstallOK' => 'OK',
        'InstallMissing' => 'Fehlt',
        'InstallMissingFor' => 'Fehlt für',
        'InstallCleanDirectory' => 'Entferne GCstar\'s Dateien im Verzeichnis: ',
        'InstallCopyDirectory' => 'Kopiere Dateien in Verzeichnis: ',
        'InstallCopyDesktop' => 'Kopiere Desktop Datei nach: ',

#Update
        'UpdateUseProxy' => 'Proxy (drücken Sie Enter für keinen): ',
        'UpdateNoPermission' => 'Keine Schreibrechte im Verzeichnis: ',
        'UpdateNone' => 'Keine Updates gefunden',
        'UpdateFileNotFound' => 'Datei nicht gefunden',

#Splash
        'SplashInit' => 'Initialisiere',
        'SplashLoad' => 'Lade Sammlung',
        'SplashDisplay' => 'Sammlung anzeigen',
        'SplashSort' => 'Sammlung sortieren',
        'SplashDone' => 'Fertig',

#Import from GCfilms
        'GCfilmsImportQuestion' => 'Sie scheinen bereits GCfilms benutzt zu haben. Was möchten Sie von GCfilms nach GCstar importieren (die Daten von GCfilms bleiben erhalten)?',
        'GCfilmsImportOptions' => 'Einstellungen',
        'GCfilmsImportData' => 'Filmliste',

#Menus
        'MenuFile' => '_Datei',
        'MenuNewList' => '_Neue Liste',
        'MenuStats' => 'Statistische Auswertung',
        'MenuHistory' => '_Letzte Sammlung',
        'MenuLend' => '_Verliehenes anzeigen', # Accepts model codes
        'MenuImport' => '_Importieren',	
        'MenuExport' => '_Exportieren',
        'MenuAddItem' => '_Hinzufügen', # Accepts model codes

        'MenuEdit'  => '_Bearbeiten',
        'MenuDuplicate' => '{1} _duplizieren', # Accepts model codes
        'MenuDuplicatePlural' => '{X} _duplizieren', # Accepts model codes
        'MenuEditSelectAllItems' => '_alle {X} auswählen', # Accepts model codes
        'MenuEditDeleteCurrent' => '{1} _löschen', # Accepts model codes
        'MenuEditDeleteCurrentPlural' => '{X} _löschen', # Accepts model codes  
        'MenuEditFields' => 'Felder _bearbeiten',
        'MenuEditLockItems' => 'Liste _sperren',

        'MenuDisplay' => '_Filter',
        'MenuSavedSearches' => 'Gespeicherte Suchanfragen',
        'MenuSavedSearchesSave' => 'Aktuelle Suchanfrage speichern',
        'MenuSavedSearchesEdit' => 'Gespeicherte Suchanfragen bearbeiten',
        'MenuAdvancedSearch' => 'Erweiterte Suche',
        'MenuViewAllItems' => '_Alle {X} anzeigen', # Accepts model codes
        'MenuNoFilter' => '_Alle',

        'MenuConfiguration' => '_Einstellungen',
            'MenuDisplayMenu' => 'Display',
                'MenuDisplayFullScreen' => 'Full screen',
                'MenuDisplayMenuBar' => 'Menus',
                'MenuDisplayToolBar' => 'Toolbar',
                'MenuDisplayStatusBar' => 'Bottom bar',
        'MenuDisplayOptions' => 'Sichtbare _Felder',
        'MenuBorrowers' => 'Ent_leiher',
        'MenuToolbarConfiguration' => '_Werkzeugleiste konfigurieren',
        'MenuDefaultValues' => 'Default values for new item', # Accepts model codes
        'MenuGenresConversion' => 'Genres _konvertieren',

        'MenuBookmarks' => 'Meine _Sammlung',
        'MenuBookmarksAdd' => 'aktuelle Sammlung _hinzufügen',
        'MenuBookmarksEdit' => 'Sammlung _bearbeiten',

        'MenuHelp' => '_Hilfe',
    	'MenuHelpContent' => '_Hilfe',
        'MenuAllPlugins' => 'Zeige _Plugins',
        'MenuBugReport' => '_Programmfehler melden',
        'MenuAbout' => '_Über GCstar',

        'MenuNewWindow' => '{1} in neuem _Fenster zeigen', # Accepts model codes
        'MenuNewWindowPlural' => '{X} in neuem _Fenster zeigen', # Accepts model codes

        'ContextExpandAll' => 'alle ausklappen',
        'ContextCollapseAll' => 'alle zusammenklappen',
        'ContextChooseImage' => '_Bild wählen',
        'ContextOpenWith' => 'Öffnen mit',
        'ContextImageEditor' => 'Bildbearbeitungsprogramm',
        'ContextImgFront' => 'Vorderseite',
        'ContextImgBack' => 'Rückseite',
        'ContextChooseFile' => 'Datei auswählen',
        'ContextChooseFolder' => 'Verzeichnis auswählen',

        'DialogEnterNumber' => 'Bitte geben Sie einen Wert ein',

        'RemoveConfirm' => 'Wollen Sie dieses Element wirklich löschen?', # Accepts model codes
        'RemoveConfirmPlural' => 'Sollen alle diese {X} wirklich gelöscht werden?', # Accepts model codes

        'DefaultNewItem' => 'Neues Element', # Accepts model codes
        'NewItemTooltip' => '{1} hinzufügen', # Accepts model codes
        'NoItemFound' => 'Element nicht gefunden. Möchten Sie auf einer anderen Seite suchen?',
        'OpenList' => 'Bitte wählen Sie eine Liste',
        'SaveList' => 'Bitte wählen Sie den Speicherort für die Liste',
        'SaveListTooltip' => 'Aktuelle Liste speichern',
        'SaveUnsavedChanges' => 'Es gibt ungespeicherte Änderungen in Ihrere Sammlung. Wollen Sie diese speichern?',
        'SaveDontSave' => 'Nicht speichern',
        'PreferencesTooltip' => 'Ändern der Programmeinstellungen',
        'ViewTooltip' => 'Anzeige der Liste ändern',
        'PlayTooltip' => 'Mit dem Film verknüpftes Video abspielen', # Accepts model codes
        'PlayFileNotFound' => 'Abzuspielende Datei nicht gefunden in:',
        'PlayRetry' => 'noch einmal versuchen',

        'StatusSave' => 'Speichere...',
        'StatusLoad' => 'Lade...',
        'StatusSearch' => 'Suche...',
        'StatusGetInfo' => 'Lade Informationen...',
        'StatusGetImage' => 'Lade Bild...',
                
        'SaveError' => 'Die Liste kann nicht gespeichert werden. Bitte überprüfen Sie die Dateirechte, und ob genügend freier Speicherplatz zur Verfügung steht.',
        'OpenError' => 'Kann die Liste nicht öffnen. Bitte überprüfen Sie die Dateirechte.',
        'OpenFormatError' => 'Kann die Liste nicht öffnen.',
        'OpenVersionWarning' => 'Die Sammlung wurde mit einer neueren Version von GCStar erzeugt. Beim speichern können Daten verloren gehen.',
        'OpenVersionQuestion' => 'Möchten Sie trotzdem fortfahren?',
        'ImageError' => 'Das Verzeichnis zum Speichern der Bilder ist nicht korrekt. Bitte wählen Sie ein anderes.',
        'OptionsCreationError'=> 'Kann die Einstellungsdatei nicht erstellen: ',
        'OptionsOpenError'=> 'Kann die Einstellungen nicht laden: ',
        'OptionsSaveError'=> 'Kann die Einstellungen nicht speichern: ',
        'ErrorModelNotFound' => 'Folgendes Modell wurde nicht gefunden: ',
        'ErrorModelUserDir' => 'Die nutzerdefinierten Modelle sind in: ', 
               
        'RandomTooltip' => '{1} für heute Abend vorschlagen',
        'RandomError'=> 'Sie haben keine ungesehenen {X}', # Accepts model codes
        'RandomEnd'=> 'Keine weiteren Vorschläge verfügbar', # Accepts model codes
        'RandomNextTip'=> 'Nächster Vorschlag',
        'RandomOkTip'=> 'Diesen Vorschlag akzeptieren',
        
        'AboutTitle' => 'Über GCstar',
        'AboutDesc' => 'Gtk2 Sammlungs Manager',
        'AboutVersion' => 'Version',
        'AboutTeam' => 'Team',
        'AboutWho' => 'Christian Jodar (Tian) : Projektmanager, Programmierer
Nyall Dawson (Zombiepig) : Programmierer
TPF : Programmierer
Adolfo González : Programmierer
',
        'AboutLicense' => 'Veröffentlicht unter den Bedingungen der GNU GPL
Logos Copyright le Spektre',
        'AboutTranslation' => 'Deutsche Übersetzung von Gabriel Meier und FrenkX',
        'AboutDesign' => 'Łukasz Kowalczk (Qoolman): Skin Designer
Logo und Webdesign von le Spektre',
        
        'ToolbarRandom' => 'Heute Abend',
        
        'UnsavedCollection' => 'Ungespeicherte Sammlung',
        'ModelsSelect' => 'Wählen Sie den Typ der Sammlung',
        'ModelsPersonal' => 'Eigene Modelle',
        'ModelsDefault' => 'Vorgegebene Modelle',
        'ModelsList' => 'Definitionen von Sammlungen',
        'ModelSettings' => 'Einstellungen von Sammlungen',
        'ModelNewType' => 'Neuer Sammlungstyp',
        'ModelName' => 'Name des Sammlungstypes:',
        'ModelFields' => 'Felder',
        'ModelOptions'	=> 'Optionen',
        'ModelFilters'	=> 'Filter',
        'ModelNewField' => 'Neues Feld',
        'ModelFieldInformation' => 'Information',
        'ModelFieldName' => 'Beschriftung:',
        'ModelFieldType' => 'Typ:',
        'ModelFieldGroup' => 'Gruppe:',
        'ModelFieldValues' => 'Werte',
        'ModelFieldInit' => 'Vorgaben:',
        'ModelFieldMin' => 'Minimum:',
        'ModelFieldMax' => 'Maximum:',
        'ModelFieldList' => 'Wertliste:',
        'ModelFieldListLegend' => '<i>Kommasepariert</i>',
        'ModelFieldDisplayAs' => 'Anzeige als:',
        'ModelFieldDisplayAsText' => 'Text',
        'ModelFieldDisplayAsGraphical' => 'Bewertungselement',
        'ModelFieldTypeShortText' => 'Kurzer Text',
        'ModelFieldTypeLongText' => 'Langer Text',
        'ModelFieldTypeYesNo' => 'Ja/Nein',
        'ModelFieldTypeNumber' => 'Zahl',
        'ModelFieldTypeDate' => 'Datum',
        'ModelFieldTypeOptions' => 'Vordefinierte Auswahlliste',
        'ModelFieldTypeImage' => 'Bild',
        'ModelFieldTypeSingleList' => 'Einfache List',
        'ModelFieldTypeFile' => 'Datei',
        'ModelFieldTypeFormatted' => 'von anderen Feldern abhängig',
        'ModelFieldParameters' => 'Parameter',
        'ModelFieldHasHistory' => 'Benutze Verlauf',
        'ModelFieldFlat' => 'Auf einer Zeile anzeigen',
        'ModelFieldStep' => 'Schrittweite:',
        'ModelFieldFileFormat' => 'Dateiformat:',
        'ModelFieldFileFile' => 'Einfache Datei',
        'ModelFieldFileImage' => 'Bild',
        'ModelFieldFileVideo' => 'Video',
        'ModelFieldFileAudio' => 'Audio',
        'ModelFieldFileProgram' => 'Programm',
        'ModelFieldFileUrl' => 'URL',
        'ModelFieldFileEbook' => 'E-Book',
        'ModelOptionsFields' => 'zu benutzende Felder',
        'ModelOptionsFieldsAuto' => 'Automatisch',
        'ModelOptionsFieldsNone' => 'Keine',
        'ModelOptionsFieldsTitle' => 'Als Titel',
        'ModelOptionsFieldsId' => 'Als Identifikator',
        'ModelOptionsFieldsCover' => 'Als Cover',
        'ModelOptionsFieldsPlay' => 'Für Abspielen Knopf',
        'ModelCollectionSettings' => 'Sammlungseinstellungen',
        'ModelCollectionSettingsLending' => 'Elemente können verborgt werden',
        'ModelCollectionSettingsTagging' => 'Elemente können getaggt werden',
        'ModelFilterActivated' => 'Soll in Suchfeld sein',
        'ModelFilterComparison' => 'Vergleich',
        'ModelFilterContain' => 'Beinhaltet',
        'ModelFilterDoesNotContain' => 'ist nicht enthalten',
        'ModelFilterRegexp' => 'Regulärer Ausdruck',
        'ModelFilterRange' => 'Bereich',
        'ModelFilterNumeric' => 'numerischer Vergleich',
        'ModelFilterQuick' => 'Schnellen Filter erstellen',
        'ModelTooltipName' => 'Benutzen Sie einen Namen, der in vielen Sammlungen verwendet werden kann. Wenn Sie nichts angeben, werden die Einstellungen direkt in der Sammlung gespeichert',
        'ModelTooltipLabel' => 'Der Feldname, so wie er angezeigt wird',
        'ModelTooltipGroup' => 'Kann zum gruppieren verwendet werden. Elemente ohne Gruppenangabe werden in einer vorgegebenen Gruppe zusammengefasst',
        'ModelTooltipHistory' => 'Alle hier eingegebenen Werte werden in einer Liste gespeichert und können darüber auch wieder ausgewählt werden',
        'ModelTooltipFormat' => 'Das Format wird benutzt, um eine geeignete Anwendung mit dem "Öffnen"-Knopf zu verbinden',
        'ModelTooltipLending' => 'Fügt Felder zur Verwaltung der Ausleihe hinzu',
        'ModelTooltipTagging' => 'Fügt Felder zur Verwaltung von Markierungen hinzu',
        'ModelTooltipNumeric' => 'In Vergleichsoperationen wird der Wert als Zahl interpretiert',
        'ModelTooltipQuick' => 'Fügt ein Untermenü zu "Filter" hinzu',

        'ResultsTitle' => 'Wählen Sie einen Eintrag', # Accepts model codes
        'ResultsNextTip' => 'Auf der nächsten Seite suchen',
        'ResultsPreview' => 'Vorschau',
        'ResultsInfo' => 'Es können mehrere Elemente durch Auswahl bei gedrückter STRG oder UMSCHALT Taste zu der Sammlung hinzugefügt werden.', # Accepts model codes
        
        'OptionsTitle' => 'Einstellungen',
        'OptionsExpertMode' => 'Expertenmodus',
        'OptionsPrograms' => 'Wählen Sie eine Anwendung für verschiedene Medientypen. Wird nichts eingetragen, werden die Voreinstellungen des Systems verwendet.',
        'OptionsBrowser' => 'Internetbrowser',
        'OptionsPlayer' => 'Videoabspielprogramm',
        'OptionsAudio' => 'Musikabspielprogramm',
        'OptionsImageEditor' => 'Bildbearbeitungsprogramm',
        'OptionsCdDevice' => 'CD Gerät',
        'OptionsImages' => 'Verzeichnis für Bilder',
        'OptionsUseRelativePaths' => 'Relative Pfade für Bilder verwenden',
        'OptionsLayout' => 'Layout',
        'OptionsStatus' => 'Statusleiste am unteren Fensterrand anzeigen',
        'OptionsUseStars' => 'Sterne für die Bewertung nutzen',
        'OptionsWarning' => 'Warnung: Die Einstellungen in diesem Panel werden erst nach dem Neustart der Anwendung wirksam!',
        'OptionsRemoveConfirm' => 'Löschen von Elementen bestätigen lassen',
        'OptionsAutoSave' => 'Sammlung automatisch speichern',
        'OptionsAutoLoad' => 'Vorhergehende Sammlung beim Programmstart laden',
        'OptionsSplash' => 'Splash-Screen anzeigen',
        'OptionsTearoffMenus' => 'Ablösbare Menüs aktivieren',
        'OptionsSpellCheck' => 'Rechtschreibprüfung für lange Textfelder verwenden',
        'OptionsProgramTitle' => 'Wählen Sie die gewünschte Anwendung',
        'OptionsPlugins' => 'Seite zum Bezug von Informationen',
        'OptionsAskPlugins' => 'Fragen (Alle Seiten)',
        'OptionsPluginsMulti' => 'Mehrere...',
        'OptionsPluginsMultiAsk' => 'Fragen (Mehrere...)',
        'OptionsPluginsMultiPerField' => 'Mehrere... (pro Feld)',
        'OptionsPluginsMultiPerFieldWindowTitle' => 'Datenquellen für die einzeln Felder zuordnen',
        'OptionsPluginsMultiPerFieldDesc' => 'Jedes ausgewählte Feld wird mit dem ersten gefunden Inhalt gefüllt, von links angefangen.',
       'OptionsPluginsMultiPerFieldFirst' => 'Anfang',
        'OptionsPluginsMultiPerFieldLast' => 'Ende',
        'OptionsPluginsMultiPerFieldRemove' => 'Entfernen',
        'OptionsPluginsMultiPerFieldClearSelected' => 'Ausgewählte Feldliste leeren',
        'OptionsPluginsList' => 'Sammlung bearbeiten',
        'OptionsAskImport' => 'Zu importierende Felder wählen',
        'OptionsProxy' => 'Proxy verwenden',
        'OptionsCookieJar' => 'Speichere Cookies in dieser Datei',
        'OptionsLang' => 'Sprache',
        'OptionsMain' => 'Allgemein',
        'OptionsPaths' => 'Pfade',
        'OptionsInternet' => 'Internet',
        'OptionsConveniences' => 'Eigenschaften',
        'OptionsDisplay' => 'Anzeige',
        'OptionsToolbar' => 'Werkzeugleiste',
        'OptionsToolbars' => {
            0 => 'Keine', 
            1 => 'Klein', 
            2 => 'Groß', 
            3 => 'Systemeinstellung'},
        'OptionsToolbarPosition' => 'Position',
        'OptionsToolbarPositions' => {
            0 => 'Oben', 
            1 => 'Unten', 
            2 => 'Links', 
            3 => 'Rechts'},
        'OptionsExpandersMode' => 'ausklappbare Zeile zu lang',
        'OptionsExpandersModes' => {
            'asis' => 'Unverändert', 
            'cut' => 'Abschneiden', 
            'wrap' => 'Zeilenumbruch'},
        'OptionsDateFormat' => 'Datumsformat',
        'OptionsDateFormatTooltip' => 'Das Format entspricht dem bei der Funktion strftime(3) genutzten. Voreinstellung ist %d/%m/%Y',
        'OptionsView' => 'Listenansicht',
        'OptionsViews' => {
            0 => 'Text', 
            1 => 'Bilder', 
            2 => 'Detailliert'},
        'OptionsColumns' => 'Spalten',
        'OptionsMailer' => 'E-Mail-Versand per',
        'OptionsSMTP' => 'Server',
        'OptionsFrom' => 'E-Mail-Adresse des Absenders',
        'OptionsTransform' => 'Artikel ans Ende des Titels stellen',
        'OptionsArticles' => 'Artikel (getrennt durch Kommata)',
        'OptionsSearchStop' => 'Suche kann abgebrochen werden',
        'OptionsBigPics' => 'Große Bilder anzeigen sofern verfügbar',
        'OptionsAlwaysOriginal' => 'Titel statt Originaltitel verwenden, wenn dieser nicht vorhanden ist',
        'OptionsRestoreAccelerators' => 'Schnellzugriffe wiederherstellen',
        'OptionsHistory' => 'Größe des Verlaufs',
        'OptionsClearHistory' => 'Verlauf löschen',
        'OptionsStyle' => 'Erscheinungsbild',
        'OptionsDontAsk' => 'Nicht mehr fragen',
        'OptionsPathProgramsGroup' => 'Anwendungsprogramme',
        'OptionsProgramsSystem' => 'Nutze systemweite Einstellungen',
        'OptionsProgramsUser' => 'Nutze hier angegebene Programme',
        'OptionsProgramsSet' => 'Programmeinstellungen',
        'OptionsPathImagesGroup' => 'Bilder',
        'OptionsInternetDataGroup' => 'Datenimport',
        'OptionsInternetSettingsGroup' => 'Einstellungen',
        'OptionsDisplayInformationGroup' => 'Informationsanzeige',
        'OptionsDisplayArticlesGroup' => 'Artikel',
        'OptionsImagesDisplayGroup' => 'Anzeige',
        'OptionsImagesStyleGroup' => 'Style',
        'OptionsDetailedPreferencesGroup' => 'Einstellungen',
        'OptionsFeaturesConveniencesGroup' => 'Annehmlichkeiten',
        'OptionsPicturesFormat' => 'Prefix für Bilddateien:',
        'OptionsPicturesFormatInternal' => 'gcstar__',
        'OptionsPicturesFormatTitle' => 'Titel oder Name für das verbundene Element',
        'OptionsPicturesWorkingDir' => '%WORKING_DIR% oder . wird durch das Verzeichnis der Sammlung ersetzt (nur am Anfang der Pfadangabe nutzen!)',
        'OptionsPicturesFileBase' => '%FILE_BASE% wird durch den Dateinamen der Sammlung ohne Erweiterung (.gcs) ersetzt',
        'OptionsPicturesWorkingDirError' => '%WORKING_DIR% kann nur am Anfang der Pfadangabe für die Bilder genutzt werden',
        'OptionsConfigureMailers' => 'E-Mail Programmeinstellung',

        'ImagesOptionsButton' => 'Einstellungen',
        'ImagesOptionsTitle' => 'Einstellungen für die Bilderliste',
        'ImagesOptionsSelectColor' => 'Farbe wählen',
        'ImagesOptionsUseOverlays' => '3D-Rahmen um Bild',
        'ImagesOptionsBg' => 'Hintergrund',
        'ImagesOptionsBgPicture' => 'Hintergrundbild verwenden',
        'ImagesOptionsFg'=> 'Auswahl',
        'ImagesOptionsBgTooltip' => 'Hintergrundfarbe ändern',
        'ImagesOptionsFgTooltip'=> 'Farbe für die Auswahl einstellen',
        'ImagesOptionsResizeImgList' => 'Anzahl der Spalten automatisch anpassen',
        'ImagesOptionsAnimateImgList' => 'Use animations',
        'ImagesOptionsSizeLabel' => 'Größe',
        'ImagesOptionsSizeList' => {0 => 'Sehr klein', 1 => 'Klein', 2 => 'Mittel', 3 => 'Groß', 4 => 'Sehr Groß'},
        'ImagesOptionsSizeTooltip' => 'Bildgröße auswählen',

        'DetailedOptionsTitle' => 'Einstellungen für die detaillierte Sammlung',
        'DetailedOptionsImageSize' => 'Bildgröße',
        'DetailedOptionsGroupItems' => 'Gruppiere Elemente nach',
        'DetailedOptionsSecondarySort' => 'Sortiere gruppierte Felder nach',
        'DetailedOptionsFields' => 'Anzuzeigende Felder wählen',
        'DetailedOptionsGroupedFirst' => 'leere Elemente zusammenhalten',
        'DetailedOptionsAddCount' => 'Anzahl der enthaltenen Elemente anzeigen',

        'ExtractButton' => 'Information',
        'ExtractTitle' => 'Dateiinformationen',
        'ExtractImport' => 'Werte verwenden',

        'FieldsListOpen' => 'Lade Liste von Feldern aus Datei',
        'FieldsListSave' => 'Speichere Liste von Feldern in Datei',
        'FieldsListError' => 'Diese Liste von Feldern kann nicht für diese Sammlung benutzt werden',
        'FieldsListIgnore' => '--- Ignoriere',

        'ExportTitle' => 'Sammlung exportieren',
        'ExportFilter' => 'Nur angezeigte Elemente exportieren',
        'ExportFieldsTitle' => 'Zu exportierende Felder',
        'ExportFieldsTip' => 'Wählen Sie die zu exportierenden Felder',
        'ExportWithPictures' => 'Bilder in ein Unterverzeichnis kopieren',
        'ExportSortBy' => 'Sortierung nach',
        'ExportOrder' => 'Reihenfolge',

        'ImportListTitle' => 'Eine weitere Sammlung importieren',
        'ImportExportData' => 'Data',
        'ImportExportFile' => 'Datei',
        'ImportExportFieldsUnused' => 'Freie Felder',
        'ImportExportFieldsUsed' => 'Verwendete Felder',
        'ImportExportFieldsFill' => 'Alle hinzufügen',
        'ImportExportFieldsClear' => 'Alle entfernen',
        'ImportExportFieldsEmpty' => 'Sie müssen mindestens ein Feld wählen',
        'ImportExportFileEmpty' => 'Sie müssen einen Dateinamen angeben',
        'ImportFieldsTitle' => 'Zu importierende Felder',
        'ImportFieldsTip' => 'Wählen Sie die zu importierenden Felder',
        'ImportNewList' => 'Eine neue Sammlung erstellen',
        'ImportCurrentList' => 'Zur aktuellen Sammlung hinzufügen',
        'ImportDropError' => 'Es gab mindestens einen Fehler beim Öffnen der Dateien. Vorherige Liste wird wiederhergestellt.',
        'ImportGenerateId' => 'ID für jedes Element erzeugen',

        'FileChooserOpenFile' => 'Bitte wählen Sie die zu verwendende Datei',
        'FileChooserDirectory' => 'Verzeichnis',
        'FileChooserOpenDirectory' => 'Wählen Sie ein Verzeichnis',
        'FileChooserOverwrite' => 'Diese Datei existiert bereits. Möchten Sie sie überschreiben?',
        'FileAllFiles' => 'Alle Dateien',
        'FileVideoFiles' => 'nur Video-Dateien',
        'FileEbookFiles' => 'nur Ebook-Dateien',
        'FileAudioFiles' => 'nur Audio-Dateien',
        'FileGCstarFiles' => 'GCstar Sammlungen',

        'PanelCompact' => 'Komprimieren',
        'PanelReadOnly' => 'Nur Lesen',
        'PanelForm' => 'Tabs',

        'PanelSearchButton' => 'Internetsuche',
        'PanelSearchTip' => 'Im Internet nach Informationen zu diesem Titel suchen',
        'PanelSearchContextChooseOne' => 'Wähle eine Seite ...',
        'PanelSearchContextMultiSite' => 'Verwende "Viele Seiten"',
        'PanelSearchContextMultiSitePerField' => 'Verwende "Viele Seiten pro Feld"',
        'PanelSearchContextOptions' => 'Optionen ändern ...',
        'PanelImageTipOpen' => 'Klicken, um das Bild zu ändern.',
        'PanelImageTipView' => 'Klicken, um das Bild in Orginalgröße anzuzeigen.',
        'PanelImageTipMenu' => ' Rechtsklick für weitere Optionen.',
        'PanelImageTitle' => 'Wählen Sie ein Bild',
        'PanelImageNoImage' => 'kein Bild',
        'PanelSelectFileTitle' => 'Datei auswählen',
        'PanelLaunch' => 'Launch',        
        'PanelRestoreDefault' => 'Voreinstellung herstellen',
        'PanelRefresh' => 'Update',
        'PanelRefreshTip' => 'Noch offene Einträge aus dem Internet auffüllen',

        'PanelFrom' =>'Von',
        'PanelTo' =>'Bis',

        'PanelWeb' => 'Zeige Informationen',
        'PanelWebTip' => 'Zeige Informationen über dieses Element im Internet', # Accepts model codes
        'PanelRemoveTip' => 'Dieses Element entfernen', # Accepts model codes

        'PanelDateSelect' => 'Wählen Sie ein Datum',
        'PanelNobody' => 'Niemand',
        'PanelUnknown' => 'Unbekannt',
        'PanelAdded' => 'Hinzufügedatum',
        'PanelRating' => 'Bewertung',
        'PanelPressRating' => 'Fremdbewertung',
        'PanelLocation' => 'Ort',

        'PanelLending' => 'Verleih',
        'PanelBorrower'=> 'Entleiher',
        'PanelLendDate'=> 'verliehen am',
        'PanelHistory'=> 'Verlauf',
        'PanelReturned' => 'Element zurückgegeben', # Accepts model codes
        'PanelReturnDate' => 'Rückgabedatum',
        'PanelLendedYes' => 'Verliehen',
        'PanelLendedNo' => 'Verfügbar',

        'PanelTags' => 'Markierungen',
        'PanelFavourite' => 'Favoriten',
        'TagsAssigned' => 'Zugeordnete Markierungen', 

        'PanelUser' => 'Nutzerfeld',

        'CheckUndef' => 'Egal',
        'CheckYes' => 'Ja',
        'CheckNo' => 'Nein',

        'ToolbarAll' => 'Zeige alle',
        'ToolbarAllTooltip' => 'Alle Elemente anzeigen',
        'ToolbarGroupBy' => 'Gruppiere nach',
        'ToolbarGroupByTooltip' => 'Wählen Sie das Feld, nach dem die Einträge gruppiert werden sollen',
        'ToolbarQuickSearch' => 'Schnelle Suche',
        'ToolbarQuickSearchLabel' => 'Suche',
        'ToolbarQuickSearchTooltip' => 'Bitte wählen Sie das Feld, in dem gesucht werden soll. Geben Sie den Suchbegriff ein und drücken Sie anschließend Enter.',
        'ToolbarSeparator' => ' Trenner',
        
        'PluginsTitle' => 'Nach einem Element suchen',
        'PluginsQuery' => 'Abfrage',
        'PluginsFrame' => 'Eine Website durchsuchen',
        'PluginsLogo' => 'Logo',
        'PluginsName' => 'Name',
        'PluginsSearchFields' => 'Suchfelder',
        'PluginsAuthor' => 'Autor',
        'PluginsLang' => 'Sprache',
        'PluginsUseSite' => 'Gewählte Seite für zukünftige Suchen verwenden',
        'PluginsPreferredTooltip' => 'Empfohlen von GCstar',
        'PluginDisabled' => 'Deaktiviert',

        'BorrowersTitle' => 'Entleiher bearbeiten',
        'BorrowersList' => 'Entleiher',
        'BorrowersName' => 'Name',
        'BorrowersEmail' => 'E-Mail',
        'BorrowersAdd' => 'Hinzufügen',
        'BorrowersRemove' => 'Entfernen',
        'BorrowersEdit' => 'Bearbeiten',
        'BorrowersTemplate' => 'E-Mail Vorlage',
        'BorrowersSubject' => 'E-Mail Betreff',
        'BorrowersNotice1' => '%1 wird durch den Namen des Entleihers ersetzt',
        'BorrowersNotice2' => '%2 wird durch den Titel ersetzt',
        'BorrowersNotice3' => '%3 wird durch das Entleihdatum ersetzt',

        'BorrowersImportTitle' => 'Importiere Informationen zum Ausleiher',
        'BorrowersImportType' => 'Dateiformat:',
        'BorrowersImportFile' => 'Datei:',

        'BorrowedTitle' => 'Verliehene Elemente', # Accepts model codes
        'BorrowedDate' => 'Seit',
        'BorrowedDisplayInPanel' => 'Elemente im Hauptfenster anzeigen', # Accepts model codes

        'MailTitle' => 'E-Mail senden',
        'MailFrom' => 'Von: ',
        'MailTo' => 'An: ',
        'MailSubject' => 'Betreff: ',
        'MailSmtpError' => 'Problem beim Verbinden zum SMTP-Server',
        'MailSendmailError' => 'Problem beim Starten von Sendmail',

        'SearchTooltip' => 'Alle Elemente durchsuchen', # Accepts model codes
        'SearchTitle' => 'Titelsuche', # Accepts model codes
        'SearchNoField' => 'Es wurden keine Felder für die Suchanfrage ausgewählt.
Füge einige davon in der Filtersektion unter Einstellungen hinzu.',

        'QueryReplaceField' => 'Felder zu ersetzen',
        'QueryReplaceOld' => 'Bisheriger Name',
        'QueryReplaceNew' => 'Neuer Name',
        'QueryReplaceLaunch' => 'Ersetzen',

        'ImportWindowTitle' => 'Wählen Sie die zu importierenden Felder',
        'ImportViewPicture' => 'Bild ansehen',
        'ImportSelectAll' => 'Alles auswählen',
        'ImportSelectNone' => 'Nichts auswählen',

        'MultiSiteTitle' => 'Seite für Internetrecherche',
        'MultiSiteUnused' => 'Nicht verwendete Plugins',
        'MultiSiteUsed' => 'Zu verwendende Plugins',
        'MultiSiteLang' => 'deutschsprachige Plugins verwenden',
        'MultiSiteEmptyError' => 'Die Liste der zu verwendenden Plugins ist leer!',
        'MultiSiteClear' => 'Liste löschen',

        'DisplayOptionsTitle' => 'Anzuzeigende Felder',
        'DisplayOptionsAll' => 'Alle auswählen',
        'DisplayOptionsSearch' => 'Suchbutton',

        'GenresTitle' => 'Genre konvertieren',
        'GenresCategoryName' => 'Verwendete Genres',
        'GenresCategoryMembers' => 'Zu ersetzende Genres',
        'GenresLoad' => 'Lade eine Liste',
        'GenresExport' => 'Liste in Datei speichern',
        'GenresModify' => 'Genre bearbeiten',

        'PropertiesName' => 'Name der Sammlung',
        'PropertiesLang' => 'Sprachcode',
        'PropertiesOwner' => 'Besitzer',
        'PropertiesEmail' => 'E-Mail',
        'PropertiesDescription' => 'Beschreibung',
        'PropertiesFile' => 'Dateieigenschaften',
        'PropertiesFilePath' => 'Vollständiger Pfad',
        'PropertiesItemsNumber' => 'Anzahl enthaltener Elemente', # Accepts model codes
        'PropertiesFileSize' => 'Dateigröße',
        'PropertiesFileSizeSymbols' => ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
        'PropertiesCollection' => 'Eigenschaften der Sammlung',
        'PropertiesDefaultPicture' => 'Standardbild',

        'MailProgramsTitle' => 'Programm zum senden von E-Mails',
        'MailProgramsName' => 'Name',
        'MailProgramsCommand' => 'Kommandozeile',
        'MailProgramsRestore' => 'Vorgabe wiederherstellen',
        'MailProgramsAdd' => 'Programm hinzufügen',
        'MailProgramsInstructions' => 'In der Kommandozeile werden einige Ersetzungen vorgenommen:
 %f wird ersetzt mit der E-Mailadresse des Nutzers.
 %t wird ersetzt mit der E-Mailadresse des Empfängers.
 %s wird ersetzt mit dem Betreff der Nachricht.
 %b wird ersetzt mit dem Nachrichtentext.',

        'BookmarksBookmarks' => 'Lesezeichen',
        'BookmarksFolder' => 'Verzeichnis',
        'BookmarksLabel' => 'Beschriftung',
        'BookmarksPath' => 'Pfad',
        'BookmarksNewFolder' => 'Neues Verzeichnis',

        'AdvancedSearchType' => 'Art der Suche',
        'AdvancedSearchTypeAnd' => 'Elemente, die alle Kriterien erfüllen', # Accepts model codes
        'AdvancedSearchTypeOr' => 'Elemente, die mindestens ein Kriterium erfüllen', # Accepts model codes
        'AdvancedSearchCriteria' => 'Suchkriterium',
        'AdvancedSearchAnyField' => 'In allen Elementen',
        'AdvancedSearchSaveTitle' => 'Suchanfrage speichern',
        'AdvancedSearchSaveName' => 'Name',
        'AdvancedSearchSaveOverwrite' => 'Es existiert bereits eine Suchanfrage mit diesem Namen. Bitte nutzen Sie einen anderen.',
        'AdvancedSearchUseCase' => 'Groß/Kleinschreibung beachten',
        'AdvancedSearchIgnoreDiacritics' => 'Sonderzeichen ignorieren',

        'BugReportSubject' => 'Fehlermeldung erstellt von GCstar',
        'BugReportVersion' => 'Version',
        'BugReportPlatform' => 'Betriebssystem',
        'BugReportMessage' => 'Fehlermeldung',
        'BugReportInformation' => 'Zusätzliche Informationen',

#Statistics
        'StatsFieldToUse' => 'Auszuwertendes Feld',
        'StatsSortByNumber' => 'Nach Anzahl der {X} sortieren',
        'StatsGenerate' => 'Erzeugen',
        'StatsKindOfGraph' => 'Diagrammart',
        'StatsBars' => 'Balken',
        'StatsPie' => 'Kuchen',
        'Stats3DPie' => '3D Kuchen',
        'StatsArea' => 'Fläche',
        'StatsHistory' => 'Häufigkeitsverteilung',
        'StatsWidth' => 'Breite',
        'StatsHeight' => 'Höhe',
        'StatsFontSize' => 'Schriftgröße',
        'StatsDisplayNumber' => 'Häufigkeiten eintragen',
        'StatsSave' => 'Diagramm als Grafik speichern',
        'StatsAccumulate' => 'Werte zusammenzählen',
        'StatsShowAllDates' => 'alle Daten berücksichtigen',

        'DefaultValuesTip' => 'Values set in this window will be used as the default values when creating a new {1}',
    );
}
1;
