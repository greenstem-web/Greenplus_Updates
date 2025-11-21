-- =============================================
-- Rollback: Remove Testing2 Column
-- Version: 1.1.1
-- Date: 2025-11-21
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Rollback v1.1.1';
PRINT 'Remove Testing2 column from User table';
PRINT '========================================';
PRINT '';

-- Check if Testing2 column exists
IF EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'User' 
    AND COLUMN_NAME = 'Testing2'
)
BEGIN
    PRINT 'Removing Testing2 column...';
    
    -- Drop the column
    ALTER TABLE [dbo].[User]
    DROP COLUMN [Testing2];
    
    PRINT 'SUCCESS: Testing2 column removed';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: Testing2 column does not exist';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Rollback v1.1.1 Completed Successfully';
PRINT '========================================';