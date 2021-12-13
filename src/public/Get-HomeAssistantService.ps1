
function Get-HomeAssistantService {
    [CmdletBinding()]
    param ()
    try {
        $RestQuery = Invoke-HomeAssistantQuery -Api 'services'
        Write-Output $RestQuery
    }
    catch {
        Throw $_
    }
}