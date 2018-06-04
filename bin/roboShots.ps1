$source = "\\10.34.140.250\panama\VFX\_shots"
$destination = "Z:\VFX\_shots"

function runSync ($ma) {
    Robocopy.exe $source $destination /l /nfl /ndl /e /np /xf '.DS_Store', 'Thumbs.db' $ma /r:0 /w:0
}


