CREATE PROCEDURE [dbo].[proc_Fund_Share_Sequence_GET]  --28     

@FundDistributionSequenceID INT = NULL
AS
    BEGIN
        SELECT fss.[SequenceID], 
               fss.[FundDistributionSequenceID], 
               fss.[ShareID], 
               fds.FundID, 
               fs.ShareName, 
               fs.FundShareID
        FROM [tbl_FundShareSequence] fss
             INNER JOIN tbl_FundDistributionSequence fds ON fss.FundDistributionSequenceID = fds.FundDistributionSequenceID
             INNER JOIN tbl_FundShare fs ON fss.shareid = fs.FundShareID
        WHERE fds.FundID = ISNULL(@FundDistributionSequenceID, fds.FundID);
    END;
