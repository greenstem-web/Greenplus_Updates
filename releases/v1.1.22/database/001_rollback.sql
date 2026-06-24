-- =============================================
-- Rollback: Remove UpdateColumn13 from TestTable
-- Version: 1.1.22
-- Date: 2026-06-24
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Rollback v1.1.22';
PRINT 'Remove UpdateColumn13 from TestTable';
PRINT '========================================';
PRINT '';

IF EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'TestTable' 
    AND COLUMN_NAME = 'UpdateColumn13'
)
BEGIN
    PRINT 'Removing UpdateColumn13 column...';

    ALTER TABLE [dbo].[TestTable]
    DROP COLUMN [UpdateColumn13];

    PRINT 'SUCCESS: UpdateColumn13 column removed from TestTable';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: UpdateColumn13 column does not exist - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Rollback v1.1.22 Completed Successfully';
PRINT '========================================';