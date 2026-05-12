-- =============================================
-- Rollback: Remove UpdateColumn9 from TestTable
-- Version: 1.1.9
-- Date: 2026-05-11
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Rollback v1.1.9';
PRINT 'Remove UpdateColumn9 from TestTable';
PRINT '========================================';
PRINT '';

IF EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'TestTable' 
    AND COLUMN_NAME = 'UpdateColumn9'
)
BEGIN
    PRINT 'Removing UpdateColumn9 column...';

    ALTER TABLE [dbo].[TestTable]
    DROP COLUMN [UpdateColumn9];

    PRINT 'SUCCESS: UpdateColumn9 column removed from TestTable';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: UpdateColumn9 column does not exist - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Rollback v1.1.9 Completed Successfully';
PRINT '========================================';