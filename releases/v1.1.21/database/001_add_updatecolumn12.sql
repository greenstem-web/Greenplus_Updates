-- =============================================
-- Migration: Add UpdateColumn12 to TestTable
-- Version: 1.1.21
-- Date: 2026-06-24
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Migration v1.1.21';
PRINT 'Add UpdateColumn12 column to TestTable';
PRINT '========================================';
PRINT '';

IF NOT EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'TestTable' 
    AND COLUMN_NAME = 'UpdateColumn12'
)
BEGIN
    PRINT 'Adding UpdateColumn12 column...';

    ALTER TABLE [dbo].[TestTable]
    ADD [UpdateColumn12] NVARCHAR(100) NULL;

    PRINT 'SUCCESS: UpdateColumn12 column added to TestTable';
    PRINT 'Column Details: NVARCHAR(100), NULL allowed';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: UpdateColumn12 column already exists - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Migration v1.1.21 Completed Successfully';
PRINT '========================================';