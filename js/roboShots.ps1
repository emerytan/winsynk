$source = "\\10.34.140.250\panama\VFX\_shots"
$destination = "Z:\VFX\_shots"

robocopy $source $destination /mir /np /xf '.DS_Store', 'Thumbs.db' /xd (Get-Content C:\Users\localAdmin\nodeApps\synkerRelease\bin\fixlist.txt | Select-Object -First 650) /r:0 /w:0
