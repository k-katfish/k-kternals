[cmdletBinding()]
param(
    [String]$BIOSword, 
    [String]$SearchBase, 
    $SaveFile
)

if (-Not $BIOSword) {
    $BIOSword = Read-Host -Prompt "Enter default HP BIOS Password"
}
if (-Not $SearchBase) {
    $SearchBase = Read-Host -Prompt "Enter AD Search String (it's ok to include non-HP computers)"
}

if ($SaveFile) {
    try {
        New-Item -Path $SaveFile -ItemType File
    } catch { }
}

$Computers = Get-ADComputer -Filter "Enabled -eq 'True'" -SearchBase $SearchBase

Write-Verbose "$($Computers.count)"
Write-Verbose "$(($BIOSword).GetHashCode())"

function Invoke-ConfigureHPBIOSPowerOptions () {
    [cmdletBinding()]
    param(
        $Computers,
        [String]$BIOSword,
        [String]$SaveFile
    )

    Write-Host "There are $($Computers.Count) Computer objects"

    $Computers | ForEach-Object -Parallel {

        $ComputerName = $_.Name
        $Report = ("=" * 10) + "[ REPORT: $ComputerName ]" + ("=" * 10) + "`r`n"

        if (-Not (Test-Connection -ComputerName $ComputerName -Count 2)) {
            $Report += "Computer Offline. `r`n"
        } else {
            try {
                try {
                    if (($APL = Get-HPBIOSSettingValue -Name "After Power Loss" -ComputerName $ComputerName) -eq "Power On") {
                        $Report += "After Power Loss: $APL`r`n"
                    } else {
                        Set-HPBIOSSettingValue -Password $using:BIOSWord -ComputerName $ComputerName -Name "After Power Loss" -Value "Power On"
                        $APL = Get-HPBIOSSettingValue -Name "After Power Loss" -ComputerName $ComputerName
                        $Report += "After Power Loss: $APL (updated)`r`n"
                    }   
                } catch { 
                    $Report += "Error configurating After Power Loss: $_"
                }

                try {
                    if (($PBO = Get-HPBIOSSettingValue -Name "Power Button Override" -ComputerName $ComputerName) -eq "Disable") {
                        $Report += "Power Button Override: $PBO`r`n"
                    } else {
                        Set-HPBIOSSettingValue -Password $using:BIOSWord -ComputerName $ComputerName -Name "Power Button Override" -Value "Disable"
                        $PBO = Get-HPBIOSSettingValue -Name "Power Button Override" -ComputerName $ComputerName
                        $Report += "Power Button Override: $PBO (updated)`r`n"
                    }
                } catch {
                    $Report += "Error configurating Power Button Override: $_"
                }

            } catch {
                if ($_ -like "*Please ensure this is a supported HP device.*") {
                    $Report += "$ComputerName is not an HP- refusing to operate.`r`n"
                } else {
                    $Report += "$ComputerName :: Something else: $_"
                }
            }
        }

        try {
            Write-Host $Report
            Write-Host "`r`n"
            Add-Content -Path $using:SaveFile -Value ($Report + "`r`n")
        } catch {
            Write-Verbose $_
        }

    } -ThrottleLimit 16
}

Invoke-ConfigureHPBIOSPowerOptions -Computers $Computers -BIOSword $BIOSword -SaveFile $SaveFile