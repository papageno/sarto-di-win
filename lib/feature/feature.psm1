function Enable-WindowsOptionalFeature {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$FeatureName
    )
    process {
        Dism\Enable-WindowsOptionalFeature -Online -FeatureName $FeatureName -All -NoRestart
    }
}

Export-ModuleMember -Function Enable-WindowsOptionalFeature
