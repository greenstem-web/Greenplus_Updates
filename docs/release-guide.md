# Greenplus Accounting — Release Guide

This guide covers the full procedure for creating, rebuilding, or replacing a release version.

---

## Prerequisites

- **GitHub CLI** installed and authenticated (`gh auth login`)
- **Git** installed and configured
- **.NET 9 SDK** installed
- **SSMS** connected to `WIN-VBNET\SQLEXPRESS01`
- **Local app project** at `D:\Greenplus_Local\GreenplusLocal`
- **Updates repo** at `D:\Greenplus_Updates`

---

## Project Structure

```
D:\Greenplus_Updates\
├── releases\
│   └── v{version}\
│       ├── files\                  (compiled app files, auto-generated)
│       ├── database\
│       │   ├── 001_add_xxx.sql     (migration script)
│       │   └── 001_rollback.sql    (rollback script)
│       ├── GreenplusAccounting_v{version}.zip  (auto-generated)
│       └── README.md               (auto-generated)
├── scripts\
│   └── auto_update_package.ps1
└── updates\
    ├── update.xml                  (auto-updated by script)
    └── database\
        └── migrations.json         (manually updated)
```

---

## Part A — Delete an Existing Release

Use this when you need to remove or rebuild an existing version.

### Step 1 — Delete GitHub Releases & Tags

Run from `D:\Greenplus_Updates`:

```powershell
# Delete GitHub releases (repeat for each version)
gh release delete v1.1.2 --yes
gh release delete v1.1.1 --yes
gh release delete v1.1.0 --yes

# Delete tags locally
git tag -d v1.1.2
git tag -d v1.1.1
git tag -d v1.1.0

# Delete tags on GitHub
git push origin --delete v1.1.2
git push origin --delete v1.1.1
git push origin --delete v1.1.0
```

### Step 2 — Remove Local Release Folders

```powershell
Remove-Item -Recurse -Force "D:\Greenplus_Updates\releases\v1.1.0"
Remove-Item -Recurse -Force "D:\Greenplus_Updates\releases\v1.1.1"
Remove-Item -Recurse -Force "D:\Greenplus_Updates\releases\v1.1.2"
```

### Step 3 — Clean SchemaVersion in Database

Open **SSMS**, connect to `WIN-VBNET\SQLEXPRESS01`, run:

```sql
-- Delete only the versions being removed
DELETE FROM [GreenAcc2025].[dbo].[SchemaVersion]
WHERE [Version] IN ('1.1', '1.1.1', '1.1.2');

-- Verify
SELECT [Version], [AppliedDate], [Description]
FROM [GreenAcc2025].[dbo].[SchemaVersion];
```

> Only the baseline `1.0` row should remain after cleanup.

---

## Part B — Create a New Release

### Step 4 — Create SQL Migration Files

Create the database folder for the new version:

```powershell
New-Item -ItemType Directory -Path "D:\Greenplus_Updates\releases\v{version}\database" -Force
```

**Migration script** — `releases\v{version}\database\001_add_{columnname}.sql`

```sql
-- =============================================
-- Migration: Add {ColumnName} to {TableName}
-- Version: {version}
-- Date: {date}
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Migration v{version}';
PRINT 'Add {ColumnName} column to {TableName}';
PRINT '========================================';
PRINT '';

IF NOT EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = '{TableName}' 
    AND COLUMN_NAME = '{ColumnName}'
)
BEGIN
    PRINT 'Adding {ColumnName} column...';

    ALTER TABLE [dbo].[{TableName}]
    ADD [{ColumnName}] NVARCHAR(100) NULL;

    PRINT 'SUCCESS: {ColumnName} column added to {TableName}';
    PRINT 'Column Details: NVARCHAR(100), NULL allowed';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: {ColumnName} column already exists - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Migration v{version} Completed Successfully';
PRINT '========================================';
```

**Rollback script** — `releases\v{version}\database\001_rollback.sql`

```sql
-- =============================================
-- Rollback: Remove {ColumnName} from {TableName}
-- Version: {version}
-- Date: {date}
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Rollback v{version}';
PRINT 'Remove {ColumnName} from {TableName}';
PRINT '========================================';
PRINT '';

IF EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = '{TableName}' 
    AND COLUMN_NAME = '{ColumnName}'
)
BEGIN
    PRINT 'Removing {ColumnName} column...';

    ALTER TABLE [dbo].[{TableName}]
    DROP COLUMN [{ColumnName}];

    PRINT 'SUCCESS: {ColumnName} column removed from {TableName}';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: {ColumnName} column does not exist - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Rollback v{version} Completed Successfully';
PRINT '========================================';
```

> **Note:** The migration is NOT run manually. The app auto-update system downloads and executes it automatically when the user launches the app.

---

### Step 5 — Update migrations.json

Edit `D:\Greenplus_Updates\updates\database\migrations.json` and add the new entry:

```json
{
  "migrations": [
    {
      "version": "1.1",
      "description": "Add {ColumnName} to {TableName} (NVARCHAR(100))",
      "sqlUrl": "https://raw.githubusercontent.com/greenstem-web/Greenplus_Updates/main/releases/v{version}/database/001_add_{columnname}.sql",
      "rollbackUrl": "https://raw.githubusercontent.com/greenstem-web/Greenplus_Updates/main/releases/v{version}/database/001_rollback.sql"
    }
  ]
}
```

> For each new version, append a new object to the `migrations` array. Do not remove old entries.

---

### Step 6 — Update .csproj Version

In `D:\Greenplus_Local\GreenplusLocal\CoreWinUI\CoreWinUI.csproj`, update:

```xml
<AssemblyVersion>{version}.0</AssemblyVersion>
<FileVersion>{version}.0</FileVersion>
<Version>{version}</Version>
```

Example for v1.1.0:
```xml
<AssemblyVersion>1.1.0.0</AssemblyVersion>
<FileVersion>1.1.0.0</FileVersion>
<Version>1.1.0</Version>
```

---

### Step 7 — Build the Application

```powershell
cd D:\Greenplus_Local\GreenplusLocal
dotnet publish CoreWinUI\CoreWinUI.csproj --configuration Release --runtime win-x64 --self-contained true --output CoreWinUI\bin\Release\net9.0-windows\win-x64\publish
```

Wait for `Build succeeded` before continuing.

Verify the output files exist:

```powershell
Get-ChildItem "D:\Greenplus_Local\GreenplusLocal\CoreWinUI\bin\Release\net9.0-windows\win-x64\publish"
```

You should see: `CoreWinUI.exe`, `CoreWinUI.dll`, `Data.dll`, `CoreWinUI.deps.json`, `CoreWinUI.runtimeconfig.json`, `CoreWinUI.pdb`, `Data.pdb`

---

### Step 8 — Run auto_update_package.ps1

```powershell
cd D:\Greenplus_Updates
.\scripts\auto_update_package.ps1 -Version "1.1.0"
```

This script automatically:
- Copies 7 compiled files into `releases\v{version}\files\`
- Creates `releases\v{version}\GreenplusAccounting_v{version}.zip`
- Creates `releases\v{version}\README.md`
- Updates `updates\update.xml` to point to the new version

> `appsettings.json` is intentionally excluded — user database config is preserved.

---

### Step 9 — Commit & Push to GitHub

```powershell
cd D:\Greenplus_Updates
git add .
git commit -m "v1.1.0: Add UpdateColumn1 to TestTable migration"
git push origin main
```

> Push must happen before creating the GitHub release so the raw SQL URLs in `migrations.json` resolve correctly.

---

### Step 10 — Create GitHub Release

```powershell
gh release create v1.1.0 "D:\Greenplus_Updates\releases\v1.1.0\GreenplusAccounting_v1.1.0.zip" --title "Greenplus Accounting v1.1.0" --notes "## Changes in v1.1.0

**Database:**
- Add UpdateColumn1 column to TestTable (NVARCHAR(100))

**Update Package:**
- Files: 7 updated files

**Installation:**
Automatic via built-in auto-update

**Date:** 2026-05-09"
```

---

## Full Checklist

### Delete Existing Release

| # | Task |
|---|------|
| 1 | `gh release delete` for each version |
| 2 | `git tag -d` locally for each version |
| 3 | `git push origin --delete` for each tag |
| 4 | `Remove-Item` local release folders |
| 5 | Delete rows from `SchemaVersion` in SSMS |

### Create New Release

| # | Task |
|---|------|
| 6 | Create `releases\v{version}\database\` folder |
| 7 | Write migration SQL file |
| 8 | Write rollback SQL file |
| 9 | Update `migrations.json` |
| 10 | Update `.csproj` version numbers |
| 11 | `dotnet publish` — build the app |
| 12 | Run `auto_update_package.ps1 -Version "{version}"` |
| 13 | `git add . && git commit && git push` |
| 14 | `gh release create` with ZIP asset |

---

## Common Issues

| Problem | Cause | Fix |
|---------|-------|-----|
| App shows old update available popup | `update.xml` not pushed to GitHub yet | Run `git push origin main` |
| `auto_update_package.ps1` encoding error | Emoji characters corrupted in script | Replace `✓`/`✗` with `[OK]`/`[MISSING]` in the script |
| `gh release create` — no matches for zip path | Relative path not found | Use full absolute path `D:\Greenplus_Updates\releases\...` |
| Build succeeded but files not visible | Looking in wrong folder | Check `CoreWinUI\bin\Release\net9.0-windows\win-x64\publish\` |
| Migration runs but column already exists | Previous partial run | Script is idempotent — it skips if column already exists |

---

## Version History

| Version | Date | Database Change | Table |
|---------|------|----------------|-------|
| 1.0.0 | 2025-11-20 | Initial schema | — |
| 1.1.0 | 2026-05-09 | Add UpdateColumn1 (NVARCHAR(100)) | TestTable |
