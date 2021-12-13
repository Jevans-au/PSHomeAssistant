function Set-HomeAssistantLight {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]
        $Light,
        [Parameter()]
        [ValidateSet('turn_on','turn_off','toggle')]
        [string]
        $Action = 'toggle'
    )
    try {
        ForEach($target in $light){
            Write-Verbose -Message "Performing action [$Action] on light [$light]"
            Invoke-HomeAssistantQuery -Api ('services/light/' + $Action) -Body @{entity_id=("light." + $light)} -Method POST
        }
    }
    catch {
        Throw $_
    }
}