{
    package GCLang::TR;

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
# Turkish Language File, v.2
# KaraGarga, 17/07/2006
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

        'LangName' => 'Türkçe',
        
        'Separator' => ': ',
        
        'Warning' => '<b>Dikkat!</b>:
        
Eklentiler aracılığıyla diğer sitelerden indirilen bilgiler 
sadece <b>kişisel amaçlar için</b> kullanılmalıdır.

Bu bilgilerin, ilgili sitenin izni olmaksızın dağıtımı
<b>yasaktır</b>.

Bilginin hangi siteden alındığını <b>film detaylarının altındaki link düğmesinden öğrenebilirsiniz.</b>.',
        
        'AllItemsFiltered' => 'Aradığınız anahtar sözcükle ilişkili bir film bulunamadı.', # Accepts model codes
        
#Installation
        'InstallDirInfo' => 'Kurulum klasörü ',
        'InstallMandatory' => 'Gerekli Bileşenler',
        'InstallOptional' => 'Diğer Bileşenler',
        'InstallErrorMissing' => 'Hata : Aşağıdaki Perl bileşenini kurmalısınız: ',
        'InstallPrompt' => 'Yazılımın kurulacağı klasör [/usr/local]: ',
        'InstallEnd' => 'Kurulumun sonu',
        'InstallNoError' => 'Hata Yok',
        'InstallLaunch' => 'Bu yazılımı kullanmak için, şunu başlatmalısınız ',
        'InstallDirectory' => 'Ana klasör',
        'InstallTitle' => 'GCstar kurulumu',
        'InstallDependencies' => 'Bağımlı bileşenler',
        'InstallPath' => 'Dizin',
        'InstallOptions' => 'Seçenekler',
        'InstallSelectDirectory' => 'Kurulum için bir ana klasör seçiniz',
        'InstallWithClean' => 'Kurulum dizinindeki dosyaları temizle',
        'InstallWithMenu' => 'GCstar yazılımını Programlar menüsüne ekle',
        'InstallNoPermission' => 'Hata: Seçtiğiniz klasöre yazma hakkınız yok',
        'InstallMissingMandatory' => 'Zorunlu bileşenler eksik. Bu bileşenleri kurmadan GCstar yazılımını kullanamazsınız.',
        'InstallMissingOptional' => 'Bazı seçimlik bileşenler eksik. Bu bileşenler aşağıda listelenmiştir. GCstar yazılımını kurabilirsiniz ancak bu bileşenler olmadan bazı özelliklerini kullanmayabilirsiniz.',
        'InstallMissingNone' => 'Eksik bağımlı bileşen yok. GCstar yazılımını kurmaya devam edebilirsiniz.',
        'InstallOK' => 'Tamam',
        'InstallMissing' => 'Eksik',
        'InstallMissingFor' => 'Eksikler',
        'InstallCleanDirectory' => 'Removing GCstar\'s files in directory: ',
        'InstallCopyDirectory' => 'Copying files in directory: ',
        'InstallCopyDesktop' => 'Copying desktop file in: ',

#Update
        'UpdateUseProxy' => 'Kullanılacak Proxy (emin değilseniz sadece entere basınız): ',
        'UpdateNoPermission' => 'Bu klasöre yazma hakkınız yok ya da reddedildi: ',
        'UpdateNone' => 'Herhangi bir güncelleme bulunamadı.',
        'UpdateFileNotFound' => 'Dosya bulunamadı',

#Splash
    	'SplashInit' => 'Program açılıyor...',
    	'SplashLoad' => 'Veritabanı yükleniyor...',
        'SplashDisplay' => 'Displaying Collection',
        'SplashSort' => 'Sorting Collection',
    	'SplashDone' => 'Hazır.',

#Import from GCfilms
        'GCfilmsImportQuestion' => 'Daha önce GCfilms yazılımını kullanıyordunuz. Bu yazılımdaki verileri otomatik almak ister misiniz? (bu seçenk GCfilms yazılımını kullanmanızı etkilemeyecektir.)',
        'GCfilmsImportOptions' => 'Ayarlar',
        'GCfilmsImportData' => 'Film Listesi',

#Menus
        'MenuFile' => '_Dosya',
            'MenuNewList' => '_Yeni Kolleksiyon',
            'MenuStats' => 'Statistics',
            'MenuHistory' => '_Son Kullanılanlar',
            'MenuLend' => 'Ö_dünç Verilenler', # Accepts model codes
            'MenuImport' => '_Al',	
            'MenuExport' => '_Ver',
            'MenuAddItem' => '_Add Items', # Accepts model codes
    
        'MenuEdit'  => 'Düz_enle',
            'MenuDuplicate' => '_Kopyasını oluştur', # Accepts model codes
            'MenuDuplicatePlural' => 'Du_plicate Items', # Accepts model codes
            'MenuEditSelectAllItems' => 'Select _All Items', # Accepts model codes
            'MenuEditDeleteCurrent' => '_Sil', # Accepts model codes
            'MenuEditDeleteCurrentPlural' => '_Remove Items', # Accepts model codes  
            'MenuEditFields' => '_Change collection fields',
            'MenuEditLockItems' => '_Veritabanını kilitle',
    
        'MenuDisplay' => '_Filtrele',
            'MenuSavedSearches' => 'Saved searches',
                'MenuSavedSearchesSave' => 'Save current search',
                'MenuSavedSearchesEdit' => 'Modify saved searches',
            'MenuAdvancedSearch' => 'A_dvanced Search',
            'MenuViewAllItems' => 'Tümünü Göste', # Accepts model codes
            'MenuNoFilter' => '_Hepsi',
    
        'MenuConfiguration' => '_Ayarlar',
            'MenuDisplayMenu' => 'Display',
                'MenuDisplayFullScreen' => 'Full screen',
                'MenuDisplayMenuBar' => 'Menus',
                'MenuDisplayToolBar' => 'Toolbar',
                'MenuDisplayStatusBar' => 'Bottom bar',
            'MenuDisplayOptions' => '_Bilgi Alanları',
            'MenuBorrowers' => '_Ödünç Alanlar',
            'MenuToolbarConfiguration' => '_Toolbar controls',
            'MenuDefaultValues' => 'Default values for new item', # Accepts model codes
            'MenuGenresConversion' => '_Tür Çevrimi',
        
        'MenuBookmarks' => 'My _Collections',
            'MenuBookmarksAdd' => '_Add current collection',
            'MenuBookmarksEdit' => '_Edit bookmarked collections',

        'MenuHelp' => '_Yardım',
            'MenuHelpContent' => '_Yardım',
            'MenuAllPlugins' => 'View _plugins',
            'MenuBugReport' => 'Report a _bug',
            'MenuAbout' => 'GCstar _Hakkında',
    
        'MenuNewWindow' => '_Yeni Pencerede Göster', # Accepts model codes
        'MenuNewWindowPlural' => 'Show Items in _New Window', # Accepts model codes
        
        'ContextExpandAll' => 'Hepsini Aç',
        'ContextCollapseAll' => 'Hepsini Kapa',
        'ContextChooseImage' => 'Choose _Image',
        'ContextOpenWith' => 'Open Wit_h',
        'ContextImageEditor' => 'Image Editor',
        'ContextImgFront' => 'Front',
        'ContextImgBack' => 'Back',
        'ContextChooseFile' => 'Choose a File',
        'ContextChooseFolder' => 'Choose a Folder',
        
        'DialogEnterNumber' => 'Lütfen bir değer giriniz',

        'RemoveConfirm' => 'Bu başlığı silmek istediğinize emin misiniz?', # Accepts model codes
        'RemoveConfirmPlural' => 'Do you really want to remove these items?', # Accepts model codes
        'DefaultNewItem' => 'New item', # Accepts model codes
        'NewItemTooltip' => 'Yeni başlık eklemek için tıklayın', # Accepts model codes
        'NoItemFound' => 'Aradığınız başlık bulunamadı. Başka bir siteden arama yapmak ister misiniz?',
        'OpenList' => 'Lütfen bir veritabanı seçin',
        'SaveList' => 'Listeyi nereye kaydedeceğiniz seçiniz',
        'SaveListTooltip' => 'Açık olan veritabanını kaydetmek için tıklayınız',
        'SaveUnsavedChanges' => 'There are unsaved changes in your collection. Do you want to save them?',
        'SaveDontSave' => 'Don\'t save',
        'PreferencesTooltip' => 'Ayarları yapmak için tıklayınız',
        'ViewTooltip' => 'Koleksiyonun görsel ayarlarını değiştirir',
        'PlayTooltip' => 'Dosyayı lişkilendirilmiş oynatıcı ile başlatır', # Accepts model codes
        'PlayFileNotFound' => 'File to launch was not found in this location:',
        'PlayRetry' => 'Retry',

        'StatusSave' => 'Saving...',
        'StatusLoad' => 'Loading...',
        'StatusSearch' => 'Aranıyor...',
        'StatusGetInfo' => 'Bilgiler alınıyor...',
        'StatusGetImage' => 'Kapak alınıyor...',
                
        'SaveError' => 'GCStar Koleksiyonu kaydedilemiyor. Erişim engelleri ve boş alan kontrolü yapınız.',
        'OpenError' => 'GCStar Koleksiyonu açamıyor. Dosyanın erişim izinlerini kontrol ediniz.',
		'OpenFormatError' => 'Koleksiyonu açamıyor.',
        'OpenVersionWarning' => 'Collection was created with a more recent version of GCstar. If you save it, you may loose some data.',
        'OpenVersionQuestion' => 'Do you still want to continue?',
        'ImageError' => 'Kapak dosyaları için seçtiğiniz klasör yanlış. Lütfen başka bir klasör seçiniz.',
        'OptionsCreationError'=> 'Ayar dosyası oluşturulamıyor: ',
        'OptionsOpenError'=> 'Ayar dosyası açılamıyor: ',
        'OptionsSaveError'=> 'Ayar dosyası kaydedilemiyor: ',
        'ErrorModelNotFound' => 'Model not found: ',
        'ErrorModelUserDir' => 'User defined models are in: ',
        
        'RandomTooltip' => 'Bana öneride bulun. Rastgele dosya seçer.',
        'RandomError'=> 'Tüm başlıkları izlemişsiniz ya da veritanında başlık yok.', # Accepts model codes
        'RandomEnd'=> 'Tüm başlıkları izlemişsiniz. Başka başlık kalmadı.', # Accepts model codes
        'RandomNextTip'=> 'Bir Sonraki Öneri',
        'RandomOkTip'=> 'Tamam bu iyi',
        
        'AboutTitle' => 'GCstar Hakkında',
        'AboutDesc' => 'Veritabanı Yöneticisi',
        'AboutVersion' => 'Sürüm',
        'AboutTeam' => 'Takım',
        'AboutWho' => 'Christian Jodar (Tian): Proje Yöneticisi, Programcı
Nyall Dawson (Zombiepig): Programcı
TPF: Programcı
Adolfo González: Programcı
',
        'AboutLicense' => 'GNU GPL lisansı altında dağıtılmaktadır
Logoların telif hakları le Spektre',
        'AboutTranslation' => 'Türkçe çeviri KaraGarga\'ya aittir',
        'AboutDesign' => 'Łukasz Kowalczk (Qoolman): Skin Designer
Logo ve webtasarımı: le Spektre',

        'ToolbarRandom' => 'Gece',

        'UnsavedCollection' => 'Unsaved Collection',
        'ModelsSelect' => 'Bir koleksiyon türü seçiniz',
        'ModelsPersonal' => 'Personal models',
        'ModelsDefault' => 'Default models',
        'ModelsList' => 'Koleksiyon Türleri',
        'ModelSettings' => 'Collection settings',
        'ModelNewType' => 'New collection type',
        'ModelName' => 'Name of the collection type:',
		'ModelFields' => 'Fields',
		'ModelOptions'	=> 'Options',
		'ModelFilters'	=> 'Filters',
        'ModelNewField' => 'New field',
        'ModelFieldInformation' => 'Information',
        'ModelFieldName' => 'Label:',
        'ModelFieldType' => 'Type:',
        'ModelFieldGroup' => 'Group:',
        'ModelFieldValues' => 'Values',
        'ModelFieldInit' => 'Default:',
        'ModelFieldMin' => 'Minimum:',
        'ModelFieldMax' => 'Maximum:',
        'ModelFieldList' => 'Values list:',
        'ModelFieldListLegend' => '<i>Comma separated</i>',
        'ModelFieldDisplayAs' => 'Display as:',
        'ModelFieldDisplayAsText' => 'Text',
        'ModelFieldDisplayAsGraphical' => 'Rating Control',
        'ModelFieldTypeShortText' => 'Short text',
        'ModelFieldTypeLongText' => 'Long text',
        'ModelFieldTypeYesNo' => 'Yes/No',
        'ModelFieldTypeNumber' => 'Number',
        'ModelFieldTypeDate' => 'Date',
        'ModelFieldTypeOptions' => 'Pre-defined values list',
        'ModelFieldTypeImage' => 'Image',
        'ModelFieldTypeSingleList' => 'Simple list',
        'ModelFieldTypeFile' => 'File',
        'ModelFieldTypeFormatted' => 'Dependant on other fields',
        'ModelFieldParameters' => 'Parameters',
        'ModelFieldHasHistory' => 'Use an history',
        'ModelFieldFlat' => 'Display on one line',
        'ModelFieldStep' => 'Increment step:',
        'ModelFieldFileFormat' => 'File format:',
        'ModelFieldFileFile' => 'Simple file',
        'ModelFieldFileImage' => 'Image',
        'ModelFieldFileVideo' => 'Video',
        'ModelFieldFileAudio' => 'Audio',
        'ModelFieldFileProgram' => 'Program',
        'ModelFieldFileUrl' => 'URL',
        'ModelFieldFileEbook' => 'Ebook',
        'ModelOptionsFields' => 'Fields to use',
        'ModelOptionsFieldsAuto' => 'Automatic',
        'ModelOptionsFieldsNone' => 'None',
        'ModelOptionsFieldsTitle' => 'As title',
        'ModelOptionsFieldsId' => 'As identifier',
        'ModelOptionsFieldsCover' => 'As cover',
        'ModelOptionsFieldsPlay' => 'For Play button',
        'ModelCollectionSettings' => 'Collection settings',
        'ModelCollectionSettingsLending' => 'Items could be borrowed',
        'ModelCollectionSettingsTagging' => 'Items can be tagged',
        'ModelFilterActivated' => 'Should be in search box',
        'ModelFilterComparison' => 'Comparison',
        'ModelFilterContain' => 'Contains',
        'ModelFilterDoesNotContain' => 'Does not contain',
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
        'ModelTooltipTagging' => 'This will add some fields to manage tags',
        'ModelTooltipNumeric' => 'Should the values be consider as numbers for comparison',
        'ModelTooltipQuick' => 'This will add a submenu in the Filters one',
        
        'ResultsTitle' => 'Bir başlık seçiniz', # Accepts model codes
        'ResultsNextTip' => 'Bir sonraki sitede ara',
        'ResultsPreview' => 'Preview',
        'ResultsInfo' => 'You can add multiple items to the collection by holding down the Ctrl or the Shift key and selecting them', # Accepts model codes
        
        'OptionsTitle' => 'Ayarlar',
		'OptionsExpertMode' => 'Expert Mode',
        'OptionsPrograms' => 'Specify applications to use for different media, leave blank to use system defaults',
        'OptionsBrowser' => 'Web tarayıcı',
        'OptionsPlayer' => 'Video oynatıcı',
        'OptionsAudio' => 'Audio oynatıcı',
        'OptionsImageEditor' => 'Image editor',
        'OptionsCdDevice' => 'CD device',
        'OptionsImages' => 'Kapak klasörü',
        'OptionsUseRelativePaths' => 'Kapak resimleri için değişken dizin yapısı kullan',
        'OptionsLayout' => 'Başlık Bilgileri Paneli',
        'OptionsStatus' => 'Durum barını göster',
        'OptionsUseStars' => 'Use stars to display ratings',
        'OptionsWarning' => 'Dikkat: Bu alandaki değişikleri uygulamak için yazılımı tekrar başlatmalısınız.',
        'OptionsRemoveConfirm' => 'Başlık silmeden önce onay iste',
        'OptionsAutoSave' => 'Veritabanını otomatik olarak kaydet',
        'OptionsAutoLoad' => 'Load previous collection on startup',
        'OptionsSplash' => 'Başlangıç ekranını göster',
        'OptionsTearoffMenus' => 'Enable tear-off menus',
        'OptionsSpellCheck' => 'Use spelling checker for long text fields',
        'OptionsProgramTitle' => 'Bir Program Seçiniz',
		'OptionsPlugins' => 'Bilginin alınacağı siteyi seçiniz',
		'OptionsAskPlugins' => 'Sor (Tüm Siteler)',
		'OptionsPluginsMulti' => 'Seçtiğim Siteler',
		'OptionsPluginsMultiAsk' => 'Sor (Seçtiğim Siteler)',
        'OptionsPluginsMultiPerField' => 'Seçtiğim Siteler (per field)',
        'OptionsPluginsMultiPerFieldWindowTitle' => 'Many sites per field order selection',
        'OptionsPluginsMultiPerFieldDesc' => 'For each selected field we will return the first non empty information beginning from left',
        'OptionsPluginsMultiPerFieldFirst' => 'First',
        'OptionsPluginsMultiPerFieldLast' => 'Last',
        'OptionsPluginsMultiPerFieldRemove' => 'Remove',
        'OptionsPluginsMultiPerFieldClearSelected' => 'Empty selected field list',
		'OptionsPluginsList' => 'Listeyi oluşturun',
        'OptionsAskImport' => 'Alınacak bilgi alanları',
		'OptionsProxy' => 'Proxy Kullan',
		'OptionsCookieJar' => 'Use this cookie jar file',
        'OptionsLang' => 'Dil',
        'OptionsMain' => 'Genel',
        'OptionsPaths' => 'Dizin',
        'OptionsInternet' => 'Internet',
        'OptionsConveniences' => 'Diğer',
        'OptionsDisplay' => 'Görsel',
        'OptionsToolbar' => 'Menü',
        'OptionsToolbars' => {0 => 'Yok', 1 => 'Küçük', 2 => 'Büyük', 3 => 'System setting'},
        'OptionsToolbarPosition' => 'Konum',
        'OptionsToolbarPositions' => {0 => 'Üst', 1 => 'Alt', 2 => 'Sol', 3 => 'Sağ'},
        'OptionsExpandersMode' => 'Expanders too long',
        'OptionsExpandersModes' => {'asis' => 'Do nothing', 'cut' => 'Cut', 'wrap' => 'Line wrap'},
        'OptionsDateFormat' => 'Date Format',
        'OptionsDateFormatTooltip' => 'Format is the one used by strftime(3). Default is %d/%m/%Y',
        'OptionsView' => 'Film Listesi',
        'OptionsViews' => {0 => 'Başlık Adları', 1 => 'Kapak', 2 => 'Detay'},
        'OptionsColumns' => 'Kolonlar',
        'OptionsMailer' => 'E-posta istemcisi',
        'OptionsSMTP' => 'Sunucu',
        'OptionsFrom' => 'E-posta adresiniz',
        'OptionsTransform' => 'Aşağıdaki öbekleri film adının sonuna koy',
        'OptionsArticles' => 'Öbekler (virgülle ayrılmış)',
        'OptionsSearchStop' => 'Aramanın durdurulmasını sağlar',
        'OptionsBigPics' => 'Use big pictures when available',
        'OptionsAlwaysOriginal' => 'Başlık için özgün ad yoksa kendi adını kullan',
        'OptionsRestoreAccelerators' => 'Restore accelerators',
        'OptionsHistory' => 'Geçmiş dosya kısıtlaması',
        'OptionsClearHistory' => 'Geçmişi temizle',
		'OptionsStyle' => 'Arayüz',
        'OptionsDontAsk' => 'Bir daha sorma',
        'OptionsPathProgramsGroup' => 'Yazılımlar',
        'OptionsProgramsSystem' => 'Use programs defined by system',
        'OptionsProgramsUser' => 'Use specified programs',
        'OptionsProgramsSet' => 'Set programs',
        'OptionsPathImagesGroup' => 'Resimler',
        'OptionsInternetDataGroup' => 'Veri alma',
        'OptionsInternetSettingsGroup' => 'Ayarlar',
        'OptionsDisplayInformationGroup' => 'Bilgi gösterimi',
        'OptionsDisplayArticlesGroup' => 'Articles',
        'OptionsImagesDisplayGroup' => 'Görsel',
        'OptionsImagesStyleGroup' => 'Stil',
        'OptionsDetailedPreferencesGroup' => 'Seçenekler',
        'OptionsFeaturesConveniencesGroup' => 'Conveniences',
        'OptionsPicturesFormat' => 'Prefix to use for pictures:',
        'OptionsPicturesFormatInternal' => 'gcstar__',
        'OptionsPicturesFormatTitle' => 'Title or name of the associated item',
        'OptionsPicturesWorkingDir' => '%WORKING_DIR% or . will be replaced with collection directory (use only on beginning of path)',
        'OptionsPicturesFileBase' => '%FILE_BASE% will be replaced by collection file name without suffix (.gcs)',
        'OptionsPicturesWorkingDirError' => '%WORKING_DIR% could only be used on the beginning of the path for pictures',
        'OptionsConfigureMailers' => 'Configure mailing programs',

        'ImagesOptionsButton' => 'Ayarlar',
        'ImagesOptionsTitle' => 'Kağak listesi için ayarlar',
        'ImagesOptionsSelectColor' => 'Renk seçiniz',
        'ImagesOptionsUseOverlays' => 'Use image overlays',
        'ImagesOptionsBg' => 'Arkaplan',
        'ImagesOptionsBgPicture' => 'Arkaplan resmi kullan',
        'ImagesOptionsFg'=> 'Seçim',
        'ImagesOptionsBgTooltip' => 'Arkaplanı değiştir',
        'ImagesOptionsFgTooltip'=> 'Seçili alan rengini değiştir',
        'ImagesOptionsResizeImgList' => 'Automatically change number of columns',
        'ImagesOptionsAnimateImgList' => 'Use animations',
        'ImagesOptionsSizeLabel' => 'Boyut',
        'ImagesOptionsSizeList' => {0 => 'Minik', 1 => 'Küçük', 2 => 'Orta', 3 => 'Büyük', 4 => 'Devasa'},
        'ImagesOptionsSizeTooltip' => 'Resim boyutu seçiniz',
		        
        'DetailedOptionsTitle' => 'Detaylı liste için ayarlar',
        'DetailedOptionsImageSize' => 'Kapak boyutu',
        'DetailedOptionsGroupItems' => 'Filmleri Koleksiyon türüne göre sınıflandır',
        'DetailedOptionsSecondarySort' => 'Sort field for children',
		'DetailedOptionsFields' => 'Gösterilecek alanları seçiniz',
        'DetailedOptionsGroupedFirst' => 'Keep together orphaned items',
        'DetailedOptionsAddCount' => 'Add number of elements on categories',

        'ExtractButton' => 'Bilgi',
        'ExtractTitle' => 'Video Bilgisi',
        'ExtractImport' => 'Bu değerleri kullan',

        'FieldsListOpen' => 'Load a fields list from a file',
        'FieldsListSave' => 'Save fields list to a file',
        'FieldsListError' => 'This fields list cannot be used with this kind of collection',
        'FieldsListIgnore' => '--- Ignore',

        'ExportTitle' => 'Film listesini ver',
        'ExportFilter' => 'Sadece seçili filmleri ver',
        'ExportFieldsTitle' => 'Verilecek alanlar',
        'ExportFieldsTip' => 'Aktarılacak alanları seçiniz',
        'ExportWithPictures' => 'Kapak resimlerini bir alt klasöre kopyala',
        'ExportSortBy' => 'Sort by',
        'ExportOrder' => 'Order',

        'ImportListTitle' => 'Diğer bir film listesinden aktar',
        'ImportExportData' => 'Data',
        'ImportExportFile' => 'Dosya',
        'ImportExportFieldsUnused' => 'Kullanılmayacak alanlar',
        'ImportExportFieldsUsed' => 'Kullanılacak alanlar',
        'ImportExportFieldsFill' => 'Tümüün Ekle',
        'ImportExportFieldsClear' => 'Tümünü Sil',
        'ImportExportFieldsEmpty' => 'En az bir alan seçmelisiniz',
        'ImportExportFileEmpty' => 'Dosya adı belirlemelisiniz',
        'ImportFieldsTitle' => 'Alınacak Alanlar',
        'ImportFieldsTip' => 'Alınacak alanları seçiniz',
        'ImportNewList' => 'Yeni veritabanı oluştur',
        'ImportCurrentList' => 'Açık olan veritabanına aktar',
        'ImportDropError' => 'Dosyanın açılmasında sorun çıktı. Bir önceki veritabanı yüklenecek.',
        'ImportGenerateId' => 'Generate identifier for each item',

        'FileChooserOpenFile' => 'Lütfen bir dosya seçiniz',
        'FileChooserDirectory' => 'Directory',
        'FileChooserOpenDirectory' => 'Bir Klasör Seçiniz',
        'FileChooserOverwrite' => 'Bu dosya zaten var. Üzerine yazmak istediğinizden emin misiniz?',
        'FileAllFiles' => 'All Files',
        'FileVideoFiles' => 'Video Files',
        'FileEbookFiles' => 'Ebook Files',
        'FileAudioFiles' => 'Audio Files',
        'FileGCstarFiles' => 'GCstar Collections',

        #Some default panels
        'PanelCompact' => 'İşlevsel',
        'PanelReadOnly' => 'Salt Okunur',
        'PanelForm' => 'Sekmeler',

        'PanelSearchButton' => 'Bilgi Al',
        'PanelSearchTip' => 'Bu film için internetten bilgi al',
        'PanelSearchContextChooseOne' => 'Choose a site ...',
        'PanelSearchContextMultiSite' => 'Use "Many sites"',
        'PanelSearchContextMultiSitePerField' => 'Use "Many sites per field"',
        'PanelSearchContextOptions' => 'Change options ...',
        'PanelImageTipOpen' => 'Başka bir kapak resmi seçmek için tıklayınız.',
        'PanelImageTipView' => 'Click on the picture to view it in real size.',
        'PanelImageTipMenu' => ' Daha fazla seçenek için sağ tıklayınız.',
        'PanelImageTitle' => 'Kapak seç',
        'PanelImageNoImage' => 'No image',
        'PanelSelectFileTitle' => 'Dosya Seçiniz',
        'PanelLaunch' => 'Launch',        
        'PanelRestoreDefault' => 'Restore default',
        'PanelRefresh' => 'Update',
        'PanelRefreshTip' => 'Update information from web',

        'PanelFrom' =>'From',
        'PanelTo' =>'To',

        'PanelWeb' => 'Bilgileri göster',
        'PanelWebTip' => 'Bu filmin internet bilgisini göster', # Accepts model codes
        'PanelRemoveTip' => 'Seçili filmi siliniz', # Accepts model codes

        'PanelDateSelect' => 'Tarih Seçiniz',
        'PanelNobody' => 'Kimse',
        'PanelUnknown' => 'Bilinmiyor',
        'PanelAdded' => 'Add date',
        'PanelRating' => 'Puan',
        'PanelPressRating' => 'Press Rating',
        'PanelLocation' => 'Yer',

        'PanelLending' => 'Ödünç',
        'PanelBorrower' => 'Ödünç Alan',
        'PanelLendDate' => 'Ödünç Verme Tarihi',
        'PanelHistory' => 'Ödünç Geçmişi',
        'PanelReturned' => 'Geri Dönme Tarihi', # Accepts model codes
        'PanelReturnDate' => 'Geri dönme tarihi',
        'PanelLendedYes' => 'Ödün verilme',
        'PanelLendedNo' => 'Arşivde',

        'PanelTags' => 'Tags',
        'PanelFavourite' => 'Favourite',
        'TagsAssigned' => 'Assigned Tags', 

        'PanelUser' => 'User fields',

        'CheckUndef' => 'Farketmez',
        'CheckYes' => 'Evet',
        'CheckNo' => 'Hayır',

        'ToolbarAll' => 'Tümünü Göster',
        'ToolbarAllTooltip' => 'Tüm filmleri görmek için tıklayınız',
        'ToolbarGroupBy' => 'Grupla',
        'ToolbarGroupByTooltip' => 'Select the field to use to group items in list',
        'ToolbarQuickSearch' => 'Quick search',
        'ToolbarQuickSearchLabel' => 'Search',
        'ToolbarQuickSearchTooltip' => 'Select the field to search in. Enter the search terms and press Enter',
        'ToolbarSeparator' => ' Separator',
        
        'PluginsTitle' => 'Film arayınız',
        'PluginsQuery' => 'Query',
        'PluginsFrame' => 'Arama sitesi',
        'PluginsLogo' => 'Logo',
        'PluginsName' => 'Adı',
        'PluginsSearchFields' => 'Search fields',
        'PluginsAuthor' => 'Yazarı',
        'PluginsLang' => 'Dil',
        'PluginsUseSite' => 'Her zaman bu siteyi kullan',
        'PluginsPreferredTooltip' => 'Site recommended by GCstar',
        'PluginDisabled' => 'Disabled',

        'BorrowersTitle' => 'Ödünç Seçenekleri',
        'BorrowersList' => 'Borrowers',
        'BorrowersName' => 'Adı',
        'BorrowersEmail' => 'E-posta',
        'BorrowersAdd' => 'Ekle',
        'BorrowersRemove' => 'Sil',
        'BorrowersEdit' => 'Düzenle',
        'BorrowersTemplate' => 'E-posta örneği',
        'BorrowersSubject' => 'Posta konusu',
        'BorrowersNotice1' => '%1 - Ödünç alanın adı',
        'BorrowersNotice2' => '%2 - Film adı',
        'BorrowersNotice3' => '%3  - Ödün alma tarihi',

        'BorrowersImportTitle' => 'Import borrowers information',
        'BorrowersImportType' => 'File format:',
        'BorrowersImportFile' => 'File:',

        'BorrowedTitle' => 'Ödünç verilmiş filmler', # Accepts model codes
        'BorrowedDate' => 'Alma Tarihi',
        'BorrowedDisplayInPanel' => 'Show item in main window', # Accepts model codes

        'MailTitle' => 'E-posta gönder',
        'MailFrom' => 'Kimden: ',
        'MailTo' => 'Kime: ',
        'MailSubject' => 'Konu: ',
        'MailSmtpError' => 'SMTP sunucusuna bağlanamıyor',
        'MailSendmailError' => 'Sendmail istemcisini çalıştıramıyor',

        'SearchTooltip' => 'Detaylı arama için tıklayınız', # Accepts model codes
        'SearchTitle' => 'Film Arama', # Accepts model codes
        'SearchNoField' => 'No field have been selected for the search box.
Add some of them in the Filters tab of the collection settings.',

        'QueryReplaceField' => 'Değiştirilecek alan',
        'QueryReplaceOld' => 'Şimdiki değer',
        'QueryReplaceNew' => 'Yeni Değer',
        'QueryReplaceLaunch' => 'Değiştir',
        
        'ImportWindowTitle' => 'Alınacak alanları seçiniz',
        'ImportViewPicture' => 'Resmi göster',
        'ImportSelectAll' => 'Tümünü seç',
        'ImportSelectNone' => 'Hiçbirini seçme',

        'MultiSiteTitle' => 'Arama için kullanılan siteler',
        'MultiSiteUnused' => 'Kullanılmayacaklar',
        'MultiSiteUsed' => 'Kullanılacak eklentiler',
        'MultiSiteLang' => 'İngilizce eklentileri göster',
        'MultiSiteEmptyError' => 'Site listeniz boş',
        'MultiSiteClear' => 'Listeyi temizle',
        
        'DisplayOptionsTitle' => 'Gösterilecek alanlar',
        'DisplayOptionsAll' => 'Tümünü Seç',
        'DisplayOptionsSearch' => 'Arama düğmesi',

        'GenresTitle' => 'Tür Dönüştürme',
        'GenresCategoryName' => 'Kullanılan Tür',
        'GenresCategoryMembers' => 'Değiştirilecek Tür',
        'GenresLoad' => 'Liste yükle',
        'GenresExport' => 'Listeyi kaydet',
        'GenresModify' => 'Tür Düzenle',

        'PropertiesName' => 'Collection name',
        'PropertiesLang' => 'Language code',
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
        'BookmarksFolder' => 'Directory',
        'BookmarksLabel' => 'Label',
        'BookmarksPath' => 'Path',
        'BookmarksNewFolder' => 'New folder',

        'AdvancedSearchType' => 'Type of search',
        'AdvancedSearchTypeAnd' => 'Items matching all criteria', # Accepts model codes
        'AdvancedSearchTypeOr' => 'Items matching at least one criterion', # Accepts model codes
        'AdvancedSearchCriteria' => 'Criteria',
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
