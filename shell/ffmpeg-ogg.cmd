@echo off
set mplayer=F:\mplayer
set str=%~1
set str=%str:~0,-4%
"%mplayer%\ffmpeg\ffmpeg.exe" -i "%~s1" -vn -ab 320000 -acodec libvorbis "%str%.ogg"
pause
