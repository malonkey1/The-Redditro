# PowerShell script to resize images from 2x to 1x for Balatro
Add-Type -AssemblyName System.Drawing

$sourceFolder = ".\2x"
$targetFolder = ".\1x"

# Get all PNG files from the 2x folder
$imageFiles = Get-ChildItem -Path $sourceFolder -Filter "*.png"

Write-Host "Starting image resize process..."
Write-Host "Found $($imageFiles.Count) images to process"

foreach ($file in $imageFiles) {
    try {
        Write-Host "Processing: $($file.Name)"
        
        # Load the source image
        $sourceImage = [System.Drawing.Image]::FromFile($file.FullName)
        
        # Calculate new dimensions (50% of original)
        $newWidth = [int]($sourceImage.Width / 2)
        $newHeight = [int]($sourceImage.Height / 2)
        
        Write-Host "  Original: $($sourceImage.Width)x$($sourceImage.Height) -> New: ${newWidth}x${newHeight}"
        
        # Create new bitmap with calculated dimensions
        $resizedImage = New-Object System.Drawing.Bitmap($newWidth, $newHeight)
        
        # Create graphics object for high-quality resizing
        $graphics = [System.Drawing.Graphics]::FromImage($resizedImage)
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
        $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
        $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
        
        # Draw the resized image
        $graphics.DrawImage($sourceImage, 0, 0, $newWidth, $newHeight)
        
        # Save the resized image to 1x folder
        $targetPath = Join-Path $targetFolder $file.Name
        $resizedImage.Save($targetPath, [System.Drawing.Imaging.ImageFormat]::Png)
        
        # Clean up
        $graphics.Dispose()
        $resizedImage.Dispose()
        $sourceImage.Dispose()
        
        Write-Host "  Saved to: $targetPath"
    }
    catch {
        Write-Host "  Error processing $($file.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "Image resize process completed!" -ForegroundColor Green
