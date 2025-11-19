# Package Specific Files for Greenplus Accounting
# Only packages: EXE, DLL, runtime config (NO ZIP, NO unnecessary files)

param(
    [string]$Version = "1.0.0",
    [string]$SourceDir = "D:\Greenplus_Local\GreenplusLocal\CoreWinUI\bin\Debug\net9.0-windows",
    [string]$OutputDir = "D:\Greenplus_Updates\releases\v$Version\files"
)

Write-Host "=== Packaging Greenplus Accounting v$Version ===" -ForegroundColor Green
Write-Host ""

# Files to package
$FilesToPackage = @(
    "CoreWinUI.exe",
    "CoreWinUI.dll",
    "Data.dll",
    "CoreWinUI.runtimeconfig.json"
)

# Create output directory
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

Write-Host "Source: $SourceDir" -ForegroundColor Cyan
Write-Host "Output: $OutputDir" -ForegroundColor Cyan
Write-Host ""

$fileInfoList = @()

foreach ($file in $FilesToPackage) {
    $sourcePath = Join-Path $SourceDir $file
    $destPath = Join-Path $OutputDir $file

    if (Test-Path $sourcePath) {
        # Copy file
        Copy-Item -Path $sourcePath -Destination $destPath -Force
        
        # Calculate SHA256
        $hash = Get-FileHash -Path $destPath -Algorithm SHA256
        $size = (Get-Item $destPath).Length

        Write-Host "  OK $file" -ForegroundColor Green
        Write-Host "     Size: $([math]::Round($size / 1KB, 2)) KB" -ForegroundColor Gray
        Write-Host "     SHA256: $($hash.Hash.Substring(0, 16))..." -ForegroundColor Gray
        Write-Host ""

        # Store info for version.json
        $fileInfoList += [PSCustomObject]@{
            name = $file
            url = "https://github.com/greenstem-web/Greenplus_Updates/releases/download/v$Version/$file"
            size = $size
            checksum = $hash.Hash
        }
    }
    else {
        Write-Host "  ERROR $file NOT FOUND!" -ForegroundColor Red
    }
}

# Generate version.json
$versionJson = @{
    version = "$Version.0"
    releaseDate = (Get-Date -Format "yyyy-MM-dd")
    downloadUrl = "https://github.com/greenstem-web/Greenplus_Updates/releases/download/v$Version"
    changelog = "https://github.com/greenstem-web/Greenplus_Updates/releases/tag/v$Version"
    mandatory = $false
    minVersion = "1.0.0.0"
    files = $fileInfoList
    database = @{
        currentVersion = $Version
        migrationsUrl = "https://raw.githubusercontent.com/greenstem-web/Greenplus_Updates/main/updates/database/migrations.json"
    }
} | ConvertTo-Json -Depth 10

# Save version.json
$versionJsonPath = "D:\Greenplus_Updates\updates\version.json"
$versionJson | Out-File -FilePath $versionJsonPath -Encoding UTF8

Write-Host ""
Write-Host "=== Package Complete ===" -ForegroundColor Green
Write-Host "Files: $OutputDir" -ForegroundColor White
Write-Host "version.json: $versionJsonPath" -ForegroundColor White
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Review version.json" -ForegroundColor Gray
Write-Host "2. Commit to GitHub" -ForegroundColor Gray
Write-Host "3. Create GitHub Release" -ForegroundColor Gray