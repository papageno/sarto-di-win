# https://github.com/ScoopInstaller/Scoop/blob/859d1db51bcc840903d5280567846ae2f7207ca2/lib/core.ps1#L1391C1-L1416C2
function Out-File {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Alias("Path")]
        [string] $FilePath,
        [switch] $Append,
        [switch] $NoNewLine,
        [Parameter(ValueFromPipeline = $true)]
        [psobject] $InputObject
    )
    process {
        if ($Append) {
            [System.IO.File]::AppendAllText($FilePath, $InputObject)
        }
        else {
            if (!$NoNewLine) {
                # Ref: https://stackoverflow.com/questions/5596982
                # Performance Note: `WriteAllLines` throttles memory usage while
                # `WriteAllText` needs to keep the complete string in memory.
                [System.IO.File]::WriteAllLines($FilePath, $InputObject)
            }
            else {
                # However `WriteAllText` does not add ending newline.
                [System.IO.File]::WriteAllText($FilePath, $InputObject)
            }
        }
    }
}
Export-ModuleMember -Function Out-File
