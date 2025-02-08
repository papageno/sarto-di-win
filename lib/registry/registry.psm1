function Set-RegistryValue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Path,
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [Parameter(Mandatory = $true)]
        [Microsoft.Win32.RegistryValueKind]$Type,
        [Parameter(Mandatory = $true)]
        [System.Object]$Value
    )
    process {
        $Path | ForEach-Object {
            if (!(Test-Path -Path $_)) {
                New-Item -Path $_ -Force
            }
            $Props = @{
                Path         = $_
                Name         = $Name
                PropertyType = $Type
                Value        = $Value
            }
            New-ItemProperty @Props -Force
        }
    }
}

Export-ModuleMember -Function Set-RegistryValue

function ConvertTo-Win32RegistryValueKind {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Microsoft.Win32.RegistryValueKind]$Type
    )
    process {
        $RegistryValueKind = @{
            [Microsoft.Win32.RegistryValueKind]::Unknown      = 0 # "REG_NONE"
            [Microsoft.Win32.RegistryValueKind]::String       = "REG_SZ"
            [Microsoft.Win32.RegistryValueKind]::ExpandString = "REG_EXPAND_SZ"
            [Microsoft.Win32.RegistryValueKind]::Binary       = "REG_BINARY"
            [Microsoft.Win32.RegistryValueKind]::DWord        = "REG_DWORD"
            [Microsoft.Win32.RegistryValueKind]::MultiString  = "REG_MULTI_SZ"
            [Microsoft.Win32.RegistryValueKind]::QWord        = "REG_QWORD"
            [Microsoft.Win32.RegistryValueKind]::None         = $null
        }
        return $RegistryValueKind[$Type]
    }
}

Export-ModuleMember -Function ConvertTo-Win32RegistryValueKind
