{
    package GCLang::AR;

    use utf8;
###################################################	
#
#	This file translated by :
#		Muhammad Bashir Al-Noimi
#	Contact me:
#		mhdbnoimi@gmail.com
#		bashir.storm@gmail.com
#		mbnoimi@gmail.com
#	MY Blog:
#		http://mbnoimi.net/
#	
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

        'LangName' => 'Arabic عربي',
        
        'Separator' => ': ',
        
        'Warning' => '<b>تحذير</b>:
        
المعلومات التي يتم تحميلها من الإنترنت (عن طريق 
ملحقات البحث) تستعمل فقط من أجل <b>الإستعمال الشخصي</b>.

من أجل تحديد موقع الإنترنت المناسب لتحميل البيانات، بإمكانك
إستعمال <b>الزر الواقع تحت تفاصيل العنصر </b>.',

        
		'AllItemsFiltered' => 'لم يتم العثور على أي عنصر من خلال معيار البحث الذي قمت بتخصيصه', # Accepts model codes
     
#Installation
        'InstallDirInfo' => 'تم تنصيبه ضمن ',
        'InstallMandatory' => 'مكونات أساسية',
        'InstallOptional' => 'مكونات إختيارية',
        'InstallErrorMissing' => 'خطأ : مكونات بيرل التالية يجب أن يتم تنصيبها: ',
        'InstallPrompt' => 'مجلد التنصيب [/usr/local]: ',
        'InstallEnd' => 'نهاية التنصيب',
        'InstallNoError' => 'لا توجد أخطاء',
        'InstallLaunch' => 'لتشغيل البرنامج يجب إستدعاء نسخة واحدة ',
        'InstallDirectory' => 'المجلد الرئيسي',
        'InstallTitle' => 'تنصيب جي سي ستار',
        'InstallDependencies' => 'الإعتمادية',
        'InstallPath' => 'مسار',
        'InstallOptions' => 'خيارات',
        'InstallSelectDirectory' => 'قم بتحديد مجلد التنصيب',
        'InstallWithClean' => 'إزالة الملفات الموجودة ضمن مجلد التنصيب',
        'InstallWithMenu' => 'إضافة جي سي ستار لقائمة البرامج',
        'InstallNoPermission' => 'خطأ : ليس لديك سماحية الكتابة ضمن المجلد المحدد',
        'InstallMissingMandatory' => 'إعتماديات أساسية مفقودة. ليس بإمكانك تنصيب جي سي ستار إلا بعد إضافة الإعتماديات الرئيسية لنظامك.',
        'InstallMissingOptional' => 'بعض الإعتماديات الإختيارية مفقودة كما هو موضح أدناه. يمكن تنصيب جي سي ستار لكن بعض الميزات لن تكون متوفرة للعمل.',
        'InstallMissingNone' => 'لا توجد إعتماديات مفقودة. بإمكانك الإستمرار و تنصيب جي سي ستار.',
        'InstallOK' => 'موافق',
        'InstallMissing' => 'مفقود',
        'InstallMissingFor' => 'مفقود',
        'InstallCleanDirectory' => 'إزالة ملفات جي سي ستار من المجلد: ',
        'InstallCopyDirectory' => 'نسخ الملفات للمجلد: ',
        'InstallCopyDesktop' => 'نسخ ملف سطح المكتب إلى: ',

#Update
		'UpdateUseProxy' => 'البروكسي الذي سيتم إستعماله (قم بالنقر على Enter في حال عدم وجود بروكسي): ',
		'UpdateNoPermission' => 'لا توجد سماحية للكتابة ضمن هذا المجلّد ',
        'UpdateNone' => 'لم يتم العثور على تحديث جديد',
        'UpdateFileNotFound' => 'لم يتم العثور على الملف',

#Splash
        'SplashInit' => 'تهيئة',
        'SplashLoad' => 'تحميل المجموعات',
        'SplashDisplay' => 'عرض المجموعات',
        'SplashSort' => 'ترتيب المجموعات',
        'SplashDone' => 'جاهز',

#Import from GCfilms
        'GCfilmsImportQuestion' => 'يبدو أنك كنت تستعمل جي سي فيلم من قبل. هل ترغب بإستيراد البيانات من جي سي فيلم إلى جي سي ستار؟',
        'GCfilmsImportOptions' => 'إعدادات',
        'GCfilmsImportData' => 'قائمة الأفلام',

#Menus
        'MenuFile' => '_ملف',
            'MenuNewList' => '_مجموعة جديدة',
            'MenuStats' => 'Statistics',
            'MenuHistory' => '_المجموعات السابقة',
            'MenuLend' => 'إظهار العناصر _المستعرضة سابقاً', # Accepts model codes
            'MenuImport' => '_إستيراد',	
            'MenuExport' => '_تصدير',
            'MenuAddItem' => '_Add Items', # Accepts model codes
    
        'MenuEdit'  => '_تحرير',
            'MenuDuplicate' => 'مضاعفة العنصر',  # Accepts model codes
            'MenuDuplicatePlural' => 'Du_plicate Items', # Accepts model codes
            'MenuEditSelectAllItems' => 'Select _All Items', # Accepts model codes
            'MenuEditDeleteCurrent' => '_حذف العنصر', # Accepts model codes
            'MenuEditDeleteCurrentPlural' => '_Remove Items', # Accepts model codes   
            'MenuEditFields' => '_تغيير حقول المجموعة',
            'MenuEditLockItems' => '_إقفال المجموعة',
    
        'MenuDisplay' => 'ت_صفية',
            'MenuSavedSearches' => 'حفظ البحث',
                'MenuSavedSearchesSave' => 'حفظ البحث الحالي',
                'MenuSavedSearchesEdit' => 'تعديل بحث محفوظ',
            'MenuAdvancedSearch' => 'ب_حث متقدّم',
            'MenuViewAllItems' => 'عرض _كل العناصر', # Accepts model codes
            'MenuNoFilter' => '_أي شيء',
    
        'MenuConfiguration' => '_إعدادات',
            'MenuDisplayMenu' => 'Display',
                'MenuDisplayFullScreen' => 'Full screen',
                'MenuDisplayMenuBar' => 'Menus',
                'MenuDisplayToolBar' => 'Toolbar',
                'MenuDisplayStatusBar' => 'Bottom bar',
            'MenuDisplayOptions' => '_المعلومات المعروضة',
            'MenuBorrowers' => '_إستعارة',
            'MenuToolbarConfiguration' => '_عناصر شريط الأدوات',
            'MenuDefaultValues' => 'Default values for new item', # Accepts model codes
            'MenuGenresConversion' => 'نم_ط التحويل',
        
        'MenuBookmarks' => '_محفوظات',
            'MenuBookmarksAdd' => '_أضف الجموعة الحالية',
            'MenuBookmarksEdit' => '_تحرير المحفوظات',

        'MenuHelp' => '_مساعدة',
            'MenuHelpContent' => '_المحتوى',
            'MenuAllPlugins' => 'عرض الملحقات',
            'MenuBugReport' => 'الإبلاغ عن خطأ',
            'MenuAbout' => '_حول جي سي ستار',
    
        'MenuNewWindow' => 'عرض العنصر بنافذة _جديدة', # Accepts model codes
        'MenuNewWindowPlural' => 'Show Items in _New Window', # Accepts model codes
                
        'ContextExpandAll' => 'توسيع الكل',
        'ContextCollapseAll' => 'طي الكل',
        'ContextChooseImage' => 'قم بإختيار صورة',
        'ContextOpenWith' => 'فتح بواسطة',
        'ContextImageEditor' => 'محرر الصور',
        'ContextImgFront' => 'الواجهة',
        'ContextImgBack' => 'الخلفية',
        'ContextChooseFile' => 'Choose a File',
        'ContextChooseFolder' => 'Choose a Folder',
        
        'DialogEnterNumber' => 'قم بإدخال قيمة',

        'RemoveConfirm' => 'هل أنت متأكد من حذف هذا العنصر؟', # Accepts model codes
        'RemoveConfirmPlural' => 'Do you really want to remove these items?', # Accepts model codes

        'DefaultNewItem' => 'عنصر جديد',
        'NewItemTooltip' => 'إضافة عنصر جديد',
		'NoItemFound' => 'لم يتم العثور على أي شيء. هل تود البحث ضمن موقع آخر؟',
        'OpenList' => 'قم بتحديد مجموعة',
		'SaveList' => 'قم بتحديد مسار حفظ المجموعة',
        'SaveListTooltip' => 'حفظ المجموعة الحالية',
        'SaveUnsavedChanges' => 'لم يتم حفظ التعديلات على مجموعتك لم تُحفظ. هل تريد حفظ التعديلات؟',
        'SaveDontSave' => 'لا تحفظ',
        'PreferencesTooltip' => 'تفضيلات البرنامج',
        'ViewTooltip' => 'تغيير عرض المجموعة',
		'PlayTooltip' => 'قراءة ملف الفيديو المرتبط بالعنصر', # Accepts model codes
        'PlayFileNotFound' => 'الملف الذي سيتم إستدعاؤه غير موجود في هذا المسار:',
        'PlayRetry' => 'إعادة القراءة',

        'StatusSave' => 'الحفظ جاري...',
        'StatusLoad' => 'التحميل جاري...',
        'StatusSearch' => 'البحث جاري...',
        'StatusGetInfo' => 'الحصول على المعلومات...',
        'StatusGetImage' => 'الحصول على الصورة...',
                
		'SaveError' => 'غير قادر على حفظ قائمة العناصر. من فضلك قم بفحص سماحيات الكتابة على القرص',
        'OpenError' => 'غير قادر على فتح قائمة العناصر. من فضلك قم بفحص سماحيات القرص',
		'OpenFormatError' => 'غير قادر على فتح قائمة العناصر. تأكد من صحة التنسيق',
        'OpenVersionWarning' => 'المجموعة تم حفظها بواسطة عدة إصدارات من جي سي ستار. إذا قمت بحفظها هنالك إحتمال أن تفقد بعض البيانات.',
        'OpenVersionQuestion' => 'هل لا تزال ترغب بالإستمرار؟',
		'ImageError' => 'المسار المحدّد من أجل حفظ الصوّر غير صالح. من فضلك قم بتحديد مسار آخر',
        'OptionsCreationError'=> 'غير قادر على إنشاء ملف الخيارات: ',
        'OptionsOpenError'=> 'غير قادر على فتح ملف الخيارات: ',
        'OptionsSaveError'=> 'غير قادر على حفظ ملف الخيارات: ',
        'ErrorModelNotFound' => 'النموذج غير موجود: ',
        'ErrorModelUserDir' => 'النماذج المعرفة من قبل المستخدم موجودة ضمن: ',
        
        'RandomTooltip' => 'ما الذي ترغب برؤيته هذا المساء؟',
        'RandomError'=> 'لم يتم تحديد أي عنصر', # Accepts model codes
        'RandomEnd'=> 'لا توجد عناصر أكثر من ذلك', # Accepts model codes
        'RandomNextTip'=> 'الإقتراح التالي',
        'RandomOkTip'=> 'قبول هذا العنصر',
        
        'AboutTitle' => 'حول جي سي ستار',
        'AboutDesc' => 'لإدارة المجموعات',
        'AboutVersion' => 'إصدار',
        'AboutTeam' => 'فريق',
        'AboutWho' => 'مدير المشروع، مبرمج: Christian Jodar (Tian)
مبرمج: Nyall Dawson (Zombiepig)
مبرمج: TPF
مبرمج: Adolfo González
',
        'AboutLicense' => 'المشروع تم تطويره و توزيعه وفق رخصة البرامج مفتوحة المصدر GPL
Logos Copyright le Spektre',
        'AboutTranslation' => 'دعم اللغة العربية: محمد بشير النعيمي 
http://mbnoimi.net/
mhdbnoimi@gmail.com
bashir.storm@gmail.com
mbnoimi@gmail.com',
        'AboutDesign' => 'Łukasz Kowalczk (Qoolman): Skin Designer
        تم أنجاز الشعار و تصميم الويب من قبل le Spektre',

        'ToolbarRandom' => 'هذه اللّيلة',

        'UnsavedCollection' => 'مجموعة لم يتم حفظها',
        'ModelsSelect' => 'حدّد نوع المجموعة',
        'ModelsPersonal' => 'نماذج شخصية',
        'ModelsDefault' => 'نماذج إفتراضية',
        'ModelsList' => 'تعريف المجموعة',
        'ModelSettings' => 'إعدادات المجموعة',
        'ModelNewType' => 'مجموعة جديدة',
        'ModelName' => 'إسم المجموعة: ',
		'ModelFields' => 'حقول',
		'ModelOptions'	=> 'خيارات',
		'ModelFilters'	=> 'مرشحات تصفية',
        'ModelNewField' => 'حقل جديد',
        'ModelFieldInformation' => 'معلومات',
        'ModelFieldName' => 'تسمية:',
        'ModelFieldType' => 'نوع:',
        'ModelFieldGroup' => 'مجموعة:',
        'ModelFieldValues' => 'القيم',
        'ModelFieldInit' => 'إفتراضي:',
        'ModelFieldMin' => 'الحد الأدنى:',
        'ModelFieldMax' => 'الحد الأعلى:',
        'ModelFieldList' => 'قائمة القيم:',
        'ModelFieldListLegend' => '<i>كل قيمة تفصل عن الأخرى بفاصلة</i>',
        'ModelFieldDisplayAs' => 'عرض بهيئة: ',
        'ModelFieldDisplayAsText' => 'نص',
        'ModelFieldDisplayAsGraphical' => 'عنصر تقييم',
        'ModelFieldTypeShortText' => 'نص قصير',
        'ModelFieldTypeLongText' => 'نص طويل',
        'ModelFieldTypeYesNo' => 'نعم/لا',
        'ModelFieldTypeNumber' => 'عدد',
        'ModelFieldTypeDate' => 'تاريخ',
        'ModelFieldTypeOptions' => 'قائمة قيم ذات تعريف مسبق',
        'ModelFieldTypeImage' => 'صورة',
        'ModelFieldTypeSingleList' => 'قائمة بسيطة',
        'ModelFieldTypeFile' => 'ملف',
        'ModelFieldTypeFormatted' => 'يعتمد على الحقول الأخرى',
        'ModelFieldParameters' => 'وسائط',
        'ModelFieldHasHistory' => 'إستعمال المحفوظات',
        'ModelFieldFlat' => 'عرض ضمن صفّ واحد',
        'ModelFieldStep' => 'خطوة الزيادة:',
        'ModelFieldFileFormat' => 'تنسيق الملف:',
        'ModelFieldFileFile' => 'ملف بسيط',
        'ModelFieldFileImage' => 'صورة',
        'ModelFieldFileVideo' => 'فيديو',
        'ModelFieldFileAudio' => 'صوت',
        'ModelFieldFileProgram' => 'برنامج',
        'ModelFieldFileUrl' => 'رابط',
        'ModelFieldFileEbook' => 'Ebook',
        'ModelOptionsFields' => 'حقول للأستعمال',
        'ModelOptionsFieldsAuto' => 'تلقائي',
        'ModelOptionsFieldsNone' => 'لا شيء',
        'ModelOptionsFieldsTitle' => 'حسب العنوان',
        'ModelOptionsFieldsId' => 'حسب المعرّف',
        'ModelOptionsFieldsCover' => 'حسب الغلاف',
        'ModelOptionsFieldsPlay' => 'من أجل زر القراءة',
        'ModelCollectionSettings' => 'إعدادات المجموعة',
        'ModelCollectionSettingsLending' => 'إمكانية إعارة العناصر',
        'ModelCollectionSettingsTagging' => 'عناصر يسمح بوسمها',
        'ModelFilterActivated' => 'عرض ضمن صندوق البحث',
        'ModelFilterComparison' => 'مقارنة',
        'ModelFilterContain' => 'يحتوي',
        'ModelFilterDoesNotContain' => 'لا يحتوي على',
        'ModelFilterRegexp' => 'تعبير منتظم',
        'ModelFilterRange' => 'مجال',
        'ModelFilterNumeric' => 'المقارنة عددية',
        'ModelFilterQuick' => 'إنشاء تصفية سريعة',
        'ModelTooltipName' => 'إستعمل إسماً من أجل إعادة إستعمال هذا النموذج لمجموعات أخرى. في حال كان فارغاً، الإعدادات سيتم تخزينها مباشرة
ضمن ملف المجموعة نفسه',
        'ModelTooltipLabel' => 'إسم الحقل كما سيتم إظهاره',
        'ModelTooltipGroup' => 'يستعمل من أجل تجميع الحقول. جميع العناصر التي لا تحتوي على قيم سيتم تجميعها ضمن مجموعة إفتراضية',
        'ModelTooltipHistory' => 'القيم المدخلة سابقاً سيتم تخزينها ضمن قائمة مرتبطة بالحقل',
        'ModelTooltipFormat' => 'تستعمل هذه الصيغة لتخصيص طريقة فتح الملف بإستعمال زر القراءة',
        'ModelTooltipLending' => 'سيتم إضافة بعض الحقول من أجل إدارة الإستعارة',
        'ModelTooltipTagging' => 'إضافة بعض الحقول من أجل إدارة الوسوم',
        'ModelTooltipNumeric' => 'سيتم معاملة جميع المقارنات على أنها أعداد',
        'ModelTooltipQuick' => 'سيتم إضافة قائمة فرعية ضمن قائمة التصفية',
        
        'ResultsTitle' => 'حدد عنصر', # Accepts model codes
        'ResultsNextTip' => 'البحث ضمن الموقع',
        'ResultsPreview' => 'معاينة',
        'ResultsInfo' => 'بإمكانك إضافة عدة عناصر للمجموعة عن طريق النقر المستمر على زر Ctrl أو Shift ثم إختيار العنصر', # Accepts model codes
        
        'OptionsTitle' => 'التفضيلات',
		'OptionsExpertMode' => 'متقدّم',
        'OptionsPrograms' => 'تخصيص التطبيقات الإفتراضية ضمن البرنامج، سيتم إستعمال إفتراضيات النظام في حال ترك الحقل فارغاً',
        'OptionsBrowser' => 'متصفّح الإنترنت',
        'OptionsPlayer' => 'قارئ الفيديو',
        'OptionsAudio' => 'قارئ الصوت',
        'OptionsImageEditor' => 'محرر الصور',
        'OptionsCdDevice' => 'جهاز القرص المدمج',
        'OptionsImages' => 'مجلد الصوّر',
        'OptionsUseRelativePaths' => 'إستعمال المسارات النسبية من أجل الصوّر',
        'OptionsLayout' => 'تخطيط العرض',
        'OptionsStatus' => 'عرض شريط الحالة',
        'OptionsUseStars' => 'إستعمال النجوم من أجل عرض التقييم',
        'OptionsWarning' => 'تحذير: جميع التعديلات ستظهر عند إعادة تشغيل البرنامج، و لن تظهر مباشرة الآن',
        'OptionsRemoveConfirm' => 'إظهار رسالة تأكيد حذف العنصر',
        'OptionsAutoSave' => 'حفظ المجموعة بشكل تلقائي',
        'OptionsAutoLoad' => 'فتح المجموعة السابقة عند بدء تشغيل البرنامج',
        'OptionsSplash' => 'عرض الشاشة الترحيبية',
        'OptionsTearoffMenus' => 'تمكين تثبيت القوائم',
        'OptionsSpellCheck' => 'إستعمال المدقق الإملائي ضمن حقول النص الطويلة',
        'OptionsProgramTitle' => 'حدد البرنامج الذي سيتم إستعماله',
		'OptionsPlugins' => 'الموقع الذي سيتم جلب البيانات منه',
		'OptionsAskPlugins' => 'سؤال جميع المواقع',
		'OptionsPluginsMulti' => 'عدد معيّن من المواقع',
		'OptionsPluginsMultiAsk' => 'سؤال عدد معين من المواقع',
        'OptionsPluginsMultiPerField' => 'Many sites (per field)',
        'OptionsPluginsMultiPerFieldWindowTitle' => 'Many sites per field order selection',
        'OptionsPluginsMultiPerFieldDesc' => 'For each field we will fill the field with the first non empty information beginning from left',
        'OptionsPluginsMultiPerFieldFirst' => 'First',
        'OptionsPluginsMultiPerFieldLast' => 'Last',
        'OptionsPluginsMultiPerFieldRemove' => 'Remove',
        'OptionsPluginsMultiPerFieldClearSelected' => 'Empty selected field list',
		'OptionsPluginsList' => 'تخصيص قائمة المواقع',
        'OptionsAskImport' => 'حدد الحقول التي سيتم إستيرادها',
		'OptionsProxy' => 'إستعمل البروكسي',
		'OptionsCookieJar' => 'إستعمال ملف الكوكي',
        'OptionsLang' => 'لغة',
        'OptionsMain' => 'عام',
        'OptionsPaths' => 'مسارات',
        'OptionsInternet' => 'إنترنت',
        'OptionsConveniences' => 'ميّزات',
        'OptionsDisplay' => 'عرض',
        'OptionsToolbar' => 'شريط الأدوات',
        'OptionsToolbars' => {0 => 'بلا', 1 => 'صغير', 2 => 'كبير'},
        'OptionsToolbarPosition' => 'توضّع',
        'OptionsToolbarPositions' => {0 => 'في الأعلى', 1 => 'في الأسفل', 2 => 'في اليسار', 3 => 'في اليمين'},
        'OptionsExpandersMode' => 'طريقة إحتواء العناصر الكبيرة',
        'OptionsExpandersModes' => {'asis' => 'لا تفعل شيء', 'cut' => 'إقتطاع', 'wrap' => 'إلتفاف السطر'},
        'OptionsDateFormat' => 'صيغة التاريخ',
        'OptionsDateFormatTooltip' => 'صيغة التاريخ. القيمة الإفتراضية هي: %d/%m/%Y',
        'OptionsView' => 'قائمة العناصر',
        'OptionsViews' => {0 => 'نص', 1 => 'صورة', 2 => 'تفاصيل'},
        'OptionsColumns' => 'أعمدة',
        'OptionsMailer' => 'إرسال البريد الإلكتروني بواسطة',
        'OptionsSMTP' => 'الملقم',
        'OptionsFrom' => 'عنوان بريدك الإلكتروني',

        'OptionsTransform' => 'وضع مقطع التعريف بنهاية العناوين',
        'OptionsArticles' => 'مقطع التعريف (كل مقطع مفصول عن الآخر بفاصلة)',
        'OptionsSearchStop' => 'السماح بإحباط عملية البحث',
        'OptionsBigPics' => 'إستعمال الصور بقياس كبير في حال توفرهم',

        'OptionsAlwaysOriginal' => 'استعمل العنوان الرئيسي كعنوان أصلي إن لم يتم تخصيصه',
        'OptionsRestoreAccelerators' => 'إستعادة الإختصارات الإفتراضية',
        'OptionsHistory' => 'حجم المحفوظات',
        'OptionsClearHistory' => 'مسح المحفوظات',
		'OptionsStyle' => 'مظهرية العرض',
        'OptionsDontAsk' => 'لا تسألني مرة أخرى',
        'OptionsPathProgramsGroup' => 'تطبيقات',
        'OptionsProgramsSystem' => 'إستعمال البرامج المعرفة من قبل النظام',
        'OptionsProgramsUser' => 'إستعمال البرامج المعرفة من قبل المستخدم',
        'OptionsProgramsSet' => 'تخصيص البرامج',
        'OptionsPathImagesGroup' => 'صور',
        'OptionsInternetDataGroup' => 'استيراد البيانات',
        'OptionsInternetSettingsGroup' => 'إعدادات',
        'OptionsDisplayInformationGroup' => 'عرض المعلومات',

        'OptionsDisplayArticlesGroup' => 'مقاطع التعريف',
        'OptionsImagesDisplayGroup' => 'عرض',
        'OptionsImagesStyleGroup' => 'نمط',
        'OptionsDetailedPreferencesGroup' => 'تفضيلات',
#0
        'OptionsFeaturesConveniencesGroup' => 'وسائل الراحة',
        'OptionsPicturesFormat' => 'البادئة التي ستستعمل للصوّر',
        'OptionsPicturesFormatInternal' => 'gcstar__',
        'OptionsPicturesFormatTitle' => 'عنوان أو اسم العنصر المرتبط',
        'OptionsPicturesWorkingDir' => 'الصيغة %WORKING_DIR% . سيتم إستبدالها بمجلد المجموعة (تستعمل فقط في بداية المسار)',
        'OptionsPicturesFileBase' => 'الصيغة %FILE_BASE% سيتم إستبدالها بواسطة إسم ملف المجموعة دون اللاحقة (.gcs)',
        'OptionsPicturesWorkingDirError' => 'الصيغة %WORKING_DIR% يمكن إستعمالها فقط في بداية المسار للصور',
        'OptionsConfigureMailers' => 'تهيئة برامج البريد الإلكتروني',

        'ImagesOptionsButton' => 'إعدادات',
        'ImagesOptionsTitle' => 'إعدادات قائمة الصوّر',
        'ImagesOptionsSelectColor' => 'حدد لون',
        'ImagesOptionsUseOverlays' => 'عرض ضمن إطار زجاجي',
        'ImagesOptionsBg' => 'خلفية',
        'ImagesOptionsBgPicture' => 'إستعمل صورة الخلفية',
        'ImagesOptionsFg'=> 'تحديد',
        'ImagesOptionsBgTooltip' => 'تغيير لون الخلفية',
        'ImagesOptionsFgTooltip'=> 'تغيير لون التحديد',
        'ImagesOptionsResizeImgList' => 'تغيير عدد الأعمدة بشكل تلقائي',
        'ImagesOptionsAnimateImgList' => 'Use animations',
        'ImagesOptionsSizeLabel' => 'حجم',
        'ImagesOptionsSizeList' => {0 => 'صغير جداً', 1 => 'صغير', 2 => 'متوسط', 3 => 'كبير', 4 => 'كبير جداً'},
        'ImagesOptionsSizeTooltip' => 'حدد حجم الصورة',
		        
        'DetailedOptionsTitle' => 'إعدادات قائمة تفاصيل',
        'DetailedOptionsImageSize' => 'قياس الصوّر',
        'DetailedOptionsGroupItems' => 'تجميع العناصر بواسطة',
        'DetailedOptionsSecondarySort' => 'ترتيب الحقول الفرعية',
		'DetailedOptionsFields' => 'حدد التي الحقول التي سيتم عرضها',
        'DetailedOptionsGroupedFirst' => 'فرز العناصر الغير مجمّعة',
        'DetailedOptionsAddCount' => 'إضافة عدد العناصر ضمن التصنيفات',
        'ExtractButton' => 'معلومات',
        'ExtractTitle' => 'معلومات الملف',
        'ExtractImport' => 'إستعمل القيم',

        'FieldsListOpen' => 'فتح قائمة الحقول من ملف',
        'FieldsListSave' => 'حفظ قائمة الحقول لملف',
        'FieldsListError' => 'لا يمكن إستعمال قائمة الحقول مع هذا النوع من المجموعات',
        'FieldsListIgnore' => '--- تجاهل',

        'ExportTitle' => 'تصدير قائمة العناصر',
        'ExportFilter' => 'تصدير العناصر المعروضة فقط',
        'ExportFieldsTitle' => 'حقول سيتم تصديرها',
        'ExportFieldsTip' => 'حدد الحقول التي تود تصديرها',
        'ExportWithPictures' => 'نسخ الصّور لمجلّد فرعي',
        'ExportSortBy' => 'ترتيب حسب',
        'ExportOrder' => 'ترتيب',

        'ImportListTitle' => 'إستيراد قائمة عناصر أخرى',
        'ImportExportData' => 'بيانات',
        'ImportExportFile' => 'ملف',
        'ImportExportFieldsUnused' => 'حقول عير مستعملة',
        'ImportExportFieldsUsed' => 'حقول مستعملة',
        'ImportExportFieldsFill' => 'إضافة الكل',
        'ImportExportFieldsClear' => 'إزالة الكل',
        'ImportExportFieldsEmpty' => 'يجب تحديد حقل واحد على الأقل',
        'ImportExportFileEmpty' => 'يجب تخصيص إسم الملف',
        'ImportFieldsTitle' => 'حقول سيتم إستيرادها',
        'ImportFieldsTip' => 'حدد الحقول التي تريد إستيرادها',
        'ImportNewList' => 'إنشاء مجموعة جديدة',
        'ImportCurrentList' => 'إضافة للمجموعة الحالية',
        'ImportDropError' => 'حدث خطأ أثناء فتح الملف. القائمة السابقة سيعاد تحميلها من جديد',
		'ImportGenerateId' => 'إنشاء رقم معرّف من أجل كل عنصر',

        'FileChooserOpenFile' => 'قم بتحديد ملف ليتم إستعاله',
        'FileChooserDirectory' => 'مجلد',
        'FileChooserOpenDirectory' => 'حدد مجلد',
        'FileChooserOverwrite' => 'الملف موجود مسبقاً. هل تود إستبداله؟',
        'FileAllFiles' => 'All Files',
        'FileVideoFiles' => 'Video Files',
        'FileEbookFiles' => 'Ebook Files',
        'FileAudioFiles' => 'Audio Files',
        'FileGCstarFiles' => 'GCstar Collections',

        #Some default panels
        'PanelCompact' => 'مدمج',
        'PanelReadOnly' => 'للقراءة فقط',
        'PanelForm' => 'صفحات',

        'PanelSearchButton' => 'جلب المعلومات',
        'PanelSearchTip' => 'البحث بالإنترنت عن المعلومات التي تحمل هذا الإسم',
        'PanelSearchContextChooseOne' => 'Choose a site ...',
        'PanelSearchContextMultiSite' => 'Use "Many sites"',
        'PanelSearchContextMultiSitePerField' => 'Use "Many sites per field"',
        'PanelSearchContextOptions' => 'Change options ...',
        'PanelImageTipOpen' => 'إنقر على الصورة من أجل تحديد واحدة أخرى ',
        'PanelImageTipView' => ' إنقر على الصورة من أجل مشاهدة القياس الأصلي',
        'PanelImageTipMenu' => ' إنقر على الزر الأيمن للفأرة من أجل مزيد من الخيارات',
        'PanelImageTitle' => 'حدد صورة',
        'PanelImageNoImage' => 'لا توجد صورة',
        'PanelSelectFileTitle' => 'حدد ملف',
        'PanelLaunch' => 'Launch',
        'PanelRestoreDefault' => 'إستعادة الإفتراضيات',
        'PanelRefresh' => 'Update',
        'PanelRefreshTip' => 'Update information from web',

        'PanelFrom' =>'من',
        'PanelTo' =>'إلى',

        'PanelWeb' => 'عرض المعلومات',
        'PanelWebTip' => 'عرض المعلومات من الإنترنت حول هذا العنصر', # Accepts model codes
        'PanelRemoveTip' => 'حذف العنصر الحالي', # Accepts model codes

        'PanelDateSelect' => 'حدد التاريخ',
        'PanelNobody' => 'لا أحد',
        'PanelUnknown' => 'غير معروف',
        'PanelAdded' => 'إضافة التاريخ',
        'PanelRating' => 'تقييم',
        'PanelPressRating' => 'Press Rating',
        'PanelLocation' => 'المكان',

        'PanelLending' => 'إعارة',
        'PanelBorrower' => 'مستعير',

        'PanelLendDate' => 'تاريخ الإعارة',
        'PanelHistory' => 'تاريخ الإعارة',
        'PanelReturned' => 'عنصر مُعاد', # Accepts model codes
        'PanelReturnDate' => 'تاريخ الإعادة',
        'PanelLendedYes' => 'مُعار',
        'PanelLendedNo' => 'متاح',

        'PanelTags' => 'وسوم',
        'PanelFavourite' => 'محفوظات',
        'TagsAssigned' => 'وسوم مستعملة', 

        'PanelUser' => 'حقول المستخدم',

        'CheckUndef' => 'اما',
        'CheckYes' => 'نعم',
        'CheckNo' => 'لا',

        'ToolbarAll' => 'عرض الكل',
        'ToolbarAllTooltip' => 'عرض كل العناصر',
        'ToolbarGroupBy' => 'تجميع حسب',
        'ToolbarGroupByTooltip' => 'حدد الحقل الذي سيستعمل من أجل تجميع عناصر القائمة',
        'ToolbarQuickSearch' => 'بحث سريع',
        'ToolbarQuickSearchLabel' => 'بحث',
        'ToolbarQuickSearchTooltip' => 'قم بتحديد الحقل الذي سيتم البحث ضمنه.',
        'ToolbarSeparator' => ' فاصل',

        'PluginsTitle' => 'البحث عن عنصر',
        'PluginsQuery' => 'إستعلام',
        'PluginsFrame' => 'موقع البحث',
        'PluginsLogo' => 'الشعار',
        'PluginsName' => 'الإسم',
        'PluginsSearchFields' => 'حقول البحث',
        'PluginsAuthor' => 'المؤلف',
        'PluginsLang' => 'اللغة',
        'PluginsUseSite' => 'أستخدم الموقع المحدّد من أجل عمليات البحث المستقبلية',
        'PluginsPreferredTooltip' => 'Site recommended by GCstar',
        'PluginDisabled' => 'Disabled',

        'BorrowersTitle' => 'إعدادات الإستعارة',
        'BorrowersList' => 'المستعيرون',
        'BorrowersName' => 'إسم',
        'BorrowersEmail' => 'بريد إلكتروني',
        'BorrowersAdd' => 'إضافة',
        'BorrowersRemove' => 'إزالة',
        'BorrowersEdit' => 'تحرير',
        'BorrowersTemplate' => 'قالب البريد',
        'BorrowersSubject' => 'عنوان الرسالة',
        'BorrowersNotice1' => '%1 سيتم إستبداله بإسم المستعير',
        'BorrowersNotice2' => '%2 سيتم إستبداله بعنوان العنصر',
        'BorrowersNotice3' => '%3 سيتم إستبداله بتاريخ الإستعارة',

        'BorrowersImportTitle' => 'إستيراد معلومات المستعيرين',
        'BorrowersImportType' => 'تنسيق الملف:',
        'BorrowersImportFile' => 'ملف:',

        'BorrowedTitle' => 'عناصر مُعارة', # Accepts model codes
        'BorrowedDate' => 'منذ',
        'BorrowedDisplayInPanel' => 'عرض العنصر في النافذة الرئيسية', # Accepts model codes

        'MailTitle' => 'إرسال رسالة إلكترونية',
        'MailFrom' => 'من: ',
        'MailTo' => 'إلى: ',
        'MailSubject' => 'عنوان الرسالة: ',
        'MailSmtpError' => 'حدث خطأ لدى محاولة الإتصال بملقم SMTP',
        'MailSendmailError' => 'حدث خطأ لدى محاولة الإتصال بواسطة Sendmail',

        'SearchTooltip' => 'البحث بعن عنصر', # Accepts model codes
        'SearchTitle' => 'البحث عن عنصر', # Accepts model codes
        'SearchNoField' => 'No field have been selected for the search box.
Add some of them in the Filters tab of the collection settings.',

        'QueryReplaceField' => 'حقل سيتم إستبداله',
        'QueryReplaceOld' => 'القيمة الحالية',
        'QueryReplaceNew' => 'قيمة جديدة',
        'QueryReplaceLaunch' => 'إستبدال',
        
        'ImportWindowTitle' => 'حدد الحقول التي سيتم إستيرادها',
        'ImportViewPicture' => 'عرض الصورة',
        'ImportSelectAll' => 'تحديد الكل',
        'ImportSelectNone' => 'إلغاء التحديد',

        'MultiSiteTitle' => 'مواقع سيتم إستعمالها في عمليات البحث',
        'MultiSiteUnused' => 'ملحقات غير مستعملة',
        'MultiSiteUsed' => 'ملحقات مستعملة',
        'MultiSiteLang' => 'قم بتعبئة القائمة بالملحقات العربية',
        'MultiSiteEmptyError' => 'لديك قائمة مواقع فارغة',
        'MultiSiteClear' => 'مسح القائمة',
        
        'DisplayOptionsTitle' => 'عناصر سيتم عرضها',
        'DisplayOptionsAll' => 'تحديد الكل',
        'DisplayOptionsSearch' => 'زر البحث',

        'GenresTitle' => 'نوع التحويل',
        'GenresCategoryName' => 'نوع سيتمل استعماله',
        'GenresCategoryMembers' => 'نوع سيتم استبداله',
        'GenresLoad' => 'فتح قائمة',
        'GenresExport' => 'حفظ القائمة لملف',
        'GenresModify' => 'تحرير التحويل',

        'PropertiesName' => 'إسم المجموعة',
        'PropertiesLang' => 'رمز اللغة',
        'PropertiesOwner' => 'المالك',
        'PropertiesEmail' => 'بريد إلكتروني',
        'PropertiesDescription' => 'الوصف',
        'PropertiesFile' => 'معلومات الملف',
        'PropertiesFilePath' => 'مسار كامل',
        'PropertiesItemsNumber' => 'عدد المرات', # Accepts model codes
        'PropertiesFileSize' => 'حجم',
        'PropertiesFileSizeSymbols' => ['بايت', 'كيلوبايت', 'ميغابايت', 'جيجابايت', 'تيرابايت', 'PB', 'EB', 'ZB', 'YB'],
        'PropertiesCollection' => 'خصائص المجموعة',
        'PropertiesDefaultPicture' => 'الصورة الإفتراضية',

        'MailProgramsTitle' => 'برامج من أجل إرسال البريد الإلكتروني',
        'MailProgramsName' => 'الإسم',
        'MailProgramsCommand' => 'سطر الأوامر',
        'MailProgramsRestore' => 'أستعادة الإفتراضيات',
        'MailProgramsAdd' => 'إضافة برنامج',
        'MailProgramsInstructions' => 'في سطر الأوامر، البدائل التالية تقوم بـ:
  %f يتم إستبدالها بعنوان البريد الإلكتروني للمستخدم.
 %t يتم إستبدالها بعنوان البريد الإلكتروني للمستقبل.
 %s يتم إستبدالها بعنوان الرسالة.
 %b يتم إستبدالها بنص الرسالة.',

        'BookmarksBookmarks' => 'إشارات مرجعية',
        'BookmarksFolder' => 'مجلدات',
        'BookmarksLabel' => 'تسمية',
        'BookmarksPath' => 'مسار',
        'BookmarksNewFolder' => 'مجلد جديد',

        'AdvancedSearchType' => 'نوع البحث',
        'AdvancedSearchTypeAnd' => 'مطابقة كل المعايير', # Accepts model codes
        'AdvancedSearchTypeOr' => 'مطايقة معيار واحد على الأقل', # Accepts model codes
        'AdvancedSearchCriteria' => 'المعيار',
        'AdvancedSearchAnyField' => 'أي حقل',
        'AdvancedSearchSaveTitle' => 'حفظ البحث',
        'AdvancedSearchSaveName' => 'الإسم',
        'AdvancedSearchSaveOverwrite' => 'عملية بحث تم حفظها سابقا تحمل نفس التسمية. قم بإختيار تسمية أخرى.',
        'AdvancedSearchUseCase' => 'تحسس حالة الأحرف',
        'AdvancedSearchIgnoreDiacritics' => 'Ignore accents and other diacritics',
 
        'BugReportSubject' => 'تقرير الإبلاغ عن خطأ قام بتوليده جي سي ستار',
        'BugReportVersion' => 'الإصدار',
        'BugReportPlatform' => 'نظام التشغيل',
        'BugReportMessage' => 'رسالة الخطأ',
        'BugReportInformation' => 'معلومات إضافية',

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
