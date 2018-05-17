# ETA's shots delete filter powershell script

$localPath = "Z:\VFX\_shots\*\*\*"
$here = "C:\Users\localAdmin\nodeApps\tmp"

Get-ChildItem $localPath  |
    Where-Object {$_.Name -match "anim_|comp_|lyt_|ref_Main|pcomp" -and $_.PsIsContainer}


$output = foreach ($a in $me) {
    dir $a.FullName |
    Sort-Object -Descending |
    Select-Object -skip 3 |
    Select-Object -ExpandProperty FullName
    Out-File -FilePath "$here/outFile.txt" -Encoding ascii    
}




# shots robocopy command
# robocopy Y:\VFX\_shots\ Z:\VFX\_shots\ /xd (Get-Content .\nodeApps\fixlist.txt | Select-Object -First 650) /xf "Thumbs.db" ".DS_Store" /mir /r:0 /w:0 /mon:100 /mot:30

# assets robocopy command
# robocopy \\10.34.140.250\panama\VFX\_assets\ Z:\VFX\_assets\ /xf "Thumbs.db", ".DS_Store" /xd "mdl_*", "setref_*" /mir /r:0 /w:0 /mon:100 /mot:30
