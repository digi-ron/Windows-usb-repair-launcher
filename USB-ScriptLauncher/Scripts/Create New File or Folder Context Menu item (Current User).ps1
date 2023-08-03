# dev variables
$deleteAfterRun = $true
$outputFileName = "output.reg"

# user code
$menuItemName = Read-Host "Enter display name for context item: "
$applicationPath = Read-Host "Enter application Path: "
# validate path
if(-Not (Test-Path "$applicationPath" -PathType Leaf)) {
    throw "Application Path Invalid!"
}
$iconPath = Read-Host "Enter Icon Path (Leave blank for application path icon): "
# validate icon
if($iconPath -ne "") {
    if(-Not (Test-Path "$iconPath" -PathType Leaf)) {
        throw "Icon Path Invalid!"
    }
    $selectedIcon = $iconPath
} else {
    $selectedIcon = $applicationPath
}

# built-in variables
$outputLocation = "$($PSScriptRoot)\$($outputFileName)"
$registryBaseLocation = "HKEY_CURRENT_USER\Software\Classes"
$registryBGLocation = "$($registryBaseLocation)\Directory\Background\shell\$($menuItemName)"
$registrySelectedLocation = "$($registryBaseLocation)\Directory\shell\$($menuItemName)"
$registryAllFilesLocation = "$($registryBaseLocation)\*\shell\$($menuItemName)"
$folderAdditional = '" \"%V'
$fileAdditional = '\" \"%1'
$menuOutputMode = @"
OPTIONS:
1- Background
2 - Selected Folder
3 - all files (*)
"@

# calculated variables
$applicationPath = $applicationPath.Replace("\","\\").Replace('"','')
$selectedIcon = $selectedIcon.Replace('\', '\\').Replace('"','')

Write-Host $menuOutputMode
$menuOption = Read-Host "Enter a number: "
while ($menuOption -notin @(1, 2, 3)) {
Write-Warning "Number not in range 1-3!"
Write-Host $menuOutputMode
$menuOption = Read-Host "Enter a number: "
}

switch($menuOption) {
    1 {
        $selectedLocation = $registryBGLocation
        $selectedLocAdditional = $folderAdditional
    }
    2 {
        $selectedLocation = $registrySelectedLocation
        $selectedLocAdditional = $folderAdditional
    }
    3 {
        $selectedLocation = $registryAllFilesLocation
        $selectedLocAdditional = $fileAdditional
    }
}

# create file
$registryFile = @"
Windows Registry Editor Version 5.00

[$($selectedLocation)\command]
@="\"$($applicationPath)$($selectedLocAdditional)\""

[$($selectedLocation)]
"Icon"="\"$($selectedIcon)\""
"@

Write-Output $registryFile | Out-File -FilePath $outputLocation -Force

#wait command required otherwise the file is deleted before you get a chance to confirm importing the keys
Start-Process regedit $outputLocation -Wait

# cleanup if needed
if ($deleteAfterRun -eq $true)
{
    rm $outputLocation
}