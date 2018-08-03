$shotsPaths = ls Z:\VFX\_shots | Where-Object {$_.PSIsContainer} | ForEach-Object {$_.FullName}
$excludeListPath = "C:\Users\NUTCRACKER\nodeApps\winsynk\tmp"

for ($i = 0; $i -lt $shotsPaths.Length; $i++) {
    $base = Split-Path $shotsPaths[$i] -Leaf
    $destination = Join-Path X:\syncTest $base
    Write-Host "source: $($shotsPaths[$i]) -- dest: $($destinaion)"
    Start-Sleep -Seconds 5
    Robocopy.exe $shotsPaths[$i] $destination /e /xd (gci $excludeListPath | Where-Object {$_.Name -Match $(Split-Path $shotsPaths[$i] -Leaf)} | Get-Content) (Get-Content C:\Users\NUTCRACKER\nodeApps\winsynk\tmp\plateExcludes.txt) /xf '.DS_Store', 'Thumbs.db' /w:0 /r:0
    Start-Sleep -Seconds 5
}

