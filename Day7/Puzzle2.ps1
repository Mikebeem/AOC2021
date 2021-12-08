[double[]]$crabs = (Get-Content .\Day7\input.txt).Split(",")

[double]$avg = ($crabs |  Measure-Object -Average).Average

$floor = [System.Math]::Floor($avg)
$ceil = [System.Math]::Ceiling($avg)

$totalFloor=0
$totalCeil=0
for($i=0; $i -lt $crabs.Count; $i++){
    if($floor -lt $crabs[$i]){
        $steps = ($crabs[$i]-$floor)
        for($step=1; $step -le $steps; $step++){
            $totalFloor += $step
        }
    }
    elseif($floor -gt $crabs[$i]){
        $steps = ($floor-$crabs[$i])
        for($step=1; $step -le $steps; $step++){
            $totalFloor += $step
        }
    }
    if($ceil -lt $crabs[$i]){
        $steps = ($crabs[$i]-$ceil)
        for($step=1; $step -le $steps; $step++){
            $totalCeil += $step
        }
    }
    elseif($ceil -gt $crabs[$i]){
        $steps = ($ceil - $crabs[$i])
        for($step=1; $step -le $steps; $step++){
            $totalCeil += $step
        }
    }
    
}
$total = ($totalFloor, $totalCeil | Measure-Object -Minimum).Minimum
Write-Host "Value is $($avg) - fuel $total"