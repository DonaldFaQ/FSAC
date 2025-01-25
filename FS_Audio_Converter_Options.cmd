@echo off & setlocal
mode con cols=200 lines=60
TITLE  FS Audio Converter Options [Team QfG] v0.68 beta
setlocal EnableDelayedExpansion

rem --- Hardcoded settings. Can be changed manually ---
set "sfkpath=%~dp0tools\sfk.exe" rem Path to sfk.exe

rem --- Hardcoded settings. Cannot be changed ---

:PREFETCH
set "TARGET_FOLDER=SAME AS SOURCE"
set "TEMP_FOLDER=%~dp0temp"
set "DRP_FOLDER=!ProgramFiles!\Dolby\Dolby Reference Player"
SET "MONOWAVSLAYOUT=Standard"
set "WAVBR=16"
set "THDBR=24"
set "WAVBRAUTO=FALSE"
set "AMPLIFY=NORMALIZE"
set "AC3BR=640"
set "eAC3BR=640"
set "AACBR=5"
set "DAD=TRUE"
set "DAP=FALSE"
set "SHORTFILENAMES=FALSE"
set "LPCMCont=WAV"
set "LOGFILE=TRUE"
set "SHORTFILENAMES_ORIG=%SHORTFILENAMES%"
set "ALAYOUT=[FL][FR][FC][LFE][SL][SR][BL][BR][WL][WR][TFL][TFR][TSL][TSR][TBL][TBR]"
set "ALAYOUT_NAMES=FL,FR,FC,LFE,SL,SR,BL,BR,WL,WR,TFL,TFR,TSL,TSR,TBL,TBR"

set WAIT="!sfkpath!" sleep
set GREEN="!sfkpath!" color green
set RED="!sfkpath!" color red
set YELLOW="!sfkpath!" color yellow
set WHITE="!sfkpath!" color white
set CYAN="!sfkpath!" color cyan
set MAGENTA="!sfkpath!" color magenta
set GREY="!sfkpath!" color grey

::Check for INI and Load Settings
IF EXIST "%~dp0FS_Audio_Converter_Options.ini" (
	FOR /F "delims=" %%A IN ('findstr /C:"TARGET Folder=" "%~dp0FS_Audio_Converter_Options.ini"') DO (
		set "TARGET_FOLDER=%%A"
		set "TARGET_FOLDER=!TARGET_FOLDER:~14!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"TEMP Folder=" "%~dp0FS_Audio_Converter_Options.ini"') DO (
		set "TEMP_FOLDER=%%A"
		set "TEMP_FOLDER=!TEMP_FOLDER:~12!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"DRP Folder=" "%~dp0FS_Audio_Converter_Options.ini"') DO (
		set "DRP_FOLDER=%%A"
		set "DRP_FOLDER=!DRP_FOLDER:~11!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"LPCM Container=" "%~dp0FS_Audio_Converter_Options.ini"') DO (
		set "LPCMCont=%%A"
		set "LPCMCont=!LPCMCont:~15!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"DAD=" "%~dp0FS_Audio_Converter_Options.ini"') DO (
		set "DAD=%%A"
		set "DAD=!DAD:~4!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"DAP=" "%~dp0FS_Audio_Converter_Options.ini"') DO (
		set "DAP=%%A"
		set "DAP=!DAP:~4!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"ATMOSNAMESET=" "%~dp0FS_Audio_Converter_Options.ini"') DO (
		set "ALAYOUT_NAMES=%%A"
		set "ALAYOUT_NAMES=!ALAYOUT_NAMES:~13!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"LOUDNESS=" "%~dp0FS_Audio_Converter_Options.ini"') DO (
		set "Amplify=%%A"
		set "Amplify=!Amplify:~9!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"SHORTFILENAMES=" "%~dp0FS_Audio_Converter_Options.ini"') DO (
		set "SHORTFILENAMES=%%A"
		set "SHORTFILENAMES=!SHORTFILENAMES:~15!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"LOGFILE=" "%~dp0FS_Audio_Converter_Options.ini"') DO (
		set "LOGFILE=%%A"
		set "LOGFILE=!LOGFILE:~8!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"WAVs_LAYOUT=" "%~dp0FS_Audio_Converter_Options.ini"') DO (
		set "MONOWAVSLAYOUT=%%A"
		set "MONOWAVSLAYOUT=!MONOWAVSLAYOUT:~12!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"WAV=" "%~dp0FS_Audio_Converter_Options.ini"') DO (
		set "WAVBR=%%A"
		set "WAVBR=!WAVBR:~4!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"THD=" "%~dp0FS_Audio_Converter_Options.ini"') DO (
		set "THDBR=%%A"
		set "THDBR=!THDBR:~4!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"eAC3=" "%~dp0FS_Audio_Converter_Options.ini"') DO (
		set "eAC3BR=%%A"
		set "eAC3BR=!eAC3BR:~5!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"AC3=" "%~dp0FS_Audio_Converter_Options.ini"') DO (
		set "AC3BR=%%A"
		set "AC3BR=!AC3BR:~4!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"AAC=" "%~dp0FS_Audio_Converter_Options.ini"') DO (
		set "AACBR=%%A"
		set "AACBR=!AACBR:~4!"
	)
)

if not exist "%~dp0FS_Dolby_Atmos_Muxer.cmd" reg delete "HKLM\Software\Classes\Directory\shell\MenuFSAUDIOCONVERTER" /f>nul 2>&1

:MAINMENU
set "SHOWAMP=%AMPLIFY% dB"
if /i "%AMPLIFY%"=="NORMALIZE" set "SHOWAMP=NORMALIZED"
if /i "%AMPLIFY%"=="DIALNORM" set "SHOWAMP=DIALNORM -31 dB"
if "%AMPLIFY%"=="0" set "SHOWAMP=ORIGINAL"
set "WAVBRAUTO=FALSE"
echo !WAVBR! |findstr /I "AUTO" && set "WAVBRAUTO=TRUE"
set "WAVBR_TEXT=!WAVBR:~,2!"
set "WAVBRAUTO_TEXT=colortxt 08 "DISABLED""
if "!WAVBRAUTO!"=="TRUE" (
	set "WAVBRAUTO_TEXT=colortxt 0A "ENABLED""
)
if "!TARGET_FOLDER!"=="" set "TARGET_FOLDER=SAME AS SOURCE"
set "TARGET_FOLDER_STRING=!TARGET_FOLDER!\^<FILENAME^>"
if "!TARGET_FOLDER!"=="SAME AS SOURCE" set "TARGET_FOLDER_STRING=<SOURCEDIR>\<FILENAME>"
if exist "!DRP_FOLDER!\drp.exe" (
	set "DRP_CTEXT=colortxt 0A "FOUND""
) else (
	set "DRP_CTEXT=colortxt 0C "NOT FOUND""
	set "DAD=FALSE"
	set "DAP=FALSE"
)
if "%DAD%"=="TRUE" (
	set "DAD_TEXT=colortxt 0A "ENABLED""
) else (
	set "DAD_TEXT=colortxt 08 "DISABLED""
)
if "%DAP%"=="TRUE" (
	set "DAP_TEXT=colortxt 0A "ENABLED""
) else (
	set "DAP_TEXT=colortxt 08 "DISABLED""
)
for /f "tokens=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16 delims=," %%A in ("!ALAYOUT_NAMES!") do set "FL_NAME=%%A" & set "FR_NAME=%%B" & set "FC_NAME=%%C" & set "LFE_NAME=%%D" & set "SL_NAME=%%E" & set "SR_NAME=%%F" & set "BL_NAME=%%G" & set "BR_NAME=%%H" & set "WL_NAME=%%I" & set "WR_NAME=%%J" & set "TFL_NAME=%%K" & set "TFR_NAME=%%L" & set "TSL_NAME=%%M" & set "TSR_NAME=%%N" & set "TBL_NAME=%%O" & set "TBR_NAME=%%P"
set A_NAMESET=^[!FL_NAME!^]^[!FR_NAME!^]^[!FC_NAME!^]^[!LFE_NAME!^]^[!SL_NAME!^]^[!SR_NAME!^]^[!BL_NAME!^]^[!BR_NAME!^]^[!WL_NAME!^]^[!WR_NAME!^]^[!TFL_NAME!^]^[!TFR_NAME!^]^[!TSL_NAME!^]^[!TSR_NAME!^]^[!TBL_NAME!^]^[!TBR_NAME!^]
if "%SHORTFILENAMES%"=="TRUE" (
	set "SHORTFILENAMES_TEXT=colortxt 0A "ENABLED""
) else (
	set "SHORTFILENAMES_TEXT=colortxt 08 "DISABLED""
)
if "%LOGFILE%"=="TRUE" (
	set "LOGFILE_TEXT=colortxt 0A "ENABLED""
) else (
	set "LOGFILE_TEXT=colortxt 08 "DISABLED""
)
cls
%green%
echo                                                                                                                                                                               Copyright (c) 2023 TeamQfG
echo.
%white%
echo                                                                                   ====================================
%green%
echo                                                                                        FS AUDIO CONVERTER OPTIONS
%white%
echo                                                                                   ====================================
%WHITE%
echo.
echo.
echo == FOLDERS =============================================================================================================================================================================================
echo.
%CYAN%
echo OUTPUT FOLDER          = !TARGET_FOLDER_STRING!
echo TEMP FOLDER            = !TEMP_FOLDER!\^<CODE^>
call :colortxt 0B "DOLBY REFERENCE PLAYER = !DRP_FOLDER! [" & call :!DRP_CTEXT! & call :colortxt 0B "]" /n
%WHITE%
echo.
echo == SETTINGS ============================================================================================================================================================================================
echo.
%CYAN%
echo Mono WAVs Layout       = !MONOWAVSLAYOUT!
%WHITE%
echo.
echo == BITRATES ============================================================================================================================================================================================
echo.
%YELLOW%
call :colortxt 0E "WAV                    = !WAVBR_TEXT!-Bit / Auto Bitdepth [" & call :!WAVBRAUTO_TEXT! & call :colortxt 0E "]" /n
echo THD Atmos              = !THDBR!-Bit
echo AC-3                   = !AC3BR! k^/bs
echo eAC-3                  = !eAC3BR! k^/bs
echo AAC                    = VBR QL !AACBR!
%WHITE%
echo.
echo == MISC ================================================================================================================================================================================================
echo.
%YELLOW%
call :colortxt 0E "Dolby Atmos Demuxing   = [" & call :!DAD_TEXT! & call :colortxt 0E "]" /n
call :colortxt 0E "Dolby Atmos Priority   = [" & call :!DAP_TEXT! & call :colortxt 0E "]" /n
echo Dolby Atmos Nameset    = !A_NAMESET!
call :colortxt 0E "LPCM Container         = [" & call :colortxt 0A !LPCMCont! & call :colortxt 0E "]" /n
call :colortxt 0E "Standard Loudness      = [" & call :colortxt 0A "!SHOWAMP!" & call :colortxt 0E "]" /n
call :colortxt 0E "Short Filenames        = [" & call :!SHORTFILENAMES_TEXT! & call :colortxt 0E "]" /n
call :colortxt 0E "Logfile                = [" & call :!LOGFILE_TEXT! & call :colortxt 0E "]" /n
%WHITE%
echo.
echo == OPTIONS MENU ========================================================================================================================================================================================
echo.
%CYAN%
echo O. Set OUTPUT Directory
echo T. Set TEMP Directory
echo R. Set DOLBY REFERENCE PLAYER Directory
echo.
echo L. Change Mono WAVs Layout
echo.
%YELLOW%
echo 1. BITRATES MENU
echo 2. MISC MENU
%WHITE%
echo.
echo 3. Create Shell Extensions
echo 4. Delete Shell Extensions
echo.
%GREEN%
echo D. SET DEFAULT SETTINGS AND EXIT
echo S. SAVE SETTINGS AND EXIT
echo.
%WHITE%
echo Change Settings and Press [S]AVE or [D]EFAULT.
CHOICE /C OTRL1234DS /N /M "Select a Letter O,T,R,L,1,2,3,4,[D]EFAULT,[S]AVE"

if errorlevel 10 (
	echo          FS AUDIO CONVERTER OPTIONS CONFIG File.>"%~dp0FS_Audio_Converter_Options.ini"
	echo ---------------------------------------------------------->>"%~dp0FS_Audio_Converter_Options.ini"
	echo TARGET Folder=!TARGET_FOLDER!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo TEMP Folder=!TEMP_FOLDER!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo DRP Folder=!DRP_FOLDER!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo DAD=!DAD!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo DAP=!DAP!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo ATMOSNAMESET=!ALAYOUT_NAMES!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo LPCM Container=!LPCMCont!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo LOUDNESS=!Amplify!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo SHORTFILENAMES=!SHORTFILENAMES!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo LOGFILE=!LOGFILE!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo WAVs_LAYOUT=^%MONOWAVSLAYOUT%>>"%~dp0FS_Audio_Converter_Options.ini"
	echo WAV=^%WAVBR%>>"%~dp0FS_Audio_Converter_Options.ini"
	echo THD=^%THDBR%>>"%~dp0FS_Audio_Converter_Options.ini"
	echo eAC3=^%eAC3BR%>>"%~dp0FS_Audio_Converter_Options.ini"
	echo AC3=^%AC3BR%>>"%~dp0FS_Audio_Converter_Options.ini"
	echo AAC=^%AACBR%>>"%~dp0FS_Audio_Converter_Options.ini"
	echo ---------------------------------------------------------->>"%~dp0FS_Audio_Converter_Options.ini"
	%GREEN%
	echo.
	echo Settings Saved.
	%WAIT% 2000
	goto EXIT
)
if errorlevel 9 (
	if exist "%~dp0FS_Audio_Converter_Options.ini" del "%~dp0FS_Audio_Converter_Options.ini">nul 2>&1
	echo.
	%GREEN%
	echo Settings set to Default.
	%WAIT% 2000
	goto EXIT
)
if errorlevel 8 (
	reg delete "HKCR\*\Shell\MenuFSAUDIOCONVERTER" /f>nul 2>&1
	reg delete "HKLM\Software\Classes\Directory\shell\MenuFSAUDIOCONVERTER" /f>nul 2>&1
	echo.
	%GREEN%
	echo Registry strings deleted.
	%WAIT% 2000
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
	reg add "HKCR\*\Shell\MenuFSAUDIOCONVERTER\ContextMenu\shell\01TOOL\command" /ve /d "\"%~dp0FS_Audio_Converter.cmd\" ""%%1""" /f>nul 2>&1
	reg add "HKCR\*\Shell\MenuFSAUDIOCONVERTER\ContextMenu\shell\02OPTIONS" /ve /d "Options" /f>nul 2>&1
	reg add "HKCR\*\Shell\MenuFSAUDIOCONVERTER\ContextMenu\shell\02OPTIONS" /v "Icon" /t REG_SZ /d "\"%~dp0tools\FSAC.ico\",0" /f>nul 2>&1
	reg add "HKCR\*\Shell\MenuFSAUDIOCONVERTER\ContextMenu\shell\02OPTIONS\command" /ve /d "%~dp0FS_Audio_Converter_Options.cmd" /f>nul 2>&1
	if exist "%~dp0FS_Dolby_Atmos_Muxer.cmd" reg add "HKLM\Software\Classes\Directory\shell\MenuFSAUDIOCONVERTER" /ve /d "Mux included WAVs to Atmos file..." /f>nul 2>&1
	if exist "%~dp0FS_Dolby_Atmos_Muxer.cmd" reg add "HKLM\Software\Classes\Directory\shell\MenuFSAUDIOCONVERTER" /v "Icon" /t REG_SZ /d "\"%~dp0tools\FSAC.ico\",0" /f>nul 2>&1
	if exist "%~dp0FS_Dolby_Atmos_Muxer.cmd" reg add "HKLM\Software\Classes\Directory\shell\MenuFSAUDIOCONVERTER" /v "Position" /t REG_SZ /d "Top" /f>nul 2>&1
	if exist "%~dp0FS_Dolby_Atmos_Muxer.cmd" reg add "HKLM\Software\Classes\Directory\shell\MenuFSAUDIOCONVERTER\command" /ve /d "\"%~dp0FS_Dolby_Atmos_Muxer.cmd\" ""%%1""" /f>nul 2>&1
	echo.
	%GREEN%	
	echo Registry strings set.
	%WAIT% 2000
)
if errorlevel 6 goto :MISC_MENU
if errorlevel 5 goto :BITRATES_MENU
if errorlevel 4 (
	if "%MONOWAVSLAYOUT%"=="DTS-HD Master Audio Suite" set "MONOWAVSLAYOUT=Standard"
	if "%MONOWAVSLAYOUT%"=="Standard" set "MONOWAVSLAYOUT=DTS-HD Master Audio Suite"
)
if errorlevel 3 (
	%CYAN%
	echo.
	echo Set the DRP Folder. Do not use the last ^"^\^" symbol^!
	echo If you will use the STANDARD DRP folder leave blank and press [ENTER]^!
	echo Don't forget to [S]AVE your settings after editing^^!
	%WHITE%
	echo.
	set /p "DRP_FOLDER=Type in your DOLBY REFERENCE PLAYER Folder and press [ENTER]:" || SET "DRP_FOLDER=!ProgramFiles!\Dolby\Dolby Reference Player"
)
if errorlevel 2 (
	%CYAN%
	echo.
	echo Set the temp folder. Do not use the last ^"^\^" symbol^!
	echo If you will use the STANDARD TEMP folder leave blank and press [ENTER]^!
	echo Don't forget to [S]AVE your settings after editing^^!
	%WHITE%
	echo.
	set /p "TEMP_FOLDER=Type in your TEMP Folder and press [ENTER]:" || SET "TEMP_FOLDER=%~dp0temp"
)
if errorlevel 1 (
	%CYAN%
	echo.
	echo Set the output folder. Do not use the last ^"^\^" symbol^!
	echo If you will use the STANDARD SOURCE folder leave blank and press [ENTER]^!
	echo Don't forget to [S]AVE your settings after editing^^!
	%WHITE%
	echo.
	set /p "TARGET_FOLDER=Type in your OUTPUT Folder and press [ENTER]:" || SET "TARGET_FOLDER=SAME AS SOURCE"
)
goto MAINMENU

:BITRATES_MENU
set "WAVBRAUTO=FALSE"
echo !WAVBR! |findstr /I "AUTO" && set "WAVBRAUTO=TRUE"
set "WAVBR_TEXT=!WAVBR:~,2!"
set "WAVBRAUTO_TEXT=colortxt 08 "DISABLED""
if "!WAVBRAUTO!"=="TRUE" (
	set "WAVBRAUTO_TEXT=colortxt 0A "ENABLED""
)
cls
%green%
echo                                                                                                                                                                               Copyright (c) 2023 TeamQfG
echo.
%white%
echo                                                                                   ====================================
%green%
echo                                                                                        FS AUDIO CONVERTER OPTIONS
%white%
echo                                                                                   ====================================
%WHITE%
echo.
echo.
echo == BITRATES ============================================================================================================================================================================================
echo.
%YELLOW%
call :colortxt 0E "WAV                    = !WAVBR_TEXT!-Bit / Auto Bitdepth [" & call :!WAVBRAUTO_TEXT! & call :colortxt 0E "]" /n
echo THD Atmos              = !THDBR!-Bit
echo AC-3                   = !AC3BR! k^/bs
echo eAC-3                  = !eAC3BR! k^/bs
echo AAC                    = VBR QL !AACBR!
%WHITE%
echo.
echo == BITRATES MENU =======================================================================================================================================================================================
echo.
%YELLOW%
echo 1. Set WAV Bitdepth ^/ Auto Bitdepth
echo 2. Set THD Atmos Bitrate
echo 3. Set AC-3 Bitrate
echo 4. Set eAC-3 Bitrate
echo 5. Set AAC VBR QL
echo.
%GREEN%
echo S. SAVE SETTINGS AND EXIT
echo E. EXIT WITHOUT SAVING
echo.
%WHITE%
echo Change Settings and Press [S]AVE or [E]XIT WITHOUT SAVE.
CHOICE /C 12345SE /N /M "Select a Letter 1,2,3,4,5,[S]AVE,[E]XIT"

if errorlevel 7 (
	echo.
	%RED%
	echo Exit without saving.
	%WAIT% 2000
	goto PREFETCH
)
if errorlevel 6 (
	echo          FS AUDIO CONVERTER OPTIONS CONFIG File.>"%~dp0FS_Audio_Converter_Options.ini"
	echo ---------------------------------------------------------->>"%~dp0FS_Audio_Converter_Options.ini"
	echo TARGET Folder=!TARGET_FOLDER!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo TEMP Folder=!TEMP_FOLDER!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo DRP Folder=!DRP_FOLDER!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo DAD=!DAD!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo DAP=!DAP!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo ATMOSNAMESET=!ALAYOUT_NAMES!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo LPCM Container=!LPCMCont!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo LOUDNESS=!Amplify!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo SHORTFILENAMES=!SHORTFILENAMES!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo LOGFILE=!LOGFILE!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo WAVs_LAYOUT=^%MONOWAVSLAYOUT%>>"%~dp0FS_Audio_Converter_Options.ini"
	echo WAV=^%WAVBR%>>"%~dp0FS_Audio_Converter_Options.ini"
	echo THD=^%THDBR%>>"%~dp0FS_Audio_Converter_Options.ini"
	echo eAC3=^%eAC3BR%>>"%~dp0FS_Audio_Converter_Options.ini"
	echo AC3=^%AC3BR%>>"%~dp0FS_Audio_Converter_Options.ini"
	echo AAC=^%AACBR%>>"%~dp0FS_Audio_Converter_Options.ini"
	echo ---------------------------------------------------------->>"%~dp0FS_Audio_Converter_Options.ini"
	%GREEN%
	echo.
	echo Settings Saved.
	%WAIT% 2000
	goto MAINMENU
)
if errorlevel 5 (
	%YELLOW%
	echo.
	echo Set the VBR QL in steps 1 ^(lowest^) till 5 ^(highest^). ^(1,2,3,4,5^).
	echo Don't forget to [S]AVE your settings after editing^^!
	%WHITE%
	echo.
	set /p "AACBR=Type in VBR QL and press [ENTER]:" || SET "AACBR=!AACBR!"
)
if errorlevel 4 (
	%YELLOW%
	echo.
	echo Set the Bitrate in k^/bit ^(32-6144^).
	echo Don't forget to [S]AVE your settings after editing^^!
	%WHITE%
	echo.
	set /p "eAC3BR=Type in Bitrate and press [ENTER]:" || SET "eAC3BR=!eAC3BR!"
)
if errorlevel 3 (
	%YELLOW%
	echo.
	echo Set the Bitrate in k^/bit ^(32-640^).
	echo Don't forget to [S]AVE your settings after editing^^!
	%WHITE%
	echo.
	set /p "AC3BR=Type in Bitrate and press [ENTER]:" || SET "AC3BR=!AC3BR!"
)
if errorlevel 2 (
	%YELLOW%
	echo.
	echo Set the Bitdepth in BIT ^(16,24,32^).
	echo Don't forget to [S]AVE your settings after editing^^!
	%WHITE%
	echo.
	set /p "THDBR=Type in Bitdepth and press [ENTER]:" || SET "THDBR=!THDBR!"
)
if errorlevel 1 (
	%YELLOW%
	echo.
	echo Set the Bitdepth in BIT ^(16,24,32^).
	echo Also you can set your Bitdepth followed with AUTO. For example: 16 AUTO to enable Auto Detection.
	echo.
	echo Don't forget to [S]AVE your settings after editing^^!
	%WHITE%
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
	set "DRP_CTEXT=colortxt 0A "FOUND""
) else (
	set "DRP_CTEXT=colortxt 0C "NOT FOUND""
	set "DAD=FALSE"
	set "DAP=FALSE"
)
if "%DAD%"=="TRUE" (
	set "DAD_TEXT=colortxt 0A "ENABLED""
) else (
	set "DAD_TEXT=colortxt 08 "DISABLED""
)
if "%DAP%"=="TRUE" (
	set "DAP_TEXT=colortxt 0A "ENABLED""
) else (
	set "DAP_TEXT=colortxt 08 "DISABLED""
)
for /f "tokens=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16 delims=," %%A in ("!ALAYOUT_NAMES!") do set "FL_NAME=%%A" & set "FR_NAME=%%B" & set "FC_NAME=%%C" & set "LFE_NAME=%%D" & set "SL_NAME=%%E" & set "SR_NAME=%%F" & set "BL_NAME=%%G" & set "BR_NAME=%%H" & set "WL_NAME=%%I" & set "WR_NAME=%%J" & set "TFL_NAME=%%K" & set "TFR_NAME=%%L" & set "TSL_NAME=%%M" & set "TSR_NAME=%%N" & set "TBL_NAME=%%O" & set "TBR_NAME=%%P"
set A_NAMESET=^[!FL_NAME!^]^[!FR_NAME!^]^[!FC_NAME!^]^[!LFE_NAME!^]^[!SL_NAME!^]^[!SR_NAME!^]^[!BL_NAME!^]^[!BR_NAME!^]^[!WL_NAME!^]^[!WR_NAME!^]^[!TFL_NAME!^]^[!TFR_NAME!^]^[!TSL_NAME!^]^[!TSR_NAME!^]^[!TBL_NAME!^]^[!TBR_NAME!^]
if "%SHORTFILENAMES%"=="TRUE" (
	set "SHORTFILENAMES_TEXT=colortxt 0A "ENABLED""
) else (
	set "SHORTFILENAMES_TEXT=colortxt 08 "DISABLED""
)
if "%LOGFILE%"=="TRUE" (
	set "LOGFILE_TEXT=colortxt 0A "ENABLED""
) else (
	set "LOGFILE_TEXT=colortxt 08 "DISABLED""
)
cls
%green%
echo                                                                                                                                                                               Copyright (c) 2023 TeamQfG
echo.
%white%
echo                                                                                   ====================================
%green%
echo                                                                                        FS AUDIO CONVERTER OPTIONS
%white%
echo                                                                                   ====================================
%WHITE%
echo.
echo.
echo == MISC ================================================================================================================================================================================================
echo.
%YELLOW%
call :colortxt 0E "Dolby Atmos Demuxing   = [" & call :!DAD_TEXT! & call :colortxt 0E "]" /n
call :colortxt 0E "Dolby Atmos Priority   = [" & call :!DAP_TEXT! & call :colortxt 0E "]" /n
echo Dolby Atmos Nameset    = !A_NAMESET!
call :colortxt 0E "LPCM Container         = [" & call :colortxt 0A !LPCMCont! & call :colortxt 0E "]" /n
call :colortxt 0E "Standard Loudness      = [" & call :colortxt 0A "!SHOWAMP!" & call :colortxt 0E "]" /n
call :colortxt 0E "Short Filenames        = [" & call :!SHORTFILENAMES_TEXT! & call :colortxt 0E "]" /n
call :colortxt 0E "Logfile                = [" & call :!LOGFILE_TEXT! & call :colortxt 0E "]" /n
%WHITE%
echo.
echo == MISC MENU ===========================================================================================================================================================================================
echo.
%YELLOW%
call :colortxt 0E "1. Enable / Disable Dolby Atmos Demuxing [" & call :!DAD_TEXT! & call :colortxt 0E "]" /n
call :colortxt 0E "2. Enable / Disable Dolby Atmos Priority [" & call :!DAP_TEXT! & call :colortxt 0E "]" /n
echo 3. Set Dolby Atmos Nameset
call :colortxt 0E "4. LPCM Container                        [" & call :colortxt 0A !LPCMCont! & call :colortxt 0E "]" /n
call :colortxt 0E "5. Standard Loudness                     [" & call :colortxt 0A "!SHOWAMP!" & call :colortxt 0E "]" /n
call :colortxt 0E "6. Enable / Disable Short Filenames      [" & call :!SHORTFILENAMES_TEXT! & call :colortxt 0E "]" /n
call :colortxt 0E "7. Enable / Disable Logfile              [" & call :!LOGFILE_TEXT! & call :colortxt 0E "]" /n
echo.
%GREEN%
echo S. SAVE SETTINGS AND EXIT
echo E. EXIT WITHOUT SAVING
echo.
%WHITE%
echo Change Settings and Press [S]AVE or [E]XIT WITHOUT SAVE.
CHOICE /C 1234567SE /N /M "Select a Letter 1,2,3,4,5,6,7,[S]AVE,[E]XIT"

if errorlevel 9 (
	echo.
	%RED%
	echo Exit without saving.
	%WAIT% 2000
	goto PREFETCH
)
if errorlevel 8 (
	echo          FS AUDIO CONVERTER OPTIONS CONFIG File.>"%~dp0FS_Audio_Converter_Options.ini"
	echo ---------------------------------------------------------->>"%~dp0FS_Audio_Converter_Options.ini"
	echo TARGET Folder=!TARGET_FOLDER!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo TEMP Folder=!TEMP_FOLDER!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo DRP Folder=!DRP_FOLDER!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo DAD=!DAD!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo DAP=!DAP!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo ATMOSNAMESET=!ALAYOUT_NAMES!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo LPCM Container=!LPCMCont!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo LOUDNESS=!Amplify!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo SHORTFILENAMES=!SHORTFILENAMES!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo LOGFILE=!LOGFILE!>>"%~dp0FS_Audio_Converter_Options.ini"
	echo WAVs_LAYOUT=^%MONOWAVSLAYOUT%>>"%~dp0FS_Audio_Converter_Options.ini"
	echo WAV=^%WAVBR%>>"%~dp0FS_Audio_Converter_Options.ini"
	echo eAC3=^%eAC3BR%>>"%~dp0FS_Audio_Converter_Options.ini"
	echo AC3=^%AC3BR%>>"%~dp0FS_Audio_Converter_Options.ini"
	echo AAC=^%AACBR%>>"%~dp0FS_Audio_Converter_Options.ini"
	echo ---------------------------------------------------------->>"%~dp0FS_Audio_Converter_Options.ini"
	%GREEN%
	echo.
	echo Settings Saved.
	%WAIT% 2000
	goto MAINMENU
)
if errorlevel 7 (
	if "%LOGFILE%"=="TRUE" set "LOGFILE=FALSE"
	if "%LOGFILE%"=="FALSE" set "LOGFILE=TRUE"
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
	%YELLOW%
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
	%WHITE%
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

:colortxt
setlocal enableDelayedExpansion
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	
:colorPrint Color  Str  [/n]
setlocal
set "s=%~2"
call :colorPrintVar %1 s %3
exit /b

:colorPrintVar  Color  StrVar  [/n]
if not defined DEL call :initColorPrint
setlocal enableDelayedExpansion
pushd .
':
cd \
set "s=!%~2!"
:: The single blank line within the following IN() clause is critical - DO NOT REMOVE
for %%n in (^"^

^") do (
  set "s=!s:\=%%~n\%%~n!"
  set "s=!s:/=%%~n/%%~n!"
  set "s=!s::=%%~n:%%~n!"
)
for /f delims^=^ eol^= %%s in ("!s!") do (
  if "!" equ "" setlocal disableDelayedExpansion
  if %%s==\ (
    findstr /a:%~1 "." "\'" nul
    <nul set /p "=%DEL%%DEL%%DEL%"
  ) else if %%s==/ (
    findstr /a:%~1 "." "/.\'" nul
    <nul set /p "=%DEL%%DEL%%DEL%%DEL%%DEL%"
  ) else (
    >colorPrint.txt (echo %%s\..\')
    findstr /a:%~1 /f:colorPrint.txt "."
    <nul set /p "=%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%"
  )
)
if /i "%~3"=="/n" echo(
popd
exit /b


:initColorPrint
for /f %%A in ('"prompt $H&for %%B in (1) do rem"') do set "DEL=%%A %%A"
<nul >"%temp%\'" set /p "=."
subst ': "%temp%" >nul
exit /b


:cleanupColorPrint
2>nul del "%temp%\'"
2>nul del "%temp%\colorPrint.txt"
>nul subst ': /d
exit /b

:EXIT
%WHITE%
if "%OPTIONS%"=="YES" goto :eof
setlocal DisableDelayedExpansion
ENDLOCAL
echo.
echo  == EXIT ================================================================================================================================================================================================
echo.
exit