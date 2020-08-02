Param(
    [String]
    $Path = ".",
    
    [String]
    $VersionCode,
    
    [String]
    $Extension = ".ahk2"
)

$ErrorActionPreference = "Stop"
$require_pattern = "^\#Requires AutoHotkey v"

$get = {
    Param($filename, $i, $content)
    Write-Output $_.FullName
    Write-Output ("    Line $($i + 1)`: " + $content[$i] + "`r`n")
}

$set = {
    Param($filename, $i, $content)
    $content[$i] = $content[$i] `
        -Replace ("(?<=" + $require_pattern + ")\S+"), $VersionCode
    $content | Out-File -FilePath $_.FullName
}

$block = if ($VersionCode) {
    {
        Param($filename, $i, $content)
        $set.Invoke($filename, $i, $content)
        $get.Invoke($filename, $i, $content)
    }
} else {
    {
        Param($filename, $i, $content)
        $get.Invoke($filename, $i, $content)
    }
} 

Get-ChildItem -Path $Path -File -Recurse | ? {
    $_.Extension -eq $Extension
} | % {
    $content = Get-Content $_.FullName
    
    foreach ($i in 0..$content.Count) {
        if ($content[$i] -Match $require_pattern) {
            $block.Invoke($_.FullName, $i, $content)
            break
        }
    }
}
