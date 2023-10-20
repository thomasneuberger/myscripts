[CmdletBinding()]
param (
    [switch] $updateBicep,
    [switch] $updateWsl,
    [switch] $repairWslDns
)
#Requires -RunAsAdministrator

# Update Windows software
Write-Host "Update Windows software..." -ForegroundColor Green
winget upgrade --all --silent

if ($updateBicep){
    # Update bicep
    Write-Host "Update Bicep..." -ForegroundColor Green
    az bicep upgrade
}

if ($updateWsl){
    Write-Host "Update WSL..." -ForegroundColor Green
    wsl --update

    $scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
    $scriptPath = $scriptPath.Replace("C:", "/mnt/c").Replace([System.IO.Path]::DirectorySeparatorChar, "/")

    $ubuntuDistros = wsl --list --all | ForEach-Object { $_.Replace([string][char]0, "").Replace(" (Standard)", "") } | Where-Object { $_ -match "Ubuntu" }

    # Update Ubuntu software in WSL
    foreach ($distro in $ubuntuDistros) {
        Write-Host "Update WSL-Distrobution $distro..." -ForegroundColor Green

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

}