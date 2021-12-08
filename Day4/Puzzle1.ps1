$puzzleInput = Get-Content  -Raw .\Day4\input.txt

$boards = $puzzleInput -split "`r?`n`r?`n" | ForEach-Object { 
    ,($_ -split "`r?`n"| ForEach-Object  {
         ,($_ -split '\D+' | Where-Object {
             $_
            }) 
        })
 }
 $drawn = $boards[0]

function endGame($board,[int]$number){
    Write-Host "The winner is! $($board)"
    #$board 
    [int]$total = 0
    foreach($row in 0..4){
        foreach($col in 0..4){
            if($board[$row][$col] -ne 100){
               
                $total += $board[$row][$col]
                
            }
        }
    }
    Write-Host "Total: $total - $($total.GetType())"
    Write-Host "number: $number - $($number.GetType())"
    Write-Host "Answer is: $($number*$total)"
    exit 0
}
foreach($number in $drawn){
    for($i=1;$i -lt $boards.count; $i++){
        #eerst het nummer vervangen door 100
        # $boards[1][0] = eerste bord, eerste rij
        # $boards[1][0][0] = eerste bord, eerste waarde uit eerste rij
        $board = $boards[$i]
        foreach($row in 0..4){
            foreach($col in 0..4){
                if($board[$row][$col] -eq $number){
                    $board[$row][$col] = 100
                }
            }
        }
    }

    for($i=1;$i -lt $boards.count; $i++){
        # check per rij en colom of alles op 100 staat
        # $boards[1][0] = eerste bord, eerste rij
        # $boards[1][0][0] = eerste bord, eerste waarde uit eerste rij
        $board = $boards[$i]
        foreach($row in 0..4){
            if(($board[$row][0] -eq 100) -and ($board[$row][1] -eq 100) -and ($board[$row][2] -eq 100) -and ($board[$row][3] -eq 100) -and ($board[$row][4] -eq 100)){
                Write-Host "We got a winner!"
                endGame $board $number
            }
        }

        foreach($col in 0..4){
            if(($board[0][$col] -eq 100) -and ($board[1][$col] -eq 100) -and ($board[2][$col] -eq 100) -and ($board[3][$col] -eq 100) -and ($board[4][$col] -eq 100)){
                Write-Host "We got a winner!"
                endGame $board $number
            }
        }
    }
}
