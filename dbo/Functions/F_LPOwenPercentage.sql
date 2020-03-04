-- Batch submitted through debugger: SQLQuery33.sql|7|0|C:\Users\Administrator\AppData\Local\Temp\~vs4FA3.sql    
--  select  dbo.[F_LPOwenPercentage] (1205,4,'1 Apr,2016',28,1)    

CREATE FUNCTION [dbo].[F_LPOwenPercentage]
(@id       INT, 
 @moduleID INT, 
 @date     DATETIME, 
 @fundID   INT, 
 @shareID  INT
)
RETURNS DECIMAL(18, 2)
AS
     BEGIN
         DECLARE @sumofshares DECIMAL(18, 2);
         SET @sumofshares =
         (
             SELECT SUM(cfs.shareamount)
             FROM tbl_Commitment c
                  INNER JOIN tbl_CommitmentFundShare cfs ON c.CommitmentID = c.CommitmentID
                  INNER JOIN tbl_FundShare fs ON cfs.ID = fs.FundShareID
                                                 AND c.FundID = fs.FundID
             WHERE c.FundID = @fundID
                   AND c.Date <= @date
         );
         RETURN(
         (
             SELECT SUM(cfs.ShareAmount)
             FROM tbl_Commitment c
                  INNER JOIN tbl_CommitmentFundShare cfs ON c.CommitmentID = cfs.CommitmentID
                  INNER JOIN tbl_FundShare fs ON cfs.FundShareID = fs.FundShareID
                                                 AND c.FundID = fs.FundID
             WHERE c.FundID = @fundID
                   AND c.Date <= @date
                   AND c.ModuleID = @moduleID
                   AND c.ObjectID = @id
         ) / @sumofshares);
     END;
