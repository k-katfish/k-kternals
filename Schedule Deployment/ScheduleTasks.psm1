function New-NaiveScheduledTask {
    [cmdletBinding()]
    param(
        [Parameter(mandatory=$true)]
            [Alias('tn')][String]$TaskName,

        [Parameter(Mandatory=$true)]
            [Alias('tr')][String]$RunCommand,

        [Parameter(ParameterSetName='At', mandatory=$true)]
            [datetime]$At,

        [Parameter(ParameterSetName='DateString', mandatory=$true)]
            [Alias('sd')][String]$StartDate,
        
        [Parameter(ParameterSetName='DateString', mandatory=$true)]
            [Alias('st')][String]$StartTime,

        [Parameter()]
            [Alias('sc')][String]$ScheduleType = "Once",

        [Parameter()]
            [Alias('s')][String]$ComputerName,
        
            #[Alias('u')][String]$Username = "SYSTEM"
        #[Alias('p')][String]$Password,

        [Parameter()]
            [Alias('ru')][String]$RunUser = "SYSTEM",

        [Parameter()]
            [Alias('rl')][String]$RunLevel = "HIGHEST"

    )

    ## Validation

    if ($RunLevel -ne "HIGHEST" -or $RunLevel -ne "LIMITED") {
        throw "Argument Problem: -RunLevel must be either HIGHEST (default) or LIMITED."
    }

    if ($ScheduleType -ne "MINUTE" -or $ScheduleType -ne "HOURLY" -or $ScheduleType -ne "DAILY" -or $ScheduleType -ne "WEEKLY" -or $ScheduleType -ne "MONTHLY" -or $ScheduleType -ne "ONCE" -or $ScheduleType -ne "ONSTART" -or $ScheduleType -ne "ONLOGON" -or $ScheduleType -ne "ONIDLE") {
        throw "Argument Problem: -ScheduleType must be one of the following: MINUTE HOURLY DAILY WEEKLY MONTHLY ONCE ONSTART ONLOGON ONIDLE"
    }

    ## 

    $SchTasks_CMD = "schtasks.exe /create /tn '$TaskName' /tr '$RunCommand' /sc $ScheduleType /rl $RunLevel"

    if ($At) {
        $sd = ($At | Get-Date -Format "MM/dd/yyyy")
        $st = ($At | Get-Date -Format "HH:mm")

        $SchTasks_CMD += "/st $st /st $st "
    } elseif ($StartDate) {
        $SchTasks_CMD += "/st $StartDate /st $StartTime "
    }

    if ($ComputerName) {
        $CimSession = New-CimSession -ComputerName $Hostname -SessionOption (New-CimSessionOption -Protocol DCOM)

        Invoke-CimMethod -CimSession $CimSession -ClassName Win32_Process -MethodName create -Arguments @{
            commandline="schtasks.exe /create /tn $TaskName /tr $RunCommand /sc $ScheduleType /sd $sd /st $st /s $ComputerName"
        }
    }

    #schtasks /create /tn MyApp /tr c:\apps\myapp.exe /sc once /sd 01/01/2003 /st 00:00

}

<#function New-ScheduledTask {
    [cmdletBinding()]
    param()
    #schtasks /create /sc <scheduletype> /tn <taskname> /tr <taskrun> [/s <computer> [/u [<domain>\]<user> [/p <password>]]] [/ru {[<domain>\]<user> | system}] [/rp <password>] [/mo <modifier>] [/d <day>[,<day>...] | *] [/m <month>[,<month>...]] [/i <idletime>] [/st <starttime>] [/ri <interval>] [/rl <level>] [{/et <endtime> | /du <duration>} [/k]] [/sd <startdate>] [/ed <enddate>] [/it] [/np] [/z] [/f]
    throw "Not Implemented"
}#>