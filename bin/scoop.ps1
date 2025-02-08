#Requires -Version 5.1

[CmdletBinding()]
param (
    [string]$Config = "$PSScriptRoot\..\etc\scoop.config"
)

Set-StrictMode -Off

Import-Module -Name "$PSScriptRoot\..\lib\config"

if (!$(Get-Command -Name scoop.ps1 -ErrorAction SilentlyContinue)) {
    Invoke-RestMethod -Uri "https://get.scoop.sh" | Invoke-Expression
    scoop alias add refresh "scoop update; scoop update *; scoop cleanup *; scoop cache rm *"
    scoop install main/git
}

scoop update
scoop update *
scoop cleanup *
scoop cache rm *

$Apps = Convert-Config -Object $Config

if ($Apps.Count -ne 0) {
    $Apps | Select-Object -ExpandProperty "bucket" -Unique | ForEach-Object {
        scoop bucket add $_
    }
    $Apps | ForEach-Object {
        scoop install "$($_.bucket)/$($_.app)"
    }
    scoop cache rm *
}
