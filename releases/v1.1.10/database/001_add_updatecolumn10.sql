-- =============================================
-- Migration: Add UpdateColumn10 to TestTable
-- Version: 1.1.10
-- Date: 2026-05-12
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Migration v1.1.10';
PRINT 'Add UpdateColumn10 column to TestTable';
PRINT '========================================';
PRINT '';

IF NOT EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'TestTable' 
    AND COLUMN_NAME = 'UpdateColumn10'
)
BEGIN
    PRINT 'Adding UpdateColumn10 column...';

    ALTER TABLE [dbo].[TestTable]
    ADD [UpdateColumn10] NVARCHAR(100) NULL;

    PRINT 'SUCCESS: UpdateColumn10 column added to TestTable';
    PRINT 'Column Details: NVARCHAR(100), NULL allowed';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: UpdateColumn10 column already exists - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Migration v1.1.10 Completed Successfully';
PRINT '========================================';