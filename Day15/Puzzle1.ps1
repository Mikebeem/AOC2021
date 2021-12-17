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
    
    for($i = 0; $i -lt $nodecount; $i++) {
        #write-Host "Proces $i of $($graph.Count)"
        $min = $INFINITY+1
        # find the unchecked node closest to the source
        foreach ($pair in $graph.GetEnumerator()) {
            if(! $graph[$pair.Name].isDead -and $graph[$pair.Name].distance -lt $min) {
                $next = $pair.Name
                $min = $graph[$pair.Name].distance
            }
        }
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
    }
    foreach ($pair in $graph.GetEnumerator()) {
        "The distance between nodes {0} and {1} is {2}" -f
            $source, $pair.Name, $graph[$pair.Name].distance
    }
}


[string[]]$puzzleInput = Get-Content -Path .\Day15\input.txt

$width = $puzzleInput[0].Length
$height = $puzzleInput.Count


###
### Here’s where we define the different vertexi
### each vertex is a collection of edges
### an edge has a weight and a destination


# 0, w 1 d $i.$j+1, w 1 d $i+1.$j
# 1, 
$graph = [ordered]@{}

for($i=0;$i -lt $height; $i++){
    for($j=0;$j -lt $width; $j++){


<#
$puzzleInput[0][3]
116
138
213

#>
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

#$graph["0.0"] += vertex (edge -w 1 -d "0.1"),(edge -w 1 -d "1.0") 
#$graph["0.1"] += vertex (edge -w 6 -d "0.2"),(edge -w 3 -d "1.1") 
#$graph["1.1"] += vertex (edge -w 1 -d "0.1"),(edge -w 1 -d "2.1"),(edge -w 1 -d "1.0"),(edge -w 8 -d "1.2") 

Dijkstra $graph "0.0"

### END SCRIPT