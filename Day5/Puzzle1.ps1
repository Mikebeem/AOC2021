[string[]]$data = Get-Content -Path .\Day5\input.txt

$size = 1000
$grid = New-object -TypeName 'object[,]' -ArgumentList $size,$size

for($i=0;$i -le ($size-1);$i++){
    for($j=0;$j -le ($size-1);$j++){
        $grid[$i,$j]=0
    }
}

foreach($line in $data){
    [int]$x1=$line.Replace(" -> ","-").Split("-")[0].Split(",")[0]
    [int]$y1=$line.Replace(" -> ","-").Split("-")[0].Split(",")[1]
    [int]$x2=$line.Replace(" -> ","-").Split("-")[1].Split(",")[0]
    [int]$y2=$line.Replace(" -> ","-").Split("-")[1].Split(",")[1]

    if(($x1 -eq $x2) -or ($y1 -eq $y2)) {
        if($x1 -eq $x2){
            if($y1 -gt $y2){
                $temp = $y2
                $y2 = $y1
                $y1 = $temp
            }
            for($y1;$y1 -le $y2;$y1++){
                $grid[$x1,$y1]++
            }
        }
        else {
            if($x1 -gt $x2){
            $temp = $x2
            $x2 = $x1
            $x1 = $temp
            }
            for($x1;$x1 -le $x2;$x1++){
                $grid[$x1,$y1]++
            }
        }
    }
}

[int]$counter = 0
for($i=0;$i -le ($size-1);$i++){
    for($j=0;$j -le ($size-1);$j++){
        if($grid[$i,$j] -ge 2){$counter++}
    }
}
write-host "Danger Spots:" $counter