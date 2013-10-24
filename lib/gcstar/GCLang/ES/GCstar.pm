{
    package GCLang::ES;
    
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

        'LangName' => 'Español',
        
        'Separator' => ' : ',

        'Warning' => '<b>Aviso</b> :

La información descargada desde Internet (gracias a
los plugins de búsqueda) es sólo para <b>uso personal</b>

Cualquier redistribución queda prohibida <b> sin la
explícita autorización de las respectivas webs</b>.

Para saber cual es la web a la que pertenece la información,
puede usar <b>el botón situado debajo de los detalles de la película</b>.',

        'AllItemsFiltered' => 'Ninguna {lowercaseX} cumple con los criterios de filtrado', # Accepts model codes

#Installation
        'InstallDirInfo' => 'Instalar en ',
        'InstallMandatory' => 'Componentes obligatorios',
        'InstallOptional' => 'Componentes opcionales',
        'InstallErrorMissing' => 'Error: los componentes siguientes deben instalarse: ',
        'InstallPrompt' => 'Directorio predeterminado para la instalación [/usr/local]: ',
        'InstallEnd' => 'Fin de la instalación',	
        'InstallNoError' => 'Ningún error',
        'InstallLaunch' => 'Para utilizar la aplicación, ejecute ',
        'InstallDirectory' => 'Repertorio básico',
        'InstallTitle' => 'Instalación de GCstar',
        'InstallDependencies' => 'Dependencias',	
        'InstallPath' => 'Ruta',
        'InstallOptions' => 'Opciones',
        'InstallSelectDirectory' => 'Elija el directorio para la instalación',   
        'InstallWithClean' => 'Eliminar archivos del directorio de instalación.',
       	'InstallWithMenu' => 'Añadir GCstar al menu de Aplicaciones',
       	'InstallNoPermission' => 'Error : No tiene permisos para instalar en el directorio seleccionado!!',
        'InstallMissingMandatory' => 'Algunas dependencias obligatorias no están disponibles. No podrá instalar GCstar hasta que se instalen en el sistema.',
        'InstallMissingOptional' => 'Algunas depencias opcionales no están disponibles. Se detallan debajo. GCstar se instalará con algunas funciones deshabilitadas.',
        'InstallMissingNone' => 'Dependencias satisfechas. Puede continuar e instalar GCstar.',
        'InstallOK' => 'OK',
        'InstallMissing' => 'No disponible',
        'InstallMissingFor' => 'No disponible por',
        'InstallCleanDirectory' => 'Eliminado ficheros de GCstar en el diretorio: ',
        'InstallCopyDirectory' => 'Copiando ficheros en el directorio: ',
        'InstallCopyDesktop' => 'Copiando el fichero .desktop en: ',
        
#Update
        'UpdateUseProxy' => 'Proxy a usar (si no usa ninguno presione Enter): ',
        'UpdateNoPermission' => 'Permiso de escritura denegado en este directorio: ',
        'UpdateNone' => 'No se ha encontrado ninguna actualización',
        'UpdateFileNotFound' => 'Fichero no encontrado',

#Splash
        'SplashInit' => 'Inicialización',
        'SplashLoad' => 'Cargando películas',
        'SplashDisplay' => 'Mostrando Colección',
        'SplashSort' => 'Sorting Collection',
        'SplashDone' => 'Listo',

#Import from GCfilms
        'GCfilmsImportQuestion' => 'Parece que antes usaba GCfilms. ¿Qué quiere importar desde GCfilms a GCstar? (No afectará a GCfilms, si todavía quiere seguir usándolo)',
        'GCfilmsImportOptions' => 'Preferencias',
        'GCfilmsImportData' => 'Listado de películas',

#Menus
        'MenuFile' => '_Archivo',	
            'MenuNewList' => '_Nueva lista de películas',	
            'MenuStats' => 'Statistics',
            'MenuHistory' => '_Ficheros abiertos recientemente',
            'MenuLend' => '_Ver {lowercaseX} prestadas', # Accepts model codes
            'MenuImport' => '_Importar',
            'MenuExport' => '_Exportar',	
            'MenuAddItem' => '_Add {lowercase1}', # Accepts model codes

        'MenuEdit'  => '_Editar',
            'MenuDuplicate' => '_Duplicar {lowercase1}', # Accepts model codes
            'MenuDuplicatePlural' => '_Duplicar {lowercaseX}', # Accepts model codes
            'MenuEditSelectAllItems' => 'Select _all {lowercaseX}', # Accepts model codes
            'MenuEditDeleteCurrent' => '_Eliminar {lowercase1} actual',, # Accepts model codes
            'MenuEditDeleteCurrentPlural' => '_Eliminar {lowercaseX} actual', # Accepts model codes
            'MenuEditFields' => '_Cambiar campos de la colección',
            'MenuEditLockItems' => '_Bloquear la información',
        
        'MenuDisplay' => '_Visualización',        
            'MenuSavedSearches' => 'Búsquedas guardadas',
                'MenuSavedSearchesSave' => 'Guardar búsqueda actual',
                'MenuSavedSearchesEdit' => 'Modificar búsquedas guardadas',
            'MenuAdvancedSearch' => 'Búsqueda _avanzada',
            'MenuViewAllItems' => '_Ver todas {lowercasePX}', # Accepts model codes	
            'MenuNoFilter' => '_Todas las películas',	

        'MenuConfiguration' => '_Configuración',	
            'MenuDisplayMenu' => 'Display',
                'MenuDisplayFullScreen' => 'Full screen',
                'MenuDisplayMenuBar' => 'Menus',
                'MenuDisplayToolBar' => 'Toolbar',
                'MenuDisplayStatusBar' => 'Bottom bar',
            'MenuDisplayOptions' => '_Información a mostrar',
            'MenuBorrowers' => 'Pres_tatarios',	
            'MenuToolbarConfiguration' => 'Controles de la barra de _herramientas',
            'MenuDefaultValues' => 'Default values for new item', # Accepts model codes
            'MenuGenresConversion' => 'Conversión de _géneros',

        'MenuBookmarks' => 'Mis _Colecciones',
            'MenuBookmarksAdd' => '_Añadir colección actual',
            'MenuBookmarksEdit' => '_Editar colecciones favoritas',

        'MenuHelp' => '_?',
            'MenuHelpContent' => '_?',
            'MenuAllPlugins' => 'Ver _complementos',
            'MenuBugReport' => 'Comunicar un _fallo',
            'MenuAbout' => 'A propósito de _GCstar',	

        'MenuNewWindow' => 'Mostrar {lowercase1} en una nueva ventana', # Accepts model codes
        'MenuNewWindowPlural' => 'Mostrar {lowercaseX} en una nueva ventana', # Accepts model codes
        
        'ContextExpandAll' => 'Expandir todo',
        'ContextCollapseAll' => 'Contraer todo',
        'ContextChooseImage' => 'Elegir _Imagen',
        'ContextOpenWith' => 'Abrir _Con',
        'ContextImageEditor' => 'Editor de Imágenes',  
        'ContextImgFront' => 'Frontal',
        'ContextImgBack' => 'Trasera',
        'ContextChooseFile' => 'Choose a File',
        'ContextChooseFolder' => 'Choose a Folder',

        'DialogEnterNumber' => 'Introduzca un valor por favor',

        'RemoveConfirm' => '¿Realmente quiere eliminar {lowercaseE1}?', # Accepts model codes 
        'RemoveConfirmPlural' => '¿Realmente quiere eliminar {lowercaseEX}?', # Accepts model codes

        'DefaultNewItem' => 'Elemento nuevo',
        'NewItemTooltip' => 'Añadir una nueva película',
        'NoItemFound' => 'Ninguna película encontrada. ¿Quiere intentar una nueva búsqueda en otro sitio?',
        'OpenList' => '¿Qué lista de películas abrir?',	
        'SaveList' => '¿En qué fichero quiere guardar el listado?',	
        'SaveListTooltip' => 'Guardar el listado actual', 
        'SaveUnsavedChanges' => 'Hay cambios sin guardar en su colección. ¿Quiere guardarlos?',
        'SaveDontSave' => 'No guardar',
        'PreferencesTooltip' => 'Cambiar sus preferencias',
        'ViewTooltip' => 'Cambiar el tipo de lista',
        'PlayTooltip' => 'Reproducir archivo de video asociado {lowercaseAP1}', # Accepts model codes
        'PlayFileNotFound' => 'No se encontró el fichero a reproducir:',
        'PlayRetry' => 'Reintentar',
        
        'StatusSave' => 'Guardando...',
        'StatusLoad' => 'Cargando...',
        'StatusSearch' => 'Búsqueda en curso...',
        'StatusGetInfo' => 'Descargando la información...',
        'StatusGetImage' => 'Descarga a distancia de la imagen...',	
        
        'SaveError' => 'Imposible guardar la lista de películas. Compruebe los permisos y el espacio disponible en el disco.',
        'OpenError' => 'Imposible abrir la lista de películas. Compruebe los permisos.',
        'OpenFormatError' => 'Imposible abrir la lista de películas.',
        'OpenVersionWarning' => 'La colección se creó con una versión mñas erciente de GCstar. Si la guarda, podría perder datos.',
        'OpenVersionQuestion' => '¿Todavía quiere continuar?',
        'ImageError' => 'El repertorio elegido para salvar las imágenes no es correcto.¿Quiere elegir otro?',
        'OptionsCreationError'=> 'Imposible crear el fichero de opciones : ',
        'OptionsOpenError'=> 'Imposible abrir el fichero de opciones : ',
        'OptionsSaveError'=> 'Imposible guardar el fichero de opciones',
        'ErrorModelNotFound' => 'Modelo no encontrado: ',
        'ErrorModelUserDir' => 'Los modelos definidos por el usuario están en: ',

        'RandomTooltip' => '¿Qué quieres ver esta noche?',
        'RandomError'=> 'No quedan {lowercaseX} sin ver', # Accepts model codes
        'RandomEnd'=> 'No hay mas {lowercaseX}', # Accepts model codes
        'RandomNextTip'=> 'Siguiente sugerencia',
        'RandomOkTip'=> 'Aceptar {lowercaseE1}',
                        
        'AboutTitle' => 'A propósito de GCstar',
        'AboutDesc' => 'Gestión de Colecciones',
        'AboutVersion' => 'Versión',
        'AboutTeam' => 'Equipo',
        'AboutWho' => 'Christian Jodar (Tian) : Gestión del proyecto, Programación
Nyall Dawson (Zombiepig) : Programación
TPF : Programación
Adolfo González Blázquez : Programación
',
        'AboutLicense' => 'Distribuido según los términos de la GNU GPL
Logos Copyright le Spektre',
        'AboutTranslation' => 'Traducción : Adolfo González Blázquez',
        'AboutDesign' => 'Łukasz Kowalczk (Qoolman): Skin Designer
Logo y diseño web por le Spektre',
        
        'ToolbarRandom' => 'Esta noche',

        'UnsavedCollection' => 'Colección no guardada',
        'ModelsSelect' => 'Seleccionar un tipo de colección',
        'ModelsPersonal' => 'Modelos personales',
        'ModelsDefault' => 'Modelos predefinidos',
        'ModelsList' => 'Definición de la colección',
        'ModelSettings' => 'Preferencias de la colección',
        'ModelNewType' => 'Nuevo tipo de colección',
        'ModelName' => 'Nombre del tipo de colección:',
		'ModelFields' => 'Fields',
		'ModelOptions'	=> 'Options',
		'ModelFilters'	=> 'Filters',
        'ModelNewField' => 'Nuevo campo',
        'ModelFieldInformation' => 'Información',
        'ModelFieldName' => 'Etiqueta:',
        'ModelFieldType' => 'Tipo:',
        'ModelFieldGroup' => 'Grupo:',
        'ModelFieldValues' => 'Valores',
        'ModelFieldInit' => 'Predeterminado:',
        'ModelFieldMin' => 'Mínimo:',
        'ModelFieldMax' => 'Máximo:',
        'ModelFieldList' => 'Lista de valores:',
        'ModelFieldListLegend' => '<i>Separados por comas</i>',
        'ModelFieldDisplayAs' => 'Mostrar como:',
        'ModelFieldDisplayAsText' => 'Texto',
        'ModelFieldDisplayAsGraphical' => 'Rating Control',
        'ModelFieldTypeShortText' => 'Texto corto',
        'ModelFieldTypeLongText' => 'Texto largo',
        'ModelFieldTypeYesNo' => 'Si/No',
        'ModelFieldTypeNumber' => 'Número',
        'ModelFieldTypeDate' => 'Fecha',
        'ModelFieldTypeOptions' => 'Lista de valores prefedinidos',
        'ModelFieldTypeImage' => 'Imagen',
        'ModelFieldTypeSingleList' => 'Lista simple',
        'ModelFieldTypeFile' => 'Fichero',
        'ModelFieldTypeFormatted' => 'Dependant on other fields',
        'ModelFieldParameters' => 'Parámetros',
        'ModelFieldHasHistory' => 'Usar historial',
        'ModelFieldFlat' => 'Mostrar en una línea',
        'ModelFieldStep' => 'Paso de incremento:',
        'ModelFieldFileFormat' => 'Formato de fichero:',
        'ModelFieldFileFile' => 'Fichero simple',
        'ModelFieldFileImage' => 'Imagen',
        'ModelFieldFileVideo' => 'Video',
        'ModelFieldFileAudio' => 'Audio',
        'ModelFieldFileProgram' => 'Programa',
        'ModelFieldFileUrl' => 'URL',
        'ModelFieldFileEbook' => 'Ebook',
        'ModelOptionsFields' => 'Campos a usar',
        'ModelOptionsFieldsAuto' => 'Automático',
        'ModelOptionsFieldsNone' => 'Ninguno',
        'ModelOptionsFieldsTitle' => 'Como título',
        'ModelOptionsFieldsId' => 'Como identificador',
        'ModelOptionsFieldsCover' => 'Como portada',
        'ModelOptionsFieldsPlay' => 'Como botón de Reproducir',
        'ModelCollectionSettings' => 'Preferencias de la colección',
        'ModelCollectionSettingsLending' => 'Los elementos se pueden prestar',
        'ModelCollectionSettingsTagging' => 'Los elementos se pueden etiquetar',
        'ModelFilterActivated' => 'Debe aparecer en la caja de búsqueda',
        'ModelFilterComparison' => 'Comparación',
        'ModelFilterContain' => 'Contiene',
        'ModelFilterDoesNotContain' => 'No contiene',
        'ModelFilterRegexp' => 'Expresión regular',
        'ModelFilterRange' => 'Rango',
        'ModelFilterNumeric' => 'Comparación numérica',
        'ModelFilterQuick' => 'Crear un filtro rápido',
        'ModelTooltipName' => 'Usar un nombre para reutilizar este modelo para otras colecciones. Si lo deja vacío, las preferencias se guardatán en la propia colección',
        'ModelTooltipLabel' => 'El nombre del campo como será mostrado',
        'ModelTooltipGroup' => 'Usado para agrupar los campos. Los elementos sin calor aparecerán en el grupo por defecto',
        'ModelTooltipHistory' => '¿Deberían almacenarse los valores introducidos anteriormente en una lista asociada al campo?',
        'ModelTooltipFormat' => 'El formato se usa para determinar la acción para abrir  el fichero al pulsar el botón de Reproducir',
        'ModelTooltipLending' => 'Se añadirán algunos campos para administrar los préstamos',
        'ModelTooltipTagging' => 'Se añadirán algunos campos para administrar las etiquetas',
        'ModelTooltipNumeric' => '¿Se deberían considerar los valores como números para las comparaciones?',
        'ModelTooltipQuick' => 'Esto añadirá un submenu dentro del menu de Filtros',

        'ResultsTitle' => 'Elija {lowercaseU1}', # Accepts model codes
        'ResultsNextTip' => 'Buscar en el siguiente sitio',
        'ResultsPreview' => 'Previsualizar',
        'ResultsInfo' => 'Puedes añadir varios elementos a la colección presionando Control ó Mayúsculas y seleccionándolos', # Accepts model codes

        'OptionsTitle' => 'Preferencias',
		'OptionsExpertMode' => 'Modo experto',
        'OptionsPrograms' => 'Especifíque que aplicaciones usar para cada tipo de medio, o déjelos en blanco para usar los predeterminados del sistema',
        'OptionsBrowser' => 'Navegador de Internet',
        'OptionsPlayer' => 'Reproductor de video',
        'OptionsAudio' => 'Reproductor de audio',
        'OptionsImageEditor' => 'Editor de imágenes',
        'OptionsCdDevice' => 'Dispositivo de CD',
        'OptionsImages' => 'Directorio de imágenes', 	
        'OptionsUseRelativePaths' => 'Usar rutas relativas para las imágenes',
        'OptionsLayout' => 'Disposición',	
        'OptionsStatus' => 'Barra de estado',	
        'OptionsUseStars' => 'Usar estrellas para mostrar las puntuaciones',
        'OptionsWarning' => 'Cuidado : Los cambios efectuados en este pestaña no se tendrán en cuenta hasta reiniciar la aplicación', 
        'OptionsRemoveConfirm' => 'Pedir confirmación antes de eliminar',
        'OptionsAutoSave' => 'Protección automática de la lista de películas',
        'OptionsAutoLoad' => 'Cargar la colección anterior en el inicio',
        'OptionsSplash' => 'Mostrar la pantalla de arranque',
        'OptionsTearoffMenus' => 'Activar menus desprendibles',
        'OptionsSpellCheck' => 'Usar corrector de ortografía en los campos de texto largos',
        'OptionsProgramTitle' => 'Elija el programa que debe utilizarse',
        'OptionsPlugins' => 'Sitio para descargar las fichas',
        'OptionsAskPlugins' => 'Preguntar',
        'OptionsPluginsMulti' => 'Varios sitios',
        'OptionsPluginsMultiAsk' => 'Preguntar (Algunos sitios)',
        'OptionsPluginsMultiPerField' => 'Varios sitios (per field)',
        'OptionsPluginsMultiPerFieldWindowTitle' => 'Many sites per field order selection',
        'OptionsPluginsMultiPerFieldDesc' => 'For each selected field we will return the first non empty information beginning from left',
        'OptionsPluginsMultiPerFieldFirst' => 'First',
        'OptionsPluginsMultiPerFieldLast' => 'Last',
        'OptionsPluginsMultiPerFieldRemove' => 'Remove',
        'OptionsPluginsMultiPerFieldClearSelected' => 'Empty selected field list',
        'OptionsPluginsList' => 'Definir la lista',
        'OptionsAskImport' => 'Elegir los campos que deben importarse',
        'OptionsProxy' => 'Utilizar un proxy',
		'OptionsCookieJar' => 'Usar este fichero de cookie jar',
        'OptionsMain' => 'Principal',
        'OptionsLang' => 'Idioma',
        'OptionsPaths' => 'Directorios',
        'OptionsInternet' => 'Internet',
        'OptionsConveniences' => 'Opciones',	
        'OptionsDisplay' => 'Visualización',
        'OptionsToolbar' => 'Barra de herramientas',	
        'OptionsToolbars' => {0 => 'Ninguna', 1 => 'Pequeña', 2 => 'Grande', 3 => 'Predeterminado del sistema'},
        'OptionsToolbarPosition' => 'Posición',
        'OptionsToolbarPositions' => {0 => 'Arriba', 1 => 'Abajo', 2 => 'Izquierda', 3 => 'Derecha'},
        'OptionsExpandersMode' => 'Extensores demasiado largos',
        'OptionsExpandersModes' => {'asis' => 'No hacer nada', 'cut' => 'Cortar', 'wrap' => 'Dividir las lineas'},
        'OptionsDateFormat' => 'Formato de fecha',
        'OptionsDateFormatTooltip' => 'El formato usado es el mismo de strftime(3). El predeterminado es %d/%m/%Y',
        'OptionsView' => 'Visualización de las películas',
        'OptionsViews' => {0 => 'Texto', 1 => 'Imagen', 2 => 'Detallada'},
        'OptionsColumns' => 'Columnas',	
        'OptionsMailer' => 'Método de envío de los correos electrónicos',
        'OptionsSMTP' => 'Servidor',	
        'OptionsFrom' => 'Correo electrónico del remitente',	
        'OptionsTransform' => 'Poner al final de los títulos los artículos',	
        'OptionsArticles' => 'Artículos (separados por una coma)',	
        'OptionsSearchStop' => 'El usuario puede parar las búsquedas',
        'OptionsBigPics' => 'Usar imágenes grandes cuando estén disponibles',
        'OptionsAlwaysOriginal' => 'Usar título principal como el original si no se encuentra ninguno',
        'OptionsRestoreAccelerators' => 'Restaurar aceleradores',
        'OptionsHistory' => 'Tamaño del historial',
        'OptionsClearHistory' => 'Limpiar el historial',
        'OptionsStyle' => 'Piel',
        'OptionsDontAsk' => 'No preguntar nunca más',
        'OptionsPathProgramsGroup' => 'Aplicaciones',
        'OptionsProgramsSystem' => 'Usar programas predefinidos del sistema',
        'OptionsProgramsUser' => 'Usar programas definidos por el usuario',
        'OptionsProgramsSet' => 'Establecer programas',
        'OptionsPathImagesGroup' => 'Imágenes',
        'OptionsInternetDataGroup' => 'Importar datos',
        'OptionsInternetSettingsGroup' => 'Preferencias',
        'OptionsDisplayInformationGroup' => 'Mostrar información',
        'OptionsDisplayArticlesGroup' => 'Artículos',
        'OptionsImagesDisplayGroup' => 'Mostrar',
        'OptionsImagesStyleGroup' => 'Estilo',
        'OptionsDetailedPreferencesGroup' => 'Preferencias',
        'OptionsFeaturesConveniencesGroup' => 'conveniencias',
        'OptionsPicturesFormat' => 'Prefijo para usar en las imágenes:',
        'OptionsPicturesFormatInternal' => 'gcstar__',
        'OptionsPicturesFormatTitle' => 'Título o nombre del elemento asociado',
        'OptionsPicturesWorkingDir' => '%WORKING_DIR% o . se reemplazará con el directorio de la colección (usar sólo al principio de la ruta)',
        'OptionsPicturesFileBase' => '%FILE_BASE% se reemplazará por el nombre de la colecciñón si el sufijo (.gcs)',
        'OptionsPicturesWorkingDirError' => '%WORKING_DIR% sólo se puede usar al principio de la ruta para imágenes',
        'OptionsConfigureMailers' => 'Configurar programas de envío correo',
		       
        'ImagesOptionsButton' => 'Preferencias',
        'ImagesOptionsTitle' => 'Preferencias para el listado de imágenes',
        'ImagesOptionsSelectColor' => 'Elija un color',
        'ImagesOptionsUseOverlays' => 'Utilizar superposición de imágenes',
        'ImagesOptionsBg' => 'Fondo',
        'ImagesOptionsBgPicture' => 'Usar una imagen de fondo',
        'ImagesOptionsFg'=> 'Selección',
        'ImagesOptionsBgTooltip' => 'Cambiar el color de fondo',
        'ImagesOptionsFgTooltip'=> 'Cambiar el color de la selección',
        'ImagesOptionsResizeImgList' => 'Cambiar automáticamente el número de columnas',
        'ImagesOptionsAnimateImgList' => 'Use animations',
        'ImagesOptionsSizeLabel' => 'Tamaño',
        'ImagesOptionsSizeList' => {0 => 'Muy Pequeño', 1 => 'Pequeño', 2 => 'Mediano', 3 => 'Grande', 4 => 'Extra Grande'},
        'ImagesOptionsSizeTooltip' => 'Seleccione el tamaño de imagen',

        'DetailedOptionsTitle' => 'Preferencias del listado detallado',
        'DetailedOptionsImageSize' => 'Tamaño de la imagen',
        'DetailedOptionsGroupItems' => 'Agrupar elementos por',
        'DetailedOptionsSecondarySort' => 'Ordenar los campos por el hijo',
        'DetailedOptionsFields' => 'Seleccione los campos a mostrar',
        'DetailedOptionsGroupedFirst' => 'Mantener juntos los elementos huérfanos',
        'DetailedOptionsAddCount' => 'Añadir el número de elementos en las categorías',

        'ExtractButton' => 'Información',
        'ExtractTitle' => 'Información del Fichero de Video',
        'ExtractImport' => 'Usar valores',

        'FieldsListOpen' => 'Leer los campos de la lista desde un fichero',
        'FieldsListSave' => 'Guardar los campos de la lista a un fichero',
        'FieldsListError' => 'Estos campor no se pueden usar con este tipo de colección',
        'FieldsListIgnore' => '--- Ignorar',

        'ExportTitle' => 'Exportar el listado de películas',	
        'ExportFilter' => 'Exportar sólo las películas mostradas',
        'ExportFieldsTitle' => 'Campos a exportar',
        'ExportFieldsTip' => 'Elija los campos a exportar',
        'ExportWithPictures' => 'Copiar las imágenes a un subdirectorio',
        'ExportSortBy' => 'Ordenar por',
        'ExportOrder' => 'Orden',

        'ImportListTitle' => 'Importar otro listado de películas',
        'ImportExportData' => 'Datos',
        'ImportExportFile' => 'Fichero',	 
        'ImportExportFieldsUnused' => 'Campos sin utilizar',
        'ImportExportFieldsUsed' => 'Campos utilizados',
        'ImportExportFieldsFill' => 'Todos los campos',
        'ImportExportFieldsClear' => 'Ningún campo',
        'ImportExportFieldsEmpty' => 'Debe señalar al menos un campo',
        'ImportExportFileEmpty' => 'Especifique un nombre para el fichero',
        'ImportFieldsTitle' => 'Campos a importar',
        'ImportFieldsTip' => 'Elija los campos a importar',
        'ImportNewList' => 'Crear un nuevo listado',
        'ImportCurrentList' => 'Añadir al listado actual',
        'ImportDropError' => 'Hubo un error abriendo al menos un fichero. Se recargará el listado anterior.',
        'ImportGenerateId' => 'Generate identifier for each item',

        'FileChooserOpenFile' => '¿En qué fichero guardar?', 	
        'FileChooserDirectory' => 'Directorio',
        'FileChooserOpenDirectory' => 'Elija un directorio',
        'FileChooserOverwrite' => 'Este fichero ya existe. ¿Quiere sustituirlo?',
        'FileAllFiles' => 'All Files',
        'FileVideoFiles' => 'Video Files',
        'FileEbookFiles' => 'Ebook Files',
        'FileAudioFiles' => 'Audio Files',
        'FileGCstarFiles' => 'GCstar Collections',

        'PanelCompact' => 'Compacto',
        'PanelReadOnly' => 'Sólo Lectura',
        'PanelForm' => 'Pestañas',

        'PanelSearchButton' => 'Descargar',
        'PanelSearchTip' => 'Buscar información relativa a la película',
        'PanelSearchContextChooseOne' => 'Choose a site ...',
        'PanelSearchContextMultiSite' => 'Use "Many sites"',
        'PanelSearchContextMultiSitePerField' => 'Use "Many sites per field"',
        'PanelSearchContextOptions' => 'Change options ...',
        'PanelImageTipOpen' => 'Pulse en la imagen para elegir otra.',
        'PanelImageTipView' => 'Pulse en la imagen para verla en su tamaño real...',
        'PanelImageTipMenu' => 'Click con el botón derecho para mas opciones.',
        'PanelImageTitle' => 'Seleccionar una imagen',	
        'PanelImageNoImage' => 'Sin imagen',
        'PanelSelectFileTitle' => 'Seleccione un fichero',
        'PanelLaunch' => 'Launch',        
        'PanelRestoreDefault' => 'Restaurar predeterminado',
        'PanelRefresh' => 'Update',
        'PanelRefreshTip' => 'Update information from web',

        'PanelFrom' =>'De',
        'PanelTo' =>'Para',

        'PanelWeb' => 'Ver la ficha en Internet',
        'PanelWebTip' => 'Ver la ficha {lowercaseDP1} en Internet', # Accepts model codes	
        'PanelRemoveTip' => 'Eliminar {lowercaseP1} anteriormente mencionada',  # Accepts model codes

        'PanelDateSelect' => 'Cambiar la fecha',	
        'PanelNobody' => 'Nadie',	
        'PanelUnknown' => 'Desconocido',	
        'PanelAdded' => 'Añadida el (fecha)',
        'PanelRating' => 'Nota',
        'PanelPressRating' => 'Press Rating',
        'PanelLocation' => 'Sitio',

        'PanelLending' => 'Préstamo',
        'PanelBorrower' => 'Prestatario',
        'PanelLendDate' => 'Fecha',
        'PanelHistory' => 'Historial',
        'PanelReturned' => '{1} devuelta', # Accepts model codes	
        'PanelReturnDate' => 'Fecha de devolución',
        'PanelLendedYes' => 'Prestada',
        'PanelLendedNo' => 'Disponible',

        'PanelTags' => 'Etiquetas',
        'PanelFavourite' => 'Favorita',
        'TagsAssigned' => 'Etiquetas asignadas', 

        'PanelUser' => 'Campos del usuario',

        'CheckUndef' => 'Cualquiera',
        'CheckYes' => 'Si',
        'CheckNo' => 'No',

        'ToolbarAll' => 'Ver todas',	
        'ToolbarAllTooltip' => 'Ver todas las películas',	
        'ToolbarGroupBy' => 'Agrupar por',
        'ToolbarGroupByTooltip' => 'Seleccionar el campo a usar para agrupos los elementos en la lista',
        'ToolbarQuickSearch' => 'Búsqueda rápida',
        'ToolbarQuickSearchLabel' => 'Buscar',
        'ToolbarQuickSearchTooltip' => 'Seleccione el campo en el que buscar. Introduzca los términos de búsqueda y pulse Enter',
        'ToolbarSeparator' => ' Separador',

        'PluginsTitle' => 'Buscar una película',	
        'PluginsQuery' => 'Búsqueda',
        'PluginsFrame' => 'Sitio donde buscar ',
        'PluginsLogo' => 'Logo',
        'PluginsName' => 'Nombre',
        'PluginsSearchFields' => 'Campos de búsqueda',
        'PluginsAuthor' => 'Autor',
        'PluginsLang' => 'Idioma',
        'PluginsUseSite' => 'Usar sitio seleccionado para futuras búsquedas',
        'PluginsPreferredTooltip' => 'Sitio recomendado por GCstar',
        'PluginDisabled' => 'Disabled', 
        
        'BorrowersTitle' => 'Configuración de los prestatarios',	
        'BorrowersList' => 'Prestatarios',	
        'BorrowersName' => 'Nombre',	
        'BorrowersEmail' => 'Correo electrónico',	
        'BorrowersAdd' => 'Añadir',	
        'BorrowersRemove' => 'Eliminar',	
        'BorrowersEdit' => 'Modificar',	
        'BorrowersTemplate' => 'Modelo de correo electrónico',	
        'BorrowersSubject' => 'Título del correo electrónico : ',	
        'BorrowersNotice1' => '%1 se sustituirá por el nombre del prestatario',	
        'BorrowersNotice2' => '%2 se sustituirá por el título de la película',	
        'BorrowersNotice3' => '%3 se sustituirá por la fecha del préstamo',	
      
        'BorrowersImportTitle' => 'Importar información de prestatarios',
        'BorrowersImportType' => 'Formato del fichero:',
        'BorrowersImportFile' => 'Fichero:',

        'BorrowedTitle' => '{X} prestadas', # Accepts model codes		
        'BorrowedDate' => 'Desde el',	
        'BorrowedDisplayInPanel' => 'Mostrar {lowercase1} en la ventana principal', # Accepts model codes	

        'MailTitle' => 'Enviar un correo electrónico',	
        'MailFrom' => 'De: ',	
        'MailTo' => 'Para: ',	
        'MailSubject' => 'Tema: ',
        'MailSmtpError' => 'Problema de conexión con el servidor',	
        'MailSendmailError' => 'Problema ejecutando sendmail',	

        'SearchTooltip' => 'Buscar en todas {lowercasePX}', # Accepts model codes		
        'SearchTitle' => 'Búsqueda de {lowercasePX}', # Accepts model codes		
        'SearchNoField' => 'No field have been selected for the search box.
Add some of them in the Filters tab of the collection settings.',
                
        'QueryReplaceField' => 'Campo a sustituir',
        'QueryReplaceOld' => 'Nombre actual',	
        'QueryReplaceNew' => 'Nuevo nombre',	
        'QueryReplaceLaunch' => 'Sustituir',
        
        'ImportWindowTitle' => 'Elegir los campos que deben importarse',	
        'ImportViewPicture' => 'Ver la imagen',		
        'ImportSelectAll' => 'Seleccionarlo todo',	
        'ImportSelectNone' => 'No seleccionar nada',  

        'MultiSiteTitle' => 'Sitios donde buscar',
        'MultiSiteUnused' => 'Módulos no usados',
        'MultiSiteUsed' => 'Módulos a usar',
        'MultiSiteLang' => 'Usar todos los módulos españoles',
        'MultiSiteEmptyError' => 'La lista de sitios está vacía',
        'MultiSiteClear' => 'Vaciar la lista',

        'DisplayOptionsTitle' => 'Elementos a mostrar',
        'DisplayOptionsAll' => 'Seleccionarlo todo',
        'DisplayOptionsSearch' => 'Buscar',

        'GenresTitle' => 'Conversión de Géneros',
        'GenresCategoryName' => 'Género a usar',
        'GenresCategoryMembers' => 'Géneros a reemplazar',
        'GenresLoad' => 'Cargar una lista predefinida',
        'GenresExport' => 'Exportar listado a un fichero',
        'GenresModify' => 'Editar conversión',

        'PropertiesName' => 'Nombre de la colección',
        'PropertiesLang' => 'Código de idioma',
        'PropertiesOwner' => 'Dueño',
        'PropertiesEmail' => 'Email',
        'PropertiesDescription' => 'Descripción',
        'PropertiesFile' => 'Información del fichero',
        'PropertiesFilePath' => 'Ruta completa',
        'PropertiesItemsNumber' => 'Número de {lowercaseX}', # Accepts model codes
        'PropertiesFileSize' => 'Tamaño',
        'PropertiesFileSizeSymbols' => ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
        'PropertiesCollection' => 'Propiedades de la colección',
        'PropertiesDefaultPicture' => 'Imagen predeterminada',

        'MailProgramsTitle' => 'Programas para enviar correos',
        'MailProgramsName' => 'Nombre',
        'MailProgramsCommand' => 'Linea de comandos',
        'MailProgramsRestore' => 'Usar predeterminados',
        'MailProgramsAdd' => 'Añadir un programa',
        'MailProgramsInstructions' => 'En la linea de comandos se hacen algunas sustituciones:
 %f se sustituirá por la dirección de e-mail del usuario.
 %t se sustituirá por la dirección del destinatario.
 %s se sustituirá por el asunto del mensaje.
 %b se sustituirá por el cuerpo del mensaje.',

        'BookmarksBookmarks' => 'Marcadores',
        'BookmarksFolder' => 'Directorio',
        'BookmarksLabel' => 'Etiqueta',
        'BookmarksPath' => 'Ruta',
        'BookmarksNewFolder' => 'Nueva carpeta',

        'AdvancedSearchType' => 'Tipo de búsqueda',
        'AdvancedSearchTypeAnd' => '{X} que cumplan todos los criterios', # Accepts model codes
        'AdvancedSearchTypeOr' => '{X} que cunplan al menos un criterio', # Accepts model codes
        'AdvancedSearchCriteria' => 'Critero',
        'AdvancedSearchAnyField' => 'Cualquier campo',
        'AdvancedSearchSaveTitle' => 'Guardar búsqueda',
        'AdvancedSearchSaveName' => 'Nombre',
        'AdvancedSearchSaveOverwrite' => 'Ya esixte una búsqueda guardada con el mismo nombre. Por favor, use uno diferente.',
        'AdvancedSearchUseCase' => 'Sensible a mayúsculas',
        'AdvancedSearchIgnoreDiacritics' => 'Ignorar acentos y otros diacríticos',

        'BugReportSubject' => 'Informe de error generado por GCstar',
        'BugReportVersion' => 'Versión',
        'BugReportPlatform' => 'Sistema operativo',
        'BugReportMessage' => 'Mensaje de error',
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
