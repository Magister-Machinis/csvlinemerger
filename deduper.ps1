param(
	[string]$targetfile=".\target.csv",
	[string]$outputfile = ".\output.csv"
)

foreach($item in $MyParam.Keys)
{
	New-Item (Get-Variable $item).Value -ItemType File -ErrorAction SilentlyContinue
	(Get-Variable $item).Value = Resolve-Path (Get-Variable $item).Value 
	Write-Host "Resolving $((Get-Variable $item).Value)"
}
$indexkey= 5
$target = Import-Csv $targetfile

$intermediate = @{}

foreach($line in $target)
{
	$keytest = $line.$($line.keys[$indexkey])
	if($intermediate.keys.contains($keytest))
	{
		foreach($key in $line.keys)
		{
			if($line.$key -eq "x" -or $line.$key -eq "X")
			{
				$intermediate.$keytest.$key = $line.$key
			}
		}
	}
	else
	{
		$intermediate.add($keytest, $line)
	}	
}
$output = @()
foreach($item in $intermediate.keys)
{
	$output += $intermediate.$item
}

$output | export-csv $outputfile
