[string[]] $puzzleInput = Get-Content .\Day10\input.txt

$validOpener = @("(","{","[","<")
$complete = @("()","{}","[]","<>")
$total = 0
$totalScores = @()
for($i=0;$i -lt $puzzleInput.Count;$i++){
    $arrayChecker = New-Object System.Collections.ArrayList
    $j=0
    $corrupt = $false
    while($j -lt $puzzleInput[$i].Length -and (-not $corrupt)){
        if($puzzleInput[$i][$j] -in $validOpener){
            $arrayChecker.Add($puzzleInput[$i][$j]) | Out-Null
        }
        elseif($arrayChecker[$arrayChecker.Count-1] + $puzzleInput[$i][$j] -in $complete){
            $arrayChecker.RemoveAt(($arrayChecker.Count-1)) | Out-Null
        }
        else{
            switch ($puzzleInput[$i][$j]) {
                ")" { $total += 3 }
                "]" { $total += 57 }
                "}" { $total += 1197 }
                ">" { $total += 25137 }
            }
            $corrupt = $true
        }
        $j++
    }
    if(-not ($corrupt) -and $arrayChecker.Count -gt 0){
        [int64]$score = 0
        for($k=$arrayChecker.Count-1;$k -ge 0; $k--){
            $score = $score * 5
            switch($arrayChecker[$k]){
                "(" {  $score += 1 }
                "[" {  $score += 2 }
                "{" {  $score += 3 }
                "<" {  $score += 4 }
            }
        }
        $totalScores += $score
    }
}

$totalScores = ($totalScores | Sort-Object)
$answer = $totalScores[$totalScores.count/2]
Write-Host "The answer for part one is $total"
Write-Host "The answer for part two is $answer"