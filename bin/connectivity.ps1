#Requires -Version 5.1

Set-StrictMode -Off

$Timeout = 180 # seconds
$StartTime = Get-Date
$Connectivity = $false
while ((!$Connectivity) -and ($(Get-Date) -lt $StartTime.AddSeconds($Timeout))) {
    try {
        $NetConnectionProfiles = @(Get-NetConnectionProfile)
        if ($NetConnectionProfiles.Count -gt 0) {
            $Connectivities = $NetConnectionProfiles | ForEach-Object {
                ($_.IPv4Connectivity -eq "Internet") -or ($_.IPv6Connectivity -eq "Internet")
            }
            if ($Connectivities -contains $true) {
                $Connectivity = $true
            }
        }
    }
    catch {
        $Connectivity = $false
        Write-Error $_
    }
}
