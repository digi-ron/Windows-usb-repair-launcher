# I know making a massive try catch is a bit shit but considering the nature of this script, I REALLY don't want to deal with the repercussions of it running post-error
try
{
    #ask for location of backup (typically a drive)
    Write-Output "Please enter a name for the backup folder: "
    $backupFolderName = Read-Host
    Write-Output "Please enter the location for the backup (e.g. R:\): "
    $backupLocation = Read-Host

    if ($backupLocation.ToCharArray()[$backupLocation.Length - 1] -eq '\')
    {
        Write-Output "Path syntax valid"
    }
    else
    {
        Write-Output "adding additional \ to string"
        $backupLocation = "$($backupLocation)\"
    }

    $BackupFolderFullPath = "$($backupLocation)$($backupFolderName)"

    Write-Output "Backup will be written to directory: $($BackupFolderFullPath)"
    # information collected, cd into and make directory
    cd $backupLocation
    mkdir $backupFolderName
    cd $BackupFolderFullPath

    # start copying common locations for any kind of save file, assuming user is fine with very large backup
    Write-Warning "PLEASE NOTE: this script has no failover or exclusions, and so will copy everything from a select few directories marked as useful. Only continue if you are willing to wait!!!"
    pause
    #copy begin
    # useful locations known: ProgramData, AppData, (pretty much everything under $USERPROFILE%)
    # start with programdata
    robocopy $env:ProgramData "$($BackupFolderFullPath)\ProgramData" /S /R:1 /W:1 /XF *.url *.lnk /XD "$($env:ProgramData)\Application Data" "$($env:ProgramData)\Package Cache" "$($env:ProgramData)\NVIDIA" "$($env:ProgramData)\NVIDIA Corporation" "$($env:ProgramData)\Microsoft" "$($env:ProgramData)\Adobe"
    # appdata
    robocopy "$($env:USERPROFILE)\AppData" "$($BackupFolderFullPath)\AppData" /S /R:1 /W:1 /XF *.url *.lnk /XD "$($env:USERPROFILE)\AppData\Local\Temp" "$($env:USERPROFILE)\AppData\Local\Android" "$($env:USERPROFILE)\AppData\Local\Microsoft" "$($env:USERPROFILE)\AppData\Local\Packages" "$($env:USERPROFILE)\AppData\Local\NVIDIA" "$($env:USERPROFILE)\AppData\Local\NVIDIA Corporation" "$($env:USERPROFILE)\AppData\Local\Spotify" "$($env:USERPROFILE)\AppData\Roaming\Spotify" "$($env:USERPROFILE)\AppData\Roaming\Microsoft"
    # documents
    robocopy "$($env:USERPROFILE)\Documents" "$($BackupFolderFullPath)\Documents" /S /R:1 /W:1 /XF *.url *.lnk
    # downloads
    robocopy "$($env:USERPROFILE)\Downloads" "$($BackupFolderFullPath)\Downloads" /S /R:1 /W:1 /XF *.url *.lnk
    # desktop
    robocopy "$($env:USERPROFILE)\Desktop" "$($BackupFolderFullPath)\Desktop" /S /R:1 /W:1 /XF *.url *.lnk
    # music
    robocopy "$($env:USERPROFILE)\Music" "$($BackupFolderFullPath)\Music" /S /R:1 /W:1 /XF *.url *.lnk
    # pictures
    robocopy "$($env:USERPROFILE)\Pictures" "$($BackupFolderFullPath)\Pictures" /S /R:1 /W:1 /XF *.url *.lnk
    # saved games
    robocopy "$($env:USERPROFILE)\Saved Games" "$($BackupFolderFullPath)\Saved Games" /S /R:1 /W:1 /XF *.url *.lnk
    # videos
    robocopy "$($env:USERPROFILE)\Videos" "$($BackupFolderFullPath)\Videos" /S /R:1 /W:1 /XF *.url *.lnk
}
catch
{
    Write-Error "Error reached in backup script!!!"
}