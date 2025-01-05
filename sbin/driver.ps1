#Requires -RunAsAdministrator
#Requires -Version 5.1

[CmdletBinding()]
param (
    [string]$Driver = "$PSScriptRoot\..\etc\driver.driver"
)

Set-StrictMode -Off

if (Test-Path -Path $Driver -PathType Leaf) {
    pnputil.exe /add-driver $(Get-Item -Path $Driver).FullName /install
}

elseif (Test-Path -Path $Driver -PathType Container) {
    Get-ChildItem -Path $Driver -Filter "*.inf" -File -Recurse | ForEach-Object {
        & $PSCommandPath -Driver $_.FullName
    }
}
