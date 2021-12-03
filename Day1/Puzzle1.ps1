[string[]] $puzzleInput = Get-Content .\Day1\input.txt

$increased = 0
for($i=0; $i -lt $puzzleInput.Count; $i++){
    if(($i -gt 0) -and ([int]$puzzleInput[$i] -gt [int]$puzzleInput[$i-1])){
        $increased++
    }
}

Write-Host "The answer is: $increased" 