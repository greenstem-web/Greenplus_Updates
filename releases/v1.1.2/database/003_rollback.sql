-- =============================================
-- Rollback: Remove Testing2 Column
-- Version: 1.1.2
-- Date: 2025-11-21
-- Author: Tee-FY
-- =============================================

BEGIN TRANSACTION;

BEGIN TRY
    IF EXISTS (
        SELECT * FROM sys.columns 
        WHERE object_id = OBJECT_ID(N'[dbo].[User]') 
        AND name = 'Testing3'
    )
    BEGIN
        ALTER TABLE [dbo].[User]
        DROP COLUMN [Testing3];
        
        PRINT 'Successfully removed Testing3 column';
    END
    ELSE
    BEGIN
        PRINT 'Testing3 column does not exist';
    END
    
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR(@ErrorMessage, 16, 1);
END CATCH;