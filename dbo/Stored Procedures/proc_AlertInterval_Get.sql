
-- created by	:	Syed Zain ALi

CREATE PROC [dbo].[proc_AlertInterval_Get]
AS
     SELECT AlertIntervalID, 
            IntervalDelay, 
            IntervalDesc
     FROM tbl_alertinterval;
