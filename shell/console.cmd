@echo off
setlocal
set mplayer=C:\Portable\mplayer
set path=%path%;%mplayer%\mplayer;%mplayer%\ffmpeg;%mplayer%\flac
%~d1
cd "%~p1"
echo. & echo Example: ffmpeg -i video -i audio -vcodec copy -acodec copy video_mux & echo. 
call cmd
