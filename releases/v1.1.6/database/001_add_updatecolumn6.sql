-- =============================================
-- Migration: Add UpdateColumn6 to TestTable
-- Version: 1.1.6
-- Date: 2026-05-11
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Migration v1.1.6';
PRINT 'Add UpdateColumn6 column to TestTable';
PRINT '========================================';
PRINT '';

IF NOT EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'TestTable' 
    AND COLUMN_NAME = 'UpdateColumn6'
)
BEGIN
    PRINT 'Adding UpdateColumn6 column...';

    ALTER TABLE [dbo].[TestTable]
    ADD [UpdateColumn6] NVARCHAR(100) NULL;

    PRINT 'SUCCESS: UpdateColumn6 column added to TestTable';
    PRINT 'Column Details: NVARCHAR(100), NULL allowed';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: UpdateColumn6 column already exists - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Migration v1.1.6 Completed Successfully';
PRINT '========================================';