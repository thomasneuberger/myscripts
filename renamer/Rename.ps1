[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]
    $FolderPath,
    [Parameter()]
    [string]
    $filePrefix = $null,
    [Parameter()]
    [switch]
    $whatIf
)

if (-not [System.IO.Directory]::Exists($FolderPath)) {
    Write-Host "Ordner $FolderPath existiert nicht." -ForegroundColor Red
    return
}

if ([string]::IsNullOrWhiteSpace($filePrefix)) {
    Write-Host Wie sollen die Dateien heissen?
    $filePrefix = Read-Host
}

$folder = Get-Item $FolderPath;

$shellObject = New-Object -ComObject Shell.Application
$directoryObject = $shellObject.NameSpace( $folder.FullName )
$property = 'Aufnahmedatum'
for(
  $propertyIndex = 5;
  $directoryObject.GetDetailsOf( $directoryObject.Items, $propertyIndex ) -ne $property;
  ++$propertyIndex ) {
    # Write-Host $directoryObject.GetDetailsOf( $directoryObject.Items, $propertyIndex )
   }

$files = $folder.GetFiles() | ForEach-Object {
    $file = $_;
    $fileObject = $directoryObject.ParseName( $file.Name )
    $dateTakenValue = $directoryObject.GetDetailsOf($fileObject, $propertyIndex)
    $dateTakenValue = [System.Text.RegularExpressions.Regex]::Replace($dateTakenValue, "[^0-9.: ]", "")
    [DateTime]$datetaken = New-Object DateTime
    $hasDateTaken = [DateTime]::TryParse($dateTakenValue, [ref] $datetaken)
    $fileinfo = New-Object -TypeName PSObject -Property @{     
        File = $file
        DateTakenValue = $dateTakenValue
        DateTaken = $datetaken
    }
    if ($hasDateTaken) {
        $fileinfo
    }
    else {
        Write-Host "$($file.Name) hat kein Aufnahmedatum."
    }
} | Sort-Object { $_.DateTaken }

for ($i = 0; $i -lt $files.Count; $i++) {
    $file = $files[$i]
    $newFilename = $filePrefix + $i.ToString("_0000") + [System.IO.Path]::GetExtension($file.File)
    $newFilename = [System.IO.Path]::Combine($file.File.DirectoryName, $newFilename)
    
    Write-Host "$($file.File.Name) umbenennen in $([System.IO.Path]::GetFileName($newFilename))..."
    if (-not $whatIf) {
        $file.File.MoveTo($newFilename)
    }
}