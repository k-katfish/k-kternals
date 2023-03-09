if ($env:USERNAME -eq "Administrator") { exit }

$OWLpid = [Environment]::GetEnvironmentVariable("OWLpid", "User")

Stop-Process -Id $OWLpid -Force

[Environment]::SetEnvironmentVariable("OWLpid", $null, "User")