CREATE PROCEDURE [dbo].[proc_Commitment_DEL] @CommitmentID INT
AS
     DELETE FROM [tbl_Commitment]
     WHERE [CommitmentID] = @CommitmentID;
     SELECT 1;
