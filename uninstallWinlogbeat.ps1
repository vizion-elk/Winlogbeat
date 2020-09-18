﻿##[Ps1 To Exe]
##
##Kd3HDZOFADWE8uK1
##Nc3NCtDXThU=
##Kd3HFJGZHWLWoLaVvnQnhQ==
##LM/RF4eFHHGZ7/K1
##K8rLFtDXTiW5
##OsHQCZGeTiiZ4tI=
##OcrLFtDXTiW5
##LM/BD5WYTiiZ4tI=
##McvWDJ+OTiiZ4tI=
##OMvOC56PFnzN8u+Vs1Q=
##M9jHFoeYB2Hc8u+Vs1Q=
##PdrWFpmIG2HcofKIo2QX
##OMfRFJyLFzWE8uK1
##KsfMAp/KUzWJ0g==
##OsfOAYaPHGbQvbyVvnQX
##LNzNAIWJGmPcoKHc7Do3uAuO
##LNzNAIWJGnvYv7eVvnQX
##M9zLA5mED3nfu77Q7TV64AuzAgg=
##NcDWAYKED3nfu77Q7TV64AuzAgg=
##OMvRB4KDHmHQvbyVvnQX
##P8HPFJGEFzWE8tI=
##KNzDAJWHD2fS8u+Vgw==
##P8HSHYKDCX3N8u+Vgw==
##LNzLEpGeC3fMu77Ro2k3hQ==
##L97HB5mLAnfMu77Ro2k3hQ==
##P8HPCZWEGmaZ7/K1
##L8/UAdDXTlaDjofG5iZk2UbjQ3EtZ8CXvYqDwZK36+X8hyTMXZVZRFFjhCD/Bk68Tc4BVuccpMUCaQgkJvwY9rPcF8qsUbADkeF6avHAo6osdQ==
##Kc/BRM3KXxU=
##
##
##fd6a9f26a06ea3bc99616d4851b372ba

Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope CurrentUser	
Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope LocalMachine
Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope Process
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force

$ServiceName = "winlogbeat"

$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())

if($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    #Change Folder to winlogbeat
    $currentLocation = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
    If ( -Not (Test-Path -Path "$currentLocation\winlogbeat") )
    {
        Write-Host -Object "Path $currentLocation\winlogbeat does not exit, exiting..." -ForegroundColor Red
        Exit 1
    }
    Else
    {
        Set-Location -Path "$currentLocation\winlogbeat"
    }

    #Stops winlogbeat from running
    Stop-Service -Force $ServiceName

    #Get The winlogbeat Status and delete the service
    Get-Service $ServiceName
    Start-Sleep -Seconds 20
    C:\Windows\System32\sc.exe delete $ServiceName

    #Change Directory to winlogbeat
    Set-Location -Path 'c:\'

    "`nUninstalling winlogbeat Now..."

    Get-ChildItem -Path $currentLocation -Recurse -force |
        Where-Object { -not ($_.pscontainer)} |
            Remove-Item -Force -Recurse

    Remove-Item -Recurse -Force $currentLocation

    "`nWinlogbeat Uninstall Successful."

    #Close Powershell window
    #Stop-Process -Id $PID
}
else {
    Start-Process -FilePath "powershell" -ArgumentList "$('-File ""')$(Get-Location)$('\')$($MyInvocation.MyCommand.Name)$('""')" -Verb runAs
}