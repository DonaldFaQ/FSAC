@echo off & setlocal
mode con cols=200lines=65
set VERSION=0.71 (Fix#4) beta
set HEADER1=powered by Avisynth / FFMPEG                                                               GNU License (GPL) 2021-2025
set HEADER2=powered by Avisynth / FFMPEG                                                                                                                                                GNU License (GPL) 2021-2025
TITLE FS Audio Converter OPTIONS [Team QfG] v%VERSION%
set DESIGN=STANDARD

setlocal EnableDelayedExpansion

rem --- Hardcoded settings. Can be changed manually ---
set "Cecho="%~dp0tools\cecho_x64.exe"" rem Path to cecho_x64.exe
set "sfkpath=%~dp0tools\sfk.exe" rem Path to sfk.exe

:PREFETCH
rem --- Hardcoded settings. Cannot be changed ---
set "TARGET_FOLDER=SAME AS SOURCE"
set "TEMP_FOLDER=%~dp0temp"
set "DRP_FOLDER=!ProgramFiles!\Dolby\Dolby Reference Player"
SET "MONOWAVSLAYOUT=Standard"
set "FLACBR=24"
set "WAVBR=16"
set "THDBR=24"
set "AMPLIFY=0"
set "AC3BR=640"
set "eAC3BR=640"
set "AACBR=5"
set "DAD=TRUE"
set "DAP=FALSE"
set "SHORTFILENAMES=FALSE"
set "LPCMCont=WAV"
set "LOGFILE=TRUE"
set "CACHEFILE=TRUE"
set "PITCHCOR=TRUE"
set "USR_SE_SWITCHES=NONE"
set "USR_SE_NAME=NONE"
set "USR_SE_ORDER=NONE"
set "SHORTFILENAMES_ORIG=%SHORTFILENAMES%"
set "ALAYOUT=[FL][FR][FC][LFE][SL][SR][BL][BR][WL][WR][TFL][TFR][TSL][TSR][TBL][TBR]"
set "ALAYOUT_NAMES=FL,FR,FC,LFE,SL,SR,BL,BR,WL,WR,TFL,TFR,TSL,TSR,TBL,TBR"

::Check for INI and Load Settings
IF EXIST "%~dp0FSAC_Options.ini" (
	FOR /F "delims=" %%A IN ('findstr /C:"TARGET Folder=" "%~dp0FSAC_Options.ini"') DO (
		set "TARGET_FOLDER=%%A"
		set "TARGET_FOLDER=!TARGET_FOLDER:~14!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"TEMP Folder=" "%~dp0FSAC_Options.ini"') DO (
		set "TEMP_FOLDER=%%A"
		set "TEMP_FOLDER=!TEMP_FOLDER:~12!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"DRP Folder=" "%~dp0FSAC_Options.ini"') DO (
		set "DRP_FOLDER=%%A"
		set "DRP_FOLDER=!DRP_FOLDER:~11!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"LPCM Container=" "%~dp0FSAC_Options.ini"') DO (
		set "LPCMCont=%%A"
		set "LPCMCont=!LPCMCont:~15!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"DAD=" "%~dp0FSAC_Options.ini"') DO (
		set "DAD=%%A"
		set "DAD=!DAD:~4!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"DAP=" "%~dp0FSAC_Options.ini"') DO (
		set "DAP=%%A"
		set "DAP=!DAP:~4!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"ATMOSNAMESET=" "%~dp0FSAC_Options.ini"') DO (
		set "ALAYOUT_NAMES=%%A"
		set "ALAYOUT_NAMES=!ALAYOUT_NAMES:~13!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"LOUDNESS=" "%~dp0FSAC_Options.ini"') DO (
		set "Amplify=%%A"
		set "Amplify=!Amplify:~9!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"SHORTFILENAMES=" "%~dp0FSAC_Options.ini"') DO (
		set "SHORTFILENAMES=%%A"
		set "SHORTFILENAMES=!SHORTFILENAMES:~15!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"PITCHCOR=" "%~dp0FSAC_Options.ini"') DO (
		set "PITCHCOR=%%A"
		set "PITCHCOR=!PITCHCOR:~9!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"LOGFILE=" "%~dp0FSAC_Options.ini"') DO (
		set "LOGFILE=%%A"
		set "LOGFILE=!LOGFILE:~8!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"CACHEFILE=" "%~dp0FSAC_Options.ini"') DO (
		set "CACHEFILE=%%A"
		set "CACHEFILE=!CACHEFILE:~10!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"WAVs_LAYOUT=" "%~dp0FSAC_Options.ini"') DO (
		set "MONOWAVSLAYOUT=%%A"
		set "MONOWAVSLAYOUT=!MONOWAVSLAYOUT:~12!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"FLAC=" "%~dp0FSAC_Options.ini"') DO (
		set "FLACBR=%%A"
		set "FLACBR=!FLACBR:~5!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"WAV=" "%~dp0FSAC_Options.ini"') DO (
		set "WAVBR=%%A"
		set "WAVBR=!WAVBR:~4!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"THD=" "%~dp0FSAC_Options.ini"') DO (
		set "THDBR=%%A"
		set "THDBR=!THDBR:~4!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"eAC3=" "%~dp0FSAC_Options.ini"') DO (
		set "eAC3BR=%%A"
		set "eAC3BR=!eAC3BR:~5!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"AC3=" "%~dp0FSAC_Options.ini"') DO (
		set "AC3BR=%%A"
		set "AC3BR=!AC3BR:~4!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"AAC=" "%~dp0FSAC_Options.ini"') DO (
		set "AACBR=%%A"
		set "AACBR=!AACBR:~4!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"DESIGN=" "%~dp0FSAC_Options.ini"') DO (
		set "DESIGN=%%A"
		set "DESIGN=!DESIGN:~7!"
	)
)

if not exist "%~dp0FSAC_Atmos_Muxer.cmd" reg delete "HKLM\Software\Classes\Directory\shell\MenuFSAUDIOCONVERTER" /f>nul 2>&1

:MAINMENU
set "HCWHITE="!sfkpath!" color white"
set "HCRED="!sfkpath!" color red"
set "HCGREEN="!sfkpath!" color green"
set "HCYELLOW="!sfkpath!" color yellow"
set "HC_WHITE=0F"
set "HC_RED=0C"
set "HC_GREEN=0A"
set "HC_YELLOW=0E"
set "GREY="!sfkpath!" color grey"
set "RED="!sfkpath!" color red"
set "GREEN="!sfkpath!" color green"
set "YELLOW="!sfkpath!" color yellow"
set "BLUE="!sfkpath!" color blue"
set "MAGENTA="!sfkpath!" color magenta"
set "CYAN="!sfkpath!" color cyan"
set "WHITE="!sfkpath!" color white"
set "_GREY=08"
set "_RED=0C"
set "_GREEN=0A"
set "_YELLOW=0E"
set "_BLUE=09"
set "_MAGENTA=0D"
set "_CYAN=0B"
set "_WHITE=0F"

if "!DESIGN!" NEQ "STANDARD" (
	call "!DESIGN!"
	for %%f in (!DESIGN!) do set "DESIGN_STRING=%%~nf">nul 2>&1
) else (
	set "DESIGN_STRING=STANDARD"
)
set "SHOWAMP=%AMPLIFY% dB"
if /i "%AMPLIFY%"=="NORMALIZE" set "SHOWAMP=NORMALIZED"
if /i "%AMPLIFY%"=="DIALNORM" set "SHOWAMP=DIALNORM -31 dB"
if "%AMPLIFY%"=="0" set "SHOWAMP=ORIGINAL"
set "WAVBRAUTO=FALSE"
echo !WAVBR! |findstr /I "AUTO" && set "WAVBRAUTO=TRUE"
set "WAVBR_TEXT=!WAVBR:~,2!"
if "!WAVBRAUTO!"=="TRUE" (set "WAVBRAUTO_TEXT={0A}ENABLED") else (set "WAVBRAUTO_TEXT={08}DISABLED")
set "FLACBRAUTO=FALSE"
echo !FLACBR! |findstr /I "AUTO" && set "FLACBRAUTO=TRUE"
set "FLACBR_TEXT=!FLACBR:~,2!"
if "!FLACBRAUTO!"=="TRUE" (set "FLACBRAUTO_TEXT={0A}ENABLED") else (set "FLACBRAUTO_TEXT={08}DISABLED")
if "!TARGET_FOLDER!"=="" set "TARGET_FOLDER=SAME AS SOURCE"
set "TARGET_FOLDER_STRING=!TARGET_FOLDER!\^<FILENAME^>"
if "!TARGET_FOLDER!"=="SAME AS SOURCE" set "TARGET_FOLDER_STRING=<SOURCEDIR>\<FILENAME>"
if exist "!DRP_FOLDER!\drp.exe" (
	set "DRP_CTEXT={0A}FOUND"
) else (
	set "DRP_CTEXT={0C}NOT FOUND"
	set "DAD=FALSE"
	set "DAP=FALSE"
)
if "%DAD%"=="TRUE" (set "DAD_TEXT={0A}ENABLED") else (set "DAD_TEXT={08}DISABLED")
if "%DAP%"=="TRUE" (set "DAP_TEXT={0A}ENABLED") else (set "DAP_TEXT={08}DISABLED")
for /f "tokens=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16 delims=," %%A in ("!ALAYOUT_NAMES!") do set "FL_NAME=%%A" & set "FR_NAME=%%B" & set "FC_NAME=%%C" & set "LFE_NAME=%%D" & set "SL_NAME=%%E" & set "SR_NAME=%%F" & set "BL_NAME=%%G" & set "BR_NAME=%%H" & set "WL_NAME=%%I" & set "WR_NAME=%%J" & set "TFL_NAME=%%K" & set "TFR_NAME=%%L" & set "TSL_NAME=%%M" & set "TSR_NAME=%%N" & set "TBL_NAME=%%O" & set "TBR_NAME=%%P"
set A_NAMESET=^[!FL_NAME!^]^[!FR_NAME!^]^[!FC_NAME!^]^[!LFE_NAME!^]^[!SL_NAME!^]^[!SR_NAME!^]^[!BL_NAME!^]^[!BR_NAME!^]^[!WL_NAME!^]^[!WR_NAME!^]^[!TFL_NAME!^]^[!TFR_NAME!^]^[!TSL_NAME!^]^[!TSR_NAME!^]^[!TBL_NAME!^]^[!TBR_NAME!^]
if "%SHORTFILENAMES%"=="TRUE" (set "SHORTFILENAMES_TEXT={0A}ENABLED") else (set "SHORTFILENAMES_TEXT={08}DISABLED")
if "%PITCHCOR%"=="TRUE" (set "PITCHCOR_TEXT={0A}ENABLED") else (set "PITCHCOR_TEXT={08}DISABLED")
if "%LOGFILE%"=="TRUE" (set "LOGFILE_TEXT={0A}ENABLED") else (set "LOGFILE_TEXT={08}DISABLED")
if "%CACHEFILE%"=="TRUE" (set "CACHEFILE_TEXT={0A}ENABLED") else (set "CACHEFILE_TEXT={08}DISABLED")
cls
%GREEN%
echo !HEADER2!
echo.
%WHITE%
echo                                                                                   ====================================
%GREEN%
echo                                                                                        FS AUDIO CONVERTER OPTIONS
%WHITE%
echo                                                                                   ====================================
%WHITE%
echo.
echo.
echo == FOLDERS ============================================================================================================================================================================================
echo.
%CYAN%
echo OUTPUT FOLDER          = !TARGET_FOLDER_STRING!
echo TEMP FOLDER            = !TEMP_FOLDER!\^<CODE^>
!Cecho! {%_CYAN%}DOLBY REFERENCE PLAYER = !DRP_FOLDER! {%_CYAN%}[!DRP_CTEXT!{%_CYAN%}]{#}{\n}
%WHITE%
echo.
echo == SETTINGS ===========================================================================================================================================================================================
echo.
%CYAN%
echo Mono WAVs Layout       = !MONOWAVSLAYOUT!
%WHITE%
echo.
echo == BITRATES ===========================================================================================================================================================================================
echo.
%YELLOW%
!Cecho! {%_YELLOW%}WAV                    = !WAVBR_TEXT!-Bit / Auto Bitdepth [!WAVBRAUTO_TEXT!{%_YELLOW%}]{#}{\n}
!Cecho! {%_YELLOW%}FLAC                   = !FLACBR_TEXT!-Bit / Auto Bitdepth [!FLACBRAUTO_TEXT!{%_YELLOW%}]{#}{\n}
echo THD Atmos              = !THDBR!-Bit
echo AC-3                   = !AC3BR! k^/bs
echo eAC-3                  = !eAC3BR! k^/bs
echo AAC                    = VBR QL !AACBR!
%WHITE%
echo.
echo == MISC ===============================================================================================================================================================================================
echo.
%YELLOW%
!Cecho! {%_YELLOW%}Dolby Atmos Demuxing   = [!DAD_TEXT!{%_YELLOW%}]{#}{\n}
!Cecho! {%_YELLOW%}Dolby Atmos Priority   = [!DAP_TEXT!{%_YELLOW%}]{#}{\n}
echo Dolby Atmos Nameset    = !A_NAMESET!
!Cecho! {%_YELLOW%}LPCM Container         = [{0A}!LPCMCont!{%_YELLOW%}]{#}{\n}
!Cecho! {%_YELLOW%}Standard Loudness      = [{0A}!SHOWAMP!{%_YELLOW%}]{#}{\n}
!Cecho! {%_YELLOW%}Short Filenames        = [!SHORTFILENAMES_TEXT!{%_YELLOW%}]{#}{\n}
!Cecho! {%_YELLOW%}Std. Pitch Correction  = [!PITCHCOR_TEXT!{%_YELLOW%}]{#}{\n}
!Cecho! {%_YELLOW%}Cachefile              = [!CACHEFILE_TEXT!{%_YELLOW%}]{#}{\n}
!Cecho! {%_YELLOW%}Logfile                = [!LOGFILE_TEXT!{%_YELLOW%}]{#}{\n}
%WHITE%
echo.
echo == OPTIONS MENU =======================================================================================================================================================================================
echo.
%CYAN%
echo O. Set OUTPUT Directory
echo T. Set TEMP Directory
echo R. Set DOLBY REFERENCE PLAYER Directory
echo.
%CYAN%
echo L. Change Mono WAVs Layout
echo.
%YELLOW%
echo 1. BITRATES MENU
echo 2. MISC MENU
%HCWHITE%
echo.
echo 3. Create Shell Extensions
echo 4. Delete Shell Extensions
echo 5. Custom Shell Extensions
echo.
!Cecho! {%HC_WHITE%}6. DESIGN [{%HC_YELLOW%}!DESIGN_STRING!{%HC_WHITE%}]{#}{\n}
echo.
%HCGREEN%
echo D. SET DEFAULT SETTINGS
echo S. SAVE SETTINGS
echo E. EXIT
echo.
%HCWHITE%
!Cecho! {%HC_WHITE%}Change Settings and Press [{%HC_GREEN%}S{%HC_WHITE%}]AVE, [{%HC_GREEN%}D{%HC_WHITE%}]EFAULT or [{%HC_GREEN%}E{%HC_WHITE%}]XIT.{#}{\n}
CHOICE /C OTRL123456DSE /N /M "Select a Letter O,T,R,L,1,2,3,4,5,6,[D]EFAULT,[S]AVE,[E]XIT"
if errorlevel 13 goto :EXIT
if errorlevel 12 (
	(
	echo          FS AUDIO CONVERTER OPTIONS CONFIG File.
	echo ----------------------------------------------------------
	echo TARGET Folder=!TARGET_FOLDER!
	echo TEMP Folder=!TEMP_FOLDER!
	echo DRP Folder=!DRP_FOLDER!
	echo DAD=!DAD!
	echo DAP=!DAP!
	echo ATMOSNAMESET=!ALAYOUT_NAMES!
	echo LPCM Container=!LPCMCont!
	echo LOUDNESS=!Amplify!
	echo SHORTFILENAMES=!SHORTFILENAMES!
	echo PITCHCOR=!PITCHCOR!
	echo CACHEFILE=!CACHEFILE!
	echo LOGFILE=!LOGFILE!
	echo WAVs_LAYOUT=^%MONOWAVSLAYOUT%
	echo FLAC=^%FLACBR%
	echo WAV=^%WAVBR%
	echo THD=^%THDBR%
	echo eAC3=^%eAC3BR%
	echo AC3=^%AC3BR%
	echo AAC=^%AACBR%
	echo DESIGN=!DESIGN!
	echo ----------------------------------------------------------
	)>"%~dp0FSAC_Options.ini"
	%HCGREEN%
	echo.
	echo Settings Saved.
	TIMEOUT 2 >nul
)
if errorlevel 11 (
	cls
	%GREEN%
	echo !HEADER2!
	echo.
	%WHITE%
	echo                                                                                   ====================================
	%GREEN%
	echo                                                                                        FS AUDIO CONVERTER OPTIONS
	%WHITE%
	echo                                                                                   ====================================
	%WHITE%
	echo.
	echo.
	echo == DESIGN =============================================================================================================================================================================================
	echo.
	%HCYELLOW%
	echo Really set all Options to Default?
	echo.
	echo [Y]ES
	echo [N]O
	echo.
	CHOICE /C YN /N /M "Press [Y]ES or [N]O."
	if errorlevel 2 (
		%HCGREEN%
		echo Settings not set to Default.
			)
	if errorlevel 1 (
		if exist "%~dp0FSAC_Options.ini" del "%~dp0FSAC_Options.ini">nul 2>&1
		%HCGREEN%
		echo Settings set to Default.
	)
	TIMEOUT 2 >nul
)
if errorlevel 10 (
	cls
	%GREEN%
	echo !HEADER2!
	echo.
	%WHITE%
	echo                                                                                   ====================================
	%GREEN%
	echo                                                                                        FS AUDIO CONVERTER OPTIONS
	%WHITE%
	echo                                                                                   ====================================
	%WHITE%
	echo.
	echo.
	echo == DESIGN =============================================================================================================================================================================================
	echo.
	%HCYELLOW%
	echo [Info] Set own Design file here. Design sample files in ...\themes folder.
	echo        Leave blank and hit ENTER to use STANDARD Design.
	echo.
	echo        Design file MUST have one of the following extensions^:
	echo        bat^/cmd^ ^^!
	echo.
	%HCWHITE%
	echo.
	!Cecho! {%HC_WHITE%}Drag 'n' Drop {%_GREEN%}DESIGN File {%HC_WHITE%}here and press ENTER:{#}{\n}
	%GREEN%
	set /p "DESIGNINPUT=" || set "DESIGN=STANDARD"
	if "!DESIGNINPUT!" NEQ "STANDARD" for %%f in (!DESIGNINPUT!) do set "DESIGN=%%~dpnxf">nul 2>&1
)
if errorlevel 9 (
	call :CUSTOM_SHELL_EXTENSION_MENU
)
if errorlevel 8 (
	reg delete "HKCR\*\Shell\MenuFSAUDIOCONVERTER" /f>nul 2>&1
	reg delete "HKLM\Software\Classes\Directory\shell\MenuFSAUDIOCONVERTER" /f>nul 2>&1
	echo.
	reg query "HKCR\*\Shell\MenuFSAUDIOCONVERTER" /v "Icon" >nul 2>&1
	if "!ERRORLEVEL!"=="1" (
		%HCGREEN%
		echo Registry strings deleted.
	) else (
		%HCRED%
		echo Registry strings not deleted. Permissions needed^^!
		set "NewLine=[System.Environment]::NewLine"
		set "Line1=REGISTRY STRINGS NOT DELETED^!"
		set "Line2=Start the script with ADMINISTRATOR permissions to activate/deactivate the Windows SHELL EXTENSIONS. Without ADMINISTRATOR permissions you have insufficent rights changing Windows registry^!"
		START /MIN PowerShell -WindowStyle Hidden -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('!Line1!' + !NewLine! + !NewLine! + '!Line2!', 'DDVT OPTIONS [QfG] %VERSION%', 'Ok','Error')"	
	)
	TIMEOUT 1 >nul
)
if errorlevel 7 (
	reg delete "HKCR\*\Shell\MenuFSAUDIOCONVERTER" /f>nul 2>&1
	reg delete "HKLM\Software\Classes\Directory\shell\MenuFSAUDIOCONVERTER" /f>nul 2>&1
	reg add "HKCR\*\Shell\MenuFSAUDIOCONVERTER" /ve /d "FS Audio Converter" /f>nul 2>&1
	reg add "HKCR\*\Shell\MenuFSAUDIOCONVERTER" /v "Icon" /t REG_SZ /d "\"%~dp0tools\FSAC.ico\",0" /f>nul 2>&1
	reg add "HKCR\*\Shell\MenuFSAUDIOCONVERTER" /v "ExtendedSubCommandsKey" /t REG_SZ /d "\"%~dp0tools\FSAC.ico\",0" /f>nul 2>&1
	reg add "HKCR\*\Shell\MenuFSAUDIOCONVERTER" /v "ExtendedSubCommandsKey" /t REG_SZ /d "*\Shell\MenuFSAUDIOCONVERTER\ContextMenu" /f>nul 2>&1
	reg add "HKCR\*\Shell\MenuFSAUDIOCONVERTER" /v "Position" /t REG_SZ /d "Top" /f>nul 2>&1
	reg add "HKCR\*\Shell\MenuFSAUDIOCONVERTER\ContextMenu\shell\01TOOL" /ve /d "Open File..." /f>nul 2>&1
	reg add "HKCR\*\Shell\MenuFSAUDIOCONVERTER\ContextMenu\shell\01TOOL" /v "Icon" /t REG_SZ /d "\"%~dp0tools\FSAC.ico\",0" /f>nul 2>&1
	reg add "HKCR\*\Shell\MenuFSAUDIOCONVERTER\ContextMenu\shell\01TOOL\command" /ve /d "\"%~dp0FSAC.cmd\" ""%%1""" /f>nul 2>&1
	reg add "HKCR\*\Shell\MenuFSAUDIOCONVERTER\ContextMenu\shell\02OPTIONS" /ve /d "Options" /f>nul 2>&1
	reg add "HKCR\*\Shell\MenuFSAUDIOCONVERTER\ContextMenu\shell\02OPTIONS" /v "Icon" /t REG_SZ /d "\"%~dp0tools\FSAC.ico\",0" /f>nul 2>&1
	reg add "HKCR\*\Shell\MenuFSAUDIOCONVERTER\ContextMenu\shell\02OPTIONS\command" /ve /d "%~dp0FSAC_Options.cmd" /f>nul 2>&1
	if exist "%~dp0FSAC_Atmos_Muxer.cmd" reg add "HKLM\Software\Classes\Directory\shell\MenuFSAUDIOCONVERTER" /ve /d "Mux included WAVs to Atmos file..." /f>nul 2>&1
	if exist "%~dp0FSAC_Atmos_Muxer.cmd" reg add "HKLM\Software\Classes\Directory\shell\MenuFSAUDIOCONVERTER" /v "Icon" /t REG_SZ /d "\"%~dp0tools\FSAC.ico\",0" /f>nul 2>&1
	if exist "%~dp0FSAC_Atmos_Muxer.cmd" reg add "HKLM\Software\Classes\Directory\shell\MenuFSAUDIOCONVERTER" /v "Position" /t REG_SZ /d "Top" /f>nul 2>&1
	if exist "%~dp0FSAC_Atmos_Muxer.cmd" reg add "HKLM\Software\Classes\Directory\shell\MenuFSAUDIOCONVERTER\command" /ve /d "\"%~dp0FSAC_Atmos_Muxer.cmd\" ""%%1""" /f>nul 2>&1
	echo.
	reg query "HKCR\*\Shell\MenuFSAUDIOCONVERTER" /v "Icon" >nul 2>&1
	if "!ERRORLEVEL!"=="0" (
		%HCGREEN%
		echo Registry strings set.
	) else (
		%HCRED%
		echo Registry strings not set. Permissions needed^^!
		set "NewLine=[System.Environment]::NewLine"
		set "Line1=REGISTRY STRINGS NOT SET^!"
		set "Line2=Start the script with ADMINISTRATOR permissions to activate/deactivate the Windows SHELL EXTENSIONS. Without ADMINISTRATOR permissions you have insufficent rights changing Windows registry^!"
		START /MIN PowerShell -WindowStyle Hidden -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('!Line1!' + !NewLine! + !NewLine! + '!Line2!', 'DDVT OPTIONS [QfG] %VERSION%', 'Ok','Error')"	
	)
	TIMEOUT 1 >nul
)
if errorlevel 6 goto :MISC_MENU
if errorlevel 5 goto :BITRATES_MENU
if errorlevel 4 (
	if "%MONOWAVSLAYOUT%"=="DTS-HD Master Audio Suite" set "MONOWAVSLAYOUT=Standard"
	if "%MONOWAVSLAYOUT%"=="Standard" set "MONOWAVSLAYOUT=DTS-HD Master Audio Suite"
)
if errorlevel 3 (
	%HCYELLOW%
	echo.
	echo Set the DRP Folder. Do not use the last ^"^\^" symbol^!
	echo If you will use the STANDARD DRP folder leave blank and press [ENTER]^!
	echo Don't forget to [S]AVE your settings after editing^^!
	%HCWHITE%
	echo.
	set /p "DRP_FOLDER=Type in your DOLBY REFERENCE PLAYER Folder and press [ENTER]:" || SET "DRP_FOLDER=!ProgramFiles!\Dolby\Dolby Reference Player"
)
if errorlevel 2 (
	%HCYELLOW%
	echo.
	echo Set the temp folder. Do not use the last ^"^\^" symbol^!
	echo If you will use the STANDARD TEMP folder leave blank and press [ENTER]^!
	echo Don't forget to [S]AVE your settings after editing^^!
	%HCWHITE%
	echo.
	set /p "TEMP_FOLDER=Type in your TEMP Folder and press [ENTER]:" || SET "TEMP_FOLDER=%~dp0temp"
)
if errorlevel 1 (
	%HCYELLOW%
	echo.
	echo Set the output folder. Do not use the last ^"^\^" symbol^!
	echo If you will use the STANDARD SOURCE folder leave blank and press [ENTER]^!
	echo Don't forget to [S]AVE your settings after editing^^!
	%HCWHITE%
	echo.
	set /p "TARGET_FOLDER=Type in your OUTPUT Folder and press [ENTER]:" || SET "TARGET_FOLDER=SAME AS SOURCE"
)
goto MAINMENU

:BITRATES_MENU
set "WAVBRAUTO=FALSE"
echo !WAVBR! |findstr /I "AUTO" && set "WAVBRAUTO=TRUE"
set "WAVBR_TEXT=!WAVBR:~,2!"
if "!WAVBRAUTO!"=="TRUE" (set "WAVBRAUTO_TEXT={0A}ENABLED") else (set "WAVBRAUTO_TEXT={08}DISABLED")
set "FLACBRAUTO=FALSE"
echo !FLACBR! |findstr /I "AUTO" && set "FLACBRAUTO=TRUE"
set "FLACBR_TEXT=!FLACBR:~,2!"
if "!FLACBRAUTO!"=="TRUE" (set "FLACBRAUTO_TEXT={0A}ENABLED") else (set "FLACBRAUTO_TEXT={08}DISABLED")
cls
%GREEN%
echo !HEADER2!
echo.
%WHITE%
echo                                                                                   ====================================
%GREEN%
echo                                                                                        FS AUDIO CONVERTER OPTIONS
%WHITE%
echo                                                                                   ====================================
%WHITE%
echo.
echo.
echo == BITRATES ===========================================================================================================================================================================================
echo.
%YELLOW%
!Cecho! {%_YELLOW%}WAV                    = !WAVBR_TEXT!-Bit / Auto Bitdepth [!WAVBRAUTO_TEXT!{%_YELLOW%}]{#}{\n}
!Cecho! {%_YELLOW%}FLAC                   = !FLACBR_TEXT!-Bit / Auto Bitdepth [!FLACBRAUTO_TEXT!{%_YELLOW%}]{#}{\n}
echo THD Atmos              = !THDBR!-Bit
echo AC-3                   = !AC3BR! k^/bs
echo eAC-3                  = !eAC3BR! k^/bs
echo AAC                    = VBR QL !AACBR!
%WHITE%
echo.
echo == BITRATES MENU ======================================================================================================================================================================================
echo.
%YELLOW%
echo 1. Set WAV Bitdepth ^/ Auto Bitdepth
echo 2. Set FLAC Bitdepth ^/ Auto Bitdepth
echo 3. Set THD Atmos Bitrate
echo 4. Set AC-3 Bitrate
echo 5. Set eAC-3 Bitrate
echo 6. Set AAC VBR QL
echo.
%HCGREEN%
echo S. SAVE SETTINGS AND EXIT
echo E. EXIT WITHOUT SAVING
echo.
%HCWHITE%
!Cecho! {%HC_WHITE%}Change Settings and Press [{%HC_GREEN%}S{%HC_WHITE%}]AVE or [{%HC_GREEN%}E{%HC_WHITE%}]XIT WITHOUT SAVE.{#}{\n}
CHOICE /C 123456SE /N /M "Select a Letter 1,2,3,4,5,6,[S]AVE,[E]XIT"

if errorlevel 8 (
	echo.
	%HCRED%
	echo Exit without saving.
	TIMEOUT 2 >nul
	goto PREFETCH
)
if errorlevel 7 (
	(
	echo          FS AUDIO CONVERTER OPTIONS CONFIG File.
	echo ----------------------------------------------------------
	echo TARGET Folder=!TARGET_FOLDER!
	echo TEMP Folder=!TEMP_FOLDER!
	echo DRP Folder=!DRP_FOLDER!
	echo DAD=!DAD!
	echo DAP=!DAP!
	echo ATMOSNAMESET=!ALAYOUT_NAMES!
	echo LPCM Container=!LPCMCont!
	echo LOUDNESS=!Amplify!
	echo SHORTFILENAMES=!SHORTFILENAMES!
	echo PITCHCOR=!PITCHCOR!
	echo CACHEFILE=!CACHEFILE!
	echo LOGFILE=!LOGFILE!
	echo WAVs_LAYOUT=^%MONOWAVSLAYOUT%
	echo FLAC=^%FLACBR%
	echo WAV=^%WAVBR%
	echo THD=^%THDBR%
	echo eAC3=^%eAC3BR%
	echo AC3=^%AC3BR%
	echo AAC=^%AACBR%
	echo DESIGN=!DESIGN!
	echo ----------------------------------------------------------
	)>"%~dp0FSAC_Options.ini"
	%HCGREEN%
	echo.
	echo Settings Saved.
	TIMEOUT 2 >nul
	goto MAINMENU
)
if errorlevel 6 (
	%HCYELLOW%
	echo.
	echo Set the VBR QL in steps 1 ^(lowest^) till 5 ^(highest^). ^(1,2,3,4,5^).
	echo Don't forget to [S]AVE your settings after editing^^!
	%HCWHITE%
	echo.
	set /p "AACBR=Type in VBR QL and press [ENTER]:" || SET "AACBR=!AACBR!"
)
if errorlevel 5 (
	%HCYELLOW%
	echo.
	echo Set the Bitrate in k^/bit ^(32-6144^).
	echo Don't forget to [S]AVE your settings after editing^^!
	%HCWHITE%
	echo.
	set /p "eAC3BR=Type in Bitrate and press [ENTER]:" || SET "eAC3BR=!eAC3BR!"
)
if errorlevel 4 (
	%HCYELLOW%
	echo.
	echo Set the Bitrate in k^/bit ^(32-640^).
	echo Don't forget to [S]AVE your settings after editing^^!
	%HCWHITE%
	echo.
	set /p "AC3BR=Type in Bitrate and press [ENTER]:" || SET "AC3BR=!AC3BR!"
)
if errorlevel 3 (
	%HCYELLOW%
	echo.
	echo Set the Bitdepth in BIT ^(16,24,32^).
	echo Don't forget to [S]AVE your settings after editing^^!
	%HCWHITE%
	echo.
	set /p "THDBR=Type in Bitdepth and press [ENTER]:" || SET "THDBR=!THDBR!"
)
if errorlevel 2 (
	%HCYELLOW%
	echo.
	echo Set the Bitdepth in BIT ^(16,24,32^).
	echo Also you can set your Bitdepth followed with AUTO. For example: 16 AUTO to enable Auto Detection.
	echo.
	echo Don't forget to [S]AVE your settings after editing^^!
	%HCWHITE%
	echo.
	set /p "FLACBR=Type in Bitdepth (or Bitdepth AUTO) and press [ENTER]:" || SET "FLACBR=!FLACBR!"
)
if errorlevel 1 (
	%HCYELLOW%
	echo.
	echo Set the Bitdepth in BIT ^(16,24,32^).
	echo Also you can set your Bitdepth followed with AUTO. For example: 16 AUTO to enable Auto Detection.
	echo.
	echo Don't forget to [S]AVE your settings after editing^^!
	%HCWHITE%
	echo.
	set /p "WAVBR=Type in Bitdepth (or Bitdepth AUTO) and press [ENTER]:" || SET "WAVBR=!WAVBR!"
)
goto :BITRATES_MENU

:MISC_MENU
::SET AMPLIFY STRINGS
set "SHOWAMP=%AMPLIFY% dB"
if /i "%AMPLIFY%"=="NORMALIZE" set "SHOWAMP=NORMALIZED"
if /i "%AMPLIFY%"=="DIALNORM" set "SHOWAMP=DIALNORM -31 dB"
if "%AMPLIFY%"=="0" set "SHOWAMP=ORIGINAL"
if exist "!DRP_FOLDER!\drp.exe" (
	set "DRP_CTEXT={0A}FOUND"
) else (
	set "DRP_CTEXT={0C}NOT FOUND"
	set "DAD=FALSE"
	set "DAP=FALSE"
)
if "%DAD%"=="TRUE" (set "DAD_TEXT={0A}ENABLED") else (set "DAD_TEXT={08}DISABLED")
if "%DAP%"=="TRUE" (set "DAP_TEXT={0A}ENABLED") else (set "DAP_TEXT={08}DISABLED")
for /f "tokens=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16 delims=," %%A in ("!ALAYOUT_NAMES!") do set "FL_NAME=%%A" & set "FR_NAME=%%B" & set "FC_NAME=%%C" & set "LFE_NAME=%%D" & set "SL_NAME=%%E" & set "SR_NAME=%%F" & set "BL_NAME=%%G" & set "BR_NAME=%%H" & set "WL_NAME=%%I" & set "WR_NAME=%%J" & set "TFL_NAME=%%K" & set "TFR_NAME=%%L" & set "TSL_NAME=%%M" & set "TSR_NAME=%%N" & set "TBL_NAME=%%O" & set "TBR_NAME=%%P"
set A_NAMESET=^[!FL_NAME!^]^[!FR_NAME!^]^[!FC_NAME!^]^[!LFE_NAME!^]^[!SL_NAME!^]^[!SR_NAME!^]^[!BL_NAME!^]^[!BR_NAME!^]^[!WL_NAME!^]^[!WR_NAME!^]^[!TFL_NAME!^]^[!TFR_NAME!^]^[!TSL_NAME!^]^[!TSR_NAME!^]^[!TBL_NAME!^]^[!TBR_NAME!^]
if "%SHORTFILENAMES%"=="TRUE" (set "SHORTFILENAMES_TEXT={0A}ENABLED") else (set "SHORTFILENAMES_TEXT={08}DISABLED")
if "%PITCHCOR%"=="TRUE" (set "PITCHCOR_TEXT={0A}ENABLED") else (set "PITCHCOR_TEXT={08}DISABLED")
if "%CACHEFILE%"=="TRUE" (set "CACHEFILE_TEXT={0A}ENABLED") else (set "CACHEFILE_TEXT={08}DISABLED")
if "%LOGFILE%"=="TRUE" (set "LOGFILE_TEXT={0A}ENABLED") else (set "LOGFILE_TEXT={08}DISABLED")
cls
%GREEN%
echo !HEADER2!
echo.
%WHITE%
echo                                                                                   ====================================
%GREEN%
echo                                                                                        FS AUDIO CONVERTER OPTIONS
%WHITE%
echo                                                                                   ====================================
%WHITE%
echo.
echo.
echo == MISC ===============================================================================================================================================================================================
echo.
%YELLOW%
!Cecho! {%_YELLOW%}Dolby Atmos Demuxing   = [!DAD_TEXT!{%_YELLOW%}]{#}{\n}
!Cecho! {%_YELLOW%}Dolby Atmos Priority   = [!DAP_TEXT!{%_YELLOW%}]{#}{\n}
echo Dolby Atmos Nameset    = !A_NAMESET!
!Cecho! {%_YELLOW%}LPCM Container         = [{0A}!LPCMCont!{%_YELLOW%}]{#}{\n}
!Cecho! {%_YELLOW%}Standard Loudness      = [{0A}!SHOWAMP!{%_YELLOW%}]{#}{\n}
!Cecho! {%_YELLOW%}Short Filenames        = [!SHORTFILENAMES_TEXT!{%_YELLOW%}]{#}{\n}
!Cecho! {%_YELLOW%}Std. Pitch Correction  = [!PITCHCOR_TEXT!{%_YELLOW%}]{#}{\n}
!Cecho! {%_YELLOW%}Cachefile              = [!CACHEFILE_TEXT!{%_YELLOW%}]{#}{\n}
!Cecho! {%_YELLOW%}Logfile                = [!LOGFILE_TEXT!{%_YELLOW%}]{#}{\n}
%WHITE%
echo.
echo == MISC MENU ==========================================================================================================================================================================================
echo.
%YELLOW%
!Cecho! {%_YELLOW%}1. Enable / Disable Dolby Atmos Demuxing [!DAD_TEXT!{%_YELLOW%}]{#}{\n}
!Cecho! {%_YELLOW%}2. Enable / Disable Dolby Atmos Priority [!DAP_TEXT!{%_YELLOW%}]{#}{\n}
echo 3. Set Dolby Atmos Nameset
!Cecho! {%_YELLOW%}4. LPCM Container                        [{0A}!LPCMCont!{%_YELLOW%}]{#}{\n}
!Cecho! {%_YELLOW%}5. Standard Loudness                     [{0A}!SHOWAMP!{%_YELLOW%}]{#}{\n}
!Cecho! {%_YELLOW%}6. Enable / Disable Short Filenames      [!SHORTFILENAMES_TEXT!{%_YELLOW%}]{#}{\n}
!Cecho! {%_YELLOW%}7. Std. Pitch Correction                 [!PITCHCOR_TEXT!{%_YELLOW%}]{#}{\n}
!Cecho! {%_YELLOW%}8. Enable / Disable Cachefile            [!CACHEFILE_TEXT!{%_YELLOW%}]{#}{\n}
!Cecho! {%_YELLOW%}9. Enable / Disable Logfile              [!LOGFILE_TEXT!{%_YELLOW%}]{#}{\n}
echo.
%HCGREEN%
echo S. SAVE SETTINGS AND EXIT
echo E. EXIT WITHOUT SAVING
echo.
%HCWHITE%
!Cecho! {%HC_WHITE%}Change Settings and Press [{%HC_GREEN%}S{%HC_WHITE%}]AVE or [{%HC_GREEN%}E{%HC_WHITE%}]XIT WITHOUT SAVE.{#}{\n}
CHOICE /C 123456789SE /N /M "Select a Letter 1,2,3,4,5,6,7,8,9,[S]AVE,[E]XIT"

if errorlevel 11 (
	echo.
	%HCRED%
	echo Exit without saving.
	TIMEOUT 2 >nul
	goto PREFETCH
)
if errorlevel 10 (
	echo          FS AUDIO CONVERTER OPTIONS CONFIG File.>"%~dp0FSAC_Options.ini"
	echo ---------------------------------------------------------->>"%~dp0FSAC_Options.ini"
	echo TARGET Folder=!TARGET_FOLDER!>>"%~dp0FSAC_Options.ini"
	echo TEMP Folder=!TEMP_FOLDER!>>"%~dp0FSAC_Options.ini"
	echo DRP Folder=!DRP_FOLDER!>>"%~dp0FSAC_Options.ini"
	echo DAD=!DAD!>>"%~dp0FSAC_Options.ini"
	echo DAP=!DAP!>>"%~dp0FSAC_Options.ini"
	echo ATMOSNAMESET=!ALAYOUT_NAMES!>>"%~dp0FSAC_Options.ini"
	echo LPCM Container=!LPCMCont!>>"%~dp0FSAC_Options.ini"
	echo LOUDNESS=!Amplify!>>"%~dp0FSAC_Options.ini"
	echo SHORTFILENAMES=!SHORTFILENAMES!>>"%~dp0FSAC_Options.ini"
	echo PITCHCOR=!PITCHCOR!>>"%~dp0FSAC_Options.ini"
	echo CACHEFILE=!CACHEFILE!>>"%~dp0FSAC_Options.ini"
	echo LOGFILE=!LOGFILE!>>"%~dp0FSAC_Options.ini"
	echo WAVs_LAYOUT=^%MONOWAVSLAYOUT%>>"%~dp0FSAC_Options.ini"
	echo FLAC=^%FLACBR%>>"%~dp0FSAC_Options.ini"
	echo WAV=^%WAVBR%>>"%~dp0FSAC_Options.ini"
	echo THD=^%THDBR%>>"%~dp0FSAC_Options.ini"
	echo eAC3=^%eAC3BR%>>"%~dp0FSAC_Options.ini"
	echo AC3=^%AC3BR%>>"%~dp0FSAC_Options.ini"
	echo AAC=^%AACBR%>>"%~dp0FSAC_Options.ini"
	echo ---------------------------------------------------------->>"%~dp0FSAC_Options.ini"
	%HCGREEN%
	echo.
	echo Settings Saved.
	TIMEOUT 2 >nul
	goto MAINMENU
)
if errorlevel 9 (
	if "%LOGFILE%"=="TRUE" set "LOGFILE=FALSE"
	if "%LOGFILE%"=="FALSE" set "LOGFILE=TRUE"
)
if errorlevel 8 (
	if "%CACHEFILE%"=="TRUE" set "CACHEFILE=FALSE"
	if "%CACHEFILE%"=="FALSE" set "CACHEFILE=TRUE"
)
if errorlevel 7 (
	if "%PITCHCOR%"=="TRUE" set "PITCHCOR=FALSE"
	if "%PITCHCOR%"=="FALSE" set "PITCHCOR=TRUE"
)
if errorlevel 6 (
	if "%SHORTFILENAMES%"=="TRUE" set "SHORTFILENAMES=FALSE"
	if "%SHORTFILENAMES%"=="FALSE" set "SHORTFILENAMES=TRUE"
)
if errorlevel 5 (
	if "%Amplify%"=="NORMALIZE" set "Amplify=DIALNORM"
	if "%Amplify%"=="DIALNORM" set "Amplify=0"
	if "%Amplify%"=="0" set "Amplify=NORMALIZE"
)
if errorlevel 4 (
	if "%LPCMCont%"=="WAV" set "LPCMCont=CAF"
	if "%LPCMCont%"=="CAF" set "LPCMCont=WAV"
)
if errorlevel 3 (
	%HCYELLOW%
	echo.
	echo Set Dolby Atmos Nameset for Dolby Atmos Mono WAV extracting.
	echo Set Name for each of the 16 channels, use "," as delimeter.
	echo.
	echo Channel Order is^:
	echo !ALAYOUT!
	echo.
	echo Example for Standard FFMPEG Nameset:
	echo FL,FR,FC,LFE,SL,SR,BL,BR,WL,WR,TFL,TFR,TSL,TSR,TBL,TBR
	echo.
	echo Don't forget to [S]AVE your settings after editing^^!
	%HCWHITE%
	echo.
	set /p "ALAYOUT_NAMES=Type in Nameset and press [ENTER]:" || SET "ALAYOUT_NAMES=FL,FR,FC,LFE,SL,SR,BL,BR,WL,WR,TFL,TFR,TSL,TSR,TBL,TBR"
)
if errorlevel 2 (
	if "%DAP%"=="TRUE" set "DAP=FALSE"
	if "%DAP%"=="FALSE" (
		set "DAP=TRUE"
		set "DAD=TRUE"
	)
)
if errorlevel 1 (
	if "%DAD%"=="TRUE" (
		set "DAD=FALSE"
		set "DAP=FALSE"
	)
	if "%DAD%"=="FALSE" (
		set "DAD=TRUE"
		set "DAP=TRUE"
	)
)
goto :MISC_MENU

:CUSTOM_SHELL_EXTENSION_MENU
set PasswordChars=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890
set PasswordLength=5
call :CreatePassword Password
cls
if "!USR_SE_ORDER!"=="NONE" (
	set "ORDERSTRING="
	set "ORDERCOLOR=%HC_YELLOW%"
) else (
	set "ORDERSTRING=!USR_SE_ORDER!_"
	set "ORDERCOLOR=%HC_GREEN%"
)
if "!USR_SE_SWITCHES!"=="NONE" (
	set "SWITCHOK=FALSE"
	set "SWITCHCOLOR=%HC_RED%"
) else (
	set "SWITCHOK=TRUE"
	set "SWITCHCOLOR=%HC_GREEN%"
)
if "!USR_SE_NAME!"=="NONE" (
	set "NAMEOK=FALSE"
	set "NAMECOLOR=%HC_RED%"
) else (
	set "NAMEOK=TRUE"
	set "NAMECOLOR=%HC_GREEN%"
)
%GREEN%
echo !HEADER2!
echo.
%WHITE%
echo                                                                                   ====================================
%GREEN%
echo                                                                                        FS AUDIO CONVERTER OPTIONS
%WHITE%
echo                                                                                   ====================================
%WHITE%
echo.
echo.
echo == CUSTOM SHELL EXTENSION =============================================================================================================================================================================
%HCYELLOW%%
echo.
echo Here you can add a predefined Shell Extionsion for FSAC. Simply use Switches and Name and Save the profile.
echo You can use this profile via Right Click on a valid file.
%HCWHITE%%
echo.
!Cecho! {%HC_GREEN%}AVAILABLE SWITCHES:{#}{\n}
echo --INDEX-^<Index Number^>                               Set Index if container is sourcefile.
%HCYELLOW%
echo --DRC-^<ON^|OFF^>                                       Set Dynamic Range Compression On or Off.
%HCWHITE%
echo --TEMPO-^<Adjustments^>                                Slow-down or Speed-up audio. Set one of the following Tempo Adjustments.
echo         ^<25to23976^|25to23976p^>                       Slow-down 25 FPS to 23,976 FPS. "p" means with pitch correctur.
echo         ^<25to24^|25to24p^>                             Slow-down 25 FPS to 24 FPS. "p" means with pitch correctur.
echo         ^<24to23976^|24to23976p^>                       Slow-down 24 FPS to 23,976 FPS. "p" means with pitch correctur.
echo         ^<23976to25^|23976to25p^>                       Speed-up 23,976 FPS to 25 FPS. "p" means with pitch correctur.
echo         ^<24to25^|24to25p^>                             Speed-up 24 FPS to 25 FPS. "p" means with pitch correctur.
echo         ^<23976to24^|23976to24p^>                       Speed-up 23,976 FPS to 24 FPS. "p" means with pitch correctur.
%HCYELLOW%
echo --PITCH-^<Adjustments^>                                Change pitch only. Set one of the following Pitch Adjustments.
echo         ^<25to23976^|25to24^|23976to25^|24to25^>          Do not use --TEMPO and --PITCH together!.
%HCWHITE%
echo --CODEC-^<Audio Codec^>                                Set one of the following Audio Codecs.
echo         ^<LPCM^|MONOWAVs^|FLAC^|AC3^|EAC3^|AAC^>            Available output audio codecs.
echo         ^<ATMOS-LPCM^|ATMOS-MONOWAVs^>                  Dolby Atmos Codecs. Needed installed Dolby Reference Player
%HCYELLOW%
echo --DELAY-^<Delay in ms^>                                Set delay for audio track. for negative delay use -.
%HCWHITE%
echo --AMPLIFY-^<AMPLIFY in dB^>                            Set amplify. for negative amplify use -. Also available switches:
echo           ^<DIALNORM^|NORMALIZE^>                       DIALNORM sets audio amplify to -31dB, NORMALIZE sets highest peak to -0dB
%HCYELLOW%
echo --DIR-^<Path to output directory^>                     Set output directory without "".
echo.
!Cecho! {%HC_YELLOW%}For unused switches the tool uses standard settings.{#}{\n}
%WHITE%
echo.
echo == MENU ===============================================================================================================================================================================================
%YELLOW%
echo.
!Cecho! {%_YELLOW%}1. Set Order [{!ORDERCOLOR!}!USR_SE_ORDER!{%_YELLOW%}]{#}{\n}
!Cecho! {%_YELLOW%}2. Set Switches [{!SWITCHCOLOR!}!USR_SE_SWITCHES!{%_YELLOW%}]{#}{\n}
!Cecho! {%_YELLOW%}3. Set Name [{!NAMECOLOR!}!USR_SE_NAME!{%_YELLOW%}]{#}{\n}
echo.
%HCGREEN%
echo S. Save User Shell Extension
echo D. Delete User Shell Extension
echo.
echo E. Exit Menu
echo.
if "!SWITCHOK!!NAMEOK!" NEQ "TRUETRUE" (
	!Cecho! {%HC_YELLOW%}Fix {!SWITCHCOLOR!}Switches {%HC_YELLOW%}and / or {!NAMECOLOR!}Name {%HC_YELLOW%}entries^^! You cannot save yet.{#}{\n}
	echo.
)
%HCWHITE%
!Cecho! {%HC_WHITE%}Change Settings and Press [{%HC_GREEN%}S{%HC_WHITE%}]AVE, [{%HC_GREEN%}D{%HC_WHITE%}]ELETE or [{%HC_GREEN%}E{%HC_WHITE%}]XIT WITHOUT SAVE.{#}{\n}
CHOICE /C 123SDE /N /M "Select a Letter 1,2,[S]AVE,[D]ELETE,[E]XIT"
if errorlevel 6 goto :MAINMENU
if errorlevel 5 (
	reg delete "HKCR\*\Shell\MenuFSAUDIOCUSTOMCONVERTER" /f>nul 2>&1
	echo.
	reg query "HKCR\*\Shell\MenuFSAUDIOCUSTOMCONVERTER" /v "Icon" >nul 2>&1
	if "!ERRORLEVEL!"=="1" (
		%HCGREEN%
		echo Registry strings deleted.
	) else (
		%HCRED%
		echo Registry strings not deleted. Permissions needed^^!
		set "NewLine=[System.Environment]::NewLine"
		set "Line1=REGISTRY STRINGS NOT DELETED^!"
		set "Line2=Start the script with ADMINISTRATOR permissions to activate/deactivate the Windows SHELL EXTENSIONS. Without ADMINISTRATOR permissions you have insufficent rights changing Windows registry^!"
		START /MIN PowerShell -WindowStyle Hidden -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('!Line1!' + !NewLine! + !NewLine! + '!Line2!', 'DDVT OPTIONS [QfG] %VERSION%', 'Ok','Error')"	
	)
	TIMEOUT 1 >nul
)
if errorlevel 4 (
	if "!SWITCHOK!!NAMEOK!" NEQ "TRUETRUE" (
		echo.
		!Cecho! {%HC_YELLOW%}Fix {!SWITCHCOLOR!}Switches {%HC_YELLOW%}and / or {!NAMECOLOR!}Name {%HC_YELLOW%}entries^^! You cannot save yet.{#}{\n}
	) else (
		reg add "HKCR\*\Shell\MenuFSAUDIOCUSTOMCONVERTER" /ve /d "FS Audio Converter (Profiles)" /f>nul 2>&1
		reg add "HKCR\*\Shell\MenuFSAUDIOCUSTOMCONVERTER" /v "Icon" /t REG_SZ /d "\"%~dp0tools\FSAC.ico\",0" /f>nul 2>&1
		reg add "HKCR\*\Shell\MenuFSAUDIOCUSTOMCONVERTER" /v "ExtendedSubCommandsKey" /t REG_SZ /d "\"%~dp0tools\FSAC.ico\",0" /f>nul 2>&1
		reg add "HKCR\*\Shell\MenuFSAUDIOCUSTOMCONVERTER" /v "ExtendedSubCommandsKey" /t REG_SZ /d "*\Shell\MenuFSAUDIOCUSTOMCONVERTER\ContextMenu" /f>nul 2>&1
		reg add "HKCR\*\Shell\MenuFSAUDIOCUSTOMCONVERTER" /v "Position" /t REG_SZ /d "Top" /f>nul 2>&1
		reg add "HKCR\*\Shell\MenuFSAUDIOCUSTOMCONVERTER\ContextMenu\shell\!ORDERSTRING!%Password%" /ve /d "!USR_SE_NAME!" /f>nul 2>&1
		reg add "HKCR\*\Shell\MenuFSAUDIOCUSTOMCONVERTER\ContextMenu\shell\!ORDERSTRING!%Password%" /v "Icon" /t REG_SZ /d "\"%~dp0tools\FSAC.ico\",0" /f>nul 2>&1
		reg add "HKCR\*\Shell\MenuFSAUDIOCUSTOMCONVERTER\ContextMenu\shell\!ORDERSTRING!%Password%\command" /ve /d "\"%~dp0FSAC.cmd\" ""%%1\"" !USR_SE_SWITCHES!" /f>nul 2>&1
		echo.
		reg query "HKCR\*\Shell\MenuFSAUDIOCUSTOMCONVERTER\ContextMenu\shell\!ORDERSTRING!%Password%" /v "Icon" >nul 2>&1
		if "!ERRORLEVEL!"=="0" (
			%HCGREEN%
			echo Registry strings set.
		) else (
			%HCRED%
			echo Registry strings not set. Permissions needed^^!
			set "NewLine=[System.Environment]::NewLine"
			set "Line1=REGISTRY STRINGS NOT SET^!"
			set "Line2=Start the script with ADMINISTRATOR permissions to activate/deactivate the Windows SHELL EXTENSIONS. Without ADMINISTRATOR permissions you have insufficent rights changing Windows registry^!"
			START /MIN PowerShell -WindowStyle Hidden -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('!Line1!' + !NewLine! + !NewLine! + '!Line2!', 'DDVT OPTIONS [QfG] %VERSION%', 'Ok','Error')"	
		)
	)
	TIMEOUT 1 >nul
)
if errorlevel 3 (
	echo.
	!Cecho! {%HC_WHITE%}Set Name. This is the Name in the FSAC Shell Extension Menu. Hit ENTER without Entry set Name to NONE.{#}{\n}
	!Cecho! {%HC_WHITE%}Example Name: {%HC_YELLOW%}Convert to FLAC [Tempo Change 25 to 24]...{#}{\n}
	echo.
	%HCWHITE%
	set /p "USR_SE_NAME=Type in Name and press [ENTER]:" || SET "USR_SE_NAME=NONE"
)
if errorlevel 2 (
	echo.
	!Cecho! {%HC_WHITE%}Set Switches. Check {%HC_GREEN%}AVAILABLE SWITCHES{%HC_WHITE%}. Hit ENTER without Entry set Switches to NONE.{#}{\n}
	!Cecho! {%HC_WHITE%}Example Line: {%HC_YELLOW%}--tempo-25to24 --codec-flac --dir-C:\Output{#}{\n}
	echo.
	%HCWHITE%
	set /p "USR_SE_SWITCHES=Type in Switches and press [ENTER]:" || SET "USR_SE_SWITCHES=NONE"
)
if errorlevel 1 (
	echo.
	!Cecho! {%HC_WHITE%}Set Order. Entries {%HC_YELLOW%}will not be ordered by Name{%HC_WHITE%}. You must use your own Order system.{#}{\n}
	!Cecho! {%HC_WHITE%}Example Orders: First Script set Order to {%HC_YELLOW%}01{%HC_WHITE%}, second to {%HC_YELLOW%}02{%HC_WHITE%}, third to {%HC_YELLOW%}03{%HC_WHITE%}...{#}{\n}
	echo.
	%HCWHITE%
	set /p "USR_SE_ORDER=Type in Order-Code and press [ENTER]:" || SET "USR_SE_ORDER=NONE"
)
goto :CUSTOM_SHELL_EXTENSION_MENU

:EXIT
%WHITE%
if "%OPTIONS%"=="YES" goto :eof
setlocal DisableDelayedExpansion
ENDLOCAL
echo.
echo  == EXIT ===============================================================================================================================================================================================
echo.
exit

:CreatePassword
set TempVar=%PasswordChars%
set /a PWCharCount=0

:CountLoop
set TempVar=%TempVar:~1%
set /a PWCharCount+=1
if not "%TempVar%"=="" goto CountLoop
set TempVar=
set Length=0

:GenerateLoop
set /a i=%Random% %% PWCharCount
set /a Length+=1
set TempVar=%TempVar%!PasswordChars:~%i%,1!
if not "%Length%"=="%PasswordLength%" goto GenerateLoop
set %1=%TempVar%
goto :eof