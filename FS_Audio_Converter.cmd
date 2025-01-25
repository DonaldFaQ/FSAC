@echo off & setlocal
mode con cols=120 lines=55
chcp 1252>nul
TITLE  FS Audio Converter [Team QfG] v0.68 beta

set PasswordChars=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890
set PasswordLength=5
call :CreatePassword Password

setlocal EnableDelayedExpansion

::Change to your liking
set "sfkpath=%~dp0tools\sfk.exe"
set "eac3topath=%~dp0tools\eac3to.exe"
set "FFMPEGpath=%~dp0tools\ffmpeg.exe"
set "SOXpath=%~dp0tools\sox.exe"
set "LSMASHpath=%~dp0tools\LSMASHSource.dll"
set "MEDIAINFOpath=%~dp0tools\MediaInfo.exe"
set "TOOLSpath=%~dp0tools"
set "CAVERNpath=%~dp0tools\CavernizeGUI.exe"

::HARDCODED
set "FIRSTSTART=TRUE"
set "DAD=TRUE"
set "DAP=FALSE"
set "ALAYOUT_NAMES=FL,FR,FC,LFE,SL,SR,BL,BR,WL,WR,TFL,TFR,TSL,TSR,TBL,TBR"
set "REM_DIALNORM=NO"
set "SHORTFILENAMES=FALSE"
set "LOGFILE=TRUE"
set "ATMOS_INFO="
set "ATMOS_CODEC="
set "ATMOS_MONOWAV=FALSE"
set "ATMOS_OPT=FALSE"
set "C_LAYOUT=UNKNOWN"
set "LPCMCont=WAV"
set "SOURCEFILE=%~dpnx1"
set "SOURCEFILE_ORIG=!SOURCEFILE!"
set "SOURCEFILENAME=%~n1"
set "SOURCEFILEEXT=%~x1"
set "SOURCEFILEPATHNAME=%~dpn1"
set "TARGET_FOLDER=SAME AS SOURCE\"
set "TEMP_FOLDER=%~dp0temp"
set "DRP_FOLDER=!ProgramFiles!\Dolby\Dolby Reference Player"
set "MONOWAVSLAYOUT=Standard"
set "CONTTRUE=FALSE"
set "THDAC3=FALSE"
set "PCM_10CHANNEL=FALSE"
set "TRACK=2"
set "DRC=OFF"
set "DRC_SCALE="
set "codec_out_NAME=FLAC"
set "SAMPLE_RATE=ORIGINAL"
set "Tempo_NAME=ORIGINAL"
set "Pitch_NAME=NO"
set "HEADER_FIX=NO"
set "TIMESTRETCH=NO"
set "DELAY=0"
set "AMPLIFY=NORMALIZE"
set "WAVBR=16"
set "THDBR=24"
set "WAVBRAUTO=FALSE"
set "WAVBRAUTOINFO_TEXT="
set "AC3BR=640"
set "eAC3BR=640"
set "AACBR=5"
set "SL_EXT=SL"
set "SR_EXT=SR"
set "BL_EXT=BL"
set "BR_EXT=BR"
set "BC_EXT=BC"
set "PAN="
set "51PAN=FALSE"
set "FILE_COUNTER=0"

set "WAIT="!sfkpath!" sleep"
set "GREEN="!sfkpath!" color green"
set "RED="!sfkpath!" color red"
set "YELLOW="!sfkpath!" color yellow"
set "WHITE="!sfkpath!" color white"
set "CYAN="!sfkpath!" color cyan"
set "MAGENTA="!sfkpath!" color magenta"
set "GREY="!sfkpath!" color grey"

if not exist "%~dp0FS_Dolby_Atmos_Muxer.cmd" reg delete "HKLM\Software\Classes\Directory\shell\MenuFSAUDIOCONVERTER" /f>nul 2>&1
if "%~1"=="" call "%~dp0FS_Audio_Converter_Options.cmd"

echo.

:BEGIN
if "%OPTIONS%"=="YES" call "%~dp0FS_Audio_Converter_Options.cmd"
set "OPTIONS=NO"

::Check for INI and Load Settings
if exist "%~dp0FS_Audio_Converter_Options.ini" (
	FOR /F "delims=" %%A IN ('findstr /C:"TARGET Folder=" "%~dp0FS_Audio_Converter_Options.ini"') DO (
		set "TARGET_FOLDER=%%A"
		set "TARGET_FOLDER=!TARGET_FOLDER:~14!\"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"TEMP Folder=" "%~dp0FS_Audio_Converter_Options.ini"') DO (
		set "TEMP_FOLDER=%%A"
		set "TEMP_FOLDER=!TEMP_FOLDER:~12!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"DRP Folder=" "%~dp0FS_Audio_Converter_Options.ini"') DO (
		set "DRP_FOLDER=%%A"
		set "DRP_FOLDER=!DRP_FOLDER:~11!"
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
	FOR /F "delims=" %%A IN ('findstr /C:"LPCM Container=" "%~dp0FS_Audio_Converter_Options.ini"') DO (
		set "LPCMCont=%%A"
		set "LPCMCont=!LPCMCont:~15!"
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
if exist "%~dp0FS_Audio_Converter_Settings.ini" (
	for /F "delims=" %%A IN ('findstr /C:"Stream=" "%~dp0FS_Audio_Converter_Settings.ini"') DO (
		set "TRACK=%%A"
		set "TRACK=!TRACK:~7!"
	)
	for /F "delims=" %%A IN ('findstr /C:"DRC=" "%~dp0FS_Audio_Converter_Settings.ini"') DO (
		set "DRC=%%A"
		set "DRC=!DRC:~4!"
	)
	for /F "delims=" %%A IN ('findstr /C:"Codec=" "%~dp0FS_Audio_Converter_Settings.ini"') DO (
		set "codec_out_NAME=%%A"
		set "codec_out_NAME=!codec_out_NAME:~6!"
	)
	for /F "delims=" %%A IN ('findstr /C:"Sample Rate=" "%~dp0FS_Audio_Converter_Settings.ini"') DO (
		set "SAMPLE_RATE=%%A"
		set "SAMPLE_RATE=!SAMPLE_RATE:~12!"
	)
	for /F "delims=" %%A IN ('findstr /C:"MonoWAVsLayout=" "%~dp0FS_Audio_Converter_Settings.ini"') DO (
		set "MONOWAVSLAYOUT=%%A"
		set "MONOWAVSLAYOUT=!MONOWAVSLAYOUT:~15!"
	)
	for /F "delims=" %%A IN ('findstr /C:"Tempo=" "%~dp0FS_Audio_Converter_Settings.ini"') DO (
		set "Tempo_NAME=%%A"
		set "Tempo_NAME=!Tempo_NAME:~6!"
	)
	for /F "delims=" %%A IN ('findstr /C:"Pitch Correction=" "%~dp0FS_Audio_Converter_Settings.ini"') DO (
		set "Pitch_NAME=%%A"
		set "Pitch_NAME=!Pitch_NAME:~17!"
	)
	for /F "delims=" %%A IN ('findstr /C:"Delay=" "%~dp0FS_Audio_Converter_Settings.ini"') DO (
		set "DELAY=%%A"
		set "DELAY=!DELAY:~6!"
	)
	for /F "delims=" %%A IN ('findstr /C:"Amplify=" "%~dp0FS_Audio_Converter_Settings.ini"') DO (
		set "AMPLIFY=%%A"
		set "AMPLIFY=!AMPLIFY:~8!"
	)
)

set "TEMP_FOLDER=!TEMP_FOLDER!\%Password%"
if not exist "!TEMP_FOLDER!" md "!TEMP_FOLDER!"

set "MONOWASLAYOUT_ORIG=!MONOWAVSLAYOUT!"
if "%codec_out_NAME%"=="Mono WAVs [ATMOS]" set "codec_out_NAME=Mono WAVs"
if "%codec_out_NAME%"=="LPCM Multichannel [ATMOS]" set "codec_out_NAME=LPCM Multichannel"
set "TARGET_FOLDER_STRING=!TARGET_FOLDER!^<FILENAME^>"
if "!TARGET_FOLDER!"=="SAME AS SOURCE\" set "TARGET_FOLDER_STRING=<SOURCEDIR>\<FILENAME>"
if "!TARGET_FOLDER!"=="SAME AS SOURCE\" set "TARGET_FOLDER=%~dp1"
if exist "!TOOLSpath!\log.txt" del "!TOOLSpath!\log.txt"
echo !WAVBR!|findstr /I "AUTO">nul 2>&1 && set "WAVBRAUTO=TRUE"
set "WAVBR_TEXT=!WAVBR:~,2!"

::CHECK SUPPORTED CONTAINER
if /i "!SOURCEFILEEXT!"==".mkv" set "CONTTRUE=TRUE"
if /i "!SOURCEFILEEXT!"==".mka" set "CONTTRUE=TRUE" & set "TRACK=1"
if /i "!SOURCEFILEEXT!"==".avi" set "CONTTRUE=TRUE"
if /i "!SOURCEFILEEXT!"==".evo" set "CONTTRUE=TRUE"
if /i "!SOURCEFILEEXT!"==".vob" set "CONTTRUE=TRUE"
if /i "!SOURCEFILEEXT!"==".m2ts" set "CONTTRUE=TRUE"
if /i "!SOURCEFILEEXT!"==".ts" set "CONTTRUE=TRUE"
if /i "!SOURCEFILEEXT!"==".thd+ac3" set "THDAC3=TRUE"

:: CHECK INPUT FILE
if "!CONTTRUE!"=="TRUE" (
	:: INFOFILE
	"!MEDIAINFOpath!" --full "!SOURCEFILE!" "--Inform=Audio;%%ID%%: %%Format_Commercial%% %%Format_AdditionalFeatures%%,%%Channels%% Channels,%%ChannelLayout%%|%%BitDepth%%|\r\n">"%TEMP_FOLDER%\info.txt"
	:: HEADER FILE
	"!MEDIAINFOpath!" --full "!SOURCEFILE!" "--Inform=General;!SOURCEFILENAME!!SOURCEFILEEXT!, %%AudioCount%% Audio Track(s), %%Duration_String%%">"%TEMP_FOLDER%\header.txt"
	echo ------------------------------------------------------------------------------------------------------------------------>>"%TEMP_FOLDER%\header.txt"
	"!MEDIAINFOpath!" --full "!SOURCEFILE!" "--Inform=Audio;%%ID%%: %%Language_String%%, %%Format_Commercial%% %%Format_AdditionalFeatures%%, %%Channels%% Channels, %%ChannelPositions_String2%%, %%SamplingRate_String%%, %%BitDepth_String%%, %%BitRate_String%%\r\n">>"%TEMP_FOLDER%\header.txt"
) else (
	:: INFOFILE
	"!MEDIAINFOpath!" --full "!SOURCEFILE!" "--Inform=Audio;%%Format_Commercial%% %%Format_AdditionalFeatures%%,%%Channels%% Channels,%%ChannelLayout%%|%%BitDepth%%|\r\n">"%TEMP_FOLDER%\info.txt"
	:: HEADER FILE
	"!MEDIAINFOpath!" --full "!SOURCEFILE!" "--Inform=General;!SOURCEFILENAME!!SOURCEFILEEXT!, %%Duration_String%%">"%TEMP_FOLDER%\header.txt"
	echo ------------------------------------------------------------------------------------------------------------------------>>"%TEMP_FOLDER%\header.txt"
	"!MEDIAINFOpath!" --full "!SOURCEFILE!" "--Inform=Audio;%%Format_Commercial%% %%Format_AdditionalFeatures%%, %%Channels%% Channels, %%ChannelPositions_String2%%, %%SamplingRate_String%%, %%BitDepth_String%%, %%BitRate_String%%\r\n">>"%TEMP_FOLDER%\header.txt"
)
set "S_HEADERFILE=%TEMP_FOLDER%\header.txt"
set "S_INFOFILE=%TEMP_FOLDER%\info.txt"
set "S_TRACKFILE=%TEMP_FOLDER%\track.txt"

:START
if "!CONTTRUE!"=="TRUE" (
	set "TRACKCHECK=FALSE"
) else (
	set "TRACKCHECK=TRUE"
)
set "ATMOSFILE=FALSE"
set "ATMOSTYPE=NONE"
set "ATMOSDEMUX=FALSE"
set "SHOWBD="

:: INFO DRP
if exist "!DRP_FOLDER!\drp.exe" (
	set "DRP_CTEXT=colortxt 0A "FOUND""
) else (
	set "DRP_CTEXT=colortxt 08 "NOT FOUND""
	set "DAD=FALSE"
	set "DAP=FALSE"
)

:: INFO DAD
if "%DAD%"=="TRUE" (
	set "DAD_TEXT=colortxt 0A "ENABLED""
) else (
	set "DAD_TEXT=colortxt 08 "DISABLED""
)

::INFO DAP
if "%DAP%"=="TRUE" (
	set "DAP_TEXT=colortxt 0A "ENABLED""
) else (
	set "DAP_TEXT=colortxt 08 "DISABLED""
)

:: INFO AVISYNTH
if exist "%WINDIR%\System32\Avisynth.dll" (
	set "AS_TEXT=colortxt 0A "FOUND""
) else (
	set "AS_TEXT=colortxt 0C "NOT FOUND""
	%RED%
	echo Avisynth Plus not found. Install Avisynth and start again^!
	%YELLOW%
	echo https://github.com/AviSynth/AviSynthPlus/releases
	start https://github.com/AviSynth/AviSynthPlus/releases
	goto EXIT
)

:: INFO CHOOSEN TRACK
if "!CONTTRUE!"=="FALSE" (
	set "S_TRACKFILE=!S_INFOFILE!"
	FOR /F "delims=" %%A IN ('findstr /C:"with Dolby Atmos" "!S_TRACKFILE!"') DO set "ATMOSFILE=TRUE"
	FOR /F "delims=" %%A IN ('findstr /C:"16 Channels" "!S_TRACKFILE!"') DO set "ATMOSFILE=TRUE"
	FOR /F "delims=" %%A IN ('findstr /C:"12 Channels" "!S_TRACKFILE!"') DO set "ATMOSFILE=TRUE"
	FOR /F "delims=" %%A IN ('findstr /C:"10 Channels" "!S_TRACKFILE!"') DO set "ATMOSFILE=TRUE"

	FOR /F "delims=" %%A IN ('findstr /C:"Dolby TrueHD" "!S_TRACKFILE!"') DO set "ATMOSTYPE=THD"
	FOR /F "delims=" %%A IN ('findstr /C:"Dolby Digital Plus" "!S_TRACKFILE!"') DO set "ATMOSTYPE=DDP"
	FOR /F "delims=" %%A IN ('findstr /C:"PCM" "!S_TRACKFILE!"') DO set "ATMOSTYPE=PCM"
	if "!ATMOSTYPE!"=="PCM" FOR /F "delims=" %%A IN ('findstr /C:"8 Channels" "!S_TRACKFILE!"') DO set "ATMOSFILE=TRUE"
	set "S_TRACKFILE=!S_INFOFILE!"
)
if "!CONTTRUE!"=="TRUE" (
	findstr /C:"!TRACK!:" "!S_INFOFILE!">"!S_TRACKFILE!"
	FOR /F "delims=" %%A IN ('findstr /C:"!TRACK!:" "!S_TRACKFILE!"') DO set "TRACKCHECK=TRUE"
	
	FOR /F "delims=" %%A IN ('findstr /C:"with Dolby Atmos" "!S_TRACKFILE!"') DO set "ATMOSFILE=TRUE"
	FOR /F "delims=" %%A IN ('findstr /C:"16 Channels" "!S_TRACKFILE!"') DO set "ATMOSFILE=TRUE"
	FOR /F "delims=" %%A IN ('findstr /C:"12 Channels" "!S_TRACKFILE!"') DO set "ATMOSFILE=TRUE"
	FOR /F "delims=" %%A IN ('findstr /C:"10 Channels" "!S_TRACKFILE!"') DO set "ATMOSFILE=TRUE"

	FOR /F "delims=" %%A IN ('findstr /C:"Dolby TrueHD" "!S_TRACKFILE!"') DO set "ATMOSTYPE=THD"
	FOR /F "delims=" %%A IN ('findstr /C:"Dolby Digital Plus" "!S_TRACKFILE!"') DO set "ATMOSTYPE=DDP"
	FOR /F "delims=" %%A IN ('findstr /C:"PCM" "!S_TRACKFILE!"') DO set "ATMOSTYPE=PCM"
	if "!ATMOSTYPE!"=="PCM" FOR /F "delims=" %%A IN ('findstr /C:"8 Channels" "!S_TRACKFILE!"') DO set "ATMOSFILE=TRUE"
)

::DAD CHECK
if "%DAD%"=="FALSE" (
	set "ATMOSFILE=FALSE"
	set "ATMOSTYPE=NONE"
	set "ATMOS_OPT=FALSE"
)

::TRACK CHECK
if "!TRACKCHECK!"=="TRUE" (
	set "TRACKCHECK_TEXT=colortxt 0A "VALID""
) else (
	set "TRACKCHECK_TEXT=colortxt 0C "INVALID""
)

::SET AUTO BITRATE
if "%WAVBRAUTO%"=="TRUE" (
	set "WAVBRAUTO_TEXT=colortxt 0A "ENABLED""
	for /f "tokens=2 delims=| usebackq" %%A in ("!S_TRACKFILE!") do (
		if "%%A" NEQ "" set "WAVBR_TEXT=%%A"
		set /a "WAVBR_TEXT=WAVBR_TEXT"
		if "!WAVBR_TEXT!" LSS "24" set "WAVBR_TEXT=16"
		if "!WAVBR_TEXT!" GTR "24" set "WAVBR_TEXT=24"
		set "WAVBRAUTOINFO_TEXT=AUTO "
	)
) else (
	set "WAVBRAUTO_TEXT=colortxt 08 "DISABLED""
)

::BEGIN
cls
%GREEN%
echo                                                                                               Copyright (c) 2025 TeamQfG
echo.
%WHITE%
echo                                        ====================================
%GREEN%
echo                                                 FS AUDIO CONVERTER
%WHITE%
echo                                        ====================================
echo.
%WHITE%
echo INFORMATION:
echo.
call :colortxt 0E "AVISYNTH FRAMESERVER   : [" & call :!AS_TEXT! & call :colortxt 0E "]." /n
call :colortxt 0E "DOLBY REFERENCE PLAYER : [" & call :!DRP_CTEXT! & call :colortxt 0E "]. DOLBY ATMOS DEMUXING : [" & call :!DAD_TEXT! & call :colortxt 0E "]. DOLBY ATMOS PRIORITY : [" & call :!DAP_TEXT! & call :colortxt 0E "]." /n
call :colortxt 0E "BITDEPTH AUTO DETECT   : [" & call :!WAVBRAUTO_TEXT! & call :colortxt 0E "]." /n
echo.
echo SOURCE INFORMATION:
echo.
%CYAN%
for /f "usebackq delims=" %%i in ("!S_HEADERFILE!") do echo %%i
:: MULTICHANNEL SECTION
if "!ATMOS_OPT!"=="FALSE" (
	set "C_LAYOUT=[UNKNOWN]"
	FOR /F "delims=" %%A IN ('findstr /C:"1 Channels" "!S_TRACKFILE!"') DO (
		set "C_LAYOUT=Mono [FC]"
		set "O_C_Layout=!C_LAYOUT!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"2 Channels" "!S_TRACKFILE!"') DO (
		set "C_LAYOUT=Stereo [FL][FR]"
		set "O_C_Layout=!C_LAYOUT!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"L R LFE" "!S_TRACKFILE!"') DO (
		set "C_LAYOUT=2.1 [FL][FR][LFE]"
		set "O_C_Layout=!C_LAYOUT!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"L R Cb" "!S_TRACKFILE!"') DO (
		set "C_LAYOUT=3.0 [FL][FR][FC]"
		set "O_C_Layout=!C_LAYOUT!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"C L R LFE" "!S_TRACKFILE!"') DO (
		set "C_LAYOUT=3.1 [FL][FR][FC][LFE]"
		set "O_C_Layout=!C_LAYOUT!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"L R LFE Cb" "!S_TRACKFILE!"') DO (
		set "C_LAYOUT=3.1 [FL][FR][BC][LFE]"
		set "O_C_Layout=!C_LAYOUT!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"4 Channels" "!S_TRACKFILE!"') DO (
		set "C_LAYOUT=4.0 [UNKNOWN]"
		set "O_C_Layout=!C_LAYOUT!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"L R Ls Rs" "!S_TRACKFILE!"') DO (
		set "C_LAYOUT=4.0 (Quad) [FL][FR][BL][BR]"
		set "O_C_Layout=!C_LAYOUT!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"C L R Cb" "!S_TRACKFILE!"') DO (
		set "C_LAYOUT=4.0 [FL][FR][FC][BC]"
		set "O_C_Layout=!C_LAYOUT!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"C L R LFE Cb" "!S_TRACKFILE!"') DO (
		set "C_LAYOUT=4.1 [FL][FR][FC][LFE][BC]"
		set "O_C_Layout=!C_LAYOUT!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"L R Ls Rs LFE" "!S_TRACKFILE!"') DO (
		set "C_LAYOUT=4.1 (Quad) [FL][FR][LFE][SL][SR]"
		set "O_C_Layout=!C_LAYOUT!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"C L R Ls Rs" "!S_TRACKFILE!"') DO (
		set "C_LAYOUT=5.0 [FL][FR][FC][LS][RS]"
		set "O_C_Layout=!C_LAYOUT!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"6 Channels" "!S_TRACKFILE!"') DO (
		set "C_LAYOUT=5.1 [FL][FR][FC][LFE][LS][RS]"
		set "O_C_Layout=!C_LAYOUT!"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"C L R Ls Rs Cb" "!S_TRACKFILE!"') DO (
		set "C_LAYOUT=6.0 [FL][FR][FC][BC][LS][RS]"
		set "O_C_Layout=!C_LAYOUT!"
		set "51PAN=TRUE"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"C L R Ls Rs LFE Cb" "!S_TRACKFILE!"') DO (
		set "C_LAYOUT=6.1 [FL][FR][FC][LFE][BC][LS][RS]"
		set "O_C_Layout=!C_LAYOUT!"
		set "51PAN=TRUE"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"8 Channels" "!S_TRACKFILE!"') DO (
		set "C_LAYOUT=7.1 [FL][FR][FC][LFE][BL][BR][SL][SR]"
		set "O_C_Layout=!C_LAYOUT!"
		set "51PAN=TRUE"
	)
	:: DTS FORMATS
	FOR /F "delims=" %%A IN ('findstr /C:"ES XLL,6 Channels,C L R Ls Rs Cb" "!S_TRACKFILE!"') DO (
		set "C_LAYOUT=6.0 (Matrix) [FL][FR][FC][(BC)][LS][RS]"
		set "O_C_Layout=!C_LAYOUT!"
		set "51PAN=TRUE"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"ES XCh,6 Channels,C L R Ls Rs Cb" "!S_TRACKFILE!"') DO (
		set "C_LAYOUT=6.0 (Discrete) [FL][FR][FC][BC][LS][RS]"
		set "O_C_Layout=!C_LAYOUT!"
		set "51PAN=TRUE"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"ES XLL,7 Channels,C L R Ls Rs LFE Cb" "!S_TRACKFILE!"') DO (
		set "C_LAYOUT=6.1 (Matrix) [FL][FR][FC][LFE][(BC)][LS][RS]"
		set "O_C_Layout=!C_LAYOUT!"
		set "51PAN=TRUE"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"ES XCh,7 Channels,C L R Ls Rs Cb LFE" "!S_TRACKFILE!"') DO (
		set "C_LAYOUT=6.1 (Discrete) [FL][FR][FC][LFE][BC][LS][RS]"
		set "O_C_Layout=!C_LAYOUT!"
		set "51PAN=TRUE"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"ES XLL,8 Channels,C L R Ls Rs LFE Lb Rb" "!S_TRACKFILE!"') DO (
		set "C_LAYOUT=7.1 (Strange) [FL][FR][FC][LFE][LSR][RSR][LS][RS]"
		set "O_C_Layout=!C_LAYOUT!"
		set "51PAN=TRUE"
	)
)

:: DAP FUNCTION
if "!FIRSTSTART!!DAP!!ATMOSFILE!"=="TRUETRUETRUE" (
	set "ATMOS_OPT=TRUE"
	set "codec_out_NAME=Mono WAVs [ATMOS]"
	set "C_LAYOUT=9.1.6 [FL][FR][FC][LFE][SL][SR][BL][BR][WL][WR][TFL][TFR][TSL][TSR][TBL][TBR]"
)
if "!FIRSTSTART!!DAP!!ATMOSFILE!%codec_out_NAME%"=="TRUETRUETRUELPCM Multichannel" (
	set "ATMOS_OPT=TRUE"
	set "codec_out_NAME=LPCM Multichannel [ATMOS]"
	set "C_LAYOUT=9.1.6 [FL][FR][FC][LFE][SL][SR][BL][BR][WL][WR][TFL][TFR][TSL][TSR][TBL][TBR]"
)
if "!FIRSTSTART!!DAP!!ATMOSFILE!%codec_out_NAME%"=="TRUEFALSETRUEMono WAVs [ATMOS]" (
	set "ATMOS_OPT=FALSE"
	set "codec_out_NAME=Mono WAVs"
	set "C_Layout=!O_C_Layout!"
)
if "!FIRSTSTART!!DAP!!ATMOSFILE!%codec_out_NAME%"=="TRUEFALSETRUELPCM Multichannel [ATMOS]" (
	set "ATMOS_OPT=FALSE"
	set "codec_out_NAME=LPCM Multichannel"
	set "C_Layout=!O_C_Layout!"
)
	
:: PCM SOURCE
if "!ATMOSTYPE!"=="PCM" (
	FOR /F "delims=" %%A IN ('findstr /C:"16 Channels" "!S_TRACKFILE!"') DO (
		set "ATMOS_OPT=TRUE"
		set "C_LAYOUT=9.1.6 [FL][FR][FC][LFE][SL][SR][BL][BR][WL][WR][TFL][TFR][TSL][TSR][TBL][TBR]"
		set "codec_out_NAME=Mono WAVs [ATMOS]"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"12 Channels" "!S_TRACKFILE!"') DO (
		set "ATMOS_OPT=TRUE"
		set "C_LAYOUT=7.1.4 [FL][FR][FC][LFE][SL][SR][BL][BR][TFL][TFR][TBL][TBR]"
		set "codec_out_NAME=Mono WAVs [ATMOS]"
	)
	FOR /F "delims=" %%A IN ('findstr /C:"10 Channels" "!S_TRACKFILE!"') DO (
		if "!FIRSTSTART!"=="TRUE" call :PCM_CHANNEL_10
		set "ATMOS_OPT=TRUE"
		set "codec_out_NAME=Mono WAVs [ATMOS]"
	)
)

set "FIRSTSTART=FALSE"

:: MANIPULATE MENU STRINGS
if "%codec_out_NAME%!51PAN!"=="AC-3TRUE" set "C_LAYOUT=5.1 [FL][FR][FC][LFE][LS][RS]"
if "%codec_out_NAME%!51PAN!"=="eAC-3TRUE" set "C_LAYOUT=5.1 [FL][FR][FC][LFE][LS][RS]"

set "MONOWAVSLAYOUT=-"
if "%codec_out_NAME%"=="Mono WAVs" (
	set "SHOWBD= [!WAVBRAUTOINFO_TEXT!!WAVBR_TEXT!-Bit]"
	set "MONOWAVSLAYOUT=!MONOWASLAYOUT_ORIG!"
)
if "%codec_out_NAME%"=="LPCM Multichannel" (
	set "SHOWBD= [!WAVBRAUTOINFO_TEXT!!WAVBR_TEXT!-Bit]"
	set "MONOWAVSLAYOUT=-"
)
if "%codec_out_NAME%"=="Mono WAVs [ATMOS]" (
	set "SHOWBD= [!THDBR!-Bit]"
	set "MONOWAVSLAYOUT=Dolby Atmos Demuxer"
)
if "%codec_out_NAME%"=="LPCM Multichannel [ATMOS]" (
	set "SHOWBD= [!THDBR!-Bit]" 
	set "MONOWAVSLAYOUT=-"
)

::SET AMPLIFY STRINGS
set "SHOWAMP=%AMPLIFY% dB"
if /i "%AMPLIFY%"=="NORMALIZE" set "SHOWAMP=NORMALIZED"
if /i "%AMPLIFY%"=="DIALNORM" set "SHOWAMP=DIALNORM -31 dB"
if "%AMPLIFY%"=="0" set "SHOWAMP=ORIGINAL"

::SET DELAY STRING
if "%DELAY%"=="0" (
	set "SHOWDELAY=ORIGINAL"
) else (
	set "SHOWDELAY=!DELAY! ms"
)

::SET BITRATE STRINGS
set "BITRATE_NAME=LOSSLESS"
if "%codec_out_NAME%"=="AC-3" set "BITRATE_NAME=%AC3BR% kb^/s"
if "%codec_out_NAME%"=="eAC-3" set "BITRATE_NAME=%eAC3BR% kb^/s"
if "%codec_out_NAME%"=="AAC" set "BITRATE_NAME=VBR QL %AACBR%"

:: SET SAMPLE RATE STRINGS
set "SAMPLE_RATE_NAME=Hz"
if "%SAMPLE_RATE%"=="ORIGINAL" set "SAMPLE_RATE_NAME="
if "%SAMPLE_RATE%"=="48000" set "SAMPLE_RATE_NAME=Hz ^[BluRay ^/ DVD^]"
if "%SAMPLE_RATE%"=="44100" set "SAMPLE_RATE_NAME=Hz ^[CD^]"

:: IF ATMOS_OPT IS SET BUT NO ATMOS FILE
if "!ATMOSFILE!%codec_out_NAME%"=="FALSEMono WAVs [ATMOS]" set "codec_out_NAME=FLAC"
if "!ATMOSFILE!%codec_out_NAME%"=="FALSELPCM Multichannel [ATMOS]" set "codec_out_NAME=FLAC"

:: CHECK FOR ATMOS_OPT
if "!ATMOSFILE!%codec_out_NAME%"=="TRUELPCM Multichannel [ATMOS]" set "ATMOS_OPT=TRUE"
if "!ATMOSFILE!%codec_out_NAME%"=="TRUEMono WAVs [ATMOS]" set "ATMOS_OPT=TRUE"

:: MENU
echo.	
%WHITE%
echo SETTINGS:
if "%CONTTRUE%"=="TRUE" (
	echo.
	%CYAN%
	echo    Output Folder:
	echo    !TARGET_FOLDER_STRING!
	echo.
	%YELLOW%
	call :colortxt 0E "1. Stream              : %TRACK% [" & call :!TRACKCHECK_TEXT! & call :colortxt 0E "]" /n
	echo 2. DRC                 : %DRC%
	echo 3. Codec               : %codec_out_NAME%%SHOWBD% [%BITRATE_NAME%]
	if "!ATMOSFILE!"=="TRUE" (
		echo 4. Channel Layout      : !C_LAYOUT!
		echo    Mono WAVs Layout    : !MONOWAVSLAYOUT!
		echo 5. Sample Rate         : %SAMPLE_RATE% %SAMPLE_RATE_NAME%
		echo 6. Tempo               : %Tempo_NAME%
		echo 7. Pitch Correction    : %Pitch_NAME%
		echo 8. Delay               : %SHOWDELAY%
		echo 9. Amplify             : %SHOWAMP%
	) 
	if "!ATMOSFILE!"=="FALSE" (
		echo    Channel Layout      : !C_LAYOUT!
		echo    Mono WAVs Layout    : !MONOWAVSLAYOUT!
		echo 4. Sample Rate         : %SAMPLE_RATE% %SAMPLE_RATE_NAME%
		echo 5. Tempo               : %Tempo_NAME%
		echo 6. Pitch Correction    : %Pitch_NAME%
		echo 7. Delay               : %SHOWDELAY%
		echo 8. Amplify             : %SHOWAMP%
	)
	%GREEN%
	echo.
	echo M. Start Muxing
	echo.
	%YELLOW%
	echo S. Save Settings
	echo D. Default Settings
	echo.
	echo O. Options
	echo.
	%WHITE%
	echo Change Settings and press [M] to start Muxing^!
	if "!ATMOSFILE!"=="TRUE" (
		CHOICE /C 123456789MSDO /N /M "Select a Letter 1,2,3,4,5,6,7,8,9,[M]ux,[S]ave,[D]efault,[O]ptions"
	) else (
		CHOICE /C 12345678MSDO /N /M "Select a Letter 1,2,3,4,5,6,7,8,[M]ux,[S]ave,[D]efault,[O]ptions"
	)
	if "!ATMOSFILE!"=="TRUE" (
		if errorlevel 13 (
			set "OPTIONS=YES"
			goto BEGIN
		)

		if errorlevel 12 (
			if exist "%~dp0FS_Audio_Converter_Settings.ini" del "%~dp0FS_Audio_Converter_Settings.ini"
			set "TRACK=2"
			if /i "!SOURCEFILEEXT!"==".mka" set "TRACK=1"
			set "C_Layout=!O_C_Layout!"
			set "DRC=OFF"
			set "codec_out_NAME=FLAC"
			set "Tempo_NAME=ORIGINAL"
			set "Pitch_NAME=NO"
			set "DELAY=0"
			set "Amplify=0"
		)
		if errorlevel 11 (
			echo  FS AUDIO CONVERTER CONFIG File.>"%~dp0FS_Audio_Converter_Settings.ini"
			echo -------------------------------->>"%~dp0FS_Audio_Converter_Settings.ini"
			echo DO NOT MODIFY>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo.>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Stream=!TRACK!>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo DRC=!DRC!>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Codec=%codec_out_NAME%>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Sample Rate=%SAMPLE_RATE%>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Tempo=%Tempo_NAME%>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Pitch Correction=%Pitch_NAME%>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Delay=^%DELAY%>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Amplify=^%AMPLIFY%>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo.
			%GREEN%
			echo Settings Saved^!
			%WAIT% 2000
		)
		if errorlevel 10 goto DOITAVISYNTH
		if errorlevel 9 (
			echo.
			%WHITE%	
			echo Type in Amplify in dB. For Example: 3 for 3dB higher Loudness, or -3 for 3dB lower Loudness
			echo Also you can type DIALNORM to set DialNorm -31 dB, or NORMALIZE to set the loudest Peak 0dB.
			echo.
			set /p "AMPLIFY=Type in Amplify in dB or DIALNORM, NORMALIZE and press [ENTER]:" || SET "AMPLIFY=!AMPLIFY!"
		)
		if errorlevel 8 (
			echo.
			%WHITE%	
			echo Type in your Delay in ms. For Example: 300 for a positive delay, or -300 for a negative Delay
			echo If you use timechange and delay use the Delay for the NEW speed.
			echo Example: 24FPS to 25FPS and Delay = 10 Frames you must set 400ms instead of 417ms.
			echo.
			set /p "DELAY=Type in your Delay and press [ENTER]:" || SET "DELAY=!DELAY!"
		)
		if errorlevel 7 (
			if "%Tempo_NAME%"=="ORIGINAL" (
				if "%Pitch_NAME%"=="NO" set "Pitch_NAME=[Correction] 25.00 to 23.976"
				if "%Pitch_NAME%"=="[Correction] 25.00 to 23.976" set "Pitch_NAME=[Correction] 25.00 to 24.00"
				if "%Pitch_NAME%"=="[Correction] 25.00 to 24.00" set "Pitch_NAME=[Correction] 23.976 to 25.00"
				if "%Pitch_NAME%"=="[Correction] 23.976 to 25.00" set "Pitch_NAME=[Correction] 24.00 to 25.00"
				if "%Pitch_NAME%"=="[Correction] 24.00 to 25.00" set "Pitch_NAME=NO"
			) else (
				if "%Pitch_NAME%"=="YES" set "Pitch_NAME=NO"
				if "%Pitch_NAME%"=="NO" set "Pitch_NAME=YES"
			)
		)
		if errorlevel 6 (
			if "%Tempo_NAME%"=="ORIGINAL" (
				set "Tempo_NAME=[Slowdown] 25.00 to 23.976"
				set "Pitch_NAME=YES"
			)
			if "%Tempo_NAME%"=="[Slowdown] 25.00 to 23.976" (
				set "Tempo_NAME=[Slowdown] 25.00 to 24.00"
				set "Pitch_NAME=YES"
			)
			if "%Tempo_NAME%"=="[Slowdown] 25.00 to 24.00" (
				set "Tempo_NAME=[Slowdown] 24.00 to 23.976"
				set "Pitch_NAME=NO"
			)
			if "%Tempo_NAME%"=="[Slowdown] 24.00 to 23.976" (
				set "Tempo_NAME=[Speed-Up] 23.976 to 24.00"
				set "Pitch_NAME=NO"
			)
			if "%Tempo_NAME%"=="[Speed-Up] 23.976 to 24.00" (
				set "Tempo_NAME=[Speed-Up] 23.976 to 25.00"
				set "Pitch_NAME=YES"
			)
			if "%Tempo_NAME%"=="[Speed-Up] 23.976 to 25.00" (
				set "Tempo_NAME=[Speed-Up] 24.00 to 25.00"
				set "Pitch_NAME=YES"
			)
			if "%Tempo_NAME%"=="[Speed-Up] 24.00 to 25.00" (
				set "Tempo_NAME=ORIGINAL"
				set "Pitch_NAME=NO"
			)
		)
		if errorlevel 5 (
			if "%SAMPLE_RATE%"=="ORIGINAL" 	set "SAMPLE_RATE=48000"
			if "%SAMPLE_RATE%"=="48000" set "SAMPLE_RATE=44100"
			if "%SAMPLE_RATE%"=="44100" set "SAMPLE_RATE=22050"
			if "%SAMPLE_RATE%"=="22050" set "SAMPLE_RATE=ORIGINAL"
		)
		if errorlevel 4 (
			if "%PCM_10CHANNEL%"=="TRUE" (
				if "%C_LAYOUT%"=="5.1.4 [FL][FR][FC][LFE][SL][SR][TFL][TFR][TBL][TBR] set "C_LAYOUT=7.1.2 [FL][FR][FC][LFE][SL][SR][BL][BR][TSL][TSR]"
				if "%C_LAYOUT%"=="7.1.2 [FL][FR][FC][LFE][SL][SR][BL][BR][TSL][TSR] set "C_LAYOUT=5.1.4 [FL][FR][FC][LFE][SL][SR][TFL][TFR][TBL][TBR]"
			) else (
				if "%C_LAYOUT%"=="9.1.6 [FL][FR][FC][LFE][SL][SR][BL][BR][WL][WR][TFL][TFR][TSL][TSR][TBL][TBR]" set "C_LAYOUT=7.1.4 [FL][FR][FC][LFE][SL][SR][BL][BR][TFL][TFR][TBL][TBR]"
				if "%C_LAYOUT%"=="7.1.4 [FL][FR][FC][LFE][SL][SR][BL][BR][TFL][TFR][TBL][TBR]" set "C_LAYOUT=7.1.2 [FL][FR][FC][LFE][SL][SR][BL][BR][TSL][TSR]"
				if "%C_LAYOUT%"=="7.1.2 [FL][FR][FC][LFE][SL][SR][BL][BR][TSL][TSR]" set "C_LAYOUT=5.1.4 [FL][FR][FC][LFE][SL][SR][TFL][TFR][TBL][TBR]"
				if "%C_LAYOUT%"=="5.1.4 [FL][FR][FC][LFE][SL][SR][TFL][TFR][TBL][TBR]" set "C_LAYOUT=5.1.2 [FL][FR][FC][LFE][SL][SR][TSL][TSR]"
				if "%C_LAYOUT%"=="5.1.2 [FL][FR][FC][LFE][SL][SR][TSL][TSR]" set "C_LAYOUT=9.1.6 [FL][FR][FC][LFE][SL][SR][BL][BR][WL][WR][TFL][TFR][TSL][TSR][TBL][TBR]"
			)
		)
	) else (
		if errorlevel 12 (
			set "OPTIONS=YES"
			goto BEGIN
		)

		if errorlevel 11 (
			if exist "%~dp0FS_Audio_Converter_Settings.ini" del "%~dp0FS_Audio_Converter_Settings.ini"
			set "TRACK=2"
			if /i "!SOURCEFILEEXT!"==".mka" set "TRACK=1"
			set "C_Layout=!O_C_Layout!"
			set "DRC=OFF"
			set "codec_out_NAME=FLAC"
			set "Tempo_NAME=ORIGINAL"
			set "Pitch_NAME=NO"
			set "DELAY=0"
			set "Amplify=0"
		)
		if errorlevel 10 (
			echo  FS AUDIO CONVERTER CONFIG File.>"%~dp0FS_Audio_Converter_Settings.ini"
			echo -------------------------------->>"%~dp0FS_Audio_Converter_Settings.ini"
			echo DO NOT MODIFY>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo.>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Stream=!TRACK!>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo DRC=!DRC!>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Codec=%codec_out_NAME%>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Sample Rate=%SAMPLE_RATE%>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Tempo=%Tempo_NAME%>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Pitch Correction=%Pitch_NAME%>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Delay=^%DELAY%>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Amplify=^%AMPLIFY%>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo.
			%GREEN%
			echo Settings Saved^!
			%WAIT% 2000
		)
		if errorlevel 9 goto DOITAVISYNTH
		if errorlevel 8 (
			echo.
			%WHITE%	
			echo Type in Amplify in dB. For Example: 3 for 3dB higher Loudness, or -3 for 3dB lower Loudness
			echo Also you can type DIALNORM to set DialNorm -31 dB, or NORMALIZE to set the loudest Peak 0dB.
			echo.
			set /p "AMPLIFY=Type in Amplify in dB or DIALNORM, NORMALIZE and press [ENTER]:" || SET "AMPLIFY=!AMPLIFY!"
		)
		if errorlevel 7 (
			echo.
			%WHITE%	
			echo Type in your Delay in ms. For Example: 300 for a positive delay, or -300 for a negative Delay
			echo If you use timechange and delay use the Delay for the NEW speed.
			echo Example: 24FPS to 25FPS and Delay = 10 Frames you must set 400ms instead of 417ms.
			echo.
			set /p "DELAY=Type in your Delay and press [ENTER]:" || SET "DELAY=!DELAY!"
		)
		if errorlevel 6 (
			if "%Tempo_NAME%"=="ORIGINAL" (
				if "%Pitch_NAME%"=="NO" set "Pitch_NAME=[Correction] 25.00 to 23.976"
				if "%Pitch_NAME%"=="[Correction] 25.00 to 23.976" set "Pitch_NAME=[Correction] 25.00 to 24.00"
				if "%Pitch_NAME%"=="[Correction] 25.00 to 24.00" set "Pitch_NAME=[Correction] 23.976 to 25.00"
				if "%Pitch_NAME%"=="[Correction] 23.976 to 25.00" set "Pitch_NAME=[Correction] 24.00 to 25.00"
				if "%Pitch_NAME%"=="[Correction] 24.00 to 25.00" set "Pitch_NAME=NO"
			) else (
				if "%Pitch_NAME%"=="YES" set "Pitch_NAME=NO"
				if "%Pitch_NAME%"=="NO" set "Pitch_NAME=YES"
			)
		)
		if errorlevel 5 (
			if "%Tempo_NAME%"=="ORIGINAL" (
				set "Tempo_NAME=[Slowdown] 25.00 to 23.976"
				set "Pitch_NAME=YES"
			)
			if "%Tempo_NAME%"=="[Slowdown] 25.00 to 23.976" (
				set "Tempo_NAME=[Slowdown] 25.00 to 24.00"
				set "Pitch_NAME=YES"
			)
			if "%Tempo_NAME%"=="[Slowdown] 25.00 to 24.00" (
				set "Tempo_NAME=[Slowdown] 24.00 to 23.976"
				set "Pitch_NAME=NO"
			)
			if "%Tempo_NAME%"=="[Slowdown] 24.00 to 23.976" (
				set "Tempo_NAME=[Speed-Up] 23.976 to 24.00"
				set "Pitch_NAME=NO"
			)
			if "%Tempo_NAME%"=="[Speed-Up] 23.976 to 24.00" (
				set "Tempo_NAME=[Speed-Up] 23.976 to 25.00"
				set "Pitch_NAME=YES"
			)
			if "%Tempo_NAME%"=="[Speed-Up] 23.976 to 25.00" (
				set "Tempo_NAME=[Speed-Up] 24.00 to 25.00"
				set "Pitch_NAME=YES"
			)
			if "%Tempo_NAME%"=="[Speed-Up] 24.00 to 25.00" (
				set "Tempo_NAME=ORIGINAL"
				set "Pitch_NAME=NO"
			)
		)
		if errorlevel 4 (
			if "%SAMPLE_RATE%"=="ORIGINAL" set "SAMPLE_RATE=48000"
			if "%SAMPLE_RATE%"=="48000" set "SAMPLE_RATE=44100"
			if "%SAMPLE_RATE%"=="44100" set "SAMPLE_RATE=22050"
			if "%SAMPLE_RATE%"=="22050" set "SAMPLE_RATE=ORIGINAL"
		)
	)
	if errorlevel 3 (
		set "ATMOS_OPT=FALSE"
		if "!ATMOSFILE!"=="TRUE" (
			if "%codec_out_NAME%"=="FLAC" (
				set "ATMOS_OPT=TRUE"
				set "codec_out_NAME=Mono WAVs [ATMOS]"
				set "C_LAYOUT=9.1.6 [FL][FR][FC][LFE][SL][SR][BL][BR][WL][WR][TFL][TFR][TSL][TSR][TBL][TBR]"
			)
			if "%codec_out_NAME%"=="Mono WAVs [ATMOS]" (
				set "ATMOS_OPT=TRUE"
				set codec_out_NAME=LPCM Multichannel [ATMOS]
				set "C_LAYOUT=9.1.6 [FL][FR][FC][LFE][SL][SR][BL][BR][WL][WR][TFL][TFR][TSL][TSR][TBL][TBR]"
			)
			if "%codec_out_NAME%"=="LPCM Multichannel [ATMOS]" set codec_out_NAME=Mono WAVs
		) else (
			if "%codec_out_NAME%"=="FLAC" set "codec_out_NAME=Mono WAVs"
		)
		if "%codec_out_NAME%"=="Mono WAVs" set "codec_out_NAME=LPCM Multichannel"
		if "%codec_out_NAME%"=="LPCM Multichannel" set "codec_out_NAME=AC-3"
		if "%codec_out_NAME%"=="AC-3" set "codec_out_NAME=eAC-3"
		if "%codec_out_NAME%"=="eAC-3" set "codec_out_NAME=AAC"
		if "%codec_out_NAME%"=="AAC" set "codec_out_NAME=FLAC"
	)
	if errorlevel 2 (
		if "%DRC%"=="OFF" set "DRC=ON" 
		if "%DRC%"=="ON" set "DRC=OFF"
	)
	if errorlevel 1 (
		set "ATMOS_OPT=FALSE"
		set "FIRSTSTART=TRUE"
		echo.
		%WHITE%
		echo Type in the Track Number, which will be extracted.
		echo Importend^! Only Audio Tracks are supported yet.
		echo For Example: For Track 3 type 3 and press Enter^!
		echo.
		set /p "Track=Insert ONLY ONE Track Number here and press [ENTER]: " || SET "Track=!Track!"
	)
	goto START
) else (
	echo.
	%CYAN%
	echo    Output Folder       : 
	echo    !TARGET_FOLDER!
	echo.
	%YELLOW%
	echo 1. DRC                 : %DRC%
	echo 2. Codec               : %codec_out_NAME%%SHOWBD% [%BITRATE_NAME%]
	if "!ATMOS_OPT!"=="TRUE" (
		echo 3. Channel Layout      : !C_LAYOUT!
		echo    Mono WAVs Layout    : !MONOWAVSLAYOUT!
		echo 4. Sample Rate         : %SAMPLE_RATE% %SAMPLE_RATE_NAME%
		echo 5. Tempo               : %Tempo_NAME%
		echo 6. Pitch Correction    : %Pitch_NAME%
		echo 7. Delay               : %SHOWDELAY%
		echo 8. Fix Header          : %HEADER_FIX%
		echo 9. Amplify             : %SHOWAMP%
	)
	if "!ATMOS_OPT!"=="FALSE" (
		echo    Channel Layout      : !C_LAYOUT!
		echo    Mono WAVs Layout    : !MONOWAVSLAYOUT!
		echo 3. Sample Rate         : %SAMPLE_RATE% %SAMPLE_RATE_NAME%
		echo 4. Tempo               : %Tempo_NAME%
		echo 5. Pitch Correction    : %Pitch_NAME%
		echo 6. Delay               : %SHOWDELAY%
		echo 7. Amplify             : %SHOWAMP%
		echo 8. Fix Header          : %HEADER_FIX%
	)
	%GREEN%
	echo.
	echo M. Start Muxing
	echo.
	%YELLOW%
	echo S. Save Settings
	echo D. Default Settings
	echo.
	echo O. Options
	echo.
	%WHITE%
	echo Change Settings and press [M] to start Muxing^!
	if "!ATMOS_OPT!"=="TRUE" (
		CHOICE /C 123456789MSDO /N /M "Select a Letter 1,2,3,4,5,6,7,8,9,[M]ux,[S]ave,[D]efault,[O]ptions"
	) else (
		CHOICE /C 12345678MSDO /N /M "Select a Letter 1,2,3,4,5,6,7,8,[M]ux,[S]ave,[D]efault,[O]ptions"
	)
	if "!ATMOS_OPT!"=="TRUE" (
		if errorlevel 13 (
			set "OPTIONS=YES"
			goto BEGIN
		)

		if errorlevel 12 (
			if exist "%~dp0FS_Audio_Converter_Settings.ini" del "%~dp0FS_Audio_Converter_Settings.ini"
			set "TRACK=2"
			if /i "!SOURCEFILEEXT!"==".mka" set "TRACK=1"
			set "C_Layout=!O_C_Layout!"
			set "DRC=OFF"
			set "codec_out_NAME=FLAC"
			set "Tempo_NAME=ORIGINAL"
			set "Pitch_NAME=NO"
			set "DELAY=0"
			set "Amplify=0"
		)
		if errorlevel 11 (
			echo  FS AUDIO CONVERTER CONFIG File.>"%~dp0FS_Audio_Converter_Settings.ini"
			echo -------------------------------->>"%~dp0FS_Audio_Converter_Settings.ini"
			echo DO NOT MODIFY>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo.>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Stream=!TRACK!>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo DRC=!DRC!>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Codec=%codec_out_NAME%>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Sample Rate=%SAMPLE_RATE%>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Tempo=%Tempo_NAME%>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Pitch Correction=%Pitch_NAME%>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Delay=^%DELAY%>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Amplify=^%AMPLIFY%>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo.
			%GREEN%
			echo Settings Saved^!
			%WAIT% 2000
		)
		if errorlevel 10 goto DOITAVISYNTH
		if errorlevel 9 (
			echo.
			%WHITE%	
			echo Type in Amplify in dB. For Example: 3 for 3dB higher Loudness, or -3 for 3dB lower Loudness
			echo Also you can type DIALNORM to set DialNorm -31 dB, or NORMALIZE to set the loudest Peak 0dB.
			echo.
			set /p "AMPLIFY=Type in Amplify in dB or DIALNORM, NORMALIZE and press [ENTER]:" || SET "AMPLIFY=!AMPLIFY!"
		)	
		if errorlevel 8 (
			if "%HEADER_FIX%"=="NO" set "HEADER_FIX=YES"
			if "%HEADER_FIX%"=="YES" set "HEADER_FIX=NO"
		)
		if errorlevel 7 (
			echo.
			%WHITE%	
			echo Type in your Delay in ms. For Example: 300 for a positive delay, or -300 for a negative Delay
			echo If you use timechange and delay use the Delay for the NEW speed.
			echo Example: 24FPS to 25FPS and Delay = 10 Frames you must set 400ms instead of 417ms.
			echo.
			set /p "DELAY=Type in your Delay and press [ENTER]:" || SET "DELAY=!DELAY!"
		)
		if errorlevel 6 (
			if "%Tempo_NAME%"=="ORIGINAL" (
				if "%Pitch_NAME%"=="NO" set "Pitch_NAME=[Correction] 25.00 to 23.976"
				if "%Pitch_NAME%"=="[Correction] 25.00 to 23.976" set "Pitch_NAME=[Correction] 25.00 to 24.00"
				if "%Pitch_NAME%"=="[Correction] 25.00 to 24.00" set "Pitch_NAME=[Correction] 23.976 to 25.00"
				if "%Pitch_NAME%"=="[Correction] 23.976 to 25.00" set "Pitch_NAME=[Correction] 24.00 to 25.00"
				if "%Pitch_NAME%"=="[Correction] 24.00 to 25.00" set "Pitch_NAME=NO"
			) else (
				if "%Pitch_NAME%"=="YES" set "Pitch_NAME=NO"
				if "%Pitch_NAME%"=="NO" set "Pitch_NAME=YES"
			)
		)
		if errorlevel 5 (
			if "%Tempo_NAME%"=="ORIGINAL" (
				set "Tempo_NAME=[Slowdown] 25.00 to 23.976"
				set "Pitch_NAME=YES"
			)
			if "%Tempo_NAME%"=="[Slowdown] 25.00 to 23.976" (
				set "Tempo_NAME=[Slowdown] 25.00 to 24.00"
				set "Pitch_NAME=YES"
			)
			if "%Tempo_NAME%"=="[Slowdown] 25.00 to 24.00" (
				set "Tempo_NAME=[Slowdown] 24.00 to 23.976"
				set "Pitch_NAME=NO"
			)
			if "%Tempo_NAME%"=="[Slowdown] 24.00 to 23.976" (
				set "Tempo_NAME=[Speed-Up] 23.976 to 24.00"
				set "Pitch_NAME=NO"
			)
			if "%Tempo_NAME%"=="[Speed-Up] 23.976 to 24.00" (
				set "Tempo_NAME=[Speed-Up] 23.976 to 25.00"
				set "Pitch_NAME=YES"
			)
			if "%Tempo_NAME%"=="[Speed-Up] 23.976 to 25.00" (
				set "Tempo_NAME=[Speed-Up] 24.00 to 25.00"
				set "Pitch_NAME=YES"
			)
			if "%Tempo_NAME%"=="[Speed-Up] 24.00 to 25.00" (
				set "Tempo_NAME=ORIGINAL"
				set "Pitch_NAME=NO"
			)
		)
		if errorlevel 4 (
			if "%SAMPLE_RATE%"=="ORIGINAL" set "SAMPLE_RATE=48000"
			if "%SAMPLE_RATE%"=="48000" set "SAMPLE_RATE=44100"
			if "%SAMPLE_RATE%"=="44100" set "SAMPLE_RATE=22050"
			if "%SAMPLE_RATE%"=="22050" set "SAMPLE_RATE=ORIGINAL"
		)
		if errorlevel 3 (
			if "%PCM_10CHANNEL%"=="TRUE" (
				if "%C_LAYOUT%"=="5.1.4 [FL][FR][FC][LFE][SL][SR][TFL][TFR][TBL][TBR]" set "C_LAYOUT=7.1.2 [FL][FR][FC][LFE][SL][SR][BL][BR][TSL][TSR]"
				if "%C_LAYOUT%"=="7.1.2 [FL][FR][FC][LFE][SL][SR][BL][BR][TSL][TSR]" set "C_LAYOUT=5.1.4 [FL][FR][FC][LFE][SL][SR][TFL][TFR][TBL][TBR]"
			) else (
				if "%C_LAYOUT%"=="9.1.6 [FL][FR][FC][LFE][SL][SR][BL][BR][WL][WR][TFL][TFR][TSL][TSR][TBL][TBR]" set "C_LAYOUT=7.1.4 [FL][FR][FC][LFE][SL][SR][BL][BR][TFL][TFR][TBL][TBR]"
				if "%C_LAYOUT%"=="7.1.4 [FL][FR][FC][LFE][SL][SR][BL][BR][TFL][TFR][TBL][TBR]" set "C_LAYOUT=7.1.2 [FL][FR][FC][LFE][SL][SR][BL][BR][TSL][TSR]"
				if "%C_LAYOUT%"=="7.1.2 [FL][FR][FC][LFE][SL][SR][BL][BR][TSL][TSR]" set "C_LAYOUT=5.1.4 [FL][FR][FC][LFE][SL][SR][TFL][TFR][TBL][TBR]"
				if "%C_LAYOUT%"=="5.1.4 [FL][FR][FC][LFE][SL][SR][TFL][TFR][TBL][TBR]" set "C_LAYOUT=5.1.2 [FL][FR][FC][LFE][SL][SR][TSL][TSR]"
				if "%C_LAYOUT%"=="5.1.2 [FL][FR][FC][LFE][SL][SR][TSL][TSR]" set "C_LAYOUT=9.1.6 [FL][FR][FC][LFE][SL][SR][BL][BR][WL][WR][TFL][TFR][TSL][TSR][TBL][TBR]"
			)
		)
	) else (
		if errorlevel 12 (
			set "OPTIONS=YES"
			goto BEGIN
		)

		if errorlevel 11 (
			if exist "%~dp0FS_Audio_Converter_Settings.ini" del "%~dp0FS_Audio_Converter_Settings.ini"
			set "TRACK=2"
			if /i "!SOURCEFILEEXT!"==".mka" set "TRACK=1"
			set "C_Layout=!O_C_Layout!"
			set "DRC=OFF"
			set "codec_out_NAME=FLAC"
			set "Tempo_NAME=ORIGINAL"
			set "Pitch_NAME=NO"
			set "DELAY=0"
			set "Amplify=0"
		)
		if errorlevel 10 (
			echo  FS AUDIO CONVERTER CONFIG File.>"%~dp0FS_Audio_Converter_Settings.ini"
			echo -------------------------------->>"%~dp0FS_Audio_Converter_Settings.ini"
			echo DO NOT MODIFY>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo.>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Stream=!TRACK!>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo DRC=!DRC!>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Codec=%codec_out_NAME%>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Sample Rate=%SAMPLE_RATE%>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Tempo=%Tempo_NAME%>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Pitch Correction=%Pitch_NAME%>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Delay=^%DELAY%>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo Amplify=^%AMPLIFY%>>"%~dp0FS_Audio_Converter_Settings.ini"
			echo.
			%GREEN%
			echo Settings Saved^!
			%WAIT% 2000
		)
		if errorlevel 9 goto DOITAVISYNTH
		if errorlevel 8 (
			if "%HEADER_FIX%"=="NO" set "HEADER_FIX=YES"
			if "%HEADER_FIX%"=="YES" set "HEADER_FIX=NO"
		)		
		if errorlevel 7 (
			echo.
			%WHITE%	
			echo Type in Amplify in dB. For Example: 3 for 3dB higher Loudness, or -3 for 3dB lower Loudness
			echo Also you can type DIALNORM to set DialNorm -31 dB, or NORMALIZE to set the loudest Peak 0dB.
			echo.
			set /p "AMPLIFY=Type in Amplify in dB or DIALNORM, NORMALIZE and press [ENTER]:" || SET "AMPLIFY=!AMPLIFY!"
		)
		if errorlevel 6 (
			echo.
			%WHITE%	
			echo Type in your Delay in ms. For Example: 300 for a positive delay, or -300 for a negative Delay
			echo If you use timechange and delay use the Delay for the NEW speed.
			echo Example: 24FPS to 25FPS and Delay = 10 Frames you must set 400ms instead of 417ms.
			echo.
			set /p "DELAY=Type in your Delay and press [ENTER]:" || SET "DELAY=!DELAY!"
		)
		if errorlevel 5 (
			if "%Tempo_NAME%"=="ORIGINAL" (
				if "%Pitch_NAME%"=="NO" set "Pitch_NAME=[Correction] 25.00 to 23.976"
				if "%Pitch_NAME%"=="[Correction] 25.00 to 23.976" set "Pitch_NAME=[Correction] 25.00 to 24.00"
				if "%Pitch_NAME%"=="[Correction] 25.00 to 24.00" set "Pitch_NAME=[Correction] 23.976 to 25.00"
				if "%Pitch_NAME%"=="[Correction] 23.976 to 25.00" set "Pitch_NAME=[Correction] 24.00 to 25.00"
				if "%Pitch_NAME%"=="[Correction] 24.00 to 25.00" set "Pitch_NAME=NO
			) else (
				if "%Pitch_NAME%"=="YES" set "Pitch_NAME=NO"
				if "%Pitch_NAME%"=="NO" set "Pitch_NAME=YES"
			)
		)
		if errorlevel 4 (
			if "%Tempo_NAME%"=="ORIGINAL" (
				set "Tempo_NAME=[Slowdown] 25.00 to 23.976"
				set "Pitch_NAME=YES"
			)
			if "%Tempo_NAME%"=="[Slowdown] 25.00 to 23.976" (
				set "Tempo_NAME=[Slowdown] 25.00 to 24.00"
				set "Pitch_NAME=YES"
			)
			if "%Tempo_NAME%"=="[Slowdown] 25.00 to 24.00" (
				set "Tempo_NAME=[Slowdown] 24.00 to 23.976"
				set "Pitch_NAME=NO"
			)
			if "%Tempo_NAME%"=="[Slowdown] 24.00 to 23.976" (
				set "Tempo_NAME=[Speed-Up] 23.976 to 24.00"
				set "Pitch_NAME=NO"
			)
			if "%Tempo_NAME%"=="[Speed-Up] 23.976 to 24.00" (
				set "Tempo_NAME=[Speed-Up] 23.976 to 25.00"
				set "Pitch_NAME=YES"
			)
			if "%Tempo_NAME%"=="[Speed-Up] 23.976 to 25.00" (
				set "Tempo_NAME=[Speed-Up] 24.00 to 25.00"
				set "Pitch_NAME=YES"
			)
			if "%Tempo_NAME%"=="[Speed-Up] 24.00 to 25.00" (
				set "Tempo_NAME=ORIGINAL"
				set "Pitch_NAME=NO"
			)
		)
		if errorlevel 3 (
			if "%SAMPLE_RATE%"=="ORIGINAL" set "SAMPLE_RATE=48000"
			if "%SAMPLE_RATE%"=="48000" set "SAMPLE_RATE=44100"
			if "%SAMPLE_RATE%"=="44100" set "SAMPLE_RATE=22050"
			if "%SAMPLE_RATE%"=="22050" set "SAMPLE_RATE=ORIGINAL"
		)
	)
	if errorlevel 2 (
		set "ATMOS_OPT=FALSE"
		if "!ATMOSFILE!"=="TRUE" (
			if "%codec_out_NAME%"=="FLAC" (
				set "ATMOS_OPT=TRUE"
				set "codec_out_NAME=Mono WAVs [ATMOS]"
				set "C_LAYOUT=9.1.6 [FL][FR][FC][LFE][SL][SR][BL][BR][WL][WR][TFL][TFR][TSL][TSR][TBL][TBR]"
			)
			if "%codec_out_NAME%"=="Mono WAVs [ATMOS]" (
				set "ATMOS_OPT=TRUE"
				set codec_out_NAME=LPCM Multichannel [ATMOS]
				set "C_LAYOUT=9.1.6 [FL][FR][FC][LFE][SL][SR][BL][BR][WL][WR][TFL][TFR][TSL][TSR][TBL][TBR]"
			)
			if "%codec_out_NAME%"=="LPCM Multichannel [ATMOS]" set codec_out_NAME=Mono WAVs
		) else (
			if "%codec_out_NAME%"=="FLAC" set "codec_out_NAME=Mono WAVs"
		)
		if "%codec_out_NAME%"=="Mono WAVs" set "codec_out_NAME=LPCM Multichannel"
		if "%codec_out_NAME%"=="LPCM Multichannel" set "codec_out_NAME=AC-3"
		if "%codec_out_NAME%"=="AC-3" set "codec_out_NAME=eAC-3"
		if "%codec_out_NAME%"=="eAC-3" set "codec_out_NAME=AAC"
		if "%codec_out_NAME%"=="AAC" set "codec_out_NAME=FLAC"
	)
	if errorlevel 1 (
		if "%DRC%"=="OFF" set "DRC=ON" 
		if "%DRC%"=="ON" set "DRC=OFF"
	)	
)
goto START

:DOITAVISYNTH
if not exist "!TEMP_FOLDER!" md "!TEMP_FOLDER!"
if /i "!Amplify!"=="DIALNORM" set "REM_DIALNORM=YES"
if not exist "!TARGET_FOLDER!" md "!TARGET_FOLDER!"
set "AVSFILE=!TEMP_FOLDER!\%Password%.avs"
cls
%GREEN%
echo                                                                                               Copyright (c) 2025 TeamQfG
echo.
%WHITE%
echo                                        ====================================
%GREEN%
echo                                                 FS AUDIO CONVERTER
%WHITE%
echo                                        ====================================
echo.
echo.
::TRACK CHECK
if "!TRACKCHECK!"=="FALSE" (
	%RED%
	echo INVALID AUDIO STREAM [!TRACK!]. CHOOSE CORRECT AUDIO STREAM^^!
	%WAIT% 3000
	goto :START
)
%WHITE%
echo SETTINGS:
echo.
%CYAN%
echo    Output Folder:
echo    !TARGET_FOLDER_STRING!
echo.
%WHITE%
echo ENCODING:
echo.

::ENCODER SETTINGS
if "%Tempo_NAME%"=="[Slowdown] 25.00 to 23.976" (
	set "Tempo=95.904"
	set "TIMESTRETCH=YES"
)
if "%Tempo_NAME%"=="[Slowdown] 25.00 to 24.00" (
	set "Tempo=96"
	set "TIMESTRETCH=YES"
)
if "%Tempo_NAME%"=="[Slowdown] 24.00 to 23.976" (
	set "Tempo=99.9"
	set "TIMESTRETCH=YES"
)
if "%Tempo_NAME%"=="[Speed-Up] 23.976 to 24.00" (
	set "Tempo=100.1001"
	set "TIMESTRETCH=YES"
)
if "%Tempo_NAME%"=="[Speed-Up] 23.976 to 25.00" (
	set "Tempo=104.2709"
	set "TIMESTRETCH=YES"
)
if "%Tempo_NAME%"=="[Speed-Up] 24.00 to 25.00" (
	set "Tempo=104.1667"
	set "TIMESTRETCH=YES"
)
if "%Pitch_NAME%"=="[Correction] 25.00 to 23.976" (
	set "Tempo=95.904"
	set "TIMESTRETCH=YES"
)
if "%Pitch_NAME%"=="[Correction] 25.00 to 24.00" (
	set "Tempo=96"
	set "TIMESTRETCH=YES"
)
if "%Pitch_NAME%"=="[Correction] 24.00 to 23.976" (
	set "Tempo=99.9"
	set "TIMESTRETCH=YES"
)
if "%Pitch_NAME%"=="[Correction] 23.976 to 24.00" (
	set "Tempo=100.1001"
	set "TIMESTRETCH=YES"
)
if "%Pitch_NAME%"=="[Correction] 23.976 to 25.00" (
	set "Tempo=104.2709"
	set "TIMESTRETCH=YES"
)
if "%Pitch_NAME%"=="[Correction] 24.00 to 25.00" (
	set "Tempo=104.1667"
	set "TIMESTRETCH=YES"
)

set "FFMPEG_DRC_SCALE="
if "%DRC%"=="OFF" set "FFMPEG_DRC_SCALE=-drc_scale 0 "

set /A "TRACK=%TRACK%-1"
set /A "FTRACK=!TRACK!"
set /A "RTRACK=%TRACK%+1"
if "%CONTTRUE%"=="FALSE" set "TRACK=-1"

if "%Pitch_NAME%"=="YES" set "Pitch=tempo"
if "%Pitch_NAME%"=="NO" set "Pitch=rate"
IF "%Tempo_NAME%"=="ORIGINAL" set "Pitch=pitch"

if "%codec_out_NAME%"=="FLAC" (
	set "codec_out=flac"
	set "codec_ext=flac"
)
if "%codec_out_NAME%"=="Mono WAVs [ATMOS]" (
	set "codec_out=pcm_s!THDBR!le
	set "codec_ext=WAVs"
)
if "%codec_out_NAME%"=="LPCM Multichannel [ATMOS]" (
	set "codec_out=pcm_s!THDBR!le
	set "codec_ext=w64"
	if "%LPCMCont%"=="CAF" set "codec_ext=caf"
)
if "%codec_out_NAME%"=="Mono WAVs" (
	set "codec_out=pcm_s!WAVBR_TEXT!le
	set "codec_ext=WAVs"
)
if "%codec_out_NAME%"=="LPCM Multichannel" (
	set "codec_out=pcm_s!WAVBR_TEXT!le
	set "codec_ext=w64"
	if "%LPCMCont%"=="CAF" set "codec_ext=caf"
)
if "%codec_out_NAME%"=="AC-3" (
	set "codec_out=ac3 -b:a %AC3BR%k"
	set "codec_ext=ac3"
)
if "%codec_out_NAME%"=="eAC-3" (
	set "codec_out=eac3 -b:a %eAC3BR%k"
	set "codec_ext=eac3"
)
if "%codec_out_NAME%"=="AAC" (
	set "codec_out=aac -f mp4 -vbr %AACBR%"
	set "codec_ext=m4a"
)

:: SETTING OUTPUT NAMES
if "!C_LAYOUT!"=="9.1.6 [FL][FR][FC][LFE][SL][SR][BL][BR][WL][WR][TFL][TFR][TSL][TSR][TBL][TBR]" set "ATMOS_CODEC=9.1.6"
if "!C_LAYOUT!"=="7.1.4 [FL][FR][FC][LFE][SL][SR][BL][BR][TFL][TFR][TBL][TBR]" set "ATMOS_CODEC=7.1.4"
if "!C_LAYOUT!"=="7.1.2 [FL][FR][FC][LFE][SL][SR][BL][BR][TSL][TSR]" set "ATMOS_CODEC=7.1.2"
if "!C_LAYOUT!"=="5.1.4 [FL][FR][FC][LFE][SL][SR][TFL][TFR][TBL][TBR]" set "ATMOS_CODEC=5.1.4"
if "!C_LAYOUT!"=="5.1.2 [FL][FR][FC][LFE][SL][SR][TSL][TSR]" set "ATMOS_CODEC=5.1.2"
if "%codec_out_NAME%"=="Mono WAVs [ATMOS]" set "ATMOS_MONOWAV=TRUE"
if "!ATMOS_OPT!"=="TRUE" set "ATMOS_INFO=_[!ATMOS_CODEC!]"
if "%CONTTRUE%"=="TRUE" (
	if "%DELAY%"=="0" (
		if "!SHORTFILENAMES!"=="FALSE" (
			set "OUTPUTFILE=!TARGET_FOLDER!!SOURCEFILENAME!!ATMOS_INFO!_[Track_!RTRACK!]_[Tempo_%Tempo_NAME%]_[Pitched_%Pitch_NAME%]"
		) else (
			set "OUTPUTFILE=!TARGET_FOLDER!!SOURCEFILENAME!_!RTRACK!_NEW"
		)
	) else (
		if "!SHORTFILENAMES!"=="FALSE" (
			set "OUTPUTFILE=!TARGET_FOLDER!!SOURCEFILENAME!!ATMOS_INFO!_[Track_!RTRACK!]_[Tempo_%Tempo_NAME%]_[Pitched_%Pitch_NAME%]_[%SHOWDELAY% DELAYED]"
		) else (
			set "OUTPUTFILE=!TARGET_FOLDER!!SOURCEFILENAME!_!RTRACK!_NEW"
		)
	)
) else (
	if "%DELAY%"=="0" (
		if "!SHORTFILENAMES!"=="FALSE" (
			set "OUTPUTFILE=!TARGET_FOLDER!!SOURCEFILENAME!!ATMOS_INFO!_[Tempo_%Tempo_NAME%]_[Pitched_%Pitch_NAME%]"
		) else (
			set "OUTPUTFILE=!TARGET_FOLDER!!SOURCEFILENAME!_NEW"
		)
	) else (
		if "!SHORTFILENAMES!"=="FALSE" (
			set "OUTPUTFILE=!TARGET_FOLDER!!SOURCEFILENAME!!ATMOS_INFO!_[Tempo_%Tempo_NAME%]_[Pitched_%Pitch_NAME%]_[%SHOWDELAY% DELAYED]"
		) else (
			set "OUTPUTFILE=!TARGET_FOLDER!!SOURCEFILENAME!_NEW"
		)
	)
)

:: FILECOUNTER
if exist "!OUTPUTFILE!.!codec_ext!" (
	call :FILECOUNTER
	set "OUTPUTFILE=!OUTPUTFILE!^(!FILE_COUNTER!^)"
)

:: LOGFILE BEGIN
for /F "Tokens=1,2 Delims=:" %%A IN ('echo %time%') DO set "TimeFile=%%A.%%B">nul
for /F "Tokens=1,2 Delims=:" %%A IN ('echo %time%') DO set "TimeStart=%%A^:%%B">nul
set "DateStart=%DATE%"
if "%LOGFILE%"=="TRUE" (
	echo.>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo =============================================================================================================================================>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo FS Audio Converter Logfile ^(!SOURCEFILENAME!!SOURCEFILEEXT!^)>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo =============================================================================================================================================>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo SCRIPT START DATE / START TIME = %DateStart% / %TimeStart%>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo --------------------------------------------------------------------------------------------------------------------------------------------->>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo =========>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo SETTINGS^:>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo =========>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo Input File : "!SOURCEFILE!">>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo Output File: "!OUTPUTFILE!.!codec_ext!">>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo Temp Folder: "!TEMP_FOLDER!">>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	if "%CONTTRUE%"=="TRUE" (
		echo Stream                 : %RTRACK% >>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo DRC                    : %DRC%>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo Codec                  : %codec_out_NAME%%SHOWBD% [%BITRATE_NAME%]>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo Channel Layout         : !C_LAYOUT!>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo Mono WAVs Layout       : !MONOWAVSLAYOUT!>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo Sample Rate            : %SAMPLE_RATE% %SAMPLE_RATE_NAME%>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo Tempo                  : %Tempo_NAME%>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo Pitch Correction       : %Pitch_NAME%>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo Delay                  : %SHOWDELAY%>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo Amplify                : %SHOWAMP%>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	) else (
		echo DRC                    : %DRC%>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo Codec                  : %codec_out_NAME%%SHOWBD% [%BITRATE_NAME%]>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo Channel Layout         : !C_LAYOUT!>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo Mono WAVs Layout       : !MONOWAVSLAYOUT!>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo Sample Rate            : %SAMPLE_RATE% %SAMPLE_RATE_NAME%>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo Tempo                  : %Tempo_NAME%>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo Pitch Correction       : %Pitch_NAME%>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo Delay                  : %SHOWDELAY%>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo Amplify                : %SHOWAMP%>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	)
	echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
)

if "%HEADER_FIX%"=="YES" call :HEADERFIX
if "!ATMOS_OPT!"=="TRUE" call :GSTREAMER_ATMOS_DECODING

:AVISYNTHSCRIPT
if "!ATMOS_OPT!%REM_DIALNORM%"=="FALSEYES" call :DIALNORM
if "%DRC%"=="OFF" set "DRC_SCALE=drc_scale=0.0, "

%YELLOW%
if "%LOGFILE%"=="TRUE" (
	echo ================>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo AVISYNTH SCRIPT^:>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo ================>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo AVS Script File : "!AVSFILE!">>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
)
echo Creating Avisynth Script
echo # Load Avisynth Filters>"!AVSFILE!"
echo AddAutoloadDir("!TOOLSpath!\AviSynth\plugins")>>"!AVSFILE!"
echo # Source Plugin request: lsmashsource.dll>>"!AVSFILE!"
echo LoadPlugin("!LSMASHpath!")>>"!AVSFILE!"
echo # [Source: LWLibavAudioSource - Stream Index %TRACK%]>>"!AVSFILE!"
if "!THDAC3!"=="TRUE" (
	echo LWLibavAudioSource^("!TEMP_FOLDER!\!SOURCEFILENAME!.thd", %DRC_SCALE%cachefile="!TEMP_FOLDER!\%Password%.lwi", stream_index=%TRACK%^)>>"!AVSFILE!"
) else (
	echo LWLibavAudioSource^("!SOURCEFILE!", %DRC_SCALE%cachefile="!TEMP_FOLDER!\%Password%.lwi", stream_index=%TRACK%^)>>"!AVSFILE!"
)

if "%SAMPLE_RATE%" NEQ "ORIGINAL" call :AVSCRIPT_SAMPLERATE
if "%DELAY%" NEQ "0" call :AVSCRIPT_DELAY
if "%AMPLIFY%" NEQ "0" call :AVSCRIPT_AMPLIFY
if "!TIMESTRETCH!" EQU "YES" call :AVSCRIPT_TIMESTRETCH

if "%LOGFILE%"=="TRUE" (
	for /f "usebackq delims=" %%i in ("!AVSFILE!") do echo %%i>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
)
if exist "!AVSFILE!" (
	if "%LOGFILE%"=="TRUE" (
		echo DONE^^!>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	)
	%GREEN%
	echo DONE^^!
	echo.
) else (
	if "%LOGFILE%"=="TRUE" (
		echo ERROR^^!>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	)
	%RED%
	echo ERROR^^!
	echo.
	goto :EXIT
)

goto :ENCODING

:AVSCRIPT_SAMPLERATE
echo # [DSP: Convert Sample Rate - !SAMPLE_RATE! SAMPLE_RATE_NAME]>>"!AVSFILE!"
echo ConvertAudioToFloat()>>"!AVSFILE!"
echo SSRC(%SAMPLE_RATE%)>>"!AVSFILE!"
goto :eof

:AVSCRIPT_DELAY
echo # [DSP: Apply Delay - !DELAY!ms]>>"!AVSFILE!"
echo DelayAudio(!DELAY!.0/1000.0)>>"!AVSFILE!"
goto :eof

:AVSCRIPT_AMPLIFY
echo # [DSP: Apply Amplify - !SHOWAMP!]>>"!AVSFILE!"
if /i "!AMPLIFY!"=="NORMALIZE" (
	echo Normalize^(0.9^)>>"!AVSFILE!"
) else (
	echo AmplifyDB^(!AMPLIFY!^)>>"!AVSFILE!"
)
goto :eof

:AVSCRIPT_TIMESTRETCH
echo # [DSP: TimeStretch - %Tempo_NAME%]>>"!AVSFILE!"
echo ConvertAudioToFloat()>>"!AVSFILE!"
echo TimeStretch(!Pitch!=!Tempo!)>>"!AVSFILE!"
goto :eof

:ENCODING
if not exist "!TARGET_FOLDER!" md "!TARGET_FOLDER!"
if "%Pitch_NAME%"=="NO" set "Pitch_NAME=ORIGINAL"
if "%Pitch_NAME%"=="YES" set "Pitch_NAME=CORRECTED"
if "%codec_out_NAME%"=="Mono WAVs" call :MONOWAVs
if "%codec_out_NAME%"=="Mono WAVs [ATMOS]" call :MONOWAVs
%YELLOW%
if "%LOGFILE%"=="TRUE" (
	echo =========>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo ENCODING^:>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo =========>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
)
if "%THDAC3%"=="TRUE" (
	echo Demuxing TrueHD Stream. Please Wait ...
	"!eac3topath!" "!SOURCEFILE!" "!TEMP_FOLDER!\!SOURCEFILENAME!.thd"
	echo.
		if "%LOGFILE%"=="TRUE" (
		echo Demuxing Line: "!eac3topath!" "!SOURCEFILE!" "!TEMP_FOLDER!\!SOURCEFILENAME!.thd">>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	)
)
	
echo Encoding. Please Wait ...
if "%LOGFILE%"=="TRUE" (
	echo Encoding Line: "!FFMPEGpath!" -y !FFMPEG_DRC_SCALE!-i "!AVSFILE!" -strict experimental -loglevel quiet -stats!PAN! -c:a !codec_out! -strict -2 "!OUTPUTFILE!.!codec_ext!" >>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
)
"!FFMPEGpath!" -y !FFMPEG_DRC_SCALE!-i "!AVSFILE!" -strict experimental -loglevel quiet -stats!PAN! -c:a !codec_out! -strict -2 "!OUTPUTFILE!.!codec_ext!"
if "%ERRORLEVEL%"=="0" (
	%GREEN%
	echo DONE^^!
	if "%LOGFILE%"=="TRUE" (
		echo DONE^^!>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	)
	echo.
) else (
	%RED%
	echo ERROR^^!
	if "%LOGFILE%"=="TRUE" (
		echo ERROR^^!>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	)
	echo.
)

:EXIT
%WHITE%
echo EXITING:
echo.
%YELLOW%
echo Cleaning Temp Files. Please Wait ...
RD /S /Q "!TEMP_FOLDER!">nul
if exist "!TOOLSpath!\log.txt" del "!TOOLSpath!\log.txt"
%GREEN%
echo DONE^^!
for /F "Tokens=1,2 Delims=:" %%A IN ('echo %time%') DO set "TimeEnd=%%A^:%%B">nul
set "DateEnd=%DATE%"
if "%LOGFILE%"=="TRUE" (
	echo --------------------------------------------------------------------------------------------------------------------------------------------->>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo SCRIPT END DATE / END TIME = %DateEnd% / %TimeEnd%>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo --------------------------------------------------------------------------------------------------------------------------------------------->>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo --- LOGFILE END --->>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
)
setlocal DisableDelayedExpansion
ENDLOCAL
%WHITE%
TIMEOUT 30
exit

:GSTREAMER_ATMOS_DECODING
set "WAV_WRONG_HEADER=FALSE"
if "!ATMOSTYPE!"=="DDP" (
	set "ATMOSTYPE_NAME=Dolby Digital Plus with Atmos"
	set "ATMOSTYPE_EXT=eac3"
)
if "!ATMOSTYPE!"=="THD" (
	set "ATMOSTYPE_NAME=Dolby TrueHD with Atmos"
	set "ATMOSTYPE_EXT=thd"
)
if "!ATMOSTYPE!"=="PCM" (
	set "ATMOSTYPE_NAME=Atmos Multichannel WAV"
	set "ATMOSTYPE_EXT=w64"
)
set "OUTPUTTRACKSTRING"=""

if "%THDAC3%"=="TRUE" (
	%YELLOW%
	echo Demuxing TrueHD Stream. Please Wait ...
	"!eac3topath!" "!SOURCEFILE!" "!TEMP_FOLDER!\!SOURCEFILENAME!.thd"
	echo.
		if "%LOGFILE%"=="TRUE" (
		echo Demuxing Line: "!eac3topath!" "!SOURCEFILE!" "!TEMP_FOLDER!\!SOURCEFILENAME!.thd">>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		set "SOURCEFILE=!TEMP_FOLDER!\!SOURCEFILENAME!.thd"
	)
)

if "!CONTTRUE!"=="TRUE" (
	set "OUTPUTTRACKSTRING="_[Track_!RTRACK!]"
	%YELLOW%
	echo Demuxing !ATMOSTYPE_NAME! from container ...
	if "%LOGFILE%"=="TRUE" (
		echo ==============================>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo DEMUXING Atmos from Container^:>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo ==============================>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo Encoding Line: "!FFMPEGpath!" -y -i "!SOURCEFILE!" -strict experimental -loglevel quiet -stats -map 0:!FTRACK! -c copy -strict -2 "!TEMP_FOLDER!\%Password%.!ATMOSTYPE_EXT!">>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	)
	"!FFMPEGpath!" -y -i "!SOURCEFILE!" -strict experimental -loglevel quiet -stats -map 0:!FTRACK! -c copy -strict -2 "!TEMP_FOLDER!\%Password%.!ATMOSTYPE_EXT!"
	if "%ERRORLEVEL%"=="0" (
		%GREEN%
		if "%LOGFILE%"=="TRUE" (
			echo DONE^^!>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
			echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		)
		echo DONE^^!
		%YELLOW%
		set "SOURCEFILE=!TEMP_FOLDER!\%Password%.!ATMOSTYPE_EXT!"
		set "CONTTRUE=FALSE"
		echo.
	) else (
		%RED%
		if "%LOGFILE%"=="TRUE" (
			echo ERROR^^!>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
			echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		)
		echo ERROR^^!
		echo.
		goto :EXIT
	)
)

if "%REM_DIALNORM%"=="YES" call :DIALNORM

set "SOURCEFILE_ORIG=!SOURCEFILE!"
set "TARGET_FOLDER_ORIG=!TARGET_FOLDER!"
set "TEMP_FOLDER_ORIG=!TEMP_FOLDER!"
set "SOURCEFILE=!SOURCEFILE:\=\\!"
set "TARGET_FOLDER=!TARGET_FOLDER:\=\\!"
set "TEMP_FOLDER=!TEMP_FOLDER:\=\\!"

:: TRUEHD
if "!ATMOSTYPE!"=="THD" (
	%YELLOW%
	echo Demuxing !ATMOSTYPE_NAME! [!ATMOS_CODEC!] to WAV ...
	if "%LOGFILE%"=="TRUE" (
		echo ===================================>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo ENCODING Dolby TrueHD ATMOS TO WAV^:>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo ===================================>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo Encoding Line: "!DRP_FOLDER!\gst-launch-1.0.exe" -q --gst-plugin-path "!DRP_FOLDER!\gst-plugins" filesrc location="!SOURCEFILE!" ^^! dlbtruehdparse align-major-sync=false ^^! dlbaudiodecbin truehddec-presentation=16 out-ch-config=!ATMOS_CODEC! ^^! audio/x-raw, format=S32LE ^^! wavenc ^^! filesink location="!TEMP_FOLDER!\\%Password%.wav">>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	)
	"!DRP_FOLDER!\gst-launch-1.0.exe" -q --gst-plugin-path "!DRP_FOLDER!\gst-plugins" filesrc location="!SOURCEFILE!" ^^! dlbtruehdparse align-major-sync=false ^^! dlbaudiodecbin truehddec-presentation=16 out-ch-config=!ATMOS_CODEC! ^^! audio/x-raw, format=S32LE ^^! wavenc ^^! filesink location="!TEMP_FOLDER!\\%Password%.wav"
	if "%ERRORLEVEL%"=="0" (
		%GREEN%
		if "%LOGFILE%"=="TRUE" (
			echo DONE^^!>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
			echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		)
		echo.
		echo DONE^^!
		set "SOURCEFILE=!TEMP_FOLDER_ORIG!\%Password%.wav"
		set "WAV_WRONG_HEADER=TRUE"
		echo.
	) else (
		%RED%
		if "%LOGFILE%"=="TRUE" (
			echo ERROR^^!>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
			echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		)
		echo.
		echo ERROR^^!
		echo.
		goto :EXIT
	)
)


:: EAC3
if "!ATMOSTYPE!"=="DDP" (
	%YELLOW%
	echo Demuxing !ATMOSTYPE_NAME! [!ATMOS_CODEC!] to WAV ...
	if "%LOGFILE%"=="TRUE" (
		echo =========================================>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo ENCODING Dolby Digital Plus ATMOS TO WAV^:>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo =========================================>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo Encoding Line: "!DRP_FOLDER!\gst-launch-1.0.exe" -q --gst-plugin-path "!DRP_FOLDER!\gst-plugins" filesrc location="!SOURCEFILE!" ^^! dlbac3parse ^^! dlbaudiodecbin ac3dec-drc-boost=0 ac3dec-drc-cut=0 ac3dec-drop-delay=true ac3dec-drc-suppress=true out-ch-config=!ATMOS_CODEC! ^^! audio/x-raw, format=S32LE ^^! wavenc ^^! filesink location="!TEMP_FOLDER!\\%Password%.wav">>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	)
	"!DRP_FOLDER!\gst-launch-1.0.exe" -q --gst-plugin-path "!DRP_FOLDER!\gst-plugins" filesrc location="!SOURCEFILE!" ^^! dlbac3parse ^^! dlbaudiodecbin ac3dec-drop-delay=true ac3dec-drc-suppress=true out-ch-config=!ATMOS_CODEC! ^^! audio/x-raw, format=S32LE ^^! wavenc ^^! filesink location="!TEMP_FOLDER!\\%Password%.wav"
	if "%ERRORLEVEL%"=="0" (
		%GREEN%
		if "%LOGFILE%"=="TRUE" (
			echo DONE^^!>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
			echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		)
		echo.
		echo DONE^^!
		set "SOURCEFILE=!TEMP_FOLDER_ORIG!\%Password%.wav"
		set "WAV_WRONG_HEADER=TRUE"
		echo.
	) else (
		%RED%
		if "%LOGFILE%"=="TRUE" (
			echo ERROR^^!>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
			echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		)
		echo.
		echo ERROR^^!
		echo.
		goto :EXIT
	)
)

set "TARGET_FOLDER=!TARGET_FOLDER_ORIG!"
set "TEMP_FOLDER=!TEMP_FOLDER_ORIG!"
if "!ATMOS_MONOWAV!%SAMPLE_RATE%%DELAY%%AMPLIFY%!TIMESTRETCH!"=="TRUEORIGINAL00NO" call :MONOWAVs

:GSTREAMER_ATMOS_DECODING_FINALISING
set "OUTPUTFILE_G="

if "!ATMOSTYPE!!ATMOS_OPT!"=="PCMTRUE" goto :eof

set "OUTPUTFILE_G=!TEMP_FOLDER!\%Password%_[!ATMOS_CODEC!].w64"
if "%SAMPLE_RATE%%DELAY%%AMPLIFY%!TIMESTRETCH!"=="ORIGINAL00NO" set "OUTPUTFILE_G=!OUTPUTFILE!.!codec_ext!"

%YELLOW%
if "%SAMPLE_RATE%%DELAY%%AMPLIFY%!TIMESTRETCH!"=="ORIGINAL00NO" (
	echo Finalising !C_LAYOUT! !THDBR!-Bit %LPCMCont% file ...
) else (
	echo Finalising !C_LAYOUT! !THDBR!-Bit WAV file ...
)

if "%LOGFILE%"=="TRUE" (
	echo ============================>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo FINALISING Atmos Encoding^:>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo ============================>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo Encoding Line: "!FFMPEGpath!" -ignore_length true -y -i "!SOURCEFILE!" -strict experimental -loglevel error -stats!PAN! -c:a pcm_s!THDBR!le "!OUTPUTFILE_G!">>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
)
"!FFMPEGpath!" -ignore_length true -y -i "!SOURCEFILE!" -strict experimental -loglevel error -stats!PAN! -c:a pcm_s!THDBR!le "!OUTPUTFILE_G!"
if "%ERRORLEVEL%"=="0" (
	%GREEN%
	echo DONE^^!
	if "%LOGFILE%"=="TRUE" (
		echo DONE^^!>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	)
	if exist "!TEMP_FOLDER!\%Password%.wav" del "!TEMP_FOLDER!\%Password%.wav"
	set "SOURCEFILE=!OUTPUTFILE_G!"
	set "TRACK=-1"
) else (
	%RED%
	if "%LOGFILE%"=="TRUE" (
		echo ERROR^^!>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	)
	echo ERROR^^!
	echo.
	goto :EXIT
)

echo.
if "%SAMPLE_RATE%%DELAY%%AMPLIFY%!TIMESTRETCH!"=="ORIGINAL00NO" goto :EXIT
goto :eof

:MONOWAVs
%YELLOW%
set "ENCODING_LINE=UNKNOWN CHANNEL LAYOUT"
set "WAV_HEADER_FIX="
if "%LOGFILE%"=="TRUE" (
	echo =====================>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo MONO WAVs Encoding^:>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo =====================>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
)

if "!ATMOS_MONOWAV!%SAMPLE_RATE%%DELAY%%AMPLIFY%!TIMESTRETCH!"=="TRUEORIGINAL00NO" (
	if "!WAV_WRONG_HEADER!"=="TRUE" set "WAV_HEADER_FIX=-ignore_length true "
	if "!SOURCEFILE!"=="!SOURCEFILE_ORIG!" set "SOURCEFILE=!SOURCEFILE_ORIG!"
	set "AVSFILE=!SOURCEFILE!"
)

if "!ATMOS_MONOWAV!"=="TRUE" (
	echo Encoding !C_LAYOUT! to !THDBR!-Bit MONO WAVs ...
) else (
	echo Encoding !C_LAYOUT! to !WAVBR_TEXT!-Bit MONO WAVs ...
)
for /f "tokens=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16 delims=," %%A in ("!ALAYOUT_NAMES!") do set "FL_NAME=%%A" & set "FR_NAME=%%B" & set "FC_NAME=%%C" & set "LFE_NAME=%%D" & set "SL_NAME=%%E" & set "SR_NAME=%%F" & set "BL_NAME=%%G" & set "BR_NAME=%%H" & set "WL_NAME=%%I" & set "WR_NAME=%%J" & set "TFL_NAME=%%K" & set "TFR_NAME=%%L" & set "TSL_NAME=%%M" & set "TSR_NAME=%%N" & set "TBL_NAME=%%O" & set "TBR_NAME=%%P"
set A_NAMESET=^[!FL_NAME!^]^[!FR_NAME!^]^[!FC_NAME!^]^[!LFE_NAME!^]^[!SL_NAME!^]^[!SR_NAME!^]^[!BL_NAME!^]^[!BR_NAME!^]^[!WL_NAME!^]^[!WR_NAME!^]^[!TFL_NAME!^]^[!TFR_NAME!^]^[!TSL_NAME!^]^[!TSR_NAME!^]^[!TBL_NAME!^]^[!TBR_NAME!^]
if "!C_LAYOUT!"=="9.1.6 [FL][FR][FC][LFE][SL][SR][BL][BR][WL][WR][TFL][TFR][TSL][TSR][TBL][TBR]" set "ENCODING_LINE="[0:a]channelmap=0[FL];[0:a]channelmap=1[FR];[0:a]channelmap=2[FC];[0:a]channelmap=3[LFE];[0:a]channelmap=4[SL];[0:a]channelmap=5[SR];[0:a]channelmap=6[BL];[0:a]channelmap=7[BR];[0:a]channelmap=8[WL];[0:a]channelmap=9[WR];[0:a]channelmap=10[TFL];[0:a]channelmap=11[TFR];[0:a]channelmap=12[TSL];[0:a]channelmap=13[TSR];[0:a]channelmap=14[TBL];[0:a]channelmap=15[TBR]" -map "[FL]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!FL_NAME!.wav" -map "[FR]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!FR_NAME!.wav" -map "[FC]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!FC_NAME!.wav" -map "[LFE]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!LFE_NAME!.wav" -map "[SL]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!SL_NAME!.wav" -map "[SR]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!SR_NAME!.wav" -map "[BL]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!BL_NAME!.wav" -map "[BR]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!BR_NAME!.wav" -map "[WL]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!WL_NAME!.wav" -map "[WR]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!WR_NAME!.wav" -map "[TFL]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!TFL_NAME!.wav" -map "[TFR]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!TFR_NAME!.wav" -map "[TSL]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!TSL_NAME!.wav" -map "[TSR]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!TSR_NAME!.wav" -map "[TBL]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!TBL_NAME!.wav" -map "[TBR]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!TBR_NAME!.wav""
if "!C_LAYOUT!"=="7.1.4 [FL][FR][FC][LFE][SL][SR][BL][BR][TFL][TFR][TBL][TBR]" set "ENCODING_LINE="[0:a]channelmap=0[FL];[0:a]channelmap=1[FR];[0:a]channelmap=2[FC];[0:a]channelmap=3[LFE];[0:a]channelmap=4[SL];[0:a]channelmap=5[SR];[0:a]channelmap=6[BL];[0:a]channelmap=7[BR];[0:a]channelmap=8[TFL];[0:a]channelmap=9[TFR];[0:a]channelmap=10[TBL];[0:a]channelmap=11[TBR]" -map "[FL]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!FL_NAME!.wav" -map "[FR]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!FR_NAME!.wav" -map "[FC]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!FC_NAME!.wav" -map "[LFE]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!LFE_NAME!.wav" -map "[SL]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!SL_NAME!.wav" -map "[SR]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!SR_NAME!.wav" -map "[BL]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!BL_NAME!.wav" -map "[BR]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!BR_NAME!.wav" -map "[TFL]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!TFL_NAME!.wav" -map "[TFR]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!TFR_NAME!.wav" -map "[TBL]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!TBL_NAME!.wav" -map "[TBR]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!TBR_NAME!.wav""
if "!C_LAYOUT!"=="7.1.2 [FL][FR][FC][LFE][SL][SR][BL][BR][TSL][TSR]" set "ENCODING_LINE="[0:a]channelmap=0[FL];[0:a]channelmap=1[FR];[0:a]channelmap=2[FC];[0:a]channelmap=3[LFE];[0:a]channelmap=4[SL];[0:a]channelmap=5[SR];[0:a]channelmap=6[BL];[0:a]channelmap=7[BR];[0:a]channelmap=8[TSL];[0:a]channelmap=9[TSR]" -map "[FL]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!FL_NAME!.wav" -map "[FR]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!FR_NAME!.wav" -map "[FC]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!FC_NAME!.wav" -map "[LFE]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!LFE_NAME!.wav" -map "[SL]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!SL_NAME!.wav" -map "[SR]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!SR_NAME!.wav" -map "[BL]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!BL_NAME!.wav" -map "[BR]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!BR_NAME!.wav" -map "[TSL]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!TSL_NAME!.wav" -map "[TSR]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!TSR_NAME!.wav""
if "!C_LAYOUT!"=="5.1.4 [FL][FR][FC][LFE][SL][SR][TFL][TFR][TBL][TBR]" set "ENCODING_LINE="[0:a]channelmap=0[FL];[0:a]channelmap=1[FR];[0:a]channelmap=2[FC];[0:a]channelmap=3[LFE];[0:a]channelmap=4[SL];[0:a]channelmap=5[SR];[0:a]channelmap=6[TFL];[0:a]channelmap=7[TFR];[0:a]channelmap=8[TBL];[0:a]channelmap=9[TBR]" -map "[FL]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!FL_NAME!.wav" -map "[FR]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!FR_NAME!.wav" -map "[FC]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!FC_NAME!.wav" -map "[LFE]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!LFE_NAME!.wav" -map "[SL]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!SL_NAME!.wav" -map "[SR]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!SR_NAME!.wav" -map "[TFL]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!TFL_NAME!.wav" -map "[TFR]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!TFR_NAME!.wav" -map "[TBL]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!TBL_NAME!.wav" -map "[TBR]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!TBR_NAME!.wav""
if "!C_LAYOUT!"=="5.1.2 [FL][FR][FC][LFE][SL][SR][TSL][TSR]" set "ENCODING_LINE="[0:a]channelmap=0[FL];[0:a]channelmap=1[FR];[0:a]channelmap=2[FC];[0:a]channelmap=3[LFE];[0:a]channelmap=4[SL];[0:a]channelmap=5[SR];[0:a]channelmap=6[TSL];[0:a]channelmap=7[TSR]" -map "[FL]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!FL_NAME!.wav" -map "[FR]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!FR_NAME!.wav" -map "[FC]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!FC_NAME!.wav" -map "[LFE]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!LFE_NAME!.wav" -map "[SL]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!SL_NAME!.wav" -map "[SR]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!SR_NAME!.wav" -map "[TSL]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!TSL_NAME!.wav" -map "[TSR]" -c:a pcm_s!THDBR!le "!OUTPUTFILE!.!TSR_NAME!.wav""
if "!C_LAYOUT!"=="Mono [FC]" set "ENCODING_LINE="[0:a]channelmap=0[FC]" -map "[FC]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.C.wav""
if "!C_LAYOUT!"=="Stereo [FL][FR]" set "ENCODING_LINE="[0:a]channelmap=0[FL];[0:a]channelmap=1[FR]" -map "[FL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.L.wav" -map "[FR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.R.wav""
if "!C_LAYOUT!"=="2.1 [FL][FR][LFE]" set "ENCODING_LINE="[0:a]channelmap=0[FL];[0:a]channelmap=1[FR];[0:a]channelmap=2[LFE]" -map "[FL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.L.wav" -map "[FR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.R.wav" -map "[LFE]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.LFE.wav""
if "!C_LAYOUT!"=="3.0 [FL][FR][FC]" set "ENCODING_LINE="[0:a]channelmap=0[FL];[0:a]channelmap=1[FR];[0:a]channelmap=2[FC]" -map "[FL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.L.wav" -map "[FR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.R.wav" -map "[FC]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.C.wav""
if "!C_LAYOUT!"=="3.1 [FL][FR][FC][LFE]" set "ENCODING_LINE="[0:a]channelmap=0[FL];[0:a]channelmap=1[FR];[0:a]channelmap=2[FC];[0:a]channelmap=3[LFE]" -map "[FL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.L.wav" -map "[FR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.R.wav" -map "[FC]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.C.wav" -map "[LFE]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.LFE.wav""
if "!C_LAYOUT!"=="3.1 [FL][FR][FC][BC]" (
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "BC_EXT=Cs"
	set "ENCODING_LINE="[0:a]channelmap=0[FL];[0:a]channelmap=1[FR];[0:a]channelmap=2[FC];[0:a]channelmap=3[BC]" -map "[FL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.L.wav" -map "[FR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.R.wav" -map "[FC]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.C.wav" -map "[BC]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!BC_EXT!.wav""
)
if "!C_LAYOUT!"=="4.0 [UNKNOWN]" (
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "BL_EXT=Ls"
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "BR_EXT=Rs"
	set "ENCODING_LINE="[0:a]channelmap=0[FL];[0:a]channelmap=1[FR];[0:a]channelmap=2[BL];[0:a]channelmap=3[BR]" -map "[FL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.L.wav" -map "[FR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.R.wav" -map "[BL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!BL_EXT!.wav" -map "[BR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!BR_EXT!.wav""
)
if "!C_LAYOUT!"=="4.0 (Quad) [FL][FR][BL][BR]" (
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "BL_EXT=Ls"
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "BR_EXT=Rs"
	set "ENCODING_LINE="[0:a]channelmap=0[FL];[0:a]channelmap=1[FR];[0:a]channelmap=2[BL];[0:a]channelmap=3[BR]" -map "[FL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.L.wav" -map "[FR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.R.wav" -map "[BL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!BL_EXT!.wav" -map "[BR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!BR_EXT!.wav""
)
if "!C_LAYOUT!"=="4.0 [FL][FR][FC][BC]" (
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "BC_EXT=Cs"
	set "ENCODING_LINE="[0:a]channelmap=0[FL];[0:a]channelmap=1[FR];[0:a]channelmap=2[FC];[0:a]channelmap=3[BC]" -map "[FL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.L.wav" -map "[FR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.R.wav" -map "[FC]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.C.wav" -map "[BC]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!BC_EXT!.wav""
)
if "!C_LAYOUT!"=="4.1 (Quad) [FL][FR][LFE][SL][SR]" (
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "SL_EXT=Ls"
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "SR_EXT=Rs"
	set "ENCODING_LINE="[0:a]channelmap=0[FL];[0:a]channelmap=1[FR];[0:a]channelmap=2[LFE];[0:a]channelmap=3[SL];[0:a]channelmap=4[SR]" -map "[FL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.L.wav" -map "[FR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.R.wav" -map "[LFE]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.LFE.wav" -map "[SL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!SL_EXT!.wav" -map "[SR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!SR_EXT!.wav""
)
if "!C_LAYOUT!"=="4.1 [FL][FR][FC][LFE][BC]" (
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "BC_EXT=Cs"
	set "ENCODING_LINE="[0:a]channelmap=0[FL];[0:a]channelmap=1[FR];[0:a]channelmap=2[FC];[0:a]channelmap=3[LFE];[0:a]channelmap=4[BC]" -map "[FL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.L.wav" -map "[FR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.R.wav" -map "[FC]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.C.wav" -map "[LFE]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.LFE.wav" -map "[BC]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!BC_EXT!.wav""
)
if "!C_LAYOUT!"=="5.0 [FL][FR][FC][LS][RS]" (
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "SL_EXT=Ls"
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "SR_EXT=Rs"
	set "ENCODING_LINE="[0:a]channelmap=0[FL];[0:a]channelmap=1[FR];[0:a]channelmap=2[FC];[0:a]channelmap=3[SL];[0:a]channelmap=4[SR]" -map "[FL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.L.wav" -map "[FR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.R.wav" -map "[FC]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.C.wav" -map "[SL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!SL_EXT!.wav" -map "[SR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!SR_EXT!.wav""
)
if "!C_LAYOUT!"=="5.1 [FL][FR][FC][LFE][LS][RS]" (
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "SL_EXT=Ls"
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "SR_EXT=Rs"
	set "ENCODING_LINE="[0:a]channelmap=0[FL];[0:a]channelmap=1[FR];[0:a]channelmap=2[FC];[0:a]channelmap=3[LFE];[0:a]channelmap=4[SL];[0:a]channelmap=5[SR]" -map "[FL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.L.wav" -map "[FR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.R.wav" -map "[FC]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.C.wav" -map "[LFE]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.LFE.wav" -map "[SL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!SL_EXT!.wav" -map "[SR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!SR_EXT!.wav""
)
if "!C_LAYOUT!"=="6.0 [FL][FR][FC][BC][LS][RS]" (
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "BC_EXT=Cs"
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "SL_EXT=Ls"
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "SR_EXT=Rs"
	set "ENCODING_LINE="[0:a]channelmap=0[FL];[0:a]channelmap=1[FR];[0:a]channelmap=2[FC];[0:a]channelmap=3[BC];[0:a]channelmap=4[SL];[0:a]channelmap=5[SR]" -map "[FL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.L.wav" -map "[FR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.R.wav" -map "[FC]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.C.wav" -map "[BC]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!BC_EXT!.wav" -map "[SL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!SL_EXT!.wav" -map "[SR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!SR_EXT!.wav""
)
if "!C_LAYOUT!"=="6.0 (Matrix) [FL][FR][FC][(BC)][LS][RS]" (
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "SL_EXT=Ls"
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "SR_EXT=Rs"
	set "ENCODING_LINE="[0:a]channelmap=0[FL];[0:a]channelmap=1[FR];[0:a]channelmap=2[FC];[0:a]channelmap=3[SL];[0:a]channelmap=4[SR]" -map "[FL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.L.wav" -map "[FR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.R.wav" -map "[FC]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.C.wav" -map "[SL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!SL_EXT!.wav" -map "[SR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!SR_EXT!.wav""
)
if "!C_LAYOUT!"=="6.0 (Discrete) [FL][FR][FC][BC][LS][RS]" (
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "BC_EXT=Cs"
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "SL_EXT=Ls"
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "SR_EXT=Rs"
	set "ENCODING_LINE="[0:a]channelmap=0[FL];[0:a]channelmap=1[FR];[0:a]channelmap=2[FC];[0:a]channelmap=3[BC];[0:a]channelmap=4[SL];[0:a]channelmap=5[SR]" -map "[FL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.L.wav" -map "[FR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.R.wav" -map "[FC]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.C.wav" -map "[BC]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!BC_EXT!.wav" -map "[SL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!SL_EXT!.wav" -map "[SR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!SR_EXT!.wav""
)
if "!C_LAYOUT!"=="6.1 (Matrix) [FL][FR][FC][LFE][(BC)][LS][RS]" (
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "SL_EXT=Ls"
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "SR_EXT=Rs"
	set "ENCODING_LINE="[0:a]channelmap=0[FL];[0:a]channelmap=1[FR];[0:a]channelmap=2[FC];[0:a]channelmap=3[LFE];[0:a]channelmap=4[SL];[0:a]channelmap=5[SR]" -map "[FL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.L.wav" -map "[FR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.R.wav" -map "[FC]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.C.wav" -map "[LFE]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.LFE.wav" -map "[SL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!SL_EXT!.wav" -map "[SR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!SR_EXT!.wav""
)
if "!C_LAYOUT!"=="6.1 (Discrete) [FL][FR][FC][LFE][BC][LS][RS]" (
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "BC_EXT=Cs"
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "SL_EXT=Ls"
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "SR_EXT=Rs"
	set "ENCODING_LINE="[0:a]channelmap=0[FL];[0:a]channelmap=1[FR];[0:a]channelmap=2[FC];[0:a]channelmap=3[LFE];[0:a]channelmap=4[BC];[0:a]channelmap=5[SL];[0:a]channelmap=6[SR]" -map "[FL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.L.wav" -map "[FR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.R.wav" -map "[FC]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.C.wav" -map "[LFE]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.LFE.wav" -map "[BC]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!BC_EXT!.wav" -map "[SL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!SL_EXT!.wav" -map "[SR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!SR_EXT!.wav""
)
if "!C_LAYOUT!"=="6.1 [FL][FR][FC][LFE][BC][LS][RS]" (
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "BC_EXT=Cs"
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "SL_EXT=Ls"
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "SR_EXT=Rs"
	set "ENCODING_LINE="[0:a]channelmap=0[FL];[0:a]channelmap=1[FR];[0:a]channelmap=2[FC];[0:a]channelmap=3[LFE];[0:a]channelmap=4[BC];[0:a]channelmap=5[SL];[0:a]channelmap=6[SR]" -map "[FL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.L.wav" -map "[FR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.R.wav" -map "[FC]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.C.wav" -map "[LFE]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.LFE.wav" -map "[BC]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!BC_EXT!.wav" -map "[SL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!SL_EXT!.wav" -map "[SR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!SR_EXT!.wav""
)
if "!C_LAYOUT!"=="7.1 [FL][FR][FC][LFE][BL][BR][SL][SR]" (
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "BL_EXT=Lsr"
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "BR_EXT=Rsr"
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "SL_EXT=Lss"
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "SR_EXT=Rss"
	set "ENCODING_LINE="[0:a]channelmap=0[FL];[0:a]channelmap=1[FR];[0:a]channelmap=2[FC];[0:a]channelmap=3[LFE];[0:a]channelmap=4[BL];[0:a]channelmap=5[BR];[0:a]channelmap=6[SL];[0:a]channelmap=7[SR]" -map "[FL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.L.wav" -map "[FR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.R.wav" -map "[FC]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.C.wav" -map "[LFE]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.LFE.wav" -map "[BL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!BL_EXT!.wav" -map "[BR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!BR_EXT!.wav" -map "[SL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!SL_EXT!.wav" -map "[SR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!SR_EXT!.wav""
)
if "!C_LAYOUT!"=="7.1 (Strange) [FL][FR][FC][LFE][LSR][RSR][LS][RS]" (
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "BL_EXT=Lsr"
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "BR_EXT=Rsr"
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "SL_EXT=Ls"
	if "!MONOWAVSLAYOUT!"=="DTS-HD Master Audio Suite" set "SR_EXT=Rs"
	set "ENCODING_LINE="[0:a]channelmap=0[FL];[0:a]channelmap=1[FR];[0:a]channelmap=2[FC];[0:a]channelmap=3[LFE];[0:a]channelmap=4[LSR];[0:a]channelmap=5[RSR];[0:a]channelmap=6[SL];[0:a]channelmap=7[SR]" -map "[FL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.L.wav" -map "[FR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.R.wav" -map "[FC]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.C.wav" -map "[LFE]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.LFE.wav" -map "[LSR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!BL_EXT!.wav" -map "[RSR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!BR_EXT!.wav" -map "[SL]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!SL_EXT!.wav" -map "[SR]" -c:a pcm_s!WAVBR_TEXT!le "!OUTPUTFILE!.!SR_EXT!.wav""
)

if "%LOGFILE%"=="TRUE" (
	echo Encoding Line: "!FFMPEGpath!" !WAV_HEADER_FIX!-y !FFMPEG_DRC_SCALE!-i "!AVSFILE!" -strict experimental -loglevel error -stats -filter_complex !ENCODING_LINE! >>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
)
"!FFMPEGpath!" !WAV_HEADER_FIX!-y !FFMPEG_DRC_SCALE!-i "!AVSFILE!" -strict experimental -loglevel error -stats -filter_complex !ENCODING_LINE!
if "%ERRORLEVEL%"=="0" (
	%GREEN%
	if "%LOGFILE%"=="TRUE" (
		echo DONE^^!>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	)
	echo DONE^^!
	echo.
) else (
	%RED%
	if "%LOGFILE%"=="TRUE" (
		echo ERROR^^!>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	)
	echo ERROR^^!
	echo.
)

goto :EXIT

:PCM_CHANNEL_10
set "C_LAYOUT=5.1.4 [FL][FR][FC][LFE][SL][SR][TFL][TFR][TBL][TBR]"
set "PCM_10CHANNEL=TRUE"
goto :eof

:DIALNORM
%YELLOW%
set "ATMOS_DIALNORM=UNKNOWN"
set "AMPLIFY=0"

if "%LOGFILE%"=="TRUE" (
	echo ===========================>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo ANALYSING DialNorm Level^:>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo ===========================>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
)
echo Analysing DialNorm ...
"!eac3topath!" "!SOURCEFILE!" -log=NUL>"!TEMP_FOLDER!\DialNorm.txt"
if "!CONTTRUE!"=="FALSE" set "DNtemp=!TEMP_FOLDER!\DialNorm.txt"
if "!CONTTRUE!"=="TRUE" findstr /C:"!RTRACK!: " "!TEMP_FOLDER!\DialNorm.txt">"!TEMP_FOLDER!\DialNormCont.txt"
if "!CONTTRUE!"=="TRUE" set "DNtemp=!TEMP_FOLDER!\DialNormCont.txt"

for /F "usebackq tokens=1-10 delims=,:" %%A in ("!DNtemp!") do (
	if " dialnorm"=="%%A" set "ATMOS_DIALNORM=%%B"
	if " dialnorm"=="%%B" set "ATMOS_DIALNORM=%%C"
	if " dialnorm"=="%%C" set "ATMOS_DIALNORM=%%D"
	if " dialnorm"=="%%D" set "ATMOS_DIALNORM=%%E"
	if " dialnorm"=="%%E" set "ATMOS_DIALNORM=%%F"
	if " dialnorm"=="%%F" set "ATMOS_DIALNORM=%%G"
	if " dialnorm"=="%%G" set "ATMOS_DIALNORM=%%H"
	if " dialnorm"=="%%H" set "ATMOS_DIALNORM=%%I"
	if " dialnorm"=="%%I" set "ATMOS_DIALNORM=%%J"
	if "!ATMOS_DIALNORM!" NEQ "UNKNOWN" (
		set "ATMOS_DIALNORM=!ATMOS_DIALNORM:~2,2!"
		set "DNORMFOUND=TRUE"
	)
)

if "!ATMOS_DIALNORM!"=="dB" set "ATMOS_DIALNORM=UNKNOWN"
if "!ATMOS_DIALNORM!" NEQ "31" ( 
	if "!ATMOS_DIALNORM!" NEQ "UNKNOWN" (
		echo DialNorm = -!ATMOS_DIALNORM! dB
		set /a AMPLIFY=31-!ATMOS_DIALNORM!
		echo Amplify !AMPLIFY! dB for DialNorm -31
		if "%LOGFILE%"=="TRUE" (
			echo DialNorm = -!ATMOS_DIALNORM! dB>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
			echo Amplify  = !AMPLIFY!>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		)
	) else (
		set /a AMPLIFY=0
		echo DialNorm UNKNOWN, leave Amplify untouched^^!
		if "%LOGFILE%"=="TRUE" (
			echo DialNorm = NOT FOUND ^(UNKNOWN^)>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
			echo Amplify  = LEAVE UNTOUCHED>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
			echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		)
	)
) else (
	set "AMPLIFY=0"
	echo DialNorm -31 dB, no Amplify needed^^!
	if "%LOGFILE%"=="TRUE" (
		echo Amplify  = NOT NEEDED>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	)
)
	
if "!DNORMFOUND!"=="TRUE" (
	%YELLOW%
	if "%LOGFILE%"=="TRUE" (
		echo DialNorm found and Amplify set^^!>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	)		
	%GREEN%
	echo DONE^^!
	echo.
) else (
	%YELLOW%
	if "%LOGFILE%"=="TRUE" (
		echo DialNorm not found, leave untouched^^!>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	)		
	%GREEN%
	echo DONE^^!
	echo.
)
goto :eof

:HEADERFIX
%YELLOW%
echo Fixing Header. Please wait ...
if "%LOGFILE%"=="TRUE" (
	echo =============>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo HEADER FIX^:>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo =============>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo Encoding Line: "!eac3topath!" "!SOURCEFILE!" "!TEMP_FOLDER!\!SOURCEFILENAME!_[HEADER_FIXED]!SOURCEFILEEXT!" -keepDialnorm -log=NUL>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
)
"!eac3topath!" "!SOURCEFILE!" "!TEMP_FOLDER!\!SOURCEFILENAME!_[HEADER_FIXED]!SOURCEFILEEXT!" -keepDialnorm -log=NUL
set "SOURCEFILE=!TEMP_FOLDER!\!SOURCEFILENAME!_[HEADER_FIXED]!SOURCEFILEEXT!"
if "%ERRORLEVEL%"=="0" (
	%GREEN%
	if "%LOGFILE%"=="TRUE" (
		echo DONE^^!>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	)
	set "TRACK=-1"
	echo.
	goto :eof
) else (
	%RED%
	if "%LOGFILE%"=="TRUE" (
		echo ERROR^^!>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
		echo.>>"!OUTPUTFILE!.FSAC_%DateStart%_%TimeFile%.log"
	)
	echo ERROR^^!
	echo.
	goto :EXIT
)

:FILECOUNTER
set /a "FILE_COUNTER=!FILE_COUNTER!+1"
if exist "!OUTPUTFILE!^(!FILE_COUNTER!^).!codec_ext!" goto :FILECOUNTER
goto :eof

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