@echo off
set mplayer=C:\Portable\mplayer
set ed2k="--Exp=ed2k.txt"
set done="--Done=done.txt"
rem rename av2dump.ini.contrib to av2dump.ini
rem enter your anidb credentials into the the file
for /f "tokens=1,2 delims==" %%a in (%mplayer%\shell\avdump2.ini) do (
	if %%a==user set user=%%b
	if %%a==pass set pass=%%b
	set login="--Auth=%user%:%pass%"
)
"%mplayer%\avdump2\AVDump2CL.exe" %login% --OpenAniDBLink %done% %ed2k% %1
pause
