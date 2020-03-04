CREATE PROCEDURE [dbo].[proc_SET_Individualuser] @UserName     NVARCHAR(256) = NULL, 
                                                 @IndividualID INT           = NULL
AS
    BEGIN
        INSERT INTO tbl_Individualuser
        ([UserName], 
         [IndividualID]
        )
        VALUES
        (@UserName, 
         @IndividualID
        );
        SET @IndividualID = 1;
    END;
        SELECT 'Success' AS Result, 
               @IndividualID AS 'IndividualuserID';
