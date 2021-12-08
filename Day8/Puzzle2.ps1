[string[]] $puzzleInput = Get-Content .\Day8\input.txt
$total = 0


for($i=0;$i -lt $puzzleInput.count; $i++){
    $signalPattern = $puzzleInput[$i].Replace(" | ","|").Split("|")[0].Split(" ") 
    $outputValue = $puzzleInput[$i].Replace(" | ","|").Split("|")[1].Split(" ") 
    
    $signalOne = (($signalPattern | Where-Object {$_.Length -eq 2}).ToCharArray() | Sort-Object) -join ""
    $signalFour = (($signalPattern | Where-Object {$_.Length -eq 4}).ToCharArray() | Sort-Object) -join ""
    $signalSeven = (($signalPattern | Where-Object {$_.Length -eq 3}).ToCharArray() | Sort-Object) -join ""
    $signalEight = (($signalPattern | Where-Object {$_.Length -eq 7}).ToCharArray() | Sort-Object) -join ""
    
    foreach($signal in $signalPattern){
        if($signal.length -eq 6){
            # 0, 6 of 9
            $signalArray = ($signal.ToCharArray() | Sort-Object)
            if(($signalArray | Where-Object { ($signalOne.ToCharArray()) -notcontains $_ }).Length -eq 5){
                $signalSix = ($signal.ToCharArray() | Sort-Object) -join ""
            }
            elseif(($signalArray | Where-Object { ($signalFour.ToCharArray()) -notcontains $_ }).Length -eq 3){
                $signalZero = ($signal.ToCharArray() | Sort-Object) -join ""
            }
            else{
                $signalNine = ($signal.ToCharArray() | Sort-Object) -join ""
            }
            
        }
        if($signal.length -eq 5){
            # 2, 3, 5
            $signalArray = ($signal.ToCharArray() | Sort-Object)
            if(($signalArray | Where-Object { ($signalOne.ToCharArray()) -notcontains $_ }).Length -eq 3){
                $signalThree = ($signal.ToCharArray() | Sort-Object) -join ""
            }
            elseif(($signalArray | Where-Object { ($signalFour.ToCharArray()) -notcontains $_ }).Length -eq 3){
                $signalTwo = ($signal.ToCharArray() | Sort-Object) -join ""
            }
            else{
                $signalFive = ($signal.ToCharArray() | Sort-Object) -join ""
            }
        }
    }
    $valueString = ""
    foreach($value in $outputValue){
        switch (($value.ToCharArray() | Sort-Object) -join "") {
            $signalZero { $valueString += "0" }
            $signalOne { $valueString += "1" }
            $signalTwo { $valueString += "2" }
            $signalThree { $valueString += "3" }
            $signalFour { $valueString += "4" }
            $signalFive { $valueString += "5" }
            $signalSix { $valueString += "6" }
            $signalSeven { $valueString += "7" }
            $signalEight { $valueString += "8" }
            $signalNine { $valueString += "9" }
        }
    }
    [int]$valueint = $valueString
    $total += $valueint 
}


write-host "Total = $total"
<#
$1 = 2
$4 = 4
$7 = 3
$8 = 7

#>