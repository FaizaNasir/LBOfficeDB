CREATE PROCEDURE [dbo].[proc_Fund_Share_DEL] @FundShareID INT
AS
     DELETE FROM [tbl_FundShare]
     WHERE FundShareID = @FundShareID;
     SELECT 1;
