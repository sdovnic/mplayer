@echo off
set mplayer=C:\Portable\mplayer
rem 0 = Normal Display
rem 1 = Anaglyphic Cyan Magenta
rem 2 = Anaglyphic Green Magenta
rem 3 = Anaglyphic Quadbuffer Stereo
set mode=2
"%mplayer%\mplayer\mplayer.exe" -vo gl:stereo=%mode% -fs "%~s1"
