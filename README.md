# Cisco IP Communicator
Powershell Script to dynamically configure the Cisco IP Communicator software using the IPPhone field in Active Directory

I've worked in an environment that uses the Cisco IP Communicator softphone in a non-persistent virtual desktop environment and this was my solution to persist the configuration. Typically, on a physical machine or a standard virtual desktop, a user's MAC address would not change on a reboot and the neccessary settings the softphone needs to run would remain working without issue. However, in a non-persistent desktop environment the MAC address changes on logoff or reboot and would forget the TFTP settings to pull the correct config from Cisco's Call Manager. This script ensures the MAC registered to the user in Call Manager (provided you list it in the user's AD Profile - see below) and TFTP fields are set on logon regardless of the machine's actual MAC address.

This script runs on an AD joined Windows Machine using a Group Policy Object. Store the script in a location the machine you plan to run it on has permission to. (ex.: \\domain\sysvol\scripts)
Reference the script in the GPO under: User Configuration > Policies > Windows Settings > Scripts (Logon/Logoff) > Logon under the Powershell Script Tab.

![image](https://github.com/user-attachments/assets/825030e6-70c0-4bc2-8a60-d91b759aaeb2)

REQUIRED<br>
Active Directory IPPhone Field

This script relies on there being an entry in the user's AD Account under the Telephones Tab in the IPPhone field. If there is not an entry, the script does nothing. The entry should be formatted like the following for the Cisco Softphone to pick it up properly. 'SEP' followed by the MAC in Call Manager for the user.

![image](https://github.com/user-attachments/assets/37eb1e99-3fb1-4b45-bc71-5c04c9e57d39)

REQUIRED<br>
TFTP Field Conversion

The HEX registry entries generated from manually programming the TFTP IPs in the preferences section of the software are a little weird (to me). When reviewing the entries in the registry tree, I've found the HEX code is entered backwards in the Windows Registry. (ex. 192.168.1.1 should be entered into the below converter as 1.1.168.192 to get the correct value needed 0x0101A8C0.):

https://miniwebtool.com/ip-address-to-hex-converter

192.168.1.1 = 0x0101A8C0<br>
192.168.1.2 = 0x0201A8C0

Be sure to modify the script with your internal TFTP entries in HEX format:
![image](https://github.com/user-attachments/assets/225b055c-cdfd-41c6-91c6-c7128a7ae66b)




