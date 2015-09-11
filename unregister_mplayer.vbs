Option Explicit

Dim strVersion
strVersion = "14.08.2015"

Dim objShell
Set objShell = CreateObject("WScript.Shell")

Dim strDirectory, strRegistry
Dim strExtension, strExtensionPlaylist
Dim arrExtensions, arrExtensionsPlaylist
Dim strPresent

' File Extensions
arrExtensions = Array("265", "mka", "bik", "evo", "vob", "m4r", "au", "ac3", "asf", "aac", _
"mkv", "m4a", "mp3", "m2v", "ogv", "ogg", "ogm", "wav", "webm", "weba", "avi", "mp4", "divx", _
"m4v", "mpg", "mpeg", "wmv", "wma", "flv", "mov", "flac", "m4b", "3gp", "m2ts", "ts", "dts")
arrExtensionsPlaylist = Array("m3u", "m3u8", "pls")

' Registry Path
strRegistry = "HKEY_CURRENT_USER\Software\Classes\mplayer.exe\"

' Unregister File Extensions
For Each strExtension in arrExtensions
	strPresent = objShell.RegRead("HKEY_CURRENT_USER\Software\Classes\." & strExtension & "\")
	If err.number <> 0 Then
		objShell.RegDelete "HKEY_CURRENT_USER\Software\Classes\." & strExtension & "\"
	End if
Next

Dim arrEntries, strEntry
arrEntries = Array("FriendlyAppName", "DefaultIcon", "DefaultIcon\", "shell\open\command\", _
"shell\open\", "shell\join-folder\command\", "shell\join-folder\", "shell\parameter\command\", _
"shell\parameter\", "shell\playlist-audio\command\", "shell\playlist-audio\", "shell\playlist-video\command\", _
"shell\playlist-video\", "shell\noass\command\", "shell\noass\", "shell\reindex\command\", _
"shell\reindex\", "shell\avdump2\command\", "shell\avdump2\", "shell\console\command\", "shell\console\", _
"shell\extract-mp3\command\", "shell\extract-mp3\", "shell\extract-aac\command\", "shell\extract-aac\", _
"shell\extract-ogg\command\", "shell\extract-ogg\", "shell\unicode-play\command\", "shell\unicode-play\", _
"shell\switch-sid-aid\command\", "shell\switch-sid-aid\", "shell\3d-half-sbs\command\", "shell\3d-half-sbs\", _
"shell\3d-full-sbs\command\", "shell\3d-full-sbs\", "shell\3d-half-ou\command\", "shell\3d-half-ou\", _
"shell\3d-full-ou\command\", "shell\3d-full-ou\", "shell\aspect-16-10-play\command\", "shell\aspect-16-10-play\")

' Unregister MPlayer
' For Each strEntry in arrEntries
'	strPresent = objShell.RegRead(strRegistry & strEntry)
'	If err.number <> 0 Then
'		objShell.RegDelete strRegistry & strEntry
'	End if
' Next
' objShell.RegDelete strRegistry & "FriendlyAppName"
' objShell.RegDelete strRegistry & "DefaultIcon"
' objShell.RegDelete strRegistry & "DefaultIcon\"
' objShell.RegDelete strRegistry & "shell\open\command\"
' objShell.RegDelete strRegistry & "shell\open\"
' objShell.RegDelete strRegistry & "shell\join-folder\command\"
' objShell.RegDelete strRegistry & "shell\join-folder\"
' objShell.RegDelete strRegistry & "shell\parameter\command\"
' objShell.RegDelete strRegistry & "shell\parameter\"
' objShell.RegDelete strRegistry & "shell\playlist-audio\command\"
' objShell.RegDelete strRegistry & "shell\playlist-audio\"
' objShell.RegDelete strRegistry & "shell\playlist-video\command\"
' objShell.RegDelete strRegistry & "shell\playlist-video\"
' objShell.RegDelete strRegistry & "shell\noass\command\"
' objShell.RegDelete strRegistry & "shell\noass\"
' objShell.RegDelete strRegistry & "shell\reindex\command\"
' objShell.RegDelete strRegistry & "shell\reindex\"
' objShell.RegDelete strRegistry & "shell\avdump2\command\"
' objShell.RegDelete strRegistry & "shell\avdump2\"
' objShell.RegDelete strRegistry & "shell\console\command\"
' objShell.RegDelete strRegistry & "shell\console\"
' objShell.RegDelete strRegistry & "shell\extract-mp3\command\"
' objShell.RegDelete strRegistry & "shell\extract-mp3\"
' objShell.RegDelete strRegistry & "shell\extract-aac\command\"
' objShell.RegDelete strRegistry & "shell\extract-aac\"
' objShell.RegDelete strRegistry & "shell\extract-ogg\command\"
' objShell.RegDelete strRegistry & "shell\extract-ogg\"
' objShell.RegDelete strRegistry & "shell\unicode-play\command\"
' objShell.RegDelete strRegistry & "shell\unicode-play\"
' objShell.RegDelete strRegistry & "shell\switch-sid-aid\command\"
' objShell.RegDelete strRegistry & "shell\switch-sid-aid\"
' objShell.RegDelete strRegistry & "shell\3d-half-sbs\command\"
' objShell.RegDelete strRegistry & "shell\3d-half-sbs\"
' objShell.RegDelete strRegistry & "shell\3d-full-sbs\command\"
' objShell.RegDelete strRegistry & "shell\3d-full-sbs\"
' objShell.RegDelete strRegistry & "shell\3d-half-ou\command\"
' objShell.RegDelete strRegistry & "shell\3d-half-ou\"
' objShell.RegDelete strRegistry & "shell\3d-full-ou\command\"
' objShell.RegDelete strRegistry & "shell\3d-full-ou\"
' objShell.RegDelete strRegistry & "shell\aspect-16-10-play\command\"
' objShell.RegDelete strRegistry & "shell\aspect-16-10-play\"
' objShell.RegDelete strRegistry & "shell\"

' On Error Resume Next

Const HKEY_CURRENT_USER = &H80000001

Dim strComputer, strKeyPath, objRegistry
Dim arrSubkeys, strSubkey

strComputer = "."
strKeyPath = "Software\Classes\mplayer.exe"

Set objRegistry = GetObject("winmgmts:\\" & _
    strComputer & "\root\default:StdRegProv")

DeleteSubkeys HKEY_CURRENT_USER, strKeypath

Sub DeleteSubkeys(HKEY_CURRENT_USER, strKeyPath)
    objRegistry.EnumKey HKEY_CURRENT_USER, strKeyPath, arrSubkeys

    If IsArray(arrSubkeys) Then
        For Each strSubkey In arrSubkeys
            DeleteSubkeys HKEY_CURRENT_USER, strKeyPath & "\" & strSubkey
        Next
    End If

    objRegistry.DeleteKey HKEY_CURRENT_USER, strKeyPath
End Sub
' Registry Path
' strRegistry = "HKEY_CURRENT_USER\Software\Classes\mplayer.exe\"
' objShell.RegDelete strRegistry

' Registry Path for Playlist
strRegistry = "HKEY_CURRENT_USER\Software\Classes\playlist.cmd\"

' Unregister File ExtensionsPlaylist
For Each strExtensionPlaylist in arrExtensionsPlaylist
	strPresent = objShell.RegRead("HKEY_CURRENT_USER\Software\Classes\." & strExtensionPlaylist & "\")
	If err.number <> 0 Then
		objShell.RegDelete "HKEY_CURRENT_USER\Software\Classes\." & strExtensionPlaylist & "\"
	End If
Next

' Unregister MPlayer for Playlist
' objShell.RegDelete strRegistry & "FriendlyAppName"
' objShell.RegDelete strRegistry & "DefaultIcon"
' objShell.RegDelete strRegistry & "DefaultIcon\"
' objShell.RegDelete strRegistry & "shell\open\command\"
' objShell.RegDelete strRegistry & "shell\open\"
' objShell.RegDelete strRegistry & "shell\playlist-audio\command\"
' objShell.RegDelete strRegistry & "shell\playlist-audio\"
' objShell.RegDelete strRegistry & "shell\playlist-video\command\"
' objShell.RegDelete strRegistry & "shell\playlist-video\"
' objShell.RegDelete strRegistry & "shell\"
' objShell.RegDelete strRegistry

DeleteSubkeys HKEY_CURRENT_USER, "HKEY_CURRENT_USER\Software\Classes\playlist.cmd"

' Delete SendTo ShortCut
Dim strFolder
strFolder = objShell.SpecialFolders("SendTo")

Dim objFileSystem
Set objFileSystem = CreateObject("Scripting.FileSystemObject")
If objFileSystem.FileExists(strFolder + "\MPlayer - Movie Player.lnk") Then
	Dim objFile
	Set objFile = objFileSystem.GetFile(strFolder + "\MPlayer - Movie Player.lnk")
	objFile.Delete
End If

' Message Box
MsgBox "MPlayer - Movie Player successfully uninstalled!", 64, "MPlayer - Movie Player Uninstaller (" & strVersion & ")"
