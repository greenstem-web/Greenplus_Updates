-- =============================================
-- Rollback: Remove UpdateColumn12 from TestTable
-- Version: 1.1.21
-- Date: 2026-06-24
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

PRINT '========================================';
PRINT 'Starting Rollback v1.1.21';
PRINT 'Remove UpdateColumn12 from TestTable';
PRINT '========================================';
PRINT '';

IF EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'TestTable' 
    AND COLUMN_NAME = 'UpdateColumn12'
)
BEGIN
    PRINT 'Removing UpdateColumn12 column...';

    ALTER TABLE [dbo].[TestTable]
    DROP COLUMN [UpdateColumn12];

    PRINT 'SUCCESS: UpdateColumn12 column removed from TestTable';
    PRINT '';
END
ELSE
BEGIN
    PRINT 'INFO: UpdateColumn12 column does not exist - Skipping';
    PRINT '';
END

COMMIT TRANSACTION;

PRINT '========================================';
PRINT 'Rollback v1.1.21 Completed Successfully';
PRINT '========================================';