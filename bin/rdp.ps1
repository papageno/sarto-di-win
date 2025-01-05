#Requires -Version 5.1

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$Address,
    [Parameter(Mandatory = $true)]
    [string]$Username,
    [Parameter(Mandatory = $true)]
    [securestring]$Password,
    [ValidatePattern("^.+\.rdp$")]
    [string]$SaveAs = "$($HOME)\Documents\$Username@$Address.rdp"
)

Set-StrictMode -Off

Import-Module -Name "$PSScriptRoot\..\lib\file"

$InputObject = @"
full address:s:$Address
username:s:$Username
"@
if ($Password.Length -ne 0) {
    $InputObject += $("`r`n" + "password 51:b:$(ConvertFrom-SecureString -SecureString $Password)")
}

$File = @{
    InputObject = $InputObject
    FilePath    = $SaveAs
}
file\Out-File @File
