CREATE PROCEDURE [dbo].[proc_Commitment_FundShare_GET] @CommitmentID INT = NULL
AS
    BEGIN
        SELECT [ID], 
               [CommitmentID], 
               cfs.[FundShareID], 
               [ShareAmount], 
               fs.ShareName
        FROM [tbl_CommitmentFundShare] cfs
             INNER JOIN tbl_FundShare fs ON fs.FundShareID = cfs.fundshareid
        WHERE cfs.CommitmentID = ISNULL(@CommitmentID, cfs.CommitmentID);
    END;
