$source = "\\10.34.140.250\panama\VFX\_shots"
$destination = "Z:\VFX\_shots"

robocopy $source $destination /e /np /xf '.DS_Store', 'Thumbs.db' /maxage:120 /r:0 /w:0
