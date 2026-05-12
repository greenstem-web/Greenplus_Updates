-- =============================================
-- Rollback: Remove UpdateColumn10 from TestTable
-- Version: 1.1.10
-- Date: 2026-05-12
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Rollback v1.1.10';
PRINT 'Remove UpdateColumn10 from TestTable';
PRINT '========================================';
PRINT '';

IF EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'TestTable' 
    AND COLUMN_NAME = 'UpdateColumn10'
)
BEGIN
    PRINT 'Removing UpdateColumn10 column...';

    ALTER TABLE [dbo].[TestTable]
    DROP COLUMN [UpdateColumn10];

    PRINT 'SUCCESS: UpdateColumn10 column removed from TestTable';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: UpdateColumn10 column does not exist - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Rollback v1.1.10 Completed Successfully';
PRINT '========================================';