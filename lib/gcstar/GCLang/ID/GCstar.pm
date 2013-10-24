{
    package GCLang::ID;

    use utf8;
###################################################
#
#  Copyright 2005-2006 Tian
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

        'LangName' => 'Indonesia',
        
        'Separator' => ': ',
        
        'Warning' => '<b>Hati-hati</b>:
        
Information downloaded from web sites (through the 
search plugins) is for <b>personal use only</b>.

Any redistribution is forbidden without the site\'s
<b>explicit authorization</b>.

To determine which site owns the information, you
may use the <b>button below item details</b>.',
        
        'AllItemsFiltered' => 'Tidak ada yang cocok dengan kriteria pemilahan', # Accepts model codes
        
#Installation
        'InstallDirInfo' => 'Di install di ',
        'InstallMandatory' => 'Mandatory components',
        'InstallOptional' => 'Komponen Tambahan',
        'InstallErrorMissing' => 'Error : Komponen Perl berikut harus sudah terinstall: ',
        'InstallPrompt' => 'Direktori untuk instalasi [/usr/local]: ',
        'InstallEnd' => 'Akhir instalasi',
        'InstallNoError' => 'Tidak ada error',
        'InstallLaunch' => 'To use this application, one can launch ',
        'InstallDirectory' => 'Base direktori',
        'InstallTitle' => 'Instalasi GCstar',
        'InstallDependencies' => 'Dependencies',
        'InstallPath' => 'Path',
        'InstallOptions' => 'Opsi',
        'InstallSelectDirectory' => 'Select base directory for the installation',
        'InstallWithClean' => 'Remove files found in installation directory',
        'InstallWithMenu' => 'Add GCstar to Applications menu',
        'InstallNoPermission' => 'Error: You don\'t have permission to write in the selected directory',
        'InstallMissingMandatory' => 'Mandatory dependencies are missing. You won\'t be able to install GCstar until they have been added to your system.',
        'InstallMissingOptional' => 'Some optional dependencies are missing. There are listed under. GCstar may be installed but some features won\'t be available.',
        'InstallMissingNone' => 'There are no missing dependency. You may continue and install GCstar.',
        'InstallOK' => 'OK',
        'InstallMissing' => 'Hilang',
        'InstallMissingFor' => 'Missing for',
        'InstallCleanDirectory' => 'Removing GCstar\'s files in directory: ',
        'InstallCopyDirectory' => 'Mennyalin file di direktori: ',
        'InstallCopyDesktop' => 'Copying desktop file in: ',

#Update
        'UpdateUseProxy' => 'Proxy yang digunakan (tekan enter jika tidak ada): ',
        'UpdateNoPermission' => 'Write permission denied in this directory: ',
        'UpdateNone' => 'Tidak ada update yang ditemukan',
        'UpdateFileNotFound' => 'File tidak ditemukan',

#Splash
        'SplashInit' => 'Initialization',
        'SplashLoad' => 'Loading Collection',
        'SplashDisplay' => 'Memperlihatkan Koleksi',
        'SplashSort' => 'Mengurutkan Koleksi',
        'SplashDone' => 'Siap',

#Import from GCfilms
        'GCfilmsImportQuestion' => 'Sepertinya anda sebelumnya menggunakan GCfilms. Apakah anda mau mengimpor dari GCfilms ke GCstar (tidak akan mempengaruhi GCfilms jika anda masih ingin menggunakannya)?',
        'GCfilmsImportOptions' => 'Pengaturan',
        'GCfilmsImportData' => 'Daftar Film',

#Menus
        'MenuFile' => '_File',
            'MenuNewList' => '_Koleksi Baru',
            'MenuStats' => 'Statistics',
            'MenuHistory' => '_Recent Collections',
            'MenuLend' => 'Tampilkan _Item yang dipinjam', # Accepts model codes
            'MenuImport' => '_Import',	
            'MenuExport' => '_Export',
            'MenuAddItem' => '_Add Items', # Accepts model codes
    
        'MenuEdit'  => '_Ubah',
            'MenuDuplicate' => 'Du_plicate item', # Accepts model codes
            'MenuDuplicatePlural' => 'Du_plicate Items', # Accepts model codes
            'MenuEditSelectAllItems' => 'Select _All Items', # Accepts model codes
            'MenuEditDeleteCurrent' => '_Remove item', # Accepts model codes
            'MenuEditDeleteCurrentPlural' => '_Remove Items', # Accepts model codes    
            'MenuEditFields' => '_Change collection fields',
            'MenuEditLockItems' => '_Lock Collection',
    
        'MenuDisplay' => 'F_ilter',
            'MenuSavedSearches' => 'Simpan pencarian',
                'MenuSavedSearchesSave' => 'Simpan pencarian yang sekarang',
                'MenuSavedSearchesEdit' => 'Ubah simpanan pencarian',
            'MenuAdvancedSearch' => 'A_dvanced Search',
            'MenuViewAllItems' => 'Show _All items', # Accepts model codes
            'MenuNoFilter' => '_Any',
    
        'MenuConfiguration' => '_Settings',
            'MenuDisplayMenu' => 'Display',
                'MenuDisplayFullScreen' => 'Full screen',
                'MenuDisplayMenuBar' => 'Menus',
                'MenuDisplayToolBar' => 'Toolbar',
                'MenuDisplayStatusBar' => 'Bottom bar',
            'MenuDisplayOptions' => '_Displayed Information',
            'MenuBorrowers' => '_Borrowers',
            'MenuToolbarConfiguration' => '_Toolbar controls',
            'MenuDefaultValues' => 'Default values for new item', # Accepts model codes
            'MenuGenresConversion' => 'Genre _Conversion',
        
        'MenuBookmarks' => 'My _Collections',
            'MenuBookmarksAdd' => '_Add current collection',
            'MenuBookmarksEdit' => '_Edit bookmarked collections',

        'MenuHelp' => '_Help',
            'MenuHelpContent' => '_Content',
            'MenuAllPlugins' => 'Lihat _plugin',
            'MenuBugReport' => 'Report a _bug',
            'MenuAbout' => '_About GCstar',
    
        'MenuNewWindow' => 'Show item in _New Window', # Accepts model codes
        'MenuNewWindowPlural' => 'Show items in _New Window', # Accepts model codes
        
        'ContextExpandAll' => 'Expand all',
        'ContextCollapseAll' => 'Collapse all',
        'ContextChooseImage' => 'Choose _Image',
        'ContextOpenWith' => 'Open Wit_h',
        'ContextImageEditor' => 'Buka dengan pengedit gambar',
        'ContextImgFront' => 'Front',
        'ContextImgBack' => 'Back',
        'ContextChooseFile' => 'Choose a File',
        'ContextChooseFolder' => 'Choose a Folder',
        
        'DialogEnterNumber' => 'Please enter value',

        'RemoveConfirm' => 'Do you really want to remove this item?', # Accepts model codes
        'RemoveConfirmPlural' => 'Do you really want to remove these items?', # Accepts model codes
        'DefaultNewItem' => 'New item', # Accepts model codes
        'NewItemTooltip' => 'Add a new item', # Accepts model codes
        'NoItemFound' => 'Tidak menemukan apapun. Apa anda mau mencari di situs yang lain?',
        'OpenList' => 'Harap pilih koleksi',
        'SaveList' => 'Harap pilih lokasi penyimpanan koleksi',
        'SaveListTooltip' => 'Save current collection',
        'SaveUnsavedChanges' => 'There are unsaved changes in your collection. Do you want to save them?',
        'SaveDontSave' => 'Jangan disimpan',
        'PreferencesTooltip' => 'Set your preferences',
        'ViewTooltip' => 'Change collection display',
        'PlayTooltip' => 'Play video associated to the item', # Accepts model codes
        'PlayFileNotFound' => 'File to launch was not found in this location:',
        'PlayRetry' => 'Retry',

        'StatusSave' => 'Menyimpan...',
        'StatusLoad' => 'Membuka...',
        'StatusSearch' => 'Sedang mencari...',
        'StatusGetInfo' => 'Mengambil informasi...',
        'StatusGetImage' => 'Mengambil gambar...',
                
        'SaveError' => 'Cannot save items list. Please check access rights and disk free space.',
        'OpenError' => 'Cannot open items list. Please check access rights.',
		'OpenFormatError' => 'Cannot open items list. Format may be incorrect.',
        'OpenVersionWarning' => 'Koleksi dibuat menggunakan versi terbaru GCstar. Mungkin akan terjadi kerusakan data jika disimpan.',
        'OpenVersionQuestion' => 'Masih ingin melanjutkan ??',
        'ImageError' => 'Selected directory to save images is not correct. Please select another one.',
        'OptionsCreationError'=> 'Cannot create options file: ',
        'OptionsOpenError'=> 'Cannot open options file: ',
        'OptionsSaveError'=> 'Cannot save options file: ',
        'ErrorModelNotFound' => 'Model tidak ditemukan: ',
        'ErrorModelUserDir' => 'Model buatan pengguna ada di: ',
        
        'RandomTooltip' => 'What to see this evening ?',
        'RandomError'=> 'You have no item that could be selected', # Accepts model codes
        'RandomEnd'=> 'There are no more items', # Accepts model codes
        'RandomNextTip'=> 'Next suggestion',
        'RandomOkTip'=> 'Accept this item',
        
        'AboutTitle' => 'Tentang GCstar',
        'AboutDesc' => 'Collection manager',
        'AboutVersion' => 'Versi',
        'AboutTeam' => 'Tim',
        'AboutWho' => 'Christian Jodar (Tian): Manajer Proyek, Programmer
Nyall Dawson (Zombiepig): Programmer
TPF: Programmer
Adolfo González: Programmer
',
        'AboutLicense' => 'Distributed under the terms of the GNU GPL
Logos Copyright le Spektre',
        'AboutTranslation' => 'Terjemahan bahasa Ingrris oleh Yuda Nugrahadi',
        'AboutDesign' => 'Łukasz Kowalczk (Qoolman): Skin Designer
Logo dan desain web oleh le Spektre',

        'ToolbarRandom' => 'Malam ini',

        'UnsavedCollection' => 'Koleksi yang belum disimpan',
        'ModelsSelect' => 'Pilih tipe koleksi',
        'ModelsPersonal' => 'Personal models',
        'ModelsDefault' => 'Default models',
        'ModelsList' => 'Collection definition',
        'ModelSettings' => 'Collection settings',
        'ModelNewType' => 'Tipe koleksi baru',
        'ModelName' => 'Name of the collection type:',
		'ModelFields' => 'Fields',
		'ModelOptions'	=> 'Options',
		'ModelFilters'	=> 'Filters',
        'ModelNewField' => 'New field',
        'ModelFieldInformation' => 'Informasi',
        'ModelFieldName' => 'Label:',
        'ModelFieldType' => 'Tipe:',
        'ModelFieldGroup' => 'Grup:',
        'ModelFieldValues' => 'Values',
        'ModelFieldInit' => 'Default:',
        'ModelFieldMin' => 'Minimum:',
        'ModelFieldMax' => 'Maksimum:',
        'ModelFieldList' => 'Values list:',
        'ModelFieldListLegend' => '<i>Comma separated</i>',
        'ModelFieldDisplayAs' => 'Ditampilkan sebagai:',
        'ModelFieldDisplayAsText' => 'Teks',
        'ModelFieldDisplayAsGraphical' => 'Pengendali Rating',
        'ModelFieldTypeShortText' => 'Text pendek',
        'ModelFieldTypeLongText' => 'Text panjang',
        'ModelFieldTypeYesNo' => 'Ya/Tidak',
        'ModelFieldTypeNumber' => 'Nomor',
        'ModelFieldTypeDate' => 'Tanggal',
        'ModelFieldTypeOptions' => 'Pre-defined values list',
        'ModelFieldTypeImage' => 'Gambar',
        'ModelFieldTypeSingleList' => 'Daftar sederhana',
        'ModelFieldTypeFile' => 'File',
        'ModelFieldTypeFormatted' => 'Dependant on other fields',
        'ModelFieldParameters' => 'Parameter',
        'ModelFieldHasHistory' => 'Use an history',
        'ModelFieldFlat' => 'Tampilkan dalam satu baris',
        'ModelFieldStep' => 'Increment step:',
        'ModelFieldFileFormat' => 'Format file:',
        'ModelFieldFileFile' => 'File sederhana',
        'ModelFieldFileImage' => 'Gambar',
        'ModelFieldFileVideo' => 'Video',
        'ModelFieldFileAudio' => 'Audio',
        'ModelFieldFileProgram' => 'Program',
        'ModelFieldFileUrl' => 'URL',
        'ModelFieldFileEbook' => 'Ebook',
        'ModelOptionsFields' => 'Fields to use',
        'ModelOptionsFieldsAuto' => 'Otomatis',
        'ModelOptionsFieldsNone' => 'Tidak ada',
        'ModelOptionsFieldsTitle' => 'Sebagai judul',
        'ModelOptionsFieldsId' => 'Sebagai identifikasi',
        'ModelOptionsFieldsCover' => 'Sebagai cover',
        'ModelOptionsFieldsPlay' => 'For Play button',
        'ModelCollectionSettings' => 'Collection settings',
        'ModelCollectionSettingsLending' => 'Items could be borrowed',
        'ModelCollectionSettingsTagging' => 'Barang dapat diberi tag',
        'ModelFilterActivated' => 'Should be in search box',
        'ModelFilterComparison' => 'Perbandingan',
        'ModelFilterContain' => 'Berisi',
        'ModelFilterDoesNotContain' => 'Tidak mengandung kata',
        'ModelFilterRegexp' => 'Regular expression',
        'ModelFilterRange' => 'Range',
        'ModelFilterNumeric' => 'Comparison is numeric',
        'ModelFilterQuick' => 'Create a quick filter',
        'ModelTooltipName' => 'Use a name to re-use this model for many collections. If empty, the settings will be directly stored in the collection itself',
        'ModelTooltipLabel' => 'The field name as it will be displayed',
        'ModelTooltipGroup' => 'Used to group fields. Items with no value here will be in a default group',
        'ModelTooltipHistory' => 'Should the previous entered values be stored in a list associated to the field',
        'ModelTooltipFormat' => 'This format is used to determine the action to open the file with the Play button',
        'ModelTooltipLending' => 'This will add some fields to manage lendings',
        'ModelTooltipTagging' => 'Ini akan menambah tempat untu mengatur tag',
        'ModelTooltipNumeric' => 'Should the values be consider as numbers for comparison',
        'ModelTooltipQuick' => 'This will add a submenu in the Filters one',
        
        'ResultsTitle' => 'Select an item', # Accepts model codes
        'ResultsNextTip' => 'Cari di situs berikutnya',
        'ResultsPreview' => 'Pratayang',
        'ResultsInfo' => 'Anda dapat menambah barang lebih dari satu ke koleksi dengan menekan+tahan tombol Ctrl atau Shift dan pilih barang yang akan dimasukkan', # Accepts model codes
        
        'OptionsTitle' => 'Preferences',
		'OptionsExpertMode' => 'Expert Mode',
        'OptionsPrograms' => 'Tetapkan jenis aplikasi untuk digunakan oleh media yang berbeda, tinggalkan kosong untuk menggunakan konfigurasi dasar sistem',
        'OptionsBrowser' => 'Penjelajah web',
        'OptionsPlayer' => 'Video player',
        'OptionsAudio' => 'Audio player',
        'OptionsImageEditor' => 'Pengedit gambar',
        'OptionsCdDevice' => 'CD device',
        'OptionsImages' => 'Direktori gambar',
        'OptionsUseRelativePaths' => 'Use relative paths for images',
        'OptionsLayout' => 'Layout',
        'OptionsStatus' => 'Tampilkan status bar',
        'OptionsUseStars' => 'Use stars to display ratings',
        'OptionsWarning' => 'Peringatan: Perubahan pada tab ini tidak akan berpengaruh sampai aplikasi ini ditutup kemudian dibuka kembali.',
        'OptionsRemoveConfirm' => 'Ask confirmation before item deletion',
        'OptionsAutoSave' => 'Otomatis menyimpan koleksi',
        'OptionsAutoLoad' => 'Load previous collection on startup',
        'OptionsSplash' => 'Perlihatkan splash screen',
        'OptionsTearoffMenus' => 'Enable tear-off menus',
        'OptionsSpellCheck' => 'Gunakan pemeriksa bahasa untuk teks yang panjang',
        'OptionsProgramTitle' => 'Pilih program yang akan digunakan',
		'OptionsPlugins' => 'Situs untuk pengambilan data',
		'OptionsAskPlugins' => 'Tanya (Semua situs)',
		'OptionsPluginsMulti' => 'Banyak situs',
		'OptionsPluginsMultiAsk' => 'Tanya (Banyak situs)',
        'OptionsPluginsMultiPerField' => 'Banyak situs (per field)',
        'OptionsPluginsMultiPerFieldWindowTitle' => 'Many sites per field order selection',
        'OptionsPluginsMultiPerFieldDesc' => 'For each selected field we will return the first non empty information beginning from left',
        'OptionsPluginsMultiPerFieldFirst' => 'First',
        'OptionsPluginsMultiPerFieldLast' => 'Last',
        'OptionsPluginsMultiPerFieldRemove' => 'Remove',
        'OptionsPluginsMultiPerFieldClearSelected' => 'Empty selected field list',
		'OptionsPluginsList' => 'Set daftar',
        'OptionsAskImport' => 'Select fields to be imported',
		'OptionsProxy' => 'Menggunakan proxy',
		'OptionsCookieJar' => 'Use this cookie jar file',
        'OptionsLang' => 'Bahasa',
        'OptionsMain' => 'Utama',
        'OptionsPaths' => 'Lokasi',
        'OptionsInternet' => 'Internet',
        'OptionsConveniences' => 'Fitur',
        'OptionsDisplay' => 'Tampilan',
        'OptionsToolbar' => 'Toolbar',
        'OptionsToolbars' => {0 => 'Tidak ada', 1 => 'Kecil', 2 => 'Besar', 3 => 'System setting'},
        'OptionsToolbarPosition' => 'Posisi',
        'OptionsToolbarPositions' => {0 => 'Atas', 1 => 'Bawah', 2 => 'Kiri', 3 => 'Kanan'},
        'OptionsExpandersMode' => 'Expanders too long',
        'OptionsExpandersModes' => {'asis' => 'Do nothing', 'cut' => 'Cut', 'wrap' => 'Line wrap'},
        'OptionsDateFormat' => 'Date Format',
        'OptionsDateFormatTooltip' => 'Format is the one used by strftime(3). Default is %d/%m/%Y',
        'OptionsView' => 'Items list',
        'OptionsViews' => {0 => 'Teks', 1 => 'Gambar', 2 => 'Detail'},
        'OptionsColumns' => 'Kolom',
        'OptionsMailer' => 'E-mailer',
        'OptionsSMTP' => 'Server',
        'OptionsFrom' => 'e-mail anda',
        'OptionsTransform' => 'Place articles at the end of titles',
        'OptionsArticles' => 'Artikel (Dipisahkan koma)',
        'OptionsSearchStop' => 'Allow search to be aborted',
        'OptionsBigPics' => 'Use big pictures when available',
        'OptionsAlwaysOriginal' => 'Use main title as the original title if none present',
        'OptionsRestoreAccelerators' => 'Mengembalikan accelerators',
        'OptionsHistory' => 'Size of history',
        'OptionsClearHistory' => 'Clear history',
		'OptionsStyle' => 'Skin',
        'OptionsDontAsk' => 'Jangan bertanya lagi',
        'OptionsPathProgramsGroup' => 'Aplikasi',
        'OptionsProgramsSystem' => 'Use programs defined by system',
        'OptionsProgramsUser' => 'Use specified programs',
        'OptionsProgramsSet' => 'Set programs',
        'OptionsPathImagesGroup' => 'Gambar',
        'OptionsInternetDataGroup' => 'Data import',
        'OptionsInternetSettingsGroup' => 'Settings',
        'OptionsDisplayInformationGroup' => 'Information display',
        'OptionsDisplayArticlesGroup' => 'Artikel',
        'OptionsImagesDisplayGroup' => 'Display',
        'OptionsImagesStyleGroup' => 'Gaya',
        'OptionsDetailedPreferencesGroup' => 'Preferences',
        'OptionsFeaturesConveniencesGroup' => 'Kenyamanan',
        'OptionsPicturesFormat' => 'Prefiks yang digunakan untuk gambar:',
        'OptionsPicturesFormatInternal' => 'gcstar__',
        'OptionsPicturesFormatTitle' => 'Title or name of the associated item',
        'OptionsPicturesWorkingDir' => '%WORKING_DIR% or . will be replaced with collection directory (use only on beginning of path)',
        'OptionsPicturesFileBase' => '%FILE_BASE% will be replaced by collection file name without suffix (.gcs)',
        'OptionsPicturesWorkingDirError' => '%WORKING_DIR% could only be used on the beginning of the path for pictures',
        'OptionsConfigureMailers' => 'Configure mailing programs',

        'ImagesOptionsButton' => 'Seting',
        'ImagesOptionsTitle' => 'Settings for images list',
        'ImagesOptionsSelectColor' => 'Pilih warna',
        'ImagesOptionsUseOverlays' => 'Use image overlays',
        'ImagesOptionsBg' => 'Background',
        'ImagesOptionsBgPicture' => 'Use a background picture',
        'ImagesOptionsFg'=> 'Selection',
        'ImagesOptionsBgTooltip' => 'Change background color',
        'ImagesOptionsFgTooltip'=> 'Change selection color',
        'ImagesOptionsResizeImgList' => 'Automatically change number of columns',
        'ImagesOptionsAnimateImgList' => 'Use animations',
        'ImagesOptionsSizeLabel' => 'Ukuran',
        'ImagesOptionsSizeList' => {0 => 'Sangat Kecil', 1 => 'Kecil', 2 => 'Medium', 3 => 'Besar', 4 => 'Sangat besar'},
        'ImagesOptionsSizeTooltip' => 'Pilih ukuran gambar',
		        
        'DetailedOptionsTitle' => 'Settings for detailed list',
        'DetailedOptionsImageSize' => 'Ukuran gambar',
        'DetailedOptionsGroupItems' => 'Group items by',
        'DetailedOptionsSecondarySort' => 'Sort field for children',
		'DetailedOptionsFields' => 'Select fields to display',
        'DetailedOptionsGroupedFirst' => 'Keep together orphaned items',
        'DetailedOptionsAddCount' => 'Add number of elements on categories',

        'ExtractButton' => 'Informasi',
        'ExtractTitle' => 'Informasi file',
        'ExtractImport' => 'Use values',

        'FieldsListOpen' => 'Load a fields list from a file',
        'FieldsListSave' => 'Save fields list to a file',
        'FieldsListError' => 'This fields list cannot be used with this kind of collection',
        'FieldsListIgnore' => '--- Ignore',

        'ExportTitle' => 'Export item list',
        'ExportFilter' => 'Export only displayed items',
        'ExportFieldsTitle' => 'Fields to be exported',
        'ExportFieldsTip' => 'Select fields you want to export',
        'ExportWithPictures' => 'Copy pictures in a sub-directory',
        'ExportSortBy' => 'Sort by',
        'ExportOrder' => 'Urutan',

        'ImportListTitle' => 'Import another items list',
        'ImportExportData' => 'Data',
        'ImportExportFile' => 'File',
        'ImportExportFieldsUnused' => 'Unused fields',
        'ImportExportFieldsUsed' => 'Used fields',
        'ImportExportFieldsFill' => 'Tambahkan Semua',
        'ImportExportFieldsClear' => 'Hapus Semua',
        'ImportExportFieldsEmpty' => 'You must choose at least one field',
        'ImportExportFileEmpty' => 'You have to specify a file name',
        'ImportFieldsTitle' => 'Fields to be imported',
        'ImportFieldsTip' => 'Select fields you want to import',
        'ImportNewList' => 'Create a new collection',
        'ImportCurrentList' => 'Add to current collection',
        'ImportDropError' => 'There was an error opening at least one file. Previous list will be reloaded.',
        'ImportGenerateId' => 'Generate identifier for each item',

        'FileChooserOpenFile' => 'Please select file to use',
        'FileChooserDirectory' => 'Direktori',
        'FileChooserOpenDirectory' => 'Pilih direktori',
        'FileChooserOverwrite' => 'This file already exists. Do you want to overwrite it?',
        'FileAllFiles' => 'All Files',
        'FileVideoFiles' => 'Video Files',
        'FileEbookFiles' => 'Ebook Files',
        'FileAudioFiles' => 'Audio Files',
        'FileGCstarFiles' => 'GCstar Collections',

        #Some default panels
        'PanelCompact' => 'Compact',
        'PanelReadOnly' => 'Read Only',
        'PanelForm' => 'Tab',

        'PanelSearchButton' => 'Fetch Information',
        'PanelSearchTip' => 'Search web for information on this name',
        'PanelSearchContextChooseOne' => 'Choose a site ...',
        'PanelSearchContextMultiSite' => 'Use "Many sites"',
        'PanelSearchContextMultiSitePerField' => 'Use "Many sites per field"',
        'PanelSearchContextOptions' => 'Change options ...',
        'PanelImageTipOpen' => 'Click on the picture to select different one.',
        'PanelImageTipView' => 'Click on the picture to view it in real size.',
        'PanelImageTipMenu' => ' Right click for more options.',
        'PanelImageTitle' => 'Pilih gambar',
        'PanelImageNoImage' => 'Tidak ada gambar',
        'PanelSelectFileTitle' => 'Pilih sebuah file',
        'PanelLaunch' => 'Launch',        
        'PanelRestoreDefault' => 'Restore default',
        'PanelRefresh' => 'Update',
        'PanelRefreshTip' => 'Update information from web',

        'PanelFrom' =>'Dari',
        'PanelTo' =>'Ke',

        'PanelWeb' => 'View Information',
        'PanelWebTip' => 'View information on the web about this item', # Accepts model codes
        'PanelRemoveTip' => 'Remove current item', # Accepts model codes

        'PanelDateSelect' => 'Select a Date',
        'PanelNobody' => 'Nobody',
        'PanelUnknown' => 'Tidak diketahui',
        'PanelAdded' => 'Add date',
        'PanelRating' => 'Rating',
        'PanelPressRating' => 'Press Rating',
        'PanelLocation' => 'Location',

        'PanelLending' => 'Lending',
        'PanelBorrower' => 'Peminjam',
        'PanelLendDate' => 'Keluar sejak',
        'PanelHistory' => 'Sejarah peminjaman',
        'PanelReturned' => 'Barang dikembalikan', # Accepts model codes
        'PanelReturnDate' => 'Tanggal pengembalian',
        'PanelLendedYes' => 'Lended',
        'PanelLendedNo' => 'Tersedia',

        'PanelTags' => 'Tags',
        'PanelFavourite' => 'Favorit',
        'TagsAssigned' => 'Assigned Tags', 

        'PanelUser' => 'User fields',

        'CheckUndef' => 'Either',
        'CheckYes' => 'Ya',
        'CheckNo' => 'Tidak',

        'ToolbarAll' => 'Lihat Semua',
        'ToolbarAllTooltip' => 'View all items',
        'ToolbarGroupBy' => 'Group by',
        'ToolbarGroupByTooltip' => 'Select the field to use to group items in list',
        'ToolbarQuickSearch' => 'Pencarian cepat',
        'ToolbarQuickSearchLabel' => 'Pencarian',
        'ToolbarQuickSearchTooltip' => 'Pilih bagian yang akan dicari. masukkan kata yang dicari kemudian tekan enter',
        'ToolbarSeparator' => ' Separator',
        
        'PluginsTitle' => 'Search an item',
        'PluginsQuery' => 'Query',
        'PluginsFrame' => 'Search site',
        'PluginsLogo' => 'Logo',
        'PluginsName' => 'Nama',
        'PluginsSearchFields' => 'Search fields',
        'PluginsAuthor' => 'Author',
        'PluginsLang' => 'Bahasa',
        'PluginsUseSite' => 'Gunakan situs yang dipilih untuk pencarian seterusnya',
        'PluginsPreferredTooltip' => 'Site recommended by GCstar',
        'PluginDisabled' => 'Disabled',

        'BorrowersTitle' => 'Borrower Configuration',
        'BorrowersList' => 'Peminjam',
        'BorrowersName' => 'Nama',
        'BorrowersEmail' => 'E-mail',
        'BorrowersAdd' => 'Tambah',
        'BorrowersRemove' => 'Mengurangi',
        'BorrowersEdit' => 'Edit',
        'BorrowersTemplate' => 'Mail template',
        'BorrowersSubject' => 'Mail subject',
        'BorrowersNotice1' => '%1 will be replaced with the borrower\'s name',
        'BorrowersNotice2' => '%2 will be replaced with the item title',
        'BorrowersNotice3' => '%3 will be replaced with the borrow date',

        'BorrowersImportTitle' => 'Import borrowers information',
        'BorrowersImportType' => 'Format file:',
        'BorrowersImportFile' => 'File:',

        'BorrowedTitle' => 'Barang yang dipinjam', # Accepts model codes
        'BorrowedDate' => 'Sejak',
        'BorrowedDisplayInPanel' => 'Show item in main window', # Accepts model codes

        'MailTitle' => 'Send an e-mail',
        'MailFrom' => 'Dari: ',
        'MailTo' => 'Kepada: ',
        'MailSubject' => 'Subjek: ',
        'MailSmtpError' => 'Problem when connecting to SMTP server',
        'MailSendmailError' => 'Problem when launching sendmail',

        'SearchTooltip' => 'Search all items', # Accepts model codes
        'SearchTitle' => 'Item Search', # Accepts model codes
        'SearchNoField' => 'No field have been selected for the search box.
Add some of them in the Filters tab of the collection settings.',

        'QueryReplaceField' => 'Field to replace',
        'QueryReplaceOld' => 'Current value',
        'QueryReplaceNew' => 'New value',
        'QueryReplaceLaunch' => 'Replace',
        
        'ImportWindowTitle' => 'Select Fields to be Imported',
        'ImportViewPicture' => 'View picture',
        'ImportSelectAll' => 'Select all',
        'ImportSelectNone' => 'Select none',

        'MultiSiteTitle' => 'Sites to use for searches',
        'MultiSiteUnused' => 'Unused plugins',
        'MultiSiteUsed' => 'Plugins to be used',
        'MultiSiteLang' => 'Fill list with English plugins',
        'MultiSiteEmptyError' => 'You have an empty site list',
        'MultiSiteClear' => 'Clear list',
        
        'DisplayOptionsTitle' => 'Items to display',
        'DisplayOptionsAll' => 'Select all',
        'DisplayOptionsSearch' => 'Search button',

        'GenresTitle' => 'Genre Conversion',
        'GenresCategoryName' => 'Genre to use',
        'GenresCategoryMembers' => 'Genre to replace',
        'GenresLoad' => 'Load a list',
        'GenresExport' => 'Save list to a file',
        'GenresModify' => 'Edit conversion',

        'PropertiesName' => 'Collection name',
        'PropertiesLang' => 'Kode bahasa',
        'PropertiesOwner' => 'Owner',
        'PropertiesEmail' => 'Email',
        'PropertiesDescription' => 'Description',
        'PropertiesFile' => 'File Information',
        'PropertiesFilePath' => 'Full path',
        'PropertiesItemsNumber' => 'Number of items', # Accepts model codes
        'PropertiesFileSize' => 'Size',
        'PropertiesFileSizeSymbols' => ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
        'PropertiesCollection' => 'Collection properties',
        'PropertiesDefaultPicture' => 'Default picture',

        'MailProgramsTitle' => 'Programs for mail sending',
        'MailProgramsName' => 'Name',
        'MailProgramsCommand' => 'Command line',
        'MailProgramsRestore' => 'Restore defaults',
        'MailProgramsAdd' => 'Add a program',
        'MailProgramsInstructions' => 'In command line, some substitutions are made:
 %f is replaced with user\'s e-mail address.
 %t is replaced with the recipient address.
 %s is replaced with the subject of the message.
 %b is replaced with the body of the message.',

        'BookmarksBookmarks' => 'Bookmarks',
        'BookmarksFolder' => 'Folders',
        'BookmarksLabel' => 'Label',
        'BookmarksPath' => 'Path',
        'BookmarksNewFolder' => 'New folder',

        'AdvancedSearchType' => 'Type of search',
        'AdvancedSearchTypeAnd' => 'Items matching all criteria', # Accepts model codes
        'AdvancedSearchTypeOr' => 'Items matching at least one criterion', # Accepts model codes
        'AdvancedSearchCriteria' => 'Criteria',
        'AdvancedSearchAnyField' => 'Any field',
        'AdvancedSearchSaveTitle' => 'Simpan pencarian',
        'AdvancedSearchSaveName' => 'Nama',
        'AdvancedSearchSaveOverwrite' => 'A saved search already exists with that name. Please use a different one.',
        'AdvancedSearchUseCase' => 'Case sensitive',
        'AdvancedSearchIgnoreDiacritics' => 'Ignore accents and other diacritics',
 
        'BugReportSubject' => 'Laporan kerusakan dibuat dari GCstar',
        'BugReportVersion' => 'Versi',
        'BugReportPlatform' => 'Sistem operasi',
        'BugReportMessage' => 'Pesan error',
        'BugReportInformation' => 'Informasi tambahan',

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
