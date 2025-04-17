# Import Required Modules
Import-Module ActiveDirectory

# Get current user
$currentUser = (Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty UserName).Split('\')[-1]

# Filter all AD Users by Users that have an IPPhone entry
$ciscoUsers = Get-ADUser -Filter * -Properties SamAccountName, IPPhone | Where-Object { $_.IPPhone -ne $null }

# Filter Cisco Users by current user and apply regedits
if ($ciscoUsers | Where-Object {$_.SamAccountName -eq $currentUser}) {
    # Get the user's IPPhone information
    $ciscoUser = Get-ADUser -Identity $currentUser -Properties IPPhone

        # Check/create the Main Registry key in WOW6432Node
        if (!(Test-Path "HKLM:\SOFTWARE\WOW6432Node\Cisco Systems, Inc.")) {
            New-Item -Path "HKLM:\SOFTWARE\WOW6432Node" -Name "Cisco Systems, Inc." -Force
        }

        # Check/create the "Communicator" subkey in WOW6432Node
        if (!(Test-Path "HKLM:\SOFTWARE\WOW6432Node\Cisco Systems, Inc.\Communicator")) {
            New-Item -Path "HKLM:\SOFTWARE\WOW6432Node\Cisco Systems, Inc." -Name "Communicator" -Force
        }

        # Set "Communicator" subkeys in WOW6432Node
        Set-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Cisco Systems, Inc.\Communicator" -Name "AlternateDeviceName" -Value 1 -Type DWORD -Force
        Set-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Cisco Systems, Inc.\Communicator" -Name "AlternateTftp" -Value 1 -Type DWord -Force
        ### MAC ###
        Set-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Cisco Systems, Inc.\Communicator" -Name "HostName" -Value $ciscoUser.IPPhone -Force 
        ### MAC ###
        Set-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Cisco Systems, Inc.\Communicator" -Name "TftpServer1" -Value 0x0101A8C0 -Type DWord -Force
        Set-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Cisco Systems, Inc.\Communicator" -Name "TftpServer2" -Value 0x0201A8C0 -Type DWord -Force

} else {}
