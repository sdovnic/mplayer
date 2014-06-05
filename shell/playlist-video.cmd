@echo off
set mplayer=C:\Portable\mplayer
"%mplayer%\mplayer\mplayer.exe" -noborder -fs -fixed-vo -nocache -idle -loop 0 -playlist "%~s1"
