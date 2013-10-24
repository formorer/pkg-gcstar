{
    package GCLang::GL;

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

        'LangName' => 'Galego',
        
        'Separator' => ': ',
        
        'Warning' => '<b>Aviso</b>:

A información descargada de sitios web (a través dos
complementos de procura) é só para <b>uso persoal</b>.       

Calquera redistribución está prohibida sen a
<b>autorización explícita</b> do sitio.

Para determinar a que web pertence a información, debe
utilizar <b>o botón situado debaixo dos detalles do elemento</b>.',
        
        'AllItemsFiltered' => 'Non hai elementos cumpran os criterios de filtrado', # Accepts model codes
        
#Installation
        'InstallDirInfo' => 'Instalar en ',
        'InstallMandatory' => 'Compoñentes obrigatorios',
        'InstallOptional' => 'Compoñentes opcionais',
        'InstallErrorMissing' => 'Erro : ten que instalar os seguintes compoñentes Perl: ',
        'InstallPrompt' => 'Directorio base para a instalación [/usr/local]: ',
        'InstallEnd' => 'Fin da instalación',
        'InstallNoError' => 'Ningún erro',
        'InstallLaunch' => 'Para usar a aplicación, execútea ',
        'InstallDirectory' => 'Directorio Base',
        'InstallTitle' => 'Instalación de GCstar',
        'InstallDependencies' => 'Dependencias',
        'InstallPath' => 'Ruta',
        'InstallOptions' => 'Opcións',
        'InstallSelectDirectory' => 'Seleccionar o directorio base para a instalación',
        'InstallWithClean' => 'Eliminar ficheiros que se atopen no directorio de instalación',
        'InstallWithMenu' => 'Engadir GCstar ao menú de Aplicacións',
        'InstallNoPermission' => 'Erro: Non ten permiso para escribir no directorio seleccionado',
        'InstallMissingMandatory' => 'Non se cumpren algunhas dependencias obrigatorias-. Non pode instalar GCstar até que se cumpran as dependencias.',
        'InstallMissingOptional' => 'Algunhas dependencias opcionais non se cumpren. Pode ver unha listaxe máis abaixo. GCstar pode instalarse pero algunhas características non estarán dispoñibles.',
        'InstallMissingNone' => 'Cúmprense todas as dependencias. Pode continuar a instalación de GCstar.',
        'InstallOK' => 'OK',
        'InstallMissing' => 'Non dispoñible',
        'InstallMissingFor' => 'Non dispoñible por',
        'InstallCleanDirectory' => 'Eliminando ficheiros de GCstar no directorio: ',
        'InstallCopyDirectory' => 'A copiar ficheiros no directorio: ',
        'InstallCopyDesktop' => 'A copiar o ficheiro de escritorio en: ',

#Update
        'UpdateUseProxy' => 'Usar Proxy (premer enter se non se usa ningún): ',
        'UpdateNoPermission' => 'Denegouse o permiso de escritura neste directorio: ',
        'UpdateNone' => 'Non se atoparon actualizacións',
        'UpdateFileNotFound' => 'Non se atopou o ficheiro',

#Splash
        'SplashInit' => 'Inicialización',
        'SplashLoad' => 'A cargar a colección',
        'SplashDisplay' => 'A mostrar a colección',
        'SplashSort' => 'A ordear a colección',
        'SplashDone' => 'Listo',

#Import from GCfilms
        'GCfilmsImportQuestion' => 'Semella que estivo a utilizar GCfilms con anterioridade. Que quere importar desde GCfilms para GCstar (isto non afectará aos ficheiros de GCfilms se quere seguilos usando)?',
        'GCfilmsImportOptions' => 'Preferencias',
        'GCfilmsImportData' => 'Listaxe de Filmes',

#Menus
        'MenuFile' => '_Ficheiro',
            'MenuNewList' => '_Nova Colección',
            'MenuStats' => 'Statistics',
            'MenuHistory' => 'Coleccións _Recentes',
            'MenuLend' => 'Amosar Elementos _Prestados', # Accepts model codes
            'MenuImport' => '_Importar',	
            'MenuExport' => '_Exportar',
            'MenuAddItem' => '_Add Items', # Accepts model codes
    
        'MenuEdit'  => '_Editar',
            'MenuDuplicate' => 'Du_plicar elemento', # Accepts model codes
            'MenuDuplicatePlural' => 'Du_plicate Items', # Accepts model codes
            'MenuEditSelectAllItems' => 'Select _All Items', # Accepts model codes
            'MenuEditDeleteCurrent' => 'Elimina_r Elemento', # Accepts model codes
            'MenuEditDeleteCurrentPlural' => '_Remove Items', # Accepts model codes 
            'MenuEditFields' => '_Cambiar campos da colección',
            'MenuEditLockItems' => '_Bloquear Colección',
    
        'MenuDisplay' => 'F_iltros',
            'MenuSavedSearches' => 'Saved searches',
                'MenuSavedSearchesSave' => 'Save current search',
                'MenuSavedSearchesEdit' => 'Modify saved searches',
            'MenuAdvancedSearch' => 'Procura A_vanzada ',
            'MenuViewAllItems' => '_Amosar todos os elementos', # Accepts model codes
            'MenuNoFilter' => '_Calquera',
    
        'MenuConfiguration' => '_Configuración',
            'MenuDisplayMenu' => 'Display',
                'MenuDisplayFullScreen' => 'Full screen',
                'MenuDisplayMenuBar' => 'Menus',
                'MenuDisplayToolBar' => 'Toolbar',
                'MenuDisplayStatusBar' => 'Bottom bar',
            'MenuDisplayOptions' => '_Información amosada',
            'MenuBorrowers' => '_Prestatarios',
            'MenuToolbarConfiguration' => '_Toolbar controls',
            'MenuDefaultValues' => 'Default values for new item', # Accepts model codes
            'MenuGenresConversion' => '_Conversión de Xéneros',
        
        'MenuBookmarks' => 'As miñas _Coleccións',
            'MenuBookmarksAdd' => 'Engadir colección _actual',
            'MenuBookmarksEdit' => '_Editar coleccións favoritas',

        'MenuHelp' => '_Axuda',
            'MenuHelpContent' => '_Contido',
            'MenuAllPlugins' => 'Ver com_plementos',
            'MenuBugReport' => 'Comunicar un problema',
            'MenuAbout' => '_Acerca de GCstar',
    
        'MenuNewWindow' => 'Amosar elemento nunha _Nova Xanela', # Accepts model codes
        'MenuNewWindowPlural' => 'Show Items in _New Window', # Accepts model codes
        
        'ContextExpandAll' => 'Expandir todo',
        'ContextCollapseAll' => 'Contraer todo',
        'ContextChooseImage' => 'Choose _Image',
        'ContextOpenWith' => 'Open Wit_h',
        'ContextImageEditor' => 'Image Editor',
        'ContextImgFront' => 'Front',
        'ContextImgBack' => 'Back',
        'ContextChooseFile' => 'Choose a File',
        'ContextChooseFolder' => 'Choose a Folder',
       
        'DialogEnterNumber' => 'Introduza un valor',

        'RemoveConfirm' => 'Está seguro de que quere eliminar este elemento?', # Accepts model codes
        'RemoveConfirmPlural' => 'Do you really want to remove these items?', # Accepts model codes

        'DefaultNewItem' => 'Novo elemento', # Accepts model codes
        'NewItemTooltip' => 'Engadir un novo elemento', # Accepts model codes
        'NoItemFound' => 'Non se atopou nada. Gustaríalle buscar en outra páxina web?',
        'OpenList' => 'Seleccine unha colección',
        'SaveList' => 'Escolla onde gardar a colección',
        'SaveListTooltip' => 'Gardar a colección actual',
        'SaveUnsavedChanges' => 'Hai cambios na colección que non se gardaron todavía. Quere gardalos?',
        'SaveDontSave' => 'Non gardar',
        'PreferencesTooltip' => 'Aplicar as súas configuracións',
        'ViewTooltip' => 'Cambiar o tipo de visualización',
        'PlayTooltip' => 'Reproducir un video asociado ao elemento', # Accepts model codes
        'PlayFileNotFound' => 'File to launch was not found in this location:',
        'PlayRetry' => 'Retry',

        'StatusSave' => 'Gardando...',
        'StatusLoad' => 'Cargando...',
        'StatusSearch' => 'Procurando...',
        'StatusGetInfo' => 'Obtendo información...',
        'StatusGetImage' => 'Obtendo a imaxe...',
                
        'SaveError' => 'Non se pode gardar a listaxe. Comprobe os permisos de acceso e se hai suficiente espazo libre en disco..',
        'OpenError' => 'Non se pode abrir a listaxe. Comprobe os permisos de acceso.',
		'OpenFormatError' => 'Non se pode abrir a listaxe. Pode que o formato sexa incorrecto.',
        'OpenVersionWarning' => 'Collection was created with a more recent version of GCstar. If you save it, you may loose some data.',
        'OpenVersionQuestion' => 'Do you still want to continue?',
        'ImageError' => 'O directorio seleccionado para gardar as imaxes non é correcto. Seleccione outro..',
        'OptionsCreationError'=> 'Non se pode crear o ficheiro de opcións: ',
        'OptionsOpenError'=> 'Non se pode abrir o ficheiro de opcións: ',
        'OptionsSaveError'=> 'Non se pode gardar o ficheiro de opcións: ',
        'ErrorModelNotFound' => 'Model not found: ',
        'ErrorModelUserDir' => 'User defined models are in: ',
        
        'RandomTooltip' => 'Que pode ver esta noite ?',
        'RandomError'=> 'Non pode seleccionar ningún elemento', # Accepts model codes
        'RandomEnd'=> 'Non hai máis elementos', # Accepts model codes
        'RandomNextTip'=> 'Seguinte suxerencia',
        'RandomOkTip'=> 'Aceptar este elemento',
        
        'AboutTitle' => 'Acerca de GCstar',
        'AboutDesc' => 'Xestor Persoal de coleccións',
        'AboutVersion' => 'Versión',
        'AboutTeam' => 'Equipo',
        'AboutWho' => 'Christian Jodar (Tian): Gestión do proxecto, Programador
Nyall Dawson (Zombiepig): Programador
TPF: Programador
Adolfo González: Programador
',
        'AboutLicense' => 'Distribuido baixo os termos de GNU GPL
Logos Copyright le Spektre',
        'AboutTranslation' => 'Traducción ao Galego por Daniel Espiñeira',
        'AboutDesign' => 'Łukasz Kowalczk (Qoolman): Skin Designer
Logo e deseño web por le Spektre',

        'ToolbarRandom' => 'Esta noite',

        'UnsavedCollection' => 'Unsaved Collection',
        'ModelsSelect' => 'Seleccionar un tipo de colección',
        'ModelsPersonal' => 'Modelos persoais',
        'ModelsDefault' => 'Modelos predeterminados',
        'ModelsList' => 'Definición da colección',
        'ModelSettings' => 'Preferencias da colección',
        'ModelNewType' => 'Novo tipo de colección',
        'ModelName' => 'Nome do tipo de colección:',
		'ModelFields' => 'Campos',
		'ModelOptions'	=> 'Opcións',
		'ModelFilters'	=> 'Filtros',
        'ModelNewField' => 'Novo campo',
        'ModelFieldInformation' => 'Información',
        'ModelFieldName' => 'Etiqueta:',
        'ModelFieldType' => 'Tipo:',
        'ModelFieldGroup' => 'Grupo:',
        'ModelFieldValues' => 'Valores',
        'ModelFieldInit' => 'Predeterminado:',
        'ModelFieldMin' => 'Mínimo:',
        'ModelFieldMax' => 'Máximo:',
        'ModelFieldList' => 'Listaxe de valores:',
        'ModelFieldListLegend' => '<i>Separado por comas</i>',
        'ModelFieldDisplayAs' => 'Display as:',
        'ModelFieldDisplayAsText' => 'Text',
        'ModelFieldDisplayAsGraphical' => 'Rating Control',
        'ModelFieldTypeShortText' => 'Texto curto',
        'ModelFieldTypeLongText' => 'Texto longo',
        'ModelFieldTypeYesNo' => 'Si/Non',
        'ModelFieldTypeNumber' => 'Número',
        'ModelFieldTypeDate' => 'Data',
        'ModelFieldTypeOptions' => 'Listaxe de valores predefinidos',
        'ModelFieldTypeImage' => 'Imaxe',
        'ModelFieldTypeSingleList' => 'Listaxe simple',
        'ModelFieldTypeFile' => 'Campo',
        'ModelFieldTypeFormatted' => 'Dependente doutros campos',
        'ModelFieldParameters' => 'Parámetros',
        'ModelFieldHasHistory' => 'Usar un historial',
        'ModelFieldFlat' => 'Amosar nunha sóa liña',
        'ModelFieldStep' => 'Paso incremental:',
        'ModelFieldFileFormat' => 'Formato do ficheiro:',
        'ModelFieldFileFile' => 'Ficheiro simple',
        'ModelFieldFileImage' => 'Imaxe',
        'ModelFieldFileVideo' => 'Video',
        'ModelFieldFileAudio' => 'Audio',
        'ModelFieldFileProgram' => 'Programa',
        'ModelFieldFileUrl' => 'URL',
        'ModelFieldFileEbook' => 'Ebook',
        'ModelOptionsFields' => 'Usar campos',
        'ModelOptionsFieldsAuto' => 'Automático',
        'ModelOptionsFieldsNone' => 'Ningún',
        'ModelOptionsFieldsTitle' => 'Como título',
        'ModelOptionsFieldsId' => 'Como identificador',
        'ModelOptionsFieldsCover' => 'Como cuberta',
        'ModelOptionsFieldsPlay' => 'Para botón Play',
        'ModelCollectionSettings' => 'Preferencias da colección',
        'ModelCollectionSettingsLending' => 'Os elementos pódense prestar',
        'ModelCollectionSettingsTagging' => 'Os elementos pódense etiquetar',
        'ModelFilterActivated' => 'Debería ser nunha caixa de procura',
        'ModelFilterComparison' => 'Comparación',
        'ModelFilterContain' => 'Contén',
        'ModelFilterDoesNotContain' => 'Does not contain',
        'ModelFilterRegexp' => 'Regular expression',
        'ModelFilterRange' => 'Rango',
        'ModelFilterNumeric' => 'Comparación numérica',
        'ModelFilterQuick' => 'Crear un filtro rápido',
        'ModelTooltipName' => 'Utilice un nome para reutilizar este modelo para outras coleccións. Se o deixa baleiro, as preferencias gardaranse directamente na propia colección.',
        'ModelTooltipLabel' => 'O nome do campo tal e como será amosado',
        'ModelTooltipGroup' => 'Usado para agrupar campos. Os elementos sen valor aquí estarán en un grupo predeterminado',
        'ModelTooltipHistory' => 'Deben gardarse os valores introducidos nunha lista asociada ao campo?',
        'ModelTooltipFormat' => 'Este formato úsase para determinar a acción que ten o botón Play ao abrir o ficheiro',
        'ModelTooltipLending' => 'Isto engadirá algúns campos para manexar os préstamos',
        'ModelTooltipTagging' => 'Isto engadirá algúns campos para manexar as etiquetas',
        'ModelTooltipNumeric' => 'Deben considerarse os valores como número na comparación?',
        'ModelTooltipQuick' => 'Isto engadirá un submenú no menú de Filtros',
        
        'ResultsTitle' => 'Seleccionar un elemento', # Accepts model codes
        'ResultsNextTip' => 'Procurarr na seguinte Web',
        'ResultsPreview' => 'Previsualizar',
        'ResultsInfo' => 'Pode engadir varios elementos á colección seleccionandoos mentres preme Ctrl ou Shift', # Accepts model codes
        
        'OptionsTitle' => 'Preferencias',
		'OptionsExpertMode' => 'Expert Mode',
        'OptionsPrograms' => 'Specify applications to use for different media, leave blank to use system defaults',
        'OptionsBrowser' => 'Navegador Web',
        'OptionsPlayer' => 'Reprodutor de Video',
        'OptionsAudio' => 'Reprodutor de Audio',
        'OptionsImageEditor' => 'Image editor',
        'OptionsCdDevice' => 'CD device',
        'OptionsImages' => 'Directorio de Imaxes',
        'OptionsUseRelativePaths' => 'Utilizar rutas relativas para as imaxes',
        'OptionsLayout' => 'Disposición',
        'OptionsStatus' => 'Amosar barra de estado',
        'OptionsUseStars' => 'Use stars to display ratings',
        'OptionsWarning' => 'Atención: Os cambios nesta pestana non terán efecto até que reinicie a aplicación.',
        'OptionsRemoveConfirm' => 'Pedir confirmación antes de eliminar un elemento',
        'OptionsAutoSave' => 'Gardar automáticamente a colección',
        'OptionsAutoLoad' => 'Cargar a colección anterior ao inicio',
        'OptionsSplash' => 'Amosar pantalla de inicio',
        'OptionsTearoffMenus' => 'Enable tear-off menus',
        'OptionsSpellCheck' => 'Utilizar corrector ortográfico para os campos de texto longos',
        'OptionsProgramTitle' => 'Seleccione que programa se utilizará',
		'OptionsPlugins' => 'Sitio web do que recuperar os datos',
		'OptionsAskPlugins' => 'Preguntar (Todos os sitios web)',
		'OptionsPluginsMulti' => 'Algúns sitios',
		'OptionsPluginsMultiAsk' => 'Preguntar (Algúns sitios web)',
        'OptionsPluginsMultiPerField' => 'Algúns sitios (per field)',
        'OptionsPluginsMultiPerFieldWindowTitle' => 'Many sites per field order selection',
        'OptionsPluginsMultiPerFieldDesc' => 'For each selected field we will return the first non empty information beginning from left',
        'OptionsPluginsMultiPerFieldFirst' => 'First',
        'OptionsPluginsMultiPerFieldLast' => 'Last',
        'OptionsPluginsMultiPerFieldRemove' => 'Remove',
        'OptionsPluginsMultiPerFieldClearSelected' => 'Empty selected field list',
		'OptionsPluginsList' => 'Definir a listaxe',
        'OptionsAskImport' => 'Seleccione os campos para importar',
		'OptionsProxy' => 'Usar un proxy',
		'OptionsCookieJar' => 'Utilizar este ficheiro cookie jar',
        'OptionsLang' => 'Linguaxe',
        'OptionsMain' => 'Principal',
        'OptionsPaths' => 'Rutas',
        'OptionsInternet' => 'Internet',
        'OptionsConveniences' => 'Características',
        'OptionsDisplay' => 'Visualización',
        'OptionsToolbar' => 'Barra de ferramentas',
        'OptionsToolbars' => {0 => 'Ningún', 1 => 'Pequeno', 2 => 'Grande', 3 => 'Predeterminado do Sistema'},
        'OptionsToolbarPosition' => 'Posición',
        'OptionsToolbarPositions' => {0 => 'Arriba', 1 => 'Abaixo', 2 => 'Esquerda', 3 => 'Derecha'},
        'OptionsExpandersMode' => 'Extensores demasiado longos',
        'OptionsExpandersModes' => {'asis' => 'Non facer nada', 'cut' => 'Cortar', 'wrap' => 'Axuste de liña'},
        'OptionsDateFormat' => 'Formato da data',
        'OptionsDateFormatTooltip' => 'O formato é o utilizado por strftime(3). Por defecto é %d/%m/%Y',
        'OptionsView' => 'Listaxe de elementos',
        'OptionsViews' => {0 => 'Texto', 1 => 'Imaxe', 2 => 'Detallado'},
        'OptionsColumns' => 'Columnas',
        'OptionsMailer' => 'Método de envío',
        'OptionsSMTP' => 'Servidor',
        'OptionsFrom' => 'O seu enderezo de correo electrónico',
        'OptionsTransform' => 'Poñer os artigos ao final dos títulos',
        'OptionsArticles' => 'Artigos (Separados por comas)',
        'OptionsSearchStop' => 'Permitir cancelar a procura',
        'OptionsBigPics' => 'Use big pictures when available',
        'OptionsAlwaysOriginal' => 'Utilizar título principal se non está o título orixinal',
        'OptionsRestoreAccelerators' => 'Restaurar aceleradores',
        'OptionsHistory' => 'Tamaño do historial',
        'OptionsClearHistory' => 'Limpar historial',
		'OptionsStyle' => 'Pel',
        'OptionsDontAsk' => 'Non preguntar de novo',
        'OptionsPathProgramsGroup' => 'Aplicacións',
        'OptionsProgramsSystem' => 'Utilizar programas definidos polo sistema',
        'OptionsProgramsUser' => 'Utilizar programas especificados',
        'OptionsProgramsSet' => 'Definir programas',
        'OptionsPathImagesGroup' => 'Imaxes',
        'OptionsInternetDataGroup' => 'Importar datos',
        'OptionsInternetSettingsGroup' => 'Preferencias',
        'OptionsDisplayInformationGroup' => 'Amosar información',
        'OptionsDisplayArticlesGroup' => 'Artigos',
        'OptionsImagesDisplayGroup' => 'Visualización',
        'OptionsImagesStyleGroup' => 'Estilo',
        'OptionsDetailedPreferencesGroup' => 'Preferencias',
        'OptionsFeaturesConveniencesGroup' => 'Conveniencias',
        'OptionsPicturesFormat' => 'Prefixo para utilizar coas imaxes:',
        'OptionsPicturesFormatInternal' => 'gcstar__',
        'OptionsPicturesFormatTitle' => 'Título ou nome do elemento asociado',
        'OptionsPicturesWorkingDir' => '%WORKING_DIR% ou . reemprazarase có directorio da colección (utilizar só ao comezo da ruta)',
        'OptionsPicturesFileBase' => '%FILE_BASE% reemprazarase polo nome do ficheiro da colección sen o sufixo (.gcs)',
        'OptionsPicturesWorkingDirError' => '%WORKING_DIR% debería ser utilizado só ao inicio da ruta para as imaxes',
        'OptionsConfigureMailers' => 'Configurar programas de correo',

        'ImagesOptionsButton' => 'Preferencias',
        'ImagesOptionsTitle' => 'Preferencias para a listaxe de imaxes',
        'ImagesOptionsSelectColor' => 'Seleccionar unha cor',
        'ImagesOptionsUseOverlays' => 'Usar superposición de imaxes',
        'ImagesOptionsBg' => 'Fondo',
        'ImagesOptionsBgPicture' => 'Utilizar unha imaxe de fondo',
        'ImagesOptionsFg'=> 'Selección',
        'ImagesOptionsBgTooltip' => 'Cambiar a cor de fondo',
        'ImagesOptionsFgTooltip'=> 'Cambiar a selección de cor',
        'ImagesOptionsResizeImgList' => 'Automatically change number of columns',
        'ImagesOptionsAnimateImgList' => 'Use animations',
        'ImagesOptionsSizeLabel' => 'Tamaño',
        'ImagesOptionsSizeList' => {0 => 'Moi pequeno', 1 => 'Pequeno', 2 => 'Medio', 3 => 'Grande', 4 => 'Moi grande'},
        'ImagesOptionsSizeTooltip' => 'Seleccionar o tamaño da imaxe',
		        
        'DetailedOptionsTitle' => 'Preferencias para a listaxe detallada',
        'DetailedOptionsImageSize' => 'Tamaño das imaxes',
        'DetailedOptionsGroupItems' => 'Agrupar elementos por',
        'DetailedOptionsSecondarySort' => 'Ordenar campos segundo descendencia',
		'DetailedOptionsFields' => 'Seleccionar campos a amosar',
        'DetailedOptionsGroupedFirst' => 'Manter xuntos elementos orfos',
        'DetailedOptionsAddCount' => 'Engadir número de elementos ás categorías',

        'ExtractButton' => 'Información',
        'ExtractTitle' => 'Información do ficheiro',
        'ExtractImport' => 'Utilizar valores',

        'FieldsListOpen' => 'Cargar unha listaxe de ficheiros desde un ficheiro',
        'FieldsListSave' => 'Gardar listaxe de cmapos a un ficheiro',
        'FieldsListError' => 'Esta listaxe de ficheiros non pode utilizase con este tipo de colección',
        'FieldsListIgnore' => '--- Ignorar',

        'ExportTitle' => 'Exportar listaxe de elementos',
        'ExportFilter' => 'Exportar só os elementos amosados',
        'ExportFieldsTitle' => 'Ficheiros a exportar',
        'ExportFieldsTip' => 'Seleccione os ficheiros que quere exportar',
        'ExportWithPictures' => 'Copiar imaxes nun sub-directorio',
        'ExportSortBy' => 'Ordear por',
        'ExportOrder' => 'Order',

        'ImportListTitle' => 'Importar outra listaxe de elementos',
        'ImportExportData' => 'Datos',
        'ImportExportFile' => 'Ficheiro',
        'ImportExportFieldsUnused' => 'Campos sen utilizar',
        'ImportExportFieldsUsed' => 'Campos utilizados',
        'ImportExportFieldsFill' => 'Engadir todo',
        'ImportExportFieldsClear' => 'Eliminar todos',
        'ImportExportFieldsEmpty' => 'Ten que escolles polo menos un campo',
        'ImportExportFileEmpty' => 'Ten que especificar un nome de campo',
        'ImportFieldsTitle' => 'Campos a importar',
        'ImportFieldsTip' => 'Seleccione os campos que quere importar',
        'ImportNewList' => 'Crear unha nova colección',
        'ImportCurrentList' => 'Engadir á colección actual',
        'ImportDropError' => 'Houbo un erro abrindo algúns dos ficheiros. Cargarase a listaxe anterior.',
        'ImportGenerateId' => 'Xerar identificador para cada elemento',

        'FileChooserOpenFile' => 'Selecione o ficheiro',
        'FileChooserDirectory' => 'Directory',
        'FileChooserOpenDirectory' => 'Seleccione un directorio',
        'FileChooserOverwrite' => 'Este ficheiro xa existe. Quere sobreescribilo?',
        'FileAllFiles' => 'All Files',
        'FileVideoFiles' => 'Video Files',
        'FileEbookFiles' => 'Ebook Files',
        'FileAudioFiles' => 'Audio Files',
        'FileGCstarFiles' => 'GCstar Collections',

        #Some default panels
        'PanelCompact' => 'Compacto',
        'PanelReadOnly' => 'Só Lectura',
        'PanelForm' => 'Pestanas',

        'PanelSearchButton' => 'Buscar información',
        'PanelSearchTip' => 'Buscar na web información sobre este nome',
        'PanelSearchContextChooseOne' => 'Choose a site ...',
        'PanelSearchContextMultiSite' => 'Use "Many sites"',
        'PanelSearchContextMultiSitePerField' => 'Use "Many sites per field"',
        'PanelSearchContextOptions' => 'Change options ...',
        'PanelImageTipOpen' => 'Preme na imaxe para seleccionar unha diferente.',
        'PanelImageTipView' => 'Preme na imaxe para vela no seu tamaño real.',
        'PanelImageTipMenu' => ' Botón dereito para máis opcións.',
        'PanelImageTitle' => 'Seleccione una imaxe',
        'PanelImageNoImage' => 'Sen imaxe',
        'PanelSelectFileTitle' => 'Seleccione un ficheiro',
        'PanelLaunch' => 'Launch',        
        'PanelRestoreDefault' => 'Restaurar predeterminado',
        'PanelRefresh' => 'Update',
        'PanelRefreshTip' => 'Update information from web',

        'PanelFrom' =>'Desde',
        'PanelTo' =>'A',

        'PanelWeb' => 'Ver información',
        'PanelWebTip' => 'Ver información na web acerca deste elemento', # Accepts model codes
        'PanelRemoveTip' => 'Eliminar elemento actual', # Accepts model codes

        'PanelDateSelect' => 'Seleccionar',
        'PanelNobody' => 'Ninguén',
        'PanelUnknown' => 'Descoñecido',
        'PanelAdded' => 'Engadir data',
        'PanelRating' => 'Puntuación',
        'PanelPressRating' => 'Press Rating',
        'PanelLocation' => 'Localidade',

        'PanelLending' => 'Prestamo',
        'PanelBorrower' => 'Prestatario',
        'PanelLendDate' => 'Fora desde',
        'PanelHistory' => 'Historial de préstamo',
        'PanelReturned' => 'Elemento devolto', # Accepts model codes
        'PanelReturnDate' => 'Data de devolución',
        'PanelLendedYes' => 'Prestado',
        'PanelLendedNo' => 'Dispoñible',

        'PanelTags' => 'Etiquetas',
        'PanelFavourite' => 'Favorito',
        'TagsAssigned' => 'Etiquetas asignadas', 

        'PanelUser' => 'User fields',

        'CheckUndef' => 'Calquera',
        'CheckYes' => 'Si',
        'CheckNo' => 'Non',

        'ToolbarAll' => 'Ver todo',
        'ToolbarAllTooltip' => 'Ver todos os elementos',
        'ToolbarGroupBy' => 'Agrupar por',
        'ToolbarGroupByTooltip' => 'Seleccionar o campo para agrupar os elementos da lista',
        'ToolbarQuickSearch' => 'Quick search',
        'ToolbarQuickSearchLabel' => 'Search',
        'ToolbarQuickSearchTooltip' => 'Select the field to search in. Enter the search terms and press Enter',
        'ToolbarSeparator' => ' Separator',
        
        'PluginsTitle' => 'Procurar un elemento',
        'PluginsQuery' => 'Procura',
        'PluginsFrame' => 'Sitio Web de búsqueda',
        'PluginsLogo' => 'Logo',
        'PluginsName' => 'Nome',
        'PluginsSearchFields' => 'Campos de búsqueda',
        'PluginsAuthor' => 'Autor',
        'PluginsLang' => 'Linguaxe',
        'PluginsUseSite' => 'Utilizar sitio web seleccionado para outras procuras no futuro',
        'PluginsPreferredTooltip' => 'Site recommended by GCstar',
        'PluginDisabled' => 'Disabled',

        'BorrowersTitle' => 'Configuración do prestatario',
        'BorrowersList' => 'Prestatarios',
        'BorrowersName' => 'Nome',
        'BorrowersEmail' => 'e-mail',
        'BorrowersAdd' => 'Engadir',
        'BorrowersRemove' => 'Eliminar',
        'BorrowersEdit' => 'Editar',
        'BorrowersTemplate' => 'Plantilla de correo',
        'BorrowersSubject' => 'Asunto do correo',
        'BorrowersNotice1' => '%1 reemprazarase có nome do prestatario/a',
        'BorrowersNotice2' => '%2 reemprazarase có título do elemento',
        'BorrowersNotice3' => '%3 reemprazarase coa data do préstamo',

        'BorrowersImportTitle' => 'Importar información dos prestatarios',
        'BorrowersImportType' => 'Formato do ficheiro:',
        'BorrowersImportFile' => 'Ficheiro:',

        'BorrowedTitle' => 'Elementos prestados', # Accepts model codes
        'BorrowedDate' => 'Desde',
        'BorrowedDisplayInPanel' => 'Show item in main window', # Accepts model codes

        'MailTitle' => 'Enviar un correo electrónico',
        'MailFrom' => 'Desde: ',
        'MailTo' => 'A: ',
        'MailSubject' => 'Asunto: ',
        'MailSmtpError' => 'Houbo un problema conectando có servidor SMTP',
        'MailSendmailError' => 'Houbo un problema ao lanzar sendmail',

        'SearchTooltip' => 'Procurar todos os elementos', # Accepts model codes
        'SearchTitle' => 'Procura de elementos', # Accepts model codes
        'SearchNoField' => 'No field have been selected for the search box.
Add some of them in the Filters tab of the collection settings.',

        'QueryReplaceField' => 'Campo a reemprazar',
        'QueryReplaceOld' => 'Valor actual',
        'QueryReplaceNew' => 'Novo valor',
        'QueryReplaceLaunch' => 'Reemprazar',
        
        'ImportWindowTitle' => 'Seleccione os campos para importar',
        'ImportViewPicture' => 'Ver imaxe',
        'ImportSelectAll' => 'Seleccionar todo',
        'ImportSelectNone' => 'Non seleccionar ningún',

        'MultiSiteTitle' => 'Sitios web para as procuras',
        'MultiSiteUnused' => 'Complementos sen usar',
        'MultiSiteUsed' => 'Complementos para usar',
        'MultiSiteLang' => 'Encher a listaxe con plugins en galego',
        'MultiSiteEmptyError' => 'Ten una listaxe de sitios baleira',
        'MultiSiteClear' => 'Limpar listaxe',
        
        'DisplayOptionsTitle' => 'Elementos para amosar',
        'DisplayOptionsAll' => 'Seleccionar todos',
        'DisplayOptionsSearch' => 'Botón de procura',

        'GenresTitle' => 'Conversión de xénero',
        'GenresCategoryName' => 'Xénero a utilizar',
        'GenresCategoryMembers' => 'Xérnero para reemprazar',
        'GenresLoad' => 'Cargar unha listaxe',
        'GenresExport' => 'Gardar listaxe a un ficheiro',
        'GenresModify' => 'Editar conversión',

        'PropertiesName' => 'Nome da colección',
        'PropertiesLang' => 'Language code',
        'PropertiesOwner' => 'Propietario/a',
        'PropertiesEmail' => 'Correo electrónico',
        'PropertiesDescription' => 'Descripción',
        'PropertiesFile' => 'Información de ficheiro',
        'PropertiesFilePath' => 'Ruta completa',
        'PropertiesItemsNumber' => 'Número de elementos', # Accepts model codes
        'PropertiesFileSize' => 'Tamaño',
        'PropertiesFileSizeSymbols' => ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
        'PropertiesCollection' => 'Propiedades da colección',
        'PropertiesDefaultPicture' => 'Default picture',

        'MailProgramsTitle' => 'Programas de envío de correo',
        'MailProgramsName' => 'Nome',
        'MailProgramsCommand' => 'Liña de comandos',
        'MailProgramsRestore' => 'Restaurar valores predeterminados',
        'MailProgramsAdd' => 'Engadir un programa',
        'MailProgramsInstructions' => 'Na liña de comandos, fanse algunhas substitucións:
 %f reemprázase có enderezo de correo electrónico do/a usuario/a.
 %t reemprázase có enderezo do destinatario/a.
 %s reemprázase có asunto da mensaxe.
 %b reemprázase có corpo da mensaxe.',

        'BookmarksBookmarks' => 'Favoritos',
        'BookmarksFolder' => 'Cartafois',
        'BookmarksLabel' => 'Etiqueta',
        'BookmarksPath' => 'Ruta',
        'BookmarksNewFolder' => 'Novo cartafol',

        'AdvancedSearchType' => 'Tipo de procura',
        'AdvancedSearchTypeAnd' => 'Elementos que cumpren todos os criterios de procura', # Accepts model codes
        'AdvancedSearchTypeOr' => 'Elementos que cumpren polo menos un criterio', # Accepts model codes
        'AdvancedSearchCriteria' => 'Criterios',
        'AdvancedSearchAnyField' => 'Calquer campo',
        'AdvancedSearchSaveTitle' => 'Save search',
        'AdvancedSearchSaveName' => 'Name',
        'AdvancedSearchSaveOverwrite' => 'A saved search already exists with that name. Please use a different one.',
        'AdvancedSearchUseCase' => 'Case sensitive',
        'AdvancedSearchIgnoreDiacritics' => 'Ignore accents and other diacritics',
 
        'BugReportSubject' => 'Reporte de erro xerado por GCstar',
        'BugReportVersion' => 'Versión',
        'BugReportPlatform' => 'Sistema Operativo',
        'BugReportMessage' => 'Mensaxe de erro',
        'BugReportInformation' => 'Información adicional',

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
