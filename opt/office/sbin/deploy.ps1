# Requires -RunAsAdministrator
#Requires -Version 5.1

[CmdletBinding()]
param (
  [string]$Config = "$PSScriptRoot\..\etc\deploy.config\default.xml"
)

Set-StrictMode -Off

# https://github.com/ScoopInstaller/Nonportable/blob/master/bucket/office-365-apps-np.json
function Get-Url {
  $ProgressPreference = "SilentlyContinue"
  $Url = "https://www.microsoft.com/en-us/download/details.aspx?id=49117"
  $Regex = "download/([\w/-]+)(officedeploymenttool_[\d-]+\.exe)"
  $Content = $(Invoke-WebRequest -Uri $Url).Content
  if (!($Content -match $Regex)) {
    Write-Host "Could not match '$Regex' in '$Url'"
    return
  }
  $BaseUrl = "https://download.microsoft.com/download/"
  $Path = $Matches[1]
  $FileName = $Matches[2]
  $Url = $BaseUrl + $Path + $FileName
  return $Url
}

$Directory = Join-Path -Path $Env:TEMP -ChildPath $(New-Guid).Guid
New-Item -Path $Directory -ItemType Directory -Force | Out-Null

$Download = @{
  Uri = Get-Url
}
$Download.OutFile = Join-Path -Path $Env:TEMP -ChildPath $([System.IO.Path]::GetFileName($Download.Uri))

Invoke-WebRequest @Download

$Expand = @{
  FilePath     = $Download.OutFile
  ArgumentList = "/quiet /extract:$Directory"
}

Start-Process @Expand -Wait
Remove-Item -Path $Expand.FilePath

if ($Env:PROCESSOR_ARCHITECTURE -eq "AMD64") {
  Copy-Item -Path $Config -Destination $Directory
}
elseif ($Env:PROCESSOR_ARCHITECTURE -eq "x86") {
  $(Get-Content -Path $Config).Replace("OfficeClientEdition=`"64`"", "OfficeClientEdition=`"32`"") | Set-Content -Path "$Directory\$($(Get-Item -Path $Config).Name)"
}

$Install = @{
  FilePath     = Join-Path -Path $Directory -ChildPath "setup.exe"
  ArgumentList = "/configure $Directory\$($(Get-Item -Path $Config).Name)"
}

Start-Process @Install -Wait
Remove-Item -Path $Directory -Recurse -Force
