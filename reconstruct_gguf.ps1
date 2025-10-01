# Folder containing all chunks
$chunkFolder = "C:\Users\nikhi\Downloads\alpha"

# Output file name
$outFile = Join-Path $chunkFolder "ggml-gpt4all-j-v1.3-groovy-restored.bin"

# Get all chunk files in correct order
$chunkFiles = Get-ChildItem -Path $chunkFolder -Filter "groovy_chunk*.bin" | Sort-Object Name

# Create output file for writing
$fsOut = [System.IO.File]::Create($outFile)

# Buffer for streaming
$buffer = New-Object byte[] 1MB

foreach ($chunk in $chunkFiles) {
    Write-Host "Appending $($chunk.Name)..."
    $fsIn = [System.IO.File]::OpenRead($chunk.FullName)

    while (($read = $fsIn.Read($buffer, 0, $buffer.Length)) -gt 0) {
        $fsOut.Write($buffer, 0, $read)
    }

    $fsIn.Close()
}

$fsOut.Close()
Write-Host "Reconstruction complete! Saved as $outFile"