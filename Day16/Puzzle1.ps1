function createPacketString {
    [string]$puzzleInput = Get-Content -Path .\Day16\input.txt

    $hexToBin = @{}
    $hexToBin["0"] = "0000"
    $hexToBin["1"] = "0001"
    $hexToBin["2"] = "0010"
    $hexToBin["3"] = "0011"
    $hexToBin["4"] = "0100"
    $hexToBin["5"] = "0101"
    $hexToBin["6"] = "0110"
    $hexToBin["7"] = "0111"
    $hexToBin["8"] = "1000"
    $hexToBin["9"] = "1001"
    $hexToBin["A"] = "1010"
    $hexToBin["B"] = "1011"
    $hexToBin["C"] = "1100"
    $hexToBin["D"] = "1101"
    $hexToBin["E"] = "1110"
    $hexToBin["F"] = "1111"
    
    $global:versionSum = 0
    $packetstring = ""
    foreach($item in $puzzleInput.ToCharArray()){
        $packetstring += $hexToBin["$item"]
    }
    return $packetstring
}


function getVersion ($packet) {
    $version = [convert]::ToInt32($packet.Substring(0,3),2)
    $global:versionSum += $version
    return $version
}
function getPacketType ($packet){
    $typeId = [convert]::ToInt32($packet.Substring(3,3),2)
    return $typeId
}

function getNextPackage ($packet, $limit){
    #$packet = $packetstring
    #$packet = "000000000000000001011000010001010110100010111000001000000000101111000110000010001101"
    #$i = 22
    #$subpacket = "00000010110"
    #$packet=$subpacket
    $packets = @()
    $i=0
    while ($i -lt $packet.Length) {
        if($packet.Length - $i -lt 10){
            $i = $packet.Length
            break
        }
        #write-host "i $i - length = $($packet.Length)"
        $packetObject = @{
            version =  $version
            typeId = $typeId
            value = ""
            subPackets = @()
        }
        $packetObject.version = getVersion $packet.Substring($i)
        $packetObject.typeId = getPacketType $packet.Substring($i)
        $i += 6
        #write-host "Package  $($packetObject.typeId) Version: $($packetObject.version)"
        if($packetObject.typeId -eq "4"){
            #literal value
            #$packet = '0001000101011010001011'
            #write-host "2 findvalue - i: $i - packet length: $($packet.length) - Packet: '$($packet)'"
            $binValue = ""
            do {
                $first = $packet.Substring($i,1)
                $i++
                $binValue += $packet.Substring($i,4)
                $i += 4
            } while ($first -eq "1")
            $packetObject.value = [convert]::ToInt64($binValue,2)
            
            #write-host "3 value: $($packetObject.value) - i: $i - packet length: $($packet.length) - Packet: '$($packet)'"
        } else {
            $SubPacketsLength = $numberOfSubPackages = 0
            $lengthTypeId = $packet.Substring($i,1)
            $i++
            if($lengthTypeId -eq "0"){
                $SubPacketsLength = [convert]::ToInt32($packet.Substring($i,15),2)
                $i += 15
                #write-host "4 Packet length: $($packet.length) - i: $i - SubPacketsLength: $SubPacketsLength "
                $subPackets += getNextPackage $packet.Substring($i,$SubPacketsLength)
                $i += $SubPacketsLength
            }
            if($lengthTypeId -eq "1"){
                #$subPackets = getSubPacketsByNumber $packet
                $numberOfSubPackages = [convert]::ToInt32($packet.Substring($i,11),2)
                $i += 11

                $subPackets = @()
                #$subPackets += getNextPackage $packet
                #$packet = "000000000000000001011000010001010110100010111000001000000000101111000110000010001101"
                #$subPackets += getNextPackage $packet.Substring(84) 2
                #write-host "5 Packet length: $($packet.length) - i: $i - numberOfSubPackages: $numberOfSubPackages - '$packet'"
                $subPackets += getNextPackage $packet.Substring($i) $numberOfSubPackages
                $i += $subPackets.iValue
                #write-host "En hier? $($packet.length) $i"
                
            }
            $packetObject.subPackets = $subPackets.packets
        }
        $packets += $packetObject
        if($limit -and $limit -eq $packets.Count){
            #write-host "Reached limit"
            break
        }
        
    }
    $packetArrayObject = @{
        packets =  $packets
        iValue = $i
    }
    return $packetArrayObject
}

$packetstring = createPacketString
$packets = getNextPackage $packetstring

$packets.packets.subPackets
$versionSum