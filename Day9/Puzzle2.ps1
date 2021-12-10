$puzzleInput = Get-Content .\Day9\input.txt

$size = $puzzleInput[0].Length
$height = $puzzleInput.Length

$grid = New-object -TypeName 'object[,]' -ArgumentList ($height+2),($size+2)
$visited = New-object -TypeName 'object[,]' -ArgumentList ($height+2),($size+2)

for($i=0;$i -lt $height; $i++){
    for($j=0;$j -lt $size; $j++){
        if($i -eq 0 -or $j -eq 0){
            $grid[($i),($j)] = 9
        }
        $grid[($i+1),($j+1)] = $puzzleInput[$i][$j]
        $visited[$i,$j] = 0
    }
}

function checkDown {
    Param(
        $x,
        $y
    )

    $counter = 0
    if(([convert]::ToInt32(($grid[($x+1),$y]), 10) -lt 9)){
        do {
            $x++
            if($visited[$x,$y] -eq 0){
                $counter++
                $visited[$x,$y] = 1
            }
            if($visited[$x,($y-1)] -eq 0){$counter += checkLeft -x $x -y $y}
            if($visited[$x,($y+1)] -eq 0){ $counter += checkRight -x $x -y $y}
        } while ($grid[($x+1),$y] - $grid[$x,$y] -gt 0 -and [convert]::ToInt32(($grid[($x+1),$y]), 10) -lt 9)
    }
    return $counter
}

function checkUp {
    Param(
        [int]$x,
        [int]$y
    )

    $counter = 0
    
    if([convert]::ToInt32(($grid[($x-1),$y]), 10) -lt 9){
        do {
            $x--
            if($visited[$x,$y] -eq 0){
                $counter++
                $visited[$x,$y] = 1
            }
            if($visited[$x,($y-1)] -eq 0){$counter += checkLeft -x $x -y $y}
            if($visited[$x,($y+1)] -eq 0){ $counter += checkRight -x $x -y $y}
        } while ($grid[($x-1),$y] - $grid[$x,$y] -gt 0 -and [convert]::ToInt32(($grid[($x-1),$y]), 10) -lt 9)
    }
    

    return $counter
}

function checkLeft {
    Param(
        $x,
        $y
    )

    $counter = 0
    if([convert]::ToInt32(($grid[$x,($y-1)]), 10) -lt 9){
        do {
            $y--
            if($visited[$x,$y] -eq 0){
                $counter++
                $visited[$x,$y] = 1
            }
            if($visited[($x+1),$y] -eq 0){ $counter += checkDown -x $x -y $y}
            if($visited[($x-1),$y] -eq 0){$counter += checkUp -x $x -y $y}
            

        } while ($grid[$x,($y-1)] - $grid[$x,$y] -gt 0 -and [convert]::ToInt32(($grid[$x,($y-1)]), 10) -lt 9)
    }
    return $counter
}

function checkRight {
    Param(
        $x,
        $y
    )

    $counter = 0
    if([convert]::ToInt32(($grid[$x,($y+1)]), 10) -lt 9){
        do {
            $y++
            if($visited[$x,$y] -eq 0){
                $counter++
                $visited[$x,$y] = 1
            }
            
            if($visited[($x+1),$y] -eq 0){ $counter += checkDown -x $x -y $y}
            if($visited[($x-1),$y] -eq 0){$counter += checkUp -x $x -y $y}
            
        } while ($grid[$x,($y+1)] - $grid[$x,$y] -gt 0 -and [convert]::ToInt32(($grid[$x,($y+1)]), 10) -lt 9)
    }
    return $counter
}

function findBasins{
    Param(
        $grid,
        $i,
        $j
    )
    [int]$basin = 1

    $visited[$i,$j] = 1
    
    $basin += checkDown -x $i -y $j
    $basin += checkLeft -x $i -y $j
    $basin += checkUp -x $i -y $j
    $basin += checkRight -x $i -y $j
    
    return $basin
}

$basins = @()
for($i=0;$i -le ($height-1);$i++){
    for($j=0;$j -le ($size-1);$j++){
       if($grid[$i,$j] -lt $grid[($i-1),$j] -and $grid[$i,$j] -lt $grid[($i+1),$j] -and $grid[$i,$j] -lt $grid[$i,($j-1)] -and $grid[$i,$j] -lt $grid[$i,($j+1)]){
            $basins += findBasins -grid $grid -i $i -j $j
        }
    }
}
$basins = $basins | Sort-Object -desc | Select-Object -First 3 
$total = $basins[0] * $basins[1] * $basins[2]
Write-Host "Answer is: $($total)"
#Should be 920448