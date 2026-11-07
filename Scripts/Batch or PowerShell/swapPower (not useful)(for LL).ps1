# --- CONFIGURATION ---
$StagingFile = "C:\ProgramData\VTech\DA\Kidizoom\5752_US_eng\Update\APP_DATA.BIN"
$MyCustomBin = "C:\Users\HourTime\Downloads\WatchHacking\BIN files\Modded BIN\Signed\APP_DATA.BIN"
$TargetSize  = 56492032  # The exact byte size when complete
# ---------------------

Write-Host "Waiting for Learning Lodge to download the official update file..." -ForegroundColor Cyan

# Step 1: Wait for the file to actually appear on the disk
while (-not (Test-Path $StagingFile)) {
    Start-Sleep -Milliseconds 100
}

Write-Host "[!] Staging file detected. Monitoring download progress..." -ForegroundColor Yellow

# Step 2: Loop until the file reaches the exact target size
$currentSize = 0
while ($currentSize -lt $TargetSize) {
    try {
        $currentSize = (Get-Item $StagingFile).Length
        # Optional: Print progress so you can see it filling up
        Write-Host "Current Size: $currentSize / $TargetSize bytes" -ForegroundColor Gray
    } catch {
        # Catch temporary file-locking errors while Learning Lodge writes to it
    }
    Start-Sleep -Milliseconds 200
}

# Step 3: Trigger the instant swap
Write-Host "`n[!] Target size reached ($TargetSize bytes)!" -ForegroundColor Green
Write-Host "[!] Overwriting with your custom binary now..." -ForegroundColor Magenta

try {
    Copy-Item -Path $MyCustomBin -Destination $StagingFile -Force -ErrorAction Stop
    Write-Host "[SUCCESS] Custom binary swapped cleanly! Let Learning Lodge finish the transfer." -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Failed to overwrite. Learning Lodge might have locked the file: $_" -ForegroundColor Red
}

Read-Host "Press Enter to exit..."
