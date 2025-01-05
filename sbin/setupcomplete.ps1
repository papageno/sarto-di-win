#Requires -RunAsAdministrator
#Requires -Version 5.1

Set-StrictMode -Off

& "$PSScriptRoot\.\driver.ps1" -Driver "$PSScriptRoot\..\etc\driver.driver"
& "$PSScriptRoot\..\bin\wifi.ps1" -Config "$PSScriptRoot\..\etc\wifi.config"
& "$PSScriptRoot\.\printer.ps1" -Config "$PSScriptRoot\..\etc\printer.config"
& "$PSScriptRoot\..\bin\connectivity.ps1"
& "$PSScriptRoot\.\tattoo.ps1" -Config "$PSScriptRoot\..\etc\tattoo.config"
& "$PSScriptRoot\..\bin\connectivity.ps1"
& "$PSScriptRoot\.\time.ps1"
& "$PSScriptRoot\.\user.ps1" -Config "$PSScriptRoot\..\etc\user.config"
& "$PSScriptRoot\.\skipoobe.ps1"

# If script is not called from another script
if ($null -eq $MyInvocation.PSCommandPath) {
    Restart-Computer -Confirm
}
