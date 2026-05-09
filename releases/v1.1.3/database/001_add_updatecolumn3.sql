-- =============================================
-- Migration: Add UpdateColumn3 to TestTable
-- Version: 1.1.3
-- Date: 2026-05-09
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Migration v1.1.3';
PRINT 'Add UpdateColumn3 column to TestTable';
PRINT '========================================';
PRINT '';

IF NOT EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'TestTable' 
    AND COLUMN_NAME = 'UpdateColumn3'
)
BEGIN
    PRINT 'Adding UpdateColumn3 column...';

    ALTER TABLE [dbo].[TestTable]
    ADD [UpdateColumn3] NVARCHAR(100) NULL;

    PRINT 'SUCCESS: UpdateColumn3 column added to TestTable';
    PRINT 'Column Details: NVARCHAR(100), NULL allowed';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: UpdateColumn3 column already exists - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Migration v1.1.3 Completed Successfully';
PRINT '========================================';