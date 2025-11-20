# Simple Package Script - Generates XML for AutoUpdater.NET
param(
    [string]$Version = "1.1.0",
    [string]$SourceDir = "D:\Greenplus_Local\GreenplusLocal\CoreWinUI\bin\Debug\net9.0-windows"
)

Write-Host "=== Packaging Greenplus v$Version ===" -ForegroundColor Green
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
        Write-Host "  OK $file" -ForegroundColor Green
    } else {
        Write-Host "  ERROR $file NOT FOUND!" -ForegroundColor Red
    }
}

# Create ZIP
Write-Host ""
Write-Host "Creating ZIP..." -ForegroundColor Cyan

if (Test-Path $ZipPath) {
    Remove-Item $ZipPath -Force
}

Compress-Archive -Path "$FilesDir\*" -DestinationPath $ZipPath -Force

$ZipSize = [math]::Round((Get-Item $ZipPath).Length / 1MB, 2)
Write-Host "ZIP created: $ZipSize MB" -ForegroundColor Green

# ✅ Create update.xml (AutoUpdater.NET format)
$updateXml = @"
<?xml version="1.0" encoding="UTF-8"?>
<item>
  <version>$Version.0</version>
  <url>https://github.com/greenstem-web/Greenplus_Updates/releases/download/v$Version/GreenplusAccounting_v$Version.zip</url>
  <changelog>https://github.com/greenstem-web/Greenplus_Updates/releases/tag/v$Version</changelog>
  <mandatory>false</mandatory>
</item>
"@

$updateXmlPath = "D:\Greenplus_Updates\updates\update.xml"
$updateXml | Out-File -FilePath $updateXmlPath -Encoding UTF8

# ✅ Create version-metadata.json (Database info)
$metadataJson = @{
    currentVersion = $Version
    migrationsUrl = "https://raw.githubusercontent.com/greenstem-web/Greenplus_Updates/main/updates/database/migrations.json"
} | ConvertTo-Json -Depth 10

$metadataPath = "D:\Greenplus_Updates\updates\version-metadata.json"
$metadataJson | Out-File -FilePath $metadataPath -Encoding UTF8

Write-Host ""
Write-Host "=== Complete ===" -ForegroundColor Green
Write-Host "ZIP: $ZipPath" -ForegroundColor White
Write-Host "XML: $updateXmlPath" -ForegroundColor White
Write-Host "Metadata: $metadataPath" -ForegroundColor White
Write-Host ""
Write-Host "Next: gh release create v$Version `"$ZipPath`"" -ForegroundColor Yellow