function playDiracDice ($p1, $p1Score, $p2, $p2Score, $turn){
    <#

    Elke beurt maakt een speler 3 tot 9 moves.
    
    Speler 1 gooit een 1, een 2 en een 3.
    Speler 2 gooit een 1, een 2 en een 3.

        Universe 1: Speler 1 heeft 1 gegooid, mag nog 2 keer gooien. Gooit een 2 en een 3.
        Universe 2: Speler 1 heeft 2 gegooid, mag nog 2 keer gooien. Gooit een 3 en een 1.
        Universe 3: Speler 1 heeft 3 gegooid, mag nog 2 keer gooien. Gooit een 1 en een 2.

    #>
    if($history["[$p1, $p1Score, $p2, $p2Score, $turn]"])
    {
        return $history["[$p1, $p1Score, $p2, $p2Score, $turn]"]
    }
    if($p1Score -ge $maxScore){
        $history["[$p1, $p1Score, $p2, $p2Score, $turn]"] = @(1,0)
        return @(1,0)
    }
    if($p2Score -ge $maxScore){
        $history["[$p1, $p1Score, $p2, $p2Score, $turn]"] = @(0,1)
        return @(0,1)
    }
    $totalWins = @([int64] 0, [int64] 0)

    for ($i = 1; $i -le 3; $i++) {
        for ($j= 1; $j -le 3; $j++) {
            for ($k = 1; $k -le 3; $k++) {
                if($turn -eq 1){
                    $newPosition = $board[($p1 + $i + $j + $k -1) % 10]
                    $wins = playDiracDice $newPosition ($p1Score + $newPosition) $p2 $p2Score 2
                    $totalWins[0] += $wins[0]
                    $totalWins[1] += $wins[1]
                }else{
                    $newPosition = $board[($p2 + $i + $j + $k -1) % 10]
                    $wins = playDiracDice $p1 $p1Score $newPosition ($p2Score + $newPosition) 1
                    $totalWins[0] += $wins[0]
                    $totalWins[1] += $wins[1]
                }
            }
        }
    }
    $history["[$p1, $p1Score, $p2, $p2Score, $turn]"] = $totalWins
    return $totalWins
}

$p1 = 5
$p1Score = 0
$p2 = 10
$p2Score = 0

$maxScore = 21
#player 1 starts
$turn = 1

$global:board = @(1,2,3,4,5,6,7,8,9,10)

$global:history = @{}

$score = playDiracDice $p1 $p1Score $p2 $p2Score $turn
$score

#$scores = $($p1Score, $p2Score)
#($scores | Sort-Object | Select-Object -First 1) * $totalRolls