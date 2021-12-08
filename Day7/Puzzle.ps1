[double[]]$crabs = (Get-Content .\Day7\input.txt).Split(",")

$crabs = $crabs | sort
if ($crabs.count%2) {
    #odd
    $medianvalue = $crabs[[math]::Floor($crabs.count/2)]
}
else {
    #even
    $MedianValue = ($crabs[$crabs.Count/2],$crabs[$crabs.count/2-1] |measure -Average).average
}    
$total=0
for($i=0; $i -lt $crabs.Count; $i++){
    if($MedianValue -lt $crabs[$i]){
        $total += ($crabs[$i]-$MedianValue)
    }
    elseif($MedianValue -gt $crabs[$i]){
        $total += ($MedianValue-$crabs[$i])
    }
}
Write-Host "Value is $($MedianValue) - fuel $total"