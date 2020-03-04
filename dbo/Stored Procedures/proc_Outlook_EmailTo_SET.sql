CREATE PROCEDURE [dbo].[proc_Outlook_EmailTo_SET] @EmailID    INT = NULL, 
                                                  @ToID       INT = NULL, 
                                                  @ToModuleID INT = NULL
AS
     DECLARE @EmailToID INT= NULL;
    BEGIN
        INSERT INTO tbl_OutlookEmailTo
        (EmailID, 
         ToID, 
         ToModuleID
        )
        VALUES
        (@EmailID, 
         @ToID, 
         @ToModuleID
        );
    END;
     SET @EmailToID = SCOPE_IDENTITY();
     SELECT 'Success' AS Result, 
            @EmailToID AS 'EmailToID';    
--END    

