-- =============================================
-- Migration: Add UpdateColumn9 to TestTable
-- Version: 1.1.9
-- Date: 2026-05-11
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Migration v1.1.9';
PRINT 'Add UpdateColumn9 column to TestTable';
PRINT '========================================';
PRINT '';

IF NOT EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'TestTable' 
    AND COLUMN_NAME = 'UpdateColumn9'
)
BEGIN
    PRINT 'Adding UpdateColumn9 column...';

    ALTER TABLE [dbo].[TestTable]
    ADD [UpdateColumn9] NVARCHAR(100) NULL;

    PRINT 'SUCCESS: UpdateColumn9 column added to TestTable';
    PRINT 'Column Details: NVARCHAR(100), NULL allowed';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: UpdateColumn9 column already exists - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Migration v1.1.9 Completed Successfully';
PRINT '========================================';