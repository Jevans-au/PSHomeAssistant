
function Get-HomeAssistantState {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $entity
    )
    try {
        $RestQuery = Invoke-HomeAssistantQuery -Api 'states'
        If($entity){
            $RestQuery = $RestQuery | Where-Object {$_.entity_id -like "*$entity*"}
        }
        If($RestQuery){
            Write-Output $RestQuery
        }
        Else{
            Write-Error "An entity with the likeness of [$entity] could not be found in Home Assistant"
        }
    }
    catch {
        Throw $_
    }
}