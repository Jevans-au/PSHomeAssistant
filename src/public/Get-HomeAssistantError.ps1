
function Get-HomeAssistantError {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $ExportPath,
        [Parameter()]
        [string]
        $Start,         # ! Requires yee-haw date format (MM/dd/yyyy)
        [Parameter()]
        [string]
        $End            # ! Requires yee-haw date format (MM/dd/yyyy)
    )
    try {
        $RestQuery = Invoke-HomeAssistantQuery -Api 'error_log'
        # Rest query is returned as a single string, this does not make for an easy to read object upon return.
        # We will split the string into an array where a new line is started
        $RestQuery = $RestQuery -split "`n"
        # We will create an object for each line
        $LogArray = @()
        ForEach($LogLine in $RestQuery){
            $RegexMatch = [regex]::Match($LogLine,'(\d*-\d*-\d* \d*:\d*:\d*) (\w*) (\(.*\)) (\[.*\]) (.*)')
            $OutputObject = [PSCustomObject]@{
                TimeStamp   = ''
                Type        = $RegexMatch.Groups[2].Value
                Thread      = $RegexMatch.Groups[3].Value # ? So clearly I don't know what the difference between MainThread and syncworker_* etc is, I'd like to fix that at some point
                Source      = $RegexMatch.Groups[4].Value
                Message     = $RegexMatch.Groups[5].Value
            }
            If($RegexMatch.Groups[1].Value){
                $OutputObject.TimeStamp = Get-Date $RegexMatch.Groups[1].Value
            }
            $LogArray += $OutputObject
        }
        If($RestQuery){
            Write-Output $LogArray
            If($ExportPath){
                $LogArray | Export-Csv -Path ($ExportPath + "\HassLog$((New-Guid).Guid).csv")
            }
        }
        Else{
            Write-Error "An entity with the likeness of [$entity] could not be found in Home Assistant"
        }
    }
    catch {
        Throw $_
    }
}