$puzzleInput = Get-Content  -Raw .\Day4\input.txt

[System.Collections.ArrayList]$boards = $puzzleInput -split "`r?`n`r?`n" | ForEach-Object { 
    ,($_ -split "`r?`n"| ForEach-Object  {
         ,($_ -split '\D+' | Where-Object {
             $_
            }) 
        })
 }
 $drawn = $boards[0]

 $boards.GetType()

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

$boards.RemoveAt(0)
$boardsCount = $boards.count

foreach($number in $drawn){
    for($i=0;$i -lt $boards.count; $i++){
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
        if($boards.Count -eq 1){
            endGame $board $number
        }
    }
    for($i=0;$i -lt $boards.count; $i++){
        # check per rij en colom of alles op 100 staat
        # $boards[1][0] = eerste bord, eerste rij
        # $boards[1][0][0] = eerste bord, eerste waarde uit eerste rij
        $board = $boards[$i]
        $removed = $false
        foreach($row in 0..4){
            if(($board[$row][0] -eq 100) -and ($board[$row][1] -eq 100) -and ($board[$row][2] -eq 100) -and ($board[$row][3] -eq 100) -and ($board[$row][4] -eq 100)){
               
                if($boards.Count -gt 0){
                    $boards.RemoveAt($i)
                    $removed = $true
                    #$i-=1
                    Write-Host "Removed $i, number $number, boards left: $($boards.Count). Row"
                    break
                }
                
            }
        }
        if($removed -eq $false){
            foreach($col in 0..4){
                if(($board[0][$col] -eq 100) -and ($board[1][$col] -eq 100) -and ($board[2][$col] -eq 100) -and ($board[3][$col] -eq 100) -and ($board[4][$col] -eq 100)){
                    
                    if($boards.Count -gt 0){
                        $boards.RemoveAt($i)
                        Write-Host "Removed $i, number $number, boards left: $($boards.Count). Col"
                        #$i-=1
                        break
                    }
                }
            }
        }
        
    }
    
}
$boards.Count
$boards[0]