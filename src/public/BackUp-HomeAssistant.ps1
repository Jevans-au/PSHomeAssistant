<#
.SYNOPSIS
    Invokes backup for Home Assistant (on-premise) instance.
#>
function BackUp-HomeAssistant {
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
        [ValidateSet('full','partial')]
        [string]
        $Action = 'full'
    )
    $BackupSplat = @{
        Api = 'services/hassio/backup_' + $Action
        Method = 'POST'
    }
    If($IpAddress){
        $BackupSplat.Add('IpAddress',$IpAddress)
    }
    If($AccessToken){
        $BackupSplat.Add('AccessToken',$AccessToken)
    }
    try {
        Invoke-HomeAssistantQuery @BackupSplat
    }
    catch {
        Throw $_
    }
}