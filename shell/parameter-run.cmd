@echo off
set mplayer=C:\Portable\mplayer

rem +-----------------------------------------------------------+
rem |							  	|
rem |	Argumente:	%~s1 or %1				|
rem |								|						
rem |	Beispiel:	"%mplayer%\mplayer\mplayer.exe" "%~s1"	|
rem |								|
rem +-----------------------------------------------------------+

set font="-fontconfig -font Calibri -embeddedfonts"
set sub="-sub-fuzziness 1 -subfont-autoscale 3 -subfont-osd-scale 1 -subfont-text-scale 1 -subpos 100"
set ass="-ass -ass-line-spacing 0 -ass-font-scale 1"

rem -lavdopts lowres=1:fast:skiploopfilter=all
rem -monitorpixelaspect 1 -nokeepaspect -nodouble -noquiet -nofs
rem -subcp ISO-8859-1
rem -nofontconfig
rem -ss 360
rem -slave 
rem -ass-styles styles.ass
rem -identify 
rem -vo gl:yuv=2:force-pbo -ao dsound -priority abovenormal -framedrop -dr -volume 50 
rem -nocache -osdlevel 0 -vf-add screenshot -noslices
rem -channels 2 -af scaletempo,equalizer=0:0:0:0:0:0:0:0:0:0 -softvol -softvol-max 110

rem blu-ray true hd test
rem -fs -zoom -quiet -vo xv -vc ffvc1 -fps 24000/1001 -lavdopts threads=2:fast:skiploopfilter=all -sws 0 -framedrop -ni -cache 9999
rem -fs -zoom -x 1280 -y 720 -quiet -vo xv -vc ffvc1 -fps 24000/1001 -lavdopts threads=2:fast:skiploopfilter=all -sws 0 -framedrop -ni -cache 9999

rem "%mplayer%\mplayer\mplayer.exe" -fs -zoom -quiet -sws 0 -fps 24000/1001 -lavdopts threads=2:fast:skiploopfilter=all -ni -framedrop -cache 9999 "%~s1"
rem 3D = -vo vdpaustereo -vc ffh264vdpau,ffmpeg12vdpau,ffvc1vdpau,ffwmv3vdpau
rem -vf stereo3d=sbsl:arcg
rem -vo gl:stereo=3
rem stereo=<n>
rem   0: normal display
rem   1: side-by-side to red-cyan stereo
rem   2: side-by-side to green-magenta stereo
rem   3: side-by-side to quadbuffer stereo

"%mplayer%\mplayer\mplayer.exe" %1 -fps 50
rem -aspect 19:9
rem -vo gl_nosw
rem -vf stereo3d=above_below_half_height_left_first:mono_left
rem -vo gl:stereo=1 %~s1
rem -vo gl:stereo=3 %~s1
rem -loop 0 -fs -zoom -quiet -volume 0 -ss 00:00:07 %~s1
rem -ao pcm -vo null %1
rem -identify -frames 0 -vo null -ao null %1

pause
