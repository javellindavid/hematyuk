Add-Type -AssemblyName System.Drawing

$iconsDir = 'c:\Users\asus\OneDrive\Documents\GitHub\HematYuk\icons'

$files = @('icon-192x192-A.png', 'icon-512x512-B.png')

foreach ($f in $files) {
    $path = Join-Path $iconsDir $f
    $bytes = [System.IO.File]::ReadAllBytes($path)
    $isPng  = ($bytes[0] -eq 0x89 -and $bytes[1] -eq 0x50 -and $bytes[2] -eq 0x4E -and $bytes[3] -eq 0x47)
    $isJpeg = ($bytes[0] -eq 0xFF -and $bytes[1] -eq 0xD8)
    Write-Host "$f => PNG=$isPng  JPEG=$isJpeg"

    if ($isJpeg) {
        Write-Host "  -> Converting $f from JPEG to real PNG..."
        $img = [System.Drawing.Image]::FromFile($path)
        # Close file handle first
        $tempPath = $path + '.tmp'
        $img.Save($tempPath, [System.Drawing.Imaging.ImageFormat]::Png)
        $img.Dispose()
        # Replace original
        Remove-Item $path -Force
        Rename-Item $tempPath $path
        Write-Host "  -> Done! $f is now a real PNG."
    } elseif ($isPng) {
        Write-Host "  -> Already a valid PNG, no conversion needed."
    } else {
        Write-Host "  -> Unknown format!"
    }
}

Write-Host ""
Write-Host "All done! Verifying..."
foreach ($f in $files) {
    $path = Join-Path $iconsDir $f
    $bytes = [System.IO.File]::ReadAllBytes($path)
    $isPng  = ($bytes[0] -eq 0x89 -and $bytes[1] -eq 0x50)
    Write-Host "$f => IsRealPNG=$isPng"
}
