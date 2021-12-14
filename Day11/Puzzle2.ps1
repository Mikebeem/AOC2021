function fillGrid {
    param (
        $puzzleInput
    )

    $width = $puzzleInput[0].Length
    $height = $puzzleInput.Count
    $global:grid = New-object -TypeName 'object[,]' -ArgumentList ($height+2),($width+2)

    #Fill grid surrounded by 10's
    for($i=0;$i -lt ($height+2); $i++){
        $grid[$i,0] = 10
        $grid[$($height+1),0] = 10
        $grid[0,$i] = 10
        $grid[0,$($height+1)] = 10
        $grid[$($height+1),$i] = 10
        $grid[$i,$($height+1)] = 10
    }
    for($i=0;$i -lt $height; $i++){
        for($j=0;$j -lt $width; $j++){
            $grid[($i+1),($j+1)] = $puzzleInput[$i][$j]
        }
    }
    #return $grid
}

function countFlashes {
    param(
        [int]$number
    )
    $flashes = ($grid | where {$_ -eq $number} | group | select Count).Count
    return $flashes
}
function increaseAll {
    # eerst alles met 1 ophogen
    for($i=1;$i -lt [math]::Sqrt($grid.Count); $i++){
        for($j=1;$j -lt [math]::Sqrt($grid.Count); $j++){
            #write-host "$i - $j"
            if($grid[$i,$j] -eq 9){
                #Flash
                #$flashes++
                $global:grid[$i,$j] = -1
                #Find adjacent
            }
            elseif($grid[$i,$j] -ne 10){
                #$show = $grid[$i,$j]
                $global:grid[$i,$j] = ([convert]::ToInt32(($grid[$i,$j]), 10) + 1)
            }
        }
    }
}
function checkAdjacent  {
    param (
        $i,
        $j
    )
    #Adjacent is -1 of +1
    for($a=($i-1);$a -le ($i+1); $a++){
        for($b=($j-1);$b -le ($j+1); $b++){
            #0,0 is het item zelf, geen adjacent
           # write-host "a $a b $b"
            if($a -eq $i -and $b -eq $j){
                #$a=0; $b=0
                #naar 0 zetten, niet meer zoeken
                $global:grid[$i,$j] = 0
            }
            else{
                if($grid[$a,$b] -notin (-1,0,9,10)){
                    #niet 0, 9 of 10 ophogen
                    $global:grid[$a,$b] = ([convert]::ToInt32(($grid[$a,$b]), 10) + 1)
                }
                elseif($grid[$a,$b] -eq 9) {
                    #nieuwe flash
                    $global:grid[$a,$b] = -1
                }
            }
        }
    }
}
function increaseAdjacent  {
    for($i=1;$i -le [math]::Sqrt($grid.Count); $i++){
        for($j=1;$j -le [math]::Sqrt($grid.Count); $j++){
            if($grid[$i,$j] -eq -1){
                #Find adjacent
                checkAdjacent $i $j
            }
        }
    }
}

function showGrid {
    for($i=1;$i -lt [math]::Sqrt($grid.Count)-1; $i++){
        $line = ""
        for($j=1;$j -lt [math]::Sqrt($grid.Count)-1; $j++){
            $line += $grid[$i,$j]
        }
        write-host $line
    }
}

[int]$totalflashes = 0

$puzzleInput = Get-Content .\Day11\input.txt

fillGrid $puzzleInput
for($step=0;$step -lt 1000; $step++){
    increaseAll
    while ((countFlashes -1) -gt 0) {
        increaseAdjacent
    }
    #Added for Puzzle 2
    if((countFlashes 0) -eq 100){
        write-Host "They all flash at $($step+1) !!!"
        exit
    }
    #End of puzzle 2
    $totalflashes += countFlashes 0
}

$totalflashes