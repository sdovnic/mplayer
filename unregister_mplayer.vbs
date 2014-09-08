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

' Registry Path
strRegistry = "HKEY_CURRENT_USER\Software\Classes\mplayer.exe\"

' Unregister File Extensions
For Each strExtension in arrExtensions
	objShell.RegDelete "HKEY_CURRENT_USER\Software\Classes\." & strExtension & "\"
Next

' Unregister MPlayer
objShell.RegDelete strRegistry & "FriendlyAppName"
objShell.RegDelete strRegistry & "DefaultIcon"
objShell.RegDelete strRegistry & "DefaultIcon\"
objShell.RegDelete strRegistry & "shell\open\command\"
objShell.RegDelete strRegistry & "shell\open\"
objShell.RegDelete strRegistry & "shell\join-folder\command\"
objShell.RegDelete strRegistry & "shell\join-folder\"
objShell.RegDelete strRegistry & "shell\parameter\command\"
objShell.RegDelete strRegistry & "shell\parameter\"
objShell.RegDelete strRegistry & "shell\playlist-audio\command\"
objShell.RegDelete strRegistry & "shell\playlist-audio\"
objShell.RegDelete strRegistry & "shell\playlist-video\command\"
objShell.RegDelete strRegistry & "shell\playlist-video\"
'objShell.RegDelete strRegistry & "shell\ass\command\"
'objShell.RegDelete strRegistry & "shell\ass\"
objShell.RegDelete strRegistry & "shell\noass\command\"
objShell.RegDelete strRegistry & "shell\noass\"
objShell.RegDelete strRegistry & "shell\reindex\command\"
objShell.RegDelete strRegistry & "shell\reindex\"
objShell.RegDelete strRegistry & "shell\avdump2\command\"
objShell.RegDelete strRegistry & "shell\avdump2\"
objShell.RegDelete strRegistry & "shell\console\command\"
objShell.RegDelete strRegistry & "shell\console\"
objShell.RegDelete strRegistry & "shell\extract-mp3\command\"
objShell.RegDelete strRegistry & "shell\extract-mp3\"
objShell.RegDelete strRegistry & "shell\extract-aac\command\"
objShell.RegDelete strRegistry & "shell\extract-aac\"
objShell.RegDelete strRegistry & "shell\extract-ogg\command\"
objShell.RegDelete strRegistry & "shell\extract-ogg\"
objShell.RegDelete strRegistry & "shell\unicode-play\command\"
objShell.RegDelete strRegistry & "shell\unicode-play\"
objShell.RegDelete strRegistry & "shell\switch-sid-aid\command\"
objShell.RegDelete strRegistry & "shell\switch-sid-aid\"
objShell.RegDelete strRegistry & "shell\3d-half-sbs\command\"
objShell.RegDelete strRegistry & "shell\3d-half-sbs\"
objShell.RegDelete strRegistry & "shell\3d-full-sbs\command\"
objShell.RegDelete strRegistry & "shell\3d-full-sbs\"
objShell.RegDelete strRegistry & "shell\3d-half-ou\command\"
objShell.RegDelete strRegistry & "shell\3d-half-ou\"
objShell.RegDelete strRegistry & "shell\3d-full-ou\command\"
objShell.RegDelete strRegistry & "shell\3d-full-ou\"
objShell.RegDelete strRegistry & "shell\"
objShell.RegDelete strRegistry

' Registry Path for Playlist
strRegistry = "HKEY_CURRENT_USER\Software\Classes\playlist.cmd\"

' Unregister File ExtensionsPlaylist
For Each strExtensionPlaylist in arrExtensionsPlaylist
	objShell.RegDelete "HKEY_CURRENT_USER\Software\Classes\." & strExtensionPlaylist & "\"
Next

' Unregister MPlayer for Playlist
objShell.RegDelete strRegistry & "FriendlyAppName"
objShell.RegDelete strRegistry & "DefaultIcon"
objShell.RegDelete strRegistry & "DefaultIcon\"
objShell.RegDelete strRegistry & "shell\open\command\"
objShell.RegDelete strRegistry & "shell\open\"
objShell.RegDelete strRegistry & "shell\playlist-audio\command\"
objShell.RegDelete strRegistry & "shell\playlist-audio\"
objShell.RegDelete strRegistry & "shell\playlist-video\command\"
objShell.RegDelete strRegistry & "shell\playlist-video\"
objShell.RegDelete strRegistry & "shell\"
objShell.RegDelete strRegistry

' Delete SendTo ShortCut
Dim strFolder
strFolder = objShell.SpecialFolders("SendTo")

Dim objFileSystem
Set objFileSystem = CreateObject("Scripting.FileSystemObject")
Dim objFile
Set objFile = objFileSystem.GetFile(strFolder + "\MPlayer - Movie Player.lnk")
objFile.Delete

' Message Box
MsgBox "MPlayer - Movie Player successfully uninstalled!", 64, "MPlayer - Movie Player Uninstaller (" & strVersion & ")"