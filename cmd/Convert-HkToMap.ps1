Param(
	[String]
	$FilePath
)

$ErrorActionPreference = "Stop"

$content = cat $FilePath
$hotstrings = @()

foreach ($i in 1..$content.Count) {
	$line = $content[$i]
	
	if ($line -match "^\s*\:[^\:]*\:") {
		$hotstrings += $line
		
		$key = [Regex]::Match($line, "(?<=;)[^;]+(?=;)").Value
		$help = [Regex]::Match($content[$i - 1], "(?<=; Hotstring\: \([^\)]+\) ).+").Value
		$unicode = [Regex]::Match($content[$i + 2], "(?<=Monitor\.SendUnicode\(`"\{U\+)[^\}]+").Value
		
		Write-Output "table[`"$key`"] := [`"{U+$unicode}`", `"`", `"$help`"]"
	}
}

"`r`n"
$hotstrings 
