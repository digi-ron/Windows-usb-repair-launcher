# usb-repair-launcher
set of PowerShell scripts created for the purposes of simply automating common computer repair/modification tasks, while avoiding using 3rd party applications (for use cases involving Group Policy or Application Whitelisting)

all files in the Scripts folder are read for acceptable file extensions (bat, reg and ps1) and listed for the technician to choose from, using a numbering system (0-n). once selected the scripts are run

scripts included in the Scripts folder are for tasks I have done regularly, listed below:
- Common Repairs - does the usual first step commands when diagnosing a corrupted disk or OS, outputting computer information into the DumpOutputs folder, running CHKDSK, running DISM, and running Disk Cleanup. each action is optional except for the computer information dump, where the option is opening the file after the information has been gathered
- create new context item - takes an input file extension (either with or without . suffix)
