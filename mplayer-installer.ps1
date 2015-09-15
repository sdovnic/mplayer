Set-PSDebug -Strict
Function Show-Balloon {
    Param(
        [Parameter(Mandatory=$true)] [String] $TipTitle,
        [Parameter(Mandatory=$true)] [String] $TipText,
        [Parameter(Mandatory=$false)] [ValidateSet("Info", "Error", "Warning")] [String] $TipIcon,
        [String] $Icon
    )
    [Void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    $FormsNotifyIcon = New-Object System.Windows.Forms.NotifyIcon
    If (-not $Icon) { $Icon = (Join-Path -Path $PSHOME -ChildPath "powershell.exe"); }
    $DrawingIcon = [System.Drawing.Icon]::ExtractAssociatedIcon($Icon)
    $FormsNotifyIcon.Icon = $DrawingIcon
    If (-not $TipIcon) { $TipIcon = "Info"; }
    $FormsNotifyIcon.BalloonTipIcon = $TipIcon;
    $FormsNotifyIcon.BalloonTipTitle = $TipTitle
    $FormsNotifyIcon.BalloonTipText = $TipText
    $FormsNotifyIcon.Visible = $True
    $FormsNotifyIcon.ShowBalloonTip(5000)
    Start-Sleep -Milliseconds 5000
    $FormsNotifyIcon.Dispose()
}
Function Add-ShortCut {
    Param(
        [Parameter(Mandatory=$true)] [String] $Link,
        [Parameter(Mandatory=$true)] [String] $TargetPath,
        [String] $Arguments,
        [String] $IconLocation,
        [String] $WorkingDirectory,
        [String] $Description,
        [Parameter(Mandatory=$false)] [ValidateSet("Normal", "Minimized", "Maximized")] [String] $WindowStyle
    )
    If (Test-Path -Path $TargetPath) {
        $WShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WShell.CreateShortcut($Link)
        $Shortcut.TargetPath = $TargetPath
        If ($Arguments) { $Shortcut.Arguments = $Arguments; }
        If ($IconLocation) { $Shortcut.IconLocation = $IconLocation; }
        If ($WorkingDirectory) { $Shortcut.WorkingDirectory = $WorkingDirectory; }
        If ($WindowStyle) {
            Switch ($WindowStyle) {
                "Normal" { [Int] $WindowStyleNumerate = 4 };
                "Minimized" { [Int] $WindowStyleNumerate = 7 };
                "Maximized" { [Int] $WindowStyleNumerate = 3 };
            }
            $Shortcut.WindowStyle = $WindowStyleNumerate;
        }
        If ($Description) { $Shortcut.Description = $Description; }
        $Shortcut.Save()
    }
}
Function Remove-Shortcut {
    Param([Parameter(Mandatory=$true)] [String] $Link)
    If (Test-Path -Path $Link) { Remove-Item $Link; }
}
[String] $AppFriendlyName = "MPlayer - Movie Player"
[String] $AppName = "MPlayer"
[String] $AppDescription = "MPlayer is a movie player which runs on many systems."
If ($PSVersionTable.PSVersion.Major -lt 3) {
    [String] $PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
}
[String] $AppLocation = $PSScriptRoot
[String] $AppIcon = "%SystemRoot%\System32\imageres.dll,128"
[String] $AppIconAudio = "%SystemRoot%\System32\imageres.dll,125"
[String] $AppIconVideo = "%SystemRoot%\System32\imageres.dll,127"
[array] $ExtensionsAudio = @(
    "mka", "m4r", "au", "ac3", "aac", "m4a", "mp3", "ogg", "wav", "weba", "wma", "flac", "m4b", "dts"
)
[array] $ExtensionsVideo = @(
    "265", "bik", "evo", "vob", "asf", "mkv", "m2v", "ogv", "ogm", "webm", "avi", "mp4", "divx", "m4v", "mpg", "mpeg",
    "wmv", "flv", "mov", "3gp", "m2ts", "ts"
)
[array] $ExtensionsPlaylist = @(
    "m3u", "m3u8", "pls"
)
If ($args.Length -gt 0) {
    If ($args[0].Contains("remove")) {
        Write-Host "Remove Submenu Entries for Extract Audio"
        $Path = "HKCU:\SOFTWARE\Classes\$AppName.Extract"
        If (Test-Path -Path $Path) { Remove-Item -Path $Path -Recurse -Confirm:$false -Force; }
        Write-Host "Remove Submenu Entries for 3D Options"
        $Path = "HKCU:\SOFTWARE\Classes\$AppName.3D"
        If (Test-Path -Path $Path) { Remove-Item -Path $Path -Recurse -Confirm:$false -Force; }
        Write-Host "Remove Submenu Entries for Extras"
        $Path = "HKCU:\SOFTWARE\Classes\$AppName.Extras"
        If (Test-Path -Path $Path) { Remove-Item -Path $Path -Recurse -Confirm:$false -Force; }
        Write-Host "Remove Submenu Entries for Playlists"
        $Path = "HKCU:\SOFTWARE\Classes\$AppName.Playlist"
        If (Test-Path -Path $Path) { Remove-Item -Path $Path -Recurse -Confirm:$false -Force; }
        Write-Host "Remove File Associations"
        Foreach($Extension in $ExtensionsAudio) {
            $Path = "HKCU:\SOFTWARE\Classes\.$Extension"
            If (Test-Path -Path $Path) { Remove-Item -Path $Path -Recurse -Confirm:$false -Force; }
        }
        Foreach($Extension in $ExtensionsVideo) {
            $Path = "HKCU:\SOFTWARE\Classes\.$Extension"
            If (Test-Path -Path $Path) { Remove-Item -Path $Path -Recurse -Confirm:$false -Force; }
        }
        Foreach($Extension in $ExtensionsPlaylist) {
            $Path = "HKCU:\SOFTWARE\Classes\.$Extension"
            If (Test-Path -Path $Path) { Remove-Item -Path $Path -Recurse -Confirm:$false -Force; }
        }
        Write-Host "Remove Menu Entries Video"
        $Path = "HKCU:\SOFTWARE\Classes\$AppName"
        If (Test-Path -Path $Path) { Remove-Item -Path $Path -Recurse -Confirm:$false -Force; }
        Write-Host "Remove Menu Entries Audio"
        $Path = "HKCU:\SOFTWARE\Classes\$AppName.Audio"
        If (Test-Path -Path $Path) { Remove-Item -Path $Path -Recurse -Confirm:$false -Force; }
        Write-Host "Remove Leftovers"
        $Path = "HKCU:\SOFTWARE\Classes\playlist.cmd"
        If (Test-Path -Path $Path) { Remove-Item -Path $Path -Recurse -Confirm:$false -Force; }
        $Path = "HKCU:\SOFTWARE\Classes\mplayer.exe"
        If (Test-Path -Path $Path) { Remove-Item -Path $Path -Recurse -Confirm:$false -Force; }
        $Path = "HKCU:\SOFTWARE\Classes\mplayer.exe.test"
        If (Test-Path -Path $Path) { Remove-Item -Path $Path -Recurse -Confirm:$false -Force; }
        Foreach($Extension in $ExtensionsAudio) {
            [String] $Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$Extension\OpenWithProgids"
            If (Test-Path -Path $Path) {
                Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$Extension\OpenWithProgids" -Name "mplayer.exe*" -ErrorAction SilentlyContinue
                Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$Extension\OpenWithProgids" -Name "MPlayer*" -ErrorAction SilentlyContinue
            }
        }
        Foreach($Extension in $ExtensionsVideo) {
            [String] $Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$Extension\OpenWithProgids"
            If (Test-Path -Path $Path) {
                Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$Extension\OpenWithProgids" -Name "mplayer.exe*" -ErrorAction SilentlyContinue
                Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$Extension\OpenWithProgids" -Name "MPlayer*" -ErrorAction SilentlyContinue
            }
        }
        Foreach($Extension in $ExtensionsPlaylist) {
            [String] $Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$Extension\OpenWithProgids"
            If (Test-Path -Path $Path) {
                Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$Extension\OpenWithProgids" -Name "mplayer.exe'" -ErrorAction SilentlyContinue
                Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$Extension\OpenWithProgids" -Name "MPlayer*" -ErrorAction SilentlyContinue
                Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$Extension\OpenWithProgids" -Name "playlist.cmd" -ErrorAction SilentlyContinue
            }
        }
        Write-Host "Remove SendTo ShortCut"
        Remove-ShortCut -Link (Join-Path -Path ([environment]::GetFolderPath("SendTo")) -ChildPath "$AppFriendlyName.lnk")
        Write-Host "Show Install Message"
        Add-Type -AssemblyName System.Windows.Forms
        $Result = [System.Windows.Forms.MessageBox]::Show(
           "$AppFriendlyName removed.",
           $AppFriendlyName, 0, [System.Windows.Forms.MessageBoxIcon]::Information
        )
        Write-Host "Show Balloon Message"
        Show-Balloon -TipTitle $AppFriendlyName -TipText "MPlayer - Movie Player removed."
    }
} Else {
    Write-Host "Add SendTo ShortCut"
    Add-ShortCut -Link (Join-Path -Path ([environment]::GetFolderPath("SendTo")) -ChildPath "$AppFriendlyName.lnk") `
                 -TargetPath (Join-Path -Path $AppLocation -ChildPath "mplayer\mplayer.exe") `
                 -Arguments "`"%1`"" -IconLocation $AppIcon -WorkingDirectory $PSScriptRoot -WindowStyle Normal `
                 -Description $AppDescription
    Write-Host "Set Path to Application Location"
    Foreach($Item in (Get-Item -Path "$AppLocation\shell\*.cmd")) {
        $Content = Get-Content -Path $Item.FullName
        $Content -replace "^set\ mplayer\=(.*)$", "set mplayer=$AppLocation" | Out-File -FilePath $Item.FullName -Encoding Ascii
    }
    Write-Host "Add Mouse Bindings"
    [Array] $MouseBindings = @(
        "MOUSE_BTN1 pause",
        "MOUSE_BTN2 vo_fullscreen"
    )
    [String] $Path = Join-Path -Path $AppLocation -ChildPath "mplayer\mplayer\input.conf"
    If (Test-Path -Path $Path) {
        $Content = Get-Content -Path $Path
        Foreach($MouseBinding in $MouseBindings) {
            If ($Content -notmatch $MouseBinding) {
                Add-Content -Path $Path -Value $MouseBinding -Force
            }
        }
    }
    Write-Host "Install StyleScript"
    [String] $StyleScript = "[Script Info]
; Script generated by Aegisub 2.1.9
; http://www.aegisub.org/
Title: Default Aegisub file
ScriptType: v4.00+
WrapStyle: 0
PlayResX: 800
PlayResY: 340
ScaledBorderAndShadow: no
Last Style Storage: Default
Video Aspect Ratio: 0
Video Zoom: 6
Video Position: 0

[V4+ Styles]
Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, OutlineColour, BackColour, Bold, Italic, Underline, StrikeOut, ScaleX, ScaleY, Spacing, Angle, BorderStyle, Outline, Shadow, Alignment, MarginL, MarginR, MarginV, Encoding
Style: Default,Calibri,30,&H00FFFFFF,&H000000FF,&H22222200,&H22222200,0,0,0,0,100,100,0,0,1,1,0,2,10,10,10,1"
    [String] $Path = Join-Path -Path $AppLocation -ChildPath "mplayer\mplayer\styles.ass"
    If (-not (Test-Path -Path $Path)) {
        $StyleScript | Out-File -FilePath $Path -Encoding Ascii
    }
    Write-Host "Set Path to StyleScript"
    [String] $Path = Join-Path -Path $AppLocation -ChildPath "mplayer\mplayer\config"
    $Content = Get-Content -Path $Path
    $Content -replace "^ass\-styles\=(.*)$", "ass-styles=`"$AppLocation\mplayer\mplayer\styles.ass`"" | Out-File -FilePath $Path -Encoding Ascii
    Write-Host "Register Menu Entries Video"
    [String] $Path = "HKCU:\SOFTWARE\Classes\$AppName\Shell\Open\Command"
    If (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
    Set-ItemProperty -Path $Path -Name "(default)" -Value "`"$(Join-Path -Path $AppLocation -ChildPath "mplayer\mplayer.exe")`" `"%1`""
    [String] $Path = "HKCU:\SOFTWARE\Classes\$AppName\DefaultIcon"
    If (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
    Set-ItemProperty -Path $Path -Name "(default)" -Value $AppIconVideo
    [String] $Path = "HKCU:\SOFTWARE\Classes\$AppName"
    Set-ItemProperty -Path $Path -Name "FriendlyAppName" -Value $AppFriendlyName
    [hashtable] $Items = @{
        "AVDump2" = @{
            "Default" = "AniDB Information";
            "Command" = "`"$(Join-Path -Path $AppLocation -ChildPath "shell\avdump2.cmd")`" `"%1`"";
        };
        "Console" = @{
            "Default" = "Console";
            "Command" = "`"$(Join-Path -Path $AppLocation -ChildPath "shell\console.cmd")`" `"%1`"";
        };
        "No-ASS" = @{
            "Default" = "No Subtitle Styles";
            "Command" = "`"$(Join-Path -Path $AppLocation -ChildPath "mplayer\mplayer.exe")`" -noass `"%1`"";
        };
    }
    Foreach($Item in $Items.Keys) {
        [String] $Path = "HKCU:\SOFTWARE\Classes\$AppName\Shell\$Item\Command"
        If (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
        Set-ItemProperty -Path $Path -Name "(default)" -Value $Items.Item($Item).Command
        [String] $Path = "HKCU:\SOFTWARE\Classes\$AppName\Shell\$Item"
        Set-ItemProperty -Path $Path -Name "(default)" -Value $Items.Item($Item).Default
    }
    Write-Host "Register Menu Entries Audio"
    [String] $Path = "HKCU:\SOFTWARE\Classes\$AppName.Audio\Shell\Open\Command"
    If (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
    Set-ItemProperty -Path $Path -Name "(default)" -Value "`"$(Join-Path -Path $AppLocation -ChildPath "mplayer\mplayer.exe")`" `"%1`""
    [String] $Path = "HKCU:\SOFTWARE\Classes\$AppName.Audio\DefaultIcon"
    If (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
    Set-ItemProperty -Path $Path -Name "(default)" -Value $AppIconAudio
    [String] $Path = "HKCU:\SOFTWARE\Classes\$AppName.Audio"
    Set-ItemProperty -Path $Path -Name "FriendlyAppName" -Value $AppFriendlyName
    [hashtable] $Items = @{
        "Console" = @{
            "Default" = "Console";
            "Command" = "`"$(Join-Path -Path $AppLocation -ChildPath "shell\console.cmd")`" `"%1`"";
        };
        "Playlist-Audio" = @{
            "Default" = "Playlist Audio";
            "Command" = "`"$(Join-Path -Path $AppLocation -ChildPath "shell\playlist-audio.cmd")`" `"%1`"";
        };
        "Playlist-Video" = @{
            "Default" = "Playlist Video";
            "Command" = "`"$(Join-Path -Path $AppLocation -ChildPath "shell\playlist-video.cmd")`" `"%1`"";
        };
    }
    Foreach($Item in $Items.Keys) {
        [String] $Path = "HKCU:\SOFTWARE\Classes\$AppName.Playlist\Shell\$Item\Command"
        If (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
        Set-ItemProperty -Path $Path -Name "(default)" -Value $Items.Item($Item).Command
        [String] $Path = "HKCU:\SOFTWARE\Classes\$AppName.Playlist\Shell\$Item"
        Set-ItemProperty -Path $Path -Name "(default)" -Value $Items.Item($Item).Default
    }
    Write-Host "Register Menu Entries for Playlists"
    [String] $Path = "HKCU:\SOFTWARE\Classes\$AppName.Playlist\Shell\Open\Command"
    If (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
    Set-ItemProperty -Path $Path -Name "(default)" -Value "`"$(Join-Path -Path $AppLocation -ChildPath "shell\playlist-audio.cmd")`" `"%1`""
    [String] $Path = "HKCU:\SOFTWARE\Classes\$AppName.Playlist\DefaultIcon"
    If (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
    Set-ItemProperty -Path $Path -Name "(default)" -Value $AppIconAudio
    [String] $Path = "HKCU:\SOFTWARE\Classes\$AppName.Playlist"
    Set-ItemProperty -Path $Path -Name "FriendlyAppName" -Value $AppFriendlyName
    Write-Host "Register Association with Audio Files"
    Foreach($Extension in $ExtensionsAudio) {
        [String] $Path = "HKCU:\SOFTWARE\Classes\.$Extension"
        If (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
        Set-ItemProperty -Path $Path -Name "(default)" -Value "$AppName.Audio"
        Set-ItemProperty -Path $Path -Name "PerceivedType" -Value "audio"
    }
    Write-Host "Register Association with Video Files"
    Foreach($Extension in $ExtensionsVideo) {
        [String] $Path = "HKCU:\SOFTWARE\Classes\.$Extension"
        If (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
        Set-ItemProperty -Path $Path -Name "(default)" -Value $AppName
        Set-ItemProperty -Path $Path -Name "PerceivedType" -Value "video"
    }
    Write-Host "Register Association with Playlist Files"
    foreach($Extension in $ExtensionsPlaylist) {
        [String] $Path = "HKCU:\SOFTWARE\Classes\.$Extension"
        If (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
        Set-ItemProperty -Path $Path -Name "(default)" -Value "$AppName.Playlist"
        Set-ItemProperty -Path $Path -Name "PerceivedType" -Value "audio"
    }
    Write-Host "Register Submenu Entries"
    [hashtable] $Items = @{
        "Extract" = @{
            "MUIVerb" = "Extract Audio";
            "ExtendedSubCommandsKey" = "$AppName.Extract";
        };
        "3D" = @{
            "MUIVerb" = "3D Options";
            "ExtendedSubCommandsKey" = "$AppName.3D";
        };
        "Extras" = @{
            "MUIVerb" = "Extras";
            "ExtendedSubCommandsKey" = "$AppName.Extras";
        };
    }
    Foreach($Item in $Items.Keys) {
        [String] $Path = "HKCU:\SOFTWARE\Classes\$AppName\Shell\$Item"
        If (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
        Set-ItemProperty -Path $Path -Name "MUIVerb" -Value $Items.Item($Item).MuiVerb
        Set-ItemProperty -Path $Path -Name "ExtendedSubCommandsKey" -Value $Items.Item($Item).ExtendedSubCommandsKey
    }
    Write-Host "Register Submenu Entries for Extras"
    [hashtable] $Items = @{
        "Broken-Index" = @{
            "MUIVerb" = "Broken Index";
            "Command" = "`"$(Join-Path -Path $AppLocation -ChildPath "mplayer\mplayer.exe")`" -idx `"%1`"";
        };
        "Unicode-Filename" = @{
            "MUIVerb" = "Unicode Filename";
            "Command" = "`"$(Join-Path -Path $AppLocation -ChildPath "shell\play-unicode.cmd")`" `"%1`"";
        };
        "Switch-Audio-Subtitle" = @{
            "MUIVerb" = "Switch Audio and Subtitle";
            "Command" = "`"$(Join-Path -Path $AppLocation -ChildPath "mplayer\mplayer.exe")`" -aid 1 -sid 0 `"%1`"";
        };
        "Custom-Parameters" = @{
            "MUIVerb" = "Custom Parameters";
            "Command" = "`"$(Join-Path -Path $AppLocation -ChildPath "shell\play-parameters.cmd")`" `"%1`"";
        };
    }
    Foreach($Item in $Items.Keys) {
        [String] $Path = "HKCU:\SOFTWARE\Classes\$AppName.Extras\Shell\$Item\Command"
        If (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
        Set-ItemProperty -Path $Path -Name "(default)" -Value $Items.Item($Item).Command
        [String] $Path = "HKCU:\SOFTWARE\Classes\$AppName.Extras\Shell\$Item"
        Set-ItemProperty -Path $Path -Name "MUIVerb" -Value $Items.Item($Item).MuiVerb
    }
    Write-Host "Register Submenu Entries for Extract Audio"
    [hashtable] $Items = @{
        "Extract-AAC" = @{
            "MUIVerb" = "AAC";
            "Command" = "`"$(Join-Path -Path $AppLocation -ChildPath "shell\extract-aac.cmd")`" `"%1`"";
        };
        "Extract-MP3" = @{
            "MUIVerb" = "MP3";
            "Command" = "`"$(Join-Path -Path $AppLocation -ChildPath "shell\extract-mp3.cmd")`" `"%1`"";
        };
        "Extract-OGG" = @{
            "MUIVerb" = "OGG";
            "Command" = "`"$(Join-Path -Path $AppLocation -ChildPath "shell\extract-ogg.cmd")`" `"%1`"";
        };
    }
    Foreach($Item in $Items.Keys) {
        [String] $Path = "HKCU:\SOFTWARE\Classes\$AppName.Extract\Shell\$Item\Command"
        If (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
        Set-ItemProperty -Path $Path -Name "(default)" -Value $Items.Item($Item).Command
        [String] $Path = "HKCU:\SOFTWARE\Classes\$AppName.Extract\Shell\$Item"
        Set-ItemProperty -Path $Path -Name "MUIVerb" -Value $Items.Item($Item).MuiVerb
    }
    Write-Host "Register Submenu Entries for 3D Options"
    [hashtable] $Items = @{
        "Full-SBS" = @{
            "MUIVerb" = "Full Side by Side";
            "Command" = "`"$(Join-Path -Path $AppLocation -ChildPath "shell\3d-full-sbs.cmd")`" `"%1`"";
        };
        "Full-OU" = @{
            "MUIVerb" = "Full Over Under";
            "Command" = "`"$(Join-Path -Path $AppLocation -ChildPath "shell\3d-full-ou.cmd")`" `"%1`"";
        };
        "Half-SBS" = @{
            "MUIVerb" = "Half Side by Side";
            "Command" = "`"$(Join-Path -Path $AppLocation -ChildPath "shell\3d-half-sbs.cmd")`" `"%1`"";
        };
        "Half-OU" = @{
            "MUIVerb" = "Half Over Under";
            "Command" = "`"$(Join-Path -Path $AppLocation -ChildPath "shell\3d-half-ou.cmd")`" `"%1`"";
        };
        "Cyan-Magenta" = @{
            "MUIVerb" = "Cyan Magenta Side by Side";
            "Command" = "`"$(Join-Path -Path $AppLocation -ChildPath "shell\3d-cyan-magenta.cmd")`" `"%1`"";
        };
        "Green-Magenta" = @{
            "MUIVerb" = "Green Magenta Side by Side";
            "Command" = "`"$(Join-Path -Path $AppLocation -ChildPath "shell\3d-green-magenta.cmd")`" `"%1`"";
        };
    }
    Foreach($Item in $Items.Keys) {
        [String] $Path = "HKCU:\SOFTWARE\Classes\$AppName.3D\Shell\$Item\Command"
        If (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
        Set-ItemProperty -Path $Path -Name "(default)" -Value $Items.Item($Item).Command
        [String] $Path = "HKCU:\SOFTWARE\Classes\$AppName.3D\Shell\$Item"
        Set-ItemProperty -Path $Path -Name "MUIVerb" -Value $Items.Item($Item).MuiVerb
    }
    Write-Host "Ask for Screen Aspect Ratio"
    Add-Type -AssemblyName System.Windows.Forms
    $Bounds = ([System.Windows.Forms.Screen]::AllScreens)[0].Bounds
    $Width = $Bounds.Width
    $Height = $Bounds.Height
    [String] $Path = Join-Path -Path $AppLocation -ChildPath "mplayer\mplayer\config"
    $Content = Get-Content -Path $Path
    If ($Content -notcontains "monitoraspect=${Width}/${Height}" -and $Content -contains "monitoraspect=") {
        $Result = [System.Windows.Forms.MessageBox]::Show(
            "Your screen seems to have a resolution of ${Width}x${Height} pixels.`n`nDo you want this resolution for the screen aspect ratio?",
            $AppFriendlyName, 4, [System.Windows.Forms.MessageBoxIcon]::Question
        )
        If ($Result -eq "Yes") {
            $Content -replace "^monitoraspect=(.*)$", "monitoraspect=$Width/$Height" | Out-File -FilePath $Path -Encoding Ascii
        }
    }
    Write-Host "Show Install Message"
    $Result = [System.Windows.Forms.MessageBox]::Show(
       "$AppFriendlyName installed.",
       $AppFriendlyName, 0, [System.Windows.Forms.MessageBoxIcon]::Information
   )
   Write-Host "Show Balloon Message"
   Show-Balloon -TipTitle $AppFriendlyName -TipText "$AppFriendlyName installed."
}
