-- =============================================
-- Migration: Add UpdateColumn13 to TestTable
-- Version: 1.1.22
-- Date: 2026-06-24
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Migration v1.1.22';
PRINT 'Add UpdateColumn13 column to TestTable';
PRINT '========================================';
PRINT '';

IF NOT EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'TestTable' 
    AND COLUMN_NAME = 'UpdateColumn13'
)
BEGIN
    PRINT 'Adding UpdateColumn13 column...';

    ALTER TABLE [dbo].[TestTable]
    ADD [UpdateColumn13] NVARCHAR(100) NULL;

    PRINT 'SUCCESS: UpdateColumn13 column added to TestTable';
    PRINT 'Column Details: NVARCHAR(100), NULL allowed';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: UpdateColumn13 column already exists - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Migration v1.1.22 Completed Successfully';
PRINT '========================================';