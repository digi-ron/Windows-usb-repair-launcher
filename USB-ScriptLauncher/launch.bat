@ECHO OFF
color 0a
REM adding powershell to allow scripts for the current user
powershell set-executionpolicy unrestricted -scope currentuser
REM launcher is not powershell as auto-launching by double-clicking is not yet supported (and may never be supported)
echo launching main script...
REM start powershell "%~dp0Scripts\Launcher.ps1"
cd Scripts
REM powershell "%~dp0Scripts\Launcher.ps1"
powershell ./Launcher.ps1