Robocopy.exe Y:\VFX\_shots\ Z:\VFX\_shots\ /l /e /njh /np /xd (Get-Content .\nodeApps\synkerRelease\tmp\platesExcludes.txt) 'anim_*', 'art_*', 'comp_*', 'edt_*', 'gra_*', 'lyt_*', 'pcomp_*', 'ref_*' /xf 'Thumbs.db', '.DS_Store' /w:0 /r:0