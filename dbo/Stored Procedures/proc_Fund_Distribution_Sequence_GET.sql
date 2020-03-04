CREATE PROCEDURE [dbo].[proc_Fund_Distribution_Sequence_GET] @FundDistributionSequenceID INT = NULL
AS
    BEGIN
        SELECT [FundDistributionSequenceID], 
               [FundID], 
               [Hurdle], 
               [Catchup], 
               [CarriedIntrest], 
               [Active], 
               [CreatedBy], 
               [CreatedDateTime], 
               [ModifiedBy], 
               [ModifiedDateTime]
        FROM [tbl_FundDistributionSequence]
        WHERE FundDistributionSequenceID = ISNULL(@FundDistributionSequenceID, FundDistributionSequenceID);
    END;
