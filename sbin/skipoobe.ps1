#Requires -RunAsAdministrator
#Requires -Version 5.1

Set-StrictMode -Off

# If script is not called from another script
if ($null -eq $MyInvocation.PSCommandPath) {
  $User = $false
  while (!$User) {
    try {
      # Create user with "admin" role
      & "$PSScriptRoot\.\user.ps1" -Role "admin"
      $User = $true
    }
    catch {
      $User = $false
      Write-Error $_
    }
  }
}

$ProvisioningPackage = @{
  Path = "$PSScriptRoot\.\skipoobe.ppkg"
}

# Set destination path to drive root for provisioning package
$ProvisioningPackage.Destination = Join-Path -Path $(Get-Item -Path $ProvisioningPackage.Path).PSDrive.Root -ChildPath $(Get-Item -Path $ProvisioningPackage.Path).Name

# Copy provisioning package
Copy-Item @ProvisioningPackage -Force

Write-Host "Press Windows key five times to install provisioning package $(Get-Item -Path $ProvisioningPackage.Destination)"

Pause
