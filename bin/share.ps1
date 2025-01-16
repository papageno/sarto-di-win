#Requires -Version 5.1

[CmdletBinding(DefaultParameterSetName = "Props")]
param (
    [Parameter(Mandatory = $true, ParameterSetName = "Props")]
    [string]$Address,
    [Parameter(Mandatory = $true, ParameterSetName = "Props")]
    [string]$Name,
    [Parameter(ParameterSetName = "Config")]
    [string]$Config = "$PSScriptRoot\..\etc\share.config"
)

Set-StrictMode -Off

Import-Module -Name "$PSScriptRoot\..\lib\config"
Import-Module -Name "$PSScriptRoot\..\lib\file"

if ($PSCmdlet.ParameterSetName -eq "Props") {
    $Directory = "$Env:APPDATA\Microsoft\Windows\Network Shortcuts\$Name"
    if (Test-Path -Path $Directory) {
        Remove-Item -Path $Directory -Recurse -Force
    }
    New-Item -Path $Directory -ItemType Directory
    $Props = @{
        Target    = $Address
        Directory = $Directory
        Name      = "target.lnk"
    }
    & "$PSScriptRoot\.\shortcut.ps1" @Props
    @"
[.ShellClassInfo]
CLSID2={0AFACED1-E828-11D1-9187-B532F1E9575D}
Flags=2
"@ | file\Out-File -FilePath "$Directory\desktop.ini"
    $(Get-Item -Path "$Directory\desktop.ini" -Force).Attributes += [System.IO.FileAttributes]::Hidden
    $(Get-Item -Path $Directory -Force).Attributes += [System.IO.FileAttributes]::ReadOnly
}

elseif ($PSCmdlet.ParameterSetName -eq "Config") {
    $Shares = Convert-Config -Object $Config
    if ($Shares.Count -ne 0) {
        $Shares | ForEach-Object {
            $Props = @{
                Address = $_.address
                Name    = $_.name
            }
            & $PSCommandPath @Props
        }
    }
}
