-- =============================================
-- Rollback: Remove UpdateColumn1 from TestTable
-- Version: 1.1.0
-- Date: 2026-05-09
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Rollback v1.1.0';
PRINT 'Remove UpdateColumn1 from TestTable';
PRINT '========================================';
PRINT '';

IF EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'TestTable' 
    AND COLUMN_NAME = 'UpdateColumn1'
)
BEGIN
    PRINT 'Removing UpdateColumn1 column...';

    ALTER TABLE [dbo].[TestTable]
    DROP COLUMN [UpdateColumn1];

    PRINT 'SUCCESS: UpdateColumn1 column removed from TestTable';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: UpdateColumn1 column does not exist - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Rollback v1.1.0 Completed Successfully';
PRINT '========================================';