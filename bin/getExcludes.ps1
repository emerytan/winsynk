$localPath = "Y:\VFX\_shots\*\*\*"
$here = "C:\Users\localAdmin\nodeApps\synkerRelease\tmp"
$arr = Get-ChildItem "Y:\VFX\_shots" | Where-Object {$_.PSIsContainer} | ForEach-Object {$_.Name}
Write-Host "Drilling into the following directories"
Write-Host $arr

Start-Sleep -Seconds 3
Write-Host "Working..."
$me = Get-ChildItem $localPath  | Where-Object {$_.Name -match "anim_|comp_|lyt_|ref_Main|pcomp" -and $_.PsIsContainer}


$output = foreach ($a in $me) {
    Get-ChildItem $a.FullName |
    Sort-Object -Descending |
    Select-Object -skip 3 |
    Select-Object -ExpandProperty FullName
}


for ($i = 0; $i -lt $arr.Length; $i++) {
    $logfile = $(Join-Path $here $arr[$i]) + "_doNotSync.txt"
    Write-Host "Outputting file: $($logfile)"
    $output | Select-String -Pattern $arr[$i] |
    Out-File -FilePath $logfile
    Start-Sleep 3
}

