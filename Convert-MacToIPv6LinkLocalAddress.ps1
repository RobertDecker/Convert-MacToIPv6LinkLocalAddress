

Function Convert-MacToIPv6LinkLocalAddress {
    <#
    .SYNOPSIS
        Converts a MAC address to an IPv6 Link Local address
    .DESCRIPTION
        Converts a MAC address to an IPv6 Link Local addressy
    .PARAMETER MacAddress
        MAC Address to convert
    .EXAMPLE
        . .\Convert-MacToIPv6LinkLocalAddress
        $IPv6LinkLocalAddress = Convert-MacToIPv6LinkLocalAddress -MacAddress 'a4:bf:01:7b:86:4a'
    .EXAMPLE
        . .\Convert-MacToIPv6LinkLocalAddress
        $IPv6LinkLocalAddress = 'a4:bf:01:7b:86:4a' | Convert-MacToIPv6LinkLocalAddress
    .EXAMPLE
        . .\Convert-MacToIPv6LinkLocalAddress
        $IPv6LinkLocalAddress = Convert-MacToIPv6LinkLocalAddress -MacAddress 'a4:bf:01:7b:86:4a' -Interface 'eth0'
    .NOTES
        - Dot source the script.
        - MacAddress will accept any of the following formats:  "XX:XX:XX:XX:XX:XX", "XXXX:XXXX:XXXX", "XXXXXX:XXXXXX", "XXXXXXXXXXXX" where the delimiter, if used, must be either a dot, hyphen, or colon.
    .NOTES
        Author:             Robert Decker
        Email:              rdecker@cybernorth.com
        License:            GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007
       
        Changelog:
            1.0.0           Initial Release
    #>

    Param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [ValidatePattern("^(([0-9A-Fa-f]{2}[\.:-]){5}([0-9A-Fa-f]{2}))|(([0-9A-Fa-f]{4}[\.:-]){2}([0-9A-Fa-f]{4}))|([0-9A-Fa-f]{6}[\.:-][0-9A-Fa-f]{6})|([0-9A-Fa-f]{12})$")]
        [String]$MacAddress,

        [Parameter(Mandatory = $false, Position = 1)]
        [String]$Interface
    )

    # Remove delimiters
    $MacAddressBare = $MacAddress.ToLower() -replace "[\.:-]", ""
    
    # Insert "fffe" in the middle of the undelimited MAC address.
    $MacAddressBare = $MacAddressBare.Insert(6, "fffe")
    
    # Convert the $MacAddressBare hex string into a byte array
    $MacAddressBytes = [byte[]]($MacAddressBare -split '([a-f0-9]{2})' | ForEach-Object { if ($_) { [System.Convert]::ToByte($_, 16) } })
    
    # Invert bit 1 of the leftmost byte
    $MacAddressBytes[0] = $MacAddressBytes[0] -bxor [byte]"0x02"

    # Create the first four hextets of the IPv6 link local address.  Trim up to three zeros.
    $Hextet1 = ($MacAddressBytes[6].ToString("X2") + $MacAddressBytes[7].ToString("X2")) -replace "^0" -replace "^0" -replace "^0"
    $Hextet2 = ($MacAddressBytes[4].ToString("X2") + $MacAddressBytes[5].ToString("X2")) -replace "^0" -replace "^0" -replace "^0"
    $Hextet3 = ($MacAddressBytes[2].ToString("X2") + $MacAddressBytes[3].ToString("X2")) -replace "^0" -replace "^0" -replace "^0"
    $Hextet4 = ($MacAddressBytes[0].ToString("X2") + $MacAddressBytes[1].ToString("X2")) -replace "^0" -replace "^0" -replace "^0"

    $IPv6LinkLocalAddress = ("fe80::" + $Hextet4 + ":" + $Hextet3 + ":" + $Hextet2 + ":" + $Hextet1).ToLower()
    # Output the MAC address properly converted and formatted into an IPv6 link local address.
    if ($Interface) {
        $IPv6LinkLocalAddress + "%" + $Interface
    }
    else {
        $IPv6LinkLocalAddress
    }
}