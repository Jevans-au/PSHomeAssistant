
function Get-HomeAssistantEntity {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $State,
        [Parameter()]
        [switch]
        $SetCache,
        [Parameter()]
        [switch]
        $ClearCache
    )
    try {
        $RestQuery = Invoke-HomeAssistantQuery -Api 'states' | Where-Object {$_.state -match $State}
        If($State){
            $RestQuery = $RestQuery | Where-Object {$_.state -match $State}
        }
        If($RestQuery){
            Write-Output $RestQuery
            $RestQueryTimestamp = Get-Date -Format 'yyyy-MM-dd-hh-ss'
            If($SetCache){
                $RestQuery | Export-Csv -Path "$PSScriptRoot\..\Data\$($RestQueryTimestamp)-EntityState.csv"
            }
        }
        Else{
            Write-Warning "Unable to retrieve entities from Home Assistant instance [$IpAddress]"
            If($ClearCache){
                $ClearCachePrompt = Read-Host "No entities were retrieved.`r`nWould you like to proceed with clearing entity cache? ('Y' to confirm, any other character\enter to exit)"
            }
        }
        If($ClearCache -and $ClearCachePrompt -ne 'Y'){
            $EntityCacheItem = Get-ChildItem -Path "$PSScriptRoot\..\Data\"
                Where-Object {$_.name -like "-EntityState.csv" -and $_.name -notlike "$($RestQueryTimestamp)-EntityState.csv"}
            Write-Host "[$($EntityCacheItem.count)] entity cache items found"
            $EntityCacheItem | ForEach-Object {
                If($_.Name -notlike "*$RestQueryTimeStamp*"){
                    Remove-Item -Path $_.FullName -Force -Confirm:$false
                }
            }
        }
    }
    catch {
        Throw $_
    }
}