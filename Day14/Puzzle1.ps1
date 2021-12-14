[string[]]$puzzleInput = Get-Content -Path .\Day14\input.txt

$template = $puzzleInput[0]

$lookupTable = @{}
foreach ($line in $puzzleInput | Where-Object {$_ -match "->"}) {

    $line = $line -replace " "
    $search = $line.Split("->")[0]
    $lookupTable.Add($search,$search[0] + $line.Split("->")[2] + $search[1])
}

for($i=0; $i -lt 10; $i++){
    $templateNew = ""
    for($j=0; $j -lt $template.Length-1; $j++){
        $toAdd = $template.Substring($j,1)
        foreach($lookup in $lookupTable.GetEnumerator()){
            if($template.Substring($j,2) -match $lookup.Key)
            {
                $toAdd = $template.Substring($j,2) -replace $lookup.Key, $lookup.Value
            }
        }
        if($j -eq 0){
            $templateNew += $toAdd.Substring(0,1)
        }
        $templateNew += $toAdd.Substring(1,2)
    }
    $template = $templateNew
}

$counted = ($template.ToCharArray()) | Group-Object | Sort-Object Count -Descending | Select-Object Name, Count
$answer = $counted[0].Count - $counted[-1].Count
Write-Host "The answer is $answer"