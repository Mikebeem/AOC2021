function addNumbers ($number, $numberToAdd) {
    $newNumber = "[$number,$numberToAdd]"
    return $newNumber
}
function checkResult ($result, $expected){
    if($number -eq $expected){
        Write-Host "Success!"
    }
    else{
        Write-Error "Nope!"
        Write-Host $result
        write-Host $expected
    }
}
function explodeNumbers ($number) {
    $toExplodeLeft = $null
    $toExplodeRight = $null
    $count = 0
    $numbersFound = New-Object System.Collections.Stack
    for($i=0; $i -lt $number.Length; $i++){
        if($null -ne $toExplodeRight)
        { #If we need to explode a number to right, we only do that
            if($number[$i] -match "[0-9]"){
                [int]$numberFound = [System.Convert]::ToInt32($number[$i],10)
                $continueI = $i+1
                if($number[$i+1] -match "[0-9]"){
                    [int]$numberFound = [System.Convert]::ToInt32($number.Substring($i, 2),10)
                    $continueI = $i+2
                }
                [int]$numberFound += $toExplodeRight
                $number = $number.Substring(0,$i) + $numberFound + $number.Substring($continueI)

                $toExplodeRight = $null
                return $number
            }
            
        }
        elseif($number[$i] -eq "["){
            $count++
            if($count -eq 5){
                #write-host "Number before Explode: $number"
                [int]$EndOfPair = $number.Substring($i).IndexOf("]")
                $stringToExplode = $number.Substring($i, $EndOfPair+1)
                $toExplode = $stringToExplode.TrimStart("[").TrimEnd("]").Split(",")
                if($numbersFound.Count -gt 0){
                    #Als er nummers gevonden zijn, moet het eerste getal naar links
                    [int]$toExplodeLeft = $toExplode[0]
                }
                if($number.Substring($EndOfPair+1) -match "[0-9]"){
                    #Als er rechts nummers zijn, moet dit naar rechts
                    [int]$toExplodeRight = $toExplode[1]
                }
                $number = $number.Substring(0,$i) + "0" + $number.Substring($i+$EndOfPair+1)
                $count--

                if($null -ne $toExplodeLeft -and $numbersFound.Count -gt 0){
                    $lastFound = $numbersFound.Peek()
                    $numberFound = $lastFound.number + $toExplodeLeft
                    $continueIndex = $lastFound.index+1
                    if($lastFound.number -gt 9){
                        $continueIndex++
                    }
                    if($numberFound -gt 9){
                        $i++
                    }
                    $number = $number.Substring(0,$lastFound.index) + $numberFound + $number.Substring($continueIndex)
                    $toExplodeLeft = $null
                }
            }
        }
        elseif($number[$i] -match "[0-9]"){
            [int]$numberFound = [System.Convert]::ToInt32($number[$i], 10)

            if($number[$i+1] -match "[0-9]"){
                [int]$numberFound = [System.Convert]::ToInt32($number.Substring($i, 2), 10)
            }
            $numbersFound.Push(@{number = $numberFound; index = $i}) 
            if($numberFound -gt 9){
                $i++
            }
        }
        elseif($number[$i] -eq "]"){
            $count--
        }
    }
    return $number
}
function splitNumbers ($number) {
    if($number -match '[0-9][0-9]'){
        for($i=0; $i -lt $number.Length; $i++){
            if("$($number[$i])$($number[$i+1])" -match '[0-9][0-9]')
            {
                [int]$numberFound = $number[$i]+$number[$i+1]
                $first = [Math]::Floor($numberFound/2)
                $second = [Math]::Ceiling($numberFound/2)
                $replaceWith = "[$first,$second]"
                $number = $number.Substring(0,$i) + $replaceWith + $number.Substring($i+2)
                return $number
            }
        }
    }
    return $number
}

function needToExplode ($number) {
    $count = 0
    for($i=0; $i -lt $number.Length; $i++){
        if($number[$i] -eq "["){
            $count++ | Out-Null
        }
        if($count -gt 4){
            return $true
        }
        if($number[$i] -eq "]"){
            $count-- | Out-Null
        }
    }
    return $false
}

function needToSplit ($number) {
    if($number -match '[0-9][0-9]'){
        return $true
    }
    return $false
}
function calcMagnitude ($number){
    for($i=0 ; $i -lt $number.Length ; $i++){
        
        if($number[$i] -match ']'){
            [int]$BeginOfPair = $number.Substring(0,$i).LastIndexOf("[")
            $stringToCalc = $number.Substring($BeginOfPair, ($i-$BeginOfPair)+1)
            $arrayToCalc = $stringToCalc.TrimStart("[").TrimEnd("]").Split(",")
            $firstValue = [System.Convert]::ToInt32($arrayToCalc[0], 10)*3
            $secondValue = [System.Convert]::ToInt32($arrayToCalc[1], 10)*2
            $value = ($firstValue+$secondValue)
            $number = $number.Substring(0,$BeginOfPair) + $value + $number.Substring($i+1)
            $i -= ($stringToCalc.Length - $value.ToString().length)
        }
    }
    return $number
}

[string[]]$puzzleInput = Get-Content -Path .\Day18\input.txt
$number = $null
$checked = @{}
$highestMagnitude = 0
for ($i=0; $i -lt $puzzleInput.Count; $i++) {
    $number = $puzzleInput[$i]
    if(($i) % 10 -eq 0){
        write-host "$i van $($puzzleInput.Count) - Highest: $highestMagnitude"
    }
    for ($j=0; $j -lt $puzzleInput.Count; $j++) {
        if($j -ne $i){
            $number = addNumbers $puzzleInput[$i] $puzzleInput[$j]
            while((needToExplode $number) -or (needToSplit $number))
            {
                while(needToExplode $number){
                    $number = explodeNumbers $number
                }
                $number = splitNumbers $number
            }
            $magnitude = calcMagnitude $number
            $magnitude = [System.Convert]::ToInt32($magnitude, 10)
            if($magnitude -gt $highestMagnitude){
                $highestMagnitude = $magnitude
            }
        }
    }
}
$highestMagnitude