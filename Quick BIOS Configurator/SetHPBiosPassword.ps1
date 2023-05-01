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

function Invoke-ConfigureHPBiosBIOSword () {
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
                if (Get-HPBIOSSetupPasswordIsSet -ComputerName $ComputerName) {
                    $Report += "BIOS password is already set.`r`n"
                } else {
                    $Report += "No BIOS password set. Setting BIOS password to $using:BIOSWord`r`n"
                }

                try {
                    if (($F12 = Get-HPBIOSSettingValue -Name "Prompt for Admin authentication on F12 (Network Boot)" -ComputerName $ComputerName) -eq "Enable") {
                        $Report += "Prompt for Admin authentication on F12 (Network Boot): $F12`r`n"
                    } else {
                        Set-HPBIOSSettingValue -Password $using:BIOSWord -ComputerName $ComputerName -Name "Prompt for Admin authentication on F12 (Network Boot)" -Value "Enable"
                        $F12 = Get-HPBIOSSettingValue -Name "Prompt for Admin authentication on F12 (Network Boot)" -ComputerName $ComputerName
                        $Report += "Prompt for Admin authentication on F12 (Network Boot): $F12 (updated)`r`n"
                    }   
                } catch {
                    if (($F12 = Get-HPBIOSSettingValue -Name "Prompt for Admin password on F12 (Network Boot)" -ComputerName $ComputerName) -eq "Enable") {
                        $Report += "Prompt for Admin password on F12 (Network Boot): $F12`r`n"
                    } else {
                        Set-HPBIOSSettingValue -Password $using:BIOSWord -ComputerName $ComputerName -Name "Prompt for Admin password on F12 (Network Boot)" -Value "Enable"
                        $F12 = Get-HPBIOSSettingValue -Name "Prompt for Admin password on F12 (Network Boot)" -ComputerName $ComputerName
                        $Report += "Prompt for Admin password on F12 (Network Boot): $F12 (updated)`r`n"
                    }
                }

                try {
                    if (($F11 = Get-HPBIOSSettingValue -Name "Prompt for Admin authentication on F11 (System Recovery)" -ComputerName $ComputerName) -eq "Enable") {
                        $Report += "Prompt for Admin authentication on F11 (System Recovery): $F11`r`n"
                    } else {
                        Set-HPBIOSSettingValue -Password $using:BIOSWord -ComputerName $ComputerName -Name "Prompt for Admin authentication on F11 (System Recovery)" -Value "Enable"
                        $F11 = Get-HPBIOSSettingValue -Name "Prompt for Admin authentication on F11 (System Recovery)" -ComputerName $ComputerName
                        $Report += "Prompt for Admin authentication on F11 (System Recovery): $F11 (updated)`r`n"
                    }
                } catch {
                    if (($F11 = Get-HPBIOSSettingValue -Name "Prompt for Admin password on F11 (System Recovery)" -ComputerName $ComputerName) -eq "Enable") {
                        $Report += "Prompt for Admin password on F11 (System Recovery): $F11`r`n"
                    } else {
                        Set-HPBIOSSettingValue -Password $using:BIOSWord -ComputerName $ComputerName -Name "Prompt for Admin password on F11 (System Recovery)" -Value "Enable"
                        $F11 = Get-HPBIOSSettingValue -Name "Prompt for Admin password on F11 (System Recovery)" -ComputerName $ComputerName
                        $Report += "Prompt for Admin password on F11 (System Recovery): $F11 (updated)`r`n"
                    }
                }

                try {
                    if (($F9 = Get-HPBIOSSettingValue -Name "Prompt for Admin authentication on F9 (Boot Menu)" -ComputerName $ComputerName) -eq "Enable") {
                        $Report += "Prompt for Admin authentication on F9 (Boot Menu): $F9`r`n"
                    } else {
                        Set-HPBIOSSettingValue -Password $using:BIOSWord -ComputerName $ComputerName -Name "Prompt for Admin authentication on F9 (Boot Menu)" -Value "Enable"
                        $F9 = Get-HPBIOSSettingValue -Name "Prompt for Admin authentication on F9 (Boot Menu)" -ComputerName $ComputerName
                        $Report += "Prompt for Admin authentication on F9 (Boot Menu): $F9 (updated)`r`n"
                    }
                } catch {
                    if (($F9 = Get-HPBIOSSettingValue -Name "Prompt for Admin password on F9 (Boot Menu)" -ComputerName $ComputerName) -eq "Enable") {
                        $Report += "Prompt for Admin password on F9 (Boot Menu): $F9`r`n"
                    } else {
                        Set-HPBIOSSettingValue -Password $using:BIOSWord -ComputerName $ComputerName -Name "Prompt for Admin password on F9 (Boot Menu)" -Value "Enable"
                        $F9 = Get-HPBIOSSettingValue -Name "Prompt for Admin password on F9 (Boot Menu)" -ComputerName $ComputerName
                        $Report += "Prompt for Admin password on F9 (Boot Menu): $F9 (updated)`r`n"
                    }
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

Invoke-ConfigureHPBiosBIOSword -Computers $Computers -BIOSword $BIOSword -SaveFile $SaveFile