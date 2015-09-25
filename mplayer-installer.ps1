function Show-Balloon {
    param(
        [parameter(Mandatory=$true)] [string] $TipTitle,
        [parameter(Mandatory=$true)] [string] $TipText,
        [parameter(Mandatory=$false)] [ValidateSet("Info", "Error", "Warning")] [string] $TipIcon,
        [string] $Icon
    )
    process {
        [Void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
        $FormsNotifyIcon = New-Object -TypeName System.Windows.Forms.NotifyIcon
        if (-not $Icon) { $Icon = (Join-Path -Path $PSHOME -ChildPath "powershell.exe"); }
        $DrawingIcon = [System.Drawing.Icon]::ExtractAssociatedIcon($Icon)
        $FormsNotifyIcon.Icon = $DrawingIcon
        if (-not $TipIcon) { $TipIcon = "Info"; }
        $FormsNotifyIcon.BalloonTipIcon = $TipIcon;
        $FormsNotifyIcon.BalloonTipTitle = $TipTitle
        $FormsNotifyIcon.BalloonTipText = $TipText
        $FormsNotifyIcon.Visible = $True
        $FormsNotifyIcon.ShowBalloonTip(5000)
        Start-Sleep -Milliseconds 5000
        $FormsNotifyIcon.Dispose()
    }
}
function Add-ShortCut {
    param(
        [parameter(Mandatory=$true)] [string] $Link,
        [parameter(Mandatory=$true)] [string] $TargetPath,
        [string] $Arguments,
        [string] $IconLocation,
        [string] $WorkingDirectory,
        [string] $Description,
        [parameter(Mandatory=$false)] [ValidateSet("Normal", "Minimized", "Maximized")] [string] $WindowStyle
    )
    process {
        if (Test-Path -Path $TargetPath) {
            $WShell = New-Object -ComObject WScript.Shell
            $Shortcut = $WShell.CreateShortcut($Link)
            $Shortcut.TargetPath = $TargetPath
            if ($Arguments) { $Shortcut.Arguments = $Arguments; }
            if ($IconLocation) { $Shortcut.IconLocation = $IconLocation; }
            if ($WorkingDirectory) { $Shortcut.WorkingDirectory = $WorkingDirectory; }
            if ($WindowStyle) {
                Switch ($WindowStyle) {
                    "Normal" { [int] $WindowStyleNumerate = 4 };
                    "Minimized" { [int] $WindowStyleNumerate = 7 };
                    "Maximized" { [int] $WindowStyleNumerate = 3 };
                }
                $Shortcut.WindowStyle = $WindowStyleNumerate;
            }
            if ($Description) { $Shortcut.Description = $Description; }
            $Shortcut.Save()
        }
    }
}
function Remove-Shortcut {
    param([parameter(Mandatory=$true)] [string] $Link)
    process {
        if (Test-Path -Path $Link) { Remove-Item -Path $Link; }
    }
}
[string] $AppFriendlyName = "MPlayer - Movie Player"
[string] $AppName = "MPlayer"
[string] $AppDescription = "MPlayer is a movie player which runs on many systems."
if ($PSVersionTable.PSVersion.Major -lt 3) {
    [string] $PSScriptRoot = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
}
[string] $AppLocation = $PSScriptRoot
[string] $AppIcon = "%SystemRoot%\System32\imageres.dll,128"
[string] $AppIconAudio = "%SystemRoot%\System32\imageres.dll,125"
[string] $AppIconVideo = "%SystemRoot%\System32\imageres.dll,127"
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
if ($args.Length -gt 0) {
    if ($args[0].Contains("remove")) {
        Write-Host -Object "Remove Submenu Entries for Extract Audio"
        $Path = "HKCU:\SOFTWARE\Classes\$AppName.Extract"
        if (Test-Path -Path $Path) { Remove-Item -Path $Path -Recurse -Confirm:$false -Force; }
        Write-Host -Object "Remove Submenu Entries for 3D Options"
        $Path = "HKCU:\SOFTWARE\Classes\$AppName.3D"
        if (Test-Path -Path $Path) { Remove-Item -Path $Path -Recurse -Confirm:$false -Force; }
        Write-Host -Object "Remove Submenu Entries for Extras"
        $Path = "HKCU:\SOFTWARE\Classes\$AppName.Extras"
        if (Test-Path -Path $Path) { Remove-Item -Path $Path -Recurse -Confirm:$false -Force; }
        Write-Host -Object "Remove Submenu Entries for Playlists"
        $Path = "HKCU:\SOFTWARE\Classes\$AppName.Playlist"
        if (Test-Path -Path $Path) { Remove-Item -Path $Path -Recurse -Confirm:$false -Force; }
        Write-Host -Object "Remove File Associations"
        Foreach($Extension in $ExtensionsAudio) {
            $Path = "HKCU:\SOFTWARE\Classes\.$Extension"
            if (Test-Path -Path $Path) { Remove-Item -Path $Path -Recurse -Confirm:$false -Force; }
        }
        Foreach($Extension in $ExtensionsVideo) {
            $Path = "HKCU:\SOFTWARE\Classes\.$Extension"
            if (Test-Path -Path $Path) { Remove-Item -Path $Path -Recurse -Confirm:$false -Force; }
        }
        Foreach($Extension in $ExtensionsPlaylist) {
            $Path = "HKCU:\SOFTWARE\Classes\.$Extension"
            if (Test-Path -Path $Path) { Remove-Item -Path $Path -Recurse -Confirm:$false -Force; }
        }
        Write-Host -Object "Remove Menu Entries Video"
        $Path = "HKCU:\SOFTWARE\Classes\$AppName"
        if (Test-Path -Path $Path) { Remove-Item -Path $Path -Recurse -Confirm:$false -Force; }
        Write-Host -Object "Remove Menu Entries Audio"
        $Path = "HKCU:\SOFTWARE\Classes\$AppName.Audio"
        if (Test-Path -Path $Path) { Remove-Item -Path $Path -Recurse -Confirm:$false -Force; }
        Write-Host -Object "Remove Leftovers"
        $Path = "HKCU:\SOFTWARE\Classes\playlist.cmd"
        if (Test-Path -Path $Path) { Remove-Item -Path $Path -Recurse -Confirm:$false -Force; }
        $Path = "HKCU:\SOFTWARE\Classes\mplayer.exe"
        if (Test-Path -Path $Path) { Remove-Item -Path $Path -Recurse -Confirm:$false -Force; }
        $Path = "HKCU:\SOFTWARE\Classes\mplayer.exe.test"
        if (Test-Path -Path $Path) { Remove-Item -Path $Path -Recurse -Confirm:$false -Force; }
        Foreach($Extension in $ExtensionsAudio) {
            [string] $Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$Extension\OpenWithProgids"
            if (Test-Path -Path $Path) {
                Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$Extension\OpenWithProgids" -Name "mplayer.exe*" -ErrorAction SilentlyContinue
                Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$Extension\OpenWithProgids" -Name "MPlayer*" -ErrorAction SilentlyContinue
            }
        }
        Foreach($Extension in $ExtensionsVideo) {
            [string] $Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$Extension\OpenWithProgids"
            if (Test-Path -Path $Path) {
                Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$Extension\OpenWithProgids" -Name "mplayer.exe*" -ErrorAction SilentlyContinue
                Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$Extension\OpenWithProgids" -Name "MPlayer*" -ErrorAction SilentlyContinue
            }
        }
        Foreach($Extension in $ExtensionsPlaylist) {
            [string] $Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$Extension\OpenWithProgids"
            if (Test-Path -Path $Path) {
                Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$Extension\OpenWithProgids" -Name "mplayer.exe'" -ErrorAction SilentlyContinue
                Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$Extension\OpenWithProgids" -Name "MPlayer*" -ErrorAction SilentlyContinue
                Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.$Extension\OpenWithProgids" -Name "playlist.cmd" -ErrorAction SilentlyContinue
            }
        }
        Write-Host -Object "Remove SendTo ShortCut"
        Remove-ShortCut -Link (Join-Path -Path ([environment]::GetFolderPath("SendTo")) -ChildPath "$AppFriendlyName.lnk")
        Write-Host -Object "Show Install Message"
        Add-Type -AssemblyName System.Windows.Forms
        $Result = [System.Windows.Forms.MessageBox]::Show(
           "$AppFriendlyName removed.",
           $AppFriendlyName, 0, [System.Windows.Forms.MessageBoxIcon]::Information
        )
        Write-Host -Object "Show Balloon Message"
        Show-Balloon -TipTitle $AppFriendlyName -TipText "MPlayer - Movie Player removed."
    }
} Else {
    Write-Host -Object "Add SendTo ShortCut"
    Add-ShortCut -Link (Join-Path -Path ([environment]::GetFolderPath("SendTo")) -ChildPath "$AppFriendlyName.lnk") `
                 -TargetPath (Join-Path -Path $AppLocation -ChildPath "mplayer\mplayer.exe") `
                 -Arguments "`"%1`"" -IconLocation $AppIcon -WorkingDirectory $PSScriptRoot -WindowStyle Normal `
                 -Description $AppDescription
    Write-Host -Object "Set Path to Application Location"
    Foreach($Item in (Get-Item -Path "$AppLocation\shell\*.cmd")) {
        $Content = Get-Content -Path $Item.FullName
        $Content -replace "^set\ mplayer\=(.*)$", "set mplayer=$AppLocation" | Out-File -FilePath $Item.FullName -Encoding Ascii
    }
    Write-Host -Object "Add Mouse Bindings"
    [Array] $MouseBindings = @(
        "MOUSE_BTN1 pause",
        "MOUSE_BTN2 vo_fullscreen"
    )
    [string] $Path = Join-Path -Path $AppLocation -ChildPath "mplayer\mplayer\input.conf"
    if (Test-Path -Path $Path) {
        $Content = Get-Content -Path $Path
        Foreach($MouseBinding in $MouseBindings) {
            if ($Content -notmatch $MouseBinding) {
                Add-Content -Path $Path -Value $MouseBinding -Force
            }
        }
    }
    Write-Host -Object "Install StyleScript"
    [string] $StyleScript = "[Script Info]
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
    [string] $Path = Join-Path -Path $AppLocation -ChildPath "mplayer\mplayer\styles.ass"
    if (-not (Test-Path -Path $Path)) {
        $StyleScript | Out-File -FilePath $Path -Encoding Ascii
    }
    Write-Host -Object "Set Path to StyleScript"
    [string] $Path = Join-Path -Path $AppLocation -ChildPath "mplayer\mplayer\config"
    $Content = Get-Content -Path $Path
    $Content -replace "^ass\-styles\=(.*)$", "ass-styles=`"$AppLocation\mplayer\mplayer\styles.ass`"" | Out-File -FilePath $Path -Encoding Ascii
    Write-Host -Object "Register Menu Entries Video"
    [string] $Path = "HKCU:\SOFTWARE\Classes\$AppName\Shell\Open\Command"
    if (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
    Set-ItemProperty -Path $Path -Name "(default)" -Value "`"$(Join-Path -Path $AppLocation -ChildPath "mplayer\mplayer.exe")`" `"%1`""
    [string] $Path = "HKCU:\SOFTWARE\Classes\$AppName\DefaultIcon"
    if (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
    Set-ItemProperty -Path $Path -Name "(default)" -Value $AppIconVideo
    [string] $Path = "HKCU:\SOFTWARE\Classes\$AppName"
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
        [string] $Path = "HKCU:\SOFTWARE\Classes\$AppName\Shell\$Item\Command"
        if (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
        Set-ItemProperty -Path $Path -Name "(default)" -Value $Items.Item($Item).Command
        [string] $Path = "HKCU:\SOFTWARE\Classes\$AppName\Shell\$Item"
        Set-ItemProperty -Path $Path -Name "(default)" -Value $Items.Item($Item).Default
    }
    Write-Host -Object "Register Menu Entries Audio"
    [string] $Path = "HKCU:\SOFTWARE\Classes\$AppName.Audio\Shell\Open\Command"
    if (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
    Set-ItemProperty -Path $Path -Name "(default)" -Value "`"$(Join-Path -Path $AppLocation -ChildPath "mplayer\mplayer.exe")`" `"%1`""
    [string] $Path = "HKCU:\SOFTWARE\Classes\$AppName.Audio\DefaultIcon"
    if (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
    Set-ItemProperty -Path $Path -Name "(default)" -Value $AppIconAudio
    [string] $Path = "HKCU:\SOFTWARE\Classes\$AppName.Audio"
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
        [string] $Path = "HKCU:\SOFTWARE\Classes\$AppName.Playlist\Shell\$Item\Command"
        if (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
        Set-ItemProperty -Path $Path -Name "(default)" -Value $Items.Item($Item).Command
        [string] $Path = "HKCU:\SOFTWARE\Classes\$AppName.Playlist\Shell\$Item"
        Set-ItemProperty -Path $Path -Name "(default)" -Value $Items.Item($Item).Default
    }
    Write-Host -Object "Register Menu Entries for Playlists"
    [string] $Path = "HKCU:\SOFTWARE\Classes\$AppName.Playlist\Shell\Open\Command"
    if (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
    Set-ItemProperty -Path $Path -Name "(default)" -Value "`"$(Join-Path -Path $AppLocation -ChildPath "shell\playlist-audio.cmd")`" `"%1`""
    [string] $Path = "HKCU:\SOFTWARE\Classes\$AppName.Playlist\DefaultIcon"
    if (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
    Set-ItemProperty -Path $Path -Name "(default)" -Value $AppIconAudio
    [string] $Path = "HKCU:\SOFTWARE\Classes\$AppName.Playlist"
    Set-ItemProperty -Path $Path -Name "FriendlyAppName" -Value $AppFriendlyName
    Write-Host -Object "Register Association with Audio Files"
    Foreach($Extension in $ExtensionsAudio) {
        [string] $Path = "HKCU:\SOFTWARE\Classes\.$Extension"
        if (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
        Set-ItemProperty -Path $Path -Name "(default)" -Value "$AppName.Audio"
        Set-ItemProperty -Path $Path -Name "PerceivedType" -Value "audio"
    }
    Write-Host -Object "Register Association with Video Files"
    Foreach($Extension in $ExtensionsVideo) {
        [string] $Path = "HKCU:\SOFTWARE\Classes\.$Extension"
        if (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
        Set-ItemProperty -Path $Path -Name "(default)" -Value $AppName
        Set-ItemProperty -Path $Path -Name "PerceivedType" -Value "video"
    }
    Write-Host -Object "Register Association with Playlist Files"
    foreach($Extension in $ExtensionsPlaylist) {
        [string] $Path = "HKCU:\SOFTWARE\Classes\.$Extension"
        if (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
        Set-ItemProperty -Path $Path -Name "(default)" -Value "$AppName.Playlist"
        Set-ItemProperty -Path $Path -Name "PerceivedType" -Value "audio"
    }
    Write-Host -Object "Register Submenu Entries"
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
        [string] $Path = "HKCU:\SOFTWARE\Classes\$AppName\Shell\$Item"
        if (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
        Set-ItemProperty -Path $Path -Name "MUIVerb" -Value $Items.Item($Item).MuiVerb
        Set-ItemProperty -Path $Path -Name "ExtendedSubCommandsKey" -Value $Items.Item($Item).ExtendedSubCommandsKey
    }
    Write-Host -Object "Register Submenu Entries for Extras"
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
        [string] $Path = "HKCU:\SOFTWARE\Classes\$AppName.Extras\Shell\$Item\Command"
        if (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
        Set-ItemProperty -Path $Path -Name "(default)" -Value $Items.Item($Item).Command
        [string] $Path = "HKCU:\SOFTWARE\Classes\$AppName.Extras\Shell\$Item"
        Set-ItemProperty -Path $Path -Name "MUIVerb" -Value $Items.Item($Item).MuiVerb
    }
    Write-Host -Object "Register Submenu Entries for Extract Audio"
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
        [string] $Path = "HKCU:\SOFTWARE\Classes\$AppName.Extract\Shell\$Item\Command"
        if (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
        Set-ItemProperty -Path $Path -Name "(default)" -Value $Items.Item($Item).Command
        [string] $Path = "HKCU:\SOFTWARE\Classes\$AppName.Extract\Shell\$Item"
        Set-ItemProperty -Path $Path -Name "MUIVerb" -Value $Items.Item($Item).MuiVerb
    }
    Write-Host -Object "Register Submenu Entries for 3D Options"
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
        [string] $Path = "HKCU:\SOFTWARE\Classes\$AppName.3D\Shell\$Item\Command"
        if (-not (Test-Path -Path $Path)) { New-Item -Path $Path -Force; }
        Set-ItemProperty -Path $Path -Name "(default)" -Value $Items.Item($Item).Command
        [string] $Path = "HKCU:\SOFTWARE\Classes\$AppName.3D\Shell\$Item"
        Set-ItemProperty -Path $Path -Name "MUIVerb" -Value $Items.Item($Item).MuiVerb
    }
    Write-Host -Object "Ask for Screen Aspect Ratio"
    Add-Type -AssemblyName System.Windows.Forms
    $Bounds = ([System.Windows.Forms.Screen]::AllScreens)[0].Bounds
    $Width = $Bounds.Width
    $Height = $Bounds.Height
    [string] $Path = Join-Path -Path $AppLocation -ChildPath "mplayer\mplayer\config"
    $Content = Get-Content -Path $Path
    if ($Content -notcontains "monitoraspect=${Width}/${Height}" -and $Content -contains "monitoraspect=") {
        $Result = [System.Windows.Forms.MessageBox]::Show(
            "Your screen seems to have a resolution of ${Width}x${Height} pixels.`n`nDo you want this resolution for the screen aspect ratio?",
            $AppFriendlyName, 4, [System.Windows.Forms.MessageBoxIcon]::Question
        )
        if ($Result -eq "Yes") {
            $Content -replace "^monitoraspect=(.*)$", "monitoraspect=$Width/$Height" | Out-File -FilePath $Path -Encoding Ascii
        }
    }
    Write-Host -Object "Show Install Message"
    $Result = [System.Windows.Forms.MessageBox]::Show(
       "$AppFriendlyName installed.",
       $AppFriendlyName, 0, [System.Windows.Forms.MessageBoxIcon]::Information
   )
   Write-Host -Object "Show Balloon Message"
   Show-Balloon -TipTitle $AppFriendlyName -TipText "$AppFriendlyName installed."
}
