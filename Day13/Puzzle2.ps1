function showFoldedGrid {
    param(
        [System.Array]$grid
    )
    $height = $grid.GetLength(0)
    $size = $grid.GetLength(1)
    for($i=0;$i -le $height; $i++){
        $line = ""
        for($j=0;$j -le $size; $j++){
            $line += $grid[$i,$j]
        }
        write-host $line
    }
}
function foldGridy {
    param(
        [int]$xValue,
       [Object[,]] $grid
    )
    $height = $grid.GetLength(0)
    $size = $grid.GetLength(1)
    [int]$x1 = $xValue + 1
    $newHeight = $height - $x1
    $global:foldedgrid = New-object -TypeName 'object[,]' -ArgumentList $newHeight,$size

    for($i=0;$i -lt $newHeight; $i++){
        for($j=0;$j -lt $size; $j++){
                $foldedgrid[$i,$j] = $grid[$i,$j]
        }
    }
    
    $newX = 0
    for($i=($height-1);$i -gt $xValue; $i--){
        for($j=0;$j -lt $size; $j++){
            if($grid[$i,$j] -eq "#"){
                #write-host "newX $newX i $i j $j height $height size $size newHeight $newHeight grid $($grid[$i,$j])"
                $foldedgrid[$newX,$j] = $grid[$i,$j]
            }
        }
        $newX++
    }
}

function foldGridx {
    param(
        [int]$yValue,
        [Object[,]] $grid
    )
    $height = $grid.GetLength(0)
    $size = $grid.GetLength(1)
    [int]$y1 = $yValue + 1
    
    $newSize = $size - $y1
    $global:foldedgrid = New-object -TypeName 'object[,]' -ArgumentList $height,$newSize

    for($i=0;$i -lt $height; $i++){
        for($j=0;$j -lt $newSize; $j++){
                $foldedgrid[$i,$j] = $grid[$i,$j]
        }
    }
    for($i=0;$i -lt $height; $i++){
        $newY = 0
        for($j=($size-1);$j -gt $yValue; $j--){

            if($grid[$i,$j] -eq "#"){
                #write-host "newy $newy i $i j $j height $height size $size newHeight $newSize grid $($grid[$i,$j])"
                $foldedgrid[$i,$newY] = $grid[$i,$j]
            }
            $newY++
        }
    }
    
}
$puzzleInput = Get-Content .\Day13\input.txt
$a = @()
$b = @()
foreach ($line in $puzzleInput | Where-Object {$_ -notmatch "fold" -and $_ -ne ""}) {
    $a+= $line.split(',')[0]
    $b+= $line.split(',')[1]
}
$size = (($a | Measure-Object -Maximum).Maximum)+1
$height = (($b | Measure-Object -Maximum).Maximum)+1

$grid = New-object -TypeName 'object[,]' -ArgumentList $height,$size

for($i=0;$i -lt $height; $i++){
    for($j=0;$j -lt $size; $j++){
        $grid[$i,$j] = "."
    }
}
foreach ($coords in $puzzleInput | Where-Object {$_ -notmatch "fold" -and $_ -ne ""}) {
    $grid[($coords.Split(",")[1]),($coords.Split(",")[0])]= "#"
}

$foldInstructions = ($puzzleInput | Where-Object {$_ -match "fold" -and $_ -ne ""})

foreach ($instruction in $foldInstructions) {
    $value = $instruction.Split("=")[1]
    $direction = $instruction.Split("=")[0][-1]
    if($direction -eq "x"){
        foldGridx $value $grid
        $grid = $foldedgrid.psObject.Copy()
    }
    else{
        foldGridy $value $grid
        $grid = $foldedgrid.psObject.Copy()
    }
}

showFoldedGrid $grid