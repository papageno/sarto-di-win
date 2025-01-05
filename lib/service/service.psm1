Add-Type -AssemblyName System.ServiceProcess
function Set-Service {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [Parameter(Mandatory = $true)]
        [System.ServiceProcess.ServiceStartMode]$StartupType
    )
    process {
        $Props = @{
            Name        = $Name
            StartupType = $StartupType
        }
        Microsoft.PowerShell.Management\Set-Service @Props
        if ($StartupType -eq [System.ServiceProcess.ServiceStartMode]::Disabled) {
            Stop-Service -Name $Name -Force
        }
        elseif ($StartupType -eq [System.ServiceProcess.ServiceStartMode]::Manual) {
            Stop-Service -Name $Name -Force
        }
    }
}
Export-ModuleMember -Function Set-Service
