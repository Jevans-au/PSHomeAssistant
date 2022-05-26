# PSHomeAssistant

## Introduction

PSHomeAssistant is a PowerShell Module providing a set of functions you can use to interact with Home Assistant.

This includes:
- Stopping/Restarting Home Assistant
- Creating back ups for Home Assistant
- Retrieving data from Home Assistant
    - Configuration
    - Entities
    - States
    - Services
    - Error logs
- And some more stuff below

You can import and run the module from:

    Windows ✅

    Linux/macOS ❌

I'm keen to support Linux/macOS as I use both myself, but ~~I'm lazy~~ there's still testing to be done.

There will almost certainly be some code changes to be done in order to have the same functions available cross-platform.

### **But Why a PowerShell Module?**

I'd be lying if I said my own curiosity wasn't the main source of motivation in developing this module.

Beyond that I encourage you to look through what the module can do, I'm not trying to sell anything or convince anyone to use this module or PowerShell over anything else.

What I am trying to do is provide options for people who may find this more accessible or compatible with their own Home Automation needs.

## Getting Started

## Importing the Module for the First Time

### Open PowerShell

There are a number of ways to do this:

1. [Opening PowerShell or PowerShell ISE](https://docs.microsoft.com/en-us/powershell/scripting/windows-powershell/starting-windows-powershell?view=powershell-5.1)
2. [VS Code](https://code.visualstudio.com/Download) + [PowerShell Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)
3. [Windows Terminal](https://docs.microsoft.com/en-us/windows/terminal/install)

All of the commands you'll see here are compatible with each of the above.

### Downloading the PowerShell Module

1. The PSHomeAssistant Module can be found [here](https://github.com/Jevans-au/PSHomeAssistant)
2. You can download the module by clicking on the green 'Code' button and choosing from one of the provided options:
    - Clone
    - Open with GitHub Desktop
    - Download ZIP
3. Once you have a copy of the module, create a folder in the following location and copy the contents of the 'src' folder to it.

    `C:\users\you\Documents\WindowsPowerShell\Modules\PSHomeAssistant`

### Importing the Module

1. In your open PowerShell window, confirm the module is available by using the following command:
```PowerShell
Get-Module -Name PSHome* -ListAvailable | Select-Object Name,Version | Sort-Object Name
```
You should see the following output
```PowerShell
Name            Version
----            -------
PSHomeAssistant 0.1.1
```

If you didn't see the above output returned then you'll need to confirm you are running the PowerShell session under the same account you copied the module to.

Alternatively, there is a way to import the module using a filepath instead of just the name of the module itself.

2. Running the below command will import the module
```PowerShell
Import-Module -Name PSHomeAssistant # If you saw the module in the previous step
Import-Module -Name "C:\Users\you\Documents\WindowsPowerShell\Modules\PSHomeAssistant\PSHomeAssistant.psd1" # If you did not see the module in the previous step and wanted to continue anyways
```
3. a
## Using the PSHomeAssistant Functions

### **Test Functions**

### Test-HomeAssistantApi

### Test-HomeAssistantConfiguration

### **Functions for Managing the Host Machine**

### Restart-HomeAssistant

### Stop-HomeAssistant

### BackUp-HomeAssistant

### **Get Functions**

### Get-HomeAssistantConfiguration

### Get-HomeAssistantEntity

### Get-HomeAssistantNewEntity

### Get-HomeAssistantService

### Get-HomeAssistantState

### Get-HomeAssistantError

### **Set Functions**

### Set-PSHomeAssistantConfiguration

### [Set-HomeAssistantLifx](https://jevans-au.github.io/PSHomeAssistant/functions/Set-HomeAssistantLifx.html)

### Set-HomeAssistantLight

### **Invoke Functions**

### Invoke-HomeAssistantQuery

### Invoke-HomeAssistantTts