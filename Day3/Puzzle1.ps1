[string[]] $puzzleInput = Get-Content .\Day3\input.txt

$gammaBinary = ""
$epsilonBinary = ""
for($i=0; $i -lt $puzzleInput[0].Length; $i++){
    $gammaBinary += ($puzzleInput | ForEach-Object { $_[$i] } | Group-Object | Sort-Object count -Descending | Select-Object -First 1).Name
    $epsilonBinary += ($puzzleInput | ForEach-Object { $_[$i] } | Group-Object | Sort-Object count | Select-Object -First 1).Name
}

$answer = ([Convert]::ToInt32($gammaBinary,2) * [Convert]::ToInt32($epsilonBinary,2))
Write-Host "The answer is: $answer" 