@echo off
set mplayer=F:\mplayer
"%mplayer%\mplayer\mplayer.exe" -noborder -fixed-vo -nocache -idle -loop 0 -playlist "%~s1"
