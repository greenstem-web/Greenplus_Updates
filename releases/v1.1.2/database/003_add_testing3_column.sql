-- =============================================
-- Migration: Add Testing2 Column to User Table
-- Version: 1.1.2
-- Date: 2025-11-21
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

BEGIN TRY
    IF NOT EXISTS (
        SELECT * FROM sys.columns 
        WHERE object_id = OBJECT_ID(N'[dbo].[User]') 
        AND name = 'Testing3'
    )
    BEGIN
        ALTER TABLE [dbo].[User]
        ADD [Testing3] NVARCHAR(300) NULL;
        
        PRINT 'Successfully added Testing3 column';
    END
    ELSE
    BEGIN
        PRINT 'Testing3 column already exists';
    END
    
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR(@ErrorMessage, 16, 1);
END CATCH;