# Simple Package Script - Only 4 Files
param(
    [string]$Version = "1.1.0",
    [string]$SourceDir = "D:\Greenplus_Local\GreenplusLocal\CoreWinUI\bin\Debug\net9.0-windows"
)

Write-Host "=== Packaging Greenplus v$Version (4 files only) ===" -ForegroundColor Green
Write-Host ""

# Output paths
$OutputBase = "D:\Greenplus_Updates\releases\v$Version"
$FilesDir = "$OutputBase\files"
$ZipPath = "$OutputBase\GreenplusAccounting_v$Version.zip"

# Create directories
New-Item -ItemType Directory -Path $FilesDir -Force | Out-Null

# Files to package
$FilesToPackage = @(
    "CoreWinUI.exe",
    "CoreWinUI.dll",
    "Data.dll",
    "CoreWinUI.runtimeconfig.json"
)

Write-Host "Copying 4 files..." -ForegroundColor Cyan

# Copy files
foreach ($file in $FilesToPackage) {
    $sourcePath = Join-Path $SourceDir $file
    $destPath = Join-Path $FilesDir $file
    
    if (Test-Path $sourcePath) {
        Copy-Item -Path $sourcePath -Destination $destPath -Force
        Write-Host "  $file" -ForegroundColor Green
    } else {
        Write-Host "  $file NOT FOUND!" -ForegroundColor Red
    }
}

# Create ZIP from the 4 files
Write-Host ""
Write-Host "Creating ZIP..." -ForegroundColor Cyan

if (Test-Path $ZipPath) {
    Remove-Item $ZipPath -Force
}

Compress-Archive -Path "$FilesDir\*" -DestinationPath $ZipPath -Force

$ZipSize = [math]::Round((Get-Item $ZipPath).Length / 1MB, 2)
Write-Host "ZIP created: $ZipSize MB" -ForegroundColor Green

# Create version.json
$versionJson = @{
    version = "$Version.0"
    url = "https://github.com/greenstem-web/Greenplus_Updates/releases/download/v$Version/GreenplusAccounting_v$Version.zip"
    changelog = "https://github.com/greenstem-web/Greenplus_Updates/releases/tag/v$Version"
    mandatory = @{
        value = $false
        minVersion = "1.0.0.0"
    }
    database = @{
        currentVersion = $Version
        migrationsUrl = "https://raw.githubusercontent.com/greenstem-web/Greenplus_Updates/main/updates/database/migrations.json"
    }
} | ConvertTo-Json -Depth 10

$versionJsonPath = "D:\Greenplus_Updates\updates\version.json"
$versionJson | Out-File -FilePath $versionJsonPath -Encoding UTF8

Write-Host ""
Write-Host "=== Complete ===" -ForegroundColor Green
Write-Host "ZIP: $ZipPath" -ForegroundColor White
Write-Host "version.json: $versionJsonPath" -ForegroundColor White
Write-Host ""
Write-Host "Next: gh release create v$Version `"$ZipPath`"" -ForegroundColor Yellow