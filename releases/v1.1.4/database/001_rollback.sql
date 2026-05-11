-- =============================================
-- Rollback: Remove UpdateColumn4 from TestTable
-- Version: 1.1.4
-- Date: 2026-05-11
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Rollback v1.1.4';
PRINT 'Remove UpdateColumn4 from TestTable';
PRINT '========================================';
PRINT '';

IF EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'TestTable' 
    AND COLUMN_NAME = 'UpdateColumn4'
)
BEGIN
    PRINT 'Removing UpdateColumn4 column...';

    ALTER TABLE [dbo].[TestTable]
    DROP COLUMN [UpdateColumn4];

    PRINT 'SUCCESS: UpdateColumn4 column removed from TestTable';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: UpdateColumn4 column does not exist - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Rollback v1.1.4 Completed Successfully';
PRINT '========================================';