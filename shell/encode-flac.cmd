@echo off
set mplayer=C:\Portable\mplayer
set str=%~s1
set str=%str:~0,-4%
"%mplayer%\flac\flac.exe" -8 -V "%~s1" -o "%str%.flac"
pause
