# Create a Shell.Application COM object
$shell = New-Object -ComObject Shell.Application
Write-Host "Initializing Shell.Application COM object..." -ForegroundColor Cyan

# Get the "This PC" folder
$thisPC = $shell.Namespace("shell:MyComputerFolder")
Write-Host "Accessing 'This PC' folder..." -ForegroundColor Cyan

# Find the iPhone device (replace 'Apple iPhone' with your device's name as it appears in Explorer)
$phone = $thisPC.Items() | Where-Object { $_.Name -eq "Apple iPhone" }
if (-not $phone) {
    Write-Host "iPhone not found. Ensure it's connected and unlocked." -ForegroundColor Red
    exit
}
Write-Host "iPhone found: $($phone.Name)" -ForegroundColor Green

# Access the Internal Storage and DCIM folder
$internalStorage = $phone.GetFolder.Items() | Where-Object { $_.Name -eq "Internal Storage" }
if (-not $internalStorage) {
    Write-Host "Internal Storage not found. Ensure you have allowed access on your iPhone." -ForegroundColor Red
    exit
}
Write-Host "Internal Storage accessed successfully." -ForegroundColor Green

# Define the destination path
$destinationPath = "I:\iCloud Backup\Photos"
if (!(Test-Path $destinationPath)) {
    Write-Host "Destination path does not exist. Creating it..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $destinationPath
}
Write-Host "Destination path: $destinationPath" -ForegroundColor Cyan

# Scan the DCIM folders
Write-Host "Scanning folders in DCIM..." -ForegroundColor Cyan
$totalFiles = 0
$totalSize = 0
$missingFiles = @()
$mediaExtensions = @("\.jpg$", "\.png$", "\.mp4$", "\.mov$", "\.HEIC$", "\.3gp$")

$dcimFolders = $internalStorage.GetFolder.Items()
foreach ($folder in $dcimFolders) {
    if ($folder.IsFolder) {
        Write-Host "Reading folder: $($folder.Name)" -ForegroundColor Yellow
        $folderItems = $folder.GetFolder.Items() | Where-Object { $_.Name -match ($mediaExtensions -join "|") }
        $fileCount = $folderItems.Count
        $folderSize = ($folderItems | Measure-Object -Property Size -Sum).Sum / 1MB
        Write-Host ("Found $fileCount files in $($folder.Name) (Size: {0:N2} MB)." -f $folderSize) -ForegroundColor Green

        # Get corresponding folder in the destination
        $destinationSubfolderPath = Join-Path -Path $destinationPath -ChildPath $folder.Name
        if (!(Test-Path $destinationSubfolderPath)) {
            Write-Host "Creating destination folder: $destinationSubfolderPath" -ForegroundColor Cyan
            New-Item -ItemType Directory -Path $destinationSubfolderPath | Out-Null
        }

        # Check for missing files
        $destinationFiles = Get-ChildItem -Path $destinationSubfolderPath -File | Select-Object -ExpandProperty Name
        $missingInSubfolder = $folderItems | Where-Object { $_.Name -notin $destinationFiles }
        $missingFiles += $missingInSubfolder

        # Copy missing files
        foreach ($file in $missingInSubfolder) {
            Write-Host "Copying $($file.Name) to $destinationSubfolderPath" -ForegroundColor Cyan
            $shell.Namespace($destinationSubfolderPath).CopyHere($file)
        }

        # Update totals
        $totalFiles += $fileCount
        $totalSize += $folderSize
    }
}

Write-Host ("Total files processed: $totalFiles (Size: {0:N2} MB)" -f $totalSize) -ForegroundColor Green
Write-Host ("Missing files copied: $($missingFiles.Count)") -ForegroundColor Green
Write-Host "Script execution completed successfully!" -ForegroundColor Cyan
