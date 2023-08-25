cls
[System.Reflection.Assembly]::LoadWithPartialName("System.DirectoryServices.AccountManagement") | Out-Null
[System.DirectoryServices.AccountManagement.PrincipalContext]$context = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::Domain)
[System.DirectoryServices.AccountManagement.UserPrincipal]$user = New-Object System.DirectoryServices.AccountManagement.UserPrincipal($context)
$user.SamAccountName = "thomas"
#$user.Surname = "Neuberger"
[System.DirectoryServices.AccountManagement.PrincipalSearcher]$searcher = New-Object System.DirectoryServices.AccountManagement.PrincipalSearcher
$searcher.QueryFilter = $user
[System.DirectoryServices.AccountManagement.PrincipalSearchResult[System.DirectoryServices.AccountManagement.Principal]]$result = $searcher.FindAll()
$userObject = $result | %{ 
    Write-Host "SID" $_.SID;
    $_.GetUnderlyingObject() 
};
$userObject | Format-List ([string[]]($userObject | Get-Member -MemberType Property | %{ $_.Name } | Sort-Object))
$searcher.Dispose()
$user.Dispose()
$context.Dispose()