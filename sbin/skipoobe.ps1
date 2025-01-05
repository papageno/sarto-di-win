#Requires -RunAsAdministrator
#Requires -Version 5.1

Set-StrictMode -Off

& "$PSScriptRoot\.\tattoo.ps1" -Config @"
{
  "registry": [
    {
      "path": "HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon",
      "name": "AutoAdminLogon",
      "type": "DWord",
      "value": "0"
    },
    {
      "path": "HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon",
      "name": "SystemAutoLogon",
      "type": "DWord",
      "value": "0"
    },
    {
      "path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\OOBE",
      "name": "BypassNRO",
      "type": "DWord",
      "value": "1"
    },
    {
      "path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\OOBE",
      "name": "DefaultAccountAction",
      "type": "DWord",
      "value": "0"
    },
    {
      "path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\OOBE",
      "name": "LaunchUserOOBE",
      "type": "DWord",
      "value": "0"
    },
    {
      "path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\OOBE",
      "name": "DisablePrivacyExperience",
      "type": "DWord",
      "value": "1"
    }
  ]
}
"@

# If script is not called from another script
if ($null -eq $MyInvocation.PSCommandPath) {
  $User = $false
  while (!$User) {
    try {
      & "$PSScriptRoot\.\user.ps1" -Role "admin"
      $User = $true
    }
    catch {
      $User = $false
      Write-Error $_
    }
  }
}

Remove-LocalUser -Name "defaultuser0"

# If script is not called from another script
if ($null -eq $MyInvocation.PSCommandPath) {
  Restart-Computer -Confirm
}
