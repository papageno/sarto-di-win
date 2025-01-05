#Requires -Version 5.1

[CmdletBinding(DefaultParameterSetName = "Props")]
param (
    [Parameter(Mandatory = $true, ParameterSetName = "Props")]
    [string]$Domain,
    [Parameter(Mandatory = $true, ParameterSetName = "Props")]
    [string]$Username,
    [Parameter(Mandatory = $true, ParameterSetName = "Props")]
    [securestring]$Password,
    [Parameter(ParameterSetName = "Config")]
    [string]$Config = "$PSScriptRoot\..\etc\key.config"
)

Set-StrictMode -Off

if ($PSCmdlet.ParameterSetName -eq "Props") {
    cmdkey.exe /add:$Domain /user:$Username /pass:$([System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)))
}

elseif ($PSCmdlet.ParameterSetName -eq "Config") {
    Import-Module -Name "$PSScriptRoot\..\lib\config"
    $keys = Convert-Config -Object $Config
    if ($keys.Count -ne 0) {
        $keys | ForEach-Object {
            $Props = @{
                Domain   = $_.domain
                Username = $_.username
                Password = $_.password | ConvertTo-SecureString -AsPlainText -Force
            }
            & $PSCommandPath @Props
        }
    }
}
