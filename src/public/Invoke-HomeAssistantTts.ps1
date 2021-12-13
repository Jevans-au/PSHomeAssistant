<#
.SYNOPSIS
    Restarts host machine for Home Assistant (on-premise) instance.
#>
function Invoke-HomeAssistantTts { # TODO Add Confirm Impact High + code to prompt user to confirm reboot
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [Alias('Address')]
        [string]
        $IpAddress,
        [Parameter(Mandatory=$false)]
        [string]
        $AccessToken,
        [Parameter(Mandatory=$false)]
        [ValidateSet('google_translate')]
        [string]
        $TtsPlatform = 'google_translate',
        [Parameter(Mandatory=$true)]
        [string]
        $Message,
        [Parameter(Mandatory=$true)]
        [string]
        $EntityId
    )
    $Ttsplat = @{
        Api = 'services/tts/google_translate_say'
        Method = 'POST'
        Body = @{'entity_id'=$EntityId;message=$Message}
    }
    If($IpAddress){
        $Ttsplat.Add('IpAddress',$IpAddress)
    }
    If($AccessToken){
        $Ttsplat.Add('AccessToken',$AccessToken)
    }
    try {
        Invoke-HomeAssistantQuery @Ttsplat
    }
    catch {
        Throw $_
    }
}