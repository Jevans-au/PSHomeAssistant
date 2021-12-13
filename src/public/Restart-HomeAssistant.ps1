<#
.SYNOPSIS
    Restarts host machine for Home Assistant (on-premise) instance.
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
        $AccessToken
    )
    $RebootSplat = @{
        Api = 'services/hassio/host_reboot'
        Method = 'POST'
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
}