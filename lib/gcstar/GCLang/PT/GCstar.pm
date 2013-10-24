{
    package GCLang::PT;

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

        'LangName' => 'Português',
        
        'Separator' => ': ',
        
        'Warning' => '<b>Aviso</b>:
        
A informação baixada de sites da internet (através 
dos plugins de busca) é para <b>uso pessoal apenas</b>.

Qualquer redistribuição é proibida <b>permissão explicita</b> 
do site.

Para escolher em qual site deseja buscar a informação, você
pode usar o <b>botão abaixo dos detalhes do item</b>.',
        
        'AllItemsFiltered' => 'Nenhum item cumpre com os critérios do filtro', # Accepts model codes
        
#Installation
        'InstallDirInfo' => 'Instalar em ',
        'InstallMandatory' => 'Componente obrigatórios',
        'InstallOptional' => 'Componentes opcionais',
        'InstallErrorMissing' => 'Error: os componentes seguintes devem ser instalados: ',
        'InstallPrompt' => 'Pasta predeterminado para a instalação [/usr/local]: ',
        'InstallEnd' => 'Fim da instalação',	
        'InstallNoError' => 'Nenhum erro',
        'InstallLaunch' => 'Para utilizar a aplicação, execute ',
        'InstallDirectory' => 'Pasta de instalação',
        'InstallTitle' => 'Instalação do GCstar',
        'InstallDependencies' => 'Dependências',	
        'InstallPath' => 'Caminho',
        'InstallOptions' => 'Opções',
        'InstallSelectDirectory' => 'Escolha a pasta para instalação',   
        'InstallWithClean' => 'Apagar arquivos das pastas de instalação.',
       	'InstallWithMenu' => 'Adicionar GCstar ao menu de Aplicações',
       	'InstallNoPermission' => 'Error : Você não tem permissões para instalar na pasta selecionada',
        'InstallMissingMandatory' => 'Algumas dependências obrigatórias não estão disponíveis. Não poderá instalar GCstar até que se instalem no sistema.',
        'InstallMissingOptional' => 'Algumas dependências opcionais não estão disponíveis (lista abaixo). GCstar será instalado com algumas funções desabilitadas.',
        'InstallMissingNone' => 'Dependências satisfeitas. Pode continuar e instalar GCstar.',
        'InstallOK' => 'OK',
        'InstallMissing' => 'Não disponível',
        'InstallMissingFor' => 'Não disponível por',
        'InstallCleanDirectory' => 'Apagar arquivos de GCstar na pasta: ',
        'InstallCopyDirectory' => 'Copiando arquivos na pasta: ',
        'InstallCopyDesktop' => 'Copiando os arquivos da área de trabalho em: ',
        
#Update
        'UpdateUseProxy' => 'Usar o Proxy (se não usa nenhum pressione Enter): ',
        'UpdateNoPermission' => 'Permissão de escrita negada para esta pasta: ',
        'UpdateNone' => 'Nenhuma atualização encontrada',
        'UpdateFileNotFound' => 'Arquivo não encontrado',

#Splash
        'SplashInit' => 'Inicialização',
        'SplashLoad' => 'Carregando coleção',
        'SplashDisplay' => 'Mostrando Coleção',
        'SplashSort' => 'Sorting Collection',
        'SplashDone' => 'Pronto',

#Import from GCfilms
        'GCfilmsImportQuestion' => 'Parece que você usava GCfilms antes. Quer importar do GCfilms para o GCstar? (Não afetará o GCfilms, se você quiser seguir usando-o)',
        'GCfilmsImportOptions' => 'Preferências',
        'GCfilmsImportData' => 'Lista de filmes',

#Menus
        'MenuFile' => '_Arquivo',	
            'MenuNewList' => '_Nova coleção',	
            'MenuStats' => 'Statistics',
            'MenuHistory' => 'Coleções _recentes',
            'MenuLend' => '_Ver itens emprestados', # Accepts model codes
            'MenuImport' => '_Importar',
            'MenuExport' => '_Exportar',	
            'MenuAddItem' => '_Add Items', # Accepts model codes

        'MenuEdit'  => '_Editar',
            'MenuDuplicate' => '_Duplicar item', # Accepts model codes
            'MenuDuplicatePlural' => 'Du_plicate Items', # Accepts model codes
            'MenuEditSelectAllItems' => 'Select _All Items', # Accepts model codes
            'MenuEditDeleteCurrent' => '_Apagar item', # Accepts model codes
            'MenuEditDeleteCurrentPlural' => '_Remove Items', # Accepts model codes    
            'MenuEditFields' => '_Trocar campos da coleção',
            'MenuEditLockItems' => '_Bloquear coleção',
        
        'MenuDisplay' => '_Filtros',        
            'MenuSavedSearches' => 'Saved searches',
                'MenuSavedSearchesSave' => 'Save current search',
                'MenuSavedSearchesEdit' => 'Modify saved searches',
            'MenuAdvancedSearch' => 'Busca _avançada',
            'MenuViewAllItems' => '_Ver todos os itens', # Accepts model codes	
            'MenuNoFilter' => '_Todos',	

        'MenuConfiguration' => '_Configurações',	
            'MenuDisplayMenu' => 'Display',
                'MenuDisplayFullScreen' => 'Full screen',
                'MenuDisplayMenuBar' => 'Menus',
                'MenuDisplayToolBar' => 'Toolbar',
                'MenuDisplayStatusBar' => 'Bottom bar',
            'MenuDisplayOptions' => '_Informações exibidas',
            'MenuBorrowers' => '_Devedores',	
            'MenuToolbarConfiguration' => '_Toolbar controls',
            'MenuDefaultValues' => 'Default values for new item', # Accepts model codes
            'MenuGenresConversion' => 'Conversão de _gêneros',

        'MenuBookmarks' => 'Minhas _Coleções',
            'MenuBookmarksAdd' => '_Adicionar coleção atual',
            'MenuBookmarksEdit' => '_Editar coleções favoritas',

        'MenuHelp' => 'Aj_uda?',
            'MenuHelpContent' => '_Conteúdo?',
            'MenuAllPlugins' => 'Ver _plugins',
            'MenuBugReport' => '_Reportar um problema',
            'MenuAbout' => '_Sobre',	

        'MenuNewWindow' => 'Mostrar item em uma nova janela', # Accepts model codes
        'MenuNewWindowPlural' => 'Show Items in _New Window', # Accepts model codes
                
        'ContextExpandAll' => 'Expandir tudo',
        'ContextCollapseAll' => 'Contrair todo',
        'ContextChooseImage' => 'Choose _Image',
        'ContextOpenWith' => 'Open Wit_h',
        'ContextImageEditor' => 'Image Editor',
        'ContextImgFront' => 'Front',
        'ContextImgBack' => 'Back',
        'ContextChooseFile' => 'Choose a File',
        'ContextChooseFolder' => 'Choose a Folder',

        'DialogEnterNumber' => 'Por favor, introduza um valor',

        'RemoveConfirm' => 'Tem certeza que quer apagar este item?', # Accepts model codes 
        'RemoveConfirmPlural' => 'Do you really want to remove these items?', # Accepts model codes 
        'DefaultNewItem' => 'Novo item', # Accepts model codes
        'NewItemTooltip' => 'Adicionar um novo item', # Accepts model codes
        'NoItemFound' => 'Nada foi encontrado. Deseja tentar a busca em outro site?',
        'OpenList' => 'Por favor, selecione uma coleção',	
        'SaveList' => 'Selecione onde deseja salvar a coleção',	
        'SaveListTooltip' => 'Salvar coleção atual', 
        'SaveUnsavedChanges' => 'Existe mudanças na coleção atual. Deseja salvá-las',
        'SaveDontSave' => 'Não salvar',
        'PreferencesTooltip' => 'Selecionar preferências',
        'ViewTooltip' => 'Trocar o tipo de coleção',
        'PlayTooltip' => 'Reproduzir arquivo de vídeo associado ao item', # Accepts model codes
        'PlayFileNotFound' => 'File to launch was not found in this location:',
        'PlayRetry' => 'Retry',
        
        'StatusSave' => 'Salvando...',
        'StatusLoad' => 'Carregando...',
        'StatusSearch' => 'Busca em progresso...',
        'StatusGetInfo' => 'Baixando a informação...',
        'StatusGetImage' => 'Baixando imagem...',	
        
        'SaveError' => 'Impossível salvar a coleção. Por favor, verifique as permissões de acesso e o espaço livre.',
        'OpenError' => 'Impossível abrir a coleção. Por favor, verifique as permissões de acesso.',
        'OpenFormatError' => 'Impossível abrir a coleção. O formato pode estar incorreto',
        'OpenVersionWarning' => 'Collection was created with a more recent version of GCstar. If you save it, you may loose some data.',
        'OpenVersionQuestion' => 'Do you still want to continue?',
        'ImageError' => 'O diretório de imagens está incorreto. Por favor, selecione outro.',
        'OptionsCreationError'=> 'Impossível criar um arquivo de opções: ',
        'OptionsOpenError'=> 'Impossível abrir um arquivo de opções: ',
        'OptionsSaveError'=> 'Impossível salvar um arquivo de opções: ',
        'ErrorModelNotFound' => 'Model not found: ',
        'ErrorModelUserDir' => 'User defined models are in: ',

        'RandomTooltip' => 'O que quer ver esta noite?',
        'RandomError'=> 'Você não possui itens selecionáveis', # Accepts model codes
        'RandomEnd'=> 'Não tem mais itens', # Accepts model codes
        'RandomNextTip'=> 'Segunda sugestão',
        'RandomOkTip'=> 'Aceitar este item',
                        
        'AboutTitle' => 'Sobre GCstar',
        'AboutDesc' => 'Gerenciador de coleções',
        'AboutVersion' => 'Versão',
        'AboutTeam' => 'Equipe',
        'AboutWho' => 'Christian Jodar (Tian) : Gerente de projeto, Programador
Nyall Dawson (Zombiepig) : Programador
TPF : Programador
Adolfo González : Programador
',
        'AboutLicense' => 'Distribuído segundo os termos da GNU GPL
Logos Copyright le Spektre',
        'AboutTranslation' => 'Tradução para português (Brasil): Daniel Valença',
        'AboutDesign' => 'Łukasz Kowalczk (Qoolman): Skin Designer
Logo e webdesign por le Spektre',
        
        'ToolbarRandom' => 'Esta noite',

        'UnsavedCollection' => 'Unsaved Collection',
        'ModelsSelect' => 'Selecionar um tipo de coleção',
        'ModelsPersonal' => 'Modelos pessoais',
        'ModelsDefault' => 'Modelos padrões',
        'ModelsList' => 'Definições da coleção',
        'ModelSettings' => 'Configurações da coleção',
        'ModelNewType' => 'Novo tipo de coleção',
        'ModelName' => 'Nome do tipo de coleção:',
		'ModelFields' => 'Campos',
		'ModelOptions'	=> 'Opções',
		'ModelFilters'	=> 'Filtros',
        'ModelNewField' => 'Novo campo',
        'ModelFieldInformation' => 'Informação',
        'ModelFieldName' => 'Nome:',
        'ModelFieldType' => 'Tipo:',
        'ModelFieldGroup' => 'Grupo:',
        'ModelFieldValues' => 'Valores',
        'ModelFieldInit' => 'Padrões:',
        'ModelFieldMin' => 'Mínimo:',
        'ModelFieldMax' => 'Máximo:',
        'ModelFieldList' => 'Lista de valores:',
        'ModelFieldListLegend' => '<i>Separados por vírgulas</i>',
        'ModelFieldDisplayAs' => 'Display as:',
        'ModelFieldDisplayAsText' => 'Text',
        'ModelFieldDisplayAsGraphical' => 'Rating Control',
        'ModelFieldTypeShortText' => 'Texto curto',
        'ModelFieldTypeLongText' => 'Texto longo',
        'ModelFieldTypeYesNo' => 'Sim/Não',
        'ModelFieldTypeNumber' => 'Número',
        'ModelFieldTypeDate' => 'Data',
        'ModelFieldTypeOptions' => 'Lista de valores predefinidos',
        'ModelFieldTypeImage' => 'Imagem',
        'ModelFieldTypeSingleList' => 'Lista simples',
        'ModelFieldTypeFile' => 'Arquivo',
        'ModelFieldTypeFormatted' => 'Dependente em outros campos',
        'ModelFieldParameters' => 'Parâmetros',
        'ModelFieldHasHistory' => 'Usar um histórico',
        'ModelFieldFlat' => 'Exibir uma linha',
        'ModelFieldStep' => 'Tamanho do incremento:',
        'ModelFieldFileFormat' => 'Formato do arquivo:',
        'ModelFieldFileFile' => 'Arquivo simples',
        'ModelFieldFileImage' => 'Imagem',
        'ModelFieldFileVideo' => 'Vídeo',
        'ModelFieldFileAudio' => 'Áudio',
        'ModelFieldFileProgram' => 'Programa',
        'ModelFieldFileUrl' => 'URL',
        'ModelFieldFileEbook' => 'Ebook',
        'ModelOptionsFields' => 'Campos a usar',
        'ModelOptionsFieldsAuto' => 'Automático',
        'ModelOptionsFieldsNone' => 'Nenhum',
        'ModelOptionsFieldsTitle' => 'Como título',
        'ModelOptionsFieldsId' => 'Como identificador',
        'ModelOptionsFieldsCover' => 'Como capa',
        'ModelOptionsFieldsPlay' => 'Como botão de Reproduzir',
        'ModelCollectionSettings' => 'Preferências da coleção',
        'ModelCollectionSettingsLending' => 'Elementos que podem ser emprestados',
        'ModelCollectionSettingsTagging' => 'Items can be tagged',
        'ModelFilterActivated' => 'Deve aparecer na caixa de busca',
        'ModelFilterComparison' => 'Comparação',
        'ModelFilterContain' => 'Contém',
        'ModelFilterDoesNotContain' => 'Does not contain',
        'ModelFilterRegexp' => 'Regular expression',
        'ModelFilterRange' => 'Escopo',
        'ModelFilterNumeric' => 'Comparação numérica',
        'ModelFilterQuick' => 'Criar um filtro rápido',
        'ModelTooltipName' => 'Usar um nome para reutilizar este modelo para outras coleções. Se vazio, as preferências serão salvas na própria coleção',
        'ModelTooltipLabel' => 'Nome do campo como será mostrado',
        'ModelTooltipGroup' => 'Usado para agrupar os campos. Itens sem valor serão atribuídos ao grupo padrão',
        'ModelTooltipHistory' => 'Os valores introduzidos anteriormente devem ser armazenados em uma lista associada ao campo?',
        'ModelTooltipFormat' => 'O formato se usa para determinar a ação para abrir o arquivo com o botão Reproduzir',
        'ModelTooltipLending' => 'Isto irá adicionar campos para o gerenciamento dos empréstimos',
        'ModelTooltipTagging' => 'This will add some fields to manage tags',
        'ModelTooltipNumeric' => 'Os valores devem ser considerados como números para comparação?',
        'ModelTooltipQuick' => 'Isto irá adicionar um sub-menu dentro do menu de Filtros',

        'ResultsTitle' => 'Selecione um item', # Accepts model codes
        'ResultsNextTip' => 'Buscar no próximo site',
        'ResultsPreview' => 'Prévia',
        'ResultsInfo' => 'You can add multiple items to the collection by holding down the Ctrl or the Shift key and selecting them', # Accepts model codes

        'OptionsTitle' => 'Preferências',
		'OptionsExpertMode' => 'Expert Mode',
        'OptionsPrograms' => 'Specify applications to use for different media, leave blank to use system defaults',
        'OptionsBrowser' => 'Navegador de Internet',
        'OptionsPlayer' => 'Reprodutor de vídeo',
        'OptionsAudio' => 'Reprodutor de áudio',
        'OptionsImageEditor' => 'Image editor',
        'OptionsCdDevice' => 'CD device',
        'OptionsImages' => 'Pasta de imagens', 	
        'OptionsUseRelativePaths' => 'Usar rotas relativas para as imagens',
        'OptionsLayout' => 'Disposição',	
        'OptionsStatus' => 'Barra de status',	
        'OptionsUseStars' => 'Use stars to display ratings',
        'OptionsWarning' => 'Atenção: As mudanças efetuadas nesta aba não terão efeito até que o aplicativo seja reiniciado.', 
        'OptionsRemoveConfirm' => 'Pedir confirmação antes de apagar',
        'OptionsAutoSave' => 'Salvar coleção automaticamente',
        'OptionsAutoLoad' => 'Carregar a coleção anterior ao início',
        'OptionsSplash' => 'Exibir tela de início',
        'OptionsTearoffMenus' => 'Enable tear-off menus',
        'OptionsSpellCheck' => 'Use spelling checker for long text fields',
        'OptionsProgramTitle' => 'Escolha que programa a utilizar',
        'OptionsPlugins' => 'Site para baixar informações',
        'OptionsAskPlugins' => 'Perguntar (Todos os sites)',
        'OptionsPluginsMulti' => 'Vários sites',
        'OptionsPluginsMultiAsk' => 'Perguntar (Alguns sites)',
        'OptionsPluginsMultiPerField' => 'Vários sites (per field)',
        'OptionsPluginsMultiPerFieldWindowTitle' => 'Many sites per field order selection',
        'OptionsPluginsMultiPerFieldDesc' => 'For each selected field we will return the first non empty information beginning from left',
        'OptionsPluginsMultiPerFieldFirst' => 'First',
        'OptionsPluginsMultiPerFieldLast' => 'Last',
        'OptionsPluginsMultiPerFieldRemove' => 'Remove',
        'OptionsPluginsMultiPerFieldClearSelected' => 'Empty selected field list',
        'OptionsPluginsList' => 'Definir lista',
        'OptionsAskImport' => 'Escolher os campos a importar',
        'OptionsProxy' => 'Utilizar um proxy',
		'OptionsCookieJar' => 'Use this cookie jar file',
        'OptionsMain' => 'Principal',
        'OptionsLang' => 'Idioma',
        'OptionsPaths' => 'Pastas',
        'OptionsInternet' => 'Internet',
        'OptionsConveniences' => 'Opções',	
        'OptionsDisplay' => 'Visualização',
        'OptionsToolbar' => 'Barra de ferramentas',	
        'OptionsToolbars' => {0 => 'Nenhuma', 1 => 'Pequena', 2 => 'Grande', 3 => 'System setting'},
        'OptionsToolbarPosition' => 'Posição',
        'OptionsToolbarPositions' => {0 => 'Acima', 1 => 'Abaixo', 2 => 'Esquerda', 3 => 'Direita'},
        'OptionsExpandersMode' => 'Expanders too long',
        'OptionsExpandersModes' => {'asis' => 'Do nothing', 'cut' => 'Cut', 'wrap' => 'Line wrap'},
        'OptionsDateFormat' => 'Date Format',
        'OptionsDateFormatTooltip' => 'Format is the one used by strftime(3). Default is %d/%m/%Y',
        'OptionsView' => 'Tipo de coleção',
        'OptionsViews' => {0 => 'Texto', 1 => 'Imagem', 2 => 'Detalhada'},
        'OptionsColumns' => 'Colunas',	
        'OptionsMailer' => 'Método de envio',
        'OptionsSMTP' => 'Servidor',	
        'OptionsFrom' => 'Seu e-mail',	
        'OptionsTransform' => 'Colocar artigos ao final dos títulos',	
        'OptionsArticles' => 'Artigos (separados por vírgula)',	
        'OptionsSearchStop' => 'O usuário pode cancelar a busca',
        'OptionsBigPics' => 'Use big pictures when available',
        'OptionsAlwaysOriginal' => 'Usar título principal como o original se não encontrar nenhum',
        'OptionsRestoreAccelerators' => 'Restore accelerators',
        'OptionsHistory' => 'Tamanho do histórico',
        'OptionsClearHistory' => 'Limpar histórico',
        'OptionsStyle' => 'Skin',
        'OptionsDontAsk' => 'Não perguntar mais',
        'OptionsPathProgramsGroup' => 'Aplicações',
        'OptionsProgramsSystem' => 'Usar programas definidos pelo sistema',
        'OptionsProgramsUser' => 'Usar programas especificados',
        'OptionsProgramsSet' => 'Escolher programas',
        'OptionsPathImagesGroup' => 'Imagens',
        'OptionsInternetDataGroup' => 'Importar dados',
        'OptionsInternetSettingsGroup' => 'Configurações',
        'OptionsDisplayInformationGroup' => 'Mostrar informação',
        'OptionsDisplayArticlesGroup' => 'Artigos',
        'OptionsImagesDisplayGroup' => 'Exibir',
        'OptionsImagesStyleGroup' => 'Estilo',
        'OptionsDetailedPreferencesGroup' => 'Preferências',
        'OptionsFeaturesConveniencesGroup' => 'Conveniências',
        'OptionsPicturesFormat' => 'Prefixo para usar nas imagens:',
        'OptionsPicturesFormatInternal' => 'gcstar__',
        'OptionsPicturesFormatTitle' => 'Título ou nome do item associado',
        'OptionsPicturesWorkingDir' => '%WORKING_DIR% ou . será substituído com a pasta da coleção (usar apenas no começo da pasta)',
        'OptionsPicturesFileBase' => '%FILE_BASE% será substituído pelo nome do arquivo da coleção sem o sufixo (.gcs)',
        'OptionsPicturesWorkingDirError' => '%WORKING_DIR% pode ser usado apenas no começo da pasta de imagens',
        'OptionsConfigureMailers' => 'Configurar programas de e-mail',
		       
        'ImagesOptionsButton' => 'Configurações',
        'ImagesOptionsTitle' => 'Configurações para lista de imagens',
        'ImagesOptionsSelectColor' => 'Escolha uma cor',
        'ImagesOptionsUseOverlays' => 'Use image overlays',
        'ImagesOptionsBg' => 'Fundo',
        'ImagesOptionsBgPicture' => 'Usar uma imagem de fundo',
        'ImagesOptionsFg'=> 'Seleção',
        'ImagesOptionsBgTooltip' => 'Trocar cor de fundo',
        'ImagesOptionsFgTooltip'=> 'Trocar cor de seleção',
        'ImagesOptionsResizeImgList' => 'Automatically change number of columns',
        'ImagesOptionsAnimateImgList' => 'Use animations',
        'ImagesOptionsSizeLabel' => 'Tamanho',
        'ImagesOptionsSizeList' => {0 => 'Muito Pequeno', 1 => 'Pequeno', 2 => 'Médio', 3 => 'Grande', 4 => 'Muito Grande'},
        'ImagesOptionsSizeTooltip' => 'Selecione um tamanho de imagem',

        'DetailedOptionsTitle' => 'Configuração para lista detalhada',
        'DetailedOptionsImageSize' => 'Tamanho da imagem',
        'DetailedOptionsGroupItems' => 'Agrupar itens por',
        'DetailedOptionsSecondarySort' => 'Sort field for children',
        'DetailedOptionsFields' => 'Selecione os campos a exibir',
        'DetailedOptionsGroupedFirst' => 'Keep together orphaned items',
        'DetailedOptionsAddCount' => 'Add number of elements on categories',

        'ExtractButton' => 'Informação',
        'ExtractTitle' => 'Informação do arquivo',
        'ExtractImport' => 'Usar valores',

        'FieldsListOpen' => 'Ler os campos da lista de um arquivo',
        'FieldsListSave' => 'Salvar os campos da lista em outro arquivo',
        'FieldsListError' => 'Estes campos não podem ser usados com este tipo de coleção',
        'FieldsListIgnore' => '--- Ignore',

        'ExportTitle' => 'Exportar itens',	
        'ExportFilter' => 'Exportar apenas itens exibidos',
        'ExportFieldsTitle' => 'Campos a exportar',
        'ExportFieldsTip' => 'Escolha os campos para exportar',
        'ExportWithPictures' => 'Copiar as imagens de uma sub-pasta',
        'ExportSortBy' => 'Sort by',
        'ExportOrder' => 'Order',

        'ImportListTitle' => 'Importar outra lista de itens',
        'ImportExportData' => 'Informação',
        'ImportExportFile' => 'Arquivo',	 
        'ImportExportFieldsUnused' => 'Campos inutilizados',
        'ImportExportFieldsUsed' => 'Campos utilizados',
        'ImportExportFieldsFill' => 'Todos os campos',
        'ImportExportFieldsClear' => 'Nenhum campo',
        'ImportExportFieldsEmpty' => 'Deve assinalar ao menos um campo',
        'ImportExportFileEmpty' => 'Especifique um nome para o arquivo',
        'ImportFieldsTitle' => 'Campos a importar',
        'ImportFieldsTip' => 'Escolha os campos para importar',
        'ImportNewList' => 'Criar uma nova coleção',
        'ImportCurrentList' => 'Adicionar para coleção atual',
        'ImportDropError' => 'Ocorreu um erro ao abrir em pelo menos um arquivo. A lista anterior será recarregada.',
        'ImportGenerateId' => 'Gerar identificador para cada item',

        'FileChooserOpenFile' => 'Por favor, selecione um arquivo', 	
        'FileChooserDirectory' => 'Directory',
        'FileChooserOpenDirectory' => 'Escolha uma pasta',
        'FileChooserOverwrite' => 'Este arquivo já existe. Deseja sobrescrevê-lo?',
        'FileAllFiles' => 'All Files',
        'FileVideoFiles' => 'Video Files',
        'FileEbookFiles' => 'Ebook Files',
        'FileAudioFiles' => 'Audio Files',
        'FileGCstarFiles' => 'GCstar Collections',

        #Some default panels
        'PanelCompact' => 'Compacto',
        'PanelReadOnly' => 'Somente leitura',
        'PanelForm' => 'Abas',

        'PanelSearchButton' => 'Baixar informação',
        'PanelSearchTip' => 'Buscar informação na Internet para este nome',
        'PanelSearchContextChooseOne' => 'Choose a site ...',
        'PanelSearchContextMultiSite' => 'Use "Many sites"',
        'PanelSearchContextMultiSitePerField' => 'Use "Many sites per field"',
        'PanelSearchContextOptions' => 'Change options ...',
        'PanelImageTipOpen' => 'Click na imagem para selecionar outra',
        'PanelImageTipView' => 'Click na imagem para vê-la em tamanho real...',
        'PanelImageTipMenu' => 'Click com o botão direito para mais opções.',
        'PanelImageTitle' => 'Selecionar uma imagem',	
        'PanelImageNoImage' => 'Sem imagem',
        'PanelSelectFileTitle' => 'Selecione um arquivo',
        'PanelLaunch' => 'Launch',        
        'PanelRestoreDefault' => 'Restaurar padrões',
        'PanelRefresh' => 'Update',
        'PanelRefreshTip' => 'Update information from web',

        'PanelFrom' =>'De',
        'PanelTo' =>'Para',

        'PanelWeb' => 'Ver informação',
        'PanelWebTip' => 'Ver informação na Internet sobre este item', # Accepts model codes	
        'PanelRemoveTip' => 'Apagar item atual', # Accepts model codes 

        'PanelDateSelect' => 'Selecionar',	
        'PanelNobody' => 'Ninguém',	
        'PanelUnknown' => 'Desconhecido',	
        'PanelAdded' => 'Adicionar data',
        'PanelRating' => 'Nota',
        'PanelPressRating' => 'Press Rating',
        'PanelLocation' => 'Localidade',

        'PanelLending' => 'Emprestar',
        'PanelBorrower' => 'Devedor',
        'PanelLendDate' => 'Fora desde',
        'PanelHistory' => 'Histórico',
        'PanelReturned' => 'Item devolvido', # Accepts model codes	
        'PanelReturnDate' => 'Data de devolução',
        'PanelLendedYes' => 'Emprestada',
        'PanelLendedNo' => 'Disponível',

        'PanelTags' => 'Tags',
        'PanelFavourite' => 'Favourite',
        'TagsAssigned' => 'Assigned Tags', 

        'PanelUser' => 'User fields',

        'CheckUndef' => 'Qualquer',
        'CheckYes' => 'Sim',
        'CheckNo' => 'Não',

        'ToolbarAll' => 'Ver todas',	
        'ToolbarAllTooltip' => 'Ver todos os itens',	
        'ToolbarGroupBy' => 'Agrupar por',
        'ToolbarGroupByTooltip' => 'Selecionar o campo para usar nos itens agrupados na lista',
        'ToolbarQuickSearch' => 'Quick search',
        'ToolbarQuickSearchLabel' => 'Search',
        'ToolbarQuickSearchTooltip' => 'Select the field to search in. Enter the search terms and press Enter',
        'ToolbarSeparator' => ' Separator',

        'PluginsTitle' => 'Buscar um item',	
        'PluginsQuery' => 'Pergunta',
        'PluginsFrame' => 'Site de busca',
        'PluginsLogo' => 'Logo',
        'PluginsName' => 'Nome',
        'PluginsSearchFields' => 'Campos de busca',
        'PluginsAuthor' => 'Autor',
        'PluginsLang' => 'Idioma',
        'PluginsUseSite' => 'Usar site selecionado para futuras buscas',
        'PluginsPreferredTooltip' => 'Site recommended by GCstar',
        'PluginDisabled' => 'Disabled',
        
        'BorrowersTitle' => 'Configuração dos devedores',	
        'BorrowersList' => 'Devedores',	
        'BorrowersName' => 'Nome',	
        'BorrowersEmail' => 'E-mail',	
        'BorrowersAdd' => 'Adicionar',	
        'BorrowersRemove' => 'Apagar',	
        'BorrowersEdit' => 'Modificar',	
        'BorrowersTemplate' => 'Modelo do e-mail',	
        'BorrowersSubject' => 'Assunto do e-mail',	
        'BorrowersNotice1' => '%1 será substituído pelo nome do devedor',	
        'BorrowersNotice2' => '%2 será substituído pelo título do item',	
        'BorrowersNotice3' => '%3 será substituído pela data do empréstimo',	
      
        'BorrowersImportTitle' => 'Importar informação dos devedores',
        'BorrowersImportType' => 'Formato do arquivo:',
        'BorrowersImportFile' => 'Arquivo:',

        'BorrowedTitle' => 'Itens emprestados', # Accepts model codes	
        'BorrowedDate' => 'Desde',	
        'BorrowedDisplayInPanel' => 'Show item in main window', # Accepts model codes

        'MailTitle' => 'Enviar um e-mail',	
        'MailFrom' => 'De: ',	
        'MailTo' => 'Para: ',	
        'MailSubject' => 'Assunto: ',
        'MailSmtpError' => 'Problema de conexão com o servidor SMTP',	
        'MailSendmailError' => 'Problema na execução do sendmail',	

        'SearchTooltip' => 'Buscar em todos itens', # Accepts model codes	
        'SearchTitle' => 'Busca de itens', # Accepts model codes	
        'SearchNoField' => 'No field have been selected for the search box.
Add some of them in the Filters tab of the collection settings.',
                
        'QueryReplaceField' => 'Campo para substituição',
        'QueryReplaceOld' => 'Nome atual',	
        'QueryReplaceNew' => 'Novo nome',	
        'QueryReplaceLaunch' => 'Substituir',
        
        'ImportWindowTitle' => 'Escolher os campos para importar',	
        'ImportViewPicture' => 'Ver a imagem',		
        'ImportSelectAll' => 'Selecionar todos',	
        'ImportSelectNone' => 'Selecionar nenhum',  

        'MultiSiteTitle' => 'Sites de busca',
        'MultiSiteUnused' => 'Plugins inutilizados',
        'MultiSiteUsed' => 'Plugins para usar',
        'MultiSiteLang' => 'Selecionar plugins em português',
        'MultiSiteEmptyError' => 'A lista de sites está vazia',
        'MultiSiteClear' => 'Limpar lista',

        'DisplayOptionsTitle' => 'Elementos a exibir',
        'DisplayOptionsAll' => 'Selecionar todos',
        'DisplayOptionsSearch' => 'Buscar',

        'GenresTitle' => 'Conversão de Gêneros',
        'GenresCategoryName' => 'Gênero a usar',
        'GenresCategoryMembers' => 'Gêneros a substituir',
        'GenresLoad' => 'Carregar uma lista',
        'GenresExport' => 'Exportar lista para arquivo',
        'GenresModify' => 'Editar conversão',

        'PropertiesName' => 'Nome da coleção',
        'PropertiesLang' => 'Language code',
        'PropertiesOwner' => 'Dono',
        'PropertiesEmail' => 'E-mail',
        'PropertiesDescription' => 'Descrição',
        'PropertiesFile' => 'Informação do arquivo',
        'PropertiesFilePath' => 'Caminho completo',
        'PropertiesItemsNumber' => 'Número de itens', # Accepts model codes
        'PropertiesFileSize' => 'Tamanho',
        'PropertiesFileSizeSymbols' => ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
        'PropertiesCollection' => 'Propriedades da coleção',
        'PropertiesDefaultPicture' => 'Default picture',

        'MailProgramsTitle' => 'Programas para enviar e-mails',
        'MailProgramsName' => 'Nome',
        'MailProgramsCommand' => 'Linha de comando',
        'MailProgramsRestore' => 'Restaurar padrões',
        'MailProgramsAdd' => 'Adicionar um programa',
        'MailProgramsInstructions' => 'Na linha de comandos, algumas substituições são feitas:
 %f será sustituído pelo e-mail do usuário.
 %t será sustituído pelo e-mail do destinatario.
 %s será sustituído pelo assunto da mensagem.
 %b será sustituído pelo corpo da mensagem.',

        'BookmarksBookmarks' => 'Favoritos',
        'BookmarksFolder' => 'Pastas',
        'BookmarksLabel' => 'Nome',
        'BookmarksPath' => 'Caminho',
        'BookmarksNewFolder' => 'Nova pasta',

        'AdvancedSearchType' => 'Tipo de busca',
        'AdvancedSearchTypeAnd' => 'Itens que cumpram todos os critérios', # Accepts model codes
        'AdvancedSearchTypeOr' => 'Itens que cumpram pelo menos um critério', # Accepts model codes
        'AdvancedSearchCriteria' => 'Critério',
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

        'DefaultValuesTip' => 'Values set in this window will be used as the default values when creating a new {lowercase1}',
    );
}
1;
