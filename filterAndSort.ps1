# $localPath = "Y:\VFX\_shots\*\*\*"
# $here = "C:\Users\localAdmin\nodeApps\tmp\"
# $arr = Get-ChildItem Z:\VFX\_shots | Where-Object {$_.PSIsContainer} | ForEach-Object {$_.Name}
# $me = Get-ChildItem $localPath  | Where-Object {$_.Name -match "anim_|comp_|lyt_|ref_Main|pcomp" -and $_.PsIsContainer}

$allDirs = "C:\Users\localAdmin\nodeApps\tmp\allDirs.txt"

# foreach ($a in $me) {
#     Get-ChildItem $a.FullName |
#         Sort-Object -Descending |
#         Select-Object -skip 3 |
#         Select-Object -ExpandProperty FullName |
#         Out-File -FilePath $($here + "scriptAll.txt") -Append
# }


for ($i = 0; $i -lt $arr.Length; $i++) {
    $excl = Get-Content $allDirs | Select-String -Pattern $arr[$i]
    Robocopy.exe $("Y:\VFX\_shots\" + $arr[$i]) $("Z:\VFX\_shots\" + $arr[$i]) /l /nfl /ndl /xf '.DS_Store', 'Thumbs.db' /xd $excl /r:0 /w:0

}

