$shotsPaths = Get-ChildItem Y:\VFX\_shots | Where-Object {$_.PSIsContainer} | ForEach-Object {$_.FullName}
$excludeListPath = "C:\Users\$env:USERNAME\nodeApps\synkerRelease\tmp"
$plateExcludes = "C:\Users\$env:USERNAME\nodeApps\synkerRelease\tmp\plateExcludes.txt"

for ($i = 0; $i -lt $shotsPaths.Length; $i++) {

    $base = Split-Path $shotsPaths[$i] -Leaf
    $destination = Join-Path "Z:\VFX\_shots" $base

    Start-Sleep -Seconds 2
    Robocopy.exe $shotsPaths[$i] $destination /e /maxage:30 /njh /np /xd 'ref_Main' (Get-ChildItem $excludeListPath | Where-Object {$_.Name -Match $(Split-Path $shotsPaths[$i] -Leaf)} | Get-Content) (Get-Content $plateExcludes) /xf '.DS_Store', 'Thumbs.db' /w:0 /r:0
    Write-Host "source: $($shotsPaths[$i]) -- dest: $($destination)"
    Start-Sleep -Seconds 8

}

