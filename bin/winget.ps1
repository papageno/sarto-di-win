#Requires -Version 5.1

[CmdletBinding()]
param (
    [string]$Config = "$PSScriptRoot\..\etc\winget.config"
)

Set-StrictMode -Off

Import-Module -Name "$PSScriptRoot\..\lib\config"

# if (!$(Get-Command -Name winget.exe -ErrorAction SilentlyContinue)) {
#     Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
# }

# if ($(winget.exe --version) -ne $(Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/winget-cli/releases/latest").tag_name) {
#     Add-AppxPackage -Path "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx"
#     Add-AppxPackage -Path "https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx"
#     Add-AppxPackage -Path "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -ForceApplicationShutdown
# }

if (Get-Command -Name winget.exe -ErrorAction SilentlyContinue) {
    winget.exe upgrade --all --exact --silent --accept-package-agreements --accept-source-agreements

    $Apps = Convert-Config -Object $Config
    if ($Apps.Count -ne 0) {
        $Apps | ForEach-Object {
            winget.exe install --id $_.id --source $_.source --exact --silent --accept-package-agreements --accept-source-agreements
        }
    }
}
