{
    package GCLang::NL;

    use utf8;
###################################################
#
#  Auteursrecht 2005-2009 Tian
#
#  Dit bestand is onderdeel van GCstar.
#
#  GCstar is gratis software; je kan het verspreiden en/ of wijzigen
#  onder de voorwaarden van de GNU General Public License zoals gepubliceerd door
#  de Free Software Foundation; ofwel versie 2 van de licentie, of
#  (op uw keuze) een latere versie.
#
#  GCstar wordt verspreid in de hoop dat het nuttig zal zijn
#  maar ZONDER ENIGE GARANTIE, zelfs zonder de impliciete garantie van
#  Verkoopbaarheid of geschiktheid voor een bepaald doel. Zie de
#  GNU General Public License voor meer details.
#
#  Je zou een kopie van de GNU General Public License moeten ontvangen hebben
#  samen met GCstar; zo niet, schrijf naar de Free Software
#  Foundation, Inc, 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
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

        'LangName' => 'Nederlands',
        
        'Separator' => ': ',
        
        'Warning' => '<b>Waarschuwing</b>:
        
Informatie gedownload van websites (via de zoekplugins) is <b>enkel voor persoonlijk gebruik</b>.

Elke herverdeling is verboden zonder <b>uitdrukkelijke toestemming</b> van de website.

Om te bepalen welke site eigenaar van de informatie is, 

kunt u gebruik maken van de <b>onderstaande knop item details</b>.',
        
        'AllItemsFiltered' => 'Geen item komt overeen met je filtercriteria', # Accepts model codes
        
#Installation
        'InstallDirInfo' => 'Installeren in ',
        'InstallMandatory' => 'Verplichte onderdelen',
        'InstallOptional' => 'Optionele onderdelen',
        'InstallErrorMissing' => 'Fout: de volgende onderdelen van Perl moeten geïnstalleerd worden: ',
        'InstallPrompt' => 'Basismap voor installatie [/usr/local]: ',
        'InstallEnd' => 'Einde van de installatie',
        'InstallNoError' => 'Geen fouten',
        'InstallLaunch' => 'Om gebruik te maken van deze toepassing, kun je starten ',
        'InstallDirectory' => 'Basismap',
        'InstallTitle' => 'GCstar installatie',
        'InstallDependencies' => 'Afhankelijkheden',
        'InstallPath' => 'Doel',
        'InstallOptions' => 'Opties',
        'InstallSelectDirectory' => 'Kies basismap voor de installatie',
        'InstallWithClean' => 'Verwijder bestanden die in de installatiemap gevonden zijn',
        'InstallWithMenu' => 'Voeg GCstar toe aan het menu Toepassingen',
        'InstallNoPermission' => 'Fout: geen schrijfrechten in de gekozen map',
        'InstallMissingMandatory' => 'Verplichte onderdelen ontbreken. Zolang deze niet geïnstalleerd zijn, kun je GCstar niet installeren.',
        'InstallMissingOptional' => 'Enkele optionele afhankelijkheden ontbreken. Deze zijn opgesomd in de lijst hieronder. GCstar zal geïnstalleerd worden, maar enkele mogelijkheden zullen niet werken.',
        'InstallMissingNone' => 'Alle afhankelijkheden zijn in orde. Je kunt doorgaan met de installatie.',
        'InstallOK' => 'OK',
        'InstallMissing' => 'Ontbreekt',
        'InstallMissingFor' => 'Ontbreekt voor',
        'InstallCleanDirectory' => 'Verwijderen van GCstar\'s bestanden in de map: ',
        'InstallCopyDirectory' => 'Bestanden kopiëren naar map: ',
        'InstallCopyDesktop' => 'Kopieer desktopbestand in: ',

#Update
        'UpdateUseProxy' => 'Gebruik een proxy (druk op enter om zonder proxy door te gaan): ',
        'UpdateNoPermission' => 'Geen schrijfrechten in deze map: ',
        'UpdateNone' => 'Geen update gevonden',
        'UpdateFileNotFound' => 'Bestand niet gevonden',

#Splash
        'SplashInit' => 'Initialisatie',
        'SplashLoad' => 'Collectie wordt geladen',
        'SplashDisplay' => 'Collectie weergeven',
        'SplashSort' => 'Collectie sorteren',
        'SplashDone' => 'Klaar',

#Import from GCfilms
        'GCfilmsImportQuestion' => 'Waarschijnlijk gebruikte je GCfilms eerder. Wat wil je importeren van GCfilms naar GCstar? (Dit heeft geen invloed op GCfilms als je die nog wilt gebruiken.)',
        'GCfilmsImportOptions' => 'Instellingen',
        'GCfilmsImportData' => 'Filmlijst',

#Menus
        'MenuFile' => '_Bestand',
            'MenuNewList' => '_Nieuwe collectie',
            'MenuStats' => 'Statistics',
            'MenuHistory' => '_Recente collecties',
            'MenuLend' => 'Toon _Uitgeleende items', # Accepts model codes
            'MenuImport' => '_Importeer',	
            'MenuExport' => '_Exporteer',
            'MenuAddItem' => '_Add Items', # Accepts model codes    
    
        'MenuEdit'  => '_Bewerken',
            'MenuDuplicate' => 'Du_pliceer item', # Accepts model codes
            'MenuDuplicatePlural' => 'Du_pliceer items', # Accepts model codes
            'MenuEditSelectAllItems' => 'Select _All items', # Accepts model codes
            'MenuEditDeleteCurrent' => '_Verwijder item', # Accepts model codes
            'MenuEditDeleteCurrentPlural' => '_Remove items', # Accepts model codes 
            'MenuEditFields' => 'Ve_rander collectievelden',
            'MenuEditLockItems' => '_Blokkeer collectie',
    
        'MenuDisplay' => 'F_ilter',
            'MenuSavedSearches' => 'Bewaarde zoekopdrachten',
                'MenuSavedSearchesSave' => 'Bewaar huidige zoekopdracht',
                'MenuSavedSearchesEdit' => 'Modificeer opgeslagen zoekopdrachten',
            'MenuAdvancedSearch' => 'Geavanceer_de zoekopdracht',
            'MenuViewAllItems' => 'Toon _Alle items', # Accepts model codes
            'MenuNoFilter' => '_Om het even welk',
    
        'MenuConfiguration' => 'In_stellingen',
            'MenuDisplayMenu' => 'Display',
                'MenuDisplayFullScreen' => 'Full screen',
                'MenuDisplayMenuBar' => 'Menus',
                'MenuDisplayToolBar' => 'Toolbar',
                'MenuDisplayStatusBar' => 'Bottom bar',
            'MenuDisplayOptions' => 'Getoon_de informatie',
            'MenuBorrowers' => '_Leners',
            'MenuToolbarConfiguration' => '_Werkbalk aanpassen',
            'MenuDefaultValues' => 'Default values for new item', # Accepts model codes
            'MenuGenresConversion' => 'Genre om_zetting',
        
        'MenuBookmarks' => 'Mijn _Collecties',
            'MenuBookmarksAdd' => '_Huidige collectie toevoegen',
            'MenuBookmarksEdit' => '_Bewerk opgeslagen collecties',

        'MenuHelp' => '_Help',
            'MenuHelpContent' => '_Inhoud',
            'MenuAllPlugins' => 'Bekijk _Plug-ins',
            'MenuBugReport' => 'Rappor_teer een probleem',
            'MenuAbout' => '_Over GCstar',
    
        'MenuNewWindow' => 'Toon item in _Nieuw Venster', # Accepts model codes
        'MenuNewWindowPlural' => 'Toon items in _Nieuw Venster', # Accepts model codes
        
        'ContextExpandAll' => 'Alles _uitvouwen',
        'ContextCollapseAll' => 'Alles _samenvouwen',
        'ContextChooseImage' => '_Kies afbeelding',
        'ContextOpenWith' => 'Openen _met',
        'ContextImageEditor' => 'Afbeeldingsbewerker',
        'ContextImgFront' => 'Voorkant',
        'ContextImgBack' => 'Achterkant',
        'ContextChooseFile' => 'Choose a File',
        'ContextChooseFolder' => 'Choose a Folder',

        'DialogEnterNumber' => 'Voer een waarde in',

        'RemoveConfirm' => 'Ben je zeker dat je dit item wilt verwijderen?', # Accepts model codes
        'RemoveConfirmPlural' => 'Do you really want to remove these items?', # Accepts model codes
        'DefaultNewItem' => 'Nieuw item', # Accepts model codes
        'NewItemTooltip' => 'Voeg een nieuw item toe', # Accepts model codes
        'NoItemFound' => 'Niets gevonden. Wil je in een andere website zoeken?',
        'OpenList' => 'Kies collectie',
        'SaveList' => 'Kies waar je de collectie wilt opslaan',
        'SaveListTooltip' => 'Bewaar huidige collectie',
        'SaveUnsavedChanges' => 'Er zijn niet opgeslagen wijzigingen in je collectie. Wil je die opslaan?',
        'SaveDontSave' => 'Niet opslaan',
        'PreferencesTooltip' => 'Instellingen',
        'ViewTooltip' => 'Verander collectiebeeld',
        'PlayTooltip' => 'Open bestand geassocieerd met dit item', # Accepts model codes
        'PlayFileNotFound' => 'Bestand niet gevonden op deze plaats:',
        'PlayRetry' => 'Opnieuw',

        'StatusSave' => 'Opslaan...',
        'StatusLoad' => 'Laden...',
        'StatusSearch' => 'Bezig met zoeken...',
        'StatusGetInfo' => 'Informatie ophalen...',
        'StatusGetImage' => 'Afbeelding ophalen...',
                
        'SaveError' => 'Kan de itemlijst niet opslaan. Controleer schijfruimte en schrijfrechten.',
        'OpenError' => 'Kan de itemlijst niet openen. Controleer leesrechten.',
        'OpenFormatError' => 'Kan de itemlijst niet openen. Formaat is misschien foutief.',
        'OpenVersionWarning' => 'Collectie was aangemaakt met een nieuwere versie van GCstar. Als je het toch opslaat kun je data verliezen.',
        'OpenVersionQuestion' => 'Wil je toch doorgaan?',
        'ImageError' => 'Gekozen map om afbeeldingen in op te slaan is niet juist. Kies een andere map.',
        'OptionsCreationError'=> 'Kan geen optiebestand maken: ',
        'OptionsOpenError'=> 'Kan optiebestand niet openen: ',
        'OptionsSaveError'=> 'Kan optiebestand niet opslaan: ',
        'ErrorModelNotFound' => 'Model niet gevonden: ',
        'ErrorModelUserDir' => 'Door gebruiker gedefinieerde modellen staan in: ',
        
        'RandomTooltip' => 'Wat te bekijken deze avond?',
        'RandomError'=> 'Je hebt geen selecteerbare items', # Accepts model codes
        'RandomEnd'=> 'Er zijn geen items meer', # Accepts model codes
        'RandomNextTip'=> 'Volgende suggestie',
        'RandomOkTip'=> 'Accepteer dit item',
        
        'AboutTitle' => 'Over GCstar',
        'AboutDesc' => 'Persoonlijke collectiebeheerder',
        'AboutVersion' => 'Versie',
        'AboutTeam' => 'Team',
        'AboutWho' => 'Christian Jodar (Tian): projectbeheerder, programmeur
Nyall Dawson (Zombiepig): programmeur
TPF: programmeur
Adolfo González: programmeur
',
        'AboutLicense' => 'verspreid onder GNU GPL termen
Logo Copyright le Spektre',
        'AboutTranslation' => 'Engelse vertaling door Kim',
        'AboutDesign' => 'Łukasz Kowalczk (Qoolman): Skin Designer
Logo en webdesign door le Spektre',

        'UnsavedCollection' => 'Niet opgeslagen collectie',
        'ModelsSelect' => 'Kies een collectietype',
        'ModelsPersonal' => 'Persoonlijke modellen',
        'ModelsDefault' => 'Standaardmodellen',
        'ModelsList' => 'Collectiedefinitie',
        'ModelSettings' => 'Collectieinstellingen',
        'ModelNewType' => 'Nieuw collectietype',
        'ModelName' => 'Naam van het collectietype:',
		'ModelFields' => 'Velden',
		'ModelOptions'	=> 'Opties',
		'ModelFilters'	=> 'Filters',
        'ModelNewField' => 'Nieuw veld',
        'ModelFieldInformation' => 'Informatie',
        'ModelFieldName' => 'Label:',
        'ModelFieldType' => 'Type:',
        'ModelFieldGroup' => 'Groep:',
        'ModelFieldValues' => 'Waarden',
        'ModelFieldInit' => 'Standaard:',
        'ModelFieldMin' => 'Minimum:',
        'ModelFieldMax' => 'Maximum:',
        'ModelFieldList' => 'Waardenlijst:',
        'ModelFieldListLegend' => '<i>door komma\'s gescheiden</i>',
        'ModelFieldDisplayAs' => 'Geef weer als:',
        'ModelFieldDisplayAsText' => 'Tekst',
        'ModelFieldDisplayAsGraphical' => 'Waarderingsbeheer',
        'ModelFieldTypeShortText' => 'Korte tekst',
        'ModelFieldTypeLongText' => 'Lange tekst',
        'ModelFieldTypeYesNo' => 'Ja/Nee',
        'ModelFieldTypeNumber' => 'Nummer',
        'ModelFieldTypeDate' => 'Datum',
        'ModelFieldTypeOptions' => 'Vooraf gedefinieerde waardenlijst',
        'ModelFieldTypeImage' => 'Afbeelding',
        'ModelFieldTypeSingleList' => 'Eenvoudige lijst',
        'ModelFieldTypeFile' => 'Bestand',
        'ModelFieldTypeFormatted' => 'Afhankelijk van andere velden',
        'ModelFieldParameters' => 'Parameters',
        'ModelFieldHasHistory' => 'Gebruik een geschiedenis',
        'ModelFieldFlat' => 'Toon op een lijn',
        'ModelFieldStep' => 'Incrementele stap:',
        'ModelFieldFileFormat' => 'Bestandsformaat:',
        'ModelFieldFileFile' => 'Eenvoudig bestand',
        'ModelFieldFileImage' => 'Afbeelding',
        'ModelFieldFileVideo' => 'Video',
        'ModelFieldFileAudio' => 'Geluid',
        'ModelFieldFileProgram' => 'Programma',
        'ModelFieldFileUrl' => 'Link',
        'ModelFieldFileEbook' => 'Ebook',
        'ModelOptionsFields' => 'Velden om te gebruiken',
        'ModelOptionsFieldsAuto' => 'Automatisch',
        'ModelOptionsFieldsNone' => 'Geen',
        'ModelOptionsFieldsTitle' => 'Zoals titel',
        'ModelOptionsFieldsId' => 'Zoals ID',
        'ModelOptionsFieldsCover' => 'Zoals cover',
        'ModelOptionsFieldsPlay' => 'Voor Playknop',
        'ModelCollectionSettings' => 'Collectie instellingen',
        'ModelCollectionSettingsLending' => 'Items kunnen geleend worden',
        'ModelCollectionSettingsTagging' => 'Items kunnen getagd worden',
        'ModelFilterActivated' => 'Zou in het zoekvak moeten zijn',
        'ModelFilterComparison' => 'Vergelijking',
        'ModelFilterContain' => 'Bevat',
        'ModelFilterDoesNotContain' => 'Bevat niet',
        'ModelFilterRegexp' => 'Reguliere expressie',
        'ModelFilterRange' => 'Bereik',
        'ModelFilterNumeric' => 'Vergelijking is numeriek',
        'ModelFilterQuick' => 'Maak een snelle filter',
        'ModelTooltipName' => 'Gebruik een naam om dit model voor vele collecties te herbruiken. Indien leeg, zullen de instellingen in het model zelf opgeslagen worden',
        'ModelTooltipLabel' => 'De veldnaam zoals het weergegeven zal worden',
        'ModelTooltipGroup' => 'Gebruikt om velden te groeperen. Items zonder waarde zitten in een standaardgroep',
        'ModelTooltipHistory' => 'Moeten de vorige ingevoerde waarden worden opgeslagen in een lijst geassocieerd aan het veld',
        'ModelTooltipFormat' => 'Dit formaat dient om de aktie van de playknop te bepalen',
        'ModelTooltipLending' => 'Dit voegt velden toe om uitleningen te beheren',
        'ModelTooltipTagging' => 'Dit voegt velden toe om tags te beheren',
        'ModelTooltipNumeric' => 'Moeten de waarden worden beschouwd als nummers om te vergelijken',
        'ModelTooltipQuick' => 'Dit voegt een submenu toe bij de filters',
        
        'ResultsTitle' => 'Kies een item', # Accepts model codes
        'ResultsNextTip' => 'Zoek in de volgende website',
        'ResultsPreview' => 'Voorvertoning',
        'ResultsInfo' => 'Je kan meerdere items toevoegen aan de collectie met Ctrl of Shift', # Accepts model codes
        
        'OptionsTitle' => 'Voorkeuren',
		'OptionsExpertMode' => 'Geavanceerde opties',
        'OptionsPrograms' => 'Kies de te gebruiken programma\'s voor verschillende media, laat leeg voor systeemstandaarden',
        'OptionsBrowser' => 'Webbrowser',
        'OptionsPlayer' => 'Videospeler',
        'OptionsAudio' => 'Geluidspeler',
        'OptionsImageEditor' => 'Afbeeldingsbewerker',
        'OptionsCdDevice' => 'CD-apparaat',
        'OptionsImages' => 'Afbeeldingenmap',
        'OptionsUseRelativePaths' => 'Gebruik relatieve paden voor afbeeldingen',
        'OptionsLayout' => 'Layout',
        'OptionsStatus' => 'Toon statusbalk',
        'OptionsUseStars' => 'Gebruik sterren om beoordelingen te tonen',
        'OptionsWarning' => 'Waarschuwing: Veranderingen op dit tabblad hebben geen effect tot je GCstar herstart.',
        'OptionsRemoveConfirm' => 'Vraag bevestiging voordat een item verwijderd wordt',
        'OptionsAutoSave' => 'Automatisch collectie opslaan',
        'OptionsAutoLoad' => 'Laad vorige collectie bij programmastart',
        'OptionsSplash' => 'Toon splash beeld',
        'OptionsTearoffMenus' => 'Sta afneembare menu\'s toe',
        'OptionsSpellCheck' => 'Gebruik spellingscontrole in lange tekstvelden',
        'OptionsProgramTitle' => 'Kies het programma om te gebruiken',
		'OptionsPlugins' => 'Website om data van op te halen',
		'OptionsAskPlugins' => 'Vraag (vele websites)',
		'OptionsPluginsMulti' => 'Vele websites',
		'OptionsPluginsMultiAsk' => 'Vraag (vele websites)',
        'OptionsPluginsMultiPerField' => 'Vele websites (per field)',
        'OptionsPluginsMultiPerFieldWindowTitle' => 'Many sites per field order selection',
        'OptionsPluginsMultiPerFieldDesc' => 'For each selected field we will return the first non empty information beginning from left',
        'OptionsPluginsMultiPerFieldFirst' => 'First',
        'OptionsPluginsMultiPerFieldLast' => 'Last',
        'OptionsPluginsMultiPerFieldRemove' => 'Remove',
        'OptionsPluginsMultiPerFieldClearSelected' => 'Empty selected field list',
		'OptionsPluginsList' => 'Stel lijst in',
        'OptionsAskImport' => 'Kies velden om te importeren',
		'OptionsProxy' => 'Gebruik een proxy',
		'OptionsCookieJar' => 'Gebruik dit cookie jar bestand',
        'OptionsLang' => 'Taal',
        'OptionsMain' => 'Hoofd',
        'OptionsPaths' => 'Paden',
        'OptionsInternet' => 'Internet',
        'OptionsConveniences' => 'Extra\'s',
        'OptionsDisplay' => 'Beeld',
        'OptionsToolbar' => 'Werkbalk',
        'OptionsToolbars' => {0 => 'Geen', 1 => 'Klein', 2 => 'Groot', 3 => 'Systeem instelling'},
        'OptionsToolbarPosition' => 'Positie',
        'OptionsToolbarPositions' => {0 => 'Bovenaan', 1 => 'Onderaan', 2 => 'Links', 3 => 'Rechts'},
        'OptionsExpandersMode' => 'Expanders te lang',
        'OptionsExpandersModes' => {'asis' => 'Doe niets', 'cut' => 'knip', 'wrap' => 'Regelafbraak'},
        'OptionsDateFormat' => 'Datum formaat',
        'OptionsDateFormatTooltip' => 'Formaat is gebruikt door strftime(3). Standaard is %d/%m/%Y',
        'OptionsView' => 'Items lijst',
        'OptionsViews' => {0 => 'Tekst', 1 => 'Afbeelding', 2 => 'Gedetailleerd'},
        'OptionsColumns' => 'Kolommen',
        'OptionsMailer' => 'E-mailer',
        'OptionsSMTP' => 'Server',
        'OptionsFrom' => 'Jouw e-mail',
        'OptionsTransform' => 'Plaats lidwoorden op het einde van de titels',
        'OptionsArticles' => 'Lidwoorden (door komma\'s gescheiden)',
        'OptionsSearchStop' => 'Zoeken mag onderbroken worden',
        'OptionsBigPics' => 'Gebruik grote afbeeldingen indien beschikbaar',
        'OptionsAlwaysOriginal' => 'Gebruik hoofdtitel als de originele titel niet beschikbaar is',
        'OptionsRestoreAccelerators' => 'Herstel sneltoetsen toetsenbord ',
        'OptionsHistory' => 'Grootte van de geschiedenis',
        'OptionsClearHistory' => 'Verwijder geschiedenis',
		'OptionsStyle' => 'Uiterlijk',
        'OptionsDontAsk' => 'Niet opnieuw vragen',
        'OptionsPathProgramsGroup' => 'Toepassingen',
        'OptionsProgramsSystem' => 'Gebruik standaard systeemtoepassingen',
        'OptionsProgramsUser' => 'Gebruik programma\'s van je eigen keuze',
        'OptionsProgramsSet' => 'Kies programma\'s',
        'OptionsPathImagesGroup' => 'Afbeeldingen',
        'OptionsInternetDataGroup' => 'Data importeren',
        'OptionsInternetSettingsGroup' => 'Instellingen',
        'OptionsDisplayInformationGroup' => 'Informatievenster',
        'OptionsDisplayArticlesGroup' => 'Lidwoorden',
        'OptionsImagesDisplayGroup' => 'Beeld',
        'OptionsImagesStyleGroup' => 'Stijl',
        'OptionsDetailedPreferencesGroup' => 'Voorkeuren',
        'OptionsFeaturesConveniencesGroup' => 'Gemak',
        'OptionsPicturesFormat' => 'Voorvoegsel bij afbeeldingen:',
        'OptionsPicturesFormatInternal' => 'gcstar__',
        'OptionsPicturesFormatTitle' => 'Titel of naam van het item',
        'OptionsPicturesWorkingDir' => '%werkmap% of . zal vervangen worden door collectiemap',
        'OptionsPicturesFileBase' => '%bestand_basis% zal vervangen worden door de collectiebestandsnaam zonder extensie (.gcs)',
        'OptionsPicturesWorkingDirError' => '%werkmap% kan alleen gebruikt worden aan het begin van het pad voor afbeeldingen',
        'OptionsConfigureMailers' => 'Stel e-mailprogramma\'s in',

        'ImagesOptionsButton' => 'Instellingen',
        'ImagesOptionsTitle' => 'Instellingen voor de afbeeldingenlijst',
        'ImagesOptionsSelectColor' => 'Kies een kleur',
        'ImagesOptionsUseOverlays' => 'Gebruik afbeelding overlay',
        'ImagesOptionsBg' => 'Achtergrond',
        'ImagesOptionsBgPicture' => 'Gebruik een achtergrondafbeelding',
        'ImagesOptionsFg'=> 'Selectie',
        'ImagesOptionsBgTooltip' => 'Verander achtergrondkleur',
        'ImagesOptionsFgTooltip'=> 'Verander selectiekleur',
        'ImagesOptionsResizeImgList' => 'Aantal kolommen automatisch veranderen',
        'ImagesOptionsAnimateImgList' => 'Use animations',
        'ImagesOptionsSizeLabel' => 'Grootte',
        'ImagesOptionsSizeList' => {0 => 'Zeer klein', 1 => 'Klein', 2 => 'Gemiddeld', 3 => 'Groot', 4 => 'Zeer groot'},
        'ImagesOptionsSizeTooltip' => 'Kies afbeeldingsgrootte',
		        
        'DetailedOptionsTitle' => 'Instellingen voor de gedetailleerde lijst',
        'DetailedOptionsImageSize' => 'afbeeldingsgrootte',
        'DetailedOptionsGroupItems' => 'Sorteer items op',
        'DetailedOptionsSecondarySort' => 'Sorteer onderliggende velden',
		'DetailedOptionsFields' => 'Kies de te tonen velden',
        'DetailedOptionsGroupedFirst' => 'Hou verweesde items samen',
        'DetailedOptionsAddCount' => 'Voeg aantal elementen aan categorieën toe',

        'ExtractButton' => 'Informatie',
        'ExtractTitle' => 'Bestandsinformatie',
        'ExtractImport' => 'Gebruik waarden',

        'FieldsListOpen' => 'Laad een veldlijst van een bestand',
        'FieldsListSave' => 'Bewaar veldlijst in een bestand',
        'FieldsListError' => 'Deze veldlijst kan niet gebruikt worden bij dit soort collectie',
        'FieldsListIgnore' => '--- Negeer',

        'ExportTitle' => 'Exporteer itemlijst',
        'ExportFilter' => 'Exporteer enkel getoonde items',
        'ExportFieldsTitle' => 'Velden om te exporteren',
        'ExportFieldsTip' => 'Kies velden om te exporteren',
        'ExportWithPictures' => 'Kopieer afbeeldingen in een onderliggende map',
        'ExportSortBy' => 'Sorteer op',
        'ExportOrder' => 'Volgorde',

        'ImportListTitle' => 'Importeer een andere itemlijst',
        'ImportExportData' => 'Data',
        'ImportExportFile' => 'Bestand',
        'ImportExportFieldsUnused' => 'Ongebruikte velden',
        'ImportExportFieldsUsed' => 'Gebruikte velden',
        'ImportExportFieldsFill' => 'Alles toevoegen',
        'ImportExportFieldsClear' => 'Alles verwijderen',
        'ImportExportFieldsEmpty' => 'Je moet minstens één veld kiezen',
        'ImportExportFileEmpty' => 'Je moet een bestandsnaam specifiëren',
        'ImportFieldsTitle' => 'Velden om te importeren',
        'ImportFieldsTip' => 'Kies velden om te importeren',
        'ImportNewList' => 'Maak een nieuwe collectie',
        'ImportCurrentList' => 'Voeg aan huidige collectie toe',
        'ImportDropError' => 'Er was een fout tijdens het openen van minstens één bestand. De vorige lijst wordt herladen.',
        'ImportGenerateId' => 'Genereer identificatie voor ieder item',

        'FileChooserOpenFile' => 'Kies een bestand om te gebruiken',
        'FileChooserDirectory' => 'Map',
        'FileChooserOpenDirectory' => 'Kies een map',
        'FileChooserOverwrite' => 'Dit bestand bestaat al. Wil je het overschrijven?',
        'FileAllFiles' => 'All Files',
        'FileVideoFiles' => 'Video Files',
        'FileEbookFiles' => 'Ebook Files',
        'FileAudioFiles' => 'Audio Files',
        'FileGCstarFiles' => 'GCstar Collections',

        #Some default panels
        'PanelCompact' => 'Compact',
        'PanelReadOnly' => 'Enkel lezen',
        'PanelForm' => 'Tabbladen',

        'PanelSearchButton' => 'Haal informatie op',
        'PanelSearchTip' => 'Zoek informatie op het internet',
        'PanelSearchContextChooseOne' => 'Choose a site ...',
        'PanelSearchContextMultiSite' => 'Use "Many sites"',
        'PanelSearchContextMultiSitePerField' => 'Use "Many sites per field"',
        'PanelSearchContextOptions' => 'Change options ...',
        'PanelImageTipOpen' => 'Klik op de afbeelding om een andere te kiezen.',
        'PanelImageTipView' => 'Klik op de afbeelding om op ware grootte weer te geven.',
        'PanelImageTipMenu' => ' Rechts klikken voor meer opties.',
        'PanelImageTitle' => 'Kies een afbeelding',
        'PanelImageNoImage' => 'Geen afbeelding',
        'PanelSelectFileTitle' => 'Kies een bestand',
        'PanelLaunch' => 'Launch',        
        'PanelRestoreDefault' => 'Herstel standaard',
        'PanelRefresh' => 'Update',
        'PanelRefreshTip' => 'Update information from web',

        'PanelFrom' =>'Van',
        'PanelTo' =>'Naar',

        'PanelWeb' => 'Bekijk informatie',
        'PanelWebTip' => 'Bekijk informatie op het internet voor dit item', # Accepts model codes
        'PanelRemoveTip' => 'Verwijder huidig item', # Accepts model codes

        'PanelDateSelect' => 'Kies',
        'PanelNobody' => 'Niemand',
        'PanelUnknown' => 'Onbekend',
        'PanelAdded' => 'Toegevoegd op',
        'PanelRating' => 'Waardering',
        'PanelPressRating' => 'Press Rating',
        'PanelLocation' => 'Locatie',

        'PanelLending' => 'Uitgeleend',
        'PanelBorrower' => 'Lener',
        'PanelLendDate' => 'Uitgeleend sinds',
        'PanelHistory' => 'Uitleengeschiedenis',
        'PanelReturned' => 'Item teruggebracht', # Accepts model codes
        'PanelReturnDate' => 'Datum teruggave',
        'PanelLendedYes' => 'Ooit uitgeleend',
        'PanelLendedNo' => 'Beschikbaar',

        'PanelTags' => 'Tags',
        'PanelFavourite' => 'Favorieten',
        'TagsAssigned' => 'Toegewezen tags', 

        'PanelUser' => 'Gebruikersvelden',

        'CheckUndef' => 'Of',
        'CheckYes' => 'Ja',
        'CheckNo' => 'Nee',

        'ToolbarRandom' => 'Vannacht',
        'ToolbarAll' => 'Toon alles',
        'ToolbarAllTooltip' => 'Toon alle items',
        'ToolbarGroupBy' => 'Groepeer op',
        'ToolbarGroupByTooltip' => 'Kies het veld waarmee items gegroepeerd moeten worden',
        'ToolbarQuickSearch' => 'Snel zoeken',
        'ToolbarQuickSearchLabel' => 'Zoeken',
        'ToolbarQuickSearchTooltip' => 'Kies het veld om in te zoeken. Voer zoektermen in en druk op enter',
        'ToolbarSeparator' => ' Scheidingsteken',
        
        'PluginsTitle' => 'Zoek een item',
        'PluginsQuery' => 'Vraag',
        'PluginsFrame' => 'Zoek website',
        'PluginsLogo' => 'Logo',
        'PluginsName' => 'Naam',
        'PluginsSearchFields' => 'Zoek velden',
        'PluginsAuthor' => 'Auteur',
        'PluginsLang' => 'Taal',
        'PluginsUseSite' => 'Gebruik geselecteerde website voor verdere zoekacties',
        'PluginsPreferredTooltip' => 'Site recommended by GCstar',
        'PluginDisabled' => 'Disabled',

        'BorrowersTitle' => 'Lenersconfiguratie',
        'BorrowersList' => 'Leners',
        'BorrowersName' => 'Naam',
        'BorrowersEmail' => 'E-mail',
        'BorrowersAdd' => 'Voeg toe',
        'BorrowersRemove' => 'Verwijder',
        'BorrowersEdit' => 'Bewerk',
        'BorrowersTemplate' => 'Mail sjabloon',
        'BorrowersSubject' => 'Mail onderwerp',
        'BorrowersNotice1' => '%1 zal vervangen worden door de naam van de lener',
        'BorrowersNotice2' => '%2 zal vervangen worden door de titel van het item',
        'BorrowersNotice3' => '%3 zal vervangen worden door de uitleendatum',

        'BorrowersImportTitle' => 'Importeer lenersinformatie',
        'BorrowersImportType' => 'Bestandsformaat:',
        'BorrowersImportFile' => 'Bestand:',

        'BorrowedTitle' => 'Uitgeleende items', # Accepts model codes
        'BorrowedDate' => 'Sinds',
        'BorrowedDisplayInPanel' => 'Toon item in hoofdvenster', # Accepts model codes

        'MailTitle' => 'Stuur een e-mail',
        'MailFrom' => 'Van: ',
        'MailTo' => 'Naar: ',
        'MailSubject' => 'Onderwerp: ',
        'MailSmtpError' => 'Probleem bij verbinding met SMTP-server',
        'MailSendmailError' => 'Probleem wanneer sendmail gestart wordt',

        'SearchTooltip' => 'Zoek alle items', # Accepts model codes
        'SearchTitle' => 'Zoek item', # Accepts model codes
        'SearchNoField' => 'No field have been selected for the search box.
Add some of them in the Filters tab of the collection settings.',

        'QueryReplaceField' => 'Velden om te vervangen',
        'QueryReplaceOld' => 'Huidige waarde',
        'QueryReplaceNew' => 'Nieuwe waarde',
        'QueryReplaceLaunch' => 'Vervang',
        
        'ImportWindowTitle' => 'Kies velden om te importeren',
        'ImportViewPicture' => 'Bekijk afbeelding',
        'ImportSelectAll' => 'Kies alles',
        'ImportSelectNone' => 'Kies niets',

        'MultiSiteTitle' => 'Websites om te gebruiken voor zoekopdrachten',
        'MultiSiteUnused' => 'Niet gebruikte plug-ins',
        'MultiSiteUsed' => 'Gebruikte plug-ins',
        'MultiSiteLang' => 'Vul lijst met Engelse plug-ins',
        'MultiSiteEmptyError' => 'Je hebt een lege websitelijst',
        'MultiSiteClear' => 'Wis lijst',
        
        'DisplayOptionsTitle' => 'Items om te tonen',
        'DisplayOptionsAll' => 'Kies alles',
        'DisplayOptionsSearch' => 'Zoek knop',

        'GenresTitle' => 'Genreconversie',
        'GenresCategoryName' => 'Genre om te gebruiken',
        'GenresCategoryMembers' => 'Genre om te vervangen',
        'GenresLoad' => 'Laad een lijst',
        'GenresExport' => 'Bewaar lijst in een bestand',
        'GenresModify' => 'Bewerk conversie',

        'PropertiesName' => 'Collectienaam',
        'PropertiesLang' => 'Taalcode',
        'PropertiesOwner' => 'Eigenaar',
        'PropertiesEmail' => 'E-mail',
        'PropertiesDescription' => 'Beschrijving',
        'PropertiesFile' => 'Bestandsinformatie',
        'PropertiesFilePath' => 'Volledig pad',
        'PropertiesItemsNumber' => 'Aantal items', # Accepts model codes
        'PropertiesFileSize' => 'Grootte',
        'PropertiesFileSizeSymbols' => ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
        'PropertiesCollection' => 'Collectie eigenschappen',
        'PropertiesDefaultPicture' => 'Standaardafbeelding',

        'MailProgramsTitle' => 'Programma\'s om mail te versturen',
        'MailProgramsName' => 'Naam',
        'MailProgramsCommand' => 'Commandlijn',
        'MailProgramsRestore' => 'Herstel standaarden',
        'MailProgramsAdd' => 'Voeg een programma toe',
        'MailProgramsInstructions' => 'In command lijn, een aantal substituties worden gemaakt:
 %f is vervangen door e-mailadres van de gebruiker.
 %t is vervangen door adres van de ontvanger.
 %s is vervangen door het onderwerp van het bericht.
 %b is vervangen door de inhoud van het bericht.',

        'BookmarksBookmarks' => 'Bladwijzers',
        'BookmarksFolder' => 'Mappen',
        'BookmarksLabel' => 'Label',
        'BookmarksPath' => 'Doel',
        'BookmarksNewFolder' => 'Nieuwe map',

        'AdvancedSearchType' => 'Zoektype',
        'AdvancedSearchTypeAnd' => 'Items komen met alle criteria overeen', # Accepts model codes
        'AdvancedSearchTypeOr' => 'Items komen met minstens één criterium overeen', # Accepts model codes
        'AdvancedSearchCriteria' => 'Criteria',
        'AdvancedSearchAnyField' => 'Elk veld',
        'AdvancedSearchSaveTitle' => 'Bewaar zoekopdracht',
        'AdvancedSearchSaveName' => 'Naam',
        'AdvancedSearchSaveOverwrite' => 'Er bestaat al een opgeslagen zoekopdracht met deze naam. Gebruik een andere naam.',
        'AdvancedSearchUseCase' => 'Hoofdlettergevoelig',
        'AdvancedSearchIgnoreDiacritics' => 'Negeer accenten en andere diacritische tekens',

        'BugReportSubject' => 'Foutenrapport gegenereerd door GCstar',
        'BugReportVersion' => 'Versie',
        'BugReportPlatform' => 'Besturingssysteem',
        'BugReportMessage' => 'Fout bericht',
        'BugReportInformation' => 'Extra informatie',

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
