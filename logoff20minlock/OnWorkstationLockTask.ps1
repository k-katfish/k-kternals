[Environment]::SetEnvironmentVariable("OWLpid", $PID, "User")

Start-Sleep -Seconds 1200

& "C:\Windows\System32\shutdown.exe" /l