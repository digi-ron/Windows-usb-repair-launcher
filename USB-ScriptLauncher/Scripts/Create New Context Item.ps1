#dev variables
$outputFileName = "output.reg"
$deleteFileAfterRun = $true

#running code
$outputLocation = "$($PSScriptRoot)\$($outputFileName)"
$fileExtension = Read-Host "Enter file extension to be added (e.g. .ps1)"

# correct file extension if not entered correctly
if ($fileExtension[0] -ne ".")
{
    Write-Output "Correcting file extension..."
    $fileExtension = ".$($fileExtension)"
    Write-Output "Done"
}

#create new reg file
Write-Output "Creating Windows Registry File..."

Write-Output "Windows Registry Editor Version 5.00" | Out-File -FilePath $outputLocation -Force
Write-Output "[HKEY_CLASSES_ROOT\$($fileExtension)\ShellNew]" | Out-File -FilePath $outputLocation -Append
Write-Output '"NullFile"=""' | Out-File -FilePath $outputLocation -Append

Write-Output "Done"

# execute
Write-Output "Running Registry Editor..."
#wait command required otherwise the file is deleted before you get a chance to confirm importing the keys
Start-Process regedit $outputLocation -Wait

Write-Output "Done"

# cleanup if needed
if ($deleteFileAfterRun -eq $true)
{
    rm $outputLocation
}