-- =============================================
-- Migration: Add UpdateColumn8 to TestTable
-- Version: 1.1.8
-- Date: 2026-05-11
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Migration v1.1.8';
PRINT 'Add UpdateColumn8 column to TestTable';
PRINT '========================================';
PRINT '';

IF NOT EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'TestTable' 
    AND COLUMN_NAME = 'UpdateColumn8'
)
BEGIN
    PRINT 'Adding UpdateColumn8 column...';

    ALTER TABLE [dbo].[TestTable]
    ADD [UpdateColumn8] NVARCHAR(100) NULL;

    PRINT 'SUCCESS: UpdateColumn8 column added to TestTable';
    PRINT 'Column Details: NVARCHAR(100), NULL allowed';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: UpdateColumn8 column already exists - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Migration v1.1.8 Completed Successfully';
PRINT '========================================';