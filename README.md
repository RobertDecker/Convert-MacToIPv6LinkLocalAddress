# Convert-MacToIPv6LinkLocalAddress
A PowerShell function which converts a MAC address into an IPv6 Link Local address

## How to use it
 1. Dot source the script.
 2. Execute the Convert-MacToIPv6LinkLocalAddress function with arguments appropriate to your needs.
 
## Notes
 - Will accept MAC Addresses in the following formats
   - XX:XX:XX:XX:XX:XX
   - XXXX:XXXX:XXXX
   - XXXXXX:XXXXXX
   - XXXXXXXXXXXX
 - MAC Address delimiter can be any one of the following characters:  dot, colon, hyphen
 - MAC Address is case-insensitive and will be converted to lower case.
 
## Example Usage:
```powershell
PS> . .\Convert-MacToIPv6LinkLocalAddress.ps1
PS> Convert-MacToIPv6LinkLocalAddress "a4:bf:01:7b:86:4a" "eth0"
fe80::a6bf:1ff:fe7b:864a%eth0
```
```powershell
PS> . .\Convert-MacToIPv6LinkLocalAddress.ps1
PS> Convert-MacToIPv6LinkLocalAddress "a4:bf:01:7b:86:4a"
fe80::a6bf:1ff:fe7b:864a
```
```powershell
PS> . .\Convert-MacToIPv6LinkLocalAddress.ps1
PS> "a4:bf:01:7b:86:4a" | Convert-MacToIPv6LinkLocalAddress 
fe80::a6bf:1ff:fe7b:864a
```
```powershell
PS> . .\Convert-MacToIPv6LinkLocalAddress.ps1
PS> "a4:bf:01:7b:86:4a" | Convert-MacToIPv6LinkLocalAddress  -Interface "eth0"
fe80::a6bf:1ff:fe7b:864a%eth0
```
```powershell
PS> . .\Convert-MacToIPv6LinkLocalAddress.ps1
PS> "a4:bf:01:7b:86:4a" | Convert-MacToIPv6LinkLocalAddress  -Interface "eth0" -EncloseInBrackets $true
[fe80::a6bf:1ff:fe7b:864a%eth0]
```
## License
This software is licensed under the GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007.
