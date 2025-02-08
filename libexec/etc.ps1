#Requires -Version 5.1

[CmdletBinding()]
param (
    [switch]$Clean
)

Set-StrictMode -Off

$Schemas = Get-Content -Path $(Get-Item -Path "$PSScriptRoot\..\lib\config\schema\*.schema.json") -Raw -Encoding utf8 | ConvertFrom-Json

$Schemas | ForEach-Object {
    $Config = @{
        Path    = Join-Path -Path "$PSScriptRoot\.." -ChildPath $_."`$id"
        Content = ConvertTo-Json -InputObject $_.default
    }
    if ($Clean) {
        if (Test-Path -Path $Config.Path -PathType Leaf) {
            Remove-Item -Path $Config.Path -Force
        }
    }
    elseif (!(Test-Path -Path $Config.Path -PathType Leaf)) {
        New-Item -Path $Config.Path -ItemType File -Value $Config.Content -Force
    }
}

$Schemas = @(
    "$PSScriptRoot\..\etc\driver.driver"
)

$Schemas | ForEach-Object {
    if ($Clean) {
        if (Test-Path -Path $_ -PathType Container) {
            Remove-Item -Path $_ -Recurse -Force
        }
    }
    elseif (!(Test-Path -Path $_ -PathType Container)) {
        New-Item -Path $_ -ItemType Directory -Force
    }
}
