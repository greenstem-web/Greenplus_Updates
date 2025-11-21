-- =============================================
-- Migration: Add Testing Column to User Table
-- Version: 1.1.0
-- Date: 2025-11-21
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Migration v1.1.0';
PRINT 'Add Testing column to User table';
PRINT '========================================';
PRINT '';

-- Check if Testing column already exists
IF NOT EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'User' 
    AND COLUMN_NAME = 'Testing'
)
BEGIN
    PRINT 'Adding Testing column...';
    
    -- Add the new column
    ALTER TABLE [dbo].[User]
    ADD [Testing] NVARCHAR(100) NULL;
    
    PRINT 'SUCCESS: Testing column added to User table';
    PRINT 'Column Details: NVARCHAR(100), NULL allowed';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: Testing column already exists - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Migration v1.1.0 Completed Successfully';
PRINT '========================================';
-- Removed GO statement