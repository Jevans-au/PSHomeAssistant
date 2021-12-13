function Set-HomeAssistantLifx {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string[]]
        $Light,
        [Parameter(Mandatory=$true)]
        [ValidateSet('ColourLoop','Pulse','StopEffect')]
        [string]
        $Action
    )
    switch($Action){
        'ColourLoop'{
            $Action = 'effect_colorloop'
        }
        'Pulse'{
            $Action = 'effect_pulse'
        }
        'StopEffect'{
            $Action = 'effect_stop'
        }
    }
    try {
        ForEach($target in $light){
            Write-Verbose -Message "Performing action [$Action] on light [$light]"
            Invoke-HomeAssistantQuery -Api ('services/lifx/' + $Action) -Body @{entity_id=("light." + $light)} -Method POST
        }
    }
    catch {
        Throw $_
    }
}