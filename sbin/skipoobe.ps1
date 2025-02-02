#Requires -RunAsAdministrator
#Requires -Version 5.1

Set-StrictMode -Off

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

$ProvisioningPackage = @{
  Path = "$PSScriptRoot\.\skipoobe.ppkg"
}
$ProvisioningPackage.Destination = Join-Path -Path $(Get-Item -Path $ProvisioningPackage.Path).PSDrive.Root -ChildPath $(Get-Item -Path $ProvisioningPackage.Path).Name

if (!(Test-Path -Path $ProvisioningPackage.Destination -PathType Leaf)) {
  Copy-Item @ProvisioningPackage
}

$(Get-Item -Path $ProvisioningPackage.Destination).FullName

Write-Host "Press Windows key five times to apply provisioning package..."

Write-Host -NoNewline "Press Enter to continue..."
[Console]::ReadLine() | Out-Null
