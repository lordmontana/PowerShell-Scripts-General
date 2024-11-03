 $directoryPath = "C:\CSVB.NET2\Code"
 $snippet = "SetControlAllowNulls"


 $files = Get-ChildItem -Path $directoryPath -Recurse -Filter *.vb

 foreach ($file in $files) {
     try {
         # get content of file
         $content = Get-Content -Path $file.FullName

         # check if empty
         if (-not $content) {
             continue
         }

         $inInitForm = $false
         $found = $false

         # Process each line if the content is valid
         foreach ($lineNumber in 0..($content.Length - 1)) {
             $line = $content[$lineNumber]

             # detect initform
             if ($line.Trim() -match "^Public Overrides Sub InitForm") {
                 $inInitForm = $true
             }

             # end ofsub
             if ($inInitForm -and $line.Trim() -match "^End Sub") {
                 $inInitForm = $false
             }

             # If inside init, check for the code
             if ($inInitForm -and $line -match [regex]::Escape($snippet)) {
                 if (-not $found) {
                     Write-Output "`nFile: $($file.FullName)"
                     $found = $true
                 }
                 Write-Output ("Line {0}: {1}" -f ($lineNumber + 1), $line.Trim())
             }
         }
     }
     catch {
         continue
     }
