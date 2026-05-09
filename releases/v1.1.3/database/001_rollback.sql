-- =============================================
-- Rollback: Remove UpdateColumn3 from TestTable
-- Version: 1.1.3
-- Date: 2026-05-09
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Rollback v1.1.3';
PRINT 'Remove UpdateColumn3 from TestTable';
PRINT '========================================';
PRINT '';

IF EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'TestTable' 
    AND COLUMN_NAME = 'UpdateColumn3'
)
BEGIN
    PRINT 'Removing UpdateColumn3 column...';

    ALTER TABLE [dbo].[TestTable]
    DROP COLUMN [UpdateColumn3];

    PRINT 'SUCCESS: UpdateColumn3 column removed from TestTable';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: UpdateColumn3 column does not exist - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Rollback v1.1.3 Completed Successfully';
PRINT '========================================';