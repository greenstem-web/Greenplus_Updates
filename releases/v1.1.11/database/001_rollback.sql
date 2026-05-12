-- =============================================
-- Rollback: Remove UpdateColumn11 from TestTable
-- Version: 1.1.11
-- Date: 2026-05-12
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Rollback v1.1.11';
PRINT 'Remove UpdateColumn11 from TestTable';
PRINT '========================================';
PRINT '';

IF EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'TestTable' 
    AND COLUMN_NAME = 'UpdateColumn11'
)
BEGIN
    PRINT 'Removing UpdateColumn11 column...';

    ALTER TABLE [dbo].[TestTable]
    DROP COLUMN [UpdateColumn11];

    PRINT 'SUCCESS: UpdateColumn11 column removed from TestTable';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: UpdateColumn11 column does not exist - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Rollback v1.1.11 Completed Successfully';
PRINT '========================================';