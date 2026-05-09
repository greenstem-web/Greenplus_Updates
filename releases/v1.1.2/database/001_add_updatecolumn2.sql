-- =============================================
-- Migration: Add UpdateColumn2 to TestTable
-- Version: 1.1.2
-- Date: 2026-05-09
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Migration v1.1.2';
PRINT 'Add UpdateColumn2 column to TestTable';
PRINT '========================================';
PRINT '';

IF NOT EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'TestTable' 
    AND COLUMN_NAME = 'UpdateColumn2'
)
BEGIN
    PRINT 'Adding UpdateColumn2 column...';

    ALTER TABLE [dbo].[TestTable]
    ADD [UpdateColumn2] NVARCHAR(100) NULL;

    PRINT 'SUCCESS: UpdateColumn2 column added to TestTable';
    PRINT 'Column Details: NVARCHAR(100), NULL allowed';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: UpdateColumn2 column already exists - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Migration v1.1.2 Completed Successfully';
PRINT '========================================';