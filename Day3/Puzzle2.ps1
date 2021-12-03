[string[]] $puzzleInput = Get-Content .\Day3\input.txt

$oxygenInput = $puzzleInput
$co2Input = $puzzleInput
for($i=0; $i -lt $puzzleInput[0].Length; $i++){
        $oxygenBitCount = ($oxygenInput | ForEach-Object { $_[$i] } | Group-Object | Sort-Object count -Descending | Select-Object -First 2)
        $co2BitCount = ($co2Input | ForEach-Object { $_[$i] } | Group-Object | Sort-Object count | Select-Object -First 2)

        [int]$oxygenBit = $oxygenBitCount[0].Name
        if($oxygenBitCount[0].Count -eq $oxygenBitCount[1].Count){
            [int]$oxygenBit = 1
        }

        [int]$co2Bit = $co2BitCount[0].Name
        if($co2BitCount[0].Count -eq $co2BitCount[1].Count){
            [int]$co2Bit = 0
        }
        if($oxygenInput.count -gt 1){
            $oxygenInput = $oxygenInput | Where-Object {[convert]::ToInt32($_[$i],10) -eq $oxygenBit}
        }
        if($co2Input.count -gt 1){
            $co2Input = $co2Input | Where-Object {[convert]::ToInt32($_[$i],10) -eq $co2Bit}
        }
}

$answer = ([Convert]::ToInt32($oxygenInput,2) * [Convert]::ToInt32($co2Input,2))
Write-Host "The answer is: $answer"