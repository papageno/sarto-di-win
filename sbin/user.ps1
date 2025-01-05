#Requires -RunAsAdministrator
#Requires -Version 5.1

[CmdletBinding(DefaultParameterSetName = "Props")]
param (
    [Parameter(Mandatory = $true, ParameterSetName = "Props")]
    [string]$Handle,
    [Parameter(Mandatory = $true, ParameterSetName = "Props")]
    [AllowEmptyString()]
    [string]$Name,
    [Parameter(Mandatory = $true, ParameterSetName = "Props")]
    [AllowNull()]
    [securestring]$Password,
    [Parameter(ParameterSetName = "Props")]
    [ValidateSet("admin", "user")]
    [string]$Role = "user",
    [Parameter(ParameterSetName = "Config")]
    [string]$Config = "$PSScriptRoot\..\etc\user.config"
)

Set-StrictMode -Off

$Group = @{
    admin = "Administrators"
    user  = "Users"
}

if ($PSCmdlet.ParameterSetName -eq "Props") {
    $Props = @{
        Name = $Handle
    }
    if ($Name.Length -ne 0) {
        $Props.FullName = $Name
    }
    if ($Password.Length -ne 0) {
        $Props.Password = $Password
    }
    else {
        $Props.NoPassword = $true
    }
    New-LocalUser @Props | Add-LocalGroupMember -Group $Group[$Role]
    Set-LocalUser -Name $Handle -PasswordNeverExpires $true
}

elseif ($PSCmdlet.ParameterSetName -eq "Config") {
    Import-Module -Name "$PSScriptRoot\..\lib\config"
    $Users = Convert-Config -Object $Config
    if ($Users.Count -ne 0) {
        $Users | ForEach-Object {
            $Props = @{
                Handle = $_.handle
                Name   = $_.name
                Role   = $_.role
            }
            if ($_.password.Length -ne 0) {
                $Props.Password = $_.password | ConvertTo-SecureString -AsPlainText -Force
            }
            else {
                $Props.Password = $null
            }
            & $PSCommandPath @Props
        }
    }
    else {
        & $PSCommandPath -Role "admin"
    }
}
