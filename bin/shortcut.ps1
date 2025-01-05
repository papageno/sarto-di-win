#Requires -Version 5.1

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$Target,
    # XXX: `$Directory` cannot handle unicode characters.
    [ValidateScript( { Test-Path -Path $_ -PathType Container } )]
    [string]$Directory = "$($HOME)\Desktop",
    # BUG: if `$Directory` is a UNC path, e.g., "\\192.168.1.1\share",
    # `$Name` might output empty file name in PowerShell 5.1.
    [ValidatePattern("^.+\.lnk$")]
    [string]$Name = $([System.IO.Path]::GetFileName($Target)) + ".lnk",
    [string[]]$ArgumentList
)

Set-StrictMode -Off

$Destination = Join-Path -Path $Env:TEMP -ChildPath $(
    $(New-Guid).Guid + $([System.IO.Path]::GetExtension($Name))
)
$Shell = New-Object -ComObject WScript.Shell
$Shortcut = $Shell.CreateShortcut($Destination)
$Shortcut.TargetPath = $Target
$Shortcut.Arguments = $($ArgumentList -join " ")
$Shortcut.Save()
$Destination = Join-Path -Path $Directory -ChildPath $Name
Move-Item -Path $Shortcut.FullName -Destination $Destination -Force
