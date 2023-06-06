# Schedule Deployment with MDT

This tool is a GUI script (with a cli backend) which will connect to a remote computer via [some-remote-command-execution-protocol-here, probably DCOM or something] and schedule a task to run a task sequence from an MDT Share. Note- selected MDT share must be world readable, otherwise the computer will fail to connect at the scheduled time and will fail to run the task sequence.

## Cool Technologies from this project

Powershell integration with MDT (sort of). Not for management, but more like viewing MDT information with Powershell. Also AD Integration (sort of). Again not as robust as Microsoft's official implementation but works for what I needed.

## How to use

Launch (double click) ScheduleDeployment.exe.

## Command Line Options

If you want to run this in a script, you'll probably want to just run the following command:

```powershell
schtasks /create /tn "Reimage Computer" /tr "\\MDTServer\MDTShare$\Scripts\LiteTouch.wsf /OSDComputerName:%COMPUTERNAME% /SkipComputerName:TRUE /TaskSequence:TS_ID /SkipTaskSequence:TRUE" /sc once /sd 01/01/2003 /st 00:00
```

But you can also use ScheduleDeployment.exe with the following parameters:

| Parameter | What to pass it | Example | What it does |
| --- | --- | --- | --- |
| -ADOU | An ldap-like string: "CN=Computers,OU=MyOU,DC=mydom,DC=TLD" | -ADOU "CN=Office-01,OU=Domain Computers,DC=MyDom,DC=TLD" | This will be passed into Get-ADComputer as the -SearchBase parameter. Any computers matching that search base will be selected and will have a scheduled task created. |
| -ADFilter | A filter string: "*" | -ADFilter "Enabled -eq 'True'"
