@echo off
set mplayer=F:\mplayer
set login="--Auth=user:pass"
set ed2k="--Exp=ed2k.txt"
set done="--Done=done.txt"
"%mplayer%\avdump2\AVDump2CL.exe" %login% --OpenAniDBLink %done% %ed2k% %1
pause
