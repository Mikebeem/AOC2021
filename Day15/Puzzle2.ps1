$INFINITY = [int]::MaxValue-1
function edge ([char] $weight, [string] $dest)
{
    [int]$weight = [convert]::ToInt32($weight, 10)
    @{weight = $weight; dest = $dest}
}

function Vertex( [object[]] $connections)
{
    @{
       connections = $connections; # An array of weighted arcs
       numconnect = $connections.length
       distance = $INFINITY
       isDead = $false
    }
}

function Dijkstra([object] $graph, [string] $source)
{#$source="0.0"
    [int] $nodecount = $graph.Count
    $graph[$source].distance = 0
    #$graph[$source].connections[0]
   # $continueWith = $graphL.First
    $last = $graphL.Last
    for($i = 0; $i -lt $nodecount; $i++) {
        #write-Host "Proces $i of $($graph.Count)"
        if($i % ($graph.Count/100)-eq 0){
            write-Host "Proces $i of $($graph.Count) - $($stopwatch.Elapsed)"
        }
        $min = $INFINITY+1
        # find the unchecked node closest to the source
        $current = $graphL.First
        for($k = 0; $graphL.Count; $k++) {
            #$current.Value.ID.getType()
            $id = $current.Value.ID
            
            if(! $graph[$id].isDead -and $graph[$id].distance -lt $min) {
                $next = $current.Value.ID
                $min = $graph[$current.Value.ID].distance
                $last = $current
            }
            if($current.Value.ID -eq $last.Value.ID){
                #write-host "End! $k $($current.Value.ID)"
                break
            }
            
            $current = $current.Next
            
        }
        <#foreach ($pair in $graph.GetEnumerator()) {
            if(! $graph[$pair.Name].isDead -and $graph[$pair.Name].distance -lt $min) {
                $next = $pair.Name
                $min = $graph[$pair.Name].distance
            }
        }#>
        # check all paths from node 
        for($j = 0; $j -lt $graph[$next].numconnect; $j++)
        {
            if($graph[$graph[$next].connections[$j].dest].distance -gt
               $graph[$next].distance + $graph[$next].connections[$j].weight)
            {
                $graph[$graph[$next].connections[$j].dest].distance =
                    $graph[$next].distance + $graph[$next].connections[$j].weight
            }
        }
        $graph[$next].isDead = $true
        $graphL.Remove($last)
    }
    foreach ($pair in $graph.GetEnumerator()) {
        "The distance between nodes {0} and {1} is {2}" -f
            $source, $pair.Name, $graph[$pair.Name].distance
    }
}


function createGraph ([string[]]$puzzleInput) {
    #$puzzleInput = $expended
        $width = $puzzleInput[0].Length
        $height = $puzzleInput.Count
    #$timerCount = 0
        $script:graphL = New-Object -TypeName 'Collections.Generic.LinkedList[PSCustomObject]'
        $graph = [ordered]@{}
        
        for($i=0;$i -lt $height; $i++){
            for($j=0;$j -lt $width; $j++){
                $script:graphL.Add(@{ID="$i.$j"})
                $timerCount++
                if($timerCount % (($width*$height)/10)-eq 0){
                    write-Host "Graph $timerCount of $($width*$height) - $($stopwatch.Elapsed)"
                }
                if($i -eq 0 -and $j -eq 0){
                    $graph["$i.$j"] += vertex (edge -w $puzzleInput[$i][($j+1)] -d "$i.$($j+1)"),(edge -w $puzzleInput[($i+1)][$j] -d "$($i+1).$j")
                }
                elseif ($i -eq 0 -and $j -eq ($width-1)) {
                    $graph["$i.$j"] += vertex (edge -w $puzzleInput[($i+1)][$j] -d "$($i+1).$j"),(edge -w $puzzleInput[$i][($j-1)] -d "$i.$($j-1)")
                }
                elseif ($i -eq 0) {
                    $graph["$i.$j"] += vertex (edge -w $puzzleInput[$i][($j+1)] -d "$i.$($j+1)"),(edge -w $puzzleInput[($i+1)][$j] -d "$($i+1).$j"),(edge -w $puzzleInput[$i][($j-1)] -d "$i.$($j-1)")
                }
                elseif ($j -eq 0 -and $i -eq ($height-1)) {
                    $graph["$i.$j"] += vertex (edge -w $puzzleInput[$i][($j+1)] -d "$i.$($j+1)"),(edge -w $puzzleInput[($i-1)][$j] -d "$($i-1).$($j)")
                }
                elseif ($j -eq 0) {
                    $graph["$i.$j"] += vertex (edge -w $puzzleInput[$i][($j+1)] -d "$i.$($j+1)"),(edge -w $puzzleInput[($i+1)][$j] -d "$($i+1).$j"),(edge -w $puzzleInput[($i-1)][$j] -d "$($i-1).$($j)")
                }
                elseif($i -eq ($height-1) -and $j -eq ($width-1)){
                    $graph["$i.$j"] += vertex (edge -w $puzzleInput[$i][($j-1)] -d "$i.$($j-1)"),(edge -w $puzzleInput[($i-1)][$j] -d "$($i-1).$j")
                }
                elseif ($i -eq ($height-1)){
                    #onderste regel
                    $graph["$i.$j"] += vertex (edge -w $puzzleInput[$i][($j+1)] -d "$i.$($j+1)"),(edge -w $puzzleInput[($i-1)][$j] -d "$($i-1).$j"),(edge -w $puzzleInput[$i][($j-1)] -d "$i.$($j-1)")
                }
                elseif ($j -eq ($width-1)) {
                    $graph["$i.$j"] += vertex (edge -w $puzzleInput[$i][($j-1)] -d "$i.$($j-1)"),(edge -w $puzzleInput[($i+1)][$j] -d "$($i+1).$j"),(edge -w $puzzleInput[($i-1)][$j] -d "$($i-1).$($j)")
                }
                else{
                    $graph["$i.$j"] += vertex (edge -w $puzzleInput[$i][($j-1)] -d "$i.$($j-1)"),(edge -w $puzzleInput[($i+1)][$j] -d "$($i+1).$j"),(edge -w $puzzleInput[($i-1)][$j] -d "$($i-1).$($j)"), (edge -w $puzzleInput[$i][($j+1)] -d "$i.$($j+1)")
                }        
            }
        }
        return $graph
    }
    
    function expandInput ([string[]]$puzzleInput) {
        $newInput = @()
        #for($j=0; $j -lt $puzzleInput.Count; $j++){
        write-host "building new input $($stopwatch.Elapsed)"
        foreach ($line in $puzzleInput) {  
            $l = $line.Length
            $newLine = $line
            for($i=$l;$i -lt $l*5; $i++){
                $newValue = [convert]::ToInt32($newline[$i-$l], 10) + 1
                if ($newValue -gt 9) {
                    $newValue = 1
                }
                $newline += $newValue
            }
            $newInput += $newline
        }
        $l = $puzzleInput.Count
        for($j=$l;$j -lt $l*5; $j++){
            $inputLine = $newInput[$j-$l]
            $newline = ""
            for($i=0;$i -lt $inputLine.Length; $i++){
                $newValue = [convert]::ToInt32($inputLine[$i], 10) + 1
                if ($newValue -gt 9) {
                    $newValue = 1
                }
                $newline += $newValue
            }
            $newInput += $newline
        }
    
        return $newInput
    }
    
    $stopwatch =  [system.diagnostics.stopwatch]::StartNew()
    [string[]]$puzzleInput = Get-Content -Path .\Day15\input.sample.txt
    
    $newInput = expandInput $puzzleInput
    write-host "Create graph $($stopwatch.Elapsed)"
    $graph = createGraph $newInput
    #$graph["0.0"] += vertex (edge -w 1 -d "0.1"),(edge -w 1 -d "1.0") 
    #$graph["0.1"] += vertex (edge -w 6 -d "0.2"),(edge -w 3 -d "1.1") 
    #$graph["1.1"] += vertex (edge -w 1 -d "0.1"),(edge -w 1 -d "2.1"),(edge -w 1 -d "1.0"),(edge -w 8 -d "1.2") 
    
    write-host "Start Dijkstra $($stopwatch.Elapsed)"
    Dijkstra $graph "0.0"
    
    $stopwatch.Stop()
    $minutes = $stopwatch.Elapsed.Minutes
    $seconds = $stopwatch.Elapsed.Seconds
    $milliseconds = $stopwatch.Elapsed.Milliseconds
    "Run took {0} minutes {1} seconds and {2} milliseconds" -f $minutes,$seconds,$milliseconds
    ### END SCRIPT