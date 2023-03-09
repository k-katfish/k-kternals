<#
# AutoLogoff.ps1
# Author:  Kyle Ketchell
# Version: 1.0
# Date:    3/9/2022
#>
[cmdletbinding(DefaultParameterSetName="AbortLogoff")]
param(
    [Parameter(ParameterSetName="BeginLogoffCountdown")][Switch][Alias("l")]$lock,
    [Parameter(ParameterSetName="BeginLogoffCountdown")][Switch]$ForceAdminLogoff,
    [Parameter(ParameterSetName="BeginLogoffCountdown")][int][Alias("t")]$time = 1200,

    [Parameter(ParameterSetName="AbortLogoff")][Switch][Alias("u")]$unlock,

    [Parameter()][Switch][Alias("h")]$help
)

if ($help) {
    Write-Host "Parameters:"
    Write-Host "--lock -l: begin a countdown, and lock the workstation after that countdown limit is reached. Cannot be used with -u."
    Write-Host "--time -t [seconds]: (optional), specify how long to wait in seconds before logging off the user. Can only be used with -l"
    Write-Host "--unlock -u: abort the countdown timer and pending logoff task. Cannot be used with -l."
    Write-Host "--help -h: Show this message and exit."
    Write-Host "--forceadminlogoff: also logoff the account with the username `"Administrator`"."
    Write-Host "`r`nIf no parameters are specified, it will attempt to abort a pending AutoLogoff, then quit."
    exit
}


if ($lock) {
    if (!($ForceAdminLogoff) -and ($env:USERNAME -eq "Administrator")) { 
        Write-Verbose("The -ForceAdminLogoff parameter was not specified, and the current user is named Administrator! Aborting.")
        exit 
    }

    Write-Verbose("Setting the user Environment Variable 'ALpid' to $($PID)")
    [Environment]::SetEnvironmentVariable("ALpid", $PID, "User")

    $SessionID = (Get-Process -PID $PID).SessionId
    Write-Verbose("The SessionID of the current user is $SessionID , and will be logged off in $time seconds")

    Start-Sleep -Seconds $time

    if ($WhatIf.IsPresent) { # The user passed -WhatIf to the cmdlet, and it was handled via cmdletbinding and exists here
        Write-Verbose("WhatIf: The time is up, and the user would now be logged off (I will not log off, because -WhatIf was passed).")
        exit
    } else {
        logoff.exe $SessionID
    }
}


if ($unlock) {
    $ALpid = [Environment]::GetEnvironmentVariable("ALpid", "User")
    Write-Verbose("Found the Process ID of the existing AutoLogoff process, it is $ALpid")

    Stop-Process -Id $ALpid -Force
    Write-Verbose("Stopped process $ALpid, the AutoLogoff was canceled.")

    Write-Verbose("Removing the user Environement Variable 'ALpid'")
    [Environment]::SetEnvironmentVariable("ALpid", $null, "User")
}