-- =============================================
-- Rollback: Remove Testing Column
-- Version: 1.1.0
-- Date: 2025-11-21
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Rollback v1.1.0';
PRINT 'Remove Testing column from User table';
PRINT '========================================';
PRINT '';

-- Check if Testing column exists before dropping
IF EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'User' 
    AND COLUMN_NAME = 'Testing'
)
BEGIN
    PRINT 'Removing Testing column...';
    
    -- Drop the column
    ALTER TABLE [dbo].[User]
    DROP COLUMN [Testing];
    
    PRINT 'SUCCESS: Testing column removed from User table';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: Testing column does not exist - Nothing to rollback';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Rollback v1.1.0 Completed Successfully';
PRINT '========================================';
-- Removed GO statement