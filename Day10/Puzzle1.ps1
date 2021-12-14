[string[]] $puzzleInput = Get-Content .\Day10\input.txt

$validOpener = @("(","{","[","<")
$complete = @("()","{}","[]","<>")
$total = 0
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
}

Write-Host "The answer is $total"