 (2..15 | % { $myNUM = "{0:D2}" -f $_; Write-Output "plate_$($myNum)" | Out-File -FilePath "C:\Us
ers\NUTCRACKER\nodeApps\winsynk\tmp\plateExcludes.txt" })
