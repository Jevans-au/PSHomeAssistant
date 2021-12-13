<#
.SYNOPSIS
    Used to configure the PSHomeAssistant module parameters.
.NOTES
    Author:     Jeff Evans - jevans.dev
    Created:    2021/11/21
    Version:    0.1.0
#>

function Set-PSHomeAssistantConfiguration {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $Address,
        [Parameter(Mandatory=$false,ParameterSetName='NewToken')]
        [string]
        $Token,
        [Parameter(Mandatory=$false,ParameterSetName='UseExistingToken')]
        [switch]
        $UseExistingToken
    )
    # If params file does not exist, create it
    switch(Test-Path -Path "$PSScriptRoot\..\PSHomeAssistantParams.json"){
        $true{
            Write-Verbose -Message "PSHomeAssistantParams.json file already exists."
        }
        default{
            try {
                $NewPSHomeAssistantParamFileTemplate = (@{"ipaddress"="";"authtoken"=""} | ConvertTo-Json)
                [void](New-Item -Path "$PSScriptRoot\..\PSHomeAssistantParams.json" -Value $NewPSHomeAssistantParamFileTemplate -ErrorAction Stop)
            }
            catch {
                Throw "Unable to create PSHomeAssistantParams.json file due to unknown error: $($_.exception.message)"
            }
        }
    }
    # Confirm either the file exists or was just created by importing the contents
    try {
        $PSHomeAssistantParamsFile = Get-Content -Path "$PSScriptRoot\..\PSHomeAssistantParams.json" -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
    }
    catch {
        Throw "Unable to retrieve PSHomeAssistantParams.json file due to unknown error: $($_.exception.message)"
    }
    # Confirm address provided is a valid one on the local network.
    try {
        [void](Test-Connection -ComputerName $Address -Count 1 -ErrorAction Stop)
        $PSHomeAssistantParamsFile.ipaddress = $Address
    }
    catch {
        Throw "Provided address [$Address] cannot be contacted: $_"

    }
    # Use existing token if present, or flip a table if there is no existing token to use
    If($UseExistingToken -and $PSHomeAssistantParamsFile.authtoken){
        $Token = $PSHomeAssistantParamsFile.authtoken
    }
    ElseIf([string]::IsNullOrEmpty($PSHomeAssistantParamsFile.authtoken) -and -not($Token)){
        Throw "No existing token to re-use in [$("$PSScriptRoot\..\PSHomeAssistantParams.json")]"
    }
    If($Token){
        $PSHomeAssistantParamsFile.AuthToken = $Token
    }
    # Update contents of PSHomeAssistantParams.json with newly set address and token
    try {
        Set-Content -Path "$PSScriptRoot\..\PSHomeAssistantParams.json" -Value ($PSHomeAssistantParamsFile | ConvertTo-Json) -ErrorAction Stop
        # Set updated params for current PowerShell session
        $Global:PSHomeAssistantParams = $PSHomeAssistantParamsFile
    }
    catch {
        Throw "Unable to set new parameters for configuration file due to unknown error: $($_.Exception)"
    }
}