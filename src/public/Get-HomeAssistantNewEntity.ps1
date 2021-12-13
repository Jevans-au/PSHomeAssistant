
function Get-HomeAssistantNewEntity {
    [CmdletBinding()]
    param ( )
    try {
        $RestQuery = Invoke-HomeAssistantQuery -Api 'states'
        If($RestQuery){
            Write-Host "[$($RestQuery.count)] entities found in Home Assistant instance [$($PSHomeAssistantParams.ipaddress)]."
            $PreviousStateCsvPath = Get-ChildItem -Path "$PSScriptRoot\..\data\" | Where-Object {$_.name -like "*Entity*.csv"} | Sort-Object LastWriteTime -Descending
            $PreviousState = Import-Csv -Path $PreviousStateCsvPath[0].FullName
            Write-Host "[$($PreviousState.count)] entities found in most recent Home Assistant entity cache [$($PreviousStateCsvPath[0].LastWriteTime.ToString('dd-MM-yyyy HH-mm-ss'))]."
            If($RestQuery.count -gt $PreviousState.count){
                ForEach($Entity in $RestQuery){
                    If($PreviousState.entity_id -notcontains $entity.entity_id){
                        $Entity
                    }
                }
            }
        }
    }
    catch {
        Throw $_
    }
}