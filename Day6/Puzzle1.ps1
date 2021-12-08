$data = Get-Content .\Day6\input.txt

[System.Collections.ArrayList]$puzzleInput = $data.split(",")
for($days=0;$days -lt 80; $days++){
    $puzzleInputToAdd = 0
    for($i=0;$i -lt $puzzleInput.Count;$i++){
        switch ($puzzleInput[$i]) {
            0 {
                $puzzleInput[$i] = 6
                $puzzleInputToAdd++
            }
            default {$puzzleInput[$i] = $puzzleInput[$i]-1}
        }
    }
    if($puzzleInputToAdd -gt 0){
        for($j=0;$j -lt $puzzleInputToAdd;$j++){
            $result = $puzzleInput.Add(8)
        }
    }
    
}

Write-Host "total numnber $($puzzleInput.Count)"