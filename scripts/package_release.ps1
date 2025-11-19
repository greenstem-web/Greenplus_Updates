# Package Release Script for Greenplus Accounting
# Excludes: Logs, Reports, appsettings.json
# Includes: All DLLs (DevExpress, etc.), EXE, and necessary files

param(
    [string]$Version = "1.0.0",
    [string]$SourceDir = "D:\Greenplus_Local\GreenplusLocal\CoreWinUI\bin\Debug\net9.0-windows",
    [string]$OutputDir = "D:\Greenplus_Updates\releases\v$Version"
)

Write-Host "=== Packaging Greenplus Accounting v$Version ===" -ForegroundColor Green
Write-Host ""

# Create output directory
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

# Create temp directory for staging
$TempDir = "$OutputDir\temp"
if (Test-Path $TempDir) {
    Remove-Item -Path $TempDir -Recurse -Force
}
New-Item -ItemType Directory -Path $TempDir | Out-Null

Write-Host "Source Directory: $SourceDir" -ForegroundColor Cyan
Write-Host "Output Directory: $OutputDir" -ForegroundColor Cyan
Write-Host ""
Write-Host "Copying files (excluding Logs, Reports, appsettings.json)..." -ForegroundColor Yellow

# Copy all files EXCEPT excluded items
Get-ChildItem -Path $SourceDir -Recurse | Where-Object {
    # Exclude directories
    ($_.PSIsContainer -and $_.Name -notin @("Logs", "logs", "Report", "Reports")) -or
    # Exclude files
    (!$_.PSIsContainer -and $_.Name -notin @("appsettings.json", "appsettings.Development.json") -and $_.Extension -notin @(".log", ".tmp", ".pdb", ".config"))
} | ForEach-Object {
    $targetPath = $_.FullName.Replace($SourceDir, $TempDir)
    $targetDir = Split-Path -Parent $targetPath
    
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }
    
    if (-not $_.PSIsContainer) {
        Copy-Item -Path $_.FullName -Destination $targetPath -Force
    }
}

Write-Host "Files copied successfully" -ForegroundColor Green
Write-Host ""

# Create appsettings.json template (NO TOKEN!)
Write-Host "Creating appsettings.json template..." -ForegroundColor Yellow

$AppSettingsTemplate = @"
{
  "AppSettings": {
    "CookieExpiryInMinutes": 600,
    "ApplicationName": "GreenplusAccounting",
    "EncryptedKey": "A@b$c#91"
  },
  "ConnectionStrings": {
    "Default": "Server=[YourServer];Database=[YourDatabase];User Id=[User];Password=[Password];Application Name=GreenplusAccounting;TrustServerCertificate=Yes;MultipleActiveResultSets=true;",
    "Default_CommandTimeout": "120"
  },
  "GitHub": {
    "UpdateUrl": "https://raw.githubusercontent.com/greenstem-web/Greenplus_Updates/main/updates/version.json",
    "MigrationsUrl": "https://raw.githubusercontent.com/greenstem-web/Greenplus_Updates/main/updates/database/migrations.json",
    "Repository": "greenstem-web/Greenplus_Updates"
  }
}
"@

Set-Content -Path "$TempDir\appsettings.json" -Value $AppSettingsTemplate -Encoding UTF8

# Create ZIP file
$ZipPath = "$OutputDir\GreenplusAccounting_v$Version.zip"
Write-Host ""
Write-Host "Creating ZIP: $ZipPath" -ForegroundColor Cyan

if (Test-Path $ZipPath) {
    Remove-Item $ZipPath -Force
}

# Create ZIP using .NET compression
Add-Type -Assembly System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($TempDir, $ZipPath, [System.IO.Compression.CompressionLevel]::Optimal, $false)

# Cleanup temp
Remove-Item -Path $TempDir -Recurse -Force

# Calculate SHA256
$Hash = Get-FileHash -Path $ZipPath -Algorithm SHA256
$FileSize = [math]::Round((Get-Item $ZipPath).Length / 1MB, 2)

Write-Host ""
Write-Host "=== Package Created Successfully ===" -ForegroundColor Green
Write-Host "Location: $ZipPath" -ForegroundColor White
Write-Host "Size: $FileSize MB" -ForegroundColor White
Write-Host "SHA256: $($Hash.Hash)" -ForegroundColor Yellow
Write-Host ""
Write-Host "Ready to upload to GitHub Releases!" -ForegroundColor Green
Write-Host ""

# Copy SHA256 to clipboard (optional)
$Hash.Hash | Set-Clipboard
Write-Host "SHA256 copied to clipboard!" -ForegroundColor Cyan