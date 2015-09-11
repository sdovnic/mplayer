@echo on
set mplayer=C:\Portable\mplayer
if not exist "%mplayer%\shell\parameter-run.cmd" (
	echo @echo off > "%mplayer%\shell\parameter-run.cmd"
set mplayer=C:\Portable\mplayer
	echo. >> "%mplayer%\shell\parameter-run.cmd"
	echo rem +--------------------------------------------------------+ >> "%mplayer%\shell\parameter-run.cmd"
	echo rem ^|                                                        ^| >> "%mplayer%\shell\parameter-run.cmd"
	echo rem ^|    Argumente: %%~s1 or %%1                               ^| >> "%mplayer%\shell\parameter-run.cmd"
	echo rem ^|                                                        ^| >> "%mplayer%\shell\parameter-run.cmd"
	echo rem ^|    Beispiel: "%%mplayer%%\mplayer\mplayer.exe" "%%~s1"    ^| >> "%mplayer%\shell\parameter-run.cmd"
	echo rem ^|                                                        ^| >> "%mplayer%\shell\parameter-run.cmd"
	echo rem +--------------------------------------------------------+ >> "%mplayer%\shell\parameter-run.cmd"
	echo. >> "%mplayer%\shell\parameter-run.cmd"
	echo "%%mplayer%%\mplayer\mplayer.exe" "%%~s1" >> "%mplayer%\shell\parameter-run.cmd"
)
notepad %mplayer%\shell\parameter-run.cmd
"%mplayer%\shell\parameter-run.cmd" "%~s1"
pause
