@echo off & setlocal
setlocal EnableDelayedExpansion
set "EXTERNSTART=TRUE" rem must be set for the call command.
set "FSACpath=C:\FSAC"
set "file=%~1"
if "!file!"=="" (
	echo Batch script for multi index encoding. Please drag and drop input file
	echo or type ^<%~n0 "MyFile.mkv"^>
) else (
	:: Start all commandos here with call!
	call "!FSACpath!\FSAC.cmd" "!file!" --Index-2
	call "!FSACpath!\FSAC.cmd" "!file!" --Index-3
)
echo.
setlocal DisableDelayedExpansion
timeout 30
exit