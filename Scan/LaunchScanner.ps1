echo "  ____   ____    _    _   _  "
echo " / ___| / ___|  / \  | \ | | "
echo " \___ \| |     / _ \ |  \| | "
echo "  ___) | |___ / ___ \| |\  | "
echo " |____/ \____/_/   \_\_| \_| "
echo "                             "

echo "Written by Kyle Ketchell for Engineering Technology Services"
echo ""

$ComputerName = Read-Host -Prompt "Enter Computer Name to scan"
#$ComputerName = $ComputerName.Substring(0,$ComputerName.Length-1)
Write-Host "Scanning '$ComputerName' now, this window will close in a few seconds."

$Location = Get-Location
#Write-Host "executing: Powershell -Command {& `"$($Location.Path)\ScanHost.ps1`" -Hostname $($ComputerName)}"

Start-Process Powershell.exe -ArgumentList "Powershell $($Location.Path)\ScanHost.ps1 -Hostname $($ComputerName)" -WindowStyle:Hidden

timeout 5 /NOBREAK