-- =============================================
-- Migration: Add UpdateColumn11 to TestTable
-- Version: 1.1.11
-- Date: 2026-05-12
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Migration v1.1.11';
PRINT 'Add UpdateColumn11 column to TestTable';
PRINT '========================================';
PRINT '';

IF NOT EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'TestTable' 
    AND COLUMN_NAME = 'UpdateColumn11'
)
BEGIN
    PRINT 'Adding UpdateColumn11 column...';

    ALTER TABLE [dbo].[TestTable]
    ADD [UpdateColumn11] NVARCHAR(100) NULL;

    PRINT 'SUCCESS: UpdateColumn11 column added to TestTable';
    PRINT 'Column Details: NVARCHAR(100), NULL allowed';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: UpdateColumn11 column already exists - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Migration v1.1.11 Completed Successfully';
PRINT '========================================';