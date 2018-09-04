$shotsPaths = Get-ChildItem Y:\VFX\_shots | Where-Object {$_.PSIsContainer} | ForEach-Object {$_.FullName}
$excludeListPath = "C:\Users\$env:USERNAME\nodeApps\synkerRelease\tmp"
$plateExcludes = "C:\Users\$env:USERNAME\nodeApps\synkerRelease\tmp\platesExcludes.txt"

for ($i = 0; $i -lt $shotsPaths.Length; $i++) {

    $base = Split-Path $shotsPaths[$i] -Leaf
    $destination = Join-Path "Z:\VFX\_shots" $base

    Start-Sleep -Seconds 1
    
    Robocopy.exe $shotsPaths[$i] $destination /l /e /maxage:60 /nfl /ndl /njh /np /xd 'ref_Main' (Get-ChildItem $excludeListPath |
        Where-Object {$_.Name -Match $(Split-Path $shotsPaths[$i] -Leaf)} |
        Get-Content) (Get-Content $plateExcludes) /xf '.DS_Store', 'Thumbs.db' /w:0 /r:0

    Write-Host "completed source: $($shotsPaths[$i]) -- dest: $($destination)"
    Start-Sleep -Seconds 4

}

