@ECHO off
color 0a
echo Setting Powershell Execution Policy...
powershell set-executionpolicy restricted -scope currentuser
exit