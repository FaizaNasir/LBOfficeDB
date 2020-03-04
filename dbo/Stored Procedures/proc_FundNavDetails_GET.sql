
-- [proc_PortfolioValuationSecurityDetails_GET] 20,1  

CREATE PROCEDURE [dbo].[proc_FundNavDetails_GET](@FundNavID INT = NULL)
AS
    BEGIN
        SELECT [Stock], 
               [ShareID], 
               fs.ShareName, 
               [Value]
        FROM [tbl_FundNavDetails] fd
             INNER JOIN tbl_FundShare fs ON fs.FundShareID = fd.ShareID
        WHERE fd.FundNavID = @FundNavID;
    END;
