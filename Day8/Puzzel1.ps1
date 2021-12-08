[string[]] $puzzleInput = Get-Content .\Day8\input.txt
$total = 0
for($i=0;$i -lt $puzzleInput.count; $i++){
    $outputValue = $puzzleInput[$i].Split("|")[1].Split(" ") 

    foreach($value in $outputValue){
        switch ($value.Length) {
            2 { $total++ }
            4 { $total++}
            3 { $total++} 
            7 { $total++}
        }
    }
    
}
write-host "Total = $total"
<#
$1 = 2
$4 = 4
$7 = 3
$8 = 7

#>