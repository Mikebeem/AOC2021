$p1 = 4
$p1Score = 0
$p2 = 8
$p2Score = 0

$diceMax = 100
$turns = 3
$totalRolls = 0
#player 1 starts
$turn = 1
$dice = 0

while($p1Score -lt 1000 -and $p2Score -lt 1000){
    $moves = 0
    #each player rolls three times
    for ($i = 1; $i -lt 4; $i++) {
        if($dice -eq $diceMax){
            $dice=0
        }
        $dice++
        $totalRolls++
        $moves += $dice
    }
    
    if($turn -eq 1){
        for($j=1; $j -le $moves; $j++){
            if($p1 -eq 10){
                $p1=0
            }
            $p1++
        }
        $p1Score += $p1
        $turn = 2
        #$p1Score
    }
    elseif($turn -eq 2){
        for($j=1; $j -le $moves; $j++){
            if($p2 -eq 10){
                $p2=0
            }
            $p2++
        }
        $p2Score += $p2
        $turn = 1
        #$p2Score
    }
    #switch turns
}

$scores = $($p1Score, $p2Score)
($scores | Sort-Object | Select-Object -First 1) * $totalRolls