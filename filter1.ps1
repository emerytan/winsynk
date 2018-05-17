$localPath = "Z:\VFX\_shots\*\*\*"
$here = "C:\Users\localAdmin\nodeApps\tmp"
$me = Get-ChildItem $localPath  | Where-Object {$_.Name -match "anim_|comp_|lyt_|ref_Main|pcomp" -and $_.PsIsContainer}
$output = foreach ($a in $me) { dir $a.FullName | Sort-Object -Descending | Select-Object -skip 3 | Select-Object -ExpandProperty FullName }
$output | Select-Object | Out-File -FilePath "$here/outFile.txt" -Encoding ascii


#$xlist = "`"$((Get-Content C:\Users\Admin\Desktop\test2.txt) -join '"`n"')`""
#$xlist | Out-File -FilePath "C:\Users\Admin\Desktop\test5.txt" -Encoding ascii

