[string[]] $puzzleInput = Get-Content .\Day1\input.txt

$increased = 0
for($i=0; $i -lt $puzzleInput.Count; $i++){
    $curMeasure=0
    $puzzleInput[$i..($i+2)] | ForEach-Object { $curMeasure += [int]$_}

    $nextMesure=0
    $puzzleInput[($i+1)..($i+3)] | ForEach-Object { $nextMesure += [int]$_}

    if($nextMesure -gt $curMeasure){
       $increased++
    }
}

Write-Host "The answer is: $increased" 