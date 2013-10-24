{
    package GCLang::SV; # Use the swedish language package

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

        'LangName' => 'Svenska',
        
        'Separator' => ': ',
        
        'Warning' => '<b>Varning</b>:
        
Information nerladdad från hemsidor (genom söktilläggen) är <b>enbart för privat bruk</b>.        

Alla nydistribueringar är förbjudna utan respektive hemsidors <b>explicita medgivande</b>. 

För att avgöra vilken hemsida som äger informationen, så kan du använda <b>knappen under artikelns detaljer</b>.',
        
        'AllItemsFiltered' => 'Inga artiklar matchar ditt filteringskriterium', # Accepts model codes
        
#Installation
        'InstallDirInfo' => 'Installera i ',
        'InstallMandatory' => 'Nödvändiga komponenter',
        'InstallOptional' => 'Valfria komponenter',
        'InstallErrorMissing' => 'Fel : Följande Perl komponenter måste installeras',
        'InstallPrompt' => 'Grundkatalog för installation [/usr/local]: ',
        'InstallEnd' => 'Installationen slutförd',
        'InstallNoError' => 'Inga fel påträffades',
        'InstallLaunch' => 'För att starta programmet, så kan du starta ',
        'InstallDirectory' => 'Grundkatalog',
        'InstallTitle' => 'GCstar installation',
        'InstallDependencies' => 'Beroenden',
        'InstallPath' => 'Sökväg',
        'InstallOptions' => 'Inställningar',
        'InstallSelectDirectory' => 'Välj grundkatalog för installationen',
        'InstallWithClean' => 'Ta bort filer som hittats i installationskatalogen',
        'InstallWithMenu' => 'Lägg till GCstar till Program-menyn',
        'InstallNoPermission' => 'Fel: Du har inte rättighet att skriva till vald katalog',
        'InstallMissingMandatory' => 'Nödvändiga beroenden fattas. Du kommer inte kunna installera GCstar förrän de har lagts till i ditt system.',
        'InstallMissingOptional' => 'Valfria beroenden fattas. De är listade under. GCstar kommer att installeras men viss funktionalitet kommer inte vara tillgänglig.',
        'InstallMissingNone' => 'Inga beroenden fattas. Du bör fortsätta installationen av GCstar.',
        'InstallOK' => 'OK',
        'InstallMissing' => 'Fattas',
        'InstallMissingFor' => 'Fattas för',
        'InstallCleanDirectory' => 'Tar bort GCstar\'s filer i katalogen: ',
        'InstallCopyDirectory' => 'Kopiera filer i katalogen: ',
        'InstallCopyDesktop' => 'Kopiera skrivbordsfilen i: ',

#Update
        'UpdateUseProxy' => 'Proxy att använda (Tryck bara enter om ingen): ',
        'UpdateNoPermission' => 'Skrivrättighet nekad i denna katalog: ',
        'UpdateNone' => 'Inga updateringar har hittats',
        'UpdateFileNotFound' => 'Filen ej hittad',

#Splash
        'SplashInit' => 'Initiering',
        'SplashLoad' => 'Laddar Samling',
        'SplashDisplay' => 'Visar Samling',
        'SplashSort' => 'Sorterar samling',
        'SplashDone' => 'Färdig',

#Import from GCfilms
        'GCfilmsImportQuestion' => 'Det verkar som du använt GCfilms tidigare. Vad vill du importera från GCfilms till GCstar (det kommer inte att påverka GCfilms ifall du fortfarande vill använda det)?',
        'GCfilmsImportOptions' => 'Inställningar',
        'GCfilmsImportData' => 'Filmlista',

#Menus
        'MenuFile' => '_Arkiv',
            'MenuNewList' => '_Ny Samling',
            'MenuStats' => 'Statistik',
            'MenuHistory' => '_Tidigare Samlingar',
            'MenuLend' => 'Visa _Lånade Artiklar', # Accepts model codes
            'MenuImport' => '_Importera',	
            'MenuExport' => '_Exportera',
            'MenuAddItem' => '_Add Items', # Accepts model codes
    
        'MenuEdit'  => '_Redigera',
            'MenuDuplicate' => 'Ko_piera artikel', # Accepts model codes
            'MenuDuplicatePlural' => 'Du_plicate Items', # Accepts model codes
            'MenuEditSelectAllItems' => 'Select _All Items', # Accepts model codes
            'MenuEditDeleteCurrent' => '_Ta bort artikel', # Accepts model codes
            'MenuEditDeleteCurrentPlural' => '_Remove Items', # Accepts model codes  
            'MenuEditFields' => '_Ändra samlingens fält',
            'MenuEditLockItems' => '_Lås Samling',
    
        'MenuDisplay' => 'F_ilter',
            'MenuSavedSearches' => 'Sparade sökningar',
                'MenuSavedSearchesSave' => 'Spara aktuell sökning',
                'MenuSavedSearchesEdit' => 'Modifiera sparade sökningar',
            'MenuAdvancedSearch' => 'A_vancerad Sök',
            'MenuViewAllItems' => 'Visa _Alla artiklar', # Accepts model codes
            'MenuNoFilter' => '_Någon',
    
        'MenuConfiguration' => '_Inställningar',
            'MenuDisplayMenu' => 'Display',
                'MenuDisplayFullScreen' => 'Full screen',
                'MenuDisplayMenuBar' => 'Menus',
                'MenuDisplayToolBar' => 'Toolbar',
                'MenuDisplayStatusBar' => 'Bottom bar',
            'MenuDisplayOptions' => '_Visad Information',
            'MenuBorrowers' => '_Låntagare',
            'MenuToolbarConfiguration' => '_Verktygsfältets kontroller',
            'MenuDefaultValues' => 'Default values for new item', # Accepts model codes
            'MenuGenresConversion' => 'Genre _Konvertering',
        
        'MenuBookmarks' => 'Mina _Samlingar',
            'MenuBookmarksAdd' => '_Lägg till aktuell samling',
            'MenuBookmarksEdit' => '_Redigera sparade samlingar',

        'MenuHelp' => '_Hjälp',
            'MenuHelpContent' => '_Innehåll',
            'MenuAllPlugins' => 'Visa _tillägg',
            'MenuBugReport' => 'Rapportera en _bugg',
            'MenuAbout' => '_Om GCstar',
    
        'MenuNewWindow' => 'Visa artikel i _Nytt Fönster', # Accepts model codes
        'MenuNewWindowPlural' => 'Show Items in _New Window', # Accepts model codes
        
        'ContextExpandAll' => 'Expandera alla',
        'ContextCollapseAll' => 'Komprimera alla',
        'ContextChooseImage' => 'Välj _Bild',
        'ContextImageEditor' => 'Öppna med Bildredigerare',
        'ContextOpenWith' => 'Öppna me_d',
        'ContextImgFront' => 'Framsida',
        'ContextImgBack' => 'Baksida',
        'ContextChooseFile' => 'Välj en Fil',
        'ContextChooseFolder' => 'Välj en Mapp',
        
        'DialogEnterNumber' => 'Var god ange ett värde',

        'RemoveConfirm' => 'Är du säker på att du vill ta bort denna artikel?', # Accepts model codes
        'RemoveConfirmPlural' => 'Do you really want to remove these items?', # Accepts model codes
        'DefaultNewItem' => 'Ny artikel', # Accepts model codes
        'NewItemTooltip' => 'Lägg till en ny artikel', # Accepts model codes
        'NoItemFound' => 'Ingenting hittades. Vill du söka på en annan hemsida?',
        'OpenList' => 'Var god välj samling',
        'SaveList' => 'Var god välj vart du vill spara samlingen',
        'SaveListTooltip' => 'Spara aktuell samling',
        'SaveUnsavedChanges' => 'Det finns osparade ändringar i din samling. Vill du spara dem?',
        'SaveDontSave' => 'Spara inte',
        'PreferencesTooltip' => 'Ställ in dina inställningar',
        'ViewTooltip' => 'Ändra samlingsvisning',
        'PlayTooltip' => 'Spela video associerad med artikel', # Accepts model codes
        'PlayFileNotFound' => 'Filen att spela hittades ej på denna platsen:',
        'PlayRetry' => 'Försök igen',

        'StatusSave' => 'Sparar...',
        'StatusLoad' => 'Laddar...',
        'StatusSearch' => 'Sökning pågår...',
        'StatusGetInfo' => 'Hämtar information...',
        'StatusGetImage' => 'Hämtar bild...',
                
        'SaveError' => 'Artikellistan kunde inte sparas. Var god kontrollera rättigheter och ledigt diskutrymme.',
        'OpenError' => 'Artikellistan kunde inte öppnas. Var god kontrollera rättigheter.',
		'OpenFormatError' => 'Artikellistan kunde inte öppnas. Formatet kan vara felaktigt.',
        'OpenVersionWarning' => 'Samlingen är skapad med en nyare version av GCstar. Om du sparar den, kan dataförlust ske.',
        'OpenVersionQuestion' => 'Vill du fortfarande fortsätta?',
        'ImageError' => 'Vald katalog att spara bilder till är felaktig. Var god välj en annan.',
        'OptionsCreationError'=> 'Kan inte skapa inställningsfil: ',
        'OptionsOpenError'=> 'Kan inte öppna inställningsfil: ',
        'OptionsSaveError'=> 'Kan inte spara inställningsfil: ',
        'ErrorModelNotFound' => 'Modell ej funnen: ',
        'ErrorModelUserDir' => 'Användardefinierade modeller finns i: ',
        
        'RandomTooltip' => 'Vad ska vi se ikväll ?',
        'RandomError'=> 'Du har inga artiklar som kan bli valda', # Accepts model codes
        'RandomEnd'=> 'Det finns inga fler artiklar', # Accepts model codes
        'RandomNextTip'=> 'Nästa förslag',
        'RandomOkTip'=> 'Acceptera denna artikel',
        
        'AboutTitle' => 'Om GCstar',
        'AboutDesc' => 'Samlingshanterare',
        'AboutVersion' => 'Version',
        'AboutTeam' => 'Team',
        'AboutWho' => 'Christian Jodar (Tian): Projektföreståndare, Programmerare
Nyall Dawson (Zombiepig): Programmerare
TPF: Programmerare
Adolfo González: Programmerare
',
        'AboutLicense' => 'Distribuerad under GNU GPL Licensen, Logotyper Copyright le Spektre',
        'AboutTranslation' => 'Svensk översättning av anonym medarbetare',
        'AboutDesign' => 'Łukasz Kowalczk (Qoolman): Skin Designer
Logotyper och webbdesign skapad av le Spektre',

        'ToolbarRandom' => 'Ikväll',

        'UnsavedCollection' => 'Osparad samling',
        'ModelsSelect' => 'Välj en samlingstyp',
        'ModelsPersonal' => 'Personliga samlingar',
        'ModelsDefault' => 'Förvalda samlingar',
        'ModelsList' => 'Samlingsdefinition',
        'ModelSettings' => 'Samlingsinställningar',
        'ModelNewType' => 'Ny samlingstyp',
        'ModelName' => 'Namn på samlingstyp:',
        'ModelFields' => 'Fält',
        'ModelOptions'	=> 'Inställningar',
        'ModelFilters'	=> 'Filter',
        'ModelNewField' => 'Nytt fält',
        'ModelFieldInformation' => 'Information',
        'ModelFieldName' => 'Beteckning:',
        'ModelFieldType' => 'Typ:',
        'ModelFieldGroup' => 'Grupp:',
        'ModelFieldValues' => 'Värden',
        'ModelFieldInit' => 'Förvalt:',
        'ModelFieldMin' => 'Minimum:',
        'ModelFieldMax' => 'Maximum:',
        'ModelFieldList' => 'Värdelista:',
        'ModelFieldListLegend' => '<i>Separerat med komma</i>',
        'ModelFieldDisplayAs' => 'Visa som: ',
        'ModelFieldDisplayAsText' => 'Text',
        'ModelFieldDisplayAsGraphical' => 'Värdering',
        'ModelFieldTypeShortText' => 'Kort text',
        'ModelFieldTypeLongText' => 'Lång text',
        'ModelFieldTypeYesNo' => 'Ja/Nej',
        'ModelFieldTypeNumber' => 'Nummer',
        'ModelFieldTypeDate' => 'Datum',
        'ModelFieldTypeOptions' => 'Fördefinierad värdelista',
        'ModelFieldTypeImage' => 'Bild',
        'ModelFieldTypeSingleList' => 'Enkel lista',
        'ModelFieldTypeFile' => 'Fil',
        'ModelFieldTypeFormatted' => 'Beroende av andra fält',
        'ModelFieldParameters' => 'Parametrar',
        'ModelFieldHasHistory' => 'Använd historik',
        'ModelFieldFlat' => 'Visa på en rad',
        'ModelFieldStep' => 'Öka steg:',
        'ModelFieldFileFormat' => 'Filformat:',
        'ModelFieldFileFile' => 'Enkel fil',
        'ModelFieldFileImage' => 'Bild',
        'ModelFieldFileVideo' => 'Video',
        'ModelFieldFileAudio' => 'Ljud',
        'ModelFieldFileProgram' => 'Program',
        'ModelFieldFileUrl' => 'Länk',
        'ModelFieldFileEbook' => 'Ebook',
        'ModelOptionsFields' => 'Fält att använda',
        'ModelOptionsFieldsAuto' => 'Automatisk',
        'ModelOptionsFieldsNone' => 'Ingen',
        'ModelOptionsFieldsTitle' => 'Som titel',
        'ModelOptionsFieldsId' => 'Som identifierare',
        'ModelOptionsFieldsCover' => 'Som omslag',
        'ModelOptionsFieldsPlay' => 'För Spelaknapp',
        'ModelCollectionSettings' => 'Samlingsinställningar',
        'ModelCollectionSettingsLending' => 'Artiklar kan bli utlånade',
        'ModelCollectionSettingsTagging' => 'Produkter kan bli märkta',
        'ModelFilterActivated' => 'Bör vara i sökrutan',
        'ModelFilterComparison' => 'Jämförelser',
        'ModelFilterContain' => 'Innehåller',
        'ModelFilterDoesNotContain' => 'Innehåller ej',
        'ModelFilterRegexp' => 'Reguljära uttryck',
        'ModelFilterRange' => 'Räckvidd',
        'ModelFilterNumeric' => 'Jämförelsen är numerisk',
        'ModelFilterQuick' => 'Skapa ett snabbt filter',
        'ModelTooltipName' => 'Använd ett namn för att återanvända denna modell för många samlingar. Om den är tom, så kommer inställningarna sparas direkt i själva samlingen',
        'ModelTooltipLabel' => 'Fältnamnet såsom den kommer visas',
        'ModelTooltipGroup' => 'Används för att gruppera fält. Artiklar utan värden här kommer att vara i den förinställda gruppen',
        'ModelTooltipHistory' => 'Bör de tidigare angivna värdena sparas i en lista associerad till fältet',
        'ModelTooltipFormat' => 'Detta format används för att avgöra hur filen skall öppnas med Spelaknappen',
        'ModelTooltipLending' => 'Detta kommer att lägga till några fält för att hantera utlåningar',
        'ModelTooltipTagging' => 'Detta kommer lägga till några fält för att hantera märkning',
        'ModelTooltipNumeric' => 'Bör värdena anses som nummer för jämförelse',
        'ModelTooltipQuick' => 'Detta kommer lägga till en undermeny i Filtermenyn',
        
        'ResultsTitle' => 'Välj en artikel', # Accepts model codes
        'ResultsNextTip' => 'Sök på nästa hemsida',
        'ResultsPreview' => 'Förhandsgranska',
        'ResultsInfo' => 'Du kan lägga till flera produkter till en samling genom att hålla ner Ctrl- eller Skift-tangenten för att markera dem', # Accepts model codes
        
        'OptionsTitle' => 'Inställningar',
		'OptionsExpertMode' => 'Expert Läge',
        'OptionsPrograms' => 'Specifiera program att använda med övrig media, lämna tomt för att använda systemets inställningar.',
        'OptionsBrowser' => 'Webbläsare',
        'OptionsPlayer' => 'Videospelare',
        'OptionsAudio' => 'Ljudspelare',
        'OptionsImageEditor' => 'Bildredigerare',
        'OptionsCdDevice' => 'CD enhet',
        'OptionsImages' => 'Bildkatalog',
        'OptionsUseRelativePaths' => 'Använd relativa sökvägar för bilder',
        'OptionsLayout' => 'Layout',
        'OptionsStatus' => 'Visa statusfält',
        'OptionsUseStars' => 'Use stars to display ratings',
        'OptionsWarning' => 'Varning: Ändringar i denna flik kommer ej ta effekt förrän applikationen startas om.',
        'OptionsRemoveConfirm' => 'Fråga efter godkännande innan artikel tas bort',
        'OptionsAutoSave' => 'Spara samling automatiskt',
        'OptionsAutoLoad' => 'Ladda senast valda samling vid uppstart',
        'OptionsSplash' => 'Visa splash screen',
        'OptionsTearoffMenus' => 'Enable tear-off menus',
        'OptionsSpellCheck' => 'Använd stavningskontroll för långa textfält',
        'OptionsProgramTitle' => 'Välj program att använda',
        'OptionsPlugins' => 'Hemsida att hämta data från',
        'OptionsAskPlugins' => 'Fråga (Alla hemsidor)',
        'OptionsPluginsMulti' => 'Många hemsidor',
        'OptionsPluginsMultiAsk' => 'Fråga (Många hemsidor)',
        'OptionsPluginsMultiPerField' => 'Många sajter (per fält)',
        'OptionsPluginsMultiPerFieldWindowTitle' => 'Många sajter per ordning av valt fäl',
        'OptionsPluginsMultiPerFieldDesc' => 'För varje fält kommer vi fylla i fältet med den första icke-tomma informationen med början från vänster',
        'OptionsPluginsMultiPerFieldFirst' => 'Första',
        'OptionsPluginsMultiPerFieldLast' => 'Sista',
        'OptionsPluginsMultiPerFieldRemove' => 'Ta bort',
        'OptionsPluginsMultiPerFieldClearSelected' => 'Töm valda fältlistor',
        'OptionsPluginsList' => 'Välj lista',
        'OptionsAskImport' => 'Välj fält som ska importeras',
        'OptionsProxy' => 'Använd en proxy',
        'OptionsCookieJar' => 'Använd denna kak-jarfil',
        'OptionsLang' => 'Språk',
        'OptionsMain' => 'Huvud',
        'OptionsPaths' => 'Sökväg',
        'OptionsInternet' => 'Internet',
        'OptionsConveniences' => 'Funktioner',
        'OptionsDisplay' => 'Visning',
        'OptionsToolbar' => 'Verktygsfält',
        'OptionsToolbars' => {0 => 'Inget', 1 => 'Litet', 2 => 'Stort', 3 => 'Systeminställningar'},
        'OptionsToolbarPosition' => 'Position',
        'OptionsToolbarPositions' => {0 => 'Topp', 1 => 'Botten', 2 => 'Vänster', 3 => 'Höger'},
        'OptionsExpandersMode' => 'För lång expanderare',
        'OptionsExpandersModes' => {'asis' => 'Gör ingenting', 'cut' => 'Klipp ut', 'wrap' => 'Radbrytning'},
        'OptionsDateFormat' => 'Datumformat',
        'OptionsDateFormatTooltip' => 'Formatet är det som används av strftime(3). Standard är %d/%m/%y',
        'OptionsView' => 'Artikellista',
        'OptionsViews' => {0 => 'Text', 1 => 'Bild', 2 => 'Detaljerat'},
        'OptionsColumns' => 'Kolumner',
        'OptionsMailer' => 'E-post',
        'OptionsSMTP' => 'Server',
        'OptionsFrom' => 'Din e-post',
        'OptionsTransform' => 'Placera artiklar i slutet av titlarna',
        'OptionsArticles' => 'Artiklar (Separerat med komma)',
        'OptionsSearchStop' => 'Tillåt att pågående sökning avbryts',
        'OptionsBigPics' => 'Använd stora bilder om möjligt',
        'OptionsAlwaysOriginal' => 'Använd huvudtitels som förvald titel om ingen finns',
        'OptionsRestoreAccelerators' => 'Återställ acceleratorer',
        'OptionsHistory' => 'Storlek av histori',
        'OptionsClearHistory' => 'Töm historik',
		'OptionsStyle' => 'Skal',
        'OptionsDontAsk' => 'Fråga inte längre',
        'OptionsPathProgramsGroup' => 'Program',
        'OptionsProgramsSystem' => 'Använd program som är definierade av systemet',
        'OptionsProgramsUser' => 'Använd specificerade program',
        'OptionsProgramsSet' => 'Ställ in program',
        'OptionsPathImagesGroup' => 'Bilder',
        'OptionsInternetDataGroup' => 'Importera data',
        'OptionsInternetSettingsGroup' => 'Inställningar',
        'OptionsDisplayInformationGroup' => 'Informationsvisning',
        'OptionsDisplayArticlesGroup' => 'Artiklar',
        'OptionsImagesDisplayGroup' => 'Visning',
        'OptionsImagesStyleGroup' => 'Stil',
        'OptionsDetailedPreferencesGroup' => 'Inställningar',
        'OptionsFeaturesConveniencesGroup' => 'Bekvämlighet',
        'OptionsPicturesFormat' => 'Prefix att använda för bilder:',
        'OptionsPicturesFormatInternal' => 'gcstar__',
        'OptionsPicturesFormatTitle' => 'Titel eller namn att associera med artikel',
        'OptionsPicturesWorkingDir' => '%WORKING_DIR% eller . kommer att ersättas med samlingskatalogen (använd bara början av sökvägen)',
        'OptionsPicturesFileBase' => '%FILE_BASE% kommer att ersättas med samlingsfilnamnet utan suffix (.gcs)',
        'OptionsPicturesWorkingDirError' => '%WORKING_DIR% kan enbart användas i början av sökvägen för bilder',
        'OptionsPicturesWorkingDirError' => '%WORKING_DIR% kan enbart användas i början av sökvägen för bilder',
        'OptionsConfigureMailers' => 'Konfigurera e-postklienter',

        'ImagesOptionsButton' => 'Inställningar',
        'ImagesOptionsTitle' => 'Inställningar för bildlistan',
        'ImagesOptionsSelectColor' => 'Välj en färg',
        'ImagesOptionsUseOverlays' => 'Använd bildöverdrag',
        'ImagesOptionsBg' => 'Bakgrund',
        'ImagesOptionsBgPicture' => 'Använd en bakgrundsbild',
        'ImagesOptionsFg'=> 'Markering',
        'ImagesOptionsBgTooltip' => 'Ändra bakgrundsfärg',
        'ImagesOptionsFgTooltip'=> 'Ändra markeringsfärg',
        'ImagesOptionsResizeImgList' => 'Ändra automatiskt antalet kolumner',
        'ImagesOptionsAnimateImgList' => 'Use animations',
        'ImagesOptionsSizeLabel' => 'Storlek',
        'ImagesOptionsSizeList' => {0 => 'Väldigt liten', 1 => 'Liten', 2 => 'Mellan', 3 => 'Stor', 4 => 'Extra Stor'},
        'ImagesOptionsSizeTooltip' => 'Välj en bildstorlek',
		        
        'DetailedOptionsTitle' => 'Inställningar för detaljerad lista',
        'DetailedOptionsImageSize' => 'Bildstorlek',
        'DetailedOptionsGroupItems' => 'Gruppera artiklar efter',
        'DetailedOptionsSecondarySort' => 'Sortera fält för barn',
		'DetailedOptionsFields' => 'Välj fält att visa',
        'DetailedOptionsGroupedFirst' => 'Gruppera alla artiklar som har barn',
        'DetailedOptionsAddCount' => 'Ange antalet element för kategorier',

        'ExtractButton' => 'Information',
        'ExtractTitle' => 'Filinformation',
        'ExtractImport' => 'Använd värden',

        'FieldsListOpen' => 'Ladda en fältlista från en fil',
        'FieldsListSave' => 'Spara fältlista till en fil',
        'FieldsListError' => 'Dessa fältlistor kan inte användas med denna typ av samling',
        'FieldsListIgnore' => '--- Ignore',

        'ExportTitle' => 'Exportera artikellista',
        'ExportFilter' => 'Exportera enbart visade artiklar',
        'ExportFieldsTitle' => 'Fält som kommer exporteras',
        'ExportFieldsTip' => 'Välj fält som du vill exportera',
        'ExportWithPictures' => 'Kopiera bilder i en underkatalog',
        'ExportSortBy' => 'Sortera på',
        'ExportOrder' => 'Ordning',

        'ImportListTitle' => 'Importa en annan artikellista',
        'ImportExportData' => 'Data',
        'ImportExportFile' => 'Fil',
        'ImportExportFieldsUnused' => 'Osparade fält',
        'ImportExportFieldsUsed' => 'Använda fält',
        'ImportExportFieldsFill' => 'Lägg till Alla',
        'ImportExportFieldsClear' => 'Ta bort Alla',
        'ImportExportFieldsEmpty' => 'Du måste välja minst ett fält',
        'ImportExportFileEmpty' => 'Du måste specificera ett filnamn',
        'ImportFieldsTitle' => 'Fält som kommer importeras',
        'ImportFieldsTip' => 'Välj fält du vill importera',
        'ImportNewList' => 'Skapa en ny samling',
        'ImportCurrentList' => 'Lägg till aktuell samling',
        'ImportDropError' => 'Det uppstod ett fel med att öppna åtminstone en fil. Föregående lista kommer laddas om.',
        'ImportGenerateId' => 'Generera identifierare för varje artikel',

        'FileChooserOpenFile' => 'Var god välj en fil att använda',
        'FileChooserDirectory' => 'Mapp',
        'FileChooserOpenDirectory' => 'Välj en katalog',
        'FileChooserOverwrite' => 'Den här filen existerar redan. Vill du skriva över den?',
        'FileAllFiles' => 'Alla Filer',
        'FileVideoFiles' => 'Video Filer',
        'FileEbookFiles' => 'Ebook Filer',
        'FileAudioFiles' => 'Audio Filer',
        'FileGCstarFiles' => 'GCstar Samlingar',

        #Some default panels
        'PanelCompact' => 'Kompakt',
        'PanelReadOnly' => 'Enbart läsning',
        'PanelForm' => 'Flikar',

        'PanelSearchButton' => 'Hämta Information',
        'PanelSearchTip' => 'Sök webben för information om detta namn',
        'PanelSearchContextChooseOne' => 'Välj en sajt...',
        'PanelSearchContextMultiSite' => 'Använd "Många sajter"',
        'PanelSearchContextMultiSitePerField' => 'Använd "Många sajter per fält"',
        'PanelSearchContextOptions' => 'Ändra inställningar...',
        'PanelImageTipOpen' => 'Klicka på bilden för att välja en annan.',
        'PanelImageTipView' => 'Klicka på bilden för att visa den i dess riktiga storlek.',
        'PanelImageTipMenu' => ' Högerklicka för ytterligare alternativ.',
        'PanelImageTitle' => 'Välj en bild',
        'PanelImageNoImage' => 'Ingen bild',
        'PanelSelectFileTitle' => 'Välj en fil',
        'PanelLaunch' => 'Launch',        
        'PanelRestoreDefault' => 'Återställ förvald',
        'PanelRefresh' => 'Uppdatera',
        'PanelRefreshTip' => 'Uppdatera information från webben',

        'PanelFrom' =>'Från',
        'PanelTo' =>'Till',

        'PanelWeb' => 'Visa Information',
        'PanelWebTip' => 'Visa information på webben om denna artikel', # Accepts model codes
        'PanelRemoveTip' => 'Ta bort aktuell artikel', # Accepts model codes

        'PanelDateSelect' => 'Välj',
        'PanelNobody' => 'Ingen',
        'PanelUnknown' => 'Okänd',
        'PanelAdded' => 'Lägg till datum',
        'PanelRating' => 'Betyg',
        'PanelPressRating' => 'Klicka i betyg',
        'PanelLocation' => 'Lokalisering',

        'PanelLending' => 'Utlåning',
        'PanelBorrower' => 'Låntagare',
        'PanelLendDate' => 'Utlånad sedan',
        'PanelHistory' => 'Utlåningshistorik',
        'PanelReturned' => 'Artikel Returnerad', # Accepts model codes
        'PanelReturnDate' => 'Returnerad datum',
        'PanelLendedYes' => 'Lånad',
        'PanelLendedNo' => 'Tillgänglig',

        'PanelTags' => 'Etikett',
        'PanelFavourite' => 'Favorit',
        'TagsAssigned' => 'Tilldelad etikett', 

        'PanelUser' => 'Användarfält',

        'CheckUndef' => 'Både',
        'CheckYes' => 'Ja',
        'CheckNo' => 'Nej',

        'ToolbarAll' => 'Visa Alla',
        'ToolbarAllTooltip' => 'Visa alla artiklar',
        'ToolbarGroupBy' => 'Gruppera på',
        'ToolbarGroupByTooltip' => 'Välj det fält att använda för att gruppera artiklar i listan',
        'ToolbarQuickSearch' => 'Snabbsök',
        'ToolbarQuickSearchLabel' => 'Sök',
        'ToolbarQuickSearchTooltip' => 'Markera fältet att söka i. Ange sökord och tryck Enter',
        'ToolbarSeparator' => ' Avskiljare',
        
        'PluginsTitle' => 'Sök en artikel',
        'PluginsQuery' => 'Förfrågan',
        'PluginsFrame' => 'Sök hemsida',
        'PluginsLogo' => 'Logotyp',
        'PluginsName' => 'Namn',
        'PluginsSearchFields' => 'Sök fält',
        'PluginsAuthor' => 'Författare',
        'PluginsLang' => 'Språk',
        'PluginsUseSite' => 'Använd valda hemsidor för framtida sökningar',
        'PluginsPreferredTooltip' => 'Sajt rekommenderad av GCstar',
        'PluginDisabled' => 'Avaktiverad',

        'BorrowersTitle' => 'Konfigurera låntagare',
        'BorrowersList' => 'Låntagare',
        'BorrowersName' => 'Namn',
        'BorrowersEmail' => 'E-post',
        'BorrowersAdd' => 'Lägg till',
        'BorrowersRemove' => 'Ta bort',
        'BorrowersEdit' => 'Redigera',
        'BorrowersTemplate' => 'E-post mall',
        'BorrowersSubject' => 'E-post ämne',
        'BorrowersNotice1' => '%1 kommer att ersättas med låntagarens namn',
        'BorrowersNotice2' => '%2 kommer att ersättas med artikelns titel',
        'BorrowersNotice3' => '%3 kommer att ersättas med låningsdatum',

        'BorrowersImportTitle' => 'Importera låntagarens information',
        'BorrowersImportType' => 'Filformat:',
        'BorrowersImportFile' => 'Fil:',

        'BorrowedTitle' => 'Lånade artiklar', # Accepts model codes
        'BorrowedDate' => 'Sedan',
        'BorrowedDisplayInPanel' => 'Visa artikel i huvudfönstret', # Accepts model codes

        'MailTitle' => 'Skicka e-post',
        'MailFrom' => 'Från: ',
        'MailTo' => 'Till: ',
        'MailSubject' => 'Ämne: ',
        'MailSmtpError' => 'Problem med att ansluta till SMTP servern',
        'MailSendmailError' => 'Problem med att köra sendmail',

        'SearchTooltip' => 'Sök alla artiklar', # Accepts model codes
        'SearchTitle' => 'Artikelsökning', # Accepts model codes
        'SearchNoField' => 'Inget fält har markerats för sökrutan. Lägg till några av dem i fliken  
Filter under samlingens inställningar.',

        'QueryReplaceField' => 'Fält att ersätta',
        'QueryReplaceOld' => 'Aktuellt värde',
        'QueryReplaceNew' => 'Nytt värde',
        'QueryReplaceLaunch' => 'Ersätt',
        
        'ImportWindowTitle' => 'Välj Fält att Importera',
        'ImportViewPicture' => 'Visa bild',
        'ImportSelectAll' => 'Välj alla',
        'ImportSelectNone' => 'Välj ingen',

        'MultiSiteTitle' => 'Hemsida att använda för sökningar',
        'MultiSiteUnused' => 'Oanvända tillägg',
        'MultiSiteUsed' => 'Tillägg att använda',
        'MultiSiteLang' => 'Fyll lista med Svenska tillägg',
        'MultiSiteEmptyError' => 'Du har en tom hemsidelista',
        'MultiSiteClear' => 'Töm lista',
        
        'DisplayOptionsTitle' => 'Artiklar att visa',
        'DisplayOptionsAll' => 'Välj alla',
        'DisplayOptionsSearch' => 'Sök knapp',

        'GenresTitle' => 'Genre Konvertering',
        'GenresCategoryName' => 'Genre att använda',
        'GenresCategoryMembers' => 'Genre att ersätta',
        'GenresLoad' => 'Ladda en lista',
        'GenresExport' => 'Spara listan till en fil',
        'GenresModify' => 'Redigera konvertering',

        'PropertiesName' => 'Namn på samling',
        'PropertiesLang' => 'Språkkod',
        'PropertiesOwner' => 'Ägare',
        'PropertiesEmail' => 'E-post',
        'PropertiesDescription' => 'Beskrivning',
        'PropertiesFile' => 'Filinformation',
        'PropertiesFilePath' => 'Full sökväg',
        'PropertiesItemsNumber' => 'Antal artiklar', # Accepts model codes
        'PropertiesFileSize' => 'Storlek',
        'PropertiesFileSizeSymbols' => ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
        'PropertiesCollection' => 'Egenskap för samling',
        'PropertiesDefaultPicture' => 'Förinställd bild',

        'MailProgramsTitle' => 'Program för att skicka e-post',
        'MailProgramsName' => 'Namn',
        'MailProgramsCommand' => 'Kommandorad',
        'MailProgramsRestore' => 'Återställ förvalda',
        'MailProgramsAdd' => 'Lägg till ett program',
        'MailProgramsInstructions' => 'I kommandoraden, så görs några ersättningar:
 %f ersätts med användarens e-postadress.
 %t ersätts med mottagarens adress.
 %s ersätts med ämnet för meddelandet.
 %b ersätts med meddelandets kropp.',

        'BookmarksBookmarks' => 'Bokmärken',
        'BookmarksFolder' => 'Kataloger',
        'BookmarksLabel' => 'Beteckning',
        'BookmarksPath' => 'Sökväg',
        'BookmarksNewFolder' => 'Ny mapp',

        'AdvancedSearchType' => 'Typ av sökning',
        'AdvancedSearchTypeAnd' => 'Artiklarna matchade alla kriterier', # Accepts model codes
        'AdvancedSearchTypeOr' => 'Artiklarna matchade åtminstone ett kriterium', # Accepts model codes
        'AdvancedSearchCriteria' => 'Kriterium',
        'AdvancedSearchAnyField' => 'Any field',
        'AdvancedSearchSaveTitle' => 'Spara sökning',
        'AdvancedSearchSaveName' => 'Namn',
        'AdvancedSearchSaveOverwrite' => 'En sparad sökning existerar redan med detta namn. Var god använd ett annat.',
        'AdvancedSearchUseCase' => 'Skiftlägeskänslighet',
        'AdvancedSearchIgnoreDiacritics' => 'Ignorera brytning och diakritiska tecken',
 
        'BugReportSubject' => 'Felrapport genererad från GCstar',
        'BugReportVersion' => 'Version',
        'BugReportPlatform' => 'Operativsystem',
        'BugReportMessage' => 'Felmeddelande',
        'BugReportInformation' => 'Ytterligare information',

#Statistics
        'StatsFieldToUse' => 'Fält att använd',
        'StatsSortByNumber' => 'Sortera på nummer av {x}',
        'StatsGenerate' => 'Generera',
        'StatsKindOfGraph' => 'Typ av grafik',
        'StatsBars' => 'Staplar',
        'StatsPie' => 'Tårtdiagra',
        'Stats3DPie' => '3D diagram',
        'StatsArea' => 'Areor',
        'StatsHistory' => 'Historik',
        'StatsWidth' => 'Bredd',
        'StatsHeight' => 'Höjd',
        'StatsFontSize' => 'Teckenstorlek',
        'StatsDisplayNumber' => 'Visa nummer',
        'StatsSave' => 'Spara statistik-bild till fil',
        'StatsAccumulate' => 'Samla ihop värden',
        'StatsShowAllDates' => 'Visa alla datum',

        'DefaultValuesTip' => 'Values set in this window will be used as the default values when creating a new {lowercase1}',
    );
}
1;
