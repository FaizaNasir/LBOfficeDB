CREATE PROCEDURE [dbo].[proc_Fund_Share_Sequence_DEL] @FundDistributionSequenceID INT
AS
     DELETE FROM [tbl_FundShareSequence]
     WHERE FundDistributionSequenceID = @FundDistributionSequenceID;
     SELECT 1;
