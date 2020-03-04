CREATE PROCEDURE [dbo].[proc_FundActivity_GET] @FundID INT = NULL
AS
    BEGIN
        SELECT Id, 
               FundID, 
               ActivityId
        FROM tbl_FuindActivity
        WHERE FundID = @FundID;
    END;
