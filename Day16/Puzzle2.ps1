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

function getNextPackage ($packet, $limit = $null){
    $packets = @()
    $i=0
    while ($i -lt $packet.Length -or ($limit -and $limit -gt $packets.Count)) {
        if($packet.Length - $i -lt 10){
            $i = $packet.Length

            break
        }
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
            $binValue = ""
            do {
                $first = $packet.Substring($i,1)
                $i++
                $binValue += $packet.Substring($i,4)
                $i += 4
            } while ($first -eq "1")
            $packetObject.value = [convert]::ToInt64($binValue,2)
        } else {
            $SubPacketsLength = $numberOfSubPackages = 0
            $lengthTypeId = $packet.Substring($i,1)
            $i++
            if($lengthTypeId -eq "0"){
                $SubPacketsLength = [convert]::ToInt32($packet.Substring($i,15),2)
                $i += 15
                $subPackets = @()
                $subPackets += getNextPackage $packet.Substring($i,$SubPacketsLength)
                $i += $SubPacketsLength
            }
            if($lengthTypeId -eq "1"){
                #$subPackets = getSubPacketsByNumber $packet
                $numberOfSubPackages = [convert]::ToInt32($packet.Substring($i,11),2)
                $i += 11

                $subPackets = @()
                $subPackets += getNextPackage $packet.Substring($i) $numberOfSubPackages
                $i += $subPackets.iValue
                
            }
            $packetObject.subPackets = $subPackets.packets
        }
        $packets += $packetObject
        if($limit -and $limit -eq $packets.Count){
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
# drillDown $packet
function drillDown ($packet, $parentType){
    
    if($packet.typeId -ne 4){
        $values = @()
        
        foreach($subPacket in $packet.subPackets){
            $values += drillDown $subPacket $packet.typeId
        }
        [int64]$value = calcValue $values $packet.typeId
        #write-host "value '$value' for type $($packet.typeId)"
        return $value
    }else{
        return $packet.value
    }
}

function calcValue ($values, $typeId){
    switch ($typeId) {
        0 { 
            [int64]$totalValue = 0
            foreach($sum in $values){
                $sumValue += $sum
            }
            $totalValue += $sumValue
            return $totalValue
        }
        1 {
            [int64]$productValue = 1
            foreach($value in $values){
                $productValue *= $value
            }
            return $productValue
        }
        2 {
            $minValues = @()
            foreach($value in $values){
                $minValues += $value
            }
            return ($minValues | Measure-Object -Minimum).Minimum
        }
        3 {
            $maxValues = @()
            foreach($value in $values){
                $maxValues += $value
            }
            return ($maxValues | Measure-Object -Maximum).Maximum
        }
        5 {
            $value = 0
            if($values[0] -gt $values[1]){
                $value = 1
            }
            return $value
        }
        
        6 {
            $value = 0
            if($values[0] -lt $values[1] ){
                $value = 1
            }
            return $value
        }
        7 {
            $value = 0
            if($values[0] -eq $values[1] ){
                $value = 1
            }
            return $value
        }
        Default { 
            write-host "not build yet"
        }
    }
}


$wat = drillDown $packets.packets[0]
$wat