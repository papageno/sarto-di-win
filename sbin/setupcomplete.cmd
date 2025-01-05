@echo off
set "file=%~dp0.\setupcomplete.ps1"
set "args=%*"
net file 1>nul 2>nul
if %errorlevel% equ 0 (
    powershell -noprofile -ex unrestricted -file "%file%" %args%
) else (
    powershell -noprofile -ex unrestricted -command "& { Start-Process -FilePath '%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe' -ArgumentList '-noprofile -ex unrestricted -file "%file%" %args%' -Verb RunAs }"
)
