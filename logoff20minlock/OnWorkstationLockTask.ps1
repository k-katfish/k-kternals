[Environment]::SetEnvironmentVariable("OWLpid", $PID, "User")
$SessionID = (Get-Process -PID $PID).SessionId

Start-Sleep -Seconds 1200

logoff.exe $SessionID