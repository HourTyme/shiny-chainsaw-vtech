# --- CONFIGURATION ---
$WatchDrive   = "F:\"  # <-- CHANGE THIS to your watch's actual drive letter (e.g., D:\, E:\, F:\)
$MyCustomBin  = "C:\Users\HourTime\Downloads\WatchHacking\BIN files\Modded BIN\Signed\APP_DATA.BIN"
# ---------------------

$TargetFile = Join-Path $WatchDrive "APP_DATA.bin"

Write-Host "Waiting for Learning Lodge to start writing to the watch drive ($WatchDrive)..." -ForegroundColor Cyan

# Step 1: Wait for Learning Lodge to create the file on the watch
while (-not (Test-Path $TargetFile)) {
    Start-Sleep -Milliseconds 50
}

Write-Host "[!] Transfer detected on the watch! Attempting aggressive overwrite..." -ForegroundColor Yellow

# Step 2: Loop aggressively to force your custom bytes over the streaming file
$swapped = $false
while (-not $swapped) {
    try {
        # Force copy with a tiny stream buffer
        Copy-Item -Path $MyCustomBin -Destination $TargetFile -Force -ErrorAction Stop
        $swapped = $true
        Write-Host "`n[SUCCESS] Custom binary injected directly onto the watch hardware!" -ForegroundColor Green
    } catch {
        # If Learning Lodge has a temporary lock on the file mid-write, it will loop here until a gap opens
        Write-Progress -Activity "Injecting custom binary" -Status "Overcoming file lock... trying again"
        Start-Sleep -Milliseconds 10
    }
}

Read-Host "Press Enter to exit..."
