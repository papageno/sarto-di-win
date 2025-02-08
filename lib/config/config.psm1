function Convert-Config {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [psobject]$Object
    )
    process {
        if (Test-Path -Path $Object -PathType Leaf) {
            Get-Content -Path $Object -Raw -Encoding utf8 | ConvertFrom-Json
        }
        else {
            ConvertFrom-Json -InputObject $Object
        }
    }
}

Export-ModuleMember -Function Convert-Config
