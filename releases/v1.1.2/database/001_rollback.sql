-- =============================================
-- Rollback: Remove UpdateColumn2 from TestTable
-- Version: 1.1.2
-- Date: 2026-05-09
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Rollback v1.1.2';
PRINT 'Remove UpdateColumn2 from TestTable';
PRINT '========================================';
PRINT '';

IF EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'TestTable' 
    AND COLUMN_NAME = 'UpdateColumn2'
)
BEGIN
    PRINT 'Removing UpdateColumn2 column...';

    ALTER TABLE [dbo].[TestTable]
    DROP COLUMN [UpdateColumn2];

    PRINT 'SUCCESS: UpdateColumn2 column removed from TestTable';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: UpdateColumn2 column does not exist - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Rollback v1.1.2 Completed Successfully';
PRINT '========================================';