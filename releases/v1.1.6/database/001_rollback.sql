-- =============================================
-- Rollback: Remove UpdateColumn6 from TestTable
-- Version: 1.1.6
-- Date: 2026-05-11
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Rollback v1.1.6';
PRINT 'Remove UpdateColumn6 from TestTable';
PRINT '========================================';
PRINT '';

IF EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'TestTable' 
    AND COLUMN_NAME = 'UpdateColumn6'
)
BEGIN
    PRINT 'Removing UpdateColumn6 column...';

    ALTER TABLE [dbo].[TestTable]
    DROP COLUMN [UpdateColumn6];

    PRINT 'SUCCESS: UpdateColumn6 column removed from TestTable';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: UpdateColumn6 column does not exist - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Rollback v1.1.6 Completed Successfully';
PRINT '========================================';