@echo off
set mplayer=F:\mplayer
rem 0 = Normal Display
rem 1 = Anaglyphic Cyan Magenta
rem 2 = Anaglyphic Green Magenta
rem 3 = Anaglyphic Quadbuffer Stereo
set mode=1
"%mplayer%\mplayer\mplayer.exe" -vo gl:stereo=%mode% -aspect 1.78 -fs "%~s1"
