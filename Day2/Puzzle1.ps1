[string[]] $puzzleInput = Get-Content .\Day2\input.txt
$horizontal = 0
$depth = 0

foreach($line in $puzzleInput){
    switch ($line.Split(" ")[0]) {
        "forward" { $horizontal += $line.Split(" ")[1] }
        "down" { $depth += $line.Split(" ")[1] }
        "up" { $depth -= $line.Split(" ")[1] }
    }
}

Write-Host "The answer is: $($horizontal*$depth)" 