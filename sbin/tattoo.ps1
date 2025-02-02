#Requires -RunAsAdministrator
#Requires -Version 5.1

[CmdletBinding()]
param (
    [string]$Config = "$PSScriptRoot\..\etc\tattoo.config",
    [switch]$NoRestart
)

Set-StrictMode -Off

Import-Module -Name "$PSScriptRoot\..\lib\config"
Import-Module -Name "$PSScriptRoot\..\lib\registry"
Import-Module -Name "$PSScriptRoot\..\lib\service"
Import-Module -Name "$PSScriptRoot\..\lib\feature"

$Tattoo = Convert-Config -Object $Config

if ($Tattoo.registry.Count -ne 0) {
    $UserProfiles = Get-CimInstance -ClassName Win32_UserProfile | Where-Object {
        ($_.Special -eq $false) -and ($null -ne $_.LocalPath)
    }
    $UserRegistryHives = @()
    $UserRegistryHives += $UserProfiles | ForEach-Object {
        @{
            Key  = Join-Path -Path "Registry::HKEY_USERS" -ChildPath $_.SID
            File = Join-Path -Path $_.LocalPath -ChildPath "NTUSER.DAT"
        }
    }
    $UserRegistryHives += @{
        Key  = Join-Path -Path "Registry::HKEY_USERS" -ChildPath $(New-Guid).Guid
        File = Join-Path -Path "$Env:SystemDrive\Users\Default" -ChildPath "NTUSER.DAT"
    }
    $UserRegistryHivesX = $UserRegistryHives | Where-Object {
        !(Test-Path -Path $_.Key)
    }
    $UserRegistryHivesX | ForEach-Object {
        reg.exe load $($_.Key -replace "^Registry::") $_.File
    }
    $Tattoo.registry | ForEach-Object {
        $Props = @{
            Path  = $_.path
            Name  = $_.name
            Type  = $_.type
            Value = $_.value
        }
        if ($_.path -match "^HKCU:\\(?:[^\\]+\\)*[^\\]*$") {
            $Props.Path = @()
            foreach ($Hive in $UserRegistryHives) {
                $Props.Path += Join-Path -Path $Hive.Key -ChildPath ($_.path -replace "^HKCU:\\")
            }
        }
        registry\Set-RegistryValue @Props
    }
    $UserRegistryHivesX | ForEach-Object {
        [gc]::Collect()
        reg.exe unload $($_.Key -replace "^Registry::")
    }
}

if ($Tattoo.service.Count -ne 0) {
    $Tattoo.service | ForEach-Object {
        $Props = @{
            Name        = $_.name
            StartupType = $_.startup_type
        }
        service\Set-Service @Props
    }
}

if ($Tattoo.feature.Count -ne 0) {
    $Tattoo.feature | ForEach-Object {
        $Props = @{
            FeatureName = $_
        }
        feature\Enable-WindowsOptionalFeature @Props
    }
}

# If script is not called from another script
if ($null -eq $MyInvocation.PSCommandPath) {
    if (!$NoRestart) {
        Restart-Computer -Confirm
    }
}
