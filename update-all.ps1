#Requires -RunAsAdministrator

# Update Windows software
winget upgrade --all

# Update git for windows
git update-git-for-windows

# Update bicep
az bicep upgrade

# Update Ubuntu software in WSL
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$scriptPath = $scriptPath.Replace("C:", "/mnt/c").Replace([System.IO.Path]::DirectorySeparatorChar, "/")
wsl --exec cp $scriptPath/update-all.sh /home/thomas/update-all.sh
wsl --exec chmod +X /home/thomas/update-all.sh
wsl --exec sudo /home/thomas/update-all.sh "$scriptPath"