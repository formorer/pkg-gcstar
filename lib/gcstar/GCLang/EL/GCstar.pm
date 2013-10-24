{
    package GCLang::EL;

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

        'LangName' => 'Ελληνικά',
        
        'Separator' => ': ',
        
        'Warning' => '<b>Προσοχή</b>:
        
Οι πληροφορίες που ανακτώνται από τις ιστοσελίδες (μέσω των 
search plugins) προορίζονται για <b>προσωπική χρήση μόνο</b>.
	
Οποιαδήποτε αναδιανομή απαγορεύεται <b>ρητά χωρίς την άδεια</b> 
των ιστοσελίδων.

Για να προσδιορίσετε από ποιο site προέρχονται οι πληροφορίες, μπορείτε 
να χρησιμοποιήσετε το κουμπί κάτω από το σημείο <b>λεπτομέρειες</b>.',
        
        'AllItemsFiltered' => 'Δεν βρέθηκαν αποτελέσματα σύμφωνα με τα κριτήρια αναζήτησης', # Accepts model codes
        
#Installation
        'InstallDirInfo' => 'Εγκατάσταση σε ',
        'InstallMandatory' => 'Υποχρεωτικά στοιχεία',
        'InstallOptional' => 'Προαιρετικά στοιχεία',
        'InstallErrorMissing' => 'Σφάλμα : Τα ακόλουθα στοιχεία Perl πρέπει να εγκατασταθούν: ',
        'InstallPrompt' => 'Βασικός κατάλογος για την εγκατάσταση [/usr/local]: ',
        'InstallEnd' => 'Η εγκατάσταση ολοκληρώθηκε',
        'InstallNoError' => 'Κανένα σφάλμα',
        'InstallLaunch' => 'Για να χρησιμοποιήσετε την εφαρμογή, εκκινήστε ',
        'InstallDirectory' => 'Βασικός κατάλογος',
        'InstallTitle' => 'Εγκατάσταση GCstar',
        'InstallDependencies' => 'Εξαρτήσεις',
        'InstallPath' => 'Διαδρομή',
        'InstallOptions' => 'Ιδιότητες',
        'InstallSelectDirectory' => 'Επιλέξτε τον βασικό κατάλογο που θα γίνει η εγκατάσταση',
        'InstallWithClean' => 'Διαγραφή των αρχείων που βρίσκονται στον κατάλογο της εγκατάστασης',
        'InstallWithMenu' => 'Προσθήκη του GCstar στο μενού Εφαρμογές',
        'InstallNoPermission' => 'Σφάλμα: Δεν έχετε δικαιώματα εγγραφής στον επιλεγμένο κατάλογο',
        'InstallMissingMandatory' => 'Λείπουν υποχρεωτικές εξαρτήσεις. Θα πρέπει να τις προσθέσετε ώστε να εγκαταστήσετε το GCstar στο σύστημά σας.',
        'InstallMissingOptional' => 'Λείπουν οι παρακάτω προαιρετικές εξαρτήσεις. Το GCstar θα συνεχίσει την εγκατάσταση αλλά ίσως κάποιες από τις λειτουργίες δεν θα είναι διαθέσιμες',
        'InstallMissingNone' => 'Δεν λείπει καμία από τις εξαρτήσεις. Μπορείτε να συνεχίσετε κανονικά την εγκατάσταση του GCstar.',
        'InstallOK' => 'OK',
        'InstallMissing' => 'Λείπει',
        'InstallMissingFor' => 'Λείπει για',
        'InstallCleanDirectory' => 'Αφαίρεση των αρχείων του GCstar από τον κατάλογο: ',
        'InstallCopyDirectory' => 'Αντιγραφή αρχείων στον κατάλογο: ',
        'InstallCopyDesktop' => 'Αντιγραφή του εικονιδίου εκκίνησης της εφαρμογής (.desktop) στο: ',

#Update
        'UpdateUseProxy' => 'Χρήση proxy (πατήστε απλά enter αν δεν έχετε ορίσει κάποιον): ',
        'UpdateNoPermission' => 'Δεν έχετε δικαιώματα εγγραφής στον κατάλογο: ',
        'UpdateNone' => 'Δεν βρέθηκαν νέες ενημερώσεις',
        'UpdateFileNotFound' => 'Το αρχείο δεν βρέθηκε',

#Splash
        'SplashInit' => 'Αρχικοποίηση',
        'SplashLoad' => 'Φόρτωση συλλογής',
        'SplashDisplay' => 'Εμφάνιση συλλογής',
        'SplashSort' => 'Ταξινόμηση συλλογής',
        'SplashDone' => 'Έτοιμο',

#Import from GCfilms
        'GCfilmsImportQuestion' => 'Φαίνεται ότι έχετε χρησιμοποιήσει στο παρελθόν GCfilms. Τι θέλετε να κάνετε εισαγωγή από το GCfilms στο GCstar (αυτό δεν θα έχει καμία επίδραση στο GCfilms εάν συνεχίζετε την χρήση του)?',
        'GCfilmsImportOptions' => 'Ρυθμίσεις',
        'GCfilmsImportData' => 'Λίστα ταινιών',

#Menus
        'MenuFile' => '_Αρχείο',
            'MenuNewList' => '_Νέα συλλογή',
            'MenuStats' => 'Στατιστικά',
            'MenuHistory' => 'Αν_οιγμένα πρόσφατα',
            'MenuLend' => 'Ε_μφάνιση διανεισμένων στοιχείων', # Accepts model codes
            'MenuImport' => 'Ει_σαγωγή',	
            'MenuExport' => 'Εξα_γωγή',
            'MenuAddItem' => '_Add Items', # Accepts model codes 
    
        'MenuEdit'  => '_Επεξεργασία',
            'MenuDuplicate' => '_Δημιουργία διπλότυπου', # Accepts model codes
            'MenuDuplicatePlural' => 'Du_plicate Items', # Accepts model codes
            'MenuEditSelectAllItems' => 'Select _All Items', # Accepts model codes
            'MenuEditDeleteCurrent' => '_Αφαίρεση στοιχείου', # Accepts model codes
            'MenuEditDeleteCurrentPlural' => '_Remove Items', # Accepts model codes    
            'MenuEditFields' => 'Α_ντικατάσταση πεδίων',
            'MenuEditLockItems' => '_Κλείδωμα Συλλογής',
    
        'MenuDisplay' => 'Φίλτρα',
            'MenuSavedSearches' => 'Αποθηκευμένες αναζητήσεις',
                'MenuSavedSearchesEdit' => 'Επεξεργασία αποθηκευμένων αναζητήσεων',
                'MenuSavedSearchesSave' => 'Αποθήκευση τρέχουσας αναζήτησης',
            'MenuAdvancedSearch' => 'Ε_ξελιγμένη αναζήτηση',
            'MenuViewAllItems' => 'Εμφάνιση _Όλων ', # Accepts model codes
            'MenuNoFilter' => '_Όλα',
    
        'MenuConfiguration' => '_Ρυθμίσεις',
            'MenuDisplayMenu' => 'Display',
                'MenuDisplayFullScreen' => 'Full screen',
                'MenuDisplayMenuBar' => 'Menus',
                'MenuDisplayToolBar' => 'Toolbar',
                'MenuDisplayStatusBar' => 'Bottom bar',
            'MenuDisplayOptions' => '_Εμφάνιση Πληροφοριών',
            'MenuBorrowers' => '_Δανειολήπτες',
            'MenuToolbarConfiguration' => '_Κουμπιά γραμμής εργαλειών',
            'MenuDefaultValues' => 'Default values for new item', # Accepts model codes
            'MenuGenresConversion' => '_Μετατροπή είδους',
        
        'MenuBookmarks' => 'Οι _Συλλογές μου',
            'MenuBookmarksAdd' => '_Προσθηκη της συλλογής',
            'MenuBookmarksEdit' => '_Επεξεργασία αποθηκευμένων συλλογών',

        'MenuHelp' => '_Βοήθεια',
            'MenuHelpContent' => '_Περιεχόμενα',
            'MenuAllPlugins' => 'Εμφάνιση _plugins',
            'MenuBugReport' => 'Αναφορά _bug',
            'MenuAbout' => '_Σχετικά με το GCstar',
    
        'MenuNewWindow' => 'Εμφάνιση στοιχείων σε _Νέο Παράθυρο', # Accepts model codes
        'MenuNewWindowPlural' => 'Εμφάνιση στοιχείων σε _Νέο Παράθυρο', # Accepts model codes
        
        'ContextExpandAll' => 'Επέκταση όλων',
        'ContextCollapseAll' => 'Σύμπτυξη όλων',
        'ContextChooseImage' => 'Επιλέξτε _Εικόνα',
        'ContextImageEditor' => 'Άνοιγμα με το πρόγραμμα επεξεργασίας εικόνας',
        'ContextOpenWith' => 'Άνοιγμα _με',
        'ContextImgFront' => 'Εξώφυλλο',
        'ContextImgBack' => 'Πίσω φύλλο',
        'ContextChooseFile' => 'Επιλογή αρχείου',
        'ContextChooseFolder' => 'Επιλογή φακέλου',
        
        'DialogEnterNumber' => 'Παρακαλώ εισάγετε τιμή',

        'RemoveConfirm' => 'Θέλετε πραγματικά να διαγραφεί το στοιχείο;', # Accepts model codes
        'RemoveConfirmPlural' => 'Do you really want to remove these items?', # Accepts model codes
        
        'DefaultNewItem' => 'Νέο στοιχείο', # Accepts model codes
        'NewItemTooltip' => 'Προσθήκη νέου στοιχείου', # Accepts model codes
        'NoItemFound' => 'Δεν βρέθηκαν αποτελέσματα. Αναζήτηση σε άλλη ιστοσελίδα;',
        'OpenList' => 'Παρακαλώ επιλέξτε συλλογή',
        'SaveList' => 'Παρακαλώ επιλέξτε που να γίνει η αποθήκευση της συλλογής',
        'SaveListTooltip' => 'Αποθήκευση της συλλογής',
        'SaveUnsavedChanges' => 'Υπάρχουν νέες εγγραφές στην συλλογή σας. Θέλετε να τις αποθηκεύσετε;',
        'SaveDontSave' => 'Να μην αποθηκευθούν',
        'PreferencesTooltip' => 'Ρύθμιση προτιμήσεων',
        'ViewTooltip' => 'Τρόπος εμφάνισης της συλλογής',
        'PlayTooltip' => 'Σχετικό Video', # Accepts model codes
        'PlayFileNotFound' => 'Δεν βρέθηκε το αρχείο σε αυτήν την τοποθεσία:',
        'PlayRetry' => 'Επανάληψη',

        'StatusSave' => 'Αποθήκευση...',
        'StatusLoad' => 'Φόρτωση...',
        'StatusSearch' => 'Αναζήτηση σε εξέλιξη...',
        'StatusGetInfo' => 'Λήψη στοιχείων...',
        'StatusGetImage' => 'Λήψη εικόνας...',
                
        'SaveError' => 'Δεν μπορεί να γίνει η αποθήκευση της συλλογής. Παρακαλώ ελέγξτε τα δικαιώματα εγγραφής και τον ελεύθερο χώρο στον δίσκο.',
        'OpenError' => 'Αδύνατο το άνοιγμα της συλλογής. Παρακαλώ ελέγξτε τα διακιώματα πρόσβασης.',
		'OpenFormatError' => 'Αδυνατο το άνοιγμα της συλλογής. Ο τύπος του αρχείου δεν είναι κατάλληλος.',
        'OpenVersionWarning' => 'Η συλλογή έχει δημιουργηθεί με μια πιο πρόσφατη έκδοση του GCstar. Εάν επιλέξετε να την αποθηκεύσετε, υπάρχει η πιθανότητα απώλειας δεδομένων.',
        'OpenVersionQuestion' => 'Επιθυμείτε να συνεχίσετε;',
        'ImageError' => 'Ο επιλεγμένος κατάλογος για την αποθήκευση των εικόνων δεν ειναι σωστος. Παρακαλώ επιλέξτε εναν άλλον.',
        'OptionsCreationError'=> 'Αδύνατη η δημιουργία του αρχείου ιδιοτήτων: ',
        'OptionsOpenError'=> 'Αδύνατο το άνοιγμα του αρχείου ιδιοτήτων: ',
        'OptionsSaveError'=> 'Αδύνατη η αποθήκευση του αρχείου ιδιοτήτων: ',
        'ErrorModelNotFound' => 'Το μοντέλο δεν βρέθηκε: ',
        'ErrorModelUserDir' => 'Τα καθορισμένα από τον χρήστη μοντέλα βρίσκονται μέσα στο: ',
        
        'RandomTooltip' => 'Τι θα δω απόψε; ',
        'RandomError'=> 'Δεν υπάρχει επιλέξιμο στοιχείο', # Accepts model codes
        'RandomEnd'=> 'Δεν υπάρχουν άλλα στοιχεία', # Accepts model codes
        'RandomNextTip'=> 'Επόμενη πρόταση',
        'RandomOkTip'=> 'Αποδοχή αυτού του στοιχείου',
        
        'AboutTitle' => 'Σχετικά με το GCstar',
        'AboutDesc' => 'Διαχείριση προσωπικών συλλογών',
        'AboutVersion' => 'Έκδοση',
        'AboutTeam' => 'Ομάδα',
        'AboutWho' => 'Christian Jodar (Tian): Υπεύθυνος του project, Προγραμματιστής
Nyall Dawson (Zombiepig): Προγραμματιστής
TPF: Προγραμματιστής
Adolfo González: Προγραμματιστής
',
        'AboutLicense' => 'Διανέμεται με την άδεια χρήσης GNU GPL
Logos Copyright le Spektre',
        'AboutTranslation' => 'Γλενταδάκης Δημήτρης dglent@gmail.com',
        'AboutDesign' => 'Łukasz Kowalczk (Qoolman): Skin Designer
Logo and webdesign by le Spektre',

        'ToolbarRandom' => 'Απόψε',

        'UnsavedCollection' => 'Μη αποθηκευμένη συλλογή',
        'ModelsSelect' => 'Επιλέξτε τον τύπο της συλλογής',
        'ModelsPersonal' => 'Προσωπικοί τύποι',
        'ModelsDefault' => 'Προεπιλεγμένοι τύποι',
        'ModelsList' => 'Ορισμός συλλογής',
        'ModelSettings' => 'Ρυθμίσεις της συλλογής',
        'ModelNewType' => 'Νέος τύπος συλλογής',
        'ModelName' => 'Όνομα του τύπου συλλογής:',
		'ModelFields' => 'Πεδία',
		'ModelOptions'	=> 'Ιδιότητες',
		'ModelFilters'	=> 'Φίλτρα',
        'ModelNewField' => 'Νέο πεδίο',
        'ModelFieldInformation' => 'Πληροφορίες',
        'ModelFieldName' => 'Όνομα:',
        'ModelFieldType' => 'Τύπος:',
        'ModelFieldGroup' => 'Ομάδα:',
        'ModelFieldValues' => 'Τιμές',
        'ModelFieldInit' => 'Προεπιλογή :',
        'ModelFieldMin' => 'Ελάχιστο :',
        'ModelFieldMax' => 'Μέγιστο :',
        'ModelFieldList' => 'Λίστα τιμών :',
        'ModelFieldListLegend' => '<i>Διαχωρισμός με κόμμα</i>',
        'ModelFieldDisplayAs' => 'Εμφάνιση ως:',
        'ModelFieldDisplayAsText' => 'Βαθμός',
        'ModelFieldDisplayAsGraphical' => 'Αστέρια',
        'ModelFieldTypeShortText' => 'Σύντομο κείμενο',
        'ModelFieldTypeLongText' => 'Μακρύ κείμενο',
        'ModelFieldTypeYesNo' => 'Ναι/Όχι',
        'ModelFieldTypeNumber' => 'Αριθμός',
        'ModelFieldTypeDate' => 'Ημερομηνία',
        'ModelFieldTypeOptions' => 'Λίστα προεπιλεγμένων τιμών',
        'ModelFieldTypeImage' => 'Εικόνα',
        'ModelFieldTypeSingleList' => 'Απλή λίστα',
        'ModelFieldTypeFile' => 'Αρχείο',
        'ModelFieldTypeFormatted' => 'Εξαρτάται από άλλα πεδία',
        'ModelFieldParameters' => 'Παράμετροι',
        'ModelFieldHasHistory' => 'Κρατείστε ιστορικό',
        'ModelFieldFlat' => 'Εμφάμιση σε μία σειρά',
        'ModelFieldStep' => 'Τιμή αξησης:',
        'ModelFieldFileFormat' => 'Τύπος αρχείου:',
        'ModelFieldFileFile' => 'Απλό αρχείο',
        'ModelFieldFileImage' => 'Εικόνα',
        'ModelFieldFileVideo' => 'Video',
        'ModelFieldFileAudio' => 'Ήχος',
        'ModelFieldFileProgram' => 'Πρόγραμμα',
        'ModelFieldFileUrl' => 'URL',
        'ModelFieldFileEbook' => 'Ebook',
        'ModelOptionsFields' => 'Χρήση των πεδίων',
        'ModelOptionsFieldsAuto' => 'Αυτόματα',
        'ModelOptionsFieldsNone' => 'Κανένα',
        'ModelOptionsFieldsTitle' => 'Ως τίτλος',
        'ModelOptionsFieldsId' => 'Ως αναγνωριστικό',
        'ModelOptionsFieldsCover' => 'Ως εξώφυλλο',
        'ModelOptionsFieldsPlay' => 'Για το κουμπί Αναπαραγωγή',
        'ModelCollectionSettings' => 'Ρυθμίσεις συλλογής',
        'ModelCollectionSettingsLending' => 'Στοιχεία που μπορούν να δανειστούν',
        'ModelCollectionSettingsTagging' => 'Χρήση ως λέξεις κλειδιά',
        'ModelFilterActivated' => 'Εμφάνιση στο παράθυρο αναζήτησης',
        'ModelFilterComparison' => 'Σύγκριση',
        'ModelFilterContain' => 'Περιέχει',
        'ModelFilterDoesNotContain' => 'Να μην περιέχει',
        'ModelFilterRegexp' => 'Απλή έκφραση',
        'ModelFilterRange' => 'Εύρος',
        'ModelFilterNumeric' => 'Αριθμητική σύγκριση',
        'ModelFilterQuick' => 'Δημιουργία γρήγορου φίλτρου',
        'ModelTooltipName' => 'Χρησιμοποίηση ενός ονόματος το οποίο θα είναι και μοντέλο χρήσης και για άλλες συλλογές. Εάν το αφήσετε κενό, οι ρυθμίσεις θα αποθηκεύονται στην ίδια τη συλλογή',
        'ModelTooltipLabel' => 'Το όνομα του πεδίου όπως θα εμφανίζεται',
        'ModelTooltipGroup' => 'Χρησιμεύει στην ομαδοποίηση των πεδίων. Τα πεδία χωρίς ομάδα θα ταξινομούνται στην ομάδα από προεπιλογή',
        'ModelTooltipHistory' => 'Αν Θα αποθηκεύονται οι προηγούμενες τιμές σε μια λίστα σχετική με το πεδίο',
        'ModelTooltipFormat' => 'Αυτή η μορφή χρησιμεύει ώστε να οριστεί η ενέργεια πατώντας το κουμπί Αναπαραγωγή',
        'ModelTooltipLending' => 'Αυτό θα προσθέσει μερικά πεδία για την διαχείριση των δανεισμών',
        'ModelTooltipTagging' => 'Αυτό θα προσθέσει μερικά πεδία για να διαχειρίζεστε τις λέξεις κλειδιά',
        'ModelTooltipNumeric' => 'Θα πρέπει οι τιμές να θεωρούνται ως αριθμητικές για τις συγκρίσεις',
        'ModelTooltipQuick' => 'Αυτό θα προσθέσει ένα υπο-μενού στο μενού Φίλτρα',
        
        'ResultsTitle' => 'Επιλέξτε ένα στοιχείο', # Accepts model codes
        'ResultsNextTip' => 'Αναζήτηση στο επόμενο site',
        'ResultsPreview' => 'Προεσκόπηση',
        'ResultsInfo' => 'Μπορείτε να προσθέσετε περισσότερα στοιχεία στην συλλογή, επιλέγοντας τα στοιχεία κρατώντας πατημένο το πλήκτρο Ctrl ή Shift', # Accepts model codes
        
        'OptionsTitle' => 'Προτιμήσεις',
		'OptionsExpertMode' => 'Λειτουργία για προχωρημένους',
        'OptionsPrograms' => 'Καθορίστε τις εφαρμογές για το άνοιγμα των αρχείων, αφήστε κενό για χρήση των προεπιλογών του συστήματος',
        'OptionsBrowser' => 'Περιηγητής Ιστιοχώρου',
        'OptionsPlayer' => 'Αναπαραγωγή Video',
        'OptionsAudio' => 'Αναπαραγωγή ήχου',
        'OptionsImageEditor' => 'Πρόγραμμα επεξεργασίας εικόνας',
        'OptionsCdDevice' => 'Συσκευή CD',
        'OptionsImages' => 'Κατάλογος εικόνων',
        'OptionsUseRelativePaths' => 'Χρήση των σχετικών διαδρομών για τις εικόνες',
        'OptionsLayout' => 'Τρόπος εμφάνισης (κεντρικό παράθυρο)',
        'OptionsStatus' => 'Εμφάνιση status bar',
        'OptionsUseStars' => 'Use stars to display ratings',
        'OptionsWarning' => 'Προσοχή: Οι αλλαγές θα πραγματοποιηθούν μετά την επανεκκίνηση της εφαρμογής.',
        'OptionsRemoveConfirm' => 'Επιβεβαίωση πριν από τη διαγραφή',
        'OptionsAutoSave' => 'Αυτόματη αποθήκευση της συλλογής',
        'OptionsAutoLoad' => 'Φόρτωση της προηγούμενης συλλογής κατά την εκκίνηση',
        'OptionsSplash' => 'Εμφάνιση splash screen',
        'OptionsTearoffMenus' => 'Ενεργοποίηση δυνατότητας αποκόλλησης των μενού από την γραμμή εργαλειών',
        'OptionsSpellCheck' => 'Χρήση του ορθογραφικού ελέγχου στα μεγάλα πεδία κειμένου',
        'OptionsProgramTitle' => 'Επιλέξτε το πρόγραμμα που θα χρησιμοποιείται',
		'OptionsPlugins' => 'Ιστιοχώρος για αναζήτηση δεδωμένων',
		'OptionsAskPlugins' => 'Αναζήτηση (Όλα τα sites)',
		'OptionsPluginsMulti' => 'Πολλαπλά sites',
		'OptionsPluginsMultiAsk' => 'Αναζήτηση (Μερικά sites)',
        'OptionsPluginsMultiPerField' => 'Πολλές ιστοσελίδες (ανά πεδίο)',
        'OptionsPluginsMultiPerFieldWindowTitle' => 'Πολλες ιστοσελίδες ανά σειρά επιλογής',
        'OptionsPluginsMultiPerFieldDesc' => 'Για κάθε πεδίο θα συμπληρώνουμε το πεδίο με την πρώτη μη κενή πληροφορία αρχίζοντας απο τ ααριστερά',
        'OptionsPluginsMultiPerFieldFirst' => 'Πρώτο',
        'OptionsPluginsMultiPerFieldLast' => 'Τελευταίο',
        'OptionsPluginsMultiPerFieldRemove' => 'Αφαίρεση',
        'OptionsPluginsMultiPerFieldClearSelected' => 'Λίστα κενών επιλεγμένων πεδίων',
		'OptionsPluginsList' => 'Ορισμός λίστας',
        'OptionsAskImport' => 'Επιλεξτε τα πεδια για εισαγωγή',
		'OptionsProxy' => 'Χρήση proxy',
		'OptionsCookieJar' => 'Χρήση αυτου του αρχείου cookie',
        'OptionsLang' => 'Γλώσσα',
        'OptionsMain' => 'Κυρίως',
        'OptionsPaths' => 'Διαδρομές',
        'OptionsInternet' => 'Internet',
        'OptionsConveniences' => 'Επιπρόσθετα',
        'OptionsDisplay' => 'Εμφάνιση',
        'OptionsToolbar' => 'Γραμμή εργαλειών',
        'OptionsToolbars' => {0 => 'Καμία', 1 => 'Μικρή', 2 => 'Μεγάλη', 3 => 'Εργαλεία συστήματος'},
        'OptionsToolbarPosition' => 'Θέση',
        'OptionsToolbarPositions' => {0 => 'Επάνω', 1 => 'Κάτω', 2 => 'Αριστερά', 3 => 'Δεξιά'},
        'OptionsExpandersMode' => 'Υπερβολικά μακρύ επεκτεινόμενο κείμενο',
        'OptionsExpandersModes' => {'asis' => 'Do nothing', 'cut' => 'Cut', 'wrap' => 'Line wrap'},
        'OptionsDateFormat' => 'Μορφή Ημερομηνίας',
        'OptionsDateFormatTooltip' => 'Η μορφή είναι αυτή που χρησιμοποιείται από strftime(3). Η προεπιλογή είναι %d/%m/%Y',
        'OptionsView' => 'Εμφάνιση λίστας (αριστερή στήλη)',
        'OptionsViews' => {0 => 'Κείμενο', 1 => 'Εικόνα', 2 => 'Λεπτομερώς'},
        'OptionsColumns' => 'Κολώνες',
        'OptionsMailer' => 'Τρόπος αποστολής e-mail',
        'OptionsSMTP' => 'Server',
        'OptionsFrom' => 'E-mail αποστολέα',
        'OptionsTransform' => 'Βάλτε τα άρθρα στο τέλος των τίτλων',
        'OptionsArticles' => 'Άρθρα (Χωριστά με κόμμα)',
        'OptionsSearchStop' => 'Επιτρέπεται η διακοπή της αναζήτησης',
        'OptionsBigPics' => 'Χρήση μεγάλων εικόνων όταν είναι διαθέσιμες',
        'OptionsAlwaysOriginal' => 'Χρήση του κυρίως τίτλου αν το πεδίο είναι κενό',
        'OptionsRestoreAccelerators' => 'Επαναφορά των συντομεύσεων',
        'OptionsHistory' => 'Μέγεθος ιστορικού',
        'OptionsClearHistory' => 'Καθάρισμα ιστορικού',
		'OptionsStyle' => 'Θέμα εμφάνισης',
        'OptionsDontAsk' => 'Να μην ξαναγίνει η ερώτηση',
        'OptionsPathProgramsGroup' => 'Εφαρμογές',
        'OptionsProgramsSystem' => 'Χρήση των προεπιλεγμένων εφαρμογών συστήματος',
        'OptionsProgramsUser' => 'Χρηση συγκεκριμένων εφαρμογών',
        'OptionsProgramsSet' => 'Ορισμός των εφαρμογών',
        'OptionsPathImagesGroup' => 'Εικόνες',
        'OptionsInternetDataGroup' => 'Εισαγωγή δεδομένων',
        'OptionsInternetSettingsGroup' => 'Ρυθμίσεις',
        'OptionsDisplayInformationGroup' => 'Εμφάνιση πληροφοριών',
        'OptionsDisplayArticlesGroup' => 'Άρθρα',
        'OptionsImagesDisplayGroup' => 'Εμφάνιση',
        'OptionsImagesStyleGroup' => 'Μορφή',
        'OptionsDetailedPreferencesGroup' => 'Προτιμήσεις',
        'OptionsFeaturesConveniencesGroup' => 'Ευκολίες',
        'OptionsPicturesFormat' => 'Prefix για τις εικόνες:',
        'OptionsPicturesFormatInternal' => 'gcstar__',
        'OptionsPicturesFormatTitle' => 'Τίτλος ή όνομα συσχετισμένου στοιχείου',
        'OptionsPicturesWorkingDir' => '%WORKING_DIR% ή . θα αντικατασταθεί από τον κατάλογο της συλλογής (μόνο στην αρχή της διαδρομής)',
        'OptionsPicturesFileBase' => '%FILE_BASE% θα αντικατασταθεί από το όνομα της συλλογής χωρίς suffix (.gcs)',
        'OptionsPicturesWorkingDirError' => '%WORKING_DIR% μπορεί να χρησιμοποιηθεί μόνο στην αρχή της διαδρομής των εικόνων',
        'OptionsConfigureMailers' => 'Ρυθμίσεις προγραμμάτων ηλ.ταχυδρομείου',

        'ImagesOptionsButton' => 'Ρυθμίσεις',
        'ImagesOptionsTitle' => 'Ρυθμίσεις για την λίστα εικόνων',
        'ImagesOptionsSelectColor' => 'Επιλέξτε χρώμα',
        'ImagesOptionsUseOverlays' => 'Χρήση εφφέ στις εικόνες',
        'ImagesOptionsBg' => 'Παρασκήνιο',
        'ImagesOptionsBgPicture' => 'Χρήση εικόνας παρασκηνίου',
        'ImagesOptionsFg'=> 'Επιλογή',
        'ImagesOptionsBgTooltip' => 'Αλλαγή χρώματος παρασκηνίου',
        'ImagesOptionsFgTooltip'=> 'Αλλαγή χρώματος επιλογής',
        'ImagesOptionsResizeImgList' => 'Αυτόματη ρύθμιση του αριθμού των στηλών',
        'ImagesOptionsAnimateImgList' => 'Use animations',
        'ImagesOptionsSizeLabel' => 'Μέγεθος',
        'ImagesOptionsSizeList' => {0 => 'Πολύ μικρό', 1 => 'Μικρό', 2 => 'Μεσαίο', 3 => 'Μεγάλο', 4 => 'Πολύ μεγάλο'},
        'ImagesOptionsSizeTooltip' => 'Επιλέξτε το μέγεθος της εικόνας',
		        
        'DetailedOptionsTitle' => 'Ρυθμίσεις της λίστας',
        'DetailedOptionsImageSize' => 'Μέγεθος εικόνας',
        'DetailedOptionsGroupItems' => 'Ομαδοποίηση στοιχείων ανά',
        'DetailedOptionsSecondarySort' => 'Ταξινόμηση πεδίων(στοιχείων της ανωτέρω ομάδας)',
		'DetailedOptionsFields' => 'Επιλογή πεδίων για εμφάνιση',
        'DetailedOptionsGroupedFirst' => 'Ομαδοποίηση αταξινόμητων στοιχείων',
        'DetailedOptionsAddCount' => 'Προσθήκη του αριθμού των στοιχείων στην κατηγορία',

        'ExtractButton' => 'Πληροφορίες',
        'ExtractTitle' => 'Πληροφορίες του αρχείου video',
        'ExtractImport' => 'ΟΚ',

        'FieldsListOpen' => 'Φόρτωση λίστας πεδίων από αρχείο',
        'FieldsListSave' => 'Αποθήκευση της λίστας πεδίων σε αρχείο',
        'FieldsListError' => 'Αυτή η λίστα πεδίων δεν μπορεί να χρησιμοποιηθεί με αυτόν τον τύπο συλλογής',
        'FieldsListIgnore' => '--- Να αγνοηθεί',

        'ExportTitle' => 'Εξαγωγή συλλογής',
        'ExportFilter' => 'Εξαγωγή μόνο των εμφανιζομένων στοιχείων',
        'ExportFieldsTitle' => 'Εξαγωγή πεδίων',
        'ExportFieldsTip' => 'Επιλέξτε τα πεδία για εξαγωγή',
        'ExportWithPictures' => 'Αντιγραφή των εικόνων σε ύπο-κατάλογο',
        'ExportSortBy' => 'Ταξινόμηση ανά',
        'ExportOrder' => 'Σειρά',

        'ImportListTitle' => 'Εισαγωγή άλλης συλλογής',
        'ImportExportData' => 'Δεδομένα',
        'ImportExportFile' => 'Αρχείο',
        'ImportExportFieldsUnused' => 'Αχρησιμοποίητα πεδία',
        'ImportExportFieldsUsed' => 'Χρησιμοποιημένα πεδία',
        'ImportExportFieldsFill' => 'Όλα τα πεδία',
        'ImportExportFieldsClear' => 'Κανένα πεδίο',
        'ImportExportFieldsEmpty' => 'Πρέπει να επιλέξτε τουλάχιστον ένα πεδίο',
        'ImportExportFileEmpty' => 'Πρέπει να ορίσετε ένα όνομα αρχείου',
        'ImportFieldsTitle' => 'Εισαγωγή πεδίων',
        'ImportFieldsTip' => 'Επιλέξτε τα πεδία για εισαγωγή',
        'ImportNewList' => 'Δημιουργία νέας συλλογής',
        'ImportCurrentList' => 'Προσθήκη σε αυτή τη συλλογή',
        'ImportDropError' => 'Σφάλμα κατά το άνοιγμα τουλάχιστον ενός αρχείου. Θα γίνει επαναφόρτωση της προηγούμενης λίστας.',
        'ImportGenerateId' => 'Δημιουργία αναγνωριστικού για κάθε στοιχείο',

        'FileChooserOpenFile' => 'Επιλέξτε αρχείο προς χρήση',
        'FileChooserDirectory' => 'Κατάλογος',
        'FileChooserOpenDirectory' => 'Επιλέξτε έναν κατάλογο',
        'FileChooserOverwrite' => 'Το αρχείο υπάρχει ήδη. Θέλετε να το αντικαταστήσετε;',
        'FileAllFiles' => 'Όλα τα αρχεία',
        'FileVideoFiles' => 'Αρχεία βίντεο',
        'FileEbookFiles' => 'Αρχεία e-book',
        'FileAudioFiles' => 'Αρχεία ήχου',
        'FileGCstarFiles' => 'Συλλογές GCstar',

        #Some default panels
        'PanelCompact' => 'Συγκεντρωτικά',
        'PanelReadOnly' => 'Μόνο ανάγνωση',
        'PanelForm' => 'Καρτέλες',

        'PanelSearchButton' => 'Λήψη στοιχείων',
        'PanelSearchTip' => 'Αναζήτηση στο Internet πληροφορίες γι\' αυτό το όνομα',
        'PanelSearchContextChooseOne' => 'Επιλογή ιστοσελίδας ...',
        'PanelSearchContextMultiSite' => 'Χρήση «πολλών ιστοσελίδων»',
        'PanelSearchContextMultiSitePerField' => 'Χρήση «πολλών ιστοσελίδων ανά πεδίο»',
        'PanelSearchContextOptions' => 'Αλλαγή επιλογών ...',
        'PanelImageTipOpen' => 'Πατήστε στην εικόνα για να επιλέξτε άλλη.',
        'PanelImageTipView' => 'Πατήστε στην εικόνα για να τη δείτε σε πραγματικό μέγεθος.',
        'PanelImageTipMenu' => ' Δεξί κλικ για περισσότερες επιλογές.',
        'PanelImageTitle' => 'Επιλέξτε μια εικόνα',
        'PanelImageNoImage' => 'Καμία εικόνα',
        'PanelSelectFileTitle' => 'Επιλέξτε ένα αρχείο',
        'PanelLaunch' => 'Launch',        
        'PanelRestoreDefault' => 'Επαναφορά προεπιλογής',
        'PanelRefresh' => 'Ενημέρωση',
        'PanelRefreshTip' => 'Ενημέρωση πληροφοριών από το διαδίκτυο',

        'PanelFrom' =>'Από',
        'PanelTo' =>'Εως',

        'PanelWeb' => 'Εμφάνιση πληροφοριών από το Internet',
        'PanelWebTip' => 'Εμφάνιση πληροφοριών αυτού του στοιχείου στο  Internet', # Accepts model codes
        'PanelRemoveTip' => 'Διαγραφή ανωτέρω στοιχείου', # Accepts model codes

        'PanelDateSelect' => 'Αλλαγή',
        'PanelNobody' => 'Κανένας',
        'PanelUnknown' => 'Άγνωστος',
        'PanelAdded' => 'Ημερομηνία προσθήκης',
        'PanelRating' => 'Βαθμολογία',
        'PanelPressRating' => 'Βαθμολόγηση ανά κλικ',
        'PanelLocation' => 'Τοποθεσία',

        'PanelLending' => 'Δανεισμοί',
        'PanelBorrower' => 'Δανειολήπτες',
        'PanelLendDate' => 'Ημερομηνία δανεισμού',
        'PanelHistory' => 'Ιστορικό δανεισμών',
        'PanelReturned' => 'Εχει επιστραφεί', # Accepts model codes
        'PanelReturnDate' => 'Ημερομηνία επιστροφής',
        'PanelLendedYes' => 'Δανεισμένο',
        'PanelLendedNo' => 'Διαθέσιμο',

        'PanelTags' => 'Λέξεις κλειδιά',
        'PanelFavourite' => 'Σελιδοδείκτης',
        'TagsAssigned' => 'Σχετικές λέξεις κλειδιά', 

        'PanelUser' => 'Πεδία χρήστη',

        'CheckUndef' => 'Αδιάφορο',
        'CheckYes' => 'Ναι',
        'CheckNo' => 'Όχι',

        'ToolbarAll' => 'Εμφάνιση όλων',
        'ToolbarAllTooltip' => 'Εμφάνιση όλης της συλλογής',
        'ToolbarGroupBy' => 'Ομαδοποίηση ανά',
        'ToolbarGroupByTooltip' => 'Επιλέξτε με ποιο πεδίο θα γίνει η ομαδοποίηση των στοιχείων στη λίστα',
        'ToolbarQuickSearch' => 'Γρήγορη αναζήτηση',
        'ToolbarQuickSearchLabel' => 'Αναζήτηση',
        'ToolbarQuickSearchTooltip' => 'Επιλέξτε σε ποιο πεδίο θα γίνει η αναζήτηση. Εισάγετε τα κριτήρια αναζήτησης και πατήστε Enter',
        'ToolbarSeparator' => ' Διαχωριστής',
        
        'PluginsTitle' => 'Αναζήτηση στοιχείου',
        'PluginsQuery' => 'Αναζήτηση',
        'PluginsFrame' => 'Αναζήτηση σε ιστοσελίδα',
        'PluginsLogo' => 'Λογότυπο',
        'PluginsName' => 'Όνομα',
        'PluginsSearchFields' => 'Πεδία αναζήτησης',
        'PluginsAuthor' => 'Γράφτηκε από',
        'PluginsLang' => 'Γλώσσα',
        'PluginsUseSite' => 'Χρήση της επιλεγμένης ιστοσελίδας για τις αναζητήσεις',
        'PluginsPreferredTooltip' => 'Η ιστοσελίδα συνιστάται από το GCstar',
        'PluginDisabled' => 'Απενεργοποιημένο',

        'BorrowersTitle' => 'Διαχείριση των δανειοληπτών',
        'BorrowersList' => 'Δανειολήπτες',
        'BorrowersName' => 'Όνομα',
        'BorrowersEmail' => 'E-mail',
        'BorrowersAdd' => 'Προσθήκη',
        'BorrowersRemove' => 'Διαγραφή',
        'BorrowersEdit' => 'Επεξεργασία',
        'BorrowersTemplate' => 'Μοντέλο e-mail',
        'BorrowersSubject' => 'Θέμα μηνύματος',
        'BorrowersNotice1' => '%1 θα αντικατασταθεί από το όνομα του δανειολήπτη',
        'BorrowersNotice2' => '%2 Θα αντικατασταθεί από το όνομα του τίτλου',
        'BorrowersNotice3' => '%3 θα αντικατασταθεί από την ημερομηνία δανεισμού',

        'BorrowersImportTitle' => 'Εισάγετε τις πληροφορίες των δανειοληπτών',
        'BorrowersImportType' => 'Τύπος αρχείου :',
        'BorrowersImportFile' => 'Αρχείο:',

        'BorrowedTitle' => 'Δανεισμένα στοιχεία', # Accepts model codes
        'BorrowedDate' => 'Από',
        'BorrowedDisplayInPanel' => 'Εμφάνιση του στοιχείου στο κυρίως παράθυρο', # Accepts model codes

        'MailTitle' => 'Στείλτε e-mail',
        'MailFrom' => 'Αποστολέας : ',
        'MailTo' => 'Παραλήπτης : ',
        'MailSubject' => 'Θέμα : ',
        'MailSmtpError' => 'Πρόβλημα σύνδεσης με τον SMTP server',
        'MailSendmailError' => 'Πρόβλημα κατά την εκκίνηση του sendmail',

        'SearchTooltip' => 'Αναζήτηση σε όλα τα στοιχεία', # Accepts model codes
        'SearchTitle' => 'Αναζήτηση', # Accepts model codes
        'SearchNoField' => 'Δεν έχετε επιλέξει κάποιο πεδίο για το κουτί αναζήτησης.
Προσθέστε μερικά στην καρτέλα με τα φίλτρα στις ρυθμίσεις της συλλογής.',

        'QueryReplaceField' => 'Πεδία προς επεξεργασία',
        'QueryReplaceOld' => 'Τρέχουσα τιμή',
        'QueryReplaceNew' => 'Νέα τιμή',
        'QueryReplaceLaunch' => 'Αντικατάσταση',
        
        'ImportWindowTitle' => 'Επιλέξτε τα πεδία για εισαγωγή',
        'ImportViewPicture' => 'Εμφάνιση εικόνας',
        'ImportSelectAll' => 'Επιλογή όλων',
        'ImportSelectNone' => 'Καμία επιλογή',

        'MultiSiteTitle' => 'Αναζήτηση στις ιστοσελίδες',
        'MultiSiteUnused' => 'Αχρησιμοποίητα plugins',
        'MultiSiteUsed' => 'Plugins προς χρήση',
        'MultiSiteLang' => 'Fill list with English plugins',
        'MultiSiteEmptyError' => 'Η λίστα με τις ιστοσελίδες είναι άδεια',
        'MultiSiteClear' => 'Καθαρισμός λίστας',
        
        'DisplayOptionsTitle' => 'Εμφάνιση των στοιχείων',
        'DisplayOptionsAll' => 'Επιλογή όλων',
        'DisplayOptionsSearch' => 'Κουμπί αναζήτησης',

        'GenresTitle' => 'Μετατροπή κατηγορίας',
        'GenresCategoryName' => 'Χρηση της κατηγορίας',
        'GenresCategoryMembers' => 'Κατηγορίες προς αντικατάσταση',
        'GenresLoad' => 'Φόρτωση λίστας',
        'GenresExport' => 'Αποθήκευση της λίστας σε αρχείο',
        'GenresModify' => 'Επεξεργασία μετατροπής',

        'PropertiesName' => 'Όνομα συλλογής',
        'PropertiesLang' => 'Κωδικός γλώσσας',
        'PropertiesOwner' => 'Ιδιοκτήτης',
        'PropertiesEmail' => 'E-mail',
        'PropertiesDescription' => 'Περιγραφή',
        'PropertiesFile' => 'Πληροφορίες αρχείου',
        'PropertiesFilePath' => 'Πλήρη διαδρομή',
        'PropertiesItemsNumber' => 'Αριθμός στοιχείων', # Accepts model codes
        'PropertiesFileSize' => 'Μέγεθος',
        'PropertiesFileSizeSymbols' => ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
        'PropertiesCollection' => 'Ιδιότητες συλλογής',
        'PropertiesDefaultPicture' => 'Προεπιλεγμένη εικόνα',

        'MailProgramsTitle' => 'Προγράμματα αποστολής e-mail',
        'MailProgramsName' => 'Όνομα',
        'MailProgramsCommand' => 'Γραμμή εντολών',
        'MailProgramsRestore' => 'Προεπιλεγμένα προγράμματα',
        'MailProgramsAdd' => 'Προσθήκη προγράμματος',
        'MailProgramsInstructions' => 'Στη γραμμή εντολών, γίνονται κάποιες αντικαταστάσεις:
 %f αντικαθίσταται από την διεύθυνση e-mail του χρήστη.
 %t αντικαθίσταται από τον παραλήπτη.
 %s αντικαθίσταται από το θέμα του μηνύματος
 %b αντικαθίσταται από το κυρίως μήνυμα',

        'BookmarksBookmarks' => 'Σελιδοδείκτες',
        'BookmarksFolder' => 'Φάκελοι',
        'BookmarksLabel' => 'Όνομα',
        'BookmarksPath' => 'Διαδρομή',
        'BookmarksNewFolder' => 'Νέος κατάλογος',

        'AdvancedSearchType' => 'Τύπος αναζήτησης',
        'AdvancedSearchTypeAnd' => 'Στοιχεία που ταιριάζουν με όλα τα κριτήρια', # Accepts model codes
        'AdvancedSearchTypeOr' => 'Στοιχεία που ταιριάζουν τουλάχιστον με ένα κριτήριο', # Accepts model codes
        'AdvancedSearchCriteria' => 'Κριτήρια',
        'AdvancedSearchAnyField' => 'Όλα τα πεδία',
        'AdvancedSearchSaveTitle' => 'Αποθήκευση αναζήτησης',
        'AdvancedSearchSaveName' => 'Όνομα',
        'AdvancedSearchSaveOverwrite' => 'Υπάρχει ήδη αποθηκευμένη αναζήτηση με αυτό το όνομα. Παρακαλώ επιλέξτε ένα άλλο.',
        'AdvancedSearchUseCase' => 'Ακριβές όνομα',
        'AdvancedSearchIgnoreDiacritics' => 'Να μην λαμβάνονται υπ\'οψη οι τονισμοί και άλλα διακριτικά',
 
        'BugReportSubject' => 'Δημιουργία αναφοράς bug από το GCstar',
        'BugReportVersion' => 'Έκδοση',
        'BugReportPlatform' => 'Λειτουργικό σύστημα',
        'BugReportMessage' => 'Μήνυμα σφάλματος',
        'BugReportInformation' => 'Πρόσθετες πληροφορίες',

#Statistics
        'Stats3DPie' => 'Πίτα 3Δ',
        'StatsAccumulate' => 'Σύνοψη τιμών',
        'StatsArea' => 'Περιοχές',
        'StatsBars' => 'Μπάρες',
        'StatsDisplayNumber' => 'Εμφάνιση αριθμών',
        'StatsFieldToUse' => 'Πεδίο προς χρήση',
        'StatsFontSize' => 'Μέγεθος γραμματοσειράς',
        'StatsGenerate' => 'Δημιουργία',
        'StatsHeight' => 'Ύψος',
        'StatsHistory' => 'Ιστορικό',
        'StatsKindOfGraph' => 'Τύπος γραφήματος',
        'StatsPie' => 'Πίτα',
        'StatsSave' => 'Αποθήκευση εικόνας στατιστικων σε αρχείο',
        'StatsShowAllDates' => 'Εμφάνιση όλων των ημερομηνιών',
        'StatsSortByNumber' => 'Ταξινόμηση ανά αριθμό {lowercaseX}',
        'StatsWidth' => 'Πλάτος',

        'DefaultValuesTip' => 'Values set in this window will be used as the default values when creating a new {lowercase1}',
    );
}
1;
