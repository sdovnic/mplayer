@echo off
set mplayer=C:\Portable\mplayer
if not exist "%mplayer%\shell\play-parameter-run.cmd" (
	echo @echo off > "%mplayer%\shell\play-parameter-run.cmd"
	echo set mplayer=%mplayer%>> "%mplayer%\shell\play-parameter-run.cmd"
	echo.>> "%mplayer%\shell\play-parameter-run.cmd"
	echo rem +--------------------------------------------------------+>> "%mplayer%\shell\play-parameter-run.cmd"
	echo rem ^|                                                        ^|>> "%mplayer%\shell\play-parameter-run.cmd"
	echo rem ^|    Argumente: %%~s1 or %%1                               ^|>> "%mplayer%\shell\play-parameter-run.cmd"
	echo rem ^|                                                        ^|>> "%mplayer%\shell\play-parameter-run.cmd"
	echo rem ^|    Beispiel: "%%mplayer%%\mplayer\mplayer.exe" "%%~s1"    ^|>> "%mplayer%\shell\play-parameter-run.cmd"
	echo rem ^|                                                        ^|>> "%mplayer%\shell\play-parameter-run.cmd"
	echo rem +--------------------------------------------------------+>> "%mplayer%\shell\play-parameter-run.cmd"
	echo.>> "%mplayer%\shell\play-parameter-run.cmd"
	echo "%%mplayer%%\mplayer\mplayer.exe" "%%~s1">> "%mplayer%\shell\play-parameter-run.cmd"
	echo.>> "%mplayer%\shell\play-parameter-run.cmd"
)
notepad "%mplayer%\shell\play-parameter-run.cmd"
"%mplayer%\shell\play-parameter-run.cmd" "%~s1"
