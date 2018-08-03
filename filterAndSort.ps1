$localPath = "Z:\VFX\_shots\*\*\*"
$here = Join-Path $PWD -ChildPath "tmp"
$arr = Get-ChildItem Z:\VFX\_shots | Where-Object {$_.PSIsContainer} | ForEach-Object {$_.Name}
$me = Get-ChildItem $localPath  | Where-Object {$_.Name -match "anim_|comp_|lyt_|ref_Main|pcomp" -and $_.PsIsContainer}

$allDirs = Join-Path -Path $PWD -ChildPath "tmp/allDirs.txt"

foreach ($a in $me) {
    Get-ChildItem $a.FullName |
        Sort-Object -Descending |
        Select-Object -skip 3 |
        Select-Object -ExpandProperty FullName |
        Out-File -FilePath $allDirs -Append
}



for ($i = 0; $i -lt $arr.Length; $i++) {
    $excl = Get-Content $allDirs | Select-String -Pattern $arr[$i]
    $excl | Out-File -FilePath $($here + "\" + $arr[$i] + ".txt") -Append
}
