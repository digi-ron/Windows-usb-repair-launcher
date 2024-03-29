# Windows Repair Launcher
set of PowerShell scripts created for the purposes of simply automating common computer repair/modification tasks, while avoiding using 3rd party applications (for use cases involving Group Policy or Application Whitelisting). As a result, none of this is particularly special or original code, and is put in this repo mostly for archive and demonstration purposes.

---
**_I am NOT responsible for results of running any of these scripts on your machines, you should read and verify any code you intend to run BEFORE running it_**

---

all files in the Scripts folder are read for acceptable file extensions (bat, reg and ps1) and listed for the technician to choose from, using a numbering system (0-n). once selected the scripts are run according to those extensions (ps1 files are run with powershell, bat files are run with cmd, reg files are imported using registry commands)

## Notes:

_- The launcher will modify the execution policy for the current user while running, this is intended functionality and is reverted as long as the launcher is exited using the "0" command in the menu_

_- The Common Repairs Script will also dump computer information into the DumpOutputs folder. While there is no sensitive information in this folder, care should be taken as to retention of these files (or the lines of code responsible removed depending on requirements)_

## Scripts included
| Name | Purpose |
| ------ | ------- |
| Common Repairs Script.ps1 | does the usual first step commands when diagnosing a corrupted disk or OS, outputting computer information into the DumpOutputs folder, running CHKDSK, running DISM, and running Disk Cleanup. each action is optional except for the computer information dump, where the option is opening the file after the information has been gathered |
| Create New Context Item.ps1 | takes an input file extension (either with or without . suffix), and adds relevant registry keys to allow for that filetype to be included in the right-click "New" menu |
| Create New File or Folder Context Menu item (Current User).ps1 | takes an input filepath (required), an icon path (optional), and a location (below) to generate and apply a registry file, which allows the user to add a custom "Edit with X.exe" to either `Background` (typically where view/group by etc. options are), `Selected Folder`, or `All Files (*)`.
| Current User Full Backup.ps1 | makes a simple backup to a different drive based on the currently logged in user, saving anything in the ProgramData, AppData, Documents, Downloads, Desktop, Music, Pictures, Saved Games, and Videos folders. The caveat for this is it doesn't discriminate on files so only recommended to run if you can't manually copy the files yourself (e.g. running overnight to filter while the PC is being reset with a fresh drive) |
| Export Consumer Product Key.ps1 | makes a backup of the registry key responsible for the product key within Windows 10. Exports the .reg file to the DumpOutputs folder |
| Get List of Installed Applications (Legacy).ps1 | Gets a WMIC queried list of installed applications on the system. *Does not include UWP applications* |
| Get List of Installed Applications (Modern).ps1 | Gets a PowerShell queried list of UWP applications on the system. *Does not include legacy applications* |
| Launch All Important Directories.bat | Launches all of the following directories: AppData, ProgramData, Local, LocalLow |
| Launcher.ps1 | Main launcher application, technically speaking this could be launched directly to the same effect as running the batch file in the directory above, however batch was decided as the "main launcher" as it can be double-clicked as default behaviour in Windows, and it can change the powershell execution policy before launch to ensure it runs. |
| Remove New Context Item.ps1 | Removes any input file extension registry key according to the input file extension (with or without a .). This is the script to revert any changes made by the Create New Context Item script |
| Reset Execution-Policy.bat | resets the powershell execution policy to default behavior manually, if this is run no more scripts will run asn the launcher should be exited immediately |
| Windows Search Disable W10_22H2.reg | A simple registry file to override cortana functionality to local search only, tested to work on Windows 10, 22H2
