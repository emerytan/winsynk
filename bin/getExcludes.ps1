$localPath = "Z:\VFX\_shots\*\*\*"
$here = "C:\Users\NUTCRACKER\nodeApps\winsynk\tmp"
$arr = Get-ChildItem Z:\VFX\_shots | Where-Object {$_.PSIsContainer} | ForEach-Object {$_.Name}
$me = Get-ChildItem $localPath  | Where-Object {$_.Name -match "anim_|comp_|lyt_|ref_Main|pcomp" -and $_.PsIsContainer}


$output = foreach ($a in $me) {
    Get-ChildItem $a.FullName |
    Sort-Object -Descending |
    Select-Object -skip 3 |
    Select-Object -ExpandProperty FullName
}


for ($i = 0; $i -lt $arr.Length; $i++) {
    $logfile = $(Join-Path $here $arr[$i]) + "_doNotSync.txt"
    $output | Select-String -Pattern $arr[$i] |
    Out-File -FilePath $logfile
}

