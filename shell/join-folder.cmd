@echo off
set mplayer=F:\mplayer
set str=%1
set ext=%~x1
set str=%str:~0,-5%


setlocal enabledelayedexpansion
rem set files=

for /r %%i in (*%~x1) do (
	set files=!files! "%%i"
)

"%mplayer%\mplayer\mencoder.exe" -forceidx -ovc copy -oac copy -o %str%-combined%ext%" %files%
"%mplayer%\mplayer\mplayer.exe" %str%-combined%ext%"