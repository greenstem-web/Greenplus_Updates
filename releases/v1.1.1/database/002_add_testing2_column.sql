-- =============================================
-- Migration: Add Testing2 Column to User Table
-- Version: 1.1.1
-- Date: 2025-11-21
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Migration v1.1.1';
PRINT 'Add Testing2 column to User table';
PRINT '========================================';
PRINT '';

-- Check if Testing2 column already exists
IF NOT EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'User' 
    AND COLUMN_NAME = 'Testing2'
)
BEGIN
    PRINT 'Adding Testing2 column...';
    
    -- Add the new column
    ALTER TABLE [dbo].[User]
    ADD [Testing2] NVARCHAR(200) NULL;
    
    PRINT 'SUCCESS: Testing2 column added to User table';
    PRINT 'Column Details: NVARCHAR(200), NULL allowed';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: Testing2 column already exists - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Migration v1.1.1 Completed Successfully';
PRINT '========================================';