$stopwatch =  [system.diagnostics.stopwatch]::StartNew()

$puzzleInput = Get-Content .\Day12\input.txt
$caves = @{}
$possibleCounts = 0
$line = $puzzleInput[0]
foreach($line in $puzzleInput){
    $a = ($line -split '-')[0]
    $b = ($line -split '-')[1]
    if(-not ($a -in $caves.$b) -and ($a -ne "start") -and ($b -ne "end")){
        $caves.$b += , $a
    }
    if(-not ($b -in $caves.$a) -and ($b -ne "start") -and ($a -ne "end")){
        $caves.$a += , $b
    }
}

function buildPossiblePaths{
    param(
        [String[]] $path = @(),
        [String[]] $used = @(),
        [String] $usedTwice = ""
    )
    $last = $path[-1]
    $possibleCaves = [String[]]$caves.$last
    #$possibleCave = $possibleCaves[0]
    foreach($possibleCave in $possibleCaves){
        if($possibleCave -eq "end"){
            $script:possibleCounts++
            continue
        }
        $newUsed = $used
        $newUsedTwice = $usedTwice
        # Lowercase
        if($possibleCave -cmatch "^[a-z]*$"){
            if($possibleCave -in $newUsed){
                if($newUsedTwice -eq ""){
                    #Lowercase mag 2 keer voorkomen
                    $newUsedTwice = $possibleCave
                }
                else{
                    #2e keer stoppen
                    continue
                }
            }
            else{
                $newUsed = $newUsed + $possibleCave
            }
        }
        $newPath = ($path + $possibleCave)
        buildPossiblePaths $newPath $newUsed $newUsedTwice
    }
}
buildPossiblePaths "start"
write-host "The answer to part 2 is: $possibleCounts"

$stopwatch.Stop()
$minutes = $stopwatch.Elapsed.Minutes
$seconds = $stopwatch.Elapsed.Seconds
$milliseconds = $stopwatch.Elapsed.Milliseconds
"Run took {0} minutes {1} seconds and {2} milliseconds" -f $minutes,$seconds,$milliseconds