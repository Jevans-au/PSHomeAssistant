
function Test-HomeAssistantApi {
    [CmdletBinding()]
    param ()
    If(-not($IpAddress)){
        $IpAddress = $PSHomeAssistantParams.IpAddress
    }
    $Uri = "http://$($IpAddress):8123/api/$Api"
    $Headers = @{
        "Authorization" = "Bearer $($PSHomeAssistantParams.AuthToken)"
        "content-type"  = "application/json"
    }
    try {
        $ApiTest = Invoke-RestMethod -Uri $Uri -Headers $Headers -Method Get -ErrorAction Stop
        If($ApiTest.message -eq 'API running.'){
            Write-Output $true
        }
        ElseIf($ApiTest.message){
            $WarningMessage = ("`r`nHome Assistant instance at address [$IpAddress] did respond, but did not return the expected message 'API running'`r`n" +
                "The message returned was [$($ApiTest.message)]")
            Write-Warning $WarningMessage
        }
    }
    catch {
        Throw $_
    }
}