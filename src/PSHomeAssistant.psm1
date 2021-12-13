# Implement your module commands in this script.

# Export only the functions using PowerShell standard verb-noun naming.
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.
(Get-ChildItem -Path "$PSScriptRoot\public").FullName | ForEach-Object {
    . $_
}
#Export-ModuleMember -Function *-*

# Import parameters file
try {
    $Global:PSHomeAssistantParams = Get-Content -Path "$PSScriptRoot\PSHomeAssistantParams.json" -ErrorAction Stop | ConvertFrom-Json
}
catch {
    If($_.Exception -match 'because it does not exist.'){
        $ConfigurePSHomeAssistantSplat = @{
            Address         = [string]::Empty
            Token           = [string]::Empty
            ErrorAction     = 'Stop'
        }
        Write-Host "PSHomeAssistantParams.json does not exist, will be created now.`r`n" -ForegroundColor Cyan
        Write-Host "Provide the name or IP address of the Home Assistant instance you wish to manage."
        Write-Host "E.g. 10.1.1.2:8123 or mylocalhomeassistant." -ForegroundColor Gray
        $ConfigurePSHomeAssistantSplat.Address = Read-Host "Enter the Address to continue, Enter 'Help' to open the documentation for this module, or 'N' to exit module configuration"
        switch($ConfigurePSHomeAssistantSplat.Address){
            ''{
                Write-Host "`r`n`r`nNo value provided for Home Assistant Address, exiting module configuration." -ForegroundColor Yellow
                return
            }
            'N'{
                Write-Host "`r`n`r`nExiting module configuration." -ForegroundColor Yellow
                return
            }
            'Help'{
                $DocumentationType = Read-Host "'Y' to open online documentation, any other character to open offline documentation"
                switch($DocumentationType){
                    'Y'{
                        # TODO - Finish blog posts :) :) :) start-process -FilePath 'https://www.jevans.dev/blog/search/pshomeassistant'
                    }
                    ''{
                        return
                    }
                    default{
                        Start-Process "$PSScriptRoot\..\doc\readme.md"
                    }
                }
            }
        }
        Write-Host "Provide the long lived token for the Home Assistant user you wish to manage the instance with."
        $ConfigurePSHomeAssistantSplat.Token = Read-Host "Enter the Token to continue, Enter 'Help' to open the documentation for this module, or 'N' to exit module configuration"
        switch($ConfigurePSHomeAssistantSplat.Token){
            ''{
                Write-Host "`r`n`r`nNo value provided for Home Assistant Token, exiting module configuration." -ForegroundColor Yellow
                Return
            }
            'N'{
                Write-Host "`r`n`r`nExiting module configuration." -ForegroundColor Yellow
                Return
            }
            'Help'{
                $DocumentationType = Read-Host "'Y' to open online documentation, any other character to open offline documentation"
                switch($DocumentationType){
                    'Y'{
                        # TODO - Finish blog posts :) :) :) start-process -FilePath 'https://www.home-assistant.io/docs/authentication/#your-account-profile'
                    }
                    ''{
                        return
                    }
                    default{
                        Start-Process "$PSScriptRoot\..\doc\readme.md"
                    }
                }
            }
        }
        # Run Set-PSHomeAssistantConfiguration with provided parameters from above to generate PSHomeAssistantConfigurationParams.json
        try {
            Set-PSHomeAssistantConfiguration @ConfigurePSHomeAssistantSplat
            Write-Host "`r`n`r`n[$("$PSScriptRoot\PSHomeAssistantParams.json")] has been created and configured to the values provided" -ForegroundColor Green
            $Global:PSHomeAssistantParams = Get-Content -Path "$PSScriptRoot\PSHomeAssistantParams.json" -ErrorAction Stop | ConvertFrom-Json
        }
        catch {
            Throw "Unknown error occurred when trying to create and import new PSHomeAssistantParams.json: $($_.Exception)"
        }
    }
    Else{
        throw $_
    }
}
