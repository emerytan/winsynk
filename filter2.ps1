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


#end


