#Requires -Version 5.1

[CmdletBinding()]
param (
    [switch]$Clean
)

Set-StrictMode -Off

$Schemas = Get-Content -Path $(Get-Item -Path "$PSScriptRoot\..\lib\config\schema\*.schema.json") -Raw -Encoding utf8 | ConvertFrom-Json
$Schemas | ForEach-Object {
    $Config = @{
        Path  = Join-Path -Path "$PSScriptRoot\.." -ChildPath $_."`$id"
        Value = ConvertTo-Json -InputObject $_.default
    }
    if ($Clean) {
        if (Test-Path -Path $Config.Path -PathType Leaf) {
            Remove-Item -Path $Config.Path -Force
        }
    }
    elseif (!(Test-Path -Path $Config.Path -PathType Leaf)) {
        New-Item -Path $Config.Path -ItemType File -Value $Config.Value -Force
    }
}

$Containers = @(
    @{
        Path = "$PSScriptRoot\..\etc\driver.driver"
    } 
)
$Containers | ForEach-Object {
    if ($Clean) {
        if (Test-Path -Path $_.Path -PathType Container) {
            Remove-Item -Path $_.Path -Recurse -Force
        }
    }
    elseif (!(Test-Path -Path $_.Path -PathType Container)) {
        New-Item -Path $_.Path -ItemType Directory -Force
    }
}
