CREATE PROC [dbo].[proc_get_DealInvestmentBackground]
AS
     SELECT DealInvestmentBackgroundID, 
            DealInvestmentBackgroundName, 
            createdDatetime, 
            ModifiedDateTime
     FROM tbl_DealInvestmentBackground;
