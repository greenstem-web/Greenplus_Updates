-- =============================================
-- Migration: Add UpdateColumn7 to TestTable
-- Version: 1.1.7
-- Date: 2026-05-11
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Migration v1.1.7';
PRINT 'Add UpdateColumn7 column to TestTable';
PRINT '========================================';
PRINT '';

IF NOT EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'TestTable' 
    AND COLUMN_NAME = 'UpdateColumn7'
)
BEGIN
    PRINT 'Adding UpdateColumn7 column...';

    ALTER TABLE [dbo].[TestTable]
    ADD [UpdateColumn7] NVARCHAR(100) NULL;

    PRINT 'SUCCESS: UpdateColumn7 column added to TestTable';
    PRINT 'Column Details: NVARCHAR(100), NULL allowed';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: UpdateColumn7 column already exists - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Migration v1.1.7 Completed Successfully';
PRINT '========================================';