@echo on
set mplayer=F:\mplayer
notepad %mplayer%\shell\parameter-run.cmd
"%mplayer%\shell\parameter-run.cmd" "%~s1"
pause
