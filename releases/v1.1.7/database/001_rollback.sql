-- =============================================
-- Rollback: Remove UpdateColumn7 from TestTable
-- Version: 1.1.7
-- Date: 2026-05-11
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Rollback v1.1.7';
PRINT 'Remove UpdateColumn7 from TestTable';
PRINT '========================================';
PRINT '';

IF EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'TestTable' 
    AND COLUMN_NAME = 'UpdateColumn7'
)
BEGIN
    PRINT 'Removing UpdateColumn7 column...';

    ALTER TABLE [dbo].[TestTable]
    DROP COLUMN [UpdateColumn7];

    PRINT 'SUCCESS: UpdateColumn7 column removed from TestTable';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: UpdateColumn7 column does not exist - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Rollback v1.1.7 Completed Successfully';
PRINT '========================================';