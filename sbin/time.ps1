#Requires -RunAsAdministrator
#Requires -Version 5.1

Set-StrictMode -Off

Start-Service -Name "W32Time"
w32tm.exe /resync
Stop-Service -Name "W32Time"
