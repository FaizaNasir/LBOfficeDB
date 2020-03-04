CREATE PROCEDURE [dbo].[proc_Fund_Share_GET] @FundShareID INT = NULL
AS
    BEGIN
        SELECT [FundShareID], 
               [FundID], 
               [ShareName], 
               [NominalValue], 
               [Ratio], 
               [Active], 
               [CreatedBy], 
               [CreatedDateTime], 
               [ModifiedBy], 
               [ModifiedDateTime]
        FROM [tbl_FundShare]
        WHERE FundShareID = ISNULL(@FundShareID, FundShareID);
    END;
