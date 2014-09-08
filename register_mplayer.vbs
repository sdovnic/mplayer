Option Explicit

Dim strVersion
strVersion = "13.10.2013"

Dim objShell
Set objShell = CreateObject("WScript.Shell")

Dim strDirectory, strRegistry
Dim strExtension, strExtensionPlaylist
Dim arrExtensions, arrExtensionsPlaylist

' File Extensions
arrExtensions = Array("265", "mka", "bik", "evo", "vob", "m4r", "au", "ac3", "asf", "aac", "mkv", "m4a", "mp3", "m2v", "ogv", "ogg", "ogm", "wav", "webm", "weba", "avi", "mp4", "divx", "m4v", "mpg", "mpeg", "wmv", "wma", "flv", "mov", "flac", "m4b", "3gp", "m2ts", "ts", "dts")
arrExtensionsPlaylist = Array("m3u", "m3u8", "pls")

' MPlayer Directory
Dim strScriptFullName
strScriptFullName = Wscript.ScriptFullName

Dim objFileSystem, objFile
Set objFileSystem = CreateObject("Scripting.FileSystemObject")
Set objFile = objFileSystem.GetFile(strScriptFullName)

strDirectory = objFileSystem.GetParentFolderName(objFile)

' Set Variables in Shell Files
Dim arrShells, strShell
arrShells = Array("3d-full-ou", "3d-half-ou", "3d-full-sbs", "3d-half-sbs", "avdump2", "encode-flac", "ffmpeg-aac", "ffmpeg-mp3", "ffmpeg-ogg", "join-folder", "playlist", "parameter", "parameter-run", "playlist-audio", "playlist-video", "unicode-play", "console")

Const Read = 1
Const Write = 2

Dim objReadFile, objTempFile, strLine
For Each strShell in arrShells
	Set objReadFile = objFileSystem.OpenTextFile(strDirectory & "\shell\" & strShell & ".cmd", Read, True)
	Set objTempFile = objFileSystem.OpenTextFile(strDirectory & "\shell\" & strShell & ".tmp", Write, True)
	Do While Not objReadFile.AtEndofStream
		strLine = objReadFile.ReadLine
		If InStr(strLine, "set mplayer=") Then
			strLine = "set mplayer=" & strDirectory
		End If

		objTempFile.WriteLine strLine
	Loop
	objReadFile.Close
	objTempFile.Close
	objFileSystem.DeleteFile(strDirectory & "\shell\" & strShell & ".cmd")
	objFileSystem.MoveFile strDirectory & "\shell\" & strShell & ".tmp", strDirectory & "\shell\" & strShell & ".cmd"
Next

' Detect Screen Resolution for Aspect
Dim objWMIService, objItem, objItems, intHorizontal, intVertical
Set objWMIService = GetObject("Winmgmts:\\.\root\cimv2")
Set objItems = objWMIService.ExecQuery("Select * From Win32_DesktopMonitor where DeviceID = 'DesktopMonitor1'",,0)
For Each objItem in objItems
	intHorizontal = objItem.ScreenWidth
	intVertical = objItem.ScreenHeight
Next

' Modify MPlayer Config
Set objReadFile = objFileSystem.OpenTextFile(strDirectory & "\mplayer\mplayer\config", Read, True)
Set objTempFile = objFileSystem.OpenTextFile(strDirectory & "\mplayer\mplayer\config" & ".tmp", Write, True)
Do While Not objReadFile.AtEndofStream
	strLine = objReadFile.ReadLine
	If InStr(strLine, "monitoraspect=") Then
		strLine = "monitoraspect=" & intHorizontal & "/" & intVertical
	End If
	If InStr(strLine, "ass-styles=") Then
		strLine = "ass-styles=" & chr(34) & strDirectory & "\mplayer\mplayer\styles.ass" & chr(34)
	End If

	objTempFile.WriteLine strLine
Loop
objReadFile.Close
objTempFile.Close
objFileSystem.DeleteFile(strDirectory & "\mplayer\mplayer\config")
objFileSystem.MoveFile strDirectory & "\mplayer\mplayer\config" & ".tmp", strDirectory & "\mplayer\mplayer\config"

' Registry Path
strRegistry = "HKEY_CURRENT_USER\Software\Classes\mplayer.exe\"

' Register File Extensions
For Each strExtension in arrExtensions
	objShell.RegWrite "HKEY_CURRENT_USER\Software\Classes\." & strExtension & "\", "mplayer.exe"
Next

' Register MPlayer
objShell.RegWrite strRegistry & "FriendlyAppName", "MPlayer - Movie Player"
objShell.RegWrite strRegistry & "DefaultIcon", strDirectory & "\icons\media.ico"
objShell.RegWrite strRegistry & "DefaultIcon\", strDirectory & "\icons\media.ico"
objShell.RegWrite strRegistry & "shell\open\command\", strDirectory & "\mplayer\mplayer.exe " & chr(34) & "%1" & chr(34)
objShell.RegWrite strRegistry & "shell\parameter\", "Parameter definieren"
objShell.RegWrite strRegistry & "shell\parameter\command\", strDirectory & "\shell\parameter.cmd " & chr(34) & "%1" & chr(34)
objShell.RegWrite strRegistry & "shell\join-folder\", "Dateien zusammenfügen"
objShell.RegWrite strRegistry & "shell\join-folder\command\", strDirectory & "\shell\join-folder.cmd " & chr(34) & "%1" & chr(34)
objShell.RegWrite strRegistry & "shell\playlist-audio\", "Playlist Audio"
objShell.RegWrite strRegistry & "shell\playlist-audio\command\", strDirectory & "\shell\playlist-audio.cmd " & chr(34) & "%1" & chr(34)
objShell.RegWrite strRegistry & "shell\playlist-video\", "Playlist Video"
objShell.RegWrite strRegistry & "shell\playlist-video\command\", strDirectory & "\shell\playlist-video.cmd " & chr(34) & "%1" & chr(34)
'objShell.RegWrite strRegistry & "shell\ass\", "Karaoke Untertitel"
'objShell.RegWrite strRegistry & "shell\ass\command\", strDirectory & "\mplayer\mplayer.exe -ass " & chr(34) & "%1" & chr(34)
objShell.RegWrite strRegistry & "shell\noass\", "Keine ASS Untertitel"
objShell.RegWrite strRegistry & "shell\noass\command\", strDirectory & "\mplayer\mplayer.exe -noass " & chr(34) & "%1" & chr(34)
objShell.RegWrite strRegistry & "shell\reindex\", "Datei mit defektem Index"
objShell.RegWrite strRegistry & "shell\reindex\command\", strDirectory & "\mplayer\mplayer.exe -idx " & chr(34) & "%1" & chr(34)
objShell.RegWrite strRegistry & "shell\console\", "Console"
objShell.RegWrite strRegistry & "shell\console\command\", strDirectory & "\shell\console.cmd"
objShell.RegWrite strRegistry & "shell\extract-mp3\", "Audio zu MP3 extrahieren"
objShell.RegWrite strRegistry & "shell\extract-mp3\command\", strDirectory & "\shell\ffmpeg-mp3.cmd " & chr(34) & "%1" & chr(34)
objShell.RegWrite strRegistry & "shell\extract-aac\", "Audio zu AAC extrahieren"
objShell.RegWrite strRegistry & "shell\extract-aac\command\", strDirectory & "\shell\ffmpeg-aac.cmd " & chr(34) & "%1" & chr(34)
objShell.RegWrite strRegistry & "shell\extract-ogg\", "Audio zu OGG extrahieren"
objShell.RegWrite strRegistry & "shell\extract-ogg\command\", strDirectory & "\shell\ffmpeg-ogg.cmd " & chr(34) & "%1" & chr(34)
objShell.RegWrite strRegistry & "shell\avdump2\", "AniDB Information"
objShell.RegWrite strRegistry & "shell\avdump2\command\", strDirectory & "\shell\avdump2.cmd " & chr(34) & "%1" & chr(34)
objShell.RegWrite strRegistry & "shell\unicode-play\", "Datei mit Sonderzeichen"
objShell.RegWrite strRegistry & "shell\unicode-play\command\", strDirectory & "\shell\unicode-play.cmd " & chr(34) & "%1" & chr(34)
objShell.RegWrite strRegistry & "shell\switch-sid-aid\", "Tonspur und Untertitel wechseln"
objShell.RegWrite strRegistry & "shell\switch-sid-aid\command\", strDirectory & "\mplayer\mplayer.exe -sid 0 -aid 1 " & chr(34) & "%1" & chr(34)
objShell.RegWrite strRegistry & "shell\3d-half-sbs\", "3D Half Side-by-Side"
objShell.RegWrite strRegistry & "shell\3d-half-sbs\command\", strDirectory & "\shell\3d-half-sbs.cmd " & chr(34) & "%1" & chr(34)
objShell.RegWrite strRegistry & "shell\3d-full-sbs\", "3D Full Side-by-Side"
objShell.RegWrite strRegistry & "shell\3d-full-sbs\command\", strDirectory & "\shell\3d-full-sbs.cmd " & chr(34) & "%1" & chr(34)
objShell.RegWrite strRegistry & "shell\3d-half-ou\", "3D Half Over-Under"
objShell.RegWrite strRegistry & "shell\3d-half-ou\command\", strDirectory & "\shell\3d-half-ou.cmd " & chr(34) & "%1" & chr(34)
objShell.RegWrite strRegistry & "shell\3d-full-ou\", "3D Full Over-Under"
objShell.RegWrite strRegistry & "shell\3d-full-ou\command\", strDirectory & "\shell\3d-full-ou.cmd " & chr(34) & "%1" & chr(34)


' Registry Path for Playlist
strRegistry = "HKEY_CURRENT_USER\Software\Classes\playlist.cmd\"

' Register File ExtensionsPlaylist
For Each strExtensionPlaylist in arrExtensionsPlaylist
	objShell.RegWrite "HKEY_CURRENT_USER\Software\Classes\." & strExtensionPlaylist & "\", "playlist.cmd"
Next

' Register MPlayer for Playlist
objShell.RegWrite strRegistry & "FriendlyAppName", "MPlayer - Movie Player (Playlist)"
objShell.RegWrite strRegistry & "DefaultIcon", strDirectory & "\icons\media.ico"
objShell.RegWrite strRegistry & "DefaultIcon\", strDirectory & "\icons\media.ico"
objShell.RegWrite strRegistry & "shell\open\command\", strDirectory & "\shell\playlist.cmd " & chr(34) & "%1" & chr(34)
objShell.RegWrite strRegistry & "shell\playlist-audio\", "Playlist Audio"
objShell.RegWrite strRegistry & "shell\playlist-audio\command\", strDirectory & "\shell\playlist-audio.cmd " & chr(34) & "%1" & chr(34)
objShell.RegWrite strRegistry & "shell\playlist-video\", "Playlist Video"
objShell.RegWrite strRegistry & "shell\playlist-video\command\", strDirectory & "\shell\playlist-video.cmd " & chr(34) & "%1" & chr(34)

' Create SendTo ShortCut
Const Maximized = 3
Const Minimized = 7
Const Normal = 4

Dim strFolder
strFolder = objShell.SpecialFolders("SendTo")

Dim objShortcut
Set objShortcut = objShell.CreateShortcut(strFolder + "\MPlayer - Movie Player.lnk")

objShortcut.WindowStyle = Normal
objShortcut.IconLocation = strDirectory + "\icons\media.ico"
objShortcut.TargetPath = strDirectory + "\shell\unicode-play.cmd"
objShortcut.Save

' Message Box
MsgBox "MPlayer - Movie Player successfully installed!", 64, "MPlayer - Movie Player Installer (" & strVersion & ")"