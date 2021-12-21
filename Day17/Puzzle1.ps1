$xtargetMin = 153
$xtargetMax = 199
$ytargetMin = -114
$ytargetMax = -75

$x=0
$y=0

$tries = 100

$maxY = 0
$hit=0
for($j=0;$j -lt $xtargetMax+1; $j++){
    $xVel = $j
    for($k=$ytargetMin;$k -lt $xtargetMin; $k++){
        $yVel = $k
        $highestY = 0
        $x=0
        $y=0

        for($i=0;$i -lt 300 ; $i++)
        {
            if($xVel-$i -gt 0){
                #-= 1
                $x += $xVel-$i
            }
            $y += $yVel - $i
            if($y -gt $highestY){
                $highestY = $y
            }
            if($x -ge $xtargetMin -and $x -le $xtargetMax -and $y -ge $ytargetMin -and $y -le $ytargetMax){
                $hit++
                if($highestY -gt $maxY){
                    $maxY = $highestY
                }
                break
            }
        }
    }
}

Write-host "Answer for 1: $maxY"
Write-host "Answer for 1: $hit"