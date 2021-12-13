<#
.SYNOPSIS
    Wrapper function to invoke REST queries against Home Assistant (on-premise).
.NOTES
    Author:     Jeff Evans - jevans.dev
    Created:    2021/11/12
    Version:    0.1.0
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
    try {
        $RestQuery = Invoke-RestMethod -Uri $Uri -Headers $Headers -Method $Method -ErrorAction Stop -Body ($Body | ConvertTo-Json)
        Write-Output $RestQuery
    }
    catch {
        Throw $_
    }
}