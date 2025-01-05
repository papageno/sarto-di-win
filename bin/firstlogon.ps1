#Requires -Version 5.1

Set-StrictMode -Off

& "$PSScriptRoot\.\key.ps1" -Config "$PSScriptRoot\..\etc\key.config"
& "$PSScriptRoot\.\share.ps1" -Config "$PSScriptRoot\..\etc\share.config"
& "$PSScriptRoot\.\connectivity.ps1"
& "$PSScriptRoot\.\winget.ps1" -Config "$PSScriptRoot\..\etc\winget.config"
& "$PSScriptRoot\.\connectivity.ps1"
& "$PSScriptRoot\.\scoop.ps1" -Config "$PSScriptRoot\..\etc\scoop.config"
