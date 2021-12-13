
function Get-HomeAssistantConfiguration {
    [CmdletBinding()]
    param ( )
    try {
        $RestQuery = Invoke-HomeAssistantQuery -Api 'config'
        Write-Output $RestQuery
    }
    catch {
        Throw $_
    }
}