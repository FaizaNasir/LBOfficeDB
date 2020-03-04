CREATE PROCEDURE [dbo].[proc_CommitmentTransfer_DEL] @CommitmentTransferID INT
AS
     DELETE FROM [tbl_CommitmentTransfer]
     WHERE [CommitmentTransferID] = @CommitmentTransferID;
     SELECT 1;
