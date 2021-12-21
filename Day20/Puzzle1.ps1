function showGrid ([object]$grid) {
    for($i=0;$i -lt [math]::Sqrt($grid.Count); $i++){
        $line = ""
        for($j=0;$j -lt [math]::Sqrt($grid.Count); $j++){
            $line += $grid[$i,$j]
        }
        write-host $line
    }
}

function enhanceGrid ([PSobject]$inputGrid, $imgEnh, $times) {
    for($time=0; $time -lt $times; $time++){
        $inputGrid = $grid 
        $size = [math]::Sqrt($grid.Count) + 2
        $height = [math]::Sqrt($grid.Count) + 2
        $start = ($size - [math]::Sqrt($grid.Count)) / 2
        $grid = New-object -TypeName 'object[,]' -ArgumentList $size, $height
        $default=[System.Convert]::ToInt32($imgEnh[0], 2) * $time % 2
        for($i=0;$i -lt $size;$i++){
            for($j=0;$j -lt $size;$j++){
                $whereI = ($i - $start)
                $whereJ = ($j - $start)
                [string]$value  = ""

                for($a=($whereI-1);$a -le ($whereI+1); $a++){
                    for($b=($whereJ-1);$b -le ($whereJ+1); $b++){
                        if($inputGrid[$a,$b] -and $a -ge 0 -and $a -le $size-3 -and $b -ge 0 -and $b -le $size-3){
                            $value += $inputGrid[$a,$b]
                        }
                        else{
                            $value += $default
                        }
                    }
                }
                [int]$index = [System.Convert]::ToInt32($value, 2)
                $grid[$i,$j] = $imgEnh[$index]
            }
        }
    }
    ($grid | Where-Object {$_ -eq "1"}).Count
}

[string[]]$puzzleInput = Get-Content -Path .\Day19\input.txt
$imgEnh = $puzzleInput[0].Replace("#","1").Replace(".","0")

$size = $puzzleInput[2].Length
$height = ($puzzleInput.Count - 2)

$grid = New-object -TypeName 'object[,]' -ArgumentList $size, $height
$start = 1

for($i=2;$i -lt ($size +2);$i++){
    for($j=0;$j -lt ($size);$j++){
        $value = 0
        if($puzzleInput[$i][$j] -eq "#"){
            $value = 1
        }
        
        $grid[($i-2),$j] = $value
    }
}

#Part 1:
enhanceGrid $grid $imgEnh 2

#part 2: 
enhanceGrid $grid $imgEnh 50