#Requires -RunAsAdministrator
#Requires -Version 5.1

Set-StrictMode -Off

# If current user is defaultuser0
if ($Env:USERNAME -eq "defaultuser0") {
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

  # Create a temporary directory
  $Directory = Join-Path -Path $Env:TEMP -ChildPath $(New-Guid).Guid
  New-Item -Path $Directory -ItemType Directory -Force | Out-Null
  # Copy provisioning package disk image to temporary directory
  Copy-Item -Path "$PSScriptRoot\.\skipoobe.ppkg.iso" -Destination $Directory
  # Mount provisioning package disk image
  $DiskImage = Mount-DiskImage -ImagePath "$Directory\skipoobe.ppkg.iso" -PassThru
  # Get provisioning package path
  $ProvisioningPackage = Get-Item -Path "$($($DiskImage | Get-Volume).DriveLetter):\skipoobe.ppkg"

  Write-Host "Press Windows key five times to install provisioning package ($($ProvisioningPackage.FullName))."
  Pause
}
