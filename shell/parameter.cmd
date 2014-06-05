@echo on
set mplayer=C:\Portable\mplayer
notepad %mplayer%\shell\parameter-run.cmd
"%mplayer%\shell\parameter-run.cmd" "%~s1"
pause
