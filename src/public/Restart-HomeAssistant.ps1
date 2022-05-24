<#
.SYNOPSIS
    Restarts host machine for Home Assistant (on-premise) instance.
.PARAMETER IpAddress
    The IP Address or Host Name of the Home Assistant instance to be restarted.
.PARAMETER AccessToken
    The Access Token generated in Home Assistant, which will be used to authenticate and authorize the restart.
    If an Access Token is not provided, the token stored in the local copy of PSHomeAssistant will be used instead.
.PARAMETER WaitForRestart
    Determines whether the function should wait until Home Assistant is confirmed to be up and running again.
    It confirms that Home Assistant has started again by testing the API.
.PARAMETER WaitTime
    If the WaitForRestart switch is used, WaitTime can be used to override the default timeout of 15 minutes.
.NOTES
    Author:     jevans.dev
    Created:    2021-12-07
    Updated:    2022-05-24
    Version:    0.2.0
#>
function Restart-HomeAssistant {
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact='High')]
    param (
        [Parameter(Mandatory=$false)]
        [Alias('Address')]
        [string]
        $IpAddress,
        [Parameter(Mandatory=$false)]
        [string]
        $AccessToken,
        [Parameter(Mandatory=$false)]
        [switch]
        $WaitForRestart,
        [Parameter(Mandatory=$false)]
        [int]
        $WaitTime = 15
    )
    $RebootSplat = @{
        Api         = 'services/hassio/host_reboot'
        Method      = 'POST'
        ErrorAction = 'Stop'
    }
    If($IpAddress){
        $RebootSplat.Add('IpAddress',$IpAddress)
    }
    If($AccessToken){
        $RebootSplat.Add('AccessToken',$AccessToken)
    }
    try {
        If($PSCmdlet.ShouldProcess('Restart Home Assistant Host')){
            Invoke-HomeAssistantQuery @RebootSplat
        }
    }
    catch {
        Throw $_
    }
    If($WaitForRestart){
        $RestartTimer = [System.Diagnostics.Stopwatch]::StartNew()
        do {
            Start-Sleep -Seconds 10 # No point spamming the poor thing
            $HomeAssistantApiTest = Test-HomeAssistantApi -ErrorAction SilentlyContinue
        } while ($RestartTimer.Elapsed.TotalMinutes -gt $WaitTime -or $HomeAssistantApiTest -eq $true) # Better to be explicit than miss it
        $RestartTimer.Stop()
        If($HomeAssistantApiTest){
            Write-Host 'Home Assistant has finished restarting.'
        }
        Else{
            Throw ("Home Assistant instance was not able to restart within the provided time of [$WaitTime] minutes.`r`n" +
            'Home Assistant may still be restarting, but taking more time than expected to complete.')
        }
    }
}