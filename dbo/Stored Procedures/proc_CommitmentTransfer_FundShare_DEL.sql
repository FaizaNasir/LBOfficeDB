CREATE PROCEDURE [dbo].[proc_CommitmentTransfer_FundShare_DEL] @CommitmentTransferID INT
AS
     DELETE FROM [tbl_CommitmentTransferFundShare]
     WHERE [CommitmentTransferID] = @CommitmentTransferID;
     SELECT 1;
