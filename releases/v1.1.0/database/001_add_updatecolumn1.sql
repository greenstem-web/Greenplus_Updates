-- =============================================
-- Migration: Add UpdateColumn1 to TestTable
-- Version: 1.1.0
-- Date: 2026-05-09
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Migration v1.1.0';
PRINT 'Add UpdateColumn1 column to TestTable';
PRINT '========================================';
PRINT '';

IF NOT EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'TestTable' 
    AND COLUMN_NAME = 'UpdateColumn1'
)
BEGIN
    PRINT 'Adding UpdateColumn1 column...';

    ALTER TABLE [dbo].[TestTable]
    ADD [UpdateColumn1] NVARCHAR(100) NULL;

    PRINT 'SUCCESS: UpdateColumn1 column added to TestTable';
    PRINT 'Column Details: NVARCHAR(100), NULL allowed';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: UpdateColumn1 column already exists - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Migration v1.1.0 Completed Successfully';
PRINT '========================================';