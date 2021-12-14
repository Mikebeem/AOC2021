function findNextParts {
    param(
        $possiblePath
    )
    #$possiblePath = $item
    $lastPart = $possiblePath[-1]
    $nextParts = $null
    if($possiblePath[-1] -ne "end"){
        $nextParts = $pathChecker | Where-Object { 
            $_ -cmatch $lastPart -and
            $_ -notmatch "start" -and
            ((($_.Split("-")[0] -cmatch "^[a-z]*$" -and $_.Split("-")[0] -cnotin $possiblePath) -or $_.Split("-")[0] -cmatch "^[A-Z]*$" -or $_.Split("-")[0] -eq $lastPart) -and
            (($_.Split("-")[1] -cmatch "^[a-z]*$" -and $_.Split("-")[1] -cnotin $possiblePath) -or $_.Split("-")[1] -cmatch "^[A-Z]*$" -or $_.Split("-")[1] -eq $lastPart))
        } 
    }
    return $nextParts
}

function buildPossiblePaths {
    param(
        $possiblePaths
    )
    $newpossiblePaths = @()
    #$item = $possiblePaths[0]
    foreach ($item in $possiblePaths) {
        if($item[-1] -eq "end"){
            $newpossiblePaths += , ($item)
        }
        else{
            $nextParts = findNextParts $item
            if($nextParts.Count -gt 0){
                foreach($part in $nextParts){
                    $pathToAdd = $null
                    $pathToAdd = ($part.Split("-") | Where-Object {$_ -ne $item[-1] -and $_ -ne "start"})
                    if($pathToAdd){
                        $newpossiblePaths += , ($item + $pathToAdd)
                    }
                    
                }
            }
        }
    }

    return $newpossiblePaths
}


function showPossiblePaths {
    param(
        $possiblePaths
    )
    $i=0

    foreach ($path in $possiblePaths | Sort-Object) {
        write-host ($path -join ",") #$i
        $i++
    }
}

$puzzleInput = Get-Content .\Day12\input.txt
$pathChecker = New-Object System.Collections.ArrayList

$possiblePaths = @()

$puzzleInput | foreach-Object {
    $global:pathChecker.Add($_) | Out-Null
}

$starts = $pathChecker | Where-Object {$_ -match 'start'}

foreach ($start in $starts) {
    $possiblePath = @()
    $possiblePath += "start"
    $next = $start.Split("-") | Where-Object {$_ -ne "start"}
    $possiblePath += $next
    $possiblePaths += , ($possiblePath)
    $continue = $true
    while($continue){
        $possiblePaths = buildPossiblePaths $possiblePaths
        if(($possiblePaths | Where-Object {$_[-1] -ne "end"}).Count -eq 0){
            $continue = $false
        }
    }
}
write-host "the answer is $($possiblePaths.Count)"