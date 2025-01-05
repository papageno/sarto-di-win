#Requires -RunAsAdministrator
#Requires -Version 5.1

[CmdletBinding(DefaultParameterSetName = "Props")]
param (
    [Parameter(Mandatory = $true, ParameterSetName = "Props")]
    [string]$Name,
    [Parameter(Mandatory = $true, ParameterSetName = "Props")]
    [string]$Address,
    [Parameter(Mandatory = $true, ParameterSetName = "Props")]
    [string]$Driver,
    [Parameter(ParameterSetName = "Props")]
    [scriptblock]$PreInstall,
    [Parameter(ParameterSetName = "Props")]
    [scriptblock]$PostInstall,
    [Parameter(ParameterSetName = "Config")]
    [string]$Config = "$PSScriptRoot\..\etc\printer.config"
)

Set-StrictMode -Off

Restart-Service -Name "Spooler" -Force

if ($PSCmdlet.ParameterSetName -eq "Props") {
    if (!$(Get-PrinterPort | Where-Object { $_.PrinterHostAddress -eq $Address })) {
        Add-PrinterPort -Name $Address -PrinterHostAddress $Address
    }
    if (!$(Get-PrinterDriver -Name $Driver -ErrorAction SilentlyContinue)) {
        Add-PrinterDriver -Name $Driver
    }
    if (!$(Get-Printer -Name $Name -ErrorAction SilentlyContinue)) {
        if ($PreInstall -ne $null) {
            Invoke-Command -ScriptBlock $PreInstall
        }
        Add-Printer -Name $Name -DriverName $Driver -PortName $Address
        Get-Printer -Name $Name | Select-Object -Property Name, Type, PortName, DriverName | Format-List
        if ($PostInstall -ne $null) {
            Invoke-Command -ScriptBlock $PostInstall
        }
    }
}

elseif ($PSCmdlet.ParameterSetName -eq "Config") {
    Import-Module -Name "$PSScriptRoot\..\lib\config"
    $Printers = Convert-Config -Object $Config
    if ($Printers.Count -ne 0) {
        $Printers | ForEach-Object {
            $Props = @{
                Name        = $_.name
                Address     = $_.address
                Driver      = $_.driver
                PreInstall  = [scriptblock]::Create($_.pre_install -join "`r`n")
                PostInstall = [scriptblock]::Create($_.post_install -join "`r`n")
            }
            & $PSCommandPath @Props
        }
    }
}
