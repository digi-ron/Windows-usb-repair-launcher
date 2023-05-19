#dev variables
$scriptfoldername = "Scripts"
$launcherPSFileName = $MyInvocation.MyCommand.Name
$inputPrompt = "Input Number for command to run"



#working code
$stringinput = "-1"
$scriptdir = Split-Path $PSScriptRoot -Parent
$scriptdir += "\$($scriptfoldername)\"
cd $scriptdir
#find all ps1 and reg files in script directory
#note that batch files could be made compatible, but as PS does everything cmd does, it doesn't seem necessary
$PSFilesList = Get-ChildItem -Path "$($scriptdir)*.ps1"
$REGFileList = Get-ChildItem -Path "$($scriptdir)*.reg"
$BATFileList = Get-ChildItem -Path "$($scriptdir)*.bat"

$fileiterator = 0
$filesArray = @()
foreach($file in $PSFilesList)
{
    # redact launcher file using if statement
    if ($file.Name -ne $launcherPSFileName)
    {
        $filesArray += $file.Name
        $fileiterator = $fileiterator + 1
    }
}

foreach($file in $REGFileList)
{
    $filesArray += $file.Name
    $fileiterator = $fileiterator + 1
}

foreach($file in $BATFileList)
{
    $filesArray += $file.Name
    $fileiterator = $fileiterator + 1
}

while($stringinput -ne "0")
{
    Write-Output "Running Script: $($PSCommandPath)"
    Write-Output "Directory: $($PSScriptRoot)"
    Write-Output ""

    Write-Output "AVAILABLE OPTIONS"
    Write-Output "============================="
    Write-Output "[0] --- Exit Repair Launcher"

    for ($i = 1; $i -le $fileiterator; $i++)
    {
        Write-Output "[$($i)] --- $($filesArray[$i-1])"
    }

    $stringinput = Read-Host $inputPrompt
    $validinput = $false
    $numberinput = -1

    while ($validinput -eq $false)
    {
        try
        {
            $numberinput = [int]$stringinput | Out-Null

            # dunno why but the comparator seems to require the STRING value rather than the int, I'm pretty sure I'm not doing this wrong, it must be PS thangs
            if($numberinput -le $fileiterator -and $numberinput -gt -1)
            {
                Write-Output "Input accepted..."
                $validinput = $true
            }
            elseif ($stringinput -eq "0")
            {
                Write-Output "Exiting Script Launcher..."
                Set-ExecutionPolicy -ExecutionPolicy Default -Scope CurrentUser
                exit
            }
            else
            {
                Write-Output "Input not accepted. Please input a number between 0 and $($fileiterator)!"
                $stringinput = Read-Host $inputPrompt
            }
        
        }
        catch
        {
            Write-Output "Input not a number. Please input a number between 0 and $($fileiterator)!"
            $stringinput = Read-Host $inputPrompt
        }
    }

    #launch program selected
    $commandtorun = $filesArray[$stringinput-1]
    Write-Output "COMMAND: $commandtorun"
    $pathrun = "$($scriptdir)$($commandtorun)"

    # registry files must be loaded differently as for some reason launching them from a child script end in a null output and no error, suspected to be something by the OS to stop malicious code
    if($commandtorun.EndsWith(".reg"))
    {
        Write-Output "registry file"
        Start-Process regedit.exe $commandtorun -Verb runas
    }
    elseif($commandtorun.EndsWith(".ps1"))
    {
        # the amount of pain and suffering this coe gorilla went through to get this to work was nearly insurmountable
        # for reference to anyone else trying this, I am starting powershell, which starts a new powershell instance with the script. even removing the powershell command in the " will break any script that needs admin. I am yet to work out why MS has forsaken myself and others like me
        start-process powershell "powershell -File `'$($PSScriptRoot)\$($commandtorun)`'" -WorkingDirectory $scriptdir
    }
    elseif($commandtorun.EndsWith(".bat"))
    {
        cmd  /c "$($PSScriptRoot)\$($commandtorun)"
    }
    cls
}
exit