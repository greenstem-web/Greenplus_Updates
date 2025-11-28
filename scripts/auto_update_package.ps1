# =============================================
# Package Auto-Update ZIP
# For existing users via auto-update
# =============================================

param(
    [Parameter(Mandatory=$true)]
    [string]$Version
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Green
Write-Host " Packaging Update v$Version" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Paths
$SourceDir = "D:\Greenplus_Local\GreenplusLocal\CoreWinUI\bin\Release\net9.0-windows\win-x64\publish"
$UpdatesRoot = "D:\Greenplus_Updates"
$OutputBase = "$UpdatesRoot\releases\v$Version"
$FilesDir = "$OutputBase\files"
$ZipPath = "$OutputBase\GreenplusAccounting_v$Version.zip"

# Files to include in update package
$FilesToPackage = @(
    "CoreWinUI.exe",
    "CoreWinUI.dll",
    "Data.dll",
    "CoreWinUI.deps.json",
    "CoreWinUI.runtimeconfig.json",
    "CoreWinUI.pdb",
    "Data.pdb"
)

Write-Host "[1/4] Checking source files..." -ForegroundColor Yellow

if (-not (Test-Path $SourceDir)) {
    Write-Host "  Source directory not found!" -ForegroundColor Red
    Write-Host "  Expected: $SourceDir" -ForegroundColor Red
    Write-Host ""
    Write-Host "Build the project first:" -ForegroundColor Yellow
    Write-Host "  cd D:\Greenplus_Local\GreenplusLocal" -ForegroundColor White
    Write-Host "  dotnet publish CoreWinUI\CoreWinUI.csproj --configuration Release --runtime win-x64 --self-contained true --output CoreWinUI\bin\Release\net9.0-windows\win-x64\publish" -ForegroundColor White
    exit 1
}

Write-Host "  Source: $SourceDir" -ForegroundColor Green
Write-Host ""

# Create output directory
Write-Host "[2/4] Copying files..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path $FilesDir -Force | Out-Null

$SuccessCount = 0
$FailCount = 0

foreach ($file in $FilesToPackage) {
    $sourcePath = Join-Path $SourceDir $file
    $destPath = Join-Path $FilesDir $file
    
    if (Test-Path $sourcePath) {
        Copy-Item -Path $sourcePath -Destination $destPath -Force
        $fileSize = [math]::Round((Get-Item $sourcePath).Length / 1KB, 2)
        Write-Host "  ✓ $file ($fileSize KB)" -ForegroundColor Green
        $SuccessCount++
    } else {
        Write-Host "  ✗ $file NOT FOUND!" -ForegroundColor Red
        $FailCount++
    }
}

Write-Host ""
Write-Host "  Copied: $SuccessCount files" -ForegroundColor Green

# ✅ Show excluded files notice
Write-Host ""
Write-Host "  Excluded files (user settings preserved):" -ForegroundColor Yellow
Write-Host "    • appsettings.json (user's database configuration)" -ForegroundColor Gray

if ($FailCount -gt 0) {
    Write-Host "  Failed: $FailCount files" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Create ZIP
Write-Host "[3/4] Creating ZIP..." -ForegroundColor Yellow

if (Test-Path $ZipPath) {
    Remove-Item $ZipPath -Force
}

Compress-Archive -Path "$FilesDir\*" -DestinationPath $ZipPath -CompressionLevel Optimal -Force

$ZipSize = [math]::Round((Get-Item $ZipPath).Length / 1MB, 2)
Write-Host "  ZIP: $ZipSize MB" -ForegroundColor Green
Write-Host ""

# Update update.xml
Write-Host "[4/4] Updating update.xml..." -ForegroundColor Yellow

$updateXml = @"
<?xml version="1.0" encoding="UTF-8"?>
<item>
  <version>$Version.0</version>
  <url>https://github.com/greenstem-web/Greenplus_Updates/releases/download/v$Version/GreenplusAccounting_v$Version.zip</url>
  <changelog>https://github.com/greenstem-web/Greenplus_Updates/releases/tag/v$Version</changelog>
  <mandatory>false</mandatory>
</item>
"@

$updateXmlPath = "$UpdatesRoot\updates\update.xml"
New-Item -ItemType Directory -Path (Split-Path $updateXmlPath) -Force | Out-Null
$updateXml | Out-File -FilePath $updateXmlPath -Encoding UTF8

Write-Host "  update.xml updated" -ForegroundColor Green
Write-Host ""

# Create README
$readmePath = "$OutputBase\README.md"
$readmeContent = @"
# Greenplus Accounting v$Version - Update Package

## Files Included

- CoreWinUI.exe (Main executable)
- CoreWinUI.dll (Application library)
- Data.dll (Data access layer)
- CoreWinUI.deps.json (Dependencies manifest)
- CoreWinUI.runtimeconfig.json (Runtime configuration)
- CoreWinUI.pdb (Debug symbols)
- Data.pdb (Debug symbols)

## Package Details

- **Version:** $Version
- **Size:** $ZipSize MB
- **Files:** $SuccessCount
- **Created:** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Installation

This is an AUTO-UPDATE package for existing users.

The application will:
1. Download this ZIP automatically
2. Extract and replace executable files ONLY
3. Preserve your appsettings.json configuration
4. Restart the application

## Important Notes

✅ Your database connection settings will NOT be affected
✅ Your custom configurations will be preserved
✅ No need to reconfigure after update
✅ Application will connect to the same databases as before

## Manual Installation

If you need to manually install:
1. Close CoreWinUI.exe
2. Extract ZIP to installation directory
3. **DO NOT overwrite appsettings.json** (if prompted)
4. Restart CoreWinUI.exe
"@

$readmeContent | Out-File -FilePath $readmePath -Encoding UTF8

Write-Host "========================================" -ForegroundColor Green
Write-Host " PACKAGE COMPLETE!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Output:" -ForegroundColor Cyan
Write-Host "  ZIP: $ZipPath" -ForegroundColor White
Write-Host "  Size: $ZipSize MB" -ForegroundColor White
Write-Host "  Files: $SuccessCount" -ForegroundColor White
Write-Host ""
Write-Host "XML Updated:" -ForegroundColor Cyan
Write-Host "  $updateXmlPath" -ForegroundColor White
Write-Host ""
Write-Host "⚠️  Important:" -ForegroundColor Yellow
Write-Host "  appsettings.json is EXCLUDED from this update" -ForegroundColor White
Write-Host "  User's database configurations will be preserved" -ForegroundColor White
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Update migrations.json (if database changes)" -ForegroundColor White
Write-Host "  2. Commit to GitHub:" -ForegroundColor White
Write-Host "     cd D:\Greenplus_Updates" -ForegroundColor Gray
Write-Host "     git add ." -ForegroundColor Gray
Write-Host '     git commit -m "v' -NoNewline -ForegroundColor Gray
Write-Host $Version -NoNewline -ForegroundColor Gray
Write-Host ': Update package"' -ForegroundColor Gray
Write-Host "     git push origin main" -ForegroundColor Gray
Write-Host "  3. Create GitHub release:" -ForegroundColor White
Write-Host "     gh release create v$Version " -NoNewline -ForegroundColor Gray
Write-Host """$ZipPath""" -NoNewline -ForegroundColor Gray
Write-Host ' --title "v' -NoNewline -ForegroundColor Gray
Write-Host $Version -NoNewline -ForegroundColor Gray
Write-Host '"' -ForegroundColor Gray
Write-Host ""

explorer.exe $OutputBase