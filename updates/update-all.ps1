[CmdletBinding()]
param (
    [switch] $updateBicep,
    [switch] $updateWsl,
    [switch] $repairWslDns
)
#Requires -RunAsAdministrator

# Update Windows software
winget upgrade --all --silent

# Update git for windows
# git update-git-for-windows

if ($updateBicep){
    # Update bicep
    az bicep upgrade
}

if ($updateWsl){
    # Update Ubuntu software in WSL
    $scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
    $scriptPath = $scriptPath.Replace("C:", "/mnt/c").Replace([System.IO.Path]::DirectorySeparatorChar, "/")
    wsl --exec cp $scriptPath/update-all.sh /home/thomas/update-all.sh
    wsl --exec chmod +X /home/thomas/update-all.sh
    if ($repairWslDns){
        [string]$repairDnsParameter = "y"
    }
    else{
        [string]$repairDnsParameter = "n"
    }
    wsl --exec sudo /home/thomas/update-all.sh "$scriptPath" $repairDnsParameter
}