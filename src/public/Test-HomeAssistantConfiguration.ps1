<#
.SYNOPSIS
    Checks Home Assistant (on-premise) configuration for any errors.
#>
function Test-HomeAssistantConfiguration {
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
    $TestConfigSplat = @{
        Api = 'services/homeassistant/check_config'
        Method = 'POST'
    }
    If($IpAddress){
        $TestConfigSplat.Add('IpAddress',$IpAddress)
    }
    If($AccessToken){
        $TestConfigSplat.Add('AccessToken',$AccessToken)
    }
    try {
        Invoke-HomeAssistantQuery @TestConfigSplat
    }
    catch {
        If($_.ErrorDetails.Message -match 'Server got itself in trouble'){
            Write-Error -Message "Issue found with Home Assistant instance configuration" -ErrorAction Stop
        }
        Else{
            Throw $_
        }
    }
}