$source = "\\10.34.140.250\panama\VFX\_assets"
$destination = "Z:\VFX\_assets"

robocopy $source $destination /mir /np /xf '.DS_Store', 'Thumbs.db' /xd "mdl*", "setref*" /r:0 /w:0
