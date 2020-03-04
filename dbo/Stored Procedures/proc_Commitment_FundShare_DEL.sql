CREATE PROCEDURE [dbo].[proc_Commitment_FundShare_DEL] @CommitmentID INT
AS
     DELETE FROM [tbl_CommitmentFundShare]
     WHERE [CommitmentID] = @CommitmentID;
     SELECT 1;
