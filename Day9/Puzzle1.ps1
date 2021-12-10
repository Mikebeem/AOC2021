$puzzleInput = Get-Content .\Day9\input.txt

$size = $puzzleInput[0].Length
$height = $puzzleInput.Length

$grid = New-object -TypeName 'object[,]' -ArgumentList $height,$size

for($i=0;$i -lt $height; $i++){
    for($j=0;$j -lt $size; $j++){
        $grid[$i,$j] = $puzzleInput[$i][$j]
    }
}

[int]$total = 0
[int]$counter = 0
for($i=0;$i -le ($height-1);$i++){
    for($j=0;$j -le ($size-1);$j++){
        #1e regel
        if($i -eq 0){  #1e regel eerste rij
            if($j -eq 0 -and $grid[$i,$j] -lt $grid[($i+1),$j] -and $grid[$i,$j] -lt $grid[$i,($j+1)]){
                $value = $grid[$i,$j]
                $total+= [convert]::ToInt32($value, 10)+1
                $counter++
            } #1e regel laatste rij
            elseif($j -eq ($size -1) -and $grid[$i,$j] -lt $grid[($i+1),$j] -and $grid[$i,$j] -lt $grid[$i,($j-1)]){
                $value = $grid[$i,$j]
                $total+= [convert]::ToInt32($value, 10)+1
                $counter++
            }#tussenligende rijen
            elseif($j -ne 0 -and $grid[$i,$j] -lt $grid[($i+1),$j] -and $grid[$i,$j] -lt $grid[$i,($j+1)] -and $grid[$i,$j] -lt $grid[$i,($j-1)]){
                $value = $grid[$i,$j]
                $total+= [convert]::ToInt32($value, 10)+1
                $counter++
            }
        }
        elseif($i -eq ($height-1)){ # laatste regel
            if($j -ne 0 -and $j -ne $size-1 -and $grid[$i,$j] -lt $grid[($i-1),$j] -and $grid[$i,$j] -lt $grid[$i,($j+1)] -and $grid[$i,$j] -lt $grid[$i,($j-1)]){
                $value = $grid[$i,$j]
                $total+= [convert]::ToInt32($value, 10)+1
                $counter++
            } #laatste regel eerste rij
            elseif($j -eq 0 -and $grid[$i,$j] -lt $grid[($i-1),$j] -and $grid[$i,$j] -lt $grid[$i,($j+1)]){
                $value = $grid[$i,$j]
                $total+= [convert]::ToInt32($value, 10)+1
                $counter++
            } #laatste regel laatste rij
            elseif($j -eq ($size -1) -and $grid[$i,$j] -lt $grid[($i-1),$j] -and $grid[$i,$j] -lt $grid[$i,($j-1)]){
                $value = $grid[$i,$j]
                $total+= [convert]::ToInt32($value, 10)+1
                $counter++
            }
        }
        else{
            if($j -eq ($size - 1) -and $grid[$i,$j] -lt $grid[($i-1),$j] -and $grid[$i,$j] -lt $grid[($i+1),$j] -and $grid[$i,$j] -lt $grid[$i,($j-1)]){
                $value = $grid[$i,$j]
                $total+= [convert]::ToInt32($value, 10)+1
                $counter++
            }
            elseif($j -eq 0 -and $grid[$i,$j] -lt $grid[($i-1),$j] -and $grid[$i,$j] -lt $grid[($i+1),$j] -and $grid[$i,$j] -lt $grid[$i,($j+1)]){
                $value = $grid[$i,$j]
                $total+= [convert]::ToInt32($value, 10)+1
                $counter++
            }
            elseif($grid[$i,$j] -lt $grid[($i-1),$j] -and $grid[$i,$j] -lt $grid[($i+1),$j] -and $grid[$i,$j] -lt $grid[$i,($j-1)] -and $grid[$i,$j] -lt $grid[$i,($j+1)]){
                $value = $grid[$i,$j]
                $total+= [convert]::ToInt32($value, 10)+1
                $counter++
            }
        }
    }
}
Write-Host "results:"
$counter
$total