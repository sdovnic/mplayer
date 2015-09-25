@echo off
<<<<<<< HEAD
=======
setlocal
>>>>>>> origin/master
set mplayer=C:\Portable\mplayer
set ed2k="--Exp=ed2k.txt"
set done="--Done=done.txt"
rem Rename avdump2.ini.contrib to avdump2.ini
rem Enter your AniDB Credentials into the the File
for /f "tokens=1,2 delims==" %%a in (%mplayer%\shell\avdump2.ini) do (
	if %%a==user set user=%%b
	if %%a==pass set pass=%%b
<<<<<<< HEAD
	set login="--Auth=%user%:%pass%"
)
"%mplayer%\avdump\AVDump2CL.exe" %login% --OpenAniDBLink %done% %ed2k% "%1"
pause
=======
)
if exist %user% do (
	set login="--Auth=%user%:%pass%"
)
"%mplayer%\avdump2\AVDump2CL.exe" %login% --OpenAniDBLink %done% %ed2k% "%1"
pause
endlocal
>>>>>>> origin/master
