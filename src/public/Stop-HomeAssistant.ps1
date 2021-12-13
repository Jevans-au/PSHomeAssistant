<#
.SYNOPSIS
    Restarts host machine for Home Assistant (on-premise) instance.
#>
function Stop-HomeAssistant { # TODO Add Confirm Impact High + code to prompt user to confirm shutdown of the host machine
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [Alias('Address')]
        [string]
        $IpAddress,
        [Parameter(Mandatory=$false)]
        [string]
        $AccessToken
    )
    $ShutdownSplat = @{
        Api     = 'services/hassio/host_shutdown'
        Method  = 'POST'
    }
    If($IpAddress){
        $ShutdownSplat.Add('IpAddress',$IpAddress)
    }
    If($AccessToken){
        $ShutdownSplat.Add('AccessToken',$AccessToken)
    }
    try {
        Invoke-HomeAssistantQuery @ShutdownSplat
    }
    catch {
        Throw $_
    }
}