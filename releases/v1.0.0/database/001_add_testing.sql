-- Migration: Add SessionToken and Testing columns to User table
-- Version: 1.2
-- Date: 2025-11-19
-- Author: Tee-FY

BEGIN TRANSACTION;

-----------------------------------------
-- Add Testing column if not exists
-----------------------------------------
IF NOT EXISTS (
    SELECT * FROM sys.columns 
    WHERE object_id = OBJECT_ID(N'[dbo].[User]')
    AND name = 'Testing'
)
BEGIN
    ALTER TABLE [dbo].[User]
    ADD [Testing] NVARCHAR(50) NULL;

    PRINT 'Testing column added successfully';
END
ELSE
BEGIN
    PRINT 'Testing column already exists - skipping';
END;

COMMIT TRANSACTION;
