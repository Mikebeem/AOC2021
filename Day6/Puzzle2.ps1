$data = Get-Content .\Day6\input.txt
[System.Collections.ArrayList]$puzzleInput = $data.split(",")

$count = @()
foreach ($i in 0..8) {
    $count += 0
}
foreach($f in $puzzleInput) {
	$count[$f] += 1
}
for($d=1;$d -le 256;$d++) {
	$temp = @()
    foreach ($i in 0..8) {
        $temp += 0
    }
	for($i=1;$i -le 8;$i++) {
		$temp[$i-1] = $count[$i]
	}
	$temp[6] += $count[0]
	$temp[8] = $count[0]
	$count = $temp
}

$count | Measure-Object -Sum