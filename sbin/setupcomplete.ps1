#Requires -RunAsAdministrator
#Requires -Version 5.1

Set-StrictMode -Off

& "$PSScriptRoot\.\driver.ps1" -Driver "$PSScriptRoot\..\etc\driver.driver"
& "$PSScriptRoot\..\bin\wifi.ps1" -Config "$PSScriptRoot\..\etc\wifi.config"
& "$PSScriptRoot\..\bin\connectivity.ps1"
& "$PSScriptRoot\.\user.ps1" -Config "$PSScriptRoot\..\etc\user.config"
& "$PSScriptRoot\.\tattoo.ps1" -Config "$PSScriptRoot\..\etc\tattoo.config"
& "$PSScriptRoot\.\printer.ps1" -Config "$PSScriptRoot\..\etc\printer.config"
& "$PSScriptRoot\.\time.ps1"
& "$PSScriptRoot\.\skipoobe.ps1"
