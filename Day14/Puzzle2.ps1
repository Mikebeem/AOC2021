function countNewPairs {
    param(
        [PSObject]$pairs
    )
    $newPair = @{}
	foreach ($pair in $pairs.GetEnumerator()) {
		$pair1 = ($pair.Name).Substring(0,1) + $rules[$pair.Name]
		$pair2 = $rules[$pair.Name] + ($pair.Name).Substring(1,1)

        if(-not $newPair[$pair1]){
            $newPair[$pair1] = 0
        }
        if(-not $newPair[$pair2]){
            $newPair[$pair2] = 0
        }
        
        $newPair[$pair1]+= $pair.Value
        $newPair[$pair2]+= $pair.Value
	}
	return $newPair;
}

function calculateTotals {
    param(
        [PSObject]$pairs
    )
	$total = @{}
	foreach ($pair in $pairs.GetEnumerator()) {
		$element = ($pair.Name).Substring(1,1)
		if (-not $total[$element]){
            $total[$element]=0
        } 
		$total[$element]+=$pair.Value
	}
	return $total;
}

[string[]]$puzzleInput = Get-Content -Path .\Day14\input.txt
$template = $puzzleInput[0]
$global:rules = @{}
foreach ($line in $puzzleInput | Where-Object {$_ -match "->"}) {
    $line = $line -replace " "
    $rules.Add($line.Split("->")[0],$line.Split("->")[2])
}
# Maak hash en tel de paren van het 1e template
$pairs = @{}
for ($i=0;$i -lt $template.Length-1;$i++) { 
	$pair = $template.Substring($i,2)
    if(-not $pairs[$pair]){
        $pairs.Add($pair,1)
    }
    else{
        $pairs[$pair]++
    }
}
# Tel nieuwe paren per step
for ($i=0;$i -lt 40;$i++) {
	$pairs = countNewPairs $pairs
}
$totals = calculateTotals $pairs

$counted = $totals.GetEnumerator() | Sort-Object -Property Value -Descending 
$answer = $counted[0].Value - $counted[-1].Value
Write-Host "The answer is $answer"