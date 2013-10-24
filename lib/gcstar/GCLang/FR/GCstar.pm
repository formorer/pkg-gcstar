{
    package GCLang::FR;
    
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

        'LangName' => 'Français',
        
        'Separator' => ' : ',
        
        'Warning' => '<b>Attention</b> :
        
Les informations récupérées depuis des sites Internet
(grâce aux modules de recherche) ne peuvent servir que
pour une <b>utilisation personnelle</b> dans un cadre privé.

Vous ne pouvez en aucune manière les redistribuer sans
l\'<b>accord préalable</b> des sites concernés.

Vous pourrez à tout instant connaître le site d\'où
proviennent les informations d\'un élément en cliquant sur
le <b>bouton situé en dessous de sa fiche</b>.',

        'AllItemsFiltered' => 'Aucun{lowercaseC1} ne correspond aux critères de filtrage', # Accepts model codes
        
        'InstallDirInfo' => 'Installation dans ',
        'InstallMandatory' => 'Composants obligatoires',
        'InstallOptional' => 'Composants optionnels',
        'InstallErrorMissing' => 'Erreur : Les composants Perl suivants doivent être installés : ',
        'InstallPrompt' => 'Répertoire de base pour l\'installation [/usr/local] : ',
        'InstallEnd' => 'Fin de l\'installation',
        'InstallNoError' => 'Aucune erreur',
        'InstallLaunch' => 'Pour utiliser l\'application, lancez ',
        'InstallDirectory' => 'Répertoire de base',
        'InstallTitle' => 'Installation de GCstar',
        'InstallDependencies' => 'Dépendances',
        'InstallPath' => 'Chemin',
        'InstallOptions' => 'Options',
        'InstallSelectDirectory' => 'Choisissez le répertoire de base pour l\'installation',
        'InstallWithClean' => 'Effacer précédents fichiers situés au même emplacement',
       	'InstallWithMenu' => 'Ajouter GCstar au menu des applications',
       	'InstallNoPermission' => 'Erreur: Vous n\'avez pas la permission d\'écrire dans le répertoire sélectionné',
        'InstallMissingMandatory' => 'Des dépendances obligatoires sont manquantes. Vous ne pourrez pas installer GCstar tant qu\'elles ne seront pas installées.',
        'InstallMissingOptional' => 'Quelques dépendances facultatives sont manquantes. Elles sont listées ci-dessous. GCstar peut être installé mais certaines fonctionnalités ne seront pas présentes.',
        'InstallMissingNone' => 'Aucune dépendance n\'est manquante. Vous pouvez poursuivre l\'installation de GCstar.',
        'InstallOK' => 'OK',
        'InstallMissing' => 'Manquant',
        'InstallMissingFor' => 'Manquant pour',
        'InstallCleanDirectory' => 'Suppression des fichiers GCstar dans le répertoire : ',
        'InstallCopyDirectory' => 'Copie des fichiers dans le répertoire : ',
        'InstallCopyDesktop' => 'Copie du fichier de lancement (.desktop) dans le répertoire : ',

#Update
        'UpdateUseProxy' => 'Proxy à utiliser (appuyer simplement sur Entrée s\'il n\'y en a pas): ',
        'UpdateNoPermission' => 'Pas de permissions d\'écriture dans ce répertoire : ',
        'UpdateNone' => 'Aucune mise à jour trouvée',
        'UpdateFileNotFound' => 'Fichier non trouvé',

#Splash
        'SplashInit' => 'Initialisation',
        'SplashLoad' => 'Chargement de la collection',
        'SplashDisplay' => 'Affichage de la collection',
        'SplashSort' => 'Tri de la collection',
        'SplashDone' => 'Prêt',

#Import from GCfilms
        'GCfilmsImportQuestion' => 'Il semblerait que vous utilisiez GCfilms. Que voulez vous importer de GCfilms vers GCstar (Cela n\'affectera pas GCfilms si vous continuez de l\'utiliser)?',
        'GCfilmsImportOptions' => 'Préférences',
        'GCfilmsImportData' => 'Liste de films',

#Menus
    	'MenuFile' => '_Fichier',
            'MenuNewList' => '_Nouvelle collection',
            'MenuStats' => 'Statistiques',
            'MenuHistory' => 'Fichiers récemment ouverts',
            'MenuLend' => 'Voir les {lowercaseX} empruntés', # Accepts model codes
            'MenuImport' => '_Importer',
            'MenuExport' => '_Exporter',
            'MenuAddItem' => '_Ajouter {lowercaseI1}', # Accepts model codes
    
        'MenuEdit'  => '_Édition',
            'MenuDuplicate' => '_Dupliquer {lowercaseD1}', # Accepts model codes
            'MenuDuplicatePlural' => '_Dupliquer {lowercaseDX}', # Accepts model codes
            'MenuEditSelectAllItems' => 'Selectionner tous {lowercaseDX}', # Accepts model codes
            'MenuEditDeleteCurrent' => 'Su_pprimer {lowercaseD1} courant', # Accepts model codes
            'MenuEditDeleteCurrentPlural' => 'Su_pprimer {lowercaseDX}', # Accepts model codes
            'MenuEditFields' => '_Changer les champs de la collection',
            'MenuEditLockItems' => 'Verroui_ller les informations',
    
        'MenuDisplay' => 'Fil_tres',
            'MenuSavedSearches' => 'Recherches sauvegardées',
                'MenuSavedSearchesSave' => 'Sauvegarder la recherche courante',
                'MenuSavedSearchesEdit' => 'Modifier les recherches sauvegardées',
            'MenuAdvancedSearch' => 'Recherche _Avancée',
            'MenuViewAllItems' => 'Voir _tous {lowercaseDX}', # Accepts model codes
            'MenuNoFilter' => '_Tous',
    
        'MenuConfiguration' => '_Configuration',
            'MenuDisplayMenu' => '_Affichage',
                'MenuDisplayFullScreen' => '_Plein écran',
                'MenuDisplayMenuBar' => '_Menus',
                'MenuDisplayToolBar' => 'Barre d\'_outils',
                'MenuDisplayStatusBar' => 'Barre d\'é_tat',
            'MenuDisplayOptions' => '_Informations à afficher',
            'MenuBorrowers' => '_Emprunteurs',
            'MenuToolbarConfiguration' => '_Boutons de la barre d\'outils',
            'MenuDefaultValues' => 'Valeurs par défaut lors de l\'ajout d{lowercaseDAX}', # Accepts model codes
            'MenuGenresConversion' => 'Conversions de _genres',
    
        'MenuBookmarks' => 'Mes _collections',
            'MenuBookmarksAdd' => '_Ajouter la collection courante',
            'MenuBookmarksEdit' => '_Éditer les collections sauvegardées',

        'MenuHelp' => '_Aide',
            'MenuHelpContent' => '_Contenu',
            'MenuAllPlugins' => 'Voir les _modules',
            'MenuBugReport' => 'Signaler    un _dysfonctionnement',
            'MenuAbout' => 'À _propos de GCstar',

        'MenuNewWindow' => 'Afficher {lowercaseD1} dans une nouvelle fenêtre', # Accepts model codes
        'MenuNewWindowPlural' => 'Afficher {lowercaseDX} dans une nouvelle fenêtre', # Accepts model codes

        'ContextExpandAll' => 'Tout développer',
        'ContextCollapseAll' => 'Tout réduire',
        'ContextChooseImage' => 'Changer l\'_image',
        'ContextOpenWith' => '_Envoyer à',
        'ContextImageEditor' => 'Éditeur d\'images',
        'ContextImgFront' => 'Recto',
        'ContextImgBack' => 'Verso',
        'ContextChooseFile' => 'Sélectionner un fichier',
        'ContextChooseFolder' => 'Sélectionner un répertoire',

        'DialogEnterNumber' => 'Veuillez entrer une valeur',
 
        'RemoveConfirm' => 'Voulez-vous vraiment supprimer {lowercaseM1} ?', # Accepts model codes
        'RemoveConfirmPlural' => 'Voulez-vous vraiment supprimer ces {lowercaseX} ?', # Accepts model codes

        'DefaultNewItem' => 'Nouvel élément', # Accepts model codes
        'NewItemTooltip' => 'Ajouter {lowercaseI1}', # Accepts model codes
        'NoItemFound' => 'Aucun{lowercaseC1} ne correspond. Voulez-vous tenter une recherche sur un autre site ?', # Accepts model codes
        'OpenList' => 'Quelle collection ouvrir ?',
        'SaveList' => 'Dans quel fichier enregistrer ?',
        'SaveListTooltip' => 'Enregistrer la liste courante',
        'SaveUnsavedChanges' => 'Vous avez des changements non sauvegardés dans votre collection. Voulez-vous les sauvegarder ?',
        'SaveDontSave' => 'Ne pas enregistrer',
        'PreferencesTooltip' => 'Changer vos préférences',
        'ViewTooltip' => 'Changer le type de liste',
        'PlayTooltip' => 'Lancer le fichier associé', # Accepts model codes
        'PlayFileNotFound' => 'Le fichier à lancer n\'a pas été trouvé dans cet emplacement :',
        'PlayRetry' => 'Réessayer',
        
        'StatusSave' => 'Sauvegarde...',
        'StatusLoad' => 'Chargement...',
        'StatusSearch' => 'Recherche en cours...',
        'StatusGetInfo' => 'Récupération des informations...',
        'StatusGetImage' => 'Téléchargement de l\'image...',
        
		'SaveError' => 'Impossible de sauver la collection. Vérifiez les permissions et la place disponible sur le disque.',
		'OpenError' => 'Impossible d\'ouvrir la collection. Vérifiez les permissions.',
		'OpenFormatError' => 'Impossible d\'ouvrir la collection. Le format semble ne pas être bon.',
        'OpenVersionWarning' => 'La collection a été créée avec une version plus récente de GCstar. Si vous la sauvegardez, vous pourriez perdre des données.',
        'OpenVersionQuestion' => 'Voulez-vous tout de même continuer ?',
		'ImageError' => 'Le répertoire choisi pour stocker les images n\'est pas correct. Veuillez en choisir un autre.',
        'OptionsCreationError'=> 'Impossible de créer le fichier d\'options : ',
        'OptionsOpenError'=> 'Impossible d\'ouvrir le fichier d\'options : ',
        'OptionsSaveError'=> 'Impossible d\'enregistrer le fichier d\'options : ',
        'ErrorModelNotFound' => 'Modèle non trouvé : ',
        'ErrorModelUserDir' => 'Les modèles créés par l\'utilisateur sont dans : ',

        'RandomTooltip' => 'Que vais-je regarder ce soir ?',
        'RandomError'=> 'Vous n\'avez pas d{lowercaseDA1} pouvant être sélectionné', # Accepts model codes
        'RandomEnd'=> 'Il n\'y a plus d\'autre {lowercase1}', # Accepts model codes
        'RandomNextTip'=> 'Proposition suivante',
        'RandomOkTip'=> 'Accepter cet élément',
        
        'AboutTitle' => 'À propos de GCstar',
        'AboutDesc' => 'Gestionnaire de collections personnelles',
        'AboutVersion' => 'Version',
        'AboutTeam' => 'Équipe',
        'AboutWho' => 'Christian Jodar (Tian) : Gestionnaire du projet, Programmeur
Nyall Dawson (Zombiepig) : Programmeur
TPF : Programmeur
Adolfo González : Programmeur
',
        'AboutLicense' => 'Distribué selon les termes de la GNU GPL
Logos Copyright le Spektre',
        'AboutTranslation' => 'Traduction française par Christian Jodar',
        'AboutDesign' => 'Łukasz Kowalczk (Qoolman): Skin Designer
Logo et webdesign par le Spektre',

        'UnsavedCollection' => 'Collection non sauvegardée',
        'ModelsSelect' => 'Choisissez un type de collection',
        'ModelsPersonal' => 'Types personnels',
        'ModelsDefault' => 'Types par défaut',
        'ModelsList' => 'Définition de la collection',
        'ModelSettings' => 'Réglages de la collection',
        'ModelNewType' => 'Nouveau type de collection',
        'ModelName' => 'Description du type de collection:',
		'ModelFields' => 'Champs',
		'ModelOptions'	=> 'Options',
		'ModelFilters'	=> 'Filtres',
        'ModelNewField' => 'Nouveau champ',
        'ModelFieldInformation' => 'Informations',
        'ModelFieldName' => 'Nom :',
        'ModelFieldType' => 'Type de champ :',
        'ModelFieldGroup' => 'Groupe :',
        'ModelFieldValues' => 'Valeurs',
        'ModelFieldInit' => 'Défaut :',
        'ModelFieldMin' => 'Minimum :',
        'ModelFieldMax' => 'Maximum :',
        'ModelFieldList' => 'Liste des valeurs :',
        'ModelFieldListLegend' => '<i>Séparées par des virgules</i>',
        'ModelFieldDisplayAs' => 'Afficher comme :',
        'ModelFieldDisplayAsText' => 'Texte',
        'ModelFieldDisplayAsGraphical' => 'Notation',
        'ModelFieldTypeShortText' => 'Texte court',
        'ModelFieldTypeLongText' => 'Texte long',
        'ModelFieldTypeYesNo' => 'Oui/Non',
        'ModelFieldTypeNumber' => 'Nombre',
        'ModelFieldTypeDate' => 'Date',
        'ModelFieldTypeOptions' => 'Liste de valeurs prédéfinies',
        'ModelFieldTypeImage' => 'Image',
        'ModelFieldTypeSingleList' => 'Liste simple',
        'ModelFieldTypeFile' => 'Fichier',
        'ModelFieldTypeFormatted' => 'Dépendant d\'autres champs',
        'ModelFieldParameters' => 'Paramètres',
        'ModelFieldHasHistory' => 'Garder un historique',
        'ModelFieldFlat' => 'Afficher sur une seule ligne',
        'ModelFieldStep' => 'Valeur d\'incrément :',
        'ModelFieldFileFormat' => 'Format du fichier :',
        'ModelFieldFileFile' => 'Simple fichier',
        'ModelFieldFileImage' => 'Image',
        'ModelFieldFileVideo' => 'Vidéo',
        'ModelFieldFileAudio' => 'Son',
        'ModelFieldFileProgram' => 'Programme',
        'ModelFieldFileUrl' => 'URL',
        'ModelFieldFileEbook' => 'Ebook',
        'ModelOptionsFields' => 'Champs à utiliser',
        'ModelOptionsFieldsAuto' => 'Automatique',
        'ModelOptionsFieldsNone' => 'Aucun',
        'ModelOptionsFieldsTitle' => 'En tant que titre',
        'ModelOptionsFieldsId' => 'En tant qu\'identifiant',
        'ModelOptionsFieldsCover' => 'En tant que couverture',
        'ModelOptionsFieldsPlay' => 'Pour le bouton Lecture',
        'ModelCollectionSettings' => 'Réglages de la collection',
        'ModelCollectionSettingsLending' => 'Les éléments peuvent être empruntés',
        'ModelCollectionSettingsTagging' => 'Les éléments peuvent être marqués',
        'ModelFilterActivated' => 'Présent dans la fenêtre de recherche',
        'ModelFilterComparison' => 'Comparaison',
        'ModelFilterContain' => 'Contient',
        'ModelFilterDoesNotContain' => 'Ne contient pas',
        'ModelFilterRegexp' => 'Expression régulière',
        'ModelFilterRange' => 'Intervalle',
        'ModelFilterNumeric' => 'La comparaison est numérique',
        'ModelFilterQuick' => 'Créer un filtre rapide',
        'ModelTooltipName' => 'Utiliser un nom pour ré-utiliser ce modèle pour plusieurs collections. S\'il est vide, les réglages seront stockées dans la collection elle-même.',
        'ModelTooltipLabel' => 'Le nom du champ tel qu\'il sera affiché.',
        'ModelTooltipGroup' => 'Utilisé pour grouper les champs. Les champs sans groupe seront mis dans un groupe par défaut.',
        'ModelTooltipHistory' => 'Est-ce qu\'un historique des valeurs entrées doit être conservé dans une liste.',
        'ModelTooltipFormat' => 'Ce format sert à déterminer l\'action à effectuer lors de l\'appui sur le bouton de lecture.',
        'ModelTooltipLending' => 'Cela va ajouter des champs pour gérer les emprunts.',
        'ModelTooltipTagging' => 'Cela va ajouter des champs pour gérer les marques et mots-clés',
        'ModelTooltipNumeric' => 'Indique que les valeurs doivent être considérées comme des nombres pour les comparaisons.',
        'ModelTooltipQuick' => 'Ajoutera un sous-menu dans le menu Filtres',

        'ResultsTitle' => 'Choisissez {lowercaseI1}', # Accepts model codes
        'ResultsNextTip' => 'Rechercher sur le site suivant',
        'ResultsPreview' => 'Aperçu',
        'ResultsInfo' => 'Vous pouvez ajouter plusieurs {lowercaseX} à la collection en maintenant la touche Shift ou Ctrl et en les sélectionnant', # Accepts model codes

        'OptionsTitle' => 'Préférences',
		'OptionsExpertMode' => 'Mode expert',
        'OptionsPrograms' => 'Indiquez les applications à utiliser, ou laissez vide pour utiliser celles par défaut',
        'OptionsBrowser' => 'Navigateur web',
        'OptionsPlayer' => 'Lecteur de vidéos',
        'OptionsAudio' => 'Lecteur audio',
        'OptionsImageEditor' => 'Éditeur d\'images',
        'OptionsCdDevice' => 'Périphérique CD',
        'OptionsImages' => 'Répertoire images',
        'OptionsUseRelativePaths' => 'Utiliser des chemins relatifs pour les images',
        'OptionsLayout' => 'Disposition',
        'OptionsStatus' => 'Afficher la barre d\'état en bas de la fenêtre',
        'OptionsUseStars' => 'Afficher les notes avec des étoiles',
        'OptionsWarning' => 'Attention : Les changements effectués dans cet onglet ne seront pris en compte qu\'après un redémarrage de l\'application',
        'OptionsRemoveConfirm' => 'Demander confirmation avant la suppression',
        'OptionsAutoSave' => 'Sauvegarde automatique de la collection',
        'OptionsAutoLoad' => 'Ouvrir la collection précédente au démarrage',
        'OptionsSplash' => 'Afficher l\'écran de démarrage',
        'OptionsTearoffMenus' => 'Activer les menus détachables',
        'OptionsSpellCheck' => 'Utiliser le vérificateur orthographique pour les champs texte longs',
        'OptionsProgramTitle' => 'Choisissez le programme à utiliser',
		'OptionsPlugins' => 'Site où récupérer les fiches',
		'OptionsAskPlugins' => 'Demander (Tous les sites)',
		'OptionsPluginsMulti' => 'Plusieurs sites',
		'OptionsPluginsMultiAsk' => 'Demander (Certains sites)',
        'OptionsPluginsMultiPerField' => 'Plusieurs sites (par champs)',
        'OptionsPluginsMultiPerFieldWindowTitle' => 'Choix de l\'ordre pour plusieurs sites par champs',
        'OptionsPluginsMultiPerFieldDesc' => 'Pour chaque champs sélectionné, on remplira avec la première information non vide trouvée, en partant de gauche.',
        'OptionsPluginsMultiPerFieldFirst' => 'En premier',
        'OptionsPluginsMultiPerFieldLast' => 'En dernier',
        'OptionsPluginsMultiPerFieldRemove' => 'Supprimer',
        'OptionsPluginsMultiPerFieldClearSelected' => 'Vider les listes sélectionnées',
		'OptionsPluginsList' => 'Définir la liste',		
        'OptionsAskImport' => 'Choisir les champs à importer',
		'OptionsProxy' => 'Utiliser un proxy',
		'OptionsCookieJar' => 'Utiliser ce fichier de cookies',
        'OptionsMain' => 'Principal',
        'OptionsLang' => 'Langue',
        'OptionsPaths' => 'Chemins',
        'OptionsInternet' => 'Internet',
        'OptionsConveniences' => 'Options',
        'OptionsDisplay' => 'Affichage',
        'OptionsToolbar' => 'Barre d\'outils',
        'OptionsToolbars' => {0 => 'Aucune', 1 => 'Petite', 2 => 'Grande', 3 => 'Réglage système'},
        'OptionsToolbarPosition' => 'Position',
        'OptionsToolbarPositions' => {0 => 'Haut', 1 => 'Bas', 2 => 'Gauche', 3 => 'Droite'},
        'OptionsExpandersMode' => 'Texte replié trop long',
        'OptionsExpandersModes' => {'asis' => 'Ne rien faire', 'cut' => 'Couper', 'wrap' => 'Aller à la ligne'},
        'OptionsDateFormat' => 'Format des dates',
        'OptionsDateFormatTooltip' => 'Le format est celui utilisé par strftime(3). La valeur par défaut est %d/%m/%Y',
        'OptionsView' => 'Type de liste',
        'OptionsViews' => {0 => 'Texte', 1 => 'Image', 2 => 'Détaillée'},
        'OptionsColumns' => 'Colonnes',
        'OptionsMailer' => 'Méthode d\'envoi d\'e-mails',
        'OptionsSMTP' => 'Serveur',
        'OptionsFrom' => 'E-mail expéditeur',
        'OptionsTransform' => 'Mettre à la fin des titres les articles',
        'OptionsArticles' => 'Articles (Séparés par des virgules)',
        'OptionsSearchStop' => 'Une recherche peut être arrêtée',
        'OptionsBigPics' => 'Utiliser les grandes images quand disponibles',
        'OptionsAlwaysOriginal' => 'Utiliser le titre principal comme titre original si non présent',
        'OptionsRestoreAccelerators' => 'Rétablir raccourcis',
		'OptionsHistory' => 'Taille de l\'historique',
		'OptionsClearHistory' => 'Purger l\'historique',
		'OptionsStyle' => 'Thème',
        'OptionsDontAsk' => 'Ne plus demander',
        'OptionsPathProgramsGroup' => 'Applications',
        'OptionsProgramsSystem' => 'Utiliser les programmes définis par le système',
        'OptionsProgramsUser' => 'Utiliser les programmes spécifiés',
        'OptionsProgramsSet' => 'Régler les programmes',
        'OptionsPathImagesGroup' => 'Images',
        'OptionsInternetDataGroup' => 'Récupération des données',
        'OptionsInternetSettingsGroup' => 'Réglages',
        'OptionsDisplayInformationGroup' => 'Affichage des informations',
        'OptionsDisplayArticlesGroup' => 'Articles',
        'OptionsImagesDisplayGroup' => 'Affichage',
        'OptionsImagesStyleGroup' => 'Style',
        'OptionsDetailedPreferencesGroup' => 'Préférences',
        'OptionsFeaturesConveniencesGroup' => 'Commodités',
        'OptionsPicturesFormat' => 'Préfixe à utiliser pour les images :',
        'OptionsPicturesFormatInternal' => 'gcstar__',
        'OptionsPicturesFormatTitle' => 'Le titre ou le nom de l\'élément associé',
        'OptionsPicturesWorkingDir' => '%WORKING_DIR% ou . sera remplacé par le répertoire de la collection (seulement utilisable en début)',
        'OptionsPicturesFileBase' => '%FILE_BASE% sera remplacé par le fichier contenant la collection sans son suffixe (.gcs)',
        'OptionsPicturesWorkingDirError' => '%WORKING_DIR% peut seulement être utilisé au début du chemin pour les images',
        'OptionsConfigureMailers' => 'Configurer les clients mail',

        'ImagesOptionsButton' => 'Réglages',
        'ImagesOptionsTitle' => 'Réglages pour la liste d\'images',
        'ImagesOptionsSelectColor' => 'Choisissez une couleur',
        'ImagesOptionsUseOverlays' => 'Effet brillant',
        'ImagesOptionsBg' => 'Fond',
        'ImagesOptionsBgPicture' => 'Utiliser une image de fond',
        'ImagesOptionsFg'=> 'Sélection',
        'ImagesOptionsBgTooltip' => 'Changer la couleur de fond',
        'ImagesOptionsFgTooltip'=> 'Changer la couleur de la sélection',
        'ImagesOptionsResizeImgList' => 'Changer dynamiquement le nombre de colonnes',
        'ImagesOptionsAnimateImgList' => 'Utiliser des animations',
        'ImagesOptionsSizeLabel' => 'Taille',
        'ImagesOptionsSizeList' => {0 => 'Minuscule', 1 => 'Petit', 2 => 'Moyen', 3 => 'Grand', 4 => 'Énorme'},
        'ImagesOptionsSizeTooltip' => 'Sélectionnez la taille pour les images',

        'DetailedOptionsTitle' => 'Réglages pour la liste détaillée',
        'DetailedOptionsImageSize' => 'Taille des images',
        'DetailedOptionsGroupItems' => 'Grouper les éléments par',
        'DetailedOptionsSecondarySort' => 'Trier les enfants par',
		'DetailedOptionsFields' => 'Choisir les champs à afficher',
        'DetailedOptionsGroupedFirst' => 'Garder ensemble les éléments orphelins',
        'DetailedOptionsAddCount' => 'Ajouter le nombre d\'éléments sur les catégories',

        'ExtractButton' => 'Informations',
        'ExtractTitle' => 'Informations du fichier vidéo',
        'ExtractImport' => 'Utiliser les valeurs',

        'FieldsListOpen' => 'Charger une liste de champs depuis un fichier',
        'FieldsListSave' => 'Sauvegarder la liste des champs dans un fichier',
        'FieldsListError' => 'Cette liste de champs ne peut pas être utilisée avec ce type de collection',
        'FieldsListIgnore' => '--- Ignorer',

        'ExportTitle' => 'Exporter la collection',
        'ExportFilter' => 'Exporter seulement les éléments affichés',
        'ExportFieldsTitle' => 'Champs à exporter',
        'ExportFieldsTip' => 'Choisir les champs devant être exportés',
        'ExportWithPictures' => 'Copier les images dans un sous-répertoire',
        'ExportSortBy' => 'Trier selon',
        'ExportOrder' => 'Ordre',

        'ImportListTitle' => 'Importer une autre collection',
        'ImportExportData' => 'Données',
        'ImportExportFile' => 'Fichier',
        'ImportExportFieldsUnused' => 'Champs inutilisés',
        'ImportExportFieldsUsed' => 'Champs utilisés',
        'ImportExportFieldsFill' => 'Tous les champs',
        'ImportExportFieldsClear' => 'Aucun champ',
        'ImportExportFieldsEmpty' => 'Au moins un champ doit être spécifié',
        'ImportExportFileEmpty' => 'Un nom de fichier doit être spécifié',
        'ImportFieldsTitle' => 'Champs à importer',
        'ImportFieldsTip' => 'Choisir les champs devant être importés',
        'ImportNewList' => 'Créer une nouvelle liste',
        'ImportCurrentList' => 'Ajouter à la liste courante',
        'ImportDropError' => 'Il y a eu une erreur dans l\'ouverture d\'au moins un fichier. La liste précédente va être rechargée.',
        'ImportGenerateId' => 'Générer l\'identifiant de chaque élément',
        
        'FileChooserOpenFile' => 'Choisissez le fichier à utiliser',
        'FileChooserDirectory' => 'Répertoire',
        'FileChooserOpenDirectory' => 'Choisissez un répertoire',
        'FileChooserOverwrite' => 'Ce fichier existe. Voulez vous le remplacer ?',
        'FileAllFiles' => 'Tous les fichiers',
        'FileVideoFiles' => 'Fichier vidéos',
        'FileEbookFiles' => 'Fichiers ebook (livres électroniques)',
        'FileAudioFiles' => 'Fichiers sons',
        'FileGCstarFiles' => 'Collections GCstar',

        'PanelCompact' => 'Compact',
        'PanelReadOnly' => 'Lecture seule',
        'PanelForm' => 'Onglets',

        'PanelSearchButton' => 'Télécharger',
        'PanelSearchTip' => 'Rechercher les informations concernant l\'élément dont le nom a été saisi',
        'PanelSearchContextChooseOne' => 'Choisir un site ...',
        'PanelSearchContextMultiSite' => 'Utiliser "plusieurs sites"',
        'PanelSearchContextMultiSitePerField' => 'Utiliser "plusieurs sites par champs"',
        'PanelSearchContextOptions' => 'Changer les options ...',
        'PanelImageTipOpen' => 'Cliquez sur l\'image pour en choisir une autre.',
        'PanelImageTipView' => 'Cliquez sur l\'image pour la voir en taille réelle.',
        'PanelImageTipMenu' => ' Clic droit pour plus d\'options.',
        'PanelImageTitle' => 'Sélectionnez une image',
        'PanelImageNoImage' => 'Pas d\'image',
        'PanelSelectFileTitle' => 'Sélectionnez un fichier',
        'PanelLaunch' => 'Démarrer',        
        'PanelRestoreDefault' => 'Rétablir défaut',
        'PanelRefresh' => 'Rafraîchir',
        'PanelRefreshTip' => 'Mettre à jour les informations depuis Internet',

        'PanelFrom' =>'Entre',
        'PanelTo' =>'et',

        'PanelWeb' => 'Voir la fiche Internet',
        'PanelWebTip' => 'Voir la fiche {lowercaseDD1} sur Internet', # Accepts model codes
        'PanelRemoveTip' => 'Supprimer {lowercaseD1} affiché ci-dessus', # Accepts model codes

        'PanelDateSelect' => 'Changer',
        'PanelNobody' => 'Personne',
        'PanelUnknown' => 'Inconnu',
        'PanelAdded' => 'Date d\'ajout',
        'PanelRating' => 'Note',
        'PanelPressRating' => 'Note Presse',
        'PanelLocation' => 'Emplacement',

        'PanelLending' => 'Emprunts',
        'PanelBorrower' => 'Emprunteur',
        'PanelLendDate' => 'Date d\'emprunt',
        'PanelHistory' => 'Historique des emprunts',
        'PanelReturned' => '{1} _Rendu', # Accepts model codes
        'PanelReturnDate' => 'Date de retour',
        'PanelLendedYes' => 'Prêté',
        'PanelLendedNo' => 'Disponible',

        'PanelTags' => 'Étiquettes',
        'PanelFavourite' => 'Favori',
        'TagsAssigned' => 'Mots-clés associés',

        'PanelUser' => 'Champs utilisateur',

        'CheckUndef' => 'Sans importance',
        'CheckYes' => 'Oui',
        'CheckNo' => 'Non',

        'ToolbarRandom' => 'Ce soir',
        'ToolbarAll' => 'Voir tous',
        'ToolbarAllTooltip' => 'Afficher toute la collection',
        'ToolbarGroupBy' => 'Grouper par',
        'ToolbarGroupByTooltip' => 'Choisir le champ à utiliser pour regrouper les éléments dans la liste',
        'ToolbarQuickSearch' => 'Recherche rapide',
        'ToolbarQuickSearchLabel' => 'Rechercher',
        'ToolbarQuickSearchTooltip' => 'Choisissez le champ dans lequel rechercher, entrez le texte de la recherche et pressez Entréé',
        'ToolbarSeparator' => ' Séparateur',

        'PluginsTitle' => 'Chercher un élément',
        'PluginsQuery' => 'Recherche',
        'PluginsFrame' => 'Site où rechercher',
        'PluginsLogo' => 'Logo',
        'PluginsName' => 'Nom',
        'PluginsSearchFields' => 'Champs de recherche',
        'PluginsAuthor' => 'Auteur',
        'PluginsLang' => 'Langue',
        'PluginsUseSite' => 'Utiliser le site sélectionné pour les futures recherches',
        'PluginsPreferredTooltip' => 'Site recommandé par GCstar',
        'PluginDisabled' => 'Désactivé',
        
        'BorrowersTitle' => 'Configuration des emprunteurs',
        'BorrowersList' => 'Emprunteurs',
        'BorrowersName' => 'Nom',
        'BorrowersEmail' => 'E-mail',
        'BorrowersAdd' => 'Ajouter',
        'BorrowersRemove' => '_Supprimer',
        'BorrowersEdit' => '_Modifier',
        'BorrowersTemplate' => 'Modèle d\'e-mail',
        'BorrowersSubject' => 'Titre du mail : ',
        'BorrowersNotice1' => '%1 sera remplacé par le nom de l\'emprunteur',
        'BorrowersNotice2' => '%2 sera remplacé par le nom de l\'élément',
        'BorrowersNotice3' => '%3 sera remplacé par la date de l\'emprunt',
      
        'BorrowersImportTitle' => 'Importer les informations d\'emprunteurs',
        'BorrowersImportType' => 'Format du fichier :',
        'BorrowersImportFile' => 'Fichier :',

        'BorrowedTitle' => '{X} empruntés', # Accepts model codes
        'BorrowedDate' => 'Depuis le',
        'BorrowedDisplayInPanel' => 'Voir {lowercaseD1} dans la fenêtre principale', # Accepts model codes

        'MailTitle' => '_Envoyer un e-mail',
        'MailFrom' => 'De : ',
        'MailTo' => 'A : ',
        'MailSubject' => 'Objet : ',
        'MailSmtpError' => 'Problème de connexion au serveur SMTP',
        'MailSendmailError' => 'Problème au lancement de sendmail',
                
        'SearchTooltip' => 'Rechercher dans tous {lowercaseDX}', # Accepts model codes
        'SearchTitle' => 'Recherche d{lowercaseDAX}', # Accepts model codes
        'SearchNoField' => 'Aucun champ n\'a été sélectionné pour la fenêtre de recherche.
Ils peuvent être ajoutés dans l\'onglet Filtres des réglages de la collection.',
        
        'QueryReplaceField' => 'Champs à modifier',
        'QueryReplaceOld' => 'Valeur actuelle',
        'QueryReplaceNew' => 'Nouvelle valeur',
        'QueryReplaceLaunch' => 'Remplacer',
        
        'ImportWindowTitle' => 'Choisir les champs à importer',
        'ImportViewPicture' => 'Voir l\'image',
        'ImportSelectAll' => 'Tout sélectionner',
        'ImportSelectNone' => 'Ne rien sélectionner',

        'MultiSiteTitle' => 'Sites où rechercher',
        'MultiSiteUnused' => 'Modules non utilisés',
        'MultiSiteUsed' => 'Modules à utiliser',
        'MultiSiteLang' => 'Remplir la liste avec les modules français',
        'MultiSiteEmptyError' => 'Vous avez une liste de sites vide',
        'MultiSiteClear' => 'Vider la liste',
        
        'DisplayOptionsTitle' => 'Éléments à afficher',
        'DisplayOptionsAll' => 'Tout sélectionner',
        'DisplayOptionsSearch' => 'Bouton recherche',
        
        'GenresTitle' => 'Conversions de genres',
        'GenresCategoryName' => 'Genre à utiliser',
        'GenresCategoryMembers' => 'Genres à remplacer',
        'GenresLoad' => 'Charger une liste prédéfinie',
        'GenresExport' => 'Exporter la liste dans un fichier',
        'GenresModify' => 'Changer la conversion',

        'PropertiesName' => 'Nom de la collection',
        'PropertiesLang' => 'Code langue',
        'PropertiesOwner' => 'Propriétaire',
        'PropertiesEmail' => 'Adresse e-mail',
        'PropertiesDescription' => 'Description',
        'PropertiesFile' => 'Informations sur le fichier',
        'PropertiesFilePath' => 'Chemin complet',
        'PropertiesItemsNumber' => 'Nombre d{lowercaseDAX}', # Accepts model codes
        'PropertiesFileSize' => 'Taille',
        'PropertiesFileSizeSymbols' => ['octets', 'Ko', 'Mo', 'Go', 'To', 'Po', 'Eo', 'Zo', 'Yo'],
        'PropertiesCollection' => 'Propriétés de la collection',
        'PropertiesDefaultPicture' => 'Image par défaut',

        'MailProgramsTitle' => 'Programmes pour envoyer des emails',
        'MailProgramsName' => 'Nom',
        'MailProgramsCommand' => 'Ligne de commande',
        'MailProgramsRestore' => 'Programmes par défaut',
        'MailProgramsAdd' => 'Ajouter un programme',
        'MailProgramsInstructions' => 'Dans la ligne de commande des substitutions seront effectuées :
 %f sera remplacé par l\'adresse email de l\'utilisateur.
 %t sera remplacé par le destinataire.
 %s sera remplacé par le sujet du message.
 %b sera remplacé par le contenu du message.',

        'BookmarksBookmarks' => 'Collections',
        'BookmarksFolder' => 'Répertoire',
        'BookmarksLabel' => 'Nom',
        'BookmarksPath' => 'Chemin',
        'BookmarksNewFolder' => 'Nouveau répertoire',

        'AdvancedSearchType' => 'Type de recherche',
        'AdvancedSearchTypeAnd' => '{X} correspondants à tous les critères', # Accepts model codes
        'AdvancedSearchTypeOr' => '{X} correspondants à au moins un critère', # Accepts model codes
        'AdvancedSearchCriteria' => 'Critères',
        'AdvancedSearchAnyField' => 'N\'importe quel champ',
        'AdvancedSearchSaveTitle' => 'Sauvegarder la recherche',
        'AdvancedSearchSaveName' => 'Nom',
        'AdvancedSearchSaveOverwrite' => 'Il y a déjà une recherche sauvegardée avec ce nom. Veuillez en choisir un autre.',
        'AdvancedSearchUseCase' => 'Différencier majuscules et minuscules',
        'AdvancedSearchIgnoreDiacritics' => 'Ignorer les accents et autres diacritiques',

        'BugReportSubject' => 'Rapport d\'erreur généré depuis GCstar',
        'BugReportVersion' => 'Version',
        'BugReportPlatform' => 'Système d\'exploitation',
        'BugReportMessage' => 'Message d\'erreur',
        'BugReportInformation' => 'Informations complémentaires',

#Statistics
        'StatsFieldToUse' => 'Champ à utiliser',
        'StatsSortByNumber' => 'Trier par nombre de {lowercaseX}',
        'StatsGenerate' => 'Générer',
        'StatsKindOfGraph' => 'Type de représentation',
        'StatsBars' => 'Barres',
        'StatsPie' => 'Camembert',
        'Stats3DPie' => 'Camembert 3D',
        'StatsArea' => 'Zones',
        'StatsHistory' => 'Historique',
        'StatsWidth' => 'Largeur',
        'StatsHeight' => 'Hauteur',
        'StatsFontSize' => 'Taille de la police',
        'StatsDisplayNumber' => 'Montrer les valeurs',
        'StatsSave' => 'Sauvegarder les statistiques dans un fichier',
        'StatsAccumulate' => 'Accumuler les valeurs',
        'StatsShowAllDates' => 'Montrer toutes les dates',

        'DefaultValuesTip' => 'Les valeurs définies dans cette fenêtre seront utilisées lors de l\'ajout d\'{lowercaseI1}',
    );
}
1;
