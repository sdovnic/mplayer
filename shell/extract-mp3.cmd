@echo off
set mplayer=C:\Portable\mplayer
set str=%~1
set str=%str:~0,-4%
"%mplayer%\ffmpeg\ffmpeg.exe" -i "%~s1" -f mp3 -ab 320000 -acodec libmp3lame "%str%.mp3"
pause
