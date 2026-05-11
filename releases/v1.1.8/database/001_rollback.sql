-- =============================================
-- Rollback: Remove UpdateColumn8 from TestTable
-- Version: 1.1.8
-- Date: 2026-05-11
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Rollback v1.1.8';
PRINT 'Remove UpdateColumn8 from TestTable';
PRINT '========================================';
PRINT '';

IF EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'TestTable' 
    AND COLUMN_NAME = 'UpdateColumn8'
)
BEGIN
    PRINT 'Removing UpdateColumn8 column...';

    ALTER TABLE [dbo].[TestTable]
    DROP COLUMN [UpdateColumn8];

    PRINT 'SUCCESS: UpdateColumn8 column removed from TestTable';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: UpdateColumn8 column does not exist - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Rollback v1.1.8 Completed Successfully';
PRINT '========================================';