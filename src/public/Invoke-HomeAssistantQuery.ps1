<#
.SYNOPSIS
    Wrapper function to invoke REST queries against Home Assistant (on-premise).
.NOTES
    Author:     Jeff Evans - jevans.dev
    Created:    2021/11/12
    Modified:   2021/12/15
    Version:    0.2.0
#>

function Invoke-HomeAssistantQuery {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [Alias('Address')]
        [string]
        $IpAddress,
        [Parameter(Mandatory=$false)]
        [string]
        $AccessToken,
        [Parameter(Mandatory=$true)]
        [string]
        $Api,
        [Parameter(Mandatory=$false)]
        [validateSet('GET','POST')]
        [string]
        $Method = 'GET',
        [Parameter(Mandatory=$false)]
        [HashTable]
        $Body
    )
    If(-not($IpAddress)){
        $IpAddress = $PSHomeAssistantParams.IpAddress
    }
    If(-not($AccessToken)){
        $AccessToken = $PSHomeAssistantParams.AuthToken
    }
    $Uri = "http://$($IpAddress):8123/api/$Api"
    $Headers = @{
        "Authorization" = "Bearer $AccessToken"
        "content-type"  = "application/json"
    }
    $InvokeRestMethodSplat = @{
        Uri = $Uri
        Headers = $Headers
        Method = $Method
        ErrorAction = 'Stop'
    }
    If($Body){
        $InvokeRestMethodSplat.Add('Body',($Body | ConvertTo-Json))
    }
    try {
        $RestQuery = Invoke-RestMethod @InvokeRestMethodSplat
        Write-Output $RestQuery
    }
    catch {
        Throw $_
    }
}