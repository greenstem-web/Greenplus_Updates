-- Rollback: Remove Testing column
-- Version: 1.2
-- Date: 2025-11-19

BEGIN TRANSACTION;

IF EXISTS (
    SELECT * FROM sys.columns 
    WHERE object_id = OBJECT_ID(N'[dbo].[User]')
    AND name = 'Testing'
)
BEGIN
    ALTER TABLE [dbo].[User]
    DROP COLUMN [Testing];

    PRINT 'Testing column removed successfully';
END
ELSE
BEGIN
    PRINT 'Testing column does not exist — skipping';
END

COMMIT TRANSACTION;
