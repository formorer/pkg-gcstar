; NSIS for GCstar ( http://www.gcstar.org/ )
; Based on Frozen Bubble NSIS

; Helper defines
!define PRODUCT_NAME "GCstar"
!define PRODUCT_VERSION "1.7.0"
!define PRODUCT_PUBLISHER "Tian"
!define PRODUCT_WEB_SITE "http://www.gcstar.org/"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\${PRODUCT_NAME}"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_STARTMENU_REGVAL "NSIS:StartMenuDir"

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "img\icon_install.ico"
!define MUI_UNICON "img\icon_uninstall.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP "img\banner_top.bmp"
!define MUI_HEADERIMAGE_UNBITMAP "img\uninstall_top.bmp"

!define MUI_COMPONENTSPAGE_CHECKBITMAP "img\checks.bmp"

!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_FUNCTION "LaunchGCstar"
!define MUI_FINISHPAGE_RUN_TEXT "$(FINISH_LAUNCH)"

!define MUI_FINISHPAGE_LINK "$(FINISH_WEBSITE)"
!define MUI_FINISHPAGE_LINK_LOCATION "${PRODUCT_WEB_SITE}"
!define MUI_FINISHPAGE_LINK_COLOR "1C86EE"

;COLORS
!define MUI_BGCOLOR "FFFFFF"
!define MUI_LICENSEPAGE_BGCOLOR "FFFFFF"
!define MUI_INSTALLCOLORS "1C86EE FFFFFF"
!define MUI_INSTFILESPAGE_COLORS "1C86EE FFFFFF"

; Language Selection Dialog Settings
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

; Welcome page
!define MUI_WELCOMEFINISHPAGE_BITMAP "img\banner_left.bmp"
!insertmacro MUI_PAGE_WELCOME
; License page
!define MUI_LICENSEPAGE_CHECKBOX
!insertmacro MUI_PAGE_LICENSE "LICENSE"
; Components page
!insertmacro MUI_PAGE_COMPONENTS
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Start menu page
var ICONS_GROUP
;!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "GCstar"
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "${PRODUCT_STARTMENU_REGVAL}"
!insertmacro MUI_PAGE_STARTMENU Application $ICONS_GROUP
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; MUI end ------

; Languages
!include "gcs_lang.nsh"

${LANG_LOAD} "Bulgarian"
${LANG_LOAD} "Czech"
${LANG_LOAD} "German"
${LANG_LOAD} "English"
${LANG_LOAD} "Spanish"
${LANG_LOAD} "French"
${LANG_LOAD} "Italian"
${LANG_LOAD} "Polish"
${LANG_LOAD} "Romanian"
${LANG_LOAD} "Russian"
${LANG_LOAD} "SerbianLatin"
${LANG_LOAD} "Turkish"

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "${PRODUCT_NAME}_${PRODUCT_VERSION}_Setup.exe"
InstallDir "$PROGRAMFILES\GCstar"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails hide
ShowUnInstDetails hide

InstType "$(INSTALL_APP_DEP)"
InstType "$(INSTALL_APP_ONLY)"
InstType "$(INSTALL_FULL)"

Function .onInit
  SetShellVarContext all
  !define MUI_LANGDLL_ALWAYSSHOW
  !insertmacro MUI_LANGDLL_DISPLAY

  ;Prevent Multiple Instances:
  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "GCstarSetup") i .r1 ?e'
  Pop $R0
  StrCmp $R0 0 +3
  MessageBox MB_OK|MB_ICONEXCLAMATION "$(PRE_MULTIPLE)"
  Abort

  ReadRegStr $R0 HKLM \
   "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" \
   "UninstallString"
  StrCmp $R0 "" NoRemove
    Return
  NoRemove:
    SectionSetText 0 ""    ; and make invisible so user doesn't see it
    Return
FunctionEnd

Function LaunchGCstar
  SetOutPath "$INSTDIR\bin"
  Exec "$\"$INSTDIR\bin\gcstar.bat$\""
FunctionEnd

Section "$(SEC_UN)" SEC01
  SetShellVarContext all
  SectionIn 3
  ReadRegStr $R0 HKLM \
  "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" \
  "UninstallString"
  StrCmp $R0 "" NoRemove  
  call RemovePrevious
 NoRemove:
SectionEnd

Section "!GCstar" SEC02
  SetShellVarContext all
  SectionIn 1 2 3 RO
  SetOutPath "$INSTDIR"
  SetOverwrite try
  File /r "lib"
  File /r "share"
  File /r "usr"
  
  SetOutPath "$INSTDIR\bin"
  File "bin\gcstar.exe"
  File "bin\gcstar.bat"
  File "bin\update.bat"

  FileOpen $1 "$INSTDIR\bin\gcstar.bat" a
  FileSeek $1 0 END
  FileWrite $1 "set LANG=$(LANG_CODE)$\r$\n"
  FileWrite $1 "start gcstar.exe %1$\r$\n"
  FileClose $1

  Call SetFileAssociation

; Shortcuts
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  CreateDirectory "$SMPROGRAMS\$ICONS_GROUP"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\$(LINK_APPLICATION).lnk" '"$INSTDIR\bin\gcstar.bat"' "" $INSTDIR\share\gcstar\icons\GCstar.ico "" SW_SHOWMINIMIZED "" "$(LINK_APPLICATION_DESCRIPTION)"
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

SectionGroup "$(SEC_ICONS)" GroupSec02

Section "$(SEC_DSK)" SEC05
  SetShellVarContext all
  SectionIn 1 3
  SetOutPath "$INSTDIR\bin"
  CreateShortCut "$DESKTOP\$(LINK_APPLICATION).lnk" '"$INSTDIR\bin\gcstar.bat"' "" $INSTDIR\share\gcstar\icons\GCstar.ico "" SW_SHOWMINIMIZED "" "$(LINK_APPLICATION_DESCRIPTION)"
SectionEnd

Section "$(SEC_QUICK)" SEC06
  SetShellVarContext all
  SectionIn 1 3
  StrCmp $QUICKLAUNCH $TEMP +3
  SetOutPath "$INSTDIR\bin"
  CreateShortCut "$QUICKLAUNCH\$(LINK_APPLICATION).lnk" '"$INSTDIR\bin\gcstar.bat"' "" $INSTDIR\share\gcstar\icons\GCstar.ico "" SW_SHOWMINIMIZED "" "$(LINK_APPLICATION_DESCRIPTION)"
SectionEnd

SectionGroupEnd

Section -AdditionalIcons
  SetShellVarContext all
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\$(LINK_UPDATE).lnk" '"$INSTDIR\bin\update.bat"' "" $INSTDIR\share\gcstar\icons\icon_install.ico "" "" "" "$(LINK_UPDATE_DESCRIPTION)"
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\$(LINK_SITE).lnk" "$INSTDIR\${PRODUCT_NAME}.url" "" $INSTDIR\share\gcstar\icons\web.ico "" "" "" "$(LINK_SITE_DESCRIPTION)"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\$(LINK_REMOVE).lnk" "$INSTDIR\uninst.exe" "" "" "" "" "" "$(LINK_REMOVE_DESCRIPTION)"
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section -Post
  SetShellVarContext all
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\gcstar"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

; Section descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
;  !insertmacro MUI_DESCRIPTION_TEXT ${GroupSec00} "$(DESC_DEPENDENCIES)"
;  !insertmacro MUI_DESCRIPTION_TEXT ${SEC00} "$(DESC_ACTIVEPERL)"
;  !insertmacro MUI_DESCRIPTION_TEXT ${GroupSec01} "$(DESC_GTKPERL)"
;  !insertmacro MUI_DESCRIPTION_TEXT ${SEC03} "$(DESC_GTK)"
;  !insertmacro MUI_DESCRIPTION_TEXT ${SEC04} "$(DESC_PERL)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC01} "$(DESC_UN)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC02} "$(DESC_APP)"
  !insertmacro MUI_DESCRIPTION_TEXT ${GroupSec02} "$(DESC_ICONS)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC05} "$(DESC_DESKTOP)"
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC06} "$(DESC_QUICK)"
!insertmacro MUI_FUNCTION_DESCRIPTION_END


Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) has been successfullly removed from your computer."
FunctionEnd

Function un.onInit
  !insertmacro MUI_UNGETLANGUAGE
FunctionEnd

Section Uninstall
  SetShellVarContext all
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "$(UN_QUESTION)" IDYES DoUnInstall
  
  Abort "$(UN_ABORTED)"
  Quit
  
  DoUnInstall:
  
  !insertmacro MUI_STARTMENU_GETFOLDER "Application" $ICONS_GROUP

  Delete "$DESKTOP\$(LINK_APPLICATION).lnk"
  Delete "$QUICKLAUNCH\$(LINK_APPLICATION).lnk"
  Delete "$SMPROGRAMS\$ICONS_GROUP\$(LINK_APPLICATION).lnk"
  Delete "$SMPROGRAMS\$ICONS_GROUP\$(LINK_UPDATE).lnk"
  Delete "$SMPROGRAMS\$ICONS_GROUP\$(LINK_SITE).lnk"
  Delete "$SMPROGRAMS\$ICONS_GROUP\$(LINK_REMOVE).lnk"
  RMDir "$SMPROGRAMS\$ICONS_GROUP"

  RMDir /r "$INSTDIR\bin"
  RMDir /r "$INSTDIR\lib"
  RMDir /r "$INSTDIR\share"
  RMDir /r "$INSTDIR\usr"
  
  Delete "$INSTDIR\*"

  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "$(UN_PERSO)" IDNO ContinueUnInstall
  
  RMDir /r "$INSTDIR\data"
  RMDir /r "$INSTDIR\config"
  
  ContinueUninstall:

  Call un.RemoveFileAssociation

  StrCpy $5 "all"
  Push "$INSTDIR\bin"
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  
  RMDir "$INSTDIR"
  
  SetAutoClose true
SectionEnd

;----------------------------------------
; based upon a script of "Written by KiCHiK 2003-01-18 05:57:02"
;----------------------------------------
!verbose 3
!include "WinMessages.nsh"
!verbose 4
;====================================================
; Usefull for file association
;====================================================
Function SetFileAssociation
    !define Index "Line${__LINE__}"
      ReadRegStr $1 HKCR ".gcs" ""
      StrCmp $1 "" "${Index}-NoBackup"
        StrCmp $1 "GCstarFile" "${Index}-NoBackup"
        WriteRegStr HKCR ".gcs" "backup_val" $1
    "${Index}-NoBackup:"
      WriteRegStr HKCR ".gcs" "" "GCstarFile"
      ReadRegStr $0 HKCR "GCstarFile" ""
      StrCmp $0 "" 0 "${Index}-Skip"
        WriteRegStr HKCR "GCstarFile" "" "$(FILE_DESC)"
        WriteRegStr HKCR "GCstarFile\shell" "" "open"
        WriteRegStr HKCR "GCstarFile\DefaultIcon" "" "$INSTDIR\share\gcstar\icons\GCstar.ico"
    "${Index}-Skip:"
      WriteRegStr HKCR "GCstarFile\shell\open\command" "" \
        '"$INSTDIR\bin\gcstar.bat" "%1"'
    !undef Index
    Call RefreshShellIcons
FunctionEnd

Function un.RemoveFileAssociation
    !define Index "Line${__LINE__}"
      ReadRegStr $1 HKCR ".gcs" ""
      StrCmp $1 "GCstarFile" 0 "${Index}-NoOwn" ; only do this if we own it
        ReadRegStr $1 HKCR ".gcs" "backup_val"
        StrCmp $1 "" 0 "${Index}-Restore" ; if backup="" then delete the whole key
          DeleteRegKey HKCR ".gcs"
        Goto "${Index}-NoOwn"
    "${Index}-Restore:"
          WriteRegStr HKCR ".gcs" "" $1
          DeleteRegValue HKCR ".gcs" "backup_val"
    
    "${Index}-NoOwn:"
    DeleteRegKey HKCR "GCstarFile" ;Delete key with association settings
    !undef Index
    Call un.RefreshShellIcons
FunctionEnd

!define SHCNE_ASSOCCHANGED 0x08000000
!define SHCNF_IDLIST 0

Function RefreshShellIcons
  ; By jerome tremblay - april 2003
  System::Call 'shell32.dll::SHChangeNotify(i, i, i, i) v \
  (${SHCNE_ASSOCCHANGED}, ${SHCNF_IDLIST}, 0, 0)'
FunctionEnd

Function un.RefreshShellIcons
  ; By jerome tremblay - april 2003
  System::Call 'shell32.dll::SHChangeNotify(i, i, i, i) v \
  (${SHCNE_ASSOCCHANGED}, ${SHCNF_IDLIST}, 0, 0)'
FunctionEnd

Function RemovePrevious
  ReadRegStr $R0 HKLM \
  "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" \
  "DisplayVersion"

  ReadRegStr $R0 HKLM \
  "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" \
  "UninstallString"

  ;Run the uninstaller
  ClearErrors
  ExecWait '$R0 _?=$INSTDIR' ;Do not copy the uninstaller to a temp file
   
  IfErrors no_remove_uninstaller
    ;You can either use Delete /REBOOTOK in the uninstaller or add some code
    ;here to remove to remove the uninstaller. Use a registry key to check
    ;whether the user has chosen to uninstall. If you are using an uninstaller
    ;components page, make sure all sections are uninstalled.
  no_remove_uninstaller:

FunctionEnd

